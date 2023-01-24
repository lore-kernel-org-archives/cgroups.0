From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/15] blk-wbt: pass a gendisk to wbt_{enable,disable}_default
Date: Tue, 24 Jan 2023 07:57:06 +0100
Message-ID: <20230124065716.152286-7-hch@lst.de>
References: <20230124065716.152286-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=wGcBNfyhCSFPMgcYB7n0YeT74FH42qnpghsYt11X0/c=; b=keHav10Mav+DU0V0PPOQEy/ysJ
        MIAW9FK9ChMxIy2eqFBmREWsZNR85QISE9OdsBwgQcfuaZNO2kEh8Ooe+7cgNFd7qJSCqrmPpAYVk
        Ge7hQV+n7SB+qb/Bl0L6LXrvZyaNmOxsF+cTfeIB/FCcmIDXFbucZNYJ6x6luqLGIH3+yUmkyMkST
        gXcdF3uuVzr/2oVgwhACJnI0hZpe8NRxZVgRBWv9LLI1y+As9QSXTytvi++jzW7SGEmJMEmfekjv5
        ZoYfDp6OC4ws+5+4OmEP7YBCPSysx5egM2he0cKhqsFH0gkwXGdpIn4KDSjzokZLp4JiON4ZPO/3X
        sxzIGO0A==;
In-Reply-To: <20230124065716.152286-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, Andreas Herrmann <aherrmann@suse.de>

Pass a gendisk to wbt_enable_default and wbt_disable_default to
prepare for phasing out usage of the request_queue in the blk-cgroup
code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andreas Herrmann <aherrmann@suse.de>
---
 block/bfq-iosched.c | 4 ++--
 block/blk-iocost.c  | 4 ++--
 block/blk-sysfs.c   | 2 +-
 block/blk-wbt.c     | 7 ++++---
 block/blk-wbt.h     | 8 ++++----
 5 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 815b884d6c5acf..68062243f2c142 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -7165,7 +7165,7 @@ static void bfq_exit_queue(struct elevator_queue *e)
 
 	blk_stat_disable_accounting(bfqd->queue);
 	clear_bit(ELEVATOR_FLAG_DISABLE_WBT, &e->flags);
-	wbt_enable_default(bfqd->queue);
+	wbt_enable_default(bfqd->queue->disk);
 
 	kfree(bfqd);
 }
@@ -7354,7 +7354,7 @@ static int bfq_init_queue(struct request_queue *q, struct elevator_type *e)
 	blk_queue_flag_set(QUEUE_FLAG_SQ_SCHED, q);
 
 	set_bit(ELEVATOR_FLAG_DISABLE_WBT, &eq->flags);
-	wbt_disable_default(q);
+	wbt_disable_default(q->disk);
 	blk_stat_enable_accounting(q);
 
 	return 0;
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index a2b4e7146be5f1..dbb93f4f68d979 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3285,11 +3285,11 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 		blk_stat_enable_accounting(disk->queue);
 		blk_queue_flag_set(QUEUE_FLAG_RQ_ALLOC_TIME, disk->queue);
 		ioc->enabled = true;
-		wbt_disable_default(disk->queue);
+		wbt_disable_default(disk);
 	} else {
 		blk_queue_flag_clear(QUEUE_FLAG_RQ_ALLOC_TIME, disk->queue);
 		ioc->enabled = false;
-		wbt_enable_default(disk->queue);
+		wbt_enable_default(disk);
 	}
 
 	if (user) {
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 5486b6c57f6b8a..2074103865f45b 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -826,7 +826,7 @@ int blk_register_queue(struct gendisk *disk)
 		goto out_elv_unregister;
 
 	blk_queue_flag_set(QUEUE_FLAG_REGISTERED, q);
-	wbt_enable_default(q);
+	wbt_enable_default(disk);
 	blk_throtl_register(disk);
 
 	/* Now everything is ready and send out KOBJ_ADD uevent */
diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index 68a774d7a7c9c0..8f9302134339c5 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -650,8 +650,9 @@ void wbt_set_write_cache(struct request_queue *q, bool write_cache_on)
 /*
  * Enable wbt if defaults are configured that way
  */
-void wbt_enable_default(struct request_queue *q)
+void wbt_enable_default(struct gendisk *disk)
 {
+	struct request_queue *q = disk->queue;
 	struct rq_qos *rqos;
 	bool disable_flag = q->elevator &&
 		    test_bit(ELEVATOR_FLAG_DISABLE_WBT, &q->elevator->flags);
@@ -718,9 +719,9 @@ static void wbt_exit(struct rq_qos *rqos)
 /*
  * Disable wbt, if enabled by default.
  */
-void wbt_disable_default(struct request_queue *q)
+void wbt_disable_default(struct gendisk *disk)
 {
-	struct rq_qos *rqos = wbt_rq_qos(q);
+	struct rq_qos *rqos = wbt_rq_qos(disk->queue);
 	struct rq_wb *rwb;
 	if (!rqos)
 		return;
diff --git a/block/blk-wbt.h b/block/blk-wbt.h
index e3ea6e7e290076..7ab1cba55c25f7 100644
--- a/block/blk-wbt.h
+++ b/block/blk-wbt.h
@@ -91,8 +91,8 @@ static inline unsigned int wbt_inflight(struct rq_wb *rwb)
 #ifdef CONFIG_BLK_WBT
 
 int wbt_init(struct request_queue *);
-void wbt_disable_default(struct request_queue *);
-void wbt_enable_default(struct request_queue *);
+void wbt_disable_default(struct gendisk *disk);
+void wbt_enable_default(struct gendisk *disk);
 
 u64 wbt_get_min_lat(struct request_queue *q);
 void wbt_set_min_lat(struct request_queue *q, u64 val);
@@ -108,10 +108,10 @@ static inline int wbt_init(struct request_queue *q)
 {
 	return -EINVAL;
 }
-static inline void wbt_disable_default(struct request_queue *q)
+static inline void wbt_disable_default(struct gendisk *disk)
 {
 }
-static inline void wbt_enable_default(struct request_queue *q)
+static inline void wbt_enable_default(struct gendisk *disk)
 {
 }
 static inline void wbt_set_write_cache(struct request_queue *q, bool wc)
-- 
2.39.0

