From: Yanfei Xu <yanfei.xu-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Subject: [PATCH] blkcg: fix memory leak in blk_iolatency_init
Date: Wed, 15 Sep 2021 15:24:26 +0800
Message-ID: <20210915072426.4022924-1-yanfei.xu@windriver.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=9aNtL+I//91GWdN0xvnAGwpNeIQvwixdOdyIGWfVgZ4=;
 b=QmiP17vs7wLjCV6/JiCEmT/5VMMQl+VUasCQDdxodan1eVbAt4q3GWrXrJq9qr7EvvmB
 9cx/6YEiZc//g/CdSR/zKnY8AjftK+faoAVzS0blkIZz8umV9W6T2qKroalmUQaNpmoz
 eQnoElHyYQf6l0T9+a/wzoNZIkC6q3oyWthQpqNs8vgcM6sQU3uprarxjXmCZKAKeGyK
 thFTFBcFUqLfUhDtNLx4QAlZ1uTHcsQWbTnj8Fp2XIM/02ea5P5kFxQa1FksyrvKd0l2
 QEK6qycQayoMyty5deAfAHTivU3igU9JWPp6Pg8OM/DLS7BmUCzDiNrQokE93CeKtLfh UQ== 
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

BUG: memory leak
unreferenced object 0xffff888129acdb80 (size 96):
  comm "syz-executor.1", pid 12661, jiffies 4294962682 (age 15.220s)
  hex dump (first 32 bytes):
    20 47 c9 85 ff ff ff ff 20 d4 8e 29 81 88 ff ff   G...... ..)....
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff82264ec8>] kmalloc include/linux/slab.h:591 [inline]
    [<ffffffff82264ec8>] kzalloc include/linux/slab.h:721 [inline]
    [<ffffffff82264ec8>] blk_iolatency_init+0x28/0x190 block/blk-iolatency.c:724
    [<ffffffff8225b8c4>] blkcg_init_queue+0xb4/0x1c0 block/blk-cgroup.c:1185
    [<ffffffff822253da>] blk_alloc_queue+0x22a/0x2e0 block/blk-core.c:566
    [<ffffffff8223b175>] blk_mq_init_queue_data block/blk-mq.c:3100 [inline]
    [<ffffffff8223b175>] __blk_mq_alloc_disk+0x25/0xd0 block/blk-mq.c:3124
    [<ffffffff826a9303>] loop_add+0x1c3/0x360 drivers/block/loop.c:2344
    [<ffffffff826a966e>] loop_control_get_free drivers/block/loop.c:2501 [inline]
    [<ffffffff826a966e>] loop_control_ioctl+0x17e/0x2e0 drivers/block/loop.c:2516
    [<ffffffff81597eec>] vfs_ioctl fs/ioctl.c:51 [inline]
    [<ffffffff81597eec>] __do_sys_ioctl fs/ioctl.c:874 [inline]
    [<ffffffff81597eec>] __se_sys_ioctl fs/ioctl.c:860 [inline]
    [<ffffffff81597eec>] __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:860
    [<ffffffff843fa745>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff843fa745>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Once blk_throtl_init() queue init failed, blkcg_iolatency_exit() will
not be invoked for cleanup. That leads a memory leak. Swap the
blk_throtl_init() and blk_iolatency_init() calls can solve this.

Reported-by: syzbot+01321b15cc98e6bf96d6-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Fixes: 19688d7f9592 (block/blk-cgroup: Swap the blk_throtl_init() and blk_iolatency_init() calls)
Signed-off-by: Yanfei Xu <yanfei.xu-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
---
 block/blk-cgroup.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 3c88a79a319b..1ded4181a6de 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1182,10 +1182,6 @@ int blkcg_init_queue(struct request_queue *q)
 	if (preloaded)
 		radix_tree_preload_end();
 
-	ret = blk_iolatency_init(q);
-	if (ret)
-		goto err_destroy_all;
-
 	ret = blk_ioprio_init(q);
 	if (ret)
 		goto err_destroy_all;
@@ -1194,6 +1190,12 @@ int blkcg_init_queue(struct request_queue *q)
 	if (ret)
 		goto err_destroy_all;
 
+	ret = blk_iolatency_init(q);
+	if (ret) {
+		blk_throtl_exit(q);
+		goto err_destroy_all;
+	}
+
 	return 0;
 
 err_destroy_all:
-- 
2.27.0

