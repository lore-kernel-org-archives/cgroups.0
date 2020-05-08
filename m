From: Guoqing Jiang <guoqing.jiang-8+5b1tb3oTXfrHaScsAUWw@public.gmane.org>
Subject: [PATCH 3/4] blk-wbt: remove wbt_update_limits
Date: Sat,  9 May 2020 00:00:14 +0200
Message-ID: <20200508220015.11528-4-guoqing.jiang@cloud.ionos.com>
References: <20200508220015.11528-1-guoqing.jiang@cloud.ionos.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dPhyON5t2lsnMJZ8HYi8BZ7gzQdWEyhKhPMeJVZANdc=;
        b=dUQcdsq4s73ekjBnKr6uL+EYjUYek6QBStLy8HUJV0SiYzsM3N3K7iYsKDel+pfhgP
         WDM2In7qIiPDBRsSfOuvAm8ofB0bJkj1B8lS3ztan7fVynzuYTfKdxqA0bwQwj0xB5uZ
         HkBTqGamIv3aIqL8VqFYRCiuNgwbc1SulcPVeN63xZ30cvLq1F6Ixs4SVkR753AW5jDW
         45jZU3+g7AMe1ltqRboBgcShGyLe6ja1i8QnrPcKgm+XEk5XXgjsKyGpZJGnckaXMw4q
         CcCpUU+W4llxARrHFqg2hd69tozoZtd/jgn3AI7Y6XE9yUY7n6965AJm/ttoiMKdLLtc
         n+eA==
In-Reply-To: <20200508220015.11528-1-guoqing.jiang-8+5b1tb3oTXfrHaScsAUWw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guoqing Jiang <guoqing.jiang-8+5b1tb3oTXfrHaScsAUWw@public.gmane.org>

No one call this function after commit 2af2783f2ea4f ("rq-qos: get rid of
redundant wbt_update_limits()"), so remove it.

Signed-off-by: Guoqing Jiang <guoqing.jiang-8+5b1tb3oTXfrHaScsAUWw@public.gmane.org>
---
 block/blk-wbt.c | 8 --------
 block/blk-wbt.h | 4 ----
 2 files changed, 12 deletions(-)

diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index 9cb082f38b93..78bb624cce53 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -418,14 +418,6 @@ static void __wbt_update_limits(struct rq_wb *rwb)
 	rwb_wake_all(rwb);
 }
 
-void wbt_update_limits(struct request_queue *q)
-{
-	struct rq_qos *rqos = wbt_rq_qos(q);
-	if (!rqos)
-		return;
-	__wbt_update_limits(RQWB(rqos));
-}
-
 u64 wbt_get_min_lat(struct request_queue *q)
 {
 	struct rq_qos *rqos = wbt_rq_qos(q);
diff --git a/block/blk-wbt.h b/block/blk-wbt.h
index 8e4e37660971..16bdc85b8df9 100644
--- a/block/blk-wbt.h
+++ b/block/blk-wbt.h
@@ -88,7 +88,6 @@ static inline unsigned int wbt_inflight(struct rq_wb *rwb)
 #ifdef CONFIG_BLK_WBT
 
 int wbt_init(struct request_queue *);
-void wbt_update_limits(struct request_queue *);
 void wbt_disable_default(struct request_queue *);
 void wbt_enable_default(struct request_queue *);
 
@@ -108,9 +107,6 @@ static inline int wbt_init(struct request_queue *q)
 {
 	return -EINVAL;
 }
-static inline void wbt_update_limits(struct request_queue *q)
-{
-}
 static inline void wbt_disable_default(struct request_queue *q)
 {
 }
-- 
2.17.1

