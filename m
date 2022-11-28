From: Li Nan <linan122@huawei.com>
Subject: [PATCH -next 8/8] block: fix null-pointer dereference in ioc_pd_init
Date: Mon, 28 Nov 2022 23:44:34 +0800
Message-ID: <20221128154434.4177442-9-linan122@huawei.com>
References: <20221128154434.4177442-1-linan122@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221128154434.4177442-1-linan122@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linan122@huawei.com, yukuai3@huawei.com, yi.zhang@huawei.com

Remove block device when iocost is initializing may cause
null-pointer dereference:

	CPU1				   CPU2
  ioc_qos_write
   blkcg_conf_open_bdev
    blkdev_get_no_open
     kobject_get_unless_zero
    blk_iocost_init
     rq_qos_add
  					del_gendisk
  					 rq_qos_exit
  					  q->rq_qos = rqos->next
  					   //iocost is removed from q->roqs
      blkcg_activate_policy
       pd_init_fn
        ioc_pd_init
  	 ioc = q_to_ioc(blkg->q)
 	  //cant find iocost and return null

Fix problem by moving rq_qos_exit() to disk_release(). ioc_qos_write() get
bd_device.kobj in blkcg_conf_open_bdev(), so disk_release will not be
actived until iocost initialization is complited.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 block/genhd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index dcf200bcbd3e..c264da49eaaa 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -656,7 +656,6 @@ void del_gendisk(struct gendisk *disk)
 		elevator_exit(q);
 		mutex_unlock(&q->sysfs_lock);
 	}
-	rq_qos_exit(q);
 	blk_mq_unquiesce_queue(q);
 
 	/*
@@ -1168,6 +1167,7 @@ static void disk_release(struct device *dev)
 	    !test_bit(GD_ADDED, &disk->state))
 		blk_mq_exit_queue(disk->queue);
 
+	rq_qos_exit(q);
 	blkcg_exit_disk(disk);
 
 	bioset_exit(&disk->bio_split);
-- 
2.31.1

