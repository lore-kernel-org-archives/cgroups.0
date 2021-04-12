From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/5] mm/memcg: Pass both memcg and lruvec to mod_memcg_lruvec_state()
Date: Mon, 12 Apr 2021 18:54:59 -0400
Message-ID: <20210412225503.15119-2-longman@redhat.com>
References: <20210412225503.15119-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618268131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=80OiZdRF0zG+/9/xLJu7PaNs7xvMkYou02sp8RHghi4=;
        b=bEYw5REF3No67N+0NW1erBC9vdem9NzzNiyO/1nmOXNifkwFboXqHRHIofgvSEQfX3XC/e
        viGlXksUX4xD7JOhNLR5HftXnbg+rz352jsQ30+N0MbRATI4cnsAYaNbBTsYIBF1NyMp+Z
        x+4p39wSf6dBcUVsiCQLBpzF8EOzB40=
In-Reply-To: <20210412225503.15119-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The caller of mod_memcg_lruvec_state() has both memcg and lruvec readily
available. So both of them are now passed to mod_memcg_lruvec_state()
and __mod_memcg_lruvec_state(). The __mod_memcg_lruvec_state() is
updated to allow either of the two parameters to be set to null. This
makes mod_memcg_lruvec_state() equivalent to mod_memcg_state() if lruvec
is null.

The new __mod_memcg_lruvec_state() function will be used in the next
patch as a replacement of mod_memcg_state() in mm/percpu.c for the
consolidation of the memory uncharge and vmstat update functions in
the kmem_cache_free() path.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h | 12 +++++++-----
 mm/memcontrol.c            | 19 +++++++++++++------
 mm/slab.h                  |  2 +-
 3 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0c04d39a7967..95f12996e66c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -955,8 +955,8 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	return x;
 }
 
-void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
-			      int val);
+void __mod_memcg_lruvec_state(struct mem_cgroup *memcg, struct lruvec *lruvec,
+			      enum node_stat_item idx, int val);
 void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
 
 static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
@@ -969,13 +969,14 @@ static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
 	local_irq_restore(flags);
 }
 
-static inline void mod_memcg_lruvec_state(struct lruvec *lruvec,
+static inline void mod_memcg_lruvec_state(struct mem_cgroup *memcg,
+					  struct lruvec *lruvec,
 					  enum node_stat_item idx, int val)
 {
 	unsigned long flags;
 
 	local_irq_save(flags);
-	__mod_memcg_lruvec_state(lruvec, idx, val);
+	__mod_memcg_lruvec_state(memcg, lruvec, idx, val);
 	local_irq_restore(flags);
 }
 
@@ -1369,7 +1370,8 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
-static inline void __mod_memcg_lruvec_state(struct lruvec *lruvec,
+static inline void __mod_memcg_lruvec_state(struct mem_cgroup *memcg,
+					    struct lruvec *lruvec,
 					    enum node_stat_item idx, int val)
 {
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e064ac0d850a..d66e1e38f8ac 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -799,20 +799,27 @@ parent_nodeinfo(struct mem_cgroup_per_node *pn, int nid)
 	return mem_cgroup_nodeinfo(parent, nid);
 }
 
-void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
-			      int val)
+/*
+ * Either one of memcg or lruvec can be NULL, but not both.
+ */
+void __mod_memcg_lruvec_state(struct mem_cgroup *memcg, struct lruvec *lruvec,
+			      enum node_stat_item idx, int val)
 {
 	struct mem_cgroup_per_node *pn;
-	struct mem_cgroup *memcg;
 	long x, threshold = MEMCG_CHARGE_BATCH;
 
+	/* Update lruvec */
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	memcg = pn->memcg;
+
+	if (!memcg)
+		memcg = pn->memcg;
 
 	/* Update memcg */
 	__mod_memcg_state(memcg, idx, val);
 
-	/* Update lruvec */
+	if (!lruvec)
+		return;
+
 	__this_cpu_add(pn->lruvec_stat_local->count[idx], val);
 
 	if (vmstat_item_in_bytes(idx))
@@ -848,7 +855,7 @@ void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 
 	/* Update memcg and lruvec */
 	if (!mem_cgroup_disabled())
-		__mod_memcg_lruvec_state(lruvec, idx, val);
+		__mod_memcg_lruvec_state(NULL, lruvec, idx, val);
 }
 
 void __mod_lruvec_page_state(struct page *page, enum node_stat_item idx,
diff --git a/mm/slab.h b/mm/slab.h
index 076582f58f68..bc6c7545e487 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -293,7 +293,7 @@ static inline void mod_objcg_state(struct obj_cgroup *objcg,
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	mod_memcg_lruvec_state(lruvec, idx, nr);
+	mod_memcg_lruvec_state(memcg, lruvec, idx, nr);
 	rcu_read_unlock();
 }
 
-- 
2.18.1

