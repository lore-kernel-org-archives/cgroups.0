From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: LTP test suite triggers LOCKDEP_CIRCULAR on linux-next
Date: Fri, 14 Jan 2022 10:00:08 -0800
Message-ID: <YeG6KN9HW4uCF7fj@carbon.dhcp.thefacebook.com>
References: <87mtjzslv7.fsf@oc8242746057.ibm.com>
 <YeGjcF6CU/R6cyec@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=WLORcTTPKSa0P+gucxjXrpFHDo3xCpKJtCROdVQHIJs=;
 b=OkcWO7SNkcoKX4DFiHYOZlc8ln2VZ71MS/FblNPrd1HFflCB6CIJhFpjg5UGHS15VhEo
 0EbtWDVAl9MViLPorWenwO2ilVapM+J/xw65lvJrJ1ffvEqYa7tNg/c/frmcZLMKslz4
 GthF5M2tWz7zOzfsnsCMG457SB30sFuJZKk= 
Content-Disposition: inline
In-Reply-To: <YeGjcF6CU/R6cyec-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alexander Egorenkov <egorenar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jan 14, 2022 at 06:23:12AM -1000, Tejun Heo wrote:
> Roman, does this ring a bell?

Hm, interesting... Alexander, thanks for the report!

I think I know where the problem is and have a couple of ideas on how to tackle
it:
1) use a dedicated spinlock instead of css_lock to sync objcg lists,
2) push obj_cgroup_release()'s code to a work context.

Let me think a bit what's better and I'll come up with a patch.

Thanks!

