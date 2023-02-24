From: Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] blk-iocost: initialize rqos before accessing it
Date: Fri, 24 Feb 2023 08:07:14 -0800
Message-ID: <20230224160714.172884-1-leitao@debian.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: aherrmann-l3A5Bk7waGM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, leit-b10kYP2dOMg@public.gmane.org

Current kernel (d2980d8d826554fa6981d621e569a453787472f8) crashes
when blk_iocost_init for `nvme1` disk.

	BUG: kernel NULL pointer dereference, address: 0000000000000050
	#PF: supervisor read access in kernel mode
	#PF: error_code(0x0000) - not-present page

	blk_iocost_init (include/asm-generic/qspinlock.h:128
			 include/linux/spinlock.h:203
			 include/linux/spinlock_api_smp.h:158
			 include/linux/spinlock.h:400
			 block/blk-iocost.c:2884)
	ioc_qos_write (block/blk-iocost.c:3198)
	? kretprobe_perf_func (kernel/trace/trace_kprobe.c:1566)
	? kernfs_fop_write_iter (include/linux/slab.h:584 fs/kernfs/file.c:311)
	? __kmem_cache_alloc_node (mm/slab.h:? mm/slub.c:3452 mm/slub.c:3491)
	? _copy_from_iter (arch/x86/include/asm/uaccess_64.h:46
			   arch/x86/include/asm/uaccess_64.h:52
			   lib/iov_iter.c:183 lib/iov_iter.c:628)
	? kretprobe_dispatcher (kernel/trace/trace_kprobe.c:1693)
	cgroup_file_write (kernel/cgroup/cgroup.c:4061)
	kernfs_fop_write_iter (fs/kernfs/file.c:334)
	vfs_write (include/linux/fs.h:1849 fs/read_write.c:491
		   fs/read_write.c:584)
	ksys_write (fs/read_write.c:637)
	do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
	entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)

This happens because ioc_refresh_params() is being called without
a properly initialized ioc->rqos, which is happening later.

ioc_refresh_params() -> ioc_autop_idx() tries to access
ioc->rqos.disk->queue but ioc->rqos.disk is NULL, causing the BUG above.

Move the ioc_refresh_params() call to after rqos is populated
(rq_qos_add).

Fixes: ce57b558604e ("blk-rq-qos: make rq_qos_add and rq_qos_del more useful")

Signed-off-by: Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
---
 block/blk-iocost.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index ff534e9d92dc..6cced8a76e9c 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2878,11 +2878,6 @@ static int blk_iocost_init(struct gendisk *disk)
 	atomic64_set(&ioc->cur_period, 0);
 	atomic_set(&ioc->hweight_gen, 0);
 
-	spin_lock_irq(&ioc->lock);
-	ioc->autop_idx = AUTOP_INVALID;
-	ioc_refresh_params(ioc, true);
-	spin_unlock_irq(&ioc->lock);
-
 	/*
 	 * rqos must be added before activation to allow ioc_pd_init() to
 	 * lookup the ioc from q. This means that the rqos methods may get
@@ -2893,6 +2888,11 @@ static int blk_iocost_init(struct gendisk *disk)
 	if (ret)
 		goto err_free_ioc;
 
+	spin_lock_irq(&ioc->lock);
+	ioc->autop_idx = AUTOP_INVALID;
+	ioc_refresh_params(ioc, true);
+	spin_unlock_irq(&ioc->lock);
+
 	ret = blkcg_activate_policy(disk, &blkcg_policy_iocost);
 	if (ret)
 		goto err_del_qos;
-- 
2.30.2

