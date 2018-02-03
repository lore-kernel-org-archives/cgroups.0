From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] mm: memcontrol: fix NR_WRITEBACK leak in memcg and system stats
Date: Sat,  3 Feb 2018 03:23:53 -0500
Message-ID: <20180203082353.17284-1-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0fj33TOfzMUtHqh1NUGvS8TM6vjD1hxQNboc8hD7BXM=; b=mMdfdtrixTzpZzsXgm2rkbTLY5
	FVjauMyjX2NCkP89KfaLhcClx29P98cmif0DpjU4crtTdYHDqxtEhPYSMcl/EOGqvQaAHn2lngtcA
	OUYFPE/3VNEKHjrcCY6zgrN4tlj0EsiYWkRdUtfWGy9wKMVBlZJ+DF8gswZ8RBR4OBJc=;
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

After the ("a983b5ebee57 mm: memcontrol: fix excessive complexity in
memory.stat reporting"), we observed slowly upward creeping
NR_WRITEBACK counts over the course of several days, both the
per-memcg stats as well as the system counter in e.g. /proc/meminfo.

The conversion from full per-cpu stat counts to per-cpu cached atomic
stat counts introduced an irq-unsafe RMW operation into the updates.

Most stat updates come from process context, but one notable exception
is the NR_WRITEBACK counter. While writebacks are issued from process
context, they are retired from (soft)irq context.

When writeback completions interrupt the RMW counter updates of new
writebacks being issued, the decs from the completions are lost.

Since the global updates are routed through the joint lruvec API, both
the memcg counters as well as the system counters are affected.

This patch makes the joint stat and event API irq safe.

Fixes: a983b5ebee57 ("mm: memcontrol: fix excessive complexity in memory.stat reporting")
Debugged-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/memcontrol.h | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 882046863581..c46016bb25eb 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -523,9 +523,11 @@ static inline void __mod_memcg_state(struct mem_cgroup *memcg,
 static inline void mod_memcg_state(struct mem_cgroup *memcg,
 				   int idx, int val)
 {
-	preempt_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	__mod_memcg_state(memcg, idx, val);
-	preempt_enable();
+	local_irq_restore(flags);
 }
 
 /**
@@ -606,9 +608,11 @@ static inline void __mod_lruvec_state(struct lruvec *lruvec,
 static inline void mod_lruvec_state(struct lruvec *lruvec,
 				    enum node_stat_item idx, int val)
 {
-	preempt_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	__mod_lruvec_state(lruvec, idx, val);
-	preempt_enable();
+	local_irq_restore(flags);
 }
 
 static inline void __mod_lruvec_page_state(struct page *page,
@@ -630,9 +634,11 @@ static inline void __mod_lruvec_page_state(struct page *page,
 static inline void mod_lruvec_page_state(struct page *page,
 					 enum node_stat_item idx, int val)
 {
-	preempt_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	__mod_lruvec_page_state(page, idx, val);
-	preempt_enable();
+	local_irq_restore(flags);
 }
 
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
@@ -659,9 +665,11 @@ static inline void __count_memcg_events(struct mem_cgroup *memcg,
 static inline void count_memcg_events(struct mem_cgroup *memcg,
 				      int idx, unsigned long count)
 {
-	preempt_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	__count_memcg_events(memcg, idx, count);
-	preempt_enable();
+	local_irq_restore(flags);
 }
 
 /* idx can be of type enum memcg_event_item or vm_event_item */
-- 
2.16.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
