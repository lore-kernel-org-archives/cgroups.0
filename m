From: Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix cgroup_path() vs rename() race
Date: Fri, 08 Feb 2013 13:46:02 -0500
Message-ID: <511547EA.4090902@gmail.com>
References: <51022FC7.5020607@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:message-id:date:from:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        bh=2TS+O09nMfvJjzFX0L+jCHQU99Zpec9sUQ+Tz2oJYyk=;
        b=k2THGjNvX81wPFeD2QkNdNIv1lzaHnWWphz9DsRDfMNFYktq6F5M4iQ1gbH1RjkIbc
         H9svB4gp2z6AIr4AQP2rJzY4q1JX61l9Ci4Kh5XYJUUV9ZI71sshU82lO/c30GhUYFiu
         VEZsZts28w/TB0wVdASVHrSZxUt5I568qfPqeYhCBJIvN/voBjfHZAT+eVG8XgPaIMrb
         g2mmMdDh4tL0CsqQ/7BUN9X5aSTh0TjRyJzmwOa0jrQ/feCDPULen5D5oZA054jK68rj
         BzM1B0y3g56qrCXKVvAeTleHiARbfJgocIeRmlUEO6jNt0+zWYBe0sJGqj/3IFZ/wHsV
         gAvw==
In-Reply-To: <51022FC7.5020607-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 01/25/2013 02:09 AM, Li Zefan wrote:
> rename() will change dentry->d_name. The result of this race can
> be worse than seeing partially rewritten name, but we might access
> a stale pointer because rename() will re-allocate memory to hold
> a longer name.
> 
> Use dentry_path_raw(), and this vfs API will take care of lockings.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi Li,

I was fuzzing with trinity inside a KVM tools guest, and stumbled on
a lockdep spew related to this patch.

Here's the spew (brace yourself):

