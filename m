From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next 2/4] blk-iocost: don't throttle bio if iocg is offlined
Date: Sat, 17 Dec 2022 11:05:25 +0800
Message-ID: <20221217030527.1250083-3-yukuai1@huaweicloud.com>
References: <20221217030527.1250083-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221217030527.1250083-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

bio will grab blkg reference, however, blkcg->online_pin is not grabbed,
hence cgroup can be removed after thread exit while bio is still in
progress. Bypass io in this case since it doesn't make sense to
throttle bio while cgroup is removed.

This patch also prepare to move operations on iocg from ioc_pd_free()
to ioc_pd_offline().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-iocost.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 1498879c4a52..23cc734dbe43 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -695,6 +695,20 @@ static struct ioc_cgrp *blkcg_to_iocc(struct blkcg *blkcg)
 			    struct ioc_cgrp, cpd);
 }
 
+static struct ioc_gq *ioc_bio_iocg(struct bio *bio)
+{
+	struct blkcg_gq *blkg = bio->bi_blkg;
+
+	if (blkg && blkg->online) {
+		struct ioc_gq *iocg = blkg_to_iocg(blkg);
+
+		if (iocg && iocg->online)
+			return iocg;
+	}
+
+	return NULL;
+}
+
 /*
  * Scale @abs_cost to the inverse of @hw_inuse.  The lower the hierarchical
  * weight, the more expensive each IO.  Must round up.
@@ -1262,6 +1276,9 @@ static bool iocg_activate(struct ioc_gq *iocg, struct ioc_now *now)
 
 	spin_lock_irq(&ioc->lock);
 
+	if (!iocg->online)
+		goto fail_unlock;
+
 	ioc_now(ioc, now);
 
 	/* update period */
@@ -2561,9 +2578,8 @@ static u64 calc_size_vtime_cost(struct request *rq, struct ioc *ioc)
 
 static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 {
-	struct blkcg_gq *blkg = bio->bi_blkg;
 	struct ioc *ioc = rqos_to_ioc(rqos);
-	struct ioc_gq *iocg = blkg_to_iocg(blkg);
+	struct ioc_gq *iocg = ioc_bio_iocg(bio);
 	struct ioc_now now;
 	struct iocg_wait wait;
 	u64 abs_cost, cost, vtime;
@@ -2697,7 +2713,7 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 static void ioc_rqos_merge(struct rq_qos *rqos, struct request *rq,
 			   struct bio *bio)
 {
-	struct ioc_gq *iocg = blkg_to_iocg(bio->bi_blkg);
+	struct ioc_gq *iocg = ioc_bio_iocg(bio);
 	struct ioc *ioc = rqos_to_ioc(rqos);
 	sector_t bio_end = bio_end_sector(bio);
 	struct ioc_now now;
@@ -2755,7 +2771,7 @@ static void ioc_rqos_merge(struct rq_qos *rqos, struct request *rq,
 
 static void ioc_rqos_done_bio(struct rq_qos *rqos, struct bio *bio)
 {
-	struct ioc_gq *iocg = blkg_to_iocg(bio->bi_blkg);
+	struct ioc_gq *iocg = ioc_bio_iocg(bio);
 
 	if (iocg && bio->bi_iocost_cost)
 		atomic64_add(bio->bi_iocost_cost, &iocg->done_vtime);
-- 
2.31.1

