From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 5/7] blkcg: associate blk-mq requests with the matching blkcg_gqs
Date: Sun, 12 Nov 2017 14:26:11 -0800
Message-ID: <20171112222613.3613362-6-tj@kernel.org>
References: <20171112222613.3613362-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ephCEeyd+9iiVZ3j8A3vkDIK3R8WKrBOsM8jeivKqdU=;
        b=G4V/43oLsuIWWT6n8Txt6uYHnyuu4FIbEVzGQPugQj13Ju1epFDjnSm54yOq0WfF2X
         BDlUIK/aqb4xWqBMk7YR++DNNRzWPnkYe/+pGwUzb7FyRXphH9U7C6qLwUFCNQDGf1Wa
         x9z9A7Zqy/ZHqPq4SNp99rMZrsFpgWLYQFRgjal6Lwd0SCqJ/TDHhp4SXG9+pOj8OXbZ
         217F5nCn9xo+GjNCbl0ixDYIkwOs7FUyS+uW1L8BHt9hUwQ2jDoj4HhIEoUJFgZ9ZzO8
         uggaO0oVG2KQyFQ+McOdyJNPuKNyVCIrZNyakmvpuufv5JiuF85tE82V/sorBKfbR0+i
         FeBA==
In-Reply-To: <20171112222613.3613362-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On legacy request_queues, request allocation through request_list
associates each request with its blkcg_gq.  However, blk-mq doesn't
use request_list and its requests aren't associated with the matching
blkcg_gqs, preventing cgroup-aware tracking blk-mq IOs.

This patch adds blk_rq_[dis]associate_blkg() and use them in blk-mq
request alloc/free paths so that every request is associated with its
blkcg_gq while in-flight.  The added overhead is minimal and per-cpu
in hot paths.  In the future, we also should be able to remove the
more frequent per-bio blkcg_gq operations in blkcg_bio_issue_check()
for blk-mq.

* ->blkcg is added to blk_mq_alloc_data to carry the target blkcg in
  the allocation path.  I didn't #ifdef it for code simplicity.  The
  only overhead when cgroup is disabled is the extra pointer in the
  data structure, which shouldn't matter.

* Moved set_start_time_ns() out of CONFIG_BLK_CGROUP together with
  blk_rq_associate_blkg().  Both functions provide dummy
  implementations when !CONFIG_BLK_CGROUP.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-mq.c             |  9 ++++++---
 block/blk-mq.h             |  1 +
 include/linux/blk-cgroup.h | 42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index af958c4..7cc64de 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -305,9 +305,10 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 	rq->rq_disk = NULL;
 	rq->part = NULL;
 	rq->start_time = jiffies;
-#ifdef CONFIG_BLK_CGROUP
-	rq->blkg = NULL;
+
+	blk_rq_associate_blkg(rq, data->blkcg);
 	set_start_time_ns(rq);
+#ifdef CONFIG_BLK_CGROUP
 	rq->io_start_time_ns = 0;
 #endif
 	rq->nr_phys_segments = 0;
@@ -472,6 +473,8 @@ void blk_mq_free_request(struct request *rq)
 		}
 	}
 
+	blk_rq_disassociate_blkg(rq);
+
 	ctx->rq_completed[rq_is_sync(rq)]++;
 	if (rq->rq_flags & RQF_MQ_INFLIGHT)
 		atomic_dec(&hctx->nr_active);
@@ -1599,7 +1602,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 {
 	const int is_sync = op_is_sync(bio->bi_opf);
 	const int is_flush_fua = op_is_flush(bio->bi_opf);
-	struct blk_mq_alloc_data data = { .flags = 0 };
+	struct blk_mq_alloc_data data = { .flags = 0, .blkcg = bio_blkcg(bio) };
 	struct request *rq;
 	unsigned int request_count = 0;
 	struct blk_plug *plug;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 4933af9..dfb1e1d 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -111,6 +111,7 @@ struct blk_mq_alloc_data {
 	struct request_queue *q;
 	unsigned int flags;
 	unsigned int shallow_depth;
+	struct blkcg *blkcg;
 
 	/* input & output parameter */
 	struct blk_mq_ctx *ctx;
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 1de5158..96eed0f 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -725,6 +725,45 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 	return !throtl;
 }
 
+/**
+ * blk_rq_associate_blkg - lookup and associate a request with its blkcg_gq
+ * @rq: request of interest
+ * @blkcg: target blkcg
+ *
+ * Associate @rq with the matching blkcg_cq of @blkcg.  This is used by
+ * blk-mq to associate requests directly with blkgs without going through
+ * request_list.
+ */
+static inline void blk_rq_associate_blkg(struct request *rq, struct blkcg *blkcg)
+{
+	struct request_queue *q = rq->q;
+	struct blkcg_gq *blkg;
+
+	if (!blkcg) {
+		rq->blkg = q->root_blkg;
+		return;
+	}
+
+	rcu_read_lock();
+	blkg = blkg_lookup_create(blkcg, q);
+	if (likely(blkg == q->root_blkg || percpu_ref_tryget(&blkg->refcnt)))
+		rq->blkg = blkg;
+	else
+		rq->blkg = q->root_blkg;
+	rcu_read_unlock();
+}
+
+/**
+ * blk_rq_disassociate_blkg - undo blk_rq_associate_blkg()
+ * @rq: request of interest
+ */
+static inline void blk_rq_disassociate_blkg(struct request *rq)
+{
+	if (rq->blkg && rq->blkg != rq->q->root_blkg)
+		blkg_put(rq->blkg);
+	rq->blkg = NULL;
+}
+
 #else	/* CONFIG_BLK_CGROUP */
 
 struct blkcg {
@@ -781,6 +820,9 @@ static inline struct request_list *blk_rq_rl(struct request *rq) { return &rq->q
 static inline bool blkcg_bio_issue_check(struct request_queue *q,
 					 struct bio *bio) { return true; }
 
+static inline void blk_rq_associate_blkg(struct request *rq, struct blkcg *blkcg) { }
+static inline void blk_rq_disassociate_blkg(struct request *rq) { }
+
 #define blk_queue_for_each_rl(rl, q)	\
 	for ((rl) = &(q)->root_rl; (rl); (rl) = NULL)
 
-- 
2.9.5
