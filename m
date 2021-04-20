From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH-next v5 2/4] mm/memcg: Cache vmstat data in percpu memcg_stock_pcp
Date: Tue, 20 Apr 2021 15:29:05 -0400
Message-ID: <20210420192907.30880-3-longman@redhat.com>
References: <20210420192907.30880-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618947020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=leP7ynLW/Ya0OWUxwJ+81qaZKo2i+UvXWl8PamMADZY=;
        b=PARmr/G8zSJA5gp6e6K8Vb146eBxiXC3OK0E5Gh6wPyYxwkGjfMc+VchhLp02atCGZNXlh
        tMNFuEEEGMywO4l/tnMKzugr5UiF9BnFTSCleDLVfPGTTyKoWEL3sckmZ7iZvrkmNxEYU6
        o3jYtqMMYy16Eigqc6dgRAN82b9VWNo=
In-Reply-To: <20210420192907.30880-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Before the new slab memory controller with per object byte charging,
charging and vmstat data update happen only when new slab pages are
allocated or freed. Now they are done with every kmem_cache_alloc()
and kmem_cache_free(). This causes additional overhead for workloads
that generate a lot of alloc and free calls.

The memcg_stock_pcp is used to cache byte charge for a specific
obj_cgroup to reduce that overhead. To further reducing it, this patch
makes the vmstat data cached in the memcg_stock_pcp structure as well
until it accumulates a page size worth of update or when other cached
data change. Caching the vmstat data in the per-cpu stock eliminates two
writes to non-hot cachelines for memcg specific as well as memcg-lruvecs
specific vmstat data by a write to a hot local stock cacheline.

On a 2-socket Cascade Lake server with instrumentation enabled and this
patch applied, it was found that about 20% (634400 out of 3243830)
of the time when mod_objcg_state() is called leads to an actual call
to __mod_objcg_state() after initial boot. When doing parallel kernel
build, the figure was about 17% (24329265 out of 142512465). So caching
the vmstat data reduces the number of calls to __mod_objcg_state()
by more than 80%.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 83 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7cd7187a017c..292b4783b1a7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -782,8 +782,9 @@ void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 	rcu_read_unlock();
 }
 
-void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
-		     enum node_stat_item idx, int nr)
+static inline void mod_objcg_mlstate(struct obj_cgroup *objcg,
+				     struct pglist_data *pgdat,
+				     enum node_stat_item idx, int nr)
 {
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
@@ -791,7 +792,7 @@ void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	mod_memcg_lruvec_state(lruvec, idx, nr);
+	__mod_memcg_lruvec_state(lruvec, idx, nr);
 	rcu_read_unlock();
 }
 
@@ -2059,7 +2060,10 @@ struct memcg_stock_pcp {
 
 #ifdef CONFIG_MEMCG_KMEM
 	struct obj_cgroup *cached_objcg;
+	struct pglist_data *cached_pgdat;
 	unsigned int nr_bytes;
+	int nr_slab_reclaimable_b;
+	int nr_slab_unreclaimable_b;
 #endif
 
 	struct work_struct work;
@@ -3008,6 +3012,63 @@ void __memcg_kmem_uncharge_page(struct page *page, int order)
 	obj_cgroup_put(objcg);
 }
 
+void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
+		     enum node_stat_item idx, int nr)
+{
+	struct memcg_stock_pcp *stock;
+	unsigned long flags;
+	int *bytes;
+
+	local_irq_save(flags);
+	stock = this_cpu_ptr(&memcg_stock);
+
+	/*
+	 * Save vmstat data in stock and skip vmstat array update unless
+	 * accumulating over a page of vmstat data or when pgdat or idx
+	 * changes.
+	 */
+	if (stock->cached_objcg != objcg) {
+		drain_obj_stock(stock);
+		obj_cgroup_get(objcg);
+		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
+				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
+		stock->cached_objcg = objcg;
+		stock->cached_pgdat = pgdat;
+	} else if (stock->cached_pgdat != pgdat) {
+		/* Flush the existing cached vmstat data */
+		if (stock->nr_slab_reclaimable_b) {
+			mod_objcg_mlstate(objcg, pgdat, NR_SLAB_RECLAIMABLE_B,
+					  stock->nr_slab_reclaimable_b);
+			stock->nr_slab_reclaimable_b = 0;
+		}
+		if (stock->nr_slab_unreclaimable_b) {
+			mod_objcg_mlstate(objcg, pgdat, NR_SLAB_UNRECLAIMABLE_B,
+					  stock->nr_slab_unreclaimable_b);
+			stock->nr_slab_unreclaimable_b = 0;
+		}
+		stock->cached_pgdat = pgdat;
+	}
+
+	bytes = (idx == NR_SLAB_RECLAIMABLE_B) ? &stock->nr_slab_reclaimable_b
+					       : &stock->nr_slab_unreclaimable_b;
+	if (!*bytes) {
+		*bytes = nr;
+		nr = 0;
+	} else {
+		*bytes += nr;
+		if (abs(*bytes) > PAGE_SIZE) {
+			nr = *bytes;
+			*bytes = 0;
+		} else {
+			nr = 0;
+		}
+	}
+	if (nr)
+		mod_objcg_mlstate(objcg, pgdat, idx, nr);
+
+	local_irq_restore(flags);
+}
+
 static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
 {
 	struct memcg_stock_pcp *stock;
@@ -3055,6 +3116,25 @@ static void drain_obj_stock(struct memcg_stock_pcp *stock)
 		stock->nr_bytes = 0;
 	}
 
+	/*
+	 * Flush the vmstat data in current stock
+	 */
+	if (stock->nr_slab_reclaimable_b || stock->nr_slab_unreclaimable_b) {
+		if (stock->nr_slab_reclaimable_b) {
+			mod_objcg_mlstate(old, stock->cached_pgdat,
+					  NR_SLAB_RECLAIMABLE_B,
+					  stock->nr_slab_reclaimable_b);
+			stock->nr_slab_reclaimable_b = 0;
+		}
+		if (stock->nr_slab_unreclaimable_b) {
+			mod_objcg_mlstate(old, stock->cached_pgdat,
+					  NR_SLAB_UNRECLAIMABLE_B,
+					  stock->nr_slab_unreclaimable_b);
+			stock->nr_slab_unreclaimable_b = 0;
+		}
+		stock->cached_pgdat = NULL;
+	}
+
 	obj_cgroup_put(old);
 	stock->cached_objcg = NULL;
 }
-- 
2.18.1

