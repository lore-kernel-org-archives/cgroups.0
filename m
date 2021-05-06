From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 1/4] mm/memcg: Move mod_objcg_state() to memcontrol.c
Date: Thu,  6 May 2021 11:00:04 -0400
Message-ID: <20210506150007.16288-2-longman@redhat.com>
References: <20210506150007.16288-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620313234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=rAzysh01QjfQCEGQGXMMcqOakHS2FuQ08mGtFy8nzuI=;
        b=L/JJ5apkjUZ6XJ41c2UJKX14qvOXltcG8wU4De/lmgYh788T7J2z7HUCBEtIlPy30Bushu
        sG3L5aNztsFXX0oUDiHLvHTxfbPhRa0I3K/49SyMKR4863c4imU9NswwRr3FfJq1uzz4m6
        FSeJPGx3b2JWAxnc+G0EVAqKxT6Hd8I=
In-Reply-To: <20210506150007.16288-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The mod_objcg_state() function is moved from mm/slab.h to mm/memcontrol.c
so that further optimization can be done to it in later patches without
exposing unnecessary details to other mm components.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
---
 mm/memcontrol.c | 13 +++++++++++++
 mm/slab.h       | 16 ++--------------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c100265dc393..859f872b482e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -906,6 +906,19 @@ void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 	rcu_read_unlock();
 }
 
+void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
+		     enum node_stat_item idx, int nr)
+{
+	struct mem_cgroup *memcg;
+	struct lruvec *lruvec;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	mod_memcg_lruvec_state(lruvec, idx, nr);
+	rcu_read_unlock();
+}
+
 /**
  * __count_memcg_events - account VM events in a cgroup
  * @memcg: the memory cgroup
diff --git a/mm/slab.h b/mm/slab.h
index 18c1927cd196..dcf964737d7e 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -239,6 +239,8 @@ static inline bool kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t fla
 #ifdef CONFIG_MEMCG_KMEM
 int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
 				 gfp_t gfp, bool new_page);
+void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
+		     enum node_stat_item idx, int nr);
 
 static inline void memcg_free_page_obj_cgroups(struct page *page)
 {
@@ -283,20 +285,6 @@ static inline bool memcg_slab_pre_alloc_hook(struct kmem_cache *s,
 	return true;
 }
 
-static inline void mod_objcg_state(struct obj_cgroup *objcg,
-				   struct pglist_data *pgdat,
-				   enum node_stat_item idx, int nr)
-{
-	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
-
-	rcu_read_lock();
-	memcg = obj_cgroup_memcg(objcg);
-	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	mod_memcg_lruvec_state(lruvec, idx, nr);
-	rcu_read_unlock();
-}
-
 static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
 					      struct obj_cgroup *objcg,
 					      gfp_t flags, size_t size,
-- 
2.18.1

