From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH 2/4] blk-throttle: remove tg_drain_bios
Date: Sat,  9 May 2020 00:00:13 +0200
Message-ID: <20200508220015.11528-3-guoqing.jiang@cloud.ionos.com>
References: <20200508220015.11528-1-guoqing.jiang@cloud.ionos.com>
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oe6VUiTYsko1zxoPYCZbsMKvQCAiAXB7o0u5C4C7os8=;
        b=UIKZzo7pCejAlakM2hiG4HdCLnh0Hv+FZak8KGCaKM+kGnJAwThVANiEyWdglZLM+S
         5mMMkwn71jUD6RsAml4EzcgJ6KiNqgGjzZHgiQ3yVAUfZmhk8CrdxHId4nqZTZ0AhusB
         StxzkUdXJGP90As1TH59dsDkU+Nrq4j85tT9qfl/s+RXqPSkcO381Gpj4ufneSi7JSsj
         6Hgfboph161R+bTtlnhprm7PnzNrFFpD8mpHtUaJ+sC10PfTO9AtpKULFOz6gU2NsA8S
         wnhytYR/j1dkQ/aZI6QfE3zD9FrytikTvcrT/u7ruPZpXgS3Mhi17hOn0A3i3q+V52Gq
         8cpg==
In-Reply-To: <20200508220015.11528-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

After blk_throtl_drain is removed, there is no caller of tg_drain_bios,
so remove it as well.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 block/blk-throttle.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 0b2ce7fb77a7..209fdd8939fb 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2358,28 +2358,6 @@ void blk_throtl_bio_endio(struct bio *bio)
 }
 #endif
 
-/*
- * Dispatch all bios from all children tg's queued on @parent_sq.  On
- * return, @parent_sq is guaranteed to not have any active children tg's
- * and all bios from previously active tg's are on @parent_sq->bio_lists[].
- */
-static void tg_drain_bios(struct throtl_service_queue *parent_sq)
-{
-	struct throtl_grp *tg;
-
-	while ((tg = throtl_rb_first(parent_sq))) {
-		struct throtl_service_queue *sq = &tg->service_queue;
-		struct bio *bio;
-
-		throtl_dequeue_tg(tg);
-
-		while ((bio = throtl_peek_queued(&sq->queued[READ])))
-			tg_dispatch_one_bio(tg, bio_data_dir(bio));
-		while ((bio = throtl_peek_queued(&sq->queued[WRITE])))
-			tg_dispatch_one_bio(tg, bio_data_dir(bio));
-	}
-}
-
 int blk_throtl_init(struct request_queue *q)
 {
 	struct throtl_data *td;
-- 
2.17.1

