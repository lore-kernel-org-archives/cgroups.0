From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH RESEND] mm: memcg: synchronize objcg lists with a
 dedicated spinlock
Date: Sat, 5 Feb 2022 20:27:09 +0800
Message-ID: <CAMZfGtU+RGm-4AjLoiRnhcMxuVz=Uwf_VkQuHMNFKwSo15CyvQ@mail.gmail.com>
References: <Yfm1IHmoGdyUR81T@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K0TXX0HcAAdILSf1Xr6CI0TmKyZq0bWXmyWtV08FgQ4=;
        b=EMGvLSzzEHh7OxpO0knPPN1LY+ww9zKIb2KgkaqSzilJqC2fDxjTAvhwReQcb0uMyQ
         Okfux9KTlP8Wy9GANPGDktwe2NM9lODyzy2li4XF6AQwZDJE6IH90+achtne1P6Gb//4
         PtLeS8jxkYUyXMfac3qwzQLQ9Bbb7ly/2jPCKHeiXxRCdKOSxPR1dI7JquHRQw2Ts91r
         V8L/LBq15WJMnTmRcRmuP7D35+/v+V1+3bEK+OsVbbawwtgad/uXtN4HtVneOE6yZgSG
         K45br0M16vxxKf4RtR8PBLvfcUcEYzs000nptnoELGnt8eFdeLCTrgdDRkKG5TOKxom+
         SKZA==
In-Reply-To: <Yfm1IHmoGdyUR81T-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Egorenkov <egorenar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Feb 2, 2022 at 6:33 AM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
>
> Alexander reported a circular lock dependency revealed by the mmap1
> ltp test:
>   LOCKDEP_CIRCULAR (suite: ltp, case: mtest06 (mmap1))
>           WARNING: possible circular locking dependency detected
>           5.17.0-20220113.rc0.git0.f2211f194038.300.fc35.s390x+debug #1 Not tainted
>           ------------------------------------------------------
>           mmap1/202299 is trying to acquire lock:
>           00000001892c0188 (css_set_lock){..-.}-{2:2}, at: obj_cgroup_release+0x4a/0xe0
>           but task is already holding lock:
>           00000000ca3b3818 (&sighand->siglock){-.-.}-{2:2}, at: force_sig_info_to_task+0x38/0x180
>           which lock already depends on the new lock.
>           the existing dependency chain (in reverse order) is:
>           -> #1 (&sighand->siglock){-.-.}-{2:2}:
>                  __lock_acquire+0x604/0xbd8
>                  lock_acquire.part.0+0xe2/0x238
>                  lock_acquire+0xb0/0x200
>                  _raw_spin_lock_irqsave+0x6a/0xd8
>                  __lock_task_sighand+0x90/0x190
>                  cgroup_freeze_task+0x2e/0x90
>                  cgroup_migrate_execute+0x11c/0x608
>                  cgroup_update_dfl_csses+0x246/0x270
>                  cgroup_subtree_control_write+0x238/0x518
>                  kernfs_fop_write_iter+0x13e/0x1e0
>                  new_sync_write+0x100/0x190
>                  vfs_write+0x22c/0x2d8
>                  ksys_write+0x6c/0xf8
>                  __do_syscall+0x1da/0x208
>                  system_call+0x82/0xb0
>           -> #0 (css_set_lock){..-.}-{2:2}:
>                  check_prev_add+0xe0/0xed8
>                  validate_chain+0x736/0xb20
>                  __lock_acquire+0x604/0xbd8
>                  lock_acquire.part.0+0xe2/0x238
>                  lock_acquire+0xb0/0x200
>                  _raw_spin_lock_irqsave+0x6a/0xd8
>                  obj_cgroup_release+0x4a/0xe0
>                  percpu_ref_put_many.constprop.0+0x150/0x168
>                  drain_obj_stock+0x94/0xe8
>                  refill_obj_stock+0x94/0x278
>                  obj_cgroup_charge+0x164/0x1d8
>                  kmem_cache_alloc+0xac/0x528
>                  __sigqueue_alloc+0x150/0x308
>                  __send_signal+0x260/0x550
>                  send_signal+0x7e/0x348
>                  force_sig_info_to_task+0x104/0x180
>                  force_sig_fault+0x48/0x58
>                  __do_pgm_check+0x120/0x1f0
>                  pgm_check_handler+0x11e/0x180
>           other info that might help us debug this:
>            Possible unsafe locking scenario:
>                  CPU0                    CPU1
>                  ----                    ----
>             lock(&sighand->siglock);
>                                          lock(css_set_lock);
>                                          lock(&sighand->siglock);
>             lock(css_set_lock);
>            *** DEADLOCK ***
>           2 locks held by mmap1/202299:
>            #0: 00000000ca3b3818 (&sighand->siglock){-.-.}-{2:2}, at: force_sig_info_to_task+0x38/0x180
>            #1: 00000001892ad560 (rcu_read_lock){....}-{1:2}, at: percpu_ref_put_many.constprop.0+0x0/0x168
>           stack backtrace:
>           CPU: 15 PID: 202299 Comm: mmap1 Not tainted 5.17.0-20220113.rc0.git0.f2211f194038.300.fc35.s390x+debug #1
>           Hardware name: IBM 3906 M04 704 (LPAR)
>           Call Trace:
>            [<00000001888aacfe>] dump_stack_lvl+0x76/0x98
>            [<0000000187c6d7be>] check_noncircular+0x136/0x158
>            [<0000000187c6e888>] check_prev_add+0xe0/0xed8
>            [<0000000187c6fdb6>] validate_chain+0x736/0xb20
>            [<0000000187c71e54>] __lock_acquire+0x604/0xbd8
>            [<0000000187c7301a>] lock_acquire.part.0+0xe2/0x238
>            [<0000000187c73220>] lock_acquire+0xb0/0x200
>            [<00000001888bf9aa>] _raw_spin_lock_irqsave+0x6a/0xd8
>            [<0000000187ef6862>] obj_cgroup_release+0x4a/0xe0
>            [<0000000187ef6498>] percpu_ref_put_many.constprop.0+0x150/0x168
>            [<0000000187ef9674>] drain_obj_stock+0x94/0xe8
>            [<0000000187efa464>] refill_obj_stock+0x94/0x278
>            [<0000000187eff55c>] obj_cgroup_charge+0x164/0x1d8
>            [<0000000187ed8aa4>] kmem_cache_alloc+0xac/0x528
>            [<0000000187bf2eb8>] __sigqueue_alloc+0x150/0x308
>            [<0000000187bf4210>] __send_signal+0x260/0x550
>            [<0000000187bf5f06>] send_signal+0x7e/0x348
>            [<0000000187bf7274>] force_sig_info_to_task+0x104/0x180
>            [<0000000187bf7758>] force_sig_fault+0x48/0x58
>            [<00000001888ae160>] __do_pgm_check+0x120/0x1f0
>            [<00000001888c0cde>] pgm_check_handler+0x11e/0x180
>           INFO: lockdep is turned off.
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

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks.
