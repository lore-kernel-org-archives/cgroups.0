From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/10] block/rq_qos: add rq_qos_merge()
Date: Wed, 28 Aug 2019 15:05:54 -0700
Message-ID: <20190828220600.2527417-5-tj@kernel.org>
References: <20190828220600.2527417-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=85wyZs3HMu6iXK+wZ0W8BFNcrkDk5YmJ/FXIK4MM3S8=;
        b=cG+3/ed+q1RdEnqmWH4ftRcuxyp4xnZQof6cm/OxQXjNXAi+nZbBEnX10Jw0NfVdM/
         O9nEbP/1s2E7IfITAwQTVpdRRflbD/FAQK83XRL36CN8o8HwKTzka1Sny7JjJYreVXbA
         4rYCz2XdATy2L/df9Y743cFRjramsvYTkyDu5QoTrZTrpylaHzR4hB9NVfaoGSKfD+ME
         7iVYTTPjGExBhPoYs5HYXOjn5qKYoYoM1cj95smDJWQKRv4ztSF8H2y0h3fz7iVw2QFh
         7DJ1YBNI3TTW9LtcBctjZ7kYYWKeOwe8cWb3EhhKI82e/f3cST1zRbpMzdMyfE7I15fU
         hJdQ==
In-Reply-To: <20190828220600.2527417-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, newella@fb.com, clm@fb.com, josef@toxicpanda.com, dennisz@fb.com, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>

Add a merge hook for rq_qos.  This will be used by io.weight.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c   | 4 ++++
 block/blk-rq-qos.c | 9 +++++++++
 block/blk-rq-qos.h | 9 +++++++++
 3 files changed, 22 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 77807a5d7f9e..875e8d105067 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -604,6 +604,7 @@ bool bio_attempt_back_merge(struct request *req, struct bio *bio,
 		return false;
 
 	trace_block_bio_backmerge(req->q, req, bio);
+	rq_qos_merge(req->q, req, bio);
 
 	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
 		blk_rq_set_mixed_merge(req);
@@ -625,6 +626,7 @@ bool bio_attempt_front_merge(struct request *req, struct bio *bio,
 		return false;
 
 	trace_block_bio_frontmerge(req->q, req, bio);
+	rq_qos_merge(req->q, req, bio);
 
 	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
 		blk_rq_set_mixed_merge(req);
@@ -650,6 +652,8 @@ bool bio_attempt_discard_merge(struct request_queue *q, struct request *req,
 	    blk_rq_get_max_sectors(req, blk_rq_pos(req)))
 		goto no_merge;
 
+	rq_qos_merge(q, req, bio);
+
 	req->biotail->bi_next = bio;
 	req->biotail = bio;
 	req->__data_len += bio->bi_iter.bi_size;
diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index 3954c0dc1443..f4eea78f5cc1 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -83,6 +83,15 @@ void __rq_qos_track(struct rq_qos *rqos, struct request *rq, struct bio *bio)
 	} while (rqos);
 }
 
+void __rq_qos_merge(struct rq_qos *rqos, struct request *rq, struct bio *bio)
+{
+	do {
+		if (rqos->ops->merge)
+			rqos->ops->merge(rqos, rq, bio);
+		rqos = rqos->next;
+	} while (rqos);
+}
+
 void __rq_qos_done_bio(struct rq_qos *rqos, struct bio *bio)
 {
 	do {
diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index 2300e038b9fa..8e426a8505b6 100644
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -35,6 +35,7 @@ struct rq_qos {
 struct rq_qos_ops {
 	void (*throttle)(struct rq_qos *, struct bio *);
 	void (*track)(struct rq_qos *, struct request *, struct bio *);
+	void (*merge)(struct rq_qos *, struct request *, struct bio *);
 	void (*issue)(struct rq_qos *, struct request *);
 	void (*requeue)(struct rq_qos *, struct request *);
 	void (*done)(struct rq_qos *, struct request *);
@@ -135,6 +136,7 @@ void __rq_qos_issue(struct rq_qos *rqos, struct request *rq);
 void __rq_qos_requeue(struct rq_qos *rqos, struct request *rq);
 void __rq_qos_throttle(struct rq_qos *rqos, struct bio *bio);
 void __rq_qos_track(struct rq_qos *rqos, struct request *rq, struct bio *bio);
+void __rq_qos_merge(struct rq_qos *rqos, struct request *rq, struct bio *bio);
 void __rq_qos_done_bio(struct rq_qos *rqos, struct bio *bio);
 
 static inline void rq_qos_cleanup(struct request_queue *q, struct bio *bio)
@@ -185,6 +187,13 @@ static inline void rq_qos_track(struct request_queue *q, struct request *rq,
 		__rq_qos_track(q->rq_qos, rq, bio);
 }
 
+static inline void rq_qos_merge(struct request_queue *q, struct request *rq,
+				struct bio *bio)
+{
+	if (q->rq_qos)
+		__rq_qos_merge(q->rq_qos, rq, bio);
+}
+
 void rq_qos_exit(struct request_queue *);
 
 #endif
-- 
2.17.1

