From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 3/5] Revert "blk-cgroup: delay blk-cgroup initialization until add_disk"
Date: Tue, 14 Feb 2023 19:33:06 +0100
Message-ID: <20230214183308.1658775-4-hch@lst.de>
References: <20230214183308.1658775-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=WUoh+1Csahgd9oVmto73ly56AlehnZ8I2LMB2EBC4RQ=; b=r1JyzZfOFBWKafi3cK+INp1u1R
        el6hEZcjSxiBfO85IvKg/rkh0HR3Oj+1a58juAN8f4GtTm1qj4ewITdVBefQbHGfBZe0ENzGNXYoa
        Z1HRWzHc1jhgQN4eJvjZLQuePZonTgvwc5S3wxrbuA8OAM01UEBPvZI2bs6SmB+CQ1hOfI3l1x4vf
        Shkf6AoGaETL5nFWAH7zm3mw6z1ZH1G+M3aIh+lmRP2w37n8Xzr0p8YyQmKSIIz4bc67a89VepNJ/
        ReGOEG+RzKWkmum+9kfj4g+vR5jthAcGdNvIwFx12FmZJ+xVGYSkw3sghJqP8I2MYjiqj8WiuzmwG
        Atsvjr/Q==;
In-Reply-To: <20230214183308.1658775-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This reverts commit 178fa7d49815ea8001f43ade37a22072829fd8ab.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/genhd.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 7e031559bf514c..093ef292e98f7f 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -466,13 +466,9 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 	 */
 	pm_runtime_set_memalloc_noio(ddev, true);
 
-	ret = blkcg_init_disk(disk);
-	if (ret)
-		goto out_del_block_link;
-
 	ret = blk_integrity_add(disk);
 	if (ret)
-		goto out_blkcg_exit;
+		goto out_del_block_link;
 
 	disk->part0->bd_holder_dir =
 		kobject_create_and_add("holders", &ddev->kobj);
@@ -538,8 +534,6 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 	kobject_put(disk->part0->bd_holder_dir);
 out_del_integrity:
 	blk_integrity_del(disk);
-out_blkcg_exit:
-	blkcg_exit_disk(disk);
 out_del_block_link:
 	if (!sysfs_deprecated)
 		sysfs_remove_link(block_depr, dev_name(ddev));
@@ -668,8 +662,6 @@ void del_gendisk(struct gendisk *disk)
 	rq_qos_exit(q);
 	blk_mq_unquiesce_queue(q);
 
-	blkcg_exit_disk(disk);
-
 	/*
 	 * If the disk does not own the queue, allow using passthrough requests
 	 * again.  Else leave the queue frozen to fail all I/O.
@@ -1178,6 +1170,8 @@ static void disk_release(struct device *dev)
 	    !test_bit(GD_ADDED, &disk->state))
 		blk_mq_exit_queue(disk->queue);
 
+	blkcg_exit_disk(disk);
+
 	bioset_exit(&disk->bio_split);
 
 	disk_release_events(disk);
@@ -1390,6 +1384,9 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 	if (xa_insert(&disk->part_tbl, 0, disk->part0, GFP_KERNEL))
 		goto out_destroy_part_tbl;
 
+	if (blkcg_init_disk(disk))
+		goto out_erase_part0;
+
 	rand_initialize_disk(disk);
 	disk_to_dev(disk)->class = &block_class;
 	disk_to_dev(disk)->type = &disk_type;
@@ -1402,6 +1399,8 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 #endif
 	return disk;
 
+out_erase_part0:
+	xa_erase(&disk->part_tbl, 0);
 out_destroy_part_tbl:
 	xa_destroy(&disk->part_tbl);
 	disk->part0->bd_disk = NULL;
-- 
2.39.1

