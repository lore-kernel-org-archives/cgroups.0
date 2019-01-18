From: Andrea Righi <righi.andrea@gmail.com>
Subject: [RFC PATCH 3/3] fsio-throttle: instrumentation
Date: Fri, 18 Jan 2019 11:31:27 +0100
Message-ID: <20190118103127.325-4-righi.andrea@gmail.com>
References: <20190118103127.325-1-righi.andrea@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bJZKyQhLGckyRl2vzdSeAHUxaeeCyICyHV3vsVcaZAA=;
        b=d5qrVfAnwhDEn+LzYX2TWatO8uiaaxy6O0cBzq+14zoPcHkCGIBBhHCk3xDxdN+wO5
         y1quHDCeReugFONlqY9U2oIBpR/lb3JY+aHzY9n9/2M552/QjsQTOibPdGTC7ueCj4uK
         bRtf7SfmM/4KEGY15qvgh8Jj8wPOJL2CbfTfcxgdkWyQOgjWNxDtBPHJAchCGDVGSwGy
         ZpWrZ2a3w8/T7Ep9ya+c9WNQF3uE4A1v1dWF9Y34kCtDky5wRfSKZ7En743NC08HNV75
         gXb5HxZ2y9gFJuZtYSer2c3E+kuHvVRvuXJLEint2oBiRMJ149H15Bu4mTU1fUkmft16
         S52g==
In-Reply-To: <20190118103127.325-1-righi.andrea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Josef Bacik <josef@toxicpanda.com>, Dennis Zhou <dennis@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Andrea Righi <righi.andrea@gmail.com>

Apply the fsio controller to the opportune kernel functions to evaluate
and throttle filesystem I/O.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 block/blk-core.c          | 10 ++++++++++
 include/linux/writeback.h |  7 ++++++-
 mm/filemap.c              | 20 +++++++++++++++++++-
 mm/page-writeback.c       | 14 ++++++++++++--
 4 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3c5f61ceeb67..4b4717f64ac1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -16,6 +16,7 @@
 #include <linux/backing-dev.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <linux/fsio-throttle.h>
 #include <linux/blk-mq.h>
 #include <linux/highmem.h>
 #include <linux/mm.h>
@@ -956,6 +957,15 @@ generic_make_request_checks(struct bio *bio)
 	 */
 	create_io_context(GFP_ATOMIC, q->node);
 
+	/*
+	 * Account only READs at this layer (WRITEs are accounted and throttled
+	 * in balance_dirty_pages()) and don't enfore sleeps (state=0): in this
+	 * way we can prevent potential lock contentions and priority inversion
+	 * problems at the filesystem layer.
+	 */
+	if (bio_op(bio) == REQ_OP_READ)
+		fsio_throttle(bio_dev(bio), bio->bi_iter.bi_size, 0);
+
 	if (!blkcg_bio_issue_check(q, bio))
 		return false;
 
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 738a0c24874f..1e161c7969e5 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -356,7 +356,12 @@ void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty);
 unsigned long wb_calc_thresh(struct bdi_writeback *wb, unsigned long thresh);
 
 void wb_update_bandwidth(struct bdi_writeback *wb, unsigned long start_time);
