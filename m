From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH 1/2] blk-throttle: remove THROTL_TG_HAS_IOPS_LIMIT
Date: Wed, 21 Sep 2022 17:53:08 +0800
Message-ID: <20220921095309.1481289-2-yukuai1@huaweicloud.com>
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

Currently, "tg->has_rules" and "tg->flags & THROTL_TG_HAS_IOPS_LIMIT"
both try to bypass bios that don't need to be throttled, however, they are
a little redundant and both not perfect:

1) "tg->has_rules" only distinguish read and write, but not iops and bps
   limit.
2) "tg->flags & THROTL_TG_HAS_IOPS_LIMIT" only check if iops limit
   exist, read and write is not distinguished, and bps limit is not
   checked.

tg->has_rules will extended to distinguish bps and iops in the following
patch. There is no need to keep the flag.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 16 ++--------------
 block/blk-throttle.h |  8 +-------
 2 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 55f2d985cfbb..a062539d84d0 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -420,24 +420,12 @@ static void tg_update_has_rules(struct throtl_grp *tg)
 	struct throtl_grp *parent_tg = sq_to_tg(tg->service_queue.parent_sq);
 	struct throtl_data *td = tg->td;
 	int rw;
-	int has_iops_limit = 0;
-
-	for (rw = READ; rw <= WRITE; rw++) {
-		unsigned int iops_limit = tg_iops_limit(tg, rw);
 
+	for (rw = READ; rw <= WRITE; rw++)
 		tg->has_rules[rw] = (parent_tg && parent_tg->has_rules[rw]) ||
 			(td->limit_valid[td->limit_index] &&
 			 (tg_bps_limit(tg, rw) != U64_MAX ||
-			  iops_limit != UINT_MAX));
-
-		if (iops_limit != UINT_MAX)
-			has_iops_limit = 1;
-	}
-
-	if (has_iops_limit)
-		tg->flags |= THROTL_TG_HAS_IOPS_LIMIT;
-	else
-		tg->flags &= ~THROTL_TG_HAS_IOPS_LIMIT;
+			  tg_iops_limit(tg, rw) != UINT_MAX));
 }
 
 static void throtl_pd_online(struct blkg_policy_data *pd)
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index 66b4292b1b92..3994b89dfa11 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -55,8 +55,7 @@ struct throtl_service_queue {
 enum tg_state_flags {
 	THROTL_TG_PENDING	= 1 << 0,	/* on parent's pending tree */
 	THROTL_TG_WAS_EMPTY	= 1 << 1,	/* bio_lists[] became non-empty */
-	THROTL_TG_HAS_IOPS_LIMIT = 1 << 2,	/* tg has iops limit */
-	THROTL_TG_CANCELING	= 1 << 3,	/* starts to cancel bio */
+	THROTL_TG_CANCELING	= 1 << 2,	/* starts to cancel bio */
 };
 
 enum {
@@ -183,11 +182,6 @@ static inline bool blk_throtl_bio(struct bio *bio)
 {
 	struct throtl_grp *tg = blkg_to_tg(bio->bi_blkg);
 
-	/* no need to throttle bps any more if the bio has been throttled */
-	if (bio_flagged(bio, BIO_BPS_THROTTLED) &&
-	    !(tg->flags & THROTL_TG_HAS_IOPS_LIMIT))
-		return false;
-
 	if (!tg->has_rules[bio_data_dir(bio)])
 		return false;
 
-- 
2.31.1

