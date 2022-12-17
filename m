From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next 4/4] blk-cgroup: synchronize del_gendisk() with configuring cgroup policy
Date: Sat, 17 Dec 2022 11:09:08 +0800
Message-ID: <20221217030908.1261787-5-yukuai1@huaweicloud.com>
References: <20221217030908.1261787-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221217030908.1261787-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

iocost is initialized when it's configured the first time, and iocost
initializing can race with del_gendisk(), which will cause null pointer
dereference:

t1				t2
ioc_qos_write
 blk_iocost_init
  rq_qos_add
  				del_gendisk
  				 rq_qos_exit
  				 //iocost is removed from q->roqs
  blkcg_activate_policy
   pd_init_fn
    ioc_pd_init
     ioc = q_to_ioc(blkg->q)
     //can't find iocost and return null

Fix the problem by adding a new mutex in request_queue, and use it to
synchronize rq_qos_exit() from del_gendisk() with configuring cgroup
policy.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-cgroup.c     | 3 +++
 block/blk-rq-qos.c     | 8 ++++++++
 include/linux/blkdev.h | 1 +
 3 files changed, 12 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index ad612148cf3b..8dcdaacb52a1 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -658,12 +658,14 @@ struct block_device *blkcg_conf_open_bdev(char **inputp)
 		return ERR_PTR(-ENODEV);
 	}
 
+	mutex_lock(&bdev->bd_queue->blkcg_pols_lock);
 	*inputp = input;
 	return bdev;
 }
 
 void blkcg_conf_close_bdev(struct block_device *bdev)
 {
+	mutex_unlock(&bdev->bd_queue->blkcg_pols_lock);
 	blkdev_put_no_open(bdev);
 }
 
@@ -1277,6 +1279,7 @@ int blkcg_init_disk(struct gendisk *disk)
 	int ret;
 
 	INIT_LIST_HEAD(&q->blkg_list);
+	mutex_init(&q->blkcg_pols_lock);
 
 	new_blkg = blkg_alloc(&blkcg_root, disk, GFP_KERNEL);
 	if (!new_blkg)
diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index efffc6fa55db..86bccdfa1a43 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -290,6 +290,10 @@ void rq_qos_exit(struct request_queue *q)
 {
 	struct rq_qos *rqos;
 
+#ifdef CONFIG_BLK_CGROUP
+	mutex_lock(&q->blkcg_pols_lock);
+#endif
+
 	spin_lock_irq(&q->queue_lock);
 	rqos = q->rq_qos;
 	q->rq_qos = NULL;
@@ -300,4 +304,8 @@ void rq_qos_exit(struct request_queue *q)
 			rqos->ops->exit(rqos);
 		rqos = rqos->next;
 	} while (rqos);
+
+#ifdef CONFIG_BLK_CGROUP
+	mutex_unlock(&q->blkcg_pols_lock);
+#endif
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 301cf1cf4f2f..824d68a41a83 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -484,6 +484,7 @@ struct request_queue {
 	DECLARE_BITMAP		(blkcg_pols, BLKCG_MAX_POLS);
 	struct blkcg_gq		*root_blkg;
 	struct list_head	blkg_list;
+	struct mutex		blkcg_pols_lock;
 #endif
 
 	struct queue_limits	limits;
-- 
2.31.1

