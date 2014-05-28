From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [stable-3.10.y] possible unsafe locking warning
Date: Wed, 28 May 2014 07:26:37 -0700
Message-ID: <20140528142637.GB24250@kroah.com>
References: <5385B52A.7050106@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=
	messagingengine.com; h=date:from:to:cc:subject:message-id
	:references:mime-version:content-type:in-reply-to; s=smtpout;
	 bh=jGH3+uzx00v2MGra+Y6bTLIvbos=; b=qqMPfk+G0uArEU4HRBLradEcLMvW
	qPOcHWKC80z1oR7nNcvh/lEllyBSTH+BkywAcJy1oYgNhOzx8QYL4KAIAinKqefv
	o2M345UNHARtPgERs2YZ7HuyKAg+SIv3loQxSajSmcsw3DNMb9unjI2BKah6z63X
	SaefrooFFRWVvec=
Content-Disposition: inline
In-Reply-To: <5385B52A.7050106-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gu Zheng <guz.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, tangchen <tangchen-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

On Wed, May 28, 2014 at 06:06:34PM +0800, Gu Zheng wrote:
> Hi all,
> When offline the whole memory of a movable numa node on kernel stable-3.10-y,
> the following possible deadlock warning occurs.
> 
> [ 2457.467359] 
> [ 2457.485175] =================================
> [ 2457.537325] [ INFO: inconsistent lock state ]
> [ 2457.589476] 3.10.39+ #4 Not tainted
> [ 2457.631218] ---------------------------------
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
> [ 2460.322679]  [<ffffffff810be0e0>] ? check_usage_backwards+0x160/0x160
> [ 2460.399807]  [<ffffffff810bfb5d>] mark_lock+0x21d/0x2a0
> [ 2460.462369]  [<ffffffff810c076a>] __lock_acquire+0x52a/0xb60
> [ 2460.530136]  [<ffffffff8101acd3>] ? native_sched_clock+0x13/0x80
> [ 2460.602065]  [<ffffffff8101ad49>] ? sched_clock+0x9/0x10
> [ 2460.665668]  [<ffffffff81096f05>] ? sched_clock_cpu+0xb5/0x100
> [ 2460.735516]  [<ffffffff810c1592>] lock_acquire+0xa2/0x140
> [ 2460.800156]  [<ffffffff81071864>] ? exit_signals+0x24/0x130
> [ 2460.866885]  [<ffffffff81158ca0>] ? balance_pgdat+0x5e0/0x5e0
> [ 2460.935691]  [<ffffffff815e01e1>] down_read+0x51/0xa0
> [ 2460.996166]  [<ffffffff81071864>] ? exit_signals+0x24/0x130
> [ 2461.062888]  [<ffffffff81071864>] exit_signals+0x24/0x130
> [ 2461.127536]  [<ffffffff81060d55>] do_exit+0xb5/0xa50
> [ 2461.186976]  [<ffffffff810841e0>] ? wake_up_bit+0x30/0x30
> [ 2461.251629]  [<ffffffff81158ca0>] ? balance_pgdat+0x5e0/0x5e0
> [ 2461.320433]  [<ffffffff8108303b>] kthread+0xdb/0x100
> [ 2461.379870]  [<ffffffff815e12eb>] ? wait_for_completion+0x3b/0x110
> [ 2461.453879]  [<ffffffff81082f60>] ? kthread_create_on_node+0x140/0x140
> [ 2461.532049]  [<ffffffff815ec0ec>] ret_from_fork+0x7c/0xb0
> [ 2461.596689]  [<ffffffff81082f60>] ? kthread_create_on_node+0x140/0x140
> 
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

Can you test the latest kernel release to verify this?  There's nothing
we can do to an old kernel version that isn't already fixed in upstream
first.

greg k-h