[  313.262599] ======================================================
[  313.271340] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
[  313.277542] 3.8.0-rc6-next-20130208-sasha-00028-ge4e162d #278 Tainted: G        W
[  313.277542] ------------------------------------------------------
[  313.277542] kworker/u:3/4490 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[  313.277542]  (rename_lock){+.+...}, at: [<ffffffff812a11f9>] dentry_path_raw+0x29/0x70
[  313.277542]
[  313.277542] and this task is already holding:
[  313.277542]  (&(&q->__queue_lock)->rlock){-.-...}, at: [<ffffffff819e78f3>] put_io_context_active+0x63/0x100
[  313.277542] which would create a new lock dependency:
[  313.277542]  (&(&q->__queue_lock)->rlock){-.-...} -> (rename_lock){+.+...}
[  313.277542]
[  313.277542] but this new dependency connects a HARDIRQ-irq-safe lock:
[  313.277542]  (&(&q->__queue_lock)->rlock){-.-...}
... which became HARDIRQ-irq-safe at:
[  313.277542]   [<ffffffff8118452e>] mark_irqflags+0x7e/0x1a0
[  313.277542]   [<ffffffff81186fce>] __lock_acquire+0x87e/0xb00
[  313.277542]   [<ffffffff81187b3a>] lock_acquire+0x1ca/0x270
[  313.277542]   [<ffffffff83d74749>] _raw_spin_lock_irqsave+0x79/0xc0
[  313.277542]   [<ffffffff81f4a1b1>] virtblk_done+0x51/0x2d0
[  313.277542]   [<ffffffff81bf1f34>] vring_interrupt+0x94/0xc0
[  313.277542]   [<ffffffff811c7909>] handle_irq_event_percpu+0x139/0x420
[  313.277542]   [<ffffffff811c7c33>] handle_irq_event+0x43/0x70
[  313.277542]   [<ffffffff811ca638>] handle_edge_irq+0xe8/0x120
[  313.277542]   [<ffffffff810706b4>] handle_irq+0x164/0x190
[  313.277542]   [<ffffffff810701e5>] do_IRQ+0x55/0xd0
[  313.277542]   [<ffffffff83d74af2>] ret_from_intr+0x0/0x1a
[  313.277542]   [<ffffffff811db968>] rcu_note_context_switch+0xc8/0x1e0
[  313.277542]   [<ffffffff83d72363>] __schedule+0x53/0x3b0
[  313.277542]   [<ffffffff83d72825>] schedule+0x55/0x60
[  313.277542]   [<ffffffff83d728ba>] io_schedule+0x8a/0xd0
[  313.277542]   [<ffffffff8120f7f9>] sleep_on_page+0x9/0x10
[  313.277542]   [<ffffffff83d70db8>] __wait_on_bit_lock+0x48/0xa0
[  313.277542]   [<ffffffff8120f7e2>] __lock_page+0x62/0x70
[  313.277542]   [<ffffffff81210968>] do_read_cache_page+0xf8/0x190
[  313.277542]   [<ffffffff81210a47>] read_cache_page_async+0x17/0x20
[  313.277542]   [<ffffffff81210a59>] read_cache_page+0x9/0x20
[  313.277542]   [<ffffffff819efb3b>] read_dev_sector+0x2b/0x90
[  313.277542]   [<ffffffff819f1812>] adfspart_check_ICS+0x52/0x2a0
[  313.277542]   [<ffffffff819f0d45>] check_partition+0xf5/0x1f0
[  313.277542]   [<ffffffff819f09ad>] rescan_partitions+0x8d/0x2b0
[  313.277542]   [<ffffffff812ca178>] __blkdev_get+0x1d8/0x470
[  313.277542]   [<ffffffff812ca605>] blkdev_get+0x1f5/0x200
[  313.277542]   [<ffffffff819ed832>] register_disk+0x102/0x170
[  313.277542]   [<ffffffff819ee034>] add_disk+0xf4/0x1f0
[  313.277542]   [<ffffffff81f4b719>] virtblk_probe+0x5b9/0x700
[  313.277542]   [<ffffffff81bf19cb>] virtio_dev_probe+0xeb/0x160
[  313.277542]   [<ffffffff81ef9f0f>] really_probe+0x10f/0x2e0
[  313.277542]   [<ffffffff81efa28b>] driver_probe_device+0x7b/0xa0
[  313.277542]   [<ffffffff81efa313>] __driver_attach+0x63/0xa0
[  313.277542]   [<ffffffff81ef8269>] bus_for_each_dev+0x59/0x90
[  313.277542]   [<ffffffff81ef9b39>] driver_attach+0x19/0x20
[  313.277542]   [<ffffffff81ef9513>] bus_add_driver+0xf3/0x270
[  313.277542]   [<ffffffff81efa978>] driver_register+0xa8/0x150
[  313.277542]   [<ffffffff81bf1c0d>] register_virtio_driver+0x2d/0x30
[  313.277542]   [<ffffffff861c0d74>] init+0x59/0x83
[  313.277542]   [<ffffffff810020ca>] do_one_initcall+0x8a/0x180
[  313.277542]   [<ffffffff8616df6a>] do_basic_setup+0x96/0xb4
[  313.277542]   [<ffffffff8616e05a>] kernel_init_freeable+0xd2/0x14c
[  313.277542]   [<ffffffff83cca109>] kernel_init+0x9/0xf0
[  313.277542]   [<ffffffff83d7543c>] ret_from_fork+0x7c/0xb0
[  313.277542]
[  313.277542] to a HARDIRQ-irq-unsafe lock:
[  313.277542]  (rename_lock){+.+...}
... which became HARDIRQ-irq-unsafe at:
[  313.277542] ...  [<ffffffff811845c0>] mark_irqflags+0x110/0x1a0
[  313.277542]   [<ffffffff81186fce>] __lock_acquire+0x87e/0xb00
[  313.277542]   [<ffffffff81187b3a>] lock_acquire+0x1ca/0x270
[  313.277542]   [<ffffffff83d7396b>] _raw_spin_lock+0x3b/0x70
[  313.277542]   [<ffffffff812a4a21>] sys_getcwd+0xa1/0x200
[  313.277542]   [<ffffffff83d75718>] tracesys+0xe1/0xe6
[  313.277542]
[  313.277542] other info that might help us debug this:
[  313.277542]
[  313.277542]  Possible interrupt unsafe locking scenario:
[  313.277542]
[  313.277542]        CPU0                    CPU1
[  313.277542]        ----                    ----
[  313.277542]   lock(rename_lock);
[  313.277542]                                local_irq_disable();
[  313.277542]                                lock(&(&q->__queue_lock)->rlock);
[  313.277542]                                lock(rename_lock);
[  313.277542]   <Interrupt>
[  313.277542]     lock(&(&q->__queue_lock)->rlock);
[  313.277542]
[  313.277542]  *** DEADLOCK ***
[  313.277542]
[  313.277542] 3 locks held by kworker/u:3/4490:
[  313.277542]  #0:  (&(&ioc->lock)->rlock/1){......}, at: [<ffffffff819e78be>] put_io_context_active+0x2e/0x100
[  313.277542]  #1:  (&(&q->__queue_lock)->rlock){-.-...}, at: [<ffffffff819e78f3>] put_io_context_active+0x63/0x100
[  313.277542]  #2:  (rcu_read_lock){.+.+..}, at: [<ffffffff81a03def>] cfq_put_queue+0x4f/0x320
[  313.277542]
the dependencies between HARDIRQ-irq-safe lock and the holding lock:
[  313.277542] -> (&(&q->__queue_lock)->rlock){-.-...} ops: 1166 {
[  313.277542]    IN-HARDIRQ-W at:
[  313.277542]                     [<ffffffff8118452e>] mark_irqflags+0x7e/0x1a0
[  313.277542]                     [<ffffffff81186fce>] __lock_acquire+0x87e/0xb00
[  313.277542]                     [<ffffffff81187b3a>] lock_acquire+0x1ca/0x270
[  313.277542]                     [<ffffffff83d74749>] _raw_spin_lock_irqsave+0x79/0xc0
[  313.277542]                     [<ffffffff81f4a1b1>] virtblk_done+0x51/0x2d0
[  313.277542]                     [<ffffffff81bf1f34>] vring_interrupt+0x94/0xc0
[  313.277542]                     [<ffffffff811c7909>] handle_irq_event_percpu+0x139/0x420
[  313.277542]                     [<ffffffff811c7c33>] handle_irq_event+0x43/0x70
[  313.277542]                     [<ffffffff811ca638>] handle_edge_irq+0xe8/0x120
[  313.277542]                     [<ffffffff810706b4>] handle_irq+0x164/0x190
[  313.277542]                     [<ffffffff810701e5>] do_IRQ+0x55/0xd0
[  313.277542]                     [<ffffffff83d74af2>] ret_from_intr+0x0/0x1a
[  313.277542]                     [<ffffffff811db968>] rcu_note_context_switch+0xc8/0x1e0
[  313.277542]                     [<ffffffff83d72363>] __schedule+0x53/0x3b0
[  313.277542]                     [<ffffffff83d72825>] schedule+0x55/0x60
[  313.277542]                     [<ffffffff83d728ba>] io_schedule+0x8a/0xd0
[  313.277542]                     [<ffffffff8120f7f9>] sleep_on_page+0x9/0x10
[  313.277542]                     [<ffffffff83d70db8>] __wait_on_bit_lock+0x48/0xa0
[  313.277542]                     [<ffffffff8120f7e2>] __lock_page+0x62/0x70
[  313.277542]                     [<ffffffff81210968>] do_read_cache_page+0xf8/0x190
[  313.277542]                     [<ffffffff81210a47>] read_cache_page_async+0x17/0x20
[  313.277542]                     [<ffffffff81210a59>] read_cache_page+0x9/0x20
[  313.277542]                     [<ffffffff819efb3b>] read_dev_sector+0x2b/0x90
[  313.277542]                     [<ffffffff819f1812>] adfspart_check_ICS+0x52/0x2a0
[  313.277542]                     [<ffffffff819f0d45>] check_partition+0xf5/0x1f0
[  313.277542]                     [<ffffffff819f09ad>] rescan_partitions+0x8d/0x2b0
[  313.277542]                     [<ffffffff812ca178>] __blkdev_get+0x1d8/0x470
[  313.277542]                     [<ffffffff812ca605>] blkdev_get+0x1f5/0x200
[  313.277542]                     [<ffffffff819ed832>] register_disk+0x102/0x170
[  313.277542]                     [<ffffffff819ee034>] add_disk+0xf4/0x1f0
[  313.277542]                     [<ffffffff81f4b719>] virtblk_probe+0x5b9/0x700
[  313.277542]                     [<ffffffff81bf19cb>] virtio_dev_probe+0xeb/0x160
[  313.277542]                     [<ffffffff81ef9f0f>] really_probe+0x10f/0x2e0
[  313.277542]                     [<ffffffff81efa28b>] driver_probe_device+0x7b/0xa0
[  313.277542]                     [<ffffffff81efa313>] __driver_attach+0x63/0xa0
[  313.277542]                     [<ffffffff81ef8269>] bus_for_each_dev+0x59/0x90
[  313.277542]                     [<ffffffff81ef9b39>] driver_attach+0x19/0x20
[  313.277542]                     [<ffffffff81ef9513>] bus_add_driver+0xf3/0x270
[  313.277542]                     [<ffffffff81efa978>] driver_register+0xa8/0x150
[  313.277542]                     [<ffffffff81bf1c0d>] register_virtio_driver+0x2d/0x30
[  313.277542]                     [<ffffffff861c0d74>] init+0x59/0x83
[  313.277542]                     [<ffffffff810020ca>] do_one_initcall+0x8a/0x180
[  313.277542]                     [<ffffffff8616df6a>] do_basic_setup+0x96/0xb4
[  313.277542]                     [<ffffffff8616e05a>] kernel_init_freeable+0xd2/0x14c
[  313.277542]                     [<ffffffff83cca109>] kernel_init+0x9/0xf0
[  313.277542]                     [<ffffffff83d7543c>] ret_from_fork+0x7c/0xb0
[  313.277542]    IN-SOFTIRQ-W at:
[  313.277542]                     [<ffffffff81184560>] mark_irqflags+0xb0/0x1a0
[  313.277542]                     [<ffffffff81186fce>] __lock_acquire+0x87e/0xb00
[  313.277542]                     [<ffffffff81187b3a>] lock_acquire+0x1ca/0x270
[  313.277542]                     [<ffffffff83d7396b>] _raw_spin_lock+0x3b/0x70
[  313.277542]                     [<ffffffff82025925>] scsi_device_unbusy+0x95/0xd0
[  313.277542]                     [<ffffffff8201c172>] scsi_finish_command+0x32/0x110
[  313.277542]                     [<ffffffff82025bc5>] scsi_softirq_done+0x135/0x150
[  313.277542]                     [<ffffffff819e9b84>] blk_done_softirq+0xb4/0xd0
[  313.277542]                     [<ffffffff81117315>] __do_softirq+0x1e5/0x490
[  313.277542]                     [<ffffffff811175fd>] run_ksoftirqd+0x3d/0xa0
[  313.277542]                     [<ffffffff8114815e>] smpboot_thread_fn+0x2ae/0x2c0
[  313.277542]                     [<ffffffff8113dcc3>] kthread+0xe3/0xf0
[  313.277542]                     [<ffffffff83d7543c>] ret_from_fork+0x7c/0xb0
[  313.277542]    INITIAL USE at:
[  313.277542]                    [<ffffffff81186ff4>] __lock_acquire+0x8a4/0xb00
[  313.277542]                    [<ffffffff81187b3a>] lock_acquire+0x1ca/0x270
[  313.277542]                    [<ffffffff83d743e9>] _raw_spin_lock_irq+0x59/0x90
[  313.277542]                    [<ffffffff819dfa36>] blk_queue_bypass_start+0x16/0xc0
[  313.277542]                    [<ffffffff819fbbb8>] blkcg_activate_policy+0x68/0x3d0
[  313.277542]                    [<ffffffff819fe4a5>] blk_throtl_init+0xf5/0x130
[  313.277542]                    [<ffffffff819fbfb7>] blkcg_init_queue+0x27/0x30
[  313.277542]                    [<ffffffff819de428>] blk_alloc_queue_node+0x278/0x2b0
[  313.277542]                    [<ffffffff819e3a86>] blk_init_queue_node+0x26/0x70
[  313.277542]                    [<ffffffff819e3ade>] blk_init_queue+0xe/0x10
[  313.277542]                    [<ffffffff861bfa80>] do_floppy_init+0xaf/0x6a4
[  313.277542]                    [<ffffffff861c007e>] floppy_async_init+0x9/0xb
[  313.277542]                    [<ffffffff811468fb>] async_run_entry_fn+0x6b/0x130
[  313.277542]                    [<ffffffff81132b08>] process_one_work+0x388/0x670
[  313.277542]                    [<ffffffff811337df>] worker_thread+0x1df/0x2e0
[  313.277542]                    [<ffffffff8113dcc3>] kthread+0xe3/0xf0
[  313.277542]                    [<ffffffff83d7543c>] ret_from_fork+0x7c/0xb0
[  313.277542]  }
[  313.277542]  ... key      at: [<ffffffff86f022d0>] __key.38539+0x0/0x8
[  313.277542]  ... acquired at:
[  313.277542]    [<ffffffff81182f5d>] check_usage+0x1bd/0x1e0
[  313.277542]    [<ffffffff81182fea>] check_irq_usage+0x6a/0xe0
[  313.277542]    [<ffffffff811831ab>] check_prev_add+0x14b/0x640
[  313.277542]    [<ffffffff8118375a>] check_prevs_add+0xba/0x1a0
[  313.277542]    [<ffffffff81183ee0>] validate_chain.isra.21+0x6a0/0x7b0
[  313.277542]    [<ffffffff81187163>] __lock_acquire+0xa13/0xb00
[  313.277542]    [<ffffffff81187b3a>] lock_acquire+0x1ca/0x270
[  313.277542]    [<ffffffff83d7396b>] _raw_spin_lock+0x3b/0x70
[  313.277542]    [<ffffffff812a11f9>] dentry_path_raw+0x29/0x70
[  313.277542]    [<ffffffff811a3e2e>] cgroup_path+0xbe/0xf0
[  313.277542]    [<ffffffff81a03e71>] cfq_put_queue+0xd1/0x320
[  313.277542]    [<ffffffff81a047d8>] cfq_exit_cfqq+0x58/0x70
[  313.277542]    [<ffffffff81a04838>] cfq_exit_icq+0x48/0x60
[  313.277542]    [<ffffffff819e7919>] put_io_context_active+0x89/0x100
[  313.277542]    [<ffffffff819e79de>] exit_io_context+0x4e/0x60
[  313.277542]    [<ffffffff811147fe>] do_exit+0x4be/0x590
[  313.277542]    [<ffffffff8113dccb>] kthread+0xeb/0xf0
[  313.277542]    [<ffffffff83d7543c>] ret_from_fork+0x7c/0xb0
[  313.277542]
[  313.277542]
the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
[  313.277542] -> (rename_lock){+.+...} ops: 2972 {
[  313.277542]    HARDIRQ-ON-W at:
[  313.277542]                     [<ffffffff811845c0>] mark_irqflags+0x110/0x1a0
[  313.277542]                     [<ffffffff81186fce>] __lock_acquire+0x87e/0xb00
[  313.277542]                     [<ffffffff81187b3a>] lock_acquire+0x1ca/0x270
[  313.277542]                     [<ffffffff83d7396b>] _raw_spin_lock+0x3b/0x70
[  313.277542]                     [<ffffffff812a4a21>] sys_getcwd+0xa1/0x200
[  313.277542]                     [<ffffffff83d75718>] tracesys+0xe1/0xe6
[  313.277542]    SOFTIRQ-ON-W at:
[  313.277542]                     [<ffffffff811845e3>] mark_irqflags+0x133/0x1a0
[  313.277542]                     [<ffffffff81186fce>] __lock_acquire+0x87e/0xb00
[  313.277542]                     [<ffffffff81187b3a>] lock_acquire+0x1ca/0x270
[  313.277542]                     [<ffffffff83d7396b>] _raw_spin_lock+0x3b/0x70
[  313.277542]                     [<ffffffff812a4a21>] sys_getcwd+0xa1/0x200
[  313.277542]                     [<ffffffff83d75718>] tracesys+0xe1/0xe6
[  313.277542]    INITIAL USE at:
[  313.277542]                    [<ffffffff81186ff4>] __lock_acquire+0x8a4/0xb00
[  313.277542]                    [<ffffffff81187b3a>] lock_acquire+0x1ca/0x270
[  313.277542]                    [<ffffffff83d7396b>] _raw_spin_lock+0x3b/0x70
[  313.277542]                    [<ffffffff812a4a21>] sys_getcwd+0xa1/0x200
[  313.277542]                    [<ffffffff83d75718>] tracesys+0xe1/0xe6
[  313.277542]  }
[  313.277542]  ... key      at: [<ffffffff8540e020>] rename_lock+0x20/0x1000
[  313.277542]  ... acquired at:
[  313.277542]    [<ffffffff81182f5d>] check_usage+0x1bd/0x1e0
[  313.277542]    [<ffffffff81182fea>] check_irq_usage+0x6a/0xe0
[  313.277542]    [<ffffffff811831ab>] check_prev_add+0x14b/0x640
[  313.277542]    [<ffffffff8118375a>] check_prevs_add+0xba/0x1a0
[  313.277542]    [<ffffffff81183ee0>] validate_chain.isra.21+0x6a0/0x7b0
[  313.277542]    [<ffffffff81187163>] __lock_acquire+0xa13/0xb00
[  313.277542]    [<ffffffff81187b3a>] lock_acquire+0x1ca/0x270
[  313.277542]    [<ffffffff83d7396b>] _raw_spin_lock+0x3b/0x70
[  313.277542]    [<ffffffff812a11f9>] dentry_path_raw+0x29/0x70
[  313.277542]    [<ffffffff811a3e2e>] cgroup_path+0xbe/0xf0
[  313.277542]    [<ffffffff81a03e71>] cfq_put_queue+0xd1/0x320
[  313.277542]    [<ffffffff81a047d8>] cfq_exit_cfqq+0x58/0x70
[  313.277542]    [<ffffffff81a04838>] cfq_exit_icq+0x48/0x60
[  313.277542]    [<ffffffff819e7919>] put_io_context_active+0x89/0x100
[  313.277542]    [<ffffffff819e79de>] exit_io_context+0x4e/0x60
[  313.277542]    [<ffffffff811147fe>] do_exit+0x4be/0x590
[  313.277542]    [<ffffffff8113dccb>] kthread+0xeb/0xf0
[  313.277542]    [<ffffffff83d7543c>] ret_from_fork+0x7c/0xb0
[  313.277542]
[  313.277542]
[  313.277542] stack backtrace:
[  313.277542] Pid: 4490, comm: kworker/u:3 Tainted: G        W    3.8.0-rc6-next-20130208-sasha-00028-ge4e162d #278
[  313.277542] Call Trace:
[  313.277542]  [<ffffffff81182d7a>] print_bad_irq_dependency+0x2ea/0x310
[  313.277542]  [<ffffffff81182f5d>] check_usage+0x1bd/0x1e0
[  313.277542]  [<ffffffff81156e65>] ? sched_clock_local+0x25/0x90
[  313.277542]  [<ffffffff81182fea>] check_irq_usage+0x6a/0xe0
[  313.277542]  [<ffffffff811831ab>] check_prev_add+0x14b/0x640
[  313.277542]  [<ffffffff810a42b8>] ? kvm_clock_read+0x38/0x70
[  313.277542]  [<ffffffff8118375a>] check_prevs_add+0xba/0x1a0
[  313.277542]  [<ffffffff810774a5>] ? sched_clock+0x15/0x20
[  313.277542]  [<ffffffff81183ee0>] validate_chain.isra.21+0x6a0/0x7b0
[  313.277542]  [<ffffffff81187163>] __lock_acquire+0xa13/0xb00
[  313.277542]  [<ffffffff81156e65>] ? sched_clock_local+0x25/0x90
[  313.277542]  [<ffffffff81157098>] ? sched_clock_cpu+0x108/0x120
[  313.277542]  [<ffffffff81187b3a>] lock_acquire+0x1ca/0x270
[  313.277542]  [<ffffffff812a11f9>] ? dentry_path_raw+0x29/0x70
[  313.277542]  [<ffffffff810774a5>] ? sched_clock+0x15/0x20
[  313.277542]  [<ffffffff83d7396b>] _raw_spin_lock+0x3b/0x70
[  313.277542]  [<ffffffff812a11f9>] ? dentry_path_raw+0x29/0x70
[  313.277542]  [<ffffffff812a11f9>] dentry_path_raw+0x29/0x70
[  313.277542]  [<ffffffff811a3e2e>] cgroup_path+0xbe/0xf0
[  313.277542]  [<ffffffff81a03e71>] cfq_put_queue+0xd1/0x320
[  313.277542]  [<ffffffff81a03def>] ? cfq_put_queue+0x4f/0x320
[  313.277542]  [<ffffffff819e78f3>] ? put_io_context_active+0x63/0x100
[  313.277542]  [<ffffffff819e78be>] ? put_io_context_active+0x2e/0x100
[  313.277542]  [<ffffffff81a047d8>] cfq_exit_cfqq+0x58/0x70
[  313.277542]  [<ffffffff81a04838>] cfq_exit_icq+0x48/0x60
[  313.277542]  [<ffffffff819e7919>] put_io_context_active+0x89/0x100
[  313.277542]  [<ffffffff819e79de>] exit_io_context+0x4e/0x60
[  313.277542]  [<ffffffff811147fe>] do_exit+0x4be/0x590
[  313.277542]  [<ffffffff81133600>] ? manage_workers+0x110/0x110
[  313.277542]  [<ffffffff8113dccb>] kthread+0xeb/0xf0
[  313.277542]  [<ffffffff83d721f6>] ? wait_for_common+0x106/0x170
[  313.277542]  [<ffffffff8113dbe0>] ? flush_kthread_worker+0x190/0x190
[  313.277542]  [<ffffffff83d7543c>] ret_from_fork+0x7c/0xb0
[  313.277542]  [<ffffffff8113dbe0>] ? flush_kthread_worker+0x190/0x190


Thanks,
Sasha
