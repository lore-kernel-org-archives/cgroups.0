From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 2/2] mm: memcontrol: fix missed end-writeback page
 accounting
Date: Thu, 23 Oct 2014 09:54:12 -0400
Message-ID: <20141023135412.GA24269@phnom.home.cmpxchg.org>
References: <1414002568-21042-1-git-send-email-hannes@cmpxchg.org>
 <1414002568-21042-3-git-send-email-hannes@cmpxchg.org>
 <20141022133936.44f2d2931948ce13477b5e64@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20141022133936.44f2d2931948ce13477b5e64@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 01:39:36PM -0700, Andrew Morton wrote:
> On Wed, 22 Oct 2014 14:29:28 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API") changed page
> > migration to uncharge the old page right away.  The page is locked,
> > unmapped, truncated, and off the LRU, but it could race with writeback
> > ending, which then doesn't unaccount the page properly:
> > 
> > test_clear_page_writeback()              migration
> >   acquire pc->mem_cgroup->move_lock
> >                                            wait_on_page_writeback()
> >   TestClearPageWriteback()
> >                                            mem_cgroup_migrate()
> >                                              clear PCG_USED
> >   if (PageCgroupUsed(pc))
> >     decrease memcg pages under writeback
> >   release pc->mem_cgroup->move_lock
> > 
> > The per-page statistics interface is heavily optimized to avoid a
> > function call and a lookup_page_cgroup() in the file unmap fast path,
> > which means it doesn't verify whether a page is still charged before
> > clearing PageWriteback() and it has to do it in the stat update later.
> > 
> > Rework it so that it looks up the page's memcg once at the beginning
> > of the transaction and then uses it throughout.  The charge will be
> > verified before clearing PageWriteback() and migration can't uncharge
> > the page as long as that is still set.  The RCU lock will protect the
> > memcg past uncharge.
> > 
> > As far as losing the optimization goes, the following test results are
> > from a microbenchmark that maps, faults, and unmaps a 4GB sparse file
> > three times in a nested fashion, so that there are two negative passes
> > that don't account but still go through the new transaction overhead.
> > There is no actual difference:
> > 
> > old:     33.195102545 seconds time elapsed       ( +-  0.01% )
> > new:     33.199231369 seconds time elapsed       ( +-  0.03% )
> > 
> > The time spent in page_remove_rmap()'s callees still adds up to the
> > same, but the time spent in the function itself seems reduced:
> > 
> >     # Children      Self  Command        Shared Object       Symbol
> > old:     0.12%     0.11%  filemapstress  [kernel.kallsyms]   [k] page_remove_rmap
> > new:     0.12%     0.08%  filemapstress  [kernel.kallsyms]   [k] page_remove_rmap
> > 
> > ...
> >
> > @@ -2132,26 +2126,32 @@ cleanup:
> >   * account and taking the move_lock in the slowpath.
> >   */
> >  
> > -void __mem_cgroup_begin_update_page_stat(struct page *page,
> > -				bool *locked, unsigned long *flags)
> > +struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page,
> > +					      bool *locked,
> > +					      unsigned long *flags)
> 
> It would be useful to document the args here (especially `locked'). 
> Also the new rcu_read_locking protocol is worth a mention: that it
> exists, what it does, why it persists as long as it does.

Okay, I added full kernel docs that explain the RCU fast path, the
memcg->move_lock slow path, and the lifetime guarantee of RCU in cases
where the page state that is about to change is the only thing pinning
the charge, like in end-writeback.

---

From 1808b8e2114a7d3cc6a0a52be2fe568ff6e1457e Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Thu, 23 Oct 2014 09:12:01 -0400
Subject: [patch] mm: memcontrol: fix missed end-writeback page accounting fix

Add kernel-doc to page state accounting functions.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 51 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 16 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 024177df7aae..ae9b630e928b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2109,21 +2109,31 @@ cleanup:
 	return true;
 }
 
-/*
- * Used to update mapped file or writeback or other statistics.
+/**
+ * mem_cgroup_begin_page_stat - begin a page state statistics transaction
+ * @page: page that is going to change accounted state
+ * @locked: &memcg->move_lock slowpath was taken
+ * @flags: IRQ-state flags for &memcg->move_lock
  *
- * Notes: Race condition
+ * This function must mark the beginning of an accounted page state
+ * change to prevent double accounting when the page is concurrently
+ * being moved to another memcg:
  *
- * Charging occurs during page instantiation, while the page is
- * unmapped and locked in page migration, or while the page table is
- * locked in THP migration.  No race is possible.
+ *   memcg = mem_cgroup_begin_page_stat(page, &locked, &flags);
+ *   if (TestClearPageState(page))
+ *     mem_cgroup_update_page_stat(memcg, state, -1);
+ *   mem_cgroup_end_page_stat(memcg, locked, flags);
  *
- * Uncharge happens to pages with zero references, no race possible.
+ * The RCU lock is held throughout the transaction.  The fast path can
+ * get away without acquiring the memcg->move_lock (@locked is false)
+ * because page moving starts with an RCU grace period.
  *
- * Charge moving between groups is protected by checking mm->moving
- * account and taking the move_lock in the slowpath.
+ * The RCU lock also protects the memcg from being freed when the page
+ * state that is going to change is the only thing preventing the page
+ * from being uncharged.  E.g. end-writeback clearing PageWriteback(),
+ * which allows migration to go ahead and uncharge the page before the
+ * account transaction might be complete.
  */
-
 struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page,
 					      bool *locked,
 					      unsigned long *flags)
@@ -2141,12 +2151,7 @@ again:
 	memcg = pc->mem_cgroup;
 	if (unlikely(!memcg))
 		return NULL;
-	/*
-	 * If this memory cgroup is not under account moving, we don't
-	 * need to take move_lock_mem_cgroup(). Because we already hold
-	 * rcu_read_lock(), any calls to move_account will be delayed until
-	 * rcu_read_unlock().
-	 */
+
 	*locked = false;
 	if (atomic_read(&memcg->moving_account) <= 0)
 		return memcg;
@@ -2161,6 +2166,12 @@ again:
 	return memcg;
 }
 
+/**
+ * mem_cgroup_end_page_stat - finish a page state statistics transaction
+ * @memcg: the memcg that was accounted against
+ * @locked: value received from mem_cgroup_begin_page_stat()
+ * @flags: value received from mem_cgroup_begin_page_stat()
+ */
 void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool locked,
 			      unsigned long flags)
 {
@@ -2170,6 +2181,14 @@ void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool locked,
 	rcu_read_unlock();
 }
 
+/**
+ * mem_cgroup_update_page_stat - update page state statistics
+ * @memcg: memcg to account against
+ * @idx: page state item to account
+ * @val: number of pages (positive or negative)
+ *
+ * See mem_cgroup_begin_page_stat() for locking requirements.
+ */
 void mem_cgroup_update_page_stat(struct mem_cgroup *memcg,
 				 enum mem_cgroup_stat_index idx, int val)
 {
-- 
2.1.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
