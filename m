From: syzbot <syzbot+b42749a851a47a0f581b-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Subject: [syzbot] memory leak in blk_iolatency_init (2)
Date: Sat, 12 Mar 2022 13:45:25 -0800
Message-ID: <0000000000007414e805da0c5de4@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

Hello,

syzbot found the following issue on:

HEAD commit:    79b00034e9dc Merge tag 'drm-fixes-2022-03-11' of git://ano..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15cf8329700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c9e1a3a8e38b9582
dashboard link: https://syzkaller.appspot.com/bug?extid=b42749a851a47a0f581b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=101cc4ee700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1270b5e9700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b42749a851a47a0f581b-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

BUG: memory leak
unreferenced object 0xffff888103f8fa00 (size 96):
  comm "kworker/u4:0", pid 8, jiffies 4294937736 (age 503.480s)
  hex dump (first 32 bytes):
    40 5d ca 85 ff ff ff ff 38 c8 26 04 81 88 ff ff  @]......8.&.....
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8228f408>] kmalloc include/linux/slab.h:581 [inline]
    [<ffffffff8228f408>] kzalloc include/linux/slab.h:714 [inline]
    [<ffffffff8228f408>] blk_iolatency_init+0x28/0x190 block/blk-iolatency.c:725
    [<ffffffff82285ede>] blkcg_init_queue+0xee/0x1c0 block/blk-cgroup.c:1206
    [<ffffffff8224b1aa>] blk_alloc_queue+0x24a/0x4a0 block/blk-core.c:495
    [<ffffffff822647a5>] blk_mq_init_queue_data block/blk-mq.c:3883 [inline]
    [<ffffffff822647a5>] blk_mq_init_queue+0x35/0x90 block/blk-mq.c:3897
    [<ffffffff8277f2b1>] scsi_alloc_sdev+0x231/0x3b0 drivers/scsi/scsi_scan.c:330
    [<ffffffff82780425>] scsi_probe_and_add_lun+0xff5/0x17e0 drivers/scsi/scsi_scan.c:1167
    [<ffffffff827812df>] __scsi_scan_target+0x14f/0x9a0 drivers/scsi/scsi_scan.c:1649
    [<ffffffff82781da7>] scsi_scan_channel drivers/scsi/scsi_scan.c:1737 [inline]
    [<ffffffff82781da7>] scsi_scan_channel+0xb7/0x100 drivers/scsi/scsi_scan.c:1713
    [<ffffffff82781faf>] scsi_scan_host_selected+0x1bf/0x220 drivers/scsi/scsi_scan.c:1766
    [<ffffffff827820d0>] do_scsi_scan_host+0xc0/0xd0 drivers/scsi/scsi_scan.c:1905
    [<ffffffff82782359>] do_scan_async+0x19/0x200 drivers/scsi/scsi_scan.c:1915
    [<ffffffff8127cff4>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff8126b43f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2307
    [<ffffffff8126bd69>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2454
    [<ffffffff81275725>] kthread+0x125/0x160 kernel/kthread.c:377
    [<ffffffff810021ef>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff888103f8fb00 (size 96):
  comm "kworker/u4:0", pid 8, jiffies 4294937736 (age 503.480s)
  hex dump (first 32 bytes):
    40 5d ca 85 ff ff ff ff c0 c2 26 04 81 88 ff ff  @]........&.....
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8228f408>] kmalloc include/linux/slab.h:581 [inline]
    [<ffffffff8228f408>] kzalloc include/linux/slab.h:714 [inline]
    [<ffffffff8228f408>] blk_iolatency_init+0x28/0x190 block/blk-iolatency.c:725
    [<ffffffff82285ede>] blkcg_init_queue+0xee/0x1c0 block/blk-cgroup.c:1206
    [<ffffffff8224b1aa>] blk_alloc_queue+0x24a/0x4a0 block/blk-core.c:495
    [<ffffffff822647a5>] blk_mq_init_queue_data block/blk-mq.c:3883 [inline]
    [<ffffffff822647a5>] blk_mq_init_queue+0x35/0x90 block/blk-mq.c:3897
    [<ffffffff8277f2b1>] scsi_alloc_sdev+0x231/0x3b0 drivers/scsi/scsi_scan.c:330
    [<ffffffff82780425>] scsi_probe_and_add_lun+0xff5/0x17e0 drivers/scsi/scsi_scan.c:1167
    [<ffffffff827812df>] __scsi_scan_target+0x14f/0x9a0 drivers/scsi/scsi_scan.c:1649
    [<ffffffff82781da7>] scsi_scan_channel drivers/scsi/scsi_scan.c:1737 [inline]
    [<ffffffff82781da7>] scsi_scan_channel+0xb7/0x100 drivers/scsi/scsi_scan.c:1713
    [<ffffffff82781faf>] scsi_scan_host_selected+0x1bf/0x220 drivers/scsi/scsi_scan.c:1766
    [<ffffffff827820d0>] do_scsi_scan_host+0xc0/0xd0 drivers/scsi/scsi_scan.c:1905
    [<ffffffff82782359>] do_scan_async+0x19/0x200 drivers/scsi/scsi_scan.c:1915
    [<ffffffff8127cff4>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff8126b43f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2307
    [<ffffffff8126bd69>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2454
    [<ffffffff81275725>] kthread+0x125/0x160 kernel/kthread.c:377
    [<ffffffff810021ef>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff888103f8fa00 (size 96):
  comm "kworker/u4:0", pid 8, jiffies 4294937736 (age 503.560s)
  hex dump (first 32 bytes):
    40 5d ca 85 ff ff ff ff 38 c8 26 04 81 88 ff ff  @]......8.&.....
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8228f408>] kmalloc include/linux/slab.h:581 [inline]
    [<ffffffff8228f408>] kzalloc include/linux/slab.h:714 [inline]
    [<ffffffff8228f408>] blk_iolatency_init+0x28/0x190 block/blk-iolatency.c:725
    [<ffffffff82285ede>] blkcg_init_queue+0xee/0x1c0 block/blk-cgroup.c:1206
    [<ffffffff8224b1aa>] blk_alloc_queue+0x24a/0x4a0 block/blk-core.c:495
    [<ffffffff822647a5>] blk_mq_init_queue_data block/blk-mq.c:3883 [inline]
    [<ffffffff822647a5>] blk_mq_init_queue+0x35/0x90 block/blk-mq.c:3897
    [<ffffffff8277f2b1>] scsi_alloc_sdev+0x231/0x3b0 drivers/scsi/scsi_scan.c:330
    [<ffffffff82780425>] scsi_probe_and_add_lun+0xff5/0x17e0 drivers/scsi/scsi_scan.c:1167
    [<ffffffff827812df>] __scsi_scan_target+0x14f/0x9a0 drivers/scsi/scsi_scan.c:1649
    [<ffffffff82781da7>] scsi_scan_channel drivers/scsi/scsi_scan.c:1737 [inline]
    [<ffffffff82781da7>] scsi_scan_channel+0xb7/0x100 drivers/scsi/scsi_scan.c:1713
    [<ffffffff82781faf>] scsi_scan_host_selected+0x1bf/0x220 drivers/scsi/scsi_scan.c:1766
    [<ffffffff827820d0>] do_scsi_scan_host+0xc0/0xd0 drivers/scsi/scsi_scan.c:1905
    [<ffffffff82782359>] do_scan_async+0x19/0x200 drivers/scsi/scsi_scan.c:1915
    [<ffffffff8127cff4>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff8126b43f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2307
    [<ffffffff8126bd69>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2454
    [<ffffffff81275725>] kthread+0x125/0x160 kernel/kthread.c:377
    [<ffffffff810021ef>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff888103f8fb00 (size 96):
  comm "kworker/u4:0", pid 8, jiffies 4294937736 (age 503.560s)
  hex dump (first 32 bytes):
    40 5d ca 85 ff ff ff ff c0 c2 26 04 81 88 ff ff  @]........&.....
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8228f408>] kmalloc include/linux/slab.h:581 [inline]
    [<ffffffff8228f408>] kzalloc include/linux/slab.h:714 [inline]
    [<ffffffff8228f408>] blk_iolatency_init+0x28/0x190 block/blk-iolatency.c:725
    [<ffffffff82285ede>] blkcg_init_queue+0xee/0x1c0 block/blk-cgroup.c:1206
    [<ffffffff8224b1aa>] blk_alloc_queue+0x24a/0x4a0 block/blk-core.c:495
    [<ffffffff822647a5>] blk_mq_init_queue_data block/blk-mq.c:3883 [inline]
    [<ffffffff822647a5>] blk_mq_init_queue+0x35/0x90 block/blk-mq.c:3897
    [<ffffffff8277f2b1>] scsi_alloc_sdev+0x231/0x3b0 drivers/scsi/scsi_scan.c:330
    [<ffffffff82780425>] scsi_probe_and_add_lun+0xff5/0x17e0 drivers/scsi/scsi_scan.c:1167
    [<ffffffff827812df>] __scsi_scan_target+0x14f/0x9a0 drivers/scsi/scsi_scan.c:1649
    [<ffffffff82781da7>] scsi_scan_channel drivers/scsi/scsi_scan.c:1737 [inline]
    [<ffffffff82781da7>] scsi_scan_channel+0xb7/0x100 drivers/scsi/scsi_scan.c:1713
    [<ffffffff82781faf>] scsi_scan_host_selected+0x1bf/0x220 drivers/scsi/scsi_scan.c:1766
    [<ffffffff827820d0>] do_scsi_scan_host+0xc0/0xd0 drivers/scsi/scsi_scan.c:1905
    [<ffffffff82782359>] do_scan_async+0x19/0x200 drivers/scsi/scsi_scan.c:1915
    [<ffffffff8127cff4>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff8126b43f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2307
    [<ffffffff8126bd69>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2454
    [<ffffffff81275725>] kthread+0x125/0x160 kernel/kthread.c:377
    [<ffffffff810021ef>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff888103f8fa00 (size 96):
  comm "kworker/u4:0", pid 8, jiffies 4294937736 (age 503.630s)
  hex dump (first 32 bytes):
    40 5d ca 85 ff ff ff ff 38 c8 26 04 81 88 ff ff  @]......8.&.....
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8228f408>] kmalloc include/linux/slab.h:581 [inline]
    [<ffffffff8228f408>] kzalloc include/linux/slab.h:714 [inline]
    [<ffffffff8228f408>] blk_iolatency_init+0x28/0x190 block/blk-iolatency.c:725
    [<ffffffff82285ede>] blkcg_init_queue+0xee/0x1c0 block/blk-cgroup.c:1206
    [<ffffffff8224b1aa>] blk_alloc_queue+0x24a/0x4a0 block/blk-core.c:495
    [<ffffffff822647a5>] blk_mq_init_queue_data block/blk-mq.c:3883 [inline]
    [<ffffffff822647a5>] blk_mq_init_queue+0x35/0x90 block/blk-mq.c:3897
    [<ffffffff8277f2b1>] scsi_alloc_sdev+0x231/0x3b0 drivers/scsi/scsi_scan.c:330
    [<ffffffff82780425>] scsi_probe_and_add_lun+0xff5/0x17e0 drivers/scsi/scsi_scan.c:1167
    [<ffffffff827812df>] __scsi_scan_target+0x14f/0x9a0 drivers/scsi/scsi_scan.c:1649
    [<ffffffff82781da7>] scsi_scan_channel drivers/scsi/scsi_scan.c:1737 [inline]
    [<ffffffff82781da7>] scsi_scan_channel+0xb7/0x100 drivers/scsi/scsi_scan.c:1713
    [<ffffffff82781faf>] scsi_scan_host_selected+0x1bf/0x220 drivers/scsi/scsi_scan.c:1766
    [<ffffffff827820d0>] do_scsi_scan_host+0xc0/0xd0 drivers/scsi/scsi_scan.c:1905
    [<ffffffff82782359>] do_scan_async+0x19/0x200 drivers/scsi/scsi_scan.c:1915
    [<ffffffff8127cff4>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff8126b43f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2307
    [<ffffffff8126bd69>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2454
    [<ffffffff81275725>] kthread+0x125/0x160 kernel/kthread.c:377
    [<ffffffff810021ef>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff888103f8fb00 (size 96):
  comm "kworker/u4:0", pid 8, jiffies 4294937736 (age 503.630s)
  hex dump (first 32 bytes):
    40 5d ca 85 ff ff ff ff c0 c2 26 04 81 88 ff ff  @]........&.....
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8228f408>] kmalloc include/linux/slab.h:581 [inline]
    [<ffffffff8228f408>] kzalloc include/linux/slab.h:714 [inline]
    [<ffffffff8228f408>] blk_iolatency_init+0x28/0x190 block/blk-iolatency.c:725
    [<ffffffff82285ede>] blkcg_init_queue+0xee/0x1c0 block/blk-cgroup.c:1206
    [<ffffffff8224b1aa>] blk_alloc_queue+0x24a/0x4a0 block/blk-core.c:495
    [<ffffffff822647a5>] blk_mq_init_queue_data block/blk-mq.c:3883 [inline]
    [<ffffffff822647a5>] blk_mq_init_queue+0x35/0x90 block/blk-mq.c:3897
    [<ffffffff8277f2b1>] scsi_alloc_sdev+0x231/0x3b0 drivers/scsi/scsi_scan.c:330
    [<ffffffff82780425>] scsi_probe_and_add_lun+0xff5/0x17e0 drivers/scsi/scsi_scan.c:1167
    [<ffffffff827812df>] __scsi_scan_target+0x14f/0x9a0 drivers/scsi/scsi_scan.c:1649
    [<ffffffff82781da7>] scsi_scan_channel drivers/scsi/scsi_scan.c:1737 [inline]
    [<ffffffff82781da7>] scsi_scan_channel+0xb7/0x100 drivers/scsi/scsi_scan.c:1713
    [<ffffffff82781faf>] scsi_scan_host_selected+0x1bf/0x220 drivers/scsi/scsi_scan.c:1766
    [<ffffffff827820d0>] do_scsi_scan_host+0xc0/0xd0 drivers/scsi/scsi_scan.c:1905
    [<ffffffff82782359>] do_scan_async+0x19/0x200 drivers/scsi/scsi_scan.c:1915
    [<ffffffff8127cff4>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff8126b43f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2307
    [<ffffffff8126bd69>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2454
    [<ffffffff81275725>] kthread+0x125/0x160 kernel/kthread.c:377
    [<ffffffff810021ef>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff888103f8fa00 (size 96):
  comm "kworker/u4:0", pid 8, jiffies 4294937736 (age 503.700s)
  hex dump (first 32 bytes):
    40 5d ca 85 ff ff ff ff 38 c8 26 04 81 88 ff ff  @]......8.&.....
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8228f408>] kmalloc include/linux/slab.h:581 [inline]
    [<ffffffff8228f408>] kzalloc include/linux/slab.h:714 [inline]
    [<ffffffff8228f408>] blk_iolatency_init+0x28/0x190 block/blk-iolatency.c:725
    [<ffffffff82285ede>] blkcg_init_queue+0xee/0x1c0 block/blk-cgroup.c:1206
    [<ffffffff8224b1aa>] blk_alloc_queue+0x24a/0x4a0 block/blk-core.c:495
    [<ffffffff822647a5>] blk_mq_init_queue_data block/blk-mq.c:3883 [inline]
    [<ffffffff822647a5>] blk_mq_init_queue+0x35/0x90 block/blk-mq.c:3897
    [<ffffffff8277f2b1>] scsi_alloc_sdev+0x231/0x3b0 drivers/scsi/scsi_scan.c:330
    [<ffffffff82780425>] scsi_probe_and_add_lun+0xff5/0x17e0 drivers/scsi/scsi_scan.c:1167
    [<ffffffff827812df>] __scsi_scan_target+0x14f/0x9a0 drivers/scsi/scsi_scan.c:1649
    [<ffffffff82781da7>] scsi_scan_channel drivers/scsi/scsi_scan.c:1737 [inline]
    [<ffffffff82781da7>] scsi_scan_channel+0xb7/0x100 drivers/scsi/scsi_scan.c:1713
    [<ffffffff82781faf>] scsi_scan_host_selected+0x1bf/0x220 drivers/scsi/scsi_scan.c:1766
    [<ffffffff827820d0>] do_scsi_scan_host+0xc0/0xd0 drivers/scsi/scsi_scan.c:1905
    [<ffffffff82782359>] do_scan_async+0x19/0x200 drivers/scsi/scsi_scan.c:1915
    [<ffffffff8127cff4>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff8126b43f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2307
    [<ffffffff8126bd69>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2454
    [<ffffffff81275725>] kthread+0x125/0x160 kernel/kthread.c:377
    [<ffffffff810021ef>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff888103f8fb00 (size 96):
  comm "kworker/u4:0", pid 8, jiffies 4294937736 (age 503.700s)
  hex dump (first 32 bytes):
    40 5d ca 85 ff ff ff ff c0 c2 26 04 81 88 ff ff  @]........&.....
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8228f408>] kmalloc include/linux/slab.h:581 [inline]
    [<ffffffff8228f408>] kzalloc include/linux/slab.h:714 [inline]
    [<ffffffff8228f408>] blk_iolatency_init+0x28/0x190 block/blk-iolatency.c:725
    [<ffffffff82285ede>] blkcg_init_queue+0xee/0x1c0 block/blk-cgroup.c:1206
    [<ffffffff8224b1aa>] blk_alloc_queue+0x24a/0x4a0 block/blk-core.c:495
    [<ffffffff822647a5>] blk_mq_init_queue_data block/blk-mq.c:3883 [inline]
    [<ffffffff822647a5>] blk_mq_init_queue+0x35/0x90 block/blk-mq.c:3897
    [<ffffffff8277f2b1>] scsi_alloc_sdev+0x231/0x3b0 drivers/scsi/scsi_scan.c:330
    [<ffffffff82780425>] scsi_probe_and_add_lun+0xff5/0x17e0 drivers/scsi/scsi_scan.c:1167
    [<ffffffff827812df>] __scsi_scan_target+0x14f/0x9a0 drivers/scsi/scsi_scan.c:1649
    [<ffffffff82781da7>] scsi_scan_channel drivers/scsi/scsi_scan.c:1737 [inline]
    [<ffffffff82781da7>] scsi_scan_channel+0xb7/0x100 drivers/scsi/scsi_scan.c:1713
    [<ffffffff82781faf>] scsi_scan_host_selected+0x1bf/0x220 drivers/scsi/scsi_scan.c:1766
    [<ffffffff827820d0>] do_scsi_scan_host+0xc0/0xd0 drivers/scsi/scsi_scan.c:1905
    [<ffffffff82782359>] do_scan_async+0x19/0x200 drivers/scsi/scsi_scan.c:1915
    [<ffffffff8127cff4>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff8126b43f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2307
    [<ffffffff8126bd69>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2454
    [<ffffffff81275725>] kthread+0x125/0x160 kernel/kthread.c:377
    [<ffffffff810021ef>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff888103f8fa00 (size 96):
  comm "kworker/u4:0", pid 8, jiffies 4294937736 (age 503.770s)
  hex dump (first 32 bytes):
    40 5d ca 85 ff ff ff ff 38 c8 26 04 81 88 ff ff  @]......8.&.....
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8228f408>] kmalloc include/linux/slab.h:581 [inline]
    [<ffffffff8228f408>] kzalloc include/linux/slab.h:714 [inline]
    [<ffffffff8228f408>] blk_iolatency_init+0x28/0x190 block/blk-iolatency.c:725
    [<ffffffff82285ede>] blkcg_init_queue+0xee/0x1c0 block/blk-cgroup.c:1206
    [<ffffffff8224b1aa>] blk_alloc_queue+0x24a/0x4a0 block/blk-core.c:495
    [<ffffffff822647a5>] blk_mq_init_queue_data block/blk-mq.c:3883 [inline]
    [<ffffffff822647a5>] blk_mq_init_queue+0x35/0x90 block/blk-mq.c:3897
    [<ffffffff8277f2b1>] scsi_alloc_sdev+0x231/0x3b0 drivers/scsi/scsi_scan.c:330
    [<ffffffff82780425>] scsi_probe_and_add_lun+0xff5/0x17e0 drivers/scsi/scsi_scan.c:1167
    [<ffffffff827812df>] __scsi_scan_target+0x14f/0x9a0 drivers/scsi/scsi_scan.c:1649
    [<ffffffff82781da7>] scsi_scan_channel drivers/scsi/scsi_scan.c:1737 [inline]
    [<ffffffff82781da7>] scsi_scan_channel+0xb7/0x100 drivers/scsi/scsi_scan.c:1713
    [<ffffffff82781faf>] scsi_scan_host_selected+0x1bf/0x220 drivers/scsi/scsi_scan.c:1766
    [<ffffffff827820d0>] do_scsi_scan_host+0xc0/0xd0 drivers/scsi/scsi_scan.c:1905
    [<ffffffff82782359>] do_scan_async+0x19/0x200 drivers/scsi/scsi_scan.c:1915
    [<ffffffff8127cff4>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff8126b43f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2307
    [<ffffffff8126bd69>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2454
    [<ffffffff81275725>] kthread+0x125/0x160 kernel/kthread.c:377
    [<ffffffff810021ef>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff888103f8fb00 (size 96):
  comm "kworker/u4:0", pid 8, jiffies 4294937736 (age 503.770s)
  hex dump (first 32 bytes):
    40 5d ca 85 ff ff ff ff c0 c2 26 04 81 88 ff ff  @]........&.....
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8228f408>] kmalloc include/linux/slab.h:581 [inline]
    [<ffffffff8228f408>] kzalloc include/linux/slab.h:714 [inline]
    [<ffffffff8228f408>] blk_iolatency_init+0x28/0x190 block/blk-iolatency.c:725
    [<ffffffff82285ede>] blkcg_init_queue+0xee/0x1c0 block/blk-cgroup.c:1206
    [<ffffffff8224b1aa>] blk_alloc_queue+0x24a/0x4a0 block/blk-core.c:495
    [<ffffffff822647a5>] blk_mq_init_queue_data block/blk-mq.c:3883 [inline]
    [<ffffffff822647a5>] blk_mq_init_queue+0x35/0x90 block/blk-mq.c:3897
    [<ffffffff8277f2b1>] scsi_alloc_sdev+0x231/0x3b0 drivers/scsi/scsi_scan.c:330
    [<ffffffff82780425>] scsi_probe_and_add_lun+0xff5/0x17e0 drivers/scsi/scsi_scan.c:1167
    [<ffffffff827812df>] __scsi_scan_target+0x14f/0x9a0 drivers/scsi/scsi_scan.c:1649
    [<ffffffff82781da7>] scsi_scan_channel drivers/scsi/scsi_scan.c:1737 [inline]
    [<ffffffff82781da7>] scsi_scan_channel+0xb7/0x100 drivers/scsi/scsi_scan.c:1713
    [<ffffffff82781faf>] scsi_scan_host_selected+0x1bf/0x220 drivers/scsi/scsi_scan.c:1766
    [<ffffffff827820d0>] do_scsi_scan_host+0xc0/0xd0 drivers/scsi/scsi_scan.c:1905
    [<ffffffff82782359>] do_scan_async+0x19/0x200 drivers/scsi/scsi_scan.c:1915
    [<ffffffff8127cff4>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff8126b43f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2307
    [<ffffffff8126bd69>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2454
    [<ffffffff81275725>] kthread+0x125/0x160 kernel/kthread.c:377
    [<ffffffff810021ef>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff888103f8fa00 (size 96):
  comm "kworker/u4:0", pid 8, jiffies 4294937736 (age 503.850s)
  hex dump (first 32 bytes):
    40 5d ca 85 ff ff ff ff 38 c8 26 04 81 88 ff ff  @]......8.&.....
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8228f408>] kmalloc include/linux/slab.h:581 [inline]
    [<ffffffff8228f408>] kzalloc include/linux/slab.h:714 [inline]
    [<ffffffff8228f408>] blk_iolatency_init+0x28/0x190 block/blk-iolatency.c:725
    [<ffffffff82285ede>] blkcg_init_queue+0xee/0x1c0 block/blk-cgroup.c:1206
    [<ffffffff8224b1aa>] blk_alloc_queue+0x24a/0x4a0 block/blk-core.c:495
    [<ffffffff822647a5>] blk_mq_init_queue_data block/blk-mq.c:3883 [inline]
    [<ffffffff822647a5>] blk_mq_init_queue+0x35/0x90 block/blk-mq.c:3897
    [<ffffffff8277f2b1>] scsi_alloc_sdev+0x231/0x3b0 drivers/scsi/scsi_scan.c:330
    [<ffffffff82780425>] scsi_probe_and_add_lun+0xff5/0x17e0 drivers/scsi/scsi_scan.c:1167
    [<ffffffff827812df>] __scsi_scan_target+0x14f/0x9a0 drivers/scsi/scsi_scan.c:1649
    [<ffffffff82781da7>] scsi_scan_channel drivers/scsi/scsi_scan.c:1737 [inline]
    [<ffffffff82781da7>] scsi_scan_channel+0xb7/0x100 drivers/scsi/scsi_scan.c:1713
    [<ffffffff82781faf>] scsi_scan_host_selected+0x1bf/0x220 drivers/scsi/scsi_scan.c:1766
    [<ffffffff827820d0>] do_scsi_scan_host+0xc0/0xd0 drivers/scsi/scsi_scan.c:1905
    [<ffffffff82782359>] do_scan_async+0x19/0x200 drivers/scsi/scsi_scan.c:1915
    [<ffffffff8127cff4>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff8126b43f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2307
    [<ffffffff8126bd69>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2454
    [<ffffffff81275725>] kthread+0x125/0x160 kernel/kthread.c:377
    [<ffffffff810021ef>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff888103f8fb00 (size 96):
  comm "kworker/u4:0", pid 8, jiffies 4294937736 (age 503.850s)
  hex dump (first 32 bytes):
    40 5d ca 85 ff ff ff ff c0 c2 26 04 81 88 ff ff  @]........&.....
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8228f408>] kmalloc include/linux/slab.h:581 [inline]
    [<ffffffff8228f408>] kzalloc include/linux/slab.h:714 [inline]
    [<ffffffff8228f408>] blk_iolatency_init+0x28/0x190 block/blk-iolatency.c:725
    [<ffffffff82285ede>] blkcg_init_queue+0xee/0x1c0 block/blk-cgroup.c:1206
    [<ffffffff8224b1aa>] blk_alloc_queue+0x24a/0x4a0 block/blk-core.c:495
    [<ffffffff822647a5>] blk_mq_init_queue_data block/blk-mq.c:3883 [inline]
    [<ffffffff822647a5>] blk_mq_init_queue+0x35/0x90 block/blk-mq.c:3897
    [<ffffffff8277f2b1>] scsi_alloc_sdev+0x231/0x3b0 drivers/scsi/scsi_scan.c:330
    [<ffffffff82780425>] scsi_probe_and_add_lun+0xff5/0x17e0 drivers/scsi/scsi_scan.c:1167
    [<ffffffff827812df>] __scsi_scan_target+0x14f/0x9a0 drivers/scsi/scsi_scan.c:1649
    [<ffffffff82781da7>] scsi_scan_channel drivers/scsi/scsi_scan.c:1737 [inline]
    [<ffffffff82781da7>] scsi_scan_channel+0xb7/0x100 drivers/scsi/scsi_scan.c:1713
    [<ffffffff82781faf>] scsi_scan_host_selected+0x1bf/0x220 drivers/scsi/scsi_scan.c:1766
    [<ffffffff827820d0>] do_scsi_scan_host+0xc0/0xd0 drivers/scsi/scsi_scan.c:1905
    [<ffffffff82782359>] do_scan_async+0x19/0x200 drivers/scsi/scsi_scan.c:1915
    [<ffffffff8127cff4>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff8126b43f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2307
    [<ffffffff8126bd69>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2454
    [<ffffffff81275725>] kthread+0x125/0x160 kernel/kthread.c:377
    [<ffffffff810021ef>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff888103f8fa00 (size 96):
  comm "kworker/u4:0", pid 8, jiffies 4294937736 (age 503.920s)
  hex dump (first 32 bytes):
    40 5d ca 85 ff ff ff ff 38 c8 26 04 81 88 ff ff  @]......8.&.....
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8228f408>] kmalloc include/linux/slab.h:581 [inline]
    [<ffffffff8228f408>] kzalloc include/linux/slab.h:714 [inline]
    [<ffffffff8228f408>] blk_iolatency_init+0x28/0x190 block/blk-iolatency.c:725
    [<ffffffff82285ede>] blkcg_init_queue+0xee/0x1c0 block/blk-cgroup.c:1206
    [<ffffffff8224b1aa>] blk_alloc_queue+0x24a/0x4a0 block/blk-core.c:495
    [<ffffffff822647a5>] blk_mq_init_queue_data block/blk-mq.c:3883 [inline]
    [<ffffffff822647a5>] blk_mq_init_queue+0x35/0x90 block/blk-mq.c:3897
    [<ffffffff8277f2b1>] scsi_alloc_sdev+0x231/0x3b0 drivers/scsi/scsi_scan.c:330
    [<ffffffff82780425>] scsi_probe_and_add_lun+0xff5/0x17e0 drivers/scsi/scsi_scan.c:1167
    [<ffffffff827812df>] __scsi_scan_target+0x14f/0x9a0 drivers/scsi/scsi_scan.c:1649
    [<ffffffff82781da7>] scsi_scan_channel drivers/scsi/scsi_scan.c:1737 [inline]
    [<ffffffff82781da7>] scsi_scan_channel+0xb7/0x100 drivers/scsi/scsi_scan.c:1713
    [<ffffffff82781faf>] scsi_scan_host_selected+0x1bf/0x220 drivers/scsi/scsi_scan.c:1766
    [<ffffffff827820d0>] do_scsi_scan_host+0xc0/0xd0 drivers/scsi/scsi_scan.c:1905
    [<ffffffff82782359>] do_scan_async+0x19/0x200 drivers/scsi/scsi_scan.c:1915
    [<ffffffff8127cff4>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff8126b43f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2307
    [<ffffffff8126bd69>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2454
    [<ffffffff81275725>] kthread+0x125/0x160 kernel/kthread.c:377
    [<ffffffff810021ef>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff888103f8fb00 (size 96):
  comm "kworker/u4:0", pid 8, jiffies 4294937736 (age 503.920s)
  hex dump (first 32 bytes):
    40 5d ca 85 ff ff ff ff c0 c2 26 04 81 88 ff ff  @]........&.....
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8228f408>] kmalloc include/linux/slab.h:581 [inline]
    [<ffffffff8228f408>] kzalloc include/linux/slab.h:714 [inline]
    [<ffffffff8228f408>] blk_iolatency_init+0x28/0x190 block/blk-iolatency.c:725
    [<ffffffff82285ede>] blkcg_init_queue+0xee/0x1c0 block/blk-cgroup.c:1206
    [<ffffffff8224b1aa>] blk_alloc_queue+0x24a/0x4a0 block/blk-core.c:495
    [<ffffffff822647a5>] blk_mq_init_queue_data block/blk-mq.c:3883 [inline]
    [<ffffffff822647a5>] blk_mq_init_queue+0x35/0x90 block/blk-mq.c:3897
    [<ffffffff8277f2b1>] scsi_alloc_sdev+0x231/0x3b0 drivers/scsi/scsi_scan.c:330
    [<ffffffff82780425>] scsi_probe_and_add_lun+0xff5/0x17e0 drivers/scsi/scsi_scan.c:1167
    [<ffffffff827812df>] __scsi_scan_target+0x14f/0x9a0 drivers/scsi/scsi_scan.c:1649
    [<ffffffff82781da7>] scsi_scan_channel drivers/scsi/scsi_scan.c:1737 [inline]
    [<ffffffff82781da7>] scsi_scan_channel+0xb7/0x100 drivers/scsi/scsi_scan.c:1713
    [<ffffffff82781faf>] scsi_scan_host_selected+0x1bf/0x220 drivers/scsi/scsi_scan.c:1766
    [<ffffffff827820d0>] do_scsi_scan_host+0xc0/0xd0 drivers/scsi/scsi_scan.c:1905
    [<ffffffff82782359>] do_scan_async+0x19/0x200 drivers/scsi/scsi_scan.c:1915
    [<ffffffff8127cff4>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff8126b43f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2307
    [<ffffffff8126bd69>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2454
    [<ffffffff81275725>] kthread+0x125/0x160 kernel/kthread.c:377
    [<ffffffff810021ef>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff888103f8fa00 (size 96):
  comm "kworker/u4:0", pid 8, jiffies 4294937736 (age 504.000s)
  hex dump (first 32 bytes):
    40 5d ca 85 ff ff ff ff 38 c8 26 04 81 88 ff ff  @]......8.&.....
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8228f408>] kmalloc include/linux/slab.h:581 [inline]
    [<ffffffff8228f408>] kzalloc include/linux/slab.h:714 [inline]
    [<ffffffff8228f408>] blk_iolatency_init+0x28/0x190 block/blk-iolatency.c:725
    [<ffffffff82285ede>] blkcg_init_queue+0xee/0x1c0 block/blk-cgroup.c:1206
    [<ffffffff8224b1aa>] blk_alloc_queue+0x24a/0x4a0 block/blk-core.c:495
    [<ffffffff822647a5>] blk_mq_init_queue_data block/blk-mq.c:3883 [inline]
    [<ffffffff822647a5>] blk_mq_init_queue+0x35/0x90 block/blk-mq.c:3897
    [<ffffffff8277f2b1>] scsi_alloc_sdev+0x231/0x3b0 drivers/scsi/scsi_scan.c:330
    [<ffffffff82780425>] scsi_probe_and_add_lun+0xff5/0x17e0 drivers/scsi/scsi_scan.c:1167
    [<ffffffff827812df>] __scsi_scan_target+0x14f/0x9a0 drivers/scsi/scsi_scan.c:1649
    [<ffffffff82781da7>] scsi_scan_channel drivers/scsi/scsi_scan.c:1737 [inline]
    [<ffffffff82781da7>] scsi_scan_channel+0xb7/0x100 drivers/scsi/scsi_scan.c:1713
    [<ffffffff82781faf>] scsi_scan_host_selected+0x1bf/0x220 drivers/scsi/scsi_scan.c:1766
    [<ffffffff827820d0>] do_scsi_scan_host+0xc0/0xd0 drivers/scsi/scsi_scan.c:1905
    [<ffffffff82782359>] do_scan_async+0x19/0x200 drivers/scsi/scsi_scan.c:1915
    [<ffffffff8127cff4>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff8126b43f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2307
    [<ffffffff8126bd69>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2454
    [<ffffffff81275725>] kthread+0x125/0x160 kernel/kthread.c:377
    [<ffffffff810021ef>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff888103f8fb00 (size 96):
  comm "kworker/u4:0", pid 8, jiffies 4294937736 (age 504.000s)
  hex dump (first 32 bytes):
    40 5d ca 85 ff ff ff ff c0 c2 26 04 81 88 ff ff  @]........&.....
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8228f408>] kmalloc include/linux/slab.h:581 [inline]
    [<ffffffff8228f408>] kzalloc include/linux/slab.h:714 [inline]
    [<ffffffff8228f408>] blk_iolatency_init+0x28/0x190 block/blk-iolatency.c:725
    [<ffffffff82285ede>] blkcg_init_queue+0xee/0x1c0 block/blk-cgroup.c:1206
    [<ffffffff8224b1aa>] blk_alloc_queue+0x24a/0x4a0 block/blk-core.c:495
    [<ffffffff822647a5>] blk_mq_init_queue_data block/blk-mq.c:3883 [inline]
    [<ffffffff822647a5>] blk_mq_init_queue+0x35/0x90 block/blk-mq.c:3897
    [<ffffffff8277f2b1>] scsi_alloc_sdev+0x231/0x3b0 drivers/scsi/scsi_scan.c:330
    [<ffffffff82780425>] scsi_probe_and_add_lun+0xff5/0x17e0 drivers/scsi/scsi_scan.c:1167
    [<ffffffff827812df>] __scsi_scan_target+0x14f/0x9a0 drivers/scsi/scsi_scan.c:1649
    [<ffffffff82781da7>] scsi_scan_channel drivers/scsi/scsi_scan.c:1737 [inline]
    [<ffffffff82781da7>] scsi_scan_channel+0xb7/0x100 drivers/scsi/scsi_scan.c:1713
    [<ffffffff82781faf>] scsi_scan_host_selected+0x1bf/0x220 drivers/scsi/scsi_scan.c:1766
    [<ffffffff827820d0>] do_scsi_scan_host+0xc0/0xd0 drivers/scsi/scsi_scan.c:1905
    [<ffffffff82782359>] do_scan_async+0x19/0x200 drivers/scsi/scsi_scan.c:1915
    [<ffffffff8127cff4>] async_run_entry_fn+0x24/0xf0 kernel/async.c:127
    [<ffffffff8126b43f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2307
    [<ffffffff8126bd69>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2454
    [<ffffffff81275725>] kthread+0x125/0x160 kernel/kthread.c:377
    [<ffffffff810021ef>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
