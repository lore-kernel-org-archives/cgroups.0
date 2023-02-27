From: Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2] blk-iocost: Pass disk queue to ioc_refresh_params
Date: Mon, 27 Feb 2023 05:56:10 -0800
Message-ID: <20230227135610.501884-1-leitao@debian.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: aherrmann-l3A5Bk7waGM@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, leit-b10kYP2dOMg@public.gmane.org

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
a properly initialized ioc->rqos, which is happening later in the callee
side.

ioc_refresh_params() -> ioc_autop_idx() tries to access
ioc->rqos.disk->queue but ioc->rqos.disk is NULL, causing the BUG above.

Create a function that is similar to ioc_refresh_params() but where the
"struct request_queue" could be passed as an explicit argument. This
function will be called when ioc->rqos.disk->queue could not be trusted.

Fixes: ce57b558604e ("blk-rq-qos: make rq_qos_add and rq_qos_del more useful")

Signed-off-by: Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
---
 block/blk-iocost.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

---
Changes in v2:
- Pass the struct request_queue explictly to ioc_refresh_params()

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index ff534e9d92dc..28f9b802241d 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -800,7 +800,7 @@ static void ioc_refresh_period_us(struct ioc *ioc)
 	ioc_refresh_margins(ioc);
 }
 
-static int ioc_autop_idx(struct ioc *ioc)
+static int ioc_autop_idx(struct ioc *ioc, struct request_queue *queue)
 {
 	int idx = ioc->autop_idx;
 	const struct ioc_params *p = &autop[idx];
@@ -808,11 +808,11 @@ static int ioc_autop_idx(struct ioc *ioc)
 	u64 now_ns;
 
 	/* rotational? */
-	if (!blk_queue_nonrot(ioc->rqos.disk->queue))
+	if (!blk_queue_nonrot(queue))
 		return AUTOP_HDD;
 
 	/* handle SATA SSDs w/ broken NCQ */
-	if (blk_queue_depth(ioc->rqos.disk->queue) == 1)
+	if (blk_queue_depth(queue) == 1)
 		return AUTOP_SSD_QD1;
 
 	/* use one of the normal ssd sets */
@@ -901,14 +901,19 @@ static void ioc_refresh_lcoefs(struct ioc *ioc)
 		    &c[LCOEF_WPAGE], &c[LCOEF_WSEQIO], &c[LCOEF_WRANDIO]);
 }
 
-static bool ioc_refresh_params(struct ioc *ioc, bool force)
+/*
+ * struct request_queue is required as an argument because ioc->rqos.disk->queue
+ * might not be properly initialized
+ */
+static bool _ioc_refresh_params(struct ioc *ioc, bool force,
+				struct request_queue *queue)
 {
 	const struct ioc_params *p;
 	int idx;
 
 	lockdep_assert_held(&ioc->lock);
 
-	idx = ioc_autop_idx(ioc);
+	idx = ioc_autop_idx(ioc, queue);
 	p = &autop[idx];
 
 	if (idx == ioc->autop_idx && !force)
@@ -939,6 +944,11 @@ static bool ioc_refresh_params(struct ioc *ioc, bool force)
 	return true;
 }
 
+static bool ioc_refresh_params(struct ioc *ioc, bool force)
+{
+	return _ioc_refresh_params(ioc, force, ioc->rqos.disk->queue);
+}
+
 /*
  * When an iocg accumulates too much vtime or gets deactivated, we throw away
  * some vtime, which lowers the overall device utilization. As the exact amount
@@ -2880,7 +2890,7 @@ static int blk_iocost_init(struct gendisk *disk)
 
 	spin_lock_irq(&ioc->lock);
 	ioc->autop_idx = AUTOP_INVALID;
-	ioc_refresh_params(ioc, true);
+	_ioc_refresh_params(ioc, true, disk->queue);
 	spin_unlock_irq(&ioc->lock);
 
 	/*
-- 
2.30.2

