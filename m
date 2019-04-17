From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH 5/5] mm: reparent slab memory on cgroup removal
Date: Wed, 17 Apr 2019 14:54:34 -0700
Message-ID: <20190417215434.25897-6-guro@fb.com>
References: <20190417215434.25897-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NUinwwoqQqqlnaj+hfWxAVvkl/hYr3H9Nu7bos7N4pE=;
        b=TnQkXWhriERaZfgxnd6oMoknEpldpZY4+ddqcjT9GjKwVe5mHq0dOSP71ukwgXypvq
         gzYvkoj5vWdSnXSRCCXCNagTc11B45enD9TrF5IxKI/NmjZLJcINdRJXe//lfyxQlxpA
         g1QIAY14d3wugoG2GI6i9vqpSBFgidozl3m/zEJH2ZbtqH1G7kNtgeATO01BFvh1iAug
         txs59zhsh/UB2k+oPSuUnLxiP6LHaLRttbMVvFmVYUbYIx18owHtFaviC8Mb2QvyP44e
         D/8viFGHj8Ezgc3m9xb9MnAOcO2tPQYTC2AC7tt88lJ76EfU3h1K7a0HOPPF2HSCG/n1
         td9Q==
In-Reply-To: <20190417215434.25897-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, david@fromorbit.com, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

Let's reparent memcg slab memory on memcg offlining. This allows us
to release the memory cgroup without waiting for the last outstanding
kernel object (e.g. dentry used by another application).

So instead of reparenting all accounted slab pages, let's do reparent
a relatively small amount of kmem_caches. Reparenting is performed as
the last part of the deactivation process, so it's guaranteed that all
kmem_caches are not active at this moment.

Since the parent cgroup is already charged, everything we need to do
is to move the kmem_cache to the parent's kmem_caches list,
swap the memcg pointer, bump parent's css refcounter and drop
the cgroup's refcounter. Quite simple.

We can't race with the slab allocation path, and if we race with
deallocation path, it's not a big deal: parent's charge and slab stats
are always correct*, and we don't care anymore about the child usage
and stats. The child cgroup is already offline, so we don't use or
show it anywhere.

* please, look at the comment in kmemcg_cache_deactivate_after_rcu()
  for some additional details

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 mm/memcontrol.c  |  4 +++-
 mm/slab.h        |  4 +++-
 mm/slab_common.c | 28 ++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 87c06e342e05..2f61d13df0c4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3239,7 +3239,6 @@ static void memcg_free_kmem(struct mem_cgroup *memcg)
 	if (memcg->kmem_state == KMEM_ALLOCATED) {
 		WARN_ON(!list_empty(&memcg->kmem_caches));
 		static_branch_dec(&memcg_kmem_enabled_key);
-		WARN_ON(page_counter_read(&memcg->kmem));
 	}
 }
 #else
@@ -4651,6 +4650,9 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 
 	/* The following stuff does not apply to the root */
 	if (!parent) {
+#ifdef CONFIG_MEMCG_KMEM
+		INIT_LIST_HEAD(&memcg->kmem_caches);
+#endif
 		root_mem_cgroup = memcg;
 		return &memcg->css;
 	}
diff --git a/mm/slab.h b/mm/slab.h
index 1f49945f5c1d..be4f04ef65f9 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -329,10 +329,12 @@ static __always_inline void memcg_uncharge_slab(struct page *page, int order,
 		return;
 	}
 
-	memcg = s->memcg_params.memcg;
+	rcu_read_lock();
+	memcg = READ_ONCE(s->memcg_params.memcg);
 	lruvec = mem_cgroup_lruvec(page_pgdat(page), memcg);
 	mod_lruvec_state(lruvec, idx, -(1 << order));
 	memcg_kmem_uncharge_memcg(page, order, memcg);
+	rcu_read_unlock();
 
 	kmemcg_cache_put_many(s, 1 << order);
 }
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 3fdd02979a1c..fc2e86de402f 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -745,7 +745,35 @@ void kmemcg_queue_cache_shutdown(struct kmem_cache *s)
 
 static void kmemcg_cache_deactivate_after_rcu(struct kmem_cache *s)
 {
+	struct mem_cgroup *memcg, *parent;
+
 	__kmemcg_cache_deactivate_after_rcu(s);
+
+	memcg = s->memcg_params.memcg;
+	parent = parent_mem_cgroup(memcg);
+	if (!parent)
+		parent = root_mem_cgroup;
+
+	if (memcg == parent)
+		return;
+
+	/*
+	 * Let's reparent the kmem_cache. It's already deactivated, so we
+	 * can't race with memcg_charge_slab(). We still can race with
+	 * memcg_uncharge_slab(), but it's not a problem. The parent cgroup
+	 * is already charged, so it's ok to uncharge either the parent cgroup
+	 * directly, either recursively.
+	 * The same is true for recursive vmstats. Local vmstats are not use
+	 * anywhere, except count_shadow_nodes(). But reparenting will not
+	 * cahnge anything for count_shadow_nodes(): on memcg removal
+	 * shrinker lists are reparented, so it always returns SHRINK_EMPTY
+	 * for non-leaf dead memcgs. For the parent memcgs local slab stats
+	 * are always 0 now, so reparenting will not change anything.
+	 */
+	list_move(&s->memcg_params.kmem_caches_node, &parent->kmem_caches);
+	s->memcg_params.memcg = parent;
+	css_get(&parent->css);
+	css_put(&memcg->css);
 }
 
 static void kmemcg_cache_deactivate(struct kmem_cache *s)
-- 
2.20.1

