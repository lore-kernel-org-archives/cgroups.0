From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 5/5] mm/memcg: Optimize user context object stock access
Date: Tue, 13 Apr 2021 21:20:27 -0400
Message-ID: <20210414012027.5352-6-longman@redhat.com>
References: <20210414012027.5352-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618363262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=9b3gCujTxyIs9Ukl1F3LKtTmo7zHMudOK70IqdY3ho4=;
        b=i+9E9oMhiIjVu3peyikNA22oqiLNyVQ9IBsgclvd8MorAnkxW60LzUtTDcdVCjF9mR38rz
        QEDEgvHcfedBzwKEzISVi1gWlb21xnRINGKxqGKJX1XPD5WvFZgHeayW9KjrhgAPH6TQYM
        LHL3ewkxVOwkA471y96+udIQRHbZwns=
In-Reply-To: <20210414012027.5352-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Most kmem_cache_alloc() calls are from user context. With instrumentation
enabled, the measured amount of kmem_cache_alloc() calls from non-task
context was about 0.01% of the total.

The irq disable/enable sequence used in this case to access content
from object stock is slow.  To optimize for user context access, there
are now two object stocks for task context and interrupt context access
respectively.

The task context object stock can be accessed after disabling preemption
which is cheap in non-preempt kernel. The interrupt context object stock
can only be accessed after disabling interrupt. User context code can
access interrupt object stock, but not vice versa.

The mod_objcg_state() function is also modified to make sure that memcg
and lruvec stat updates are done with interrupted disabled.

The downside of this change is that there are more data stored in local
object stocks and not reflected in the charge counter and the vmstat
arrays.  However, this is a small price to pay for better performance.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 74 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 59 insertions(+), 15 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 69f728383efe..8875e896e52b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2229,7 +2229,8 @@ struct obj_stock {
 struct memcg_stock_pcp {
 	struct mem_cgroup *cached; /* this never be root cgroup */
 	unsigned int nr_pages;
-	struct obj_stock obj;
+	struct obj_stock task_obj;
+	struct obj_stock irq_obj;
 
 	struct work_struct work;
 	unsigned long flags;
@@ -2254,11 +2255,48 @@ static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 }
 #endif
 
+/*
+ * Most kmem_cache_alloc() calls are from user context. The irq disable/enable
+ * sequence used in this case to access content from object stock is slow.
+ * To optimize for user context access, there are now two object stocks for
+ * task context and interrupt context access respectively.
+ *
+ * The task context object stock can be accessed by disabling preemption only
+ * which is cheap in non-preempt kernel. The interrupt context object stock
+ * can only be accessed after disabling interrupt. User context code can
+ * access interrupt object stock, but not vice versa.
+ */
 static inline struct obj_stock *current_obj_stock(void)
 {
 	struct memcg_stock_pcp *stock = this_cpu_ptr(&memcg_stock);
 
-	return &stock->obj;
+	return in_task() ? &stock->task_obj : &stock->irq_obj;
+}
+
+#define get_obj_stock(flags)				\
+({							\
+	struct memcg_stock_pcp *stock;			\
+	struct obj_stock *obj_stock;			\
+							\
+	if (in_task()) {				\
+		preempt_disable();			\
+		(flags) = -1L;				\
+		stock = this_cpu_ptr(&memcg_stock);	\
+		obj_stock = &stock->task_obj;		\
+	} else {					\
+		local_irq_save(flags);			\
+		stock = this_cpu_ptr(&memcg_stock);	\
+		obj_stock = &stock->irq_obj;		\
+	}						\
+	obj_stock;					\
+})
+
+static inline void put_obj_stock(unsigned long flags)
+{
+	if (flags == -1L)
+		preempt_enable();
+	else
+		local_irq_restore(flags);
 }
 
 /**
@@ -2327,7 +2365,9 @@ static void drain_local_stock(struct work_struct *dummy)
 	local_irq_save(flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
-	drain_obj_stock(&stock->obj);
+	drain_obj_stock(&stock->irq_obj);
+	if (in_task())
+		drain_obj_stock(&stock->task_obj);
 	drain_stock(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 
@@ -3183,7 +3223,7 @@ static inline void mod_objcg_state(struct obj_cgroup *objcg,
 	memcg = obj_cgroup_memcg(objcg);
 	if (pgdat)
 		lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	__mod_memcg_lruvec_state(memcg, lruvec, idx, nr);
+	mod_memcg_lruvec_state(memcg, lruvec, idx, nr);
 	rcu_read_unlock();
 }
 
@@ -3193,15 +3233,14 @@ static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
 	unsigned long flags;
 	bool ret = false;
 
-	local_irq_save(flags);
+	stock = get_obj_stock(flags);
 
-	stock = current_obj_stock();
 	if (objcg == stock->cached_objcg && stock->nr_bytes >= nr_bytes) {
 		stock->nr_bytes -= nr_bytes;
 		ret = true;
 	}
 
-	local_irq_restore(flags);
+	put_obj_stock(flags);
 
 	return ret;
 }
@@ -3254,8 +3293,13 @@ static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 {
 	struct mem_cgroup *memcg;
 
-	if (stock->obj.cached_objcg) {
-		memcg = obj_cgroup_memcg(stock->obj.cached_objcg);
+	if (in_task() && stock->task_obj.cached_objcg) {
+		memcg = obj_cgroup_memcg(stock->task_obj.cached_objcg);
+		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
+			return true;
+	}
+	if (stock->irq_obj.cached_objcg) {
+		memcg = obj_cgroup_memcg(stock->irq_obj.cached_objcg);
 		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
 			return true;
 	}
@@ -3283,9 +3327,9 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
 {
 	unsigned long flags;
 
-	local_irq_save(flags);
+	get_obj_stock(flags);
 	__refill_obj_stock(objcg, nr_bytes);
-	local_irq_restore(flags);
+	put_obj_stock(flags);
 }
 
 static void __mod_obj_stock_state(struct obj_cgroup *objcg,
@@ -3325,9 +3369,9 @@ void mod_obj_stock_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
 {
 	unsigned long flags;
 
-	local_irq_save(flags);
+	get_obj_stock(flags);
 	__mod_obj_stock_state(objcg, pgdat, idx, nr);
-	local_irq_restore(flags);
+	put_obj_stock(flags);
 }
 
 int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
@@ -3380,10 +3424,10 @@ void obj_cgroup_uncharge_mod_state(struct obj_cgroup *objcg, size_t size,
 {
 	unsigned long flags;
 
-	local_irq_save(flags);
+	get_obj_stock(flags);
 	__refill_obj_stock(objcg, size);
 	__mod_obj_stock_state(objcg, pgdat, idx, -(int)size);
-	local_irq_restore(flags);
+	put_obj_stock(flags);
 }
 
 #endif /* CONFIG_MEMCG_KMEM */
-- 
2.18.1

