From: Michal Hocko <mhocko@suse.cz>
Subject: [PATCH for 3.2] memcg: do not trap chargers with full callstack on
 OOM
Date: Fri, 7 Jun 2013 15:11:57 +0200
Message-ID: <20130607131157.GF8117@dhcp22.suse.cz>
References: <20130208152402.GD7557@dhcp22.suse.cz>
 <20130208165805.8908B143@pobox.sk>
 <20130208171012.GH7557@dhcp22.suse.cz>
 <20130208220243.EDEE0825@pobox.sk>
 <20130210150310.GA9504@dhcp22.suse.cz>
 <20130210174619.24F20488@pobox.sk>
 <20130211112240.GC19922@dhcp22.suse.cz>
 <20130222092332.4001E4B6@pobox.sk>
 <20130606160446.GE24115@dhcp22.suse.cz>
 <20130606181633.BCC3E02E@pobox.sk>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20130606181633.BCC3E02E@pobox.sk>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups mailinglist <cgroups@vger.kernel.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>

On Thu 06-06-13 18:16:33, azurIt wrote:
> Hello Michal,
> 
> nice to read you! :) Yes, i'm still on 3.2. Could you be so kind and
> try to backport it? Thank you very much!

Here we go. I hope I didn't screw anything (Johannes might double check)
because there were quite some changes in the area since 3.2. Nothing
earth shattering though. Please note that I have only compile tested
this. Also make sure you remove the previous patches you have from me.
---
From 9d2801c1f53147ca9134cc5f76ab28d505a37a54 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Fri, 7 Jun 2013 13:52:42 +0200
Subject: [PATCH] memcg: do not trap chargers with full callstack on OOM

The memcg OOM handling is incredibly fragile and can deadlock.  When a
task fails to charge memory, it invokes the OOM killer and loops right
there in the charge code until it succeeds.  Comparably, any other
task that enters the charge path at this point will go to a waitqueue
right then and there and sleep until the OOM situation is resolved.
The problem is that these tasks may hold filesystem locks and the
mmap_sem; locks that the selected OOM victim may need to exit.

For example, in one reported case, the task invoking the OOM killer
was about to charge a page cache page during a write(), which holds
the i_mutex.  The OOM killer selected a task that was just entering
truncate() and trying to acquire the i_mutex:

OOM invoking task:
[<ffffffff8110a9c1>] mem_cgroup_handle_oom+0x241/0x3b0
[<ffffffff8110b5ab>] T.1146+0x5ab/0x5c0
[<ffffffff8110c22e>] mem_cgroup_cache_charge+0xbe/0xe0
[<ffffffff810ca28c>] add_to_page_cache_locked+0x4c/0x140
[<ffffffff810ca3a2>] add_to_page_cache_lru+0x22/0x50
[<ffffffff810ca45b>] grab_cache_page_write_begin+0x8b/0xe0
[<ffffffff81193a18>] ext3_write_begin+0x88/0x270
[<ffffffff810c8fc6>] generic_file_buffered_write+0x116/0x290
[<ffffffff810cb3cc>] __generic_file_aio_write+0x27c/0x480
[<ffffffff810cb646>] generic_file_aio_write+0x76/0xf0           # takes ->i_mutex
[<ffffffff8111156a>] do_sync_write+0xea/0x130
[<ffffffff81112183>] vfs_write+0xf3/0x1f0
[<ffffffff81112381>] sys_write+0x51/0x90
[<ffffffff815b5926>] system_call_fastpath+0x18/0x1d
[<ffffffffffffffff>] 0xffffffffffffffff

OOM kill victim:
[<ffffffff811109b8>] do_truncate+0x58/0xa0              # takes i_mutex
[<ffffffff81121c90>] do_last+0x250/0xa30
[<ffffffff81122547>] path_openat+0xd7/0x440
[<ffffffff811229c9>] do_filp_open+0x49/0xa0
[<ffffffff8110f7d6>] do_sys_open+0x106/0x240
[<ffffffff8110f950>] sys_open+0x20/0x30
[<ffffffff815b5926>] system_call_fastpath+0x18/0x1d
[<ffffffffffffffff>] 0xffffffffffffffff

The OOM handling task will retry the charge indefinitely while the OOM
killed task is not releasing any resources.

