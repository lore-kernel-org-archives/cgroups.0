From: Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 3/7] blkcg: associate a request with its blkcg_gq instead
 of request_list
Date: Mon, 13 Nov 2017 12:15:23 -0800
Message-ID: <20171113201523.GM983427@devbig577.frc2.facebook.com>
References: <20171112222613.3613362-1-tj@kernel.org>
 <20171112222613.3613362-4-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=n98JD95i1wlSMBe4QPkU3CdTpDARzZmREeiDfvO9zFw=;
        b=ivFf2PHEdw9rRpnEexaYqAii1k++WeY0859IBqZFD2gZJT/gBgvQrs+uGpv6gxks38
         NOKKG4dbgKlhMFXMF2u4108OUcR2TgQc5SqUIAL6uDvQHSusugs1wh8DgnWNGEDUWl9W
         Pd+KpNW/snnPP9tI7RrTQFuCkYIqrwX83EZF6fOPQm74jNRyy6izBGQOC/H9wbeZq1IH
         eNAwooR8ix8YdJDx6Wk2fv5jgzO6EhjumYzgUnrWmL/q1py9cykGeVa/VOdGkDKvQXbL
         xJ0zDFOdflaQCwSKuKAzSJWtw44vkqaFAy++epv/V7lQH2gJy98t0P4BZkHKHaj5e4Qi
         Gpdg==
Content-Disposition: inline
In-Reply-To: <20171112222613.3613362-4-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: shli@kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, guro@fb.com

From c856a199ec70e4022e997609f1b17b9106408777 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Mon, 13 Nov 2017 12:11:57 -0800

On the legacy request_queue, each blkcg_gq has a dedicated
request_list that requests for the cgroup are allocated from.  Each
request points to the originating request_list and cgroup membership
can be determined by examining which cgroup the associated
request_list belongs to.

This doesn't work for blk-mq which doesn't use request_list.  Let's
associate each request with the blkcg_gq directly.  Except for minor
wrapper changes, this doesn't affect the legacy request_queue and will
allow blk-mq to track each request's cgroup association.

v2: Build fix for !CONFIG_BLK_CGROUP.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-mq.c             | 2 +-
 include/linux/blk-cgroup.h | 7 +++++--
 include/linux/blkdev.h     | 2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 98a1860..af958c4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -306,7 +306,7 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 	rq->part = NULL;
 	rq->start_time = jiffies;
 #ifdef CONFIG_BLK_CGROUP
-	rq->rl = NULL;
+	rq->blkg = NULL;
 	set_start_time_ns(rq);
 	rq->io_start_time_ns = 0;
 #endif
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index c0d4736..47db75a 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -463,7 +463,7 @@ static inline void blk_put_rl(struct request_list *rl)
  */
 static inline void blk_rq_set_rl(struct request *rq, struct request_list *rl)
 {
-	rq->rl = rl;
+	rq->blkg = rl->blkg;
 }
 
 /**
@@ -474,7 +474,10 @@ static inline void blk_rq_set_rl(struct request *rq, struct request_list *rl)
  */
 static inline struct request_list *blk_rq_rl(struct request *rq)
 {
-	return rq->rl;
+	if (!rq->blkg->parent)
+		return &rq->q->root_rl;
+	else
+		return &rq->blkg->rl;
 }
 
 struct request_list *__blk_queue_next_rl(struct request_list *rl,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8da6637..6ec1067 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -206,7 +206,7 @@ struct request {
 	unsigned long start_time;
 	struct blk_issue_stat issue_stat;
 #ifdef CONFIG_BLK_CGROUP
-	struct request_list *rl;		/* rl this rq is alloced from */
+	struct blkcg_gq *blkg;			/* blkg of this rq */
 	unsigned long long start_time_ns;
 	unsigned long long io_start_time_ns;    /* when passed to hardware */
 #endif
-- 
2.9.5

