From: Dennis Zhou <dennisszhou@gmail.com>
Subject: [PATCH 03/15] blkcg: use tryget logic when associating a blkg with a bio
Date: Thu, 30 Aug 2018 21:53:44 -0400
Message-ID: <20180831015356.69796-4-dennisszhou@gmail.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rHUzs00gtBEcf/iXCghUQ5cCQKHUCn7Y3ahs7HcS1YY=;
        b=EssQLpyrDxGRJAzRuWy/YJuWpnvt4vsVL2opMZ/12iKE7Tpsb2wt7YhKs3p29chxB3
         SoGVl+CqnoPxteowucNydIkpR6aG77oygw6KhmjKEjVPFx7IDLKM/uI0lv5Kkn1WMCks
         HxhMTSU837YTmCpNj8+CZPcL9pcqzDoYMrJ0OkeiqWKDigan/iSPlBmx502CNvbiFDO4
         uSWt8NEJgxwWfQnSuuQzdXkgbRnc3ocbCh8QlTLa0+iluHa+friudt9TwJZW/KpzhVg2
         8ByHXyrPfknxI1BgKyrySXdJ6mgEtAU8rDg6EVqAjJAXkAdRgZA5gGGeaAzfUnL+B76f
         3BRg==
In-Reply-To: <20180831015356.69796-1-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Jiufei Xue <jiufei.xue@linux.alibaba.com>, Joseph Qi <joseph.qi@linux.alibaba.com>

From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

There is a very small change a bio gets caught up in a really
unfortunate race between a task migration, cgroup exiting, and itself
trying to associate with a blkg. This is due to css offlining being
performed after the css->refcnt is killed which triggers removal of
blkgs that reach their blkg->refcnt of 0.

To avoid this, association with a blkg should use tryget and fallback to
using the root_blkg.

Fixes: 08e18eab0c579 ("block: add bi_blkg to the bio for cgroups")
Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/bio.c          | 3 ++-
 block/blk-throttle.c | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 04969b392c72..4473ccd22987 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1987,7 +1987,8 @@ int bio_associate_blkg(struct bio *bio, struct blkcg_gq *blkg)
 {
 	if (unlikely(bio->bi_blkg))
 		return -EBUSY;
-	blkg_get(blkg);
+	if (!blkg_try_get(blkg))
+		return -ENODEV;
 	bio->bi_blkg = blkg;
 	return 0;
 }
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index a3eede00d302..c626e1f7cdcd 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2129,8 +2129,9 @@ static inline void throtl_update_latency_buckets(struct throtl_data *td)
 static void blk_throtl_assoc_bio(struct throtl_grp *tg, struct bio *bio)
 {
 #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
-	if (bio->bi_css)
-		bio_associate_blkg(bio, tg_to_blkg(tg));
+	/* fallback to root_blkg if we fail to get a blkg ref */
+	if (bio->bi_css && bio_associate_blkg(bio, tg_to_blkg(tg)))
+		bio_associate_blkg(bio, bio->bi_disk->queue->root_blkg);
 	bio_issue_init(&bio->bi_issue, bio_sectors(bio));
 #endif
 }
-- 
2.17.1

