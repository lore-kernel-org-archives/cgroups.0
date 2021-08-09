From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 2/5] block: pass a gendisk to blk_queue_update_readahead
Date: Mon,  9 Aug 2021 16:17:41 +0200
Message-ID: <20210809141744.1203023-3-hch@lst.de>
References: <20210809141744.1203023-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=yfgwEJJ/lEErTg9R2tH9Q4AY/CVVCsAathAAGp4mxNU=; b=YZpwWiQwwkBzHLrz5Kh1OgLTCm
        xB08vBJzxYt3zTrEvfuSPuffpHPWcX3ryMnQv/Qh5mAmvqiE2EnlfZWToP3fGf7uQolZil/o8m9VD
        dlI9VwWf/nJubgK1QQZ2d9vSb5lfGK9NTbyJBsc7odgvA0D3KTsPbeCIx998RP7SIipGS54gbt88p
        NnGdVk/YxfCvopDOt8QY8cpWJQlJz6bpXMbVn27AhKW2dlzSGDHqAK8+eaKLCvLkP4KbCHBHNUGQq
        kIAVdsMRhpolhx9nh4WIYI27PdgTjPYIxfpismT6T0ko1+8SIvgZmq1Uyv1YdeUMhJeQQpJgU0kA5
        yfeF1MZw==;
In-Reply-To: <20210809141744.1203023-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

.. and rename the function to disk_update_readahead.  This is in
preparation for moving the BDI from the request_queue to the gendisk.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/blk-settings.c         | 8 +++++---
 block/blk-sysfs.c            | 2 +-
 drivers/block/drbd/drbd_nl.c | 2 +-
 drivers/md/dm-table.c        | 2 +-
 drivers/nvme/host/core.c     | 2 +-
 include/linux/blkdev.h       | 2 +-
 6 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 109012719aa0..44aaef9bf736 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -380,8 +380,10 @@ void blk_queue_alignment_offset(struct request_queue *q, unsigned int offset)
 }
 EXPORT_SYMBOL(blk_queue_alignment_offset);
 
-void blk_queue_update_readahead(struct request_queue *q)
+void disk_update_readahead(struct gendisk *disk)
 {
+	struct request_queue *q = disk->queue;
+
 	/*
 	 * For read-ahead of large files to be effective, we need to read ahead
 	 * at least twice the optimal I/O size.
@@ -391,7 +393,7 @@ void blk_queue_update_readahead(struct request_queue *q)
 	q->backing_dev_info->io_pages =
 		queue_max_sectors(q) >> (PAGE_SHIFT - 9);
 }
-EXPORT_SYMBOL_GPL(blk_queue_update_readahead);
+EXPORT_SYMBOL_GPL(disk_update_readahead);
 
 /**
  * blk_limits_io_min - set minimum request size for a device
@@ -665,7 +667,7 @@ void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
 		pr_notice("%s: Warning: Device %pg is misaligned\n",
 			disk->disk_name, bdev);
 
-	blk_queue_update_readahead(disk->queue);
+	disk_update_readahead(disk);
 }
 EXPORT_SYMBOL(disk_stack_limits);
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 370d83c18057..3af2ab7d5086 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -866,7 +866,7 @@ int blk_register_queue(struct gendisk *disk)
 		  "%s is registering an already registered queue\n",
 		  kobject_name(&dev->kobj));
 
-	blk_queue_update_readahead(q);
+	disk_update_readahead(disk);
 
 	ret = blk_trace_init_sysfs(dev);
 	if (ret)
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index e7d0e637e632..44ccf8b4f4b2 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1364,7 +1364,7 @@ static void drbd_setup_queue_param(struct drbd_device *device, struct drbd_backi
 
 	if (b) {
 		blk_stack_limits(&q->limits, &b->limits, 0);
-		blk_queue_update_readahead(q);
+		disk_update_readahead(device->vdisk);
 	}
 	fixup_discard_if_not_supported(q);
 	fixup_write_zeroes(device, q);
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 0543cdf89e92..b03eabc1ed7c 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -2076,7 +2076,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	}
 
 	dm_update_keyslot_manager(q, t);
-	blk_queue_update_readahead(q);
+	disk_update_readahead(t->md->disk);
 
 	return 0;
 }
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index dfd9dec0c1f6..f6c0a59c4b53 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1890,7 +1890,7 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_id_ns *id)
 		nvme_update_disk_info(ns->head->disk, ns, id);
 		blk_stack_limits(&ns->head->disk->queue->limits,
 				 &ns->queue->limits, 0);
-		blk_queue_update_readahead(ns->head->disk->queue);
+		disk_update_readahead(ns->head->disk);
 		blk_mq_unfreeze_queue(ns->head->disk->queue);
 	}
 	return 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b5c033cf5f26..ac3642c88a4d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1139,7 +1139,7 @@ void blk_queue_zone_write_granularity(struct request_queue *q,
 				      unsigned int size);
 extern void blk_queue_alignment_offset(struct request_queue *q,
 				       unsigned int alignment);
-void blk_queue_update_readahead(struct request_queue *q);
+void disk_update_readahead(struct gendisk *disk);
 extern void blk_limits_io_min(struct queue_limits *limits, unsigned int min);
 extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
 extern void blk_limits_io_opt(struct queue_limits *limits, unsigned int opt);
-- 
2.30.2