A similar scenario can happen when the kernel OOM killer for a memcg
is disabled and a userspace task is in charge of resolving OOM
situations.  In this case, ALL tasks that enter the OOM path will be
made to sleep on the OOM waitqueue and wait for userspace to free
resources or increase the group's limit.  But a userspace OOM handler
is prone to deadlock itself on the locks held by the waiting tasks.
For example one of the sleeping tasks may be stuck in a brk() call
with the mmap_sem held for writing but the userspace handler, in order
to pick an optimal victim, may need to read files from /proc/<pid>,
which tries to acquire the same mmap_sem for reading and deadlocks.

This patch changes the way tasks behave after detecting an OOM and
makes sure nobody loops or sleeps on OOM with locks held:

1. When OOMing in a system call (buffered IO and friends), invoke the
   OOM killer but just return -ENOMEM, never sleep on a OOM waitqueue.
   Userspace should be able to handle this and it prevents anybody
   from looping or waiting with locks held.

2. When OOMing in a page fault, invoke the OOM killer and restart the
   fault instead of looping on the charge attempt.  This way, the OOM
   victim can not get stuck on locks the looping task may hold.

3. When detecting an OOM in a page fault but somebody else is handling
   it (either the kernel OOM killer or a userspace handler), don't go
   to sleep in the charge context.  Instead, remember the OOMing memcg
   in the task struct and then fully unwind the page fault stack with
   -ENOMEM.  pagefault_out_of_memory() will then call back into the
   memcg code to check if the -ENOMEM came from the memcg, and then
   either put the task to sleep on the memcg's OOM waitqueue or just
   restart the fault.  The OOM victim can no longer get stuck on any
   lock a sleeping task may hold.

While reworking the OOM routine, also remove a needless OOM waitqueue
wakeup when invoking the killer.  Only uncharges and limit increases,
things that actually change the memory situation, should do wakeups.

Reported-by: Reported-by: azurIt <azurit@pobox.sk>
Debugged-by: Michal Hocko <mhocko@suse.cz>
Reported-by: David Rientjes <rientjes@google.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/memcontrol.h |   22 +++++++
 include/linux/mm.h         |    1 +
 include/linux/sched.h      |    6 ++
 mm/ksm.c                   |    2 +-
 mm/memcontrol.c            |  149 ++++++++++++++++++++++++++++----------------
 mm/memory.c                |   40 ++++++++----
 mm/oom_kill.c              |    2 +
 7 files changed, 156 insertions(+), 66 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b87068a..56bfc39 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -120,6 +120,15 @@ mem_cgroup_get_reclaim_stat_from_page(struct page *page);
 extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
 					struct task_struct *p);
 
+static inline void mem_cgroup_set_userfault(struct task_struct *p)
+{
+	p->memcg_oom.in_userfault = 1;
+}
+static inline void mem_cgroup_clear_userfault(struct task_struct *p)
+{
+	p->memcg_oom.in_userfault = 0;
+}
+bool mem_cgroup_oom_synchronize(void);
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
 #endif
@@ -333,6 +342,19 @@ mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 {
 }
 
+static inline void mem_cgroup_set_userfault(struct task_struct *p)
+{
+}
+
+static inline void mem_cgroup_clear_userfault(struct task_struct *p)
+{
+}
+
+static inline bool mem_cgroup_oom_synchronize(void)
+{
+	return false;
+}
+
 static inline void mem_cgroup_inc_page_stat(struct page *page,
 					    enum mem_cgroup_page_stat_item idx)
 {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4baadd1..91380ef 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -156,6 +156,7 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_ALLOW_RETRY	0x08	/* Retry fault if blocking */
 #define FAULT_FLAG_RETRY_NOWAIT	0x10	/* Don't drop mmap_sem and wait when retrying */
 #define FAULT_FLAG_KILLABLE	0x20	/* The fault task is in SIGKILL killable region */
+#define FAULT_FLAG_KERNEL	0x80	/* kernel-triggered fault (get_user_pages etc.) */
 
 /*
  * This interface is used by x86 PAT code to identify a pfn mapping that is
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1c4f3e9..d521a70 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1568,6 +1568,12 @@ struct task_struct {
 		unsigned long nr_pages;	/* uncharged usage */
 		unsigned long memsw_nr_pages; /* uncharged mem+swap usage */
 	} memcg_batch;
