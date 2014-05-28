From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [stable-3.10.y] possible unsafe locking warning
Date: Wed, 28 May 2014 11:48:56 -0400
Message-ID: <20140528154856.GD1419@htj.dyndns.org>
References: <5385B52A.7050106@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7VAiqhymfMFwOgnVZaImrqYFounK7dmjCxhjMakEtj0=;
        b=Bzqb6SL0VpIldPxFolBzaWfsz/7LrqvuGtHo7nH+3XHVsvvOgg2Hzwf58XVs/NrdUT
         o/rqkbfuc9vm/XmAk1nwG9AMFhlMX5GqZmNfN8O1+pjRpFZunjbRpddqAr40Xi/rOBc9
         qQmRps7vQ5Qe1+MUisDEBZsCRVbq8yBvzDLIA8BHoosW2AZlDzFSwOWG7+W382hsq0YM
         G9qY76J3zXkkdhUoyMSdB5LhLKQnnXJd44hFErBU30i8RtFYilGy8xZU+KxfHgZ8ii8I
         8xlrFplwGj3ABc0iI3MCJJ4hR2lkMuUZBiD2rhN9sqqvEFwwZqk/RYgkLyVuMPyiyhsq
         KAbw==
Content-Disposition: inline
In-Reply-To: <5385B52A.7050106-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gu Zheng <guz.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, tangchen <tangchen-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

