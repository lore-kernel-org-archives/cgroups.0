From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 02/19] blk-cgroup: delay blk-cgroup initialization until add_disk
Date: Wed,  1 Feb 2023 14:41:06 +0100
Message-ID: <20230201134123.2656505-3-hch@lst.de>
References: <20230201134123.2656505-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=owVVO/DbBHdf7AIHfu92ljEYnX36wgKXerj+tH9B5sQ=; b=2UAxJ0DwJsl7WnJQUbzN82bTMW
        6ySg0qPyZFoPgD4M3kLjxnIaRushEvLavfrRSHpjXl+txoobekdqU/f+3Psz+dLZ2WHy3BlvssPLL
        TPZKVAoY3lcDEYOVhb6T7hSAvvXrk3ZhwJVF3YtcGU1EVvAAqownYj5XxHMkxpzNd1XrXxrq4Tu9q
        fLdeW3Y70fHUNh6RxJEakeYGtTjI6BtW94jwhu0x5NVXDdyECYT5/qWi6cHhpO1bBUVVg0Iwr2x9P
        jsUCzDFy9RB+ftWOU4L+b48YrXGvkBF3a6R6XyvuetvMBfiqGC8RyQqWRZriIAl6pd5ipgtwsEvK5
        KxPiSYjQ==;
In-Reply-To: <20230201134123.2656505-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>

There is no need to initialize the cgroup code before the disk is marked
live.  Moving the cgroup initialization earlier will help to have a
fully initialized struct device in the gendisk for the cgroup code to
use in the future.  Similarly tear the cgroup information down in
del_gendisk to be symmetric and because none of the cgroup tracking is
needed once non-passthrough I/O stops.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>
---
 block/genhd.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 23cf83b3331cde..705dec0800d62e 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -466,10 +466,14 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 	 */
 	pm_runtime_set_memalloc_noio(ddev, true);
 
-	ret = blk_integrity_add(disk);
+	ret = blkcg_init_disk(disk);
 	if (ret)
 		goto out_del_block_link;
 
+	ret = blk_integrity_add(disk);
+	if (ret)
+		goto out_blkcg_exit;
+
 	disk->part0->bd_holder_dir =
 		kobject_create_and_add("holders", &ddev->kobj);
 	if (!disk->part0->bd_holder_dir) {
@@ -534,6 +538,8 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 	kobject_put(disk->part0->bd_holder_dir);
 out_del_integrity:
 	blk_integrity_del(disk);
+out_blkcg_exit:
+	blkcg_exit_disk(disk);
 out_del_block_link:
 	if (!sysfs_deprecated)
 		sysfs_remove_link(block_depr, dev_name(ddev));
@@ -662,6 +668,8 @@ void del_gendisk(struct gendisk *disk)
 	rq_qos_exit(q);
 	blk_mq_unquiesce_queue(q);
 
+	blkcg_exit_disk(disk);
+
 	/*
 	 * If the disk does not own the queue, allow using passthrough requests
 	 * again.  Else leave the queue frozen to fail all I/O.
@@ -1171,8 +1179,6 @@ static void disk_release(struct device *dev)
 	    !test_bit(GD_ADDED, &disk->state))
 		blk_mq_exit_queue(disk->queue);
 
-	blkcg_exit_disk(disk);
-
 	bioset_exit(&disk->bio_split);
 
 	disk_release_events(disk);
@@ -1385,9 +1391,6 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 	if (xa_insert(&disk->part_tbl, 0, disk->part0, GFP_KERNEL))
 		goto out_destroy_part_tbl;
 
-	if (blkcg_init_disk(disk))
-		goto out_erase_part0;
-
 	rand_initialize_disk(disk);
 	disk_to_dev(disk)->class = &block_class;
 	disk_to_dev(disk)->type = &disk_type;
@@ -1400,8 +1403,6 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 #endif
 	return disk;
 
-out_erase_part0:
-	xa_erase(&disk->part_tbl, 0);
 out_destroy_part_tbl:
 	xa_destroy(&disk->part_tbl);
 	disk->part0->bd_disk = NULL;
-- 
2.39.0

