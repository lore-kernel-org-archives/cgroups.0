From: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next v2 8/9] block: fix null-pointer dereference in ioc_pd_init
Date: Wed, 30 Nov 2022 21:21:55 +0800
Message-ID: <20221130132156.2836184-9-linan122@huawei.com>
References: <20221130132156.2836184-1-linan122@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221130132156.2836184-1-linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

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

Signed-off-by: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/genhd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index dcf200bcbd3e..0db440bbfefb 100644
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
 
+	rq_qos_exit(disk->queue);
 	blkcg_exit_disk(disk);
 
 	bioset_exit(&disk->bio_split);
-- 
2.31.1

