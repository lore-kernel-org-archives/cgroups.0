From: Roman Gushchin <guro@fb.com>
Subject: [PATCH v2 6/6] mm: reparent slab memory on cgroup removal
Date: Tue, 23 Apr 2019 14:31:33 -0700
Message-ID: <20190423213133.3551969-7-guro@fb.com>
References: <20190423213133.3551969-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=VEdpMvj5kP5nuI6Ztt7mzIbqR1F5iJNOXyr/8yu0PUA=;
 b=DfRDcwz9GNFsTOvKcjdYUIClLw2lmbenktFncRuI/FTa8XUZ6VyjEodtAqNCMQl29Bhy
 1DALn7surcj2kJNETxq0jo4Hn5+pQ8NquZhMWHyKLNswPeUbmqeulLzItHee2hTbDMAc
 zeVPjI2V9zlLEp1iFsjjb8L51n0Wi8QqcKY= 
In-Reply-To: <20190423213133.3551969-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

Let's reparent memcg slab memory on memcg offlining. This allows us
to release the memory cgroup without waiting for the last outstanding
kernel object (e.g. dentry used by another application).

So instead of reparenting all accounted slab pages, let's do reparent
a relatively small amount of kmem_caches. Reparenting is performed as
a part of the deactivation process.

Since the parent cgroup is already charged, everything we need to do
is to splice the list of kmem_caches to the parent's kmem_caches list,
swap the memcg pointer and drop the css refcounter for each kmem_cache
and adjust the parent's css refcounter. Quite simple.

Please, note that kmem_cache->memcg_params.memcg isn't a stable
pointer anymore. It's safe to read it under rcu_read_lock() or
with slab_mutex held.

We can race with the slab allocation and deallocation paths. It's not
a big problem: parent's charge and slab global stats are always
correct, and we don't care anymore about the child usage and global
stats. The child cgroup is already offline, so we don't use or show it
anywhere.

