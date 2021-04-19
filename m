From: Waiman Long <longman@redhat.com>
Subject: [PATCH v4 2/5] mm/memcg: Cache vmstat data in percpu memcg_stock_pcp
Date: Sun, 18 Apr 2021 20:00:29 -0400
Message-ID: <20210419000032.5432-3-longman@redhat.com>
References: <20210419000032.5432-1-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618790457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=jrHNa3qY0mDnQZ5jXhLj28hpfDWjX5kUgWYop2vZoe8=;
        b=Qu35lsaDKBH7+N+czRWl/3kICwClT1rGMaTiar3dQVHXRYrVhsJxFm/JAZEluE9hu5S8Y3
        jUUqFGvPYRvWXzTRlme/Sh6oNoPGodlxVsbhtY5Tg/UOksq5uG6c1y7k5USXIRHjoagjI/
        px1p7EPSXFzqVQywh4QwGtYs2no24g4=
In-Reply-To: <20210419000032.5432-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alex.shi@linux.alibaba.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, Masayoshi Mizuma <msys.mizuma@gmail.com>, Xing Zhengjun <zhengjun.xing@linux.intel.com>, Matthew Wilcox <willy@infradead.org>, Waiman Long <longman@redhat.com>

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

Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
---
 mm/memcontrol.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 61 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index dc9032f28f2e..693453f95d99 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2213,7 +2213,10 @@ struct memcg_stock_pcp {
 
 #ifdef CONFIG_MEMCG_KMEM
 	struct obj_cgroup *cached_objcg;
+	struct pglist_data *cached_pgdat;
 	unsigned int nr_bytes;
+	int vmstat_idx;
+	int vmstat_bytes;
 #endif
 
 	struct work_struct work;
@@ -3150,8 +3153,9 @@ void __memcg_kmem_uncharge_page(struct page *page, int order)
 	css_put(&memcg->css);
 }
 
-void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
-		     enum node_stat_item idx, int nr)
+static inline void __mod_objcg_state(struct obj_cgroup *objcg,
+				     struct pglist_data *pgdat,
+				     enum node_stat_item idx, int nr)
 {
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec = NULL;
@@ -3159,10 +3163,53 @@ void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	mod_memcg_lruvec_state(lruvec, idx, nr);
+	__mod_memcg_lruvec_state(lruvec, idx, nr);
 	rcu_read_unlock();
 }
 
+void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
+		     enum node_stat_item idx, int nr)
+{
+	struct memcg_stock_pcp *stock;
+	unsigned long flags;
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
+		/* Output the current data as is */
+	} else if (!stock->vmstat_bytes) {
+		/* Save the current data */
+		stock->vmstat_bytes = nr;
+		stock->vmstat_idx = idx;
+		stock->cached_pgdat = pgdat;
+		nr = 0;
+	} else if ((stock->cached_pgdat != pgdat) ||
+		   (stock->vmstat_idx != idx)) {
+		/* Output the cached data & save the current data */
+		swap(nr, stock->vmstat_bytes);
+		swap(idx, stock->vmstat_idx);
+		swap(pgdat, stock->cached_pgdat);
+	} else {
+		stock->vmstat_bytes += nr;
+		if (abs(stock->vmstat_bytes) > PAGE_SIZE) {
+			nr = stock->vmstat_bytes;
+			stock->vmstat_bytes = 0;
+		} else {
+			nr = 0;
+		}
+	}
+	if (nr)
+		__mod_objcg_state(objcg, pgdat, idx, nr);
+
+	local_irq_restore(flags);
+}
+
 static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
 {
 	struct memcg_stock_pcp *stock;
@@ -3213,6 +3260,17 @@ static void drain_obj_stock(struct memcg_stock_pcp *stock)
 		stock->nr_bytes = 0;
 	}
 
+	/*
+	 * Flush the vmstat data in current stock
+	 */
+	if (stock->vmstat_bytes) {
+		__mod_objcg_state(old, stock->cached_pgdat, stock->vmstat_idx,
+				  stock->vmstat_bytes);
+		stock->cached_pgdat = NULL;
+		stock->vmstat_bytes = 0;
+		stock->vmstat_idx = 0;
+	}
+
 	obj_cgroup_put(old);
 	stock->cached_objcg = NULL;
 }
-- 
2.18.1

