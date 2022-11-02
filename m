From: Yuwei Guan <ssawgyw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/5] block, bfq: remove unnecessary meta_pending count
Date: Wed,  2 Nov 2022 19:43:50 +0800
Message-ID: <20221102114354.162-2-Yuwei.Guan@zeekrlife.com>
References: <20221102114354.162-1-Yuwei.Guan@zeekrlife.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nr/6LyMOPEwxJWN/wHZi4iuPELnrmgBJGmSjXSuSoPo=;
        b=aA8awJ74lgAvHubnmrEfljUkZTWxL9nKaIQG6X23rQv3SwxY0cPT5ZVsr77SFLHIl7
         PvqY5kn7vI4fwVcxp5/moG8HQ6MlpYSp7u8CB62Yp8vkMKcEx6wKehhTpOHrUUuTtAWL
         KqtJwpozyk4g6mqZkargiKK7jqbgSnIEkdbHBD0gnKC99Yylc7eiFYu1uBde7w27ZneI
         nnQTIrpzCJTtP8gDKEppoet7dWZSIcK83cZ+x8Op2/RVKFdTAzFabF1hP7z9GKKKCb/a
         YSGziNerbAA0giKC4LgwV9yph0ScKgNh0uB8/qV0vckktyRgnckFbTFNt1I7D/9BgnQV
         Q3qA==
In-Reply-To: <20221102114354.162-1-Yuwei.Guan-tZnZJQTKG+hl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yuwei.Guan-tZnZJQTKG+hl57MIdRCFDg@public.gmane.org

The meta_pending is counted only, but no one use it,
so remove it.

Signed-off-by: Yuwei Guan <Yuwei.Guan-tZnZJQTKG+hl57MIdRCFDg@public.gmane.org>
---
 block/bfq-iosched.c | 7 -------
 block/bfq-iosched.h | 2 --
 2 files changed, 9 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 7ea427817f7f..74b87694105f 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2448,10 +2448,6 @@ static void bfq_remove_request(struct request_queue *q,
 		if (unlikely(!bfqd->nonrot_with_queueing))
 			bfq_pos_tree_add_move(bfqd, bfqq);
 	}
-
-	if (rq->cmd_flags & REQ_META)
-		bfqq->meta_pending--;
-
 }
 
 static bool bfq_bio_merge(struct request_queue *q, struct bio *bio,
@@ -5975,9 +5971,6 @@ static void bfq_update_has_short_ttime(struct bfq_data *bfqd,
 static void bfq_rq_enqueued(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 			    struct request *rq)
 {
-	if (rq->cmd_flags & REQ_META)
-		bfqq->meta_pending++;
-
 	bfqq->last_request_pos = blk_rq_pos(rq) + blk_rq_sectors(rq);
 
 	if (bfqq == bfqd->in_service_queue && bfq_bfqq_wait_request(bfqq)) {
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 71f721670ab6..3de849e97e4e 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -268,8 +268,6 @@ struct bfq_queue {
 	struct request *next_rq;
 	/* number of sync and async requests queued */
 	int queued[2];
-	/* number of pending metadata requests */
-	int meta_pending;
 	/* fifo list of requests in sort_list */
 	struct list_head fifo;
 
-- 
2.34.1

