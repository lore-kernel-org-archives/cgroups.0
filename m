From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] memcg: relocate charge moving from ->attach to
 ->post_attach
Date: Thu, 21 Apr 2016 19:09:02 -0400
Message-ID: <20160421230902.GJ4775@htj.duckdns.org>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160414175055.GA6794@cmpxchg.org>
 <20160415191719.GK12583@htj.duckdns.org>
 <20160417120747.GC21757@dhcp22.suse.cz>
 <20160421230648.GI4775@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7OpwfoiQGkS/MnYU0RMvO0z/r7v9u160ZpjMJsPCU64=;
        b=DbGaPucDm7QMiJrl2pTL08cdx9AX9foPnBSZf33TmUQT+2bbMkPfdXyE3XHI0TRcnh
         JS4coMGf+/KEqU/G6mqryCWbo7SwVBs/tEXTcXz7gg6YWNUTyUa/qdD4aMxFfYDd/N3O
         Ta+bF/RRjAMxvhL2dmAVQ67Bh+Rgja0Uxh3wJi/vWqaTP2bQClwrf36hMEW60asakrP7
         4SSYCMCUWjctpe2J6PipJ9kRDBydPBTdgUcMpR4s2HZVbG1odWkpUnMpVTFTe9epr8El
         vM4OFMrEl+jUbuDiId+J4IVDM3lP2BAWzXe074xyUE0xYbyb6WQztM2MqNCR+mBvcODa
         dNOw==
Content-Disposition: inline
In-Reply-To: <20160421230648.GI4775-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

So, this ended up a lot simpler than I originally expected.  I tested
it lightly and it seems to work fine.  Petr, can you please test these
two patches w/o the lru drain drop patch and see whether the problem
is gone?

Thanks.
------ 8< ------
If charge moving is used, memcg performs relabeling of the affected
pages from its ->attach callback which is called under both
cgroup_threadgroup_rwsem and thus can't create new kthreads.  This is
fragile as various operations may depend on workqueues making forward
progress which relies on the ability to create new kthreads.

There's no reason to perform charge moving from ->attach which is deep
in the task migration path.  Move it to ->post_attach which is called
after the actual migration is finished and cgroup_threadgroup_rwsem is
dropped.

* move_charge_struct->mm is added and ->can_attach is now responsible
  for pinning and recording the target mm.  mem_cgroup_clear_mc() is
  updated accordingly.  This also simplifies mem_cgroup_move_task().

* mem_cgroup_move_task() is now called from ->post_attach instead of
  ->attach.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Debugged-by: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Reported-by: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Reported-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Fixes: 1ed1328792ff ("sched, cgroup: replace signal_struct->group_rwsem with a global percpu_rwsem")
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 4.4+
---
 mm/memcontrol.c |   37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -207,6 +207,7 @@ static void mem_cgroup_oom_notify(struct
 /* "mc" and its members are protected by cgroup_mutex */
 static struct move_charge_struct {
 	spinlock_t	  lock; /* for from, to */
+	struct mm_struct  *mm;
 	struct mem_cgroup *from;
 	struct mem_cgroup *to;
 	unsigned long flags;
@@ -4667,6 +4668,8 @@ static void __mem_cgroup_clear_mc(void)
 
 static void mem_cgroup_clear_mc(void)
 {
+	struct mm_struct *mm = mc.mm;
+
 	/*
 	 * we must clear moving_task before waking up waiters at the end of
 	 * task migration.
@@ -4676,7 +4679,10 @@ static void mem_cgroup_clear_mc(void)
 	spin_lock(&mc.lock);
 	mc.from = NULL;
 	mc.to = NULL;
+	mc.mm = NULL;
 	spin_unlock(&mc.lock);
+
+	mmput(mm);
 }
 
 static int mem_cgroup_can_attach(struct cgroup_taskset *tset)
@@ -4733,6 +4739,7 @@ static int mem_cgroup_can_attach(struct
 		VM_BUG_ON(mc.moved_swap);
 
 		spin_lock(&mc.lock);
+		mc.mm = mm;
 		mc.from = from;
 		mc.to = memcg;
 		mc.flags = move_flags;
@@ -4742,8 +4749,9 @@ static int mem_cgroup_can_attach(struct
 		ret = mem_cgroup_precharge_mc(mm);
 		if (ret)
 			mem_cgroup_clear_mc();
+	} else {
+		mmput(mm);
 	}
-	mmput(mm);
 	return ret;
 }
 
@@ -4852,11 +4860,11 @@ put:			/* get_mctgt_type() gets the page
 	return ret;
 }
 
-static void mem_cgroup_move_charge(struct mm_struct *mm)
+static void mem_cgroup_move_charge(void)
 {
 	struct mm_walk mem_cgroup_move_charge_walk = {
 		.pmd_entry = mem_cgroup_move_charge_pte_range,
-		.mm = mm,
+		.mm = mc.mm,
 	};
 
 	lru_add_drain_all();
@@ -4868,7 +4876,7 @@ static void mem_cgroup_move_charge(struc
 	atomic_inc(&mc.from->moving_account);
 	synchronize_rcu();
 retry:
-	if (unlikely(!down_read_trylock(&mm->mmap_sem))) {
+	if (unlikely(!down_read_trylock(&mc.mm->mmap_sem))) {
 		/*
 		 * Someone who are holding the mmap_sem might be waiting in
 		 * waitq. So we cancel all extra charges, wake up all waiters,
@@ -4885,23 +4893,16 @@ retry:
 	 * additional charge, the page walk just aborts.
 	 */
 	walk_page_range(0, ~0UL, &mem_cgroup_move_charge_walk);
-	up_read(&mm->mmap_sem);
+	up_read(&mc.mm->mmap_sem);
 	atomic_dec(&mc.from->moving_account);
 }
 
-static void mem_cgroup_move_task(struct cgroup_taskset *tset)
+static void mem_cgroup_move_task(void)
 {
-	struct cgroup_subsys_state *css;
-	struct task_struct *p = cgroup_taskset_first(tset, &css);
-	struct mm_struct *mm = get_task_mm(p);
-
-	if (mm) {
-		if (mc.to)
-			mem_cgroup_move_charge(mm);
-		mmput(mm);
-	}
-	if (mc.to)
+	if (mc.to) {
+		mem_cgroup_move_charge();
 		mem_cgroup_clear_mc();
+	}
 }
 #else	/* !CONFIG_MMU */
 static int mem_cgroup_can_attach(struct cgroup_taskset *tset)
@@ -4911,7 +4912,7 @@ static int mem_cgroup_can_attach(struct
 static void mem_cgroup_cancel_attach(struct cgroup_taskset *tset)
 {
 }
-static void mem_cgroup_move_task(struct cgroup_taskset *tset)
+static void mem_cgroup_move_task(void)
 {
 }
 #endif
@@ -5195,7 +5196,7 @@ struct cgroup_subsys memory_cgrp_subsys
 	.css_reset = mem_cgroup_css_reset,
 	.can_attach = mem_cgroup_can_attach,
 	.cancel_attach = mem_cgroup_cancel_attach,
-	.attach = mem_cgroup_move_task,
+	.post_attach = mem_cgroup_move_task,
 	.bind = mem_cgroup_bind,
 	.dfl_cftypes = memory_files,
 	.legacy_cftypes = mem_cgroup_legacy_files,
