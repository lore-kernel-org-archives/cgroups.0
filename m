From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/5] mm/memcg: Introduce obj_cgroup_uncharge_mod_state()
Date: Mon, 12 Apr 2021 18:55:00 -0400
Message-ID: <20210412225503.15119-3-longman@redhat.com>
References: <20210412225503.15119-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618268130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=6q8PwfMd38t+lXEGfKmsTXF5u9dPLNsn54ZL71OOV5A=;
        b=Mah+M6Hl+p7tJ8ev6GjCZYaFzeuzw1gU3R/MXmgnT5IMsBtTKTXtsmtbwwZ1qi+k4kvAP7
        sXV5yHXt5choXGaL427OCP5KhRVnWryFauydUWOZ7fDqkQpP+JzAElkfWI+wEQDFl2huR0
        owWxLQbp3AtxCt+q8UJwD+5griWCVzs=
In-Reply-To: <20210412225503.15119-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

In memcg_slab_free_hook()/pcpu_memcg_free_hook(), obj_cgroup_uncharge()
is followed by mod_objcg_state()/mod_memcg_state(). Each of these
function call goes through a separate irq_save/irq_restore cycle. That
is inefficient.  Introduce a new function obj_cgroup_uncharge_mod_state()
that combines them with a single irq_save/irq_restore cycle.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
---
 include/linux/memcontrol.h |  2 ++
 mm/memcontrol.c            | 31 +++++++++++++++++++++++++++----
 mm/percpu.c                |  9 ++-------
 mm/slab.h                  |  6 +++---
 4 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 95f12996e66c..6890f999c1a3 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1592,6 +1592,8 @@ struct obj_cgroup *get_obj_cgroup_from_current(void);
 
 int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size);
 void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size);
+void obj_cgroup_uncharge_mod_state(struct obj_cgroup *objcg, size_t size,
+				   struct pglist_data *pgdat, int idx);
 
 extern struct static_key_false memcg_kmem_enabled_key;
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d66e1e38f8ac..b19100c68aa0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3225,12 +3225,9 @@ static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 	return false;
 }
 
-static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
+static void __refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
 {
 	struct memcg_stock_pcp *stock;
-	unsigned long flags;
-
-	local_irq_save(flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
 	if (stock->cached_objcg != objcg) { /* reset if necessary */
@@ -3243,7 +3240,14 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
 
 	if (stock->nr_bytes > PAGE_SIZE)
 		drain_obj_stock(stock);
+}
+
+static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
+{
+	unsigned long flags;
 
+	local_irq_save(flags);
+	__refill_obj_stock(objcg, nr_bytes);
 	local_irq_restore(flags);
 }
 
@@ -3292,6 +3296,25 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
 	refill_obj_stock(objcg, size);
 }
 
+void obj_cgroup_uncharge_mod_state(struct obj_cgroup *objcg, size_t size,
+				   struct pglist_data *pgdat, int idx)
+{
+	unsigned long flags;
+	struct mem_cgroup *memcg;
+	struct lruvec *lruvec = NULL;
+
+	local_irq_save(flags);
+	__refill_obj_stock(objcg, size);
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	if (pgdat)
+		lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	__mod_memcg_lruvec_state(memcg, lruvec, idx, -(int)size);
+	rcu_read_unlock();
+	local_irq_restore(flags);
+}
+
 #endif /* CONFIG_MEMCG_KMEM */
 
 /*
diff --git a/mm/percpu.c b/mm/percpu.c
index 23308113a5ff..fd7aad6d7f90 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1631,13 +1631,8 @@ static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 	objcg = chunk->obj_cgroups[off >> PCPU_MIN_ALLOC_SHIFT];
 	chunk->obj_cgroups[off >> PCPU_MIN_ALLOC_SHIFT] = NULL;
 
-	obj_cgroup_uncharge(objcg, size * num_possible_cpus());
-
-	rcu_read_lock();
-	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-			-(size * num_possible_cpus()));
-	rcu_read_unlock();
-
+	obj_cgroup_uncharge_mod_state(objcg, size * num_possible_cpus(),
+				      NULL, MEMCG_PERCPU_B);
 	obj_cgroup_put(objcg);
 }
 
diff --git a/mm/slab.h b/mm/slab.h
index bc6c7545e487..677cdc52e641 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -366,9 +366,9 @@ static inline void memcg_slab_free_hook(struct kmem_cache *s_orig,
 			continue;
 
 		objcgs[off] = NULL;
-		obj_cgroup_uncharge(objcg, obj_full_size(s));
-		mod_objcg_state(objcg, page_pgdat(page), cache_vmstat_idx(s),
-				-obj_full_size(s));
+		obj_cgroup_uncharge_mod_state(objcg, obj_full_size(s),
+					      page_pgdat(page),
+					      cache_vmstat_idx(s));
 		obj_cgroup_put(objcg);
 	}
 }
-- 
2.18.1

