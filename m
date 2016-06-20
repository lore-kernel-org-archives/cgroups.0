From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: 4.7-rc1: lockdep: inconsistent lock state
 kcompactd/aio_migratepage/mem_cgroup_migrate....
Date: Mon, 20 Jun 2016 13:13:41 +0200
Message-ID: <5767CFE5.7080904@de.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux MM <linux-mm@kvack.org>, cgroups@vger.kernel.org
Cc: "linux-kernel@vger.kernel.org >> Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>

Has anyone seen this before?


[  335.384657] =================================
[  335.384659] [ INFO: inconsistent lock state ]
[  335.384663] 4.7.0-rc1+ #52 Tainted: G        W      
[  335.384666] ---------------------------------
[  335.384669] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
[  335.384672] kcompactd0/151 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  335.384674]  (&(&ctx->completion_lock)->rlock){+.?.-.}, at: [<000000000038fd96>] aio_migratepage+0x156/0x1e8
[  335.384692] {IN-SOFTIRQ-W} state was registered at:
[  335.384696]   [<00000000001a8366>] __lock_acquire+0x5b6/0x1930
[  335.384704]   [<00000000001a9b9e>] lock_acquire+0xee/0x270
[  335.384708]   [<0000000000951fee>] _raw_spin_lock_irqsave+0x66/0xb0
[  335.384717]   [<0000000000390108>] aio_complete+0x98/0x328
[  335.384721]   [<000000000037c7d4>] dio_complete+0xe4/0x1e0
[  335.384728]   [<0000000000650e64>] blk_update_request+0xd4/0x450
[  335.384736]   [<000000000072a1a8>] scsi_end_request+0x48/0x1c8
[  335.384743]   [<000000000072d7e2>] scsi_io_completion+0x272/0x698
[  335.384747]   [<000000000065adb2>] blk_done_softirq+0xca/0xe8
[  335.384753]   [<0000000000953f80>] __do_softirq+0xc8/0x518
[  335.384757]   [<00000000001495de>] irq_exit+0xee/0x110
[  335.384764]   [<000000000010ceba>] do_IRQ+0x6a/0x88
[  335.384769]   [<000000000095342e>] io_int_handler+0x11a/0x25c
[  335.384774]   [<000000000094fb5c>] __mutex_unlock_slowpath+0x144/0x1d8
[  335.384778]   [<000000000094fb58>] __mutex_unlock_slowpath+0x140/0x1d8
[  335.384783]   [<00000000003c6114>] kernfs_iop_permission+0x64/0x80
[  335.384791]   [<000000000033ba86>] __inode_permission+0x9e/0xf0
[  335.384799]   [<000000000033ea96>] link_path_walk+0x6e/0x510
[  335.384825]   [<000000000033f09c>] path_lookupat+0xc4/0x1a8
[  335.384828]   [<000000000034195c>] filename_lookup+0x9c/0x160
[  335.384831]   [<0000000000341b44>] user_path_at_empty+0x5c/0x70
[  335.384834]   [<0000000000335250>] SyS_readlinkat+0x68/0x140
[  335.384838]   [<0000000000952f8e>] system_call+0xd6/0x270
[  335.384842] irq event stamp: 971410
[  335.384844] hardirqs last  enabled at (971409): [<000000000030f982>] migrate_page_move_mapping+0x3ea/0x588
[  335.384850] hardirqs last disabled at (971410): [<0000000000951fc4>] _raw_spin_lock_irqsave+0x3c/0xb0
[  335.384854] softirqs last  enabled at (970526): [<0000000000954318>] __do_softirq+0x460/0x518
[  335.384858] softirqs last disabled at (970519): [<00000000001495de>] irq_exit+0xee/0x110
[  335.384862] 
               other info that might help us debug this:
[  335.384864]  Possible unsafe locking scenario:

[  335.384867]        CPU0
[  335.384870]        ----
[  335.384871]   lock(&(&ctx->completion_lock)->rlock);
[  335.384875]   <Interrupt>
[  335.384877]     lock(&(&ctx->completion_lock)->rlock);
[  335.384882] 
                *** DEADLOCK ***

[  335.384885] 3 locks held by kcompactd0/151:
[  335.384886]  #0:  (&(&mapping->private_lock)->rlock){+.+.-.}, at: [<000000000038fc82>] aio_migratepage+0x42/0x1e8
[  335.384895]  #1:  (&ctx->ring_lock){+.+.+.}, at: [<000000000038fc9a>] aio_migratepage+0x5a/0x1e8
[  335.384902]  #2:  (&(&ctx->completion_lock)->rlock){+.?.-.}, at: [<000000000038fd96>] aio_migratepage+0x156/0x1e8
[  335.384910] 
               stack backtrace:
[  335.384913] CPU: 20 PID: 151 Comm: kcompactd0 Tainted: G        W       4.7.0-rc1+ #52
[  335.384915]        00000001c6cbb730 00000001c6cbb7c0 0000000000000002 0000000000000000 
                      00000001c6cbb860 00000001c6cbb7d8 00000001c6cbb7d8 0000000000114496 
                      0000000000000000 0000000000b517ec 0000000000b680b6 000000000000000b 
                      00000001c6cbb820 00000001c6cbb7c0 0000000000000000 0000000000000000 
                      040000000184ad18 0000000000114496 00000001c6cbb7c0 00000001c6cbb820 
[  335.384945] Call Trace:
[  335.384950] ([<00000000001143d2>] show_trace+0xea/0xf0)
[  335.384953] ([<000000000011444a>] show_stack+0x72/0xf0)
[  335.384959] ([<0000000000684522>] dump_stack+0x9a/0xd8)
[  335.384963] ([<000000000028679c>] print_usage_bug.part.27+0x2d4/0x2e8)
[  335.384966] ([<00000000001a71ce>] mark_lock+0x17e/0x758)
[  335.384969] ([<00000000001a784a>] mark_held_locks+0xa2/0xd0)
[  335.384972] ([<00000000001a79b8>] trace_hardirqs_on_caller+0x140/0x1c0)
[  335.384977] ([<0000000000326026>] mem_cgroup_migrate+0x266/0x370)
[  335.384980] ([<000000000038fdaa>] aio_migratepage+0x16a/0x1e8)
[  335.384982] ([<0000000000310568>] move_to_new_page+0xb0/0x260)
[  335.384986] ([<00000000003111b4>] migrate_pages+0x8f4/0x9f0)
[  335.384990] ([<00000000002c507c>] compact_zone+0x4dc/0xdc8)
[  335.384992] ([<00000000002c5e22>] kcompactd_do_work+0x1aa/0x358)
[  335.384994] ([<00000000002c608a>] kcompactd+0xba/0x2c8)
[  335.384999] ([<000000000016b09a>] kthread+0x10a/0x110)
[  335.385001] ([<000000000095315a>] kernel_thread_starter+0x6/0xc)
[  335.385003] ([<0000000000953154>] kernel_thread_starter+0x0/0xc)
[  335.385004] INFO: lockdep is turned off.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