-void balance_dirty_pages_ratelimited(struct address_space *mapping);
+
+#define balance_dirty_pages_ratelimited(__mapping) \
+	__balance_dirty_pages_ratelimited(__mapping, false)
+void __balance_dirty_pages_ratelimited(struct address_space *mapping,
+				       bool redirty);
+
 bool wb_over_bg_thresh(struct bdi_writeback *wb);
 
 typedef int (*writepage_t)(struct page *page, struct writeback_control *wbc,
diff --git a/mm/filemap.c b/mm/filemap.c
index 9f5e323e883e..5cc0959274d6 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -29,6 +29,7 @@
 #include <linux/backing-dev.h>
 #include <linux/pagevec.h>
 #include <linux/blkdev.h>
+#include <linux/fsio-throttle.h>
 #include <linux/security.h>
 #include <linux/cpuset.h>
 #include <linux/hugetlb.h>
@@ -2040,6 +2041,7 @@ static ssize_t generic_file_buffered_read(struct kiocb *iocb,
 {
 	struct file *filp = iocb->ki_filp;
 	struct address_space *mapping = filp->f_mapping;
+	struct block_device *bdev = as_to_bdev(mapping);
 	struct inode *inode = mapping->host;
 	struct file_ra_state *ra = &filp->f_ra;
 	loff_t *ppos = &iocb->ki_pos;
@@ -2068,6 +2070,7 @@ static ssize_t generic_file_buffered_read(struct kiocb *iocb,
 
 		cond_resched();
 find_page:
+		fsio_throttle(bdev_to_dev(bdev), 0, TASK_INTERRUPTIBLE);
 		if (fatal_signal_pending(current)) {
 			error = -EINTR;
 			goto out;
@@ -2308,11 +2311,17 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		struct file *file = iocb->ki_filp;
 		struct address_space *mapping = file->f_mapping;
+		struct block_device *bdev = as_to_bdev(mapping);
 		struct inode *inode = mapping->host;
 		loff_t size;
 
 		size = i_size_read(inode);
 		if (iocb->ki_flags & IOCB_NOWAIT) {
+			unsigned long long sleep;
+
+			sleep = fsio_throttle(bdev_to_dev(bdev), 0, 0);
+			if (sleep)
+				return -EAGAIN;
 			if (filemap_range_has_page(mapping, iocb->ki_pos,
 						   iocb->ki_pos + count - 1))
 				return -EAGAIN;
@@ -2322,6 +2331,7 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 					        iocb->ki_pos + count - 1);
 			if (retval < 0)
 				goto out;
+			fsio_throttle(bdev_to_dev(bdev), 0, TASK_INTERRUPTIBLE);
 		}
 
 		file_accessed(file);
@@ -2366,9 +2376,11 @@ EXPORT_SYMBOL(generic_file_read_iter);
 static int page_cache_read(struct file *file, pgoff_t offset, gfp_t gfp_mask)
 {
 	struct address_space *mapping = file->f_mapping;
+	struct block_device *bdev = as_to_bdev(mapping);
 	struct page *page;
 	int ret;
 
+	fsio_throttle(bdev_to_dev(bdev), 0, TASK_INTERRUPTIBLE);
 	do {
 		page = __page_cache_alloc(gfp_mask);
 		if (!page)
@@ -2498,11 +2510,15 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 	 */
 	page = find_get_page(mapping, offset);
 	if (likely(page) && !(vmf->flags & FAULT_FLAG_TRIED)) {
+		struct block_device *bdev = as_to_bdev(mapping);
 		/*
 		 * We found the page, so try async readahead before
 		 * waiting for the lock.
 		 */
 		do_async_mmap_readahead(vmf->vma, ra, file, page, offset);
+		if (unlikely(!PageUptodate(page)))
+			fsio_throttle(bdev_to_dev(bdev), 0,
+				      TASK_INTERRUPTIBLE);
 	} else if (!page) {
 		/* No page in the page cache at all */
 		do_sync_mmap_readahead(vmf->vma, ra, file, offset);
@@ -3172,6 +3188,7 @@ ssize_t generic_perform_write(struct file *file,
 	long status = 0;
 	ssize_t written = 0;
 	unsigned int flags = 0;
+	unsigned int dirty;
 
 	do {
 		struct page *page;
@@ -3216,6 +3233,7 @@ ssize_t generic_perform_write(struct file *file,
 		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
 		flush_dcache_page(page);
 
+		dirty = PageDirty(page);
 		status = a_ops->write_end(file, mapping, pos, bytes, copied,
 						page, fsdata);
 		if (unlikely(status < 0))
@@ -3241,7 +3259,7 @@ ssize_t generic_perform_write(struct file *file,
 		pos += copied;
 		written += copied;
 
-		balance_dirty_pages_ratelimited(mapping);
+		__balance_dirty_pages_ratelimited(mapping, dirty);
 	} while (iov_iter_count(i));
 
 	return written ? written : status;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 7d1010453fb9..694ede8783f3 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/pagemap.h>
 #include <linux/writeback.h>
+#include <linux/fsio-throttle.h>
 #include <linux/init.h>
 #include <linux/backing-dev.h>
 #include <linux/task_io_accounting_ops.h>
@@ -1858,10 +1859,12 @@ DEFINE_PER_CPU(int, dirty_throttle_leaks) = 0;
  * limit we decrease the ratelimiting by a lot, to prevent individual processes
  * from overshooting the limit by (ratelimit_pages) each.
  */
-void balance_dirty_pages_ratelimited(struct address_space *mapping)
+void __balance_dirty_pages_ratelimited(struct address_space *mapping,
+				       bool redirty)
 {
 	struct inode *inode = mapping->host;
 	struct backing_dev_info *bdi = inode_to_bdi(inode);
+	struct block_device *bdev = as_to_bdev(mapping);
 	struct bdi_writeback *wb = NULL;
 	int ratelimit;
 	int *p;
@@ -1878,6 +1881,13 @@ void balance_dirty_pages_ratelimited(struct address_space *mapping)
 	if (wb->dirty_exceeded)
 		ratelimit = min(ratelimit, 32 >> (PAGE_SHIFT - 10));
 
+	/*
+	 * Throttle filesystem I/O only if page was initially clean: re-writing
+	 * a dirty page doesn't generate additional I/O.
+	 */
+	if (!redirty)
+		fsio_throttle(bdev_to_dev(bdev), PAGE_SIZE, TASK_KILLABLE);
+
 	preempt_disable();
 	/*
 	 * This prevents one CPU to accumulate too many dirtied pages without
@@ -1911,7 +1921,7 @@ void balance_dirty_pages_ratelimited(struct address_space *mapping)
 
 	wb_put(wb);
 }
-EXPORT_SYMBOL(balance_dirty_pages_ratelimited);
+EXPORT_SYMBOL(__balance_dirty_pages_ratelimited);
 
 /**
  * wb_over_bg_thresh - does @wb need to be written back?
-- 
2.17.1