Local slab stats (NR_SLAB_RECLAIMABLE and NR_SLAB_UNRECLAIMABLE)
aren't used anywhere except count_shadow_nodes(). But even there it
won't break anything: after reparenting "nodes" will be 0 on child
level (because we're already reparenting shrinker lists), and on
parent level page stats always were 0, and this patch won't change
anything.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 include/linux/slab.h |  4 ++--
 mm/memcontrol.c      | 14 ++++++++------
 mm/slab.h            | 14 +++++++++-----
 mm/slab_common.c     | 23 ++++++++++++++++++++---
 4 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 1b54e5f83342..109cab2ad9b4 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -152,7 +152,7 @@ void kmem_cache_destroy(struct kmem_cache *);
 int kmem_cache_shrink(struct kmem_cache *);
 
 void memcg_create_kmem_cache(struct mem_cgroup *, struct kmem_cache *);
-void memcg_deactivate_kmem_caches(struct mem_cgroup *);
+void memcg_deactivate_kmem_caches(struct mem_cgroup *, struct mem_cgroup *);
 
 /*
  * Please use this macro to create slab caches. Simply specify the
@@ -638,7 +638,7 @@ struct memcg_cache_params {
 			bool dying;
 		};
 		struct {
-			struct mem_cgroup *memcg;
+			struct mem_cgroup __rcu *memcg;
 			struct list_head children_node;
 			struct list_head kmem_caches_node;
 			struct percpu_ref refcnt;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c9896105d8d5..27ae253922da 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3201,15 +3201,15 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
 	 */
 	memcg->kmem_state = KMEM_ALLOCATED;
 
-	memcg_deactivate_kmem_caches(memcg);
-
-	kmemcg_id = memcg->kmemcg_id;
-	BUG_ON(kmemcg_id < 0);
-
 	parent = parent_mem_cgroup(memcg);
 	if (!parent)
 		parent = root_mem_cgroup;
 
+	memcg_deactivate_kmem_caches(memcg, parent);
+
+	kmemcg_id = memcg->kmemcg_id;
+	BUG_ON(kmemcg_id < 0);
+
 	/*
 	 * Change kmemcg_id of this cgroup and all its descendants to the
 	 * parent's id, and then move all entries from this cgroup's list_lrus
@@ -3242,7 +3242,6 @@ static void memcg_free_kmem(struct mem_cgroup *memcg)
 	if (memcg->kmem_state == KMEM_ALLOCATED) {
 		WARN_ON(!list_empty(&memcg->kmem_caches));
 		static_branch_dec(&memcg_kmem_enabled_key);
-		WARN_ON(page_counter_read(&memcg->kmem));
 	}
 }
 #else
@@ -4654,6 +4653,9 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 
 	/* The following stuff does not apply to the root */
 	if (!parent) {
+#ifdef CONFIG_MEMCG_KMEM
+		INIT_LIST_HEAD(&memcg->kmem_caches);
+#endif
 		root_mem_cgroup = memcg;
 		return &memcg->css;
 	}
diff --git a/mm/slab.h b/mm/slab.h
index 61110b3035e7..68c5fc6e557e 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -289,10 +289,11 @@ static __always_inline int memcg_charge_slab(struct page *page,
 	struct lruvec *lruvec;
 	int ret;
 
-	memcg = s->memcg_params.memcg;
+	rcu_read_lock();
+	memcg = rcu_dereference(s->memcg_params.memcg);
 	ret = memcg_kmem_charge_memcg(page, gfp, order, memcg);
 	if (ret)
-		return ret;
+		goto out;
 
 	lruvec = mem_cgroup_lruvec(page_pgdat(page), memcg);
 	mod_lruvec_state(lruvec, cache_vmstat_idx(s), 1 << order);
@@ -300,8 +301,9 @@ static __always_inline int memcg_charge_slab(struct page *page,
 	/* transer try_charge() page references to kmem_cache */
 	percpu_ref_get_many(&s->memcg_params.refcnt, 1 << order);
 	css_put_many(&memcg->css, 1 << order);
-
-	return 0;
+out:
+	rcu_read_unlock();
+	return ret;
 }
 
 static __always_inline void memcg_uncharge_slab(struct page *page, int order,
@@ -310,10 +312,12 @@ static __always_inline void memcg_uncharge_slab(struct page *page, int order,
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 
-	memcg = s->memcg_params.memcg;
+	rcu_read_lock();
+	memcg = rcu_dereference(s->memcg_params.memcg);
 	lruvec = mem_cgroup_lruvec(page_pgdat(page), memcg);
 	mod_lruvec_state(lruvec, cache_vmstat_idx(s), -(1 << order));
 	memcg_kmem_uncharge_memcg(page, order, memcg);
+	rcu_read_unlock();
 
 	percpu_ref_put_many(&s->memcg_params.refcnt, 1 << order);
 }
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 995920222127..36673a43ed31 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -236,7 +236,7 @@ void memcg_link_cache(struct kmem_cache *s, struct mem_cgroup *memcg)
 		list_add(&s->root_caches_node, &slab_root_caches);
 	} else {
 		css_get(&memcg->css);
-		s->memcg_params.memcg = memcg;
+		rcu_assign_pointer(s->memcg_params.memcg, memcg);
 		list_add(&s->memcg_params.children_node,
 			 &s->memcg_params.root_cache->memcg_params.children);
 		list_add(&s->memcg_params.kmem_caches_node,
@@ -251,7 +251,8 @@ static void memcg_unlink_cache(struct kmem_cache *s)
 	} else {
 		list_del(&s->memcg_params.children_node);
 		list_del(&s->memcg_params.kmem_caches_node);
-		css_put(&s->memcg_params.memcg->css);
+		mem_cgroup_put(rcu_dereference_protected(s->memcg_params.memcg,
+			lockdep_is_held(&slab_mutex)));
 	}
 }
 #else
@@ -772,11 +773,13 @@ static void kmemcg_cache_deactivate(struct kmem_cache *s)
 	call_rcu(&s->memcg_params.rcu_head, kmemcg_schedule_work_after_rcu);
 }
 
-void memcg_deactivate_kmem_caches(struct mem_cgroup *memcg)
+void memcg_deactivate_kmem_caches(struct mem_cgroup *memcg,
+				  struct mem_cgroup *parent)
 {
 	int idx;
 	struct memcg_cache_array *arr;
 	struct kmem_cache *s, *c;
+	unsigned int nr_reparented;
 
 	idx = memcg_cache_id(memcg);
 
@@ -794,6 +797,20 @@ void memcg_deactivate_kmem_caches(struct mem_cgroup *memcg)
 		kmemcg_cache_deactivate(c);
 		arr->entries[idx] = NULL;
 	}
+	if (memcg != parent) {
+		nr_reparented = 0;
+		list_for_each_entry(s, &memcg->kmem_caches,
+				    memcg_params.kmem_caches_node) {
+			rcu_assign_pointer(s->memcg_params.memcg, parent);
+			css_put(&memcg->css);
+			nr_reparented++;
+		}
+		if (nr_reparented) {
+			list_splice_init(&memcg->kmem_caches,
+					 &parent->kmem_caches);
+			css_get_many(&parent->css, nr_reparented);
+		}
+	}
 	mutex_unlock(&slab_mutex);
 
 	put_online_mems();
-- 
2.20.1