+	struct memcg_oom_info {
+		unsigned int in_userfault:1;
+		unsigned int in_memcg_oom:1;
+		int wakeups;
+		struct mem_cgroup *wait_on_memcg;
+	} memcg_oom;
 #endif
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 	atomic_t ptrace_bp_refcnt;
diff --git a/mm/ksm.c b/mm/ksm.c
index 310544a..3295a3b 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -338,7 +338,7 @@ static int break_ksm(struct vm_area_struct *vma, unsigned long addr)
 			break;
 		if (PageKsm(page))
 			ret = handle_mm_fault(vma->vm_mm, vma, addr,
-							FAULT_FLAG_WRITE);
+					FAULT_FLAG_KERNEL | FAULT_FLAG_WRITE);
 		else
 			ret = VM_FAULT_WRITE;
 		put_page(page);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b63f5f7..67189b4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -249,6 +249,7 @@ struct mem_cgroup {
 
 	bool		oom_lock;
 	atomic_t	under_oom;
+	atomic_t	oom_wakeups;
 
 	atomic_t	refcnt;
 
@@ -1846,6 +1847,7 @@ static int memcg_oom_wake_function(wait_queue_t *wait,
 
 static void memcg_wakeup_oom(struct mem_cgroup *memcg)
 {
+	atomic_inc(&memcg->oom_wakeups);
 	/* for filtering, pass "memcg" as argument. */
 	__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
 }
@@ -1857,55 +1859,109 @@ static void memcg_oom_recover(struct mem_cgroup *memcg)
 }
 
 /*
- * try to call OOM killer. returns false if we should exit memory-reclaim loop.
+ * try to call OOM killer
  */
-bool mem_cgroup_handle_oom(struct mem_cgroup *memcg, gfp_t mask)
+static void mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask)
 {
-	struct oom_wait_info owait;
-	bool locked, need_to_kill;
-
-	owait.mem = memcg;
-	owait.wait.flags = 0;
-	owait.wait.func = memcg_oom_wake_function;
-	owait.wait.private = current;
-	INIT_LIST_HEAD(&owait.wait.task_list);
-	need_to_kill = true;
-	mem_cgroup_mark_under_oom(memcg);
+	bool locked, need_to_kill = true;
 
 	/* At first, try to OOM lock hierarchy under memcg.*/
 	spin_lock(&memcg_oom_lock);
 	locked = mem_cgroup_oom_lock(memcg);
-	/*
-	 * Even if signal_pending(), we can't quit charge() loop without
-	 * accounting. So, UNINTERRUPTIBLE is appropriate. But SIGKILL
-	 * under OOM is always welcomed, use TASK_KILLABLE here.
-	 */
-	prepare_to_wait(&memcg_oom_waitq, &owait.wait, TASK_KILLABLE);
 	if (!locked || memcg->oom_kill_disable)
 		need_to_kill = false;
 	if (locked)
 		mem_cgroup_oom_notify(memcg);
 	spin_unlock(&memcg_oom_lock);
 
-	if (need_to_kill) {
-		finish_wait(&memcg_oom_waitq, &owait.wait);
-		mem_cgroup_out_of_memory(memcg, mask);
-	} else {
-		schedule();
-		finish_wait(&memcg_oom_waitq, &owait.wait);
+	/*
+	 * A system call can just return -ENOMEM, but if this is a
+	 * page fault and somebody else is handling the OOM already,
+	 * we need to sleep on the OOM waitqueue for this memcg until
+	 * the situation is resolved.  Which can take some time
+	 * because it might be handled by a userspace task.
+	 *
+	 * However, this is the charge context, which means that we
+	 * may sit on a large call stack and hold various filesystem
+	 * locks, the mmap_sem etc. and we don't want the OOM handler
+	 * to deadlock on them while we sit here and wait.  Store the
+	 * current OOM context in the task_struct, then return
+	 * -ENOMEM.  At the end of the page fault handler, with the
+	 * stack unwound, pagefault_out_of_memory() will check back
+	 * with us by calling mem_cgroup_oom_synchronize(), possibly
+	 * putting the task to sleep.
+	 */
+	if (current->memcg_oom.in_userfault) {
+		current->memcg_oom.in_memcg_oom = 1;
+		/*
+		 * Somebody else is handling the situation.  Make sure
+		 * no wakeups are missed between now and going to
+		 * sleep at the end of the page fault.
+		 */
+		if (!need_to_kill) {
+			mem_cgroup_mark_under_oom(memcg);
+			current->memcg_oom.wakeups =
+				atomic_read(&memcg->oom_wakeups);
+			css_get(&memcg->css);
+			current->memcg_oom.wait_on_memcg = memcg;
+		}
 	}
-	spin_lock(&memcg_oom_lock);
-	if (locked)
+
+	if (need_to_kill)
+		mem_cgroup_out_of_memory(memcg, mask);
+
+	if (locked) {
+		spin_lock(&memcg_oom_lock);
 		mem_cgroup_oom_unlock(memcg);
-	memcg_wakeup_oom(memcg);
-	spin_unlock(&memcg_oom_lock);
+		/*
+		 * Sleeping tasks might have been killed, make sure
+		 * they get scheduled so they can exit.
+		 */
+		if (need_to_kill)
+			memcg_oom_recover(memcg);
+		spin_unlock(&memcg_oom_lock);
+	}
+}
 
-	mem_cgroup_unmark_under_oom(memcg);
+bool mem_cgroup_oom_synchronize(void)
+{
+	struct oom_wait_info owait;
+	struct mem_cgroup *memcg;
 
-	if (test_thread_flag(TIF_MEMDIE) || fatal_signal_pending(current))
+	/* OOM is global, do not handle */
+	if (!current->memcg_oom.in_memcg_oom)
 		return false;
-	/* Give chance to dying process */
-	schedule_timeout_uninterruptible(1);
+
+	/*
+	 * We invoked the OOM killer but there is a chance that a kill
+	 * did not free up any charges.  Everybody else might already
+	 * be sleeping, so restart the fault and keep the rampage
+	 * going until some charges are released.
+	 */
+	memcg = current->memcg_oom.wait_on_memcg;
+	if (!memcg)
+		goto out;
+
+	if (test_thread_flag(TIF_MEMDIE) || fatal_signal_pending(current))
+		goto out_put;
+
+	owait.mem = memcg;
+	owait.wait.flags = 0;
+	owait.wait.func = memcg_oom_wake_function;
+	owait.wait.private = current;
+	INIT_LIST_HEAD(&owait.wait.task_list);
+
+	prepare_to_wait(&memcg_oom_waitq, &owait.wait, TASK_KILLABLE);
+	/* Only sleep if we didn't miss any wakeups since OOM */
+	if (atomic_read(&memcg->oom_wakeups) == current->memcg_oom.wakeups)
+		schedule();
+	finish_wait(&memcg_oom_waitq, &owait.wait);
+out_put:
+	mem_cgroup_unmark_under_oom(memcg);
+	css_put(&memcg->css);
+	current->memcg_oom.wait_on_memcg = NULL;
+out:
+	current->memcg_oom.in_memcg_oom = 0;
 	return true;
 }
 
@@ -2195,11 +2251,10 @@ enum {
 	CHARGE_RETRY,		/* need to retry but retry is not bad */
 	CHARGE_NOMEM,		/* we can't do more. return -ENOMEM */
 	CHARGE_WOULDBLOCK,	/* GFP_WAIT wasn't set and no enough res. */
-	CHARGE_OOM_DIE,		/* the current is killed because of OOM */
 };
 
 static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
-				unsigned int nr_pages, bool oom_check)
+				unsigned int nr_pages, bool invoke_oom)
 {
 	unsigned long csize = nr_pages * PAGE_SIZE;
 	struct mem_cgroup *mem_over_limit;
@@ -2257,14 +2312,10 @@ static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (mem_cgroup_wait_acct_move(mem_over_limit))
 		return CHARGE_RETRY;
 
-	/* If we don't need to call oom-killer at el, return immediately */
-	if (!oom_check)
-		return CHARGE_NOMEM;
-	/* check OOM */
-	if (!mem_cgroup_handle_oom(mem_over_limit, gfp_mask))
-		return CHARGE_OOM_DIE;
+	if (invoke_oom)
+		mem_cgroup_oom(mem_over_limit, gfp_mask);
 
-	return CHARGE_RETRY;
+	return CHARGE_NOMEM;
 }
 
 /*
@@ -2349,7 +2400,7 @@ again:
 	}
 
 	do {
-		bool oom_check;
+		bool invoke_oom = oom && !nr_oom_retries;
 
 		/* If killed, bypass charge */
 		if (fatal_signal_pending(current)) {
@@ -2357,13 +2408,7 @@ again:
 			goto bypass;
 		}
 
