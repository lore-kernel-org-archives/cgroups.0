From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH 2/2] blk-throttle: improve bypassing bios checkings
Date: Wed, 21 Sep 2022 17:53:09 +0800
Message-ID: <20220921095309.1481289-3-yukuai1@huaweicloud.com>
References: <20220921095309.1481289-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220921095309.1481289-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

"tg->has_rules" is extended to "tg->has_rules_iops/bps", thus bios that
don't need to be throttled can be checked accurately.

With this patch, bio will be throttled if:

1) Bio is read/write, and corresponding read/write iops limit exist.
2) If corresponding doesn't exist, corresponding bps limit exist and
bio is not throttled before.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 13 +++++++++----
 block/blk-throttle.h | 22 +++++++++++++++++++---
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index a062539d84d0..78316955e30f 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -421,11 +421,16 @@ static void tg_update_has_rules(struct throtl_grp *tg)
 	struct throtl_data *td = tg->td;
 	int rw;
 
-	for (rw = READ; rw <= WRITE; rw++)
-		tg->has_rules[rw] = (parent_tg && parent_tg->has_rules[rw]) ||
+	for (rw = READ; rw <= WRITE; rw++) {
+		tg->has_rules_iops[rw] =
+			(parent_tg && parent_tg->has_rules_iops[rw]) ||
 			(td->limit_valid[td->limit_index] &&
-			 (tg_bps_limit(tg, rw) != U64_MAX ||
-			  tg_iops_limit(tg, rw) != UINT_MAX));
+			  tg_iops_limit(tg, rw) != UINT_MAX);
+		tg->has_rules_bps[rw] =
+			(parent_tg && parent_tg->has_rules_bps[rw]) ||
+			(td->limit_valid[td->limit_index] &&
+			 (tg_bps_limit(tg, rw) != U64_MAX));
+	}
 }
 
 static void throtl_pd_online(struct blkg_policy_data *pd)
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index 3994b89dfa11..69f00012d616 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -98,7 +98,8 @@ struct throtl_grp {
 	unsigned int flags;
 
 	/* are there any throtl rules between this group and td? */
-	bool has_rules[2];
+	bool has_rules_bps[2];
+	bool has_rules_iops[2];
 
 	/* internally used bytes per second rate limits */
 	uint64_t bps[2][LIMIT_CNT];
@@ -178,11 +179,26 @@ void blk_throtl_exit(struct request_queue *q);
 void blk_throtl_register_queue(struct request_queue *q);
 bool __blk_throtl_bio(struct bio *bio);
 void blk_throtl_cancel_bios(struct request_queue *q);
-static inline bool blk_throtl_bio(struct bio *bio)
+
+static inline bool blk_should_throtl(struct bio *bio)
 {
 	struct throtl_grp *tg = blkg_to_tg(bio->bi_blkg);
+	int rw = bio_data_dir(bio);
+
+	/* iops limit is always counted */
+	if (tg->has_rules_iops[rw])
+		return true;
+
+	if (tg->has_rules_bps[rw] && !bio_flagged(bio, BIO_BPS_THROTTLED))
+		return true;
+
+	return false;
+}
+
+static inline bool blk_throtl_bio(struct bio *bio)
+{
 
-	if (!tg->has_rules[bio_data_dir(bio)])
+	if (!blk_should_throtl(bio))
 		return false;
 
 	return __blk_throtl_bio(bio);
-- 
2.31.1

