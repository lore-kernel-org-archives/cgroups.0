From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/7] blkcg: associate a request with its blkcg_gq instead of request_list
Date: Sun, 12 Nov 2017 14:26:09 -0800
Message-ID: <20171112222613.3613362-4-tj@kernel.org>
References: <20171112222613.3613362-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Li9ges/6BZW2yXRJZABix+mKPEDNuzQuiyW8R/wCfZ8=;
        b=lhsJpQ+b6YUJimWoqw4txdTgBSuViMhzqLMFlpdpd+LvNHDjPlbwe9Chk7OgRpRc9d
         7Iood23nRIZN41jyaDz7NgNyFH+LT6qUTr5XWbzCAxb2GY7vYHjrtKoqKu1BnvMDdQl2
         ZaYVrZ+EWn1bQYsHZqRVg8mzFuycKINzsv0Rmk0Bw5F84gg4C9j/2P98kG6pu2zkWPPb
         eXkFFStOOULgE4Qa6/Om9zeS2pd2FNwFlh0neN62U6iKN/X/2/Y3JStW8+ZeV6+4GYAs
         bDJMFcwY8fLFdVgSqHr5yFNjUseQB5c8l8iSP+NPH4cq66OvbvQ3bRdPALq4c0mcy5hO
         n0gA==
In-Reply-To: <20171112222613.3613362-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: shli@kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, guro@fb.com, Tejun Heo <tj@kernel.org>

On the legacy request_queue, each blkcg_gq has a dedicated
request_list that requests for the cgroup are allocated from.  Each
request points to the originating request_list and cgroup membership
can be determined by examining which cgroup the associated
request_list belongs to.

This doesn't work for blk-mq which doesn't use request_list.  Let's
associate each request with the blkcg_gq directly.  Except for minor
wrapper changes, this doesn't affect the legacy request_queue and will
allow blk-mq to track each request's cgroup association.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-mq.c             | 2 +-
 include/linux/blk-cgroup.h | 9 ++++++---
 include/linux/blkdev.h     | 2 +-
 3 files changed, 8 insertions(+), 5 deletions(-)

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
index c0d4736..b5721d32 100644
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
@@ -762,7 +765,7 @@ static inline void blkg_put(struct blkcg_gq *blkg) { }
 static inline struct request_list *blk_get_rl(struct request_queue *q,
 					      struct bio *bio) { return &q->root_rl; }
 static inline void blk_put_rl(struct request_list *rl) { }
-static inline void blk_rq_set_rl(struct request *rq, struct request_list *rl) { }
+static inline void blk_rq_set_blkg(struct request *rq, struct blkcg_gq *blkg) { }
 static inline struct request_list *blk_rq_rl(struct request *rq) { return &rq->q->root_rl; }
 
 static inline bool blkcg_bio_issue_check(struct request_queue *q,
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