(cc'ing Johannes for mm-foo)

Hello,

On Wed, May 28, 2014 at 06:06:34PM +0800, Gu Zheng wrote:
> [ 2457.683370] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
> [ 2457.761540] kswapd2/1151 [HC0[0]:SC0[0]:HE1:SE1] takes:
> [ 2457.824102]  (&sig->group_rwsem){+++++?}, at: [<ffffffff81071864>] exit_signals+0x24/0x130
> [ 2457.923538] {RECLAIM_FS-ON-W} state was registered at:
> [ 2457.985055]   [<ffffffff810bfc99>] mark_held_locks+0xb9/0x140
> [ 2458.053976]   [<ffffffff810c1e3a>] lockdep_trace_alloc+0x7a/0xe0
> [ 2458.126015]   [<ffffffff81194f47>] kmem_cache_alloc_trace+0x37/0x240
> [ 2458.202214]   [<ffffffff812c6e89>] flex_array_alloc+0x99/0x1a0
> [ 2458.272175]   [<ffffffff810da563>] cgroup_attach_task+0x63/0x430
> [ 2458.344214]   [<ffffffff810dcca0>] attach_task_by_pid+0x210/0x280
> [ 2458.417294]   [<ffffffff810dcd26>] cgroup_procs_write+0x16/0x20
> [ 2458.488287]   [<ffffffff810d8410>] cgroup_file_write+0x120/0x2c0
> [ 2458.560320]   [<ffffffff811b21a0>] vfs_write+0xc0/0x1f0
> [ 2458.622994]   [<ffffffff811b2bac>] SyS_write+0x4c/0xa0
> [ 2458.684618]   [<ffffffff815ec3c0>] tracesys+0xdd/0xe2
> [ 2458.745214] irq event stamp: 49
> [ 2458.782794] hardirqs last  enabled at (49): [<ffffffff815e2b56>] _raw_spin_unlock_irqrestore+0x36/0x70
> [ 2458.894388] hardirqs last disabled at (48): [<ffffffff815e337b>] _raw_spin_lock_irqsave+0x2b/0xa0
> [ 2459.000771] softirqs last  enabled at (0): [<ffffffff81059247>] copy_process.part.24+0x627/0x15f0
> [ 2459.107161] softirqs last disabled at (0): [<          (null)>]           (null)
> [ 2459.195852] 
> [ 2459.195852] other info that might help us debug this:
> [ 2459.274024]  Possible unsafe locking scenario:
> [ 2459.274024] 
> [ 2459.344911]        CPU0
> [ 2459.374161]        ----
> [ 2459.403408]   lock(&sig->group_rwsem);
> [ 2459.448490]   <Interrupt>
> [ 2459.479825]     lock(&sig->group_rwsem);
> [ 2459.526979] 
> [ 2459.526979]  *** DEADLOCK ***
> [ 2459.526979] 
> [ 2459.597866] no locks held by kswapd2/1151.
> [ 2459.646896] 
> [ 2459.646896] stack backtrace:
> [ 2459.699049] CPU: 30 PID: 1151 Comm: kswapd2 Not tainted 3.10.39+ #4
> [ 2459.774098] Hardware name: FUJITSU PRIMEQUEST2800E/SB, BIOS PRIMEQUEST 2000 Series BIOS Version 01.48 05/07/2014
> [ 2459.895983]  ffffffff82284bf0 ffff88085856bbf8 ffffffff815dbcf6 ffff88085856bc48
> [ 2459.985003]  ffffffff815d67c6 0000000000000000 ffff880800000001 ffff880800000001
> [ 2460.074024]  000000000000000a ffff88085edc9600 ffffffff810be0e0 0000000000000009
> [ 2460.163087] Call Trace:
> [ 2460.192345]  [<ffffffff815dbcf6>] dump_stack+0x19/0x1b
> [ 2460.253874]  [<ffffffff815d67c6>] print_usage_bug+0x1f7/0x208
> [ 2460.399807]  [<ffffffff810bfb5d>] mark_lock+0x21d/0x2a0
> [ 2460.462369]  [<ffffffff810c076a>] __lock_acquire+0x52a/0xb60
> [ 2460.735516]  [<ffffffff810c1592>] lock_acquire+0xa2/0x140
> [ 2460.935691]  [<ffffffff815e01e1>] down_read+0x51/0xa0
> [ 2461.062888]  [<ffffffff81071864>] exit_signals+0x24/0x130
> [ 2461.127536]  [<ffffffff81060d55>] do_exit+0xb5/0xa50
> [ 2461.320433]  [<ffffffff8108303b>] kthread+0xdb/0x100
> [ 2461.532049]  [<ffffffff815ec0ec>] ret_from_fork+0x7c/0xb0

The lockdep warning is about threadgroup_lock being grabbed by kswapd
which is depended upon during memory reclaim when the lock may be held
by tasks which may wait on memory reclaim.  From the backtrace, it
looks like the right thing to do is marking the kswapd that it's no
longer a memory reclaimer once before it starts exiting.

> And when reference to the related code(kernel-3.10.y), it seems that cgroup_attach_task(thread-2,
> attach kswapd) trigger kswapd(reclaim memory?) when trying to alloc memory(flex_array_alloc) under
> the protection of sig->group_rwsem, but meanwhile the kswapd(thread-1) is in the exit routine
> (because it was marked SHOULD STOP when offline pages completed), which needs to acquire
> sig->group_rwsem in exit_signals(), so the deadlock occurs.
> 
>        thread-1                           			 |            thread-2
>                                                                  |
> __offline_pages():                                               | system_call_fastpath()
> |-> kswapd_stop(node);                                           | |-> ......
>     |-> kthread_stop(kswapd)                                     | |-> cgroup_file_write()
>         |-> set_bit(KTHREAD_SHOULD_STOP, &kthread->flags);       | |-> ......
>         |-> wake_up_process(k)                                   | |-> attach_task_by_pid()
>             |                                                    |     |-> threadgroup_lock(tsk)
> |<----------|                                                    |        // Here, got the lock.
> |-> kswapd()                                                     |    |-> ...
>     |-> if (kthread_should_stop())                               |     |-> cgroup_attach_task()
>             return;                                              |         |-> flex_array_alloc()
>             |                                                    |             |-> kzalloc()
> |<----------|                                                    |                |-> wait for kswapd to reclaim memory
> |-> kthread()                                                    |
>     |-> do_exit(ret)                                             |
>         |-> exit_signals()                                       |
>             |-> threadgroup_change_begin(tsk)                    |
>                 |-> down_read(&tsk->signal->group_rwsem)         |
>                     // Here, acquire the lock. 
> 
> If my analysis is correct, the latest kernel may have the same issue, though the flex_array was replaced
> by list, but we still need to alloc memory(e.g. in find_css_set()), so the race may still occur.
> Any comments about this? If I missed something, please correct me.:)

Not sure whether this can actually happen but if so the right fix
would be making thread-2 not wait for kswapd which is exiting and can
no longer serve as memory reclaimer.

Thanks.

-- 
tejun