-		oom_check = false;
-		if (oom && !nr_oom_retries) {
-			oom_check = true;
-			nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
-		}
-
-		ret = mem_cgroup_do_charge(memcg, gfp_mask, batch, oom_check);
+		ret = mem_cgroup_do_charge(memcg, gfp_mask, batch, invoke_oom);
 		switch (ret) {
 		case CHARGE_OK:
 			break;
@@ -2376,16 +2421,12 @@ again:
 			css_put(&memcg->css);
 			goto nomem;
 		case CHARGE_NOMEM: /* OOM routine works */
-			if (!oom) {
+			if (!oom || invoke_oom) {
 				css_put(&memcg->css);
 				goto nomem;
 			}
-			/* If oom, we never return -ENOMEM */
 			nr_oom_retries--;
 			break;
-		case CHARGE_OOM_DIE: /* Killed by OOM Killer */
-			css_put(&memcg->css);
-			goto bypass;
 		}
 	} while (ret != CHARGE_OK);
 
diff --git a/mm/memory.c b/mm/memory.c
index 829d437..bee177c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1720,7 +1720,7 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 			cond_resched();
 			while (!(page = follow_page(vma, start, foll_flags))) {
 				int ret;
-				unsigned int fault_flags = 0;
+				unsigned int fault_flags = FAULT_FLAG_KERNEL;
 
 				/* For mlock, just skip the stack guard page. */
 				if (foll_flags & FOLL_MLOCK) {
@@ -1842,6 +1842,7 @@ int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
 	if (!vma || address < vma->vm_start)
 		return -EFAULT;
 
+	fault_flags |= FAULT_FLAG_KERNEL;
 	ret = handle_mm_fault(mm, vma, address, fault_flags);
 	if (ret & VM_FAULT_ERROR) {
 		if (ret & VM_FAULT_OOM)
@@ -3439,22 +3440,14 @@ unlock:
 /*
  * By the time we get here, we already hold the mm semaphore
  */
-int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
-		unsigned long address, unsigned int flags)
+static int __handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
+			     unsigned long address, unsigned int flags)
 {
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 
-	__set_current_state(TASK_RUNNING);
-
-	count_vm_event(PGFAULT);
-	mem_cgroup_count_vm_event(mm, PGFAULT);
-
-	/* do counter updates before entering really critical section. */
-	check_sync_rss_stat(current);
-
 	if (unlikely(is_vm_hugetlb_page(vma)))
 		return hugetlb_fault(mm, vma, address, flags);
 
@@ -3503,6 +3496,31 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	return handle_pte_fault(mm, vma, address, pte, pmd, flags);
 }
 
+int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
+		    unsigned long address, unsigned int flags)
+{
+	int in_userfault = !(flags & FAULT_FLAG_KERNEL);
+	int ret;
+
+	__set_current_state(TASK_RUNNING);
+
+	count_vm_event(PGFAULT);
+	mem_cgroup_count_vm_event(mm, PGFAULT);
+
+	/* do counter updates before entering really critical section. */
+	check_sync_rss_stat(current);
+
+	if (in_userfault)
+		mem_cgroup_set_userfault(current);
+
+	ret = __handle_mm_fault(mm, vma, address, flags);
+
+	if (in_userfault)
+		mem_cgroup_clear_userfault(current);
+
+	return ret;
+}
+
 #ifndef __PAGETABLE_PUD_FOLDED
 /*
  * Allocate page upper directory.
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 069b64e..aa60863 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -785,6 +785,8 @@ out:
  */
 void pagefault_out_of_memory(void)
 {
+	if (mem_cgroup_oom_synchronize())
+		return;
 	if (try_set_system_oom()) {
 		out_of_memory(NULL, 0, 0, NULL);
 		clear_system_oom();
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
