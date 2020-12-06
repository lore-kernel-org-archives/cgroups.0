From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [RESEND PATCH v2 10/12] mm: memcontrol: scale stat_threshold for byted-sized vmstat
Date: Sun,  6 Dec 2020 18:14:49 +0800
Message-ID: <20201206101451.14706-11-songmuchun@bytedance.com>
References: <20201206101451.14706-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cL9BVbVQLgAGW6GpXAhL1X3CA8w9xPKU91tirmQZrTs=;
        b=0MtFDJWkKOQQMDcBAWzMx6gdC5YkqHBAIYhp+BQWqaLCRwKSjpNgXt0q+GE5YDnhq7
         zZlx16g/g5Hty2Kbo00woChd1R2HTbXvLREFGr+dgsJNg5wqsoVf732VjIl8t0tx/guG
         xKJjwyDtJ23mJ3u2LiGrZt8158SzBOEHqu1EONODMauwN44TsNCh+5mOLcjf6KWCRj+Q
         PpDhsHo4azjOMj55FDu9gE2qP5mrbjysGxlYeo4D7bHzSkfdcbJN0sB1YfNpHorDM+rk
         KTXv8MboLM+aP9XEdWHdigIwbkC+YMT4rLQKIz5VS8XacdkjzRDyPoEiVJiUVpjvTk70
         B/IQ==
In-Reply-To: <20201206101451.14706-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Some vmstat counters are being accounted in bytes not pages, so the
stat_threshold should also scale to bytes.

The vmstat counters are already long type for memcg (can reference
to struct lruvec_stat). For the global per-node vmstat counters
also can scale to long. But the maximum vmstat threshold is 125,
so the type of s32 is enough.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 include/linux/mmzone.h | 17 ++++++-----------
 include/linux/vmstat.h |  1 -
 mm/vmstat.c            | 24 +++++++++++++-----------
 3 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 1f9c83778629..d53328551225 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -216,17 +216,12 @@ enum node_stat_item {
  */
 static __always_inline bool vmstat_item_in_bytes(int idx)
 {
-	/*
-	 * Global and per-node slab counters track slab pages.
-	 * It's expected that changes are multiples of PAGE_SIZE.
-	 * Internally values are stored in pages.
-	 *
-	 * Per-memcg and per-lruvec counters track memory, consumed
-	 * by individual slab objects. These counters are actually
-	 * byte-precise.
-	 */
 	return (idx == NR_SLAB_RECLAIMABLE_B ||
-		idx == NR_SLAB_UNRECLAIMABLE_B);
+		idx == NR_SLAB_UNRECLAIMABLE_B ||
+#if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
+		idx == NR_KERNEL_SCS_B ||
+#endif
+		idx == NR_KERNEL_STACK_B);
 }
 
 /*
@@ -340,7 +335,7 @@ struct per_cpu_pageset {
 
 struct per_cpu_nodestat {
 	s8 stat_threshold;
-	s8 vm_node_stat_diff[NR_VM_NODE_STAT_ITEMS];
+	s32 vm_node_stat_diff[NR_VM_NODE_STAT_ITEMS];
 };
 
 #endif /* !__GENERATING_BOUNDS.H */
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index fd1a3d5d4926..afd84dc2398c 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -211,7 +211,6 @@ static inline unsigned long global_node_page_state(enum node_stat_item item)
 {
 	long x = atomic_long_read(&vm_node_stat[item]);
 
-	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 7fb0c7cb9516..25751b1d8e2e 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -341,13 +341,15 @@ void __mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
 				long delta)
 {
 	struct per_cpu_nodestat __percpu *pcp = pgdat->per_cpu_nodestats;
-	s8 __percpu *p = pcp->vm_node_stat_diff + item;
+	s32 __percpu *p = pcp->vm_node_stat_diff + item;
 	long x;
 	long t;
 
 	x = delta + __this_cpu_read(*p);
 
 	t = __this_cpu_read(pcp->stat_threshold);
+	if (vmstat_item_in_bytes(item))
+		t <<= PAGE_SHIFT;
 
 	if (unlikely(abs(x) > t)) {
 		node_page_state_add(x, pgdat, item);
@@ -399,15 +401,15 @@ void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
 void __inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
 {
 	struct per_cpu_nodestat __percpu *pcp = pgdat->per_cpu_nodestats;
-	s8 __percpu *p = pcp->vm_node_stat_diff + item;
-	s8 v, t;
+	s32 __percpu *p = pcp->vm_node_stat_diff + item;
+	s32 v, t;
 
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 
 	v = __this_cpu_inc_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v > t)) {
-		s8 overstep = t >> 1;
+		s32 overstep = t >> 1;
 
 		node_page_state_add(v + overstep, pgdat, item);
 		__this_cpu_write(*p, -overstep);
@@ -445,8 +447,8 @@ void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 void __dec_node_state(struct pglist_data *pgdat, enum node_stat_item item)
 {
 	struct per_cpu_nodestat __percpu *pcp = pgdat->per_cpu_nodestats;
-	s8 __percpu *p = pcp->vm_node_stat_diff + item;
-	s8 v, t;
+	s32 __percpu *p = pcp->vm_node_stat_diff + item;
+	s32 v, t;
 
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 
@@ -546,7 +548,7 @@ static inline void mod_node_state(struct pglist_data *pgdat,
        enum node_stat_item item, int delta, int overstep_mode)
 {
 	struct per_cpu_nodestat __percpu *pcp = pgdat->per_cpu_nodestats;
-	s8 __percpu *p = pcp->vm_node_stat_diff + item;
+	s32 __percpu *p = pcp->vm_node_stat_diff + item;
 	long o, n, t, z;
 
 	do {
@@ -563,6 +565,8 @@ static inline void mod_node_state(struct pglist_data *pgdat,
 		 * for all cpus in a node.
 		 */
 		t = this_cpu_read(pcp->stat_threshold);
+		if (vmstat_item_in_bytes(item))
+			t <<= PAGE_SHIFT;
 
 		o = this_cpu_read(*p);
 		n = delta + o;
@@ -829,7 +833,7 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
 		struct per_cpu_nodestat __percpu *p = pgdat->per_cpu_nodestats;
 
 		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
-			int v;
+			s32 v;
 
 			v = this_cpu_xchg(p->vm_node_stat_diff[i], 0);
 			if (v) {
@@ -899,7 +903,7 @@ void cpu_vm_stats_fold(int cpu)
 
 		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
 			if (p->vm_node_stat_diff[i]) {
-				int v;
+				s32 v;
 
 				v = p->vm_node_stat_diff[i];
 				p->vm_node_stat_diff[i] = 0;
@@ -1017,8 +1021,6 @@ unsigned long node_page_state(struct pglist_data *pgdat,
 {
 	long x = atomic_long_read(&pgdat->vm_stat[item]);
 
-	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
-
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
-- 
2.11.0

