From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mm/memcg: Disable task obj_stock for PREEMPT_RT
Date: Tue,  3 Aug 2021 13:55:19 -0400
Message-ID: <20210803175519.22298-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628013344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=TSdLbIa17Dn1sbXRatCyAZJSnstw1gwhMZIeM9izR74=;
        b=dObDnN88v7VkS6/uej3PMzBmEVht9Q6ox3jxUmfi6Tcdl+aU657qW7slqEfH4QXMfx6jQR
        PlcpOgRKFiPiTLCaoR/n7dtpaIRT/igG5POoSLFJtYAMs1eXOd7Fb87gSKLUZ7onBzMTnz
        EHHfJgXML+qIItjEw+3Q4O5PZMHDsnw=
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Luis Goncalves <lgoncalv-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

For PREEMPT_RT kernel, preempt_disable() and local_irq_save()
are typically converted to local_lock() and local_lock_irqsave()
respectively. These two variants of local_lock() are essentially
the same. Thus, there is no performance advantage in choosing one
over the other.

As there is no point in maintaining two different sets of obj_stock,
it is simpler and more efficient to just disable task_obj and use
only irq_obj for PREEMPT_RT. However, task_obj will still be there
in the memcg_stock_pcp structure even though it is not used in this
configuration.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 87c883227f90..4f80770cb97b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2120,12 +2120,22 @@ static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
  * which is cheap in non-preempt kernel. The interrupt context object stock
  * can only be accessed after disabling interrupt. User context code can
  * access interrupt object stock, but not vice versa.
+ *
+ * For PREEMPT_RT kernel, preempt_disable() and local_irq_save() may have
+ * to be changed to variants of local_lock(). This eliminates the
+ * performance advantage of using preempt_disable(). Fall back to always
+ * use local_irq_save() and use only irq_obj for simplicity.
  */
+static inline bool use_task_obj_stock(void)
+{
+	return !IS_ENABLED(CONFIG_PREEMPT_RT) && likely(in_task());
+}
+
 static inline struct obj_stock *get_obj_stock(unsigned long *pflags)
 {
 	struct memcg_stock_pcp *stock;
 
-	if (likely(in_task())) {
+	if (use_task_obj_stock()) {
 		*pflags = 0UL;
 		preempt_disable();
 		stock = this_cpu_ptr(&memcg_stock);
@@ -2139,7 +2149,7 @@ static inline struct obj_stock *get_obj_stock(unsigned long *pflags)
 
 static inline void put_obj_stock(unsigned long flags)
 {
-	if (likely(in_task()))
+	if (use_task_obj_stock())
 		preempt_enable();
 	else
 		local_irq_restore(flags);
@@ -2212,7 +2222,7 @@ static void drain_local_stock(struct work_struct *dummy)
 
 	stock = this_cpu_ptr(&memcg_stock);
 	drain_obj_stock(&stock->irq_obj);
-	if (in_task())
+	if (use_task_obj_stock())
 		drain_obj_stock(&stock->task_obj);
 	drain_stock(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
@@ -3217,7 +3227,7 @@ static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 {
 	struct mem_cgroup *memcg;
 
-	if (in_task() && stock->task_obj.cached_objcg) {
+	if (use_task_obj_stock() && stock->task_obj.cached_objcg) {
 		memcg = obj_cgroup_memcg(stock->task_obj.cached_objcg);
 		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
 			return true;
-- 
2.18.1