> 
> On Thu, Jan 13, 2022 at 04:20:44PM +0100, Alexander Egorenkov wrote:
> > 
> > Hi,
> > 
> > our daily CI linux-next test reported the following finding on s390x arch:
> > 
> > 	 LOCKDEP_CIRCULAR (suite: ltp, case: mtest06 (mmap1))
> > 		 WARNING: possible circular locking dependency detected
> > 		 5.17.0-20220113.rc0.git0.f2211f194038.300.fc35.s390x+debug #1 Not tainted
> > 		 ------------------------------------------------------
> > 		 mmap1/202299 is trying to acquire lock:
> > 		 00000001892c0188 (css_set_lock){..-.}-{2:2}, at: obj_cgroup_release+0x4a/0xe0
> > 		 but task is already holding lock:
> > 		 00000000ca3b3818 (&sighand->siglock){-.-.}-{2:2}, at: force_sig_info_to_task+0x38/0x180
> > 		 which lock already depends on the new lock.
> > 		 the existing dependency chain (in reverse order) is:
> > 		 -> #1 (&sighand->siglock){-.-.}-{2:2}:
> > 			__lock_acquire+0x604/0xbd8
> > 			lock_acquire.part.0+0xe2/0x238
> > 			lock_acquire+0xb0/0x200
> > 			_raw_spin_lock_irqsave+0x6a/0xd8
> > 			__lock_task_sighand+0x90/0x190
> > 			cgroup_freeze_task+0x2e/0x90
> > 			cgroup_migrate_execute+0x11c/0x608
> > 			cgroup_update_dfl_csses+0x246/0x270
> > 			cgroup_subtree_control_write+0x238/0x518
> > 			kernfs_fop_write_iter+0x13e/0x1e0
> > 			new_sync_write+0x100/0x190
> > 			vfs_write+0x22c/0x2d8
> > 			ksys_write+0x6c/0xf8
> > 			__do_syscall+0x1da/0x208
> > 			system_call+0x82/0xb0
> > 		 -> #0 (css_set_lock){..-.}-{2:2}:
> > 			check_prev_add+0xe0/0xed8
> > 			validate_chain+0x736/0xb20
> > 			__lock_acquire+0x604/0xbd8
> > 			lock_acquire.part.0+0xe2/0x238
> > 			lock_acquire+0xb0/0x200
> > 			_raw_spin_lock_irqsave+0x6a/0xd8
> > 			obj_cgroup_release+0x4a/0xe0
> > 			percpu_ref_put_many.constprop.0+0x150/0x168
> > 			drain_obj_stock+0x94/0xe8
> > 			refill_obj_stock+0x94/0x278
> > 			obj_cgroup_charge+0x164/0x1d8
> > 			kmem_cache_alloc+0xac/0x528
> > 			__sigqueue_alloc+0x150/0x308
> > 			__send_signal+0x260/0x550
> > 			send_signal+0x7e/0x348
> > 			force_sig_info_to_task+0x104/0x180
> > 			force_sig_fault+0x48/0x58
> > 			__do_pgm_check+0x120/0x1f0
> > 			pgm_check_handler+0x11e/0x180
> > 		 other info that might help us debug this:
> > 		  Possible unsafe locking scenario:
> > 			CPU0                    CPU1
> > 			----                    ----
> > 		   lock(&sighand->siglock);
> > 						lock(css_set_lock);
> > 						lock(&sighand->siglock);
> > 		   lock(css_set_lock);
> > 		  *** DEADLOCK ***
> > 		 2 locks held by mmap1/202299:
> > 		  #0: 00000000ca3b3818 (&sighand->siglock){-.-.}-{2:2}, at: force_sig_info_to_task+0x38/0x180
> > 		  #1: 00000001892ad560 (rcu_read_lock){....}-{1:2}, at: percpu_ref_put_many.constprop.0+0x0/0x168
> > 		 stack backtrace:
> > 		 CPU: 15 PID: 202299 Comm: mmap1 Not tainted 5.17.0-20220113.rc0.git0.f2211f194038.300.fc35.s390x+debug #1
> > 		 Hardware name: IBM 3906 M04 704 (LPAR)
> > 		 Call Trace:
> > 		  [<00000001888aacfe>] dump_stack_lvl+0x76/0x98 
> > 		  [<0000000187c6d7be>] check_noncircular+0x136/0x158 
> > 		  [<0000000187c6e888>] check_prev_add+0xe0/0xed8 
> > 		  [<0000000187c6fdb6>] validate_chain+0x736/0xb20 
> > 		  [<0000000187c71e54>] __lock_acquire+0x604/0xbd8 
> > 		  [<0000000187c7301a>] lock_acquire.part.0+0xe2/0x238 
> > 		  [<0000000187c73220>] lock_acquire+0xb0/0x200 
> > 		  [<00000001888bf9aa>] _raw_spin_lock_irqsave+0x6a/0xd8 
> > 		  [<0000000187ef6862>] obj_cgroup_release+0x4a/0xe0 
> > 		  [<0000000187ef6498>] percpu_ref_put_many.constprop.0+0x150/0x168 
> > 		  [<0000000187ef9674>] drain_obj_stock+0x94/0xe8 
> > 		  [<0000000187efa464>] refill_obj_stock+0x94/0x278 
> > 		  [<0000000187eff55c>] obj_cgroup_charge+0x164/0x1d8 
> > 		  [<0000000187ed8aa4>] kmem_cache_alloc+0xac/0x528 
> > 		  [<0000000187bf2eb8>] __sigqueue_alloc+0x150/0x308 
> > 		  [<0000000187bf4210>] __send_signal+0x260/0x550 
> > 		  [<0000000187bf5f06>] send_signal+0x7e/0x348 
> > 		  [<0000000187bf7274>] force_sig_info_to_task+0x104/0x180 
> > 		  [<0000000187bf7758>] force_sig_fault+0x48/0x58 
> > 		  [<00000001888ae160>] __do_pgm_check+0x120/0x1f0 
> > 		  [<00000001888c0cde>] pgm_check_handler+0x11e/0x180 
> > 		 INFO: lockdep is turned off.
> > 
> > 
> > Regards
> > Alex
> 
> -- 
> tejun
