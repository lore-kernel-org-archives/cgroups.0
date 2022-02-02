From: Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH RESEND] mm: memcg: synchronize objcg lists with a
 dedicated spinlock
Date: Wed, 2 Feb 2022 09:58:15 -0600
Message-ID: <49447f71-bb84-8e1d-e0cb-c9e482d3459b@arm.com>
References: <Yfm1IHmoGdyUR81T@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <Yfm1IHmoGdyUR81T-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Egorenkov <egorenar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/1/22 16:33, Roman Gushchin wrote:
> Alexander reported a circular lock dependency revealed by the mmap1
> ltp test:
>    LOCKDEP_CIRCULAR (suite: ltp, case: mtest06 (mmap1))
>            WARNING: possible circular locking dependency detected
>            5.17.0-20220113.rc0.git0.f2211f194038.300.fc35.s390x+debug #1 Not tainted
>            ------------------------------------------------------
>            mmap1/202299 is trying to acquire lock:
>            00000001892c0188 (css_set_lock){..-.}-{2:2}, at: obj_cgroup_release+0x4a/0xe0
>            but task is already holding lock:
>            00000000ca3b3818 (&sighand->siglock){-.-.}-{2:2}, at: force_sig_info_to_task+0x38/0x180
>            which lock already depends on the new lock.
>            the existing dependency chain (in reverse order) is:
>            -> #1 (&sighand->siglock){-.-.}-{2:2}:
>                   __lock_acquire+0x604/0xbd8
>                   lock_acquire.part.0+0xe2/0x238
>                   lock_acquire+0xb0/0x200
>                   _raw_spin_lock_irqsave+0x6a/0xd8
>                   __lock_task_sighand+0x90/0x190
>                   cgroup_freeze_task+0x2e/0x90
>                   cgroup_migrate_execute+0x11c/0x608
>                   cgroup_update_dfl_csses+0x246/0x270
>                   cgroup_subtree_control_write+0x238/0x518
>                   kernfs_fop_write_iter+0x13e/0x1e0
>                   new_sync_write+0x100/0x190
>                   vfs_write+0x22c/0x2d8
>                   ksys_write+0x6c/0xf8
>                   __do_syscall+0x1da/0x208
>                   system_call+0x82/0xb0
>            -> #0 (css_set_lock){..-.}-{2:2}:
>                   check_prev_add+0xe0/0xed8
>                   validate_chain+0x736/0xb20
>                   __lock_acquire+0x604/0xbd8
>                   lock_acquire.part.0+0xe2/0x238
>                   lock_acquire+0xb0/0x200
>                   _raw_spin_lock_irqsave+0x6a/0xd8
>                   obj_cgroup_release+0x4a/0xe0
>                   percpu_ref_put_many.constprop.0+0x150/0x168
>                   drain_obj_stock+0x94/0xe8
>                   refill_obj_stock+0x94/0x278
>                   obj_cgroup_charge+0x164/0x1d8
>                   kmem_cache_alloc+0xac/0x528
>                   __sigqueue_alloc+0x150/0x308
>                   __send_signal+0x260/0x550
>                   send_signal+0x7e/0x348
>                   force_sig_info_to_task+0x104/0x180
>                   force_sig_fault+0x48/0x58
>                   __do_pgm_check+0x120/0x1f0
>                   pgm_check_handler+0x11e/0x180
>            other info that might help us debug this:
>             Possible unsafe locking scenario:
>                   CPU0                    CPU1
>                   ----                    ----
>              lock(&sighand->siglock);
>                                           lock(css_set_lock);
>                                           lock(&sighand->siglock);
>              lock(css_set_lock);
>             *** DEADLOCK ***
>            2 locks held by mmap1/202299:
>             #0: 00000000ca3b3818 (&sighand->siglock){-.-.}-{2:2}, at: force_sig_info_to_task+0x38/0x180
>             #1: 00000001892ad560 (rcu_read_lock){....}-{1:2}, at: percpu_ref_put_many.constprop.0+0x0/0x168
>            stack backtrace:
>            CPU: 15 PID: 202299 Comm: mmap1 Not tainted 5.17.0-20220113.rc0.git0.f2211f194038.300.fc35.s390x+debug #1
>            Hardware name: IBM 3906 M04 704 (LPAR)
>            Call Trace:
>             [<00000001888aacfe>] dump_stack_lvl+0x76/0x98
>             [<0000000187c6d7be>] check_noncircular+0x136/0x158
>             [<0000000187c6e888>] check_prev_add+0xe0/0xed8
>             [<0000000187c6fdb6>] validate_chain+0x736/0xb20
>             [<0000000187c71e54>] __lock_acquire+0x604/0xbd8
>             [<0000000187c7301a>] lock_acquire.part.0+0xe2/0x238
>             [<0000000187c73220>] lock_acquire+0xb0/0x200
>             [<00000001888bf9aa>] _raw_spin_lock_irqsave+0x6a/0xd8
>             [<0000000187ef6862>] obj_cgroup_release+0x4a/0xe0
>             [<0000000187ef6498>] percpu_ref_put_many.constprop.0+0x150/0x168
>             [<0000000187ef9674>] drain_obj_stock+0x94/0xe8
>             [<0000000187efa464>] refill_obj_stock+0x94/0x278
>             [<0000000187eff55c>] obj_cgroup_charge+0x164/0x1d8
>             [<0000000187ed8aa4>] kmem_cache_alloc+0xac/0x528
>             [<0000000187bf2eb8>] __sigqueue_alloc+0x150/0x308
>             [<0000000187bf4210>] __send_signal+0x260/0x550
>             [<0000000187bf5f06>] send_signal+0x7e/0x348
>             [<0000000187bf7274>] force_sig_info_to_task+0x104/0x180
>             [<0000000187bf7758>] force_sig_fault+0x48/0x58
>             [<00000001888ae160>] __do_pgm_check+0x120/0x1f0
>             [<00000001888c0cde>] pgm_check_handler+0x11e/0x180
>            INFO: lockdep is turned off.
> 
> In this example a slab allocation from __send_signal() caused a
> refilling and draining of a percpu objcg stock, resulted in a
> releasing of another non-related objcg. Objcg release path requires
> taking the css_set_lock, which is used to synchronize objcg lists.
> 
> This can create a circular dependency with the sighandler lock,
> which is taken with the locked css_set_lock by the freezer code
> (to freeze a task).
> 
> In general it seems that using css_set_lock to synchronize objcg lists
> makes any slab allocations and deallocation with the locked
> css_set_lock and any intervened locks risky.
> 
> To fix the problem and make the code more robust let's stop using
> css_set_lock to synchronize objcg lists and use a new dedicated
> spinlock instead.
> 
> Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
> Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Reported-by: Alexander Egorenkov <egorenar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
> Tested-by: Alexander Egorenkov <egorenar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
> Reviewed-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>   include/linux/memcontrol.h |  5 +++--
>   mm/memcontrol.c            | 10 +++++-----
>   2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index b72d75141e12..0abbd685703b 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -219,7 +219,7 @@ struct obj_cgroup {
>   	struct mem_cgroup *memcg;
>   	atomic_t nr_charged_bytes;
>   	union {
> -		struct list_head list;
> +		struct list_head list; /* protected by objcg_lock */
>   		struct rcu_head rcu;
>   	};
>   };
> @@ -315,7 +315,8 @@ struct mem_cgroup {
>   #ifdef CONFIG_MEMCG_KMEM
>   	int kmemcg_id;
>   	struct obj_cgroup __rcu *objcg;
> -	struct list_head objcg_list; /* list of inherited objcgs */
> +	/* list of inherited objcgs, protected by objcg_lock */
> +	struct list_head objcg_list;
>   #endif
>   
>   	MEMCG_PADDING(_pad2_);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 09d342c7cbd0..36e9f38c919d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -254,7 +254,7 @@ struct mem_cgroup *vmpressure_to_memcg(struct vmpressure *vmpr)
>   }
>   
>   #ifdef CONFIG_MEMCG_KMEM
> -extern spinlock_t css_set_lock;
> +static DEFINE_SPINLOCK(objcg_lock);
>   
>   bool mem_cgroup_kmem_disabled(void)
>   {
> @@ -298,9 +298,9 @@ static void obj_cgroup_release(struct percpu_ref *ref)
>   	if (nr_pages)
>   		obj_cgroup_uncharge_pages(objcg, nr_pages);
>   
> -	spin_lock_irqsave(&css_set_lock, flags);
> +	spin_lock_irqsave(&objcg_lock, flags);
>   	list_del(&objcg->list);
> -	spin_unlock_irqrestore(&css_set_lock, flags);
> +	spin_unlock_irqrestore(&objcg_lock, flags);
>   
>   	percpu_ref_exit(ref);
>   	kfree_rcu(objcg, rcu);
> @@ -332,7 +332,7 @@ static void memcg_reparent_objcgs(struct mem_cgroup *memcg,
>   
>   	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
>   
> -	spin_lock_irq(&css_set_lock);
> +	spin_lock_irq(&objcg_lock);
>   
>   	/* 1) Ready to reparent active objcg. */
>   	list_add(&objcg->list, &memcg->objcg_list);
> @@ -342,7 +342,7 @@ static void memcg_reparent_objcgs(struct mem_cgroup *memcg,
>   	/* 3) Move already reparented objcgs to the parent's list */
>   	list_splice(&memcg->objcg_list, &parent->objcg_list);
>   
> -	spin_unlock_irq(&css_set_lock);
> +	spin_unlock_irq(&objcg_lock);
>   
>   	percpu_ref_kill(&objcg->refcnt);
>   }
> 

Thanks for taking care of this. Since it looks the same as my patch 
aside from the fact that I also defensivly converted the list_del to a 
list_del_rcu.


Reviewed-by: Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>

and

Tested-by: Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>


Thanks again,



