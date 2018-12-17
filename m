From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH v3] block: fix blk-iolatency accounting underflow
Date: Mon, 17 Dec 2018 11:03:51 -0500
Message-ID: <20181217160351.27903-1-dennis@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>

The blk-iolatency controller measures the time from rq_qos_throttle() to
rq_qos_done_bio() and attributes this time to the first bio that needs
to create the request. This means if a bio is plug-mergeable or
bio-mergeable, it gets to bypass the blk-iolatency controller.

The recent series [1], to tag all bios w/ blkgs undermined how iolatency
was determining which bios it was charging and should process in
rq_qos_done_bio(). Because all bios are being tagged, this caused the
atomic_t for the struct rq_wait inflight count to underflow and result
in a stall.

This patch adds a new flag BIO_TRACKED to let controllers know that a
bio is going through the rq_qos path. blk-iolatency now checks if this
flag is set to see if it should process the bio in rq_qos_done_bio().

Overloading BLK_QUEUE_ENTERED works, but makes the flag rules confusing.
BIO_THROTTLED was another candidate, but the flag is set for all bios
that have gone through blk-throttle code. Overloading a flag comes with
the burden of making sure that when either implementation changes, a
change in setting rules for one doesn't cause a bug in the other. So
here, we unfortunately opt for adding a new flag.

[1] https://lore.kernel.org/lkml/20181205171039.73066-1-dennis@kernel.org/

Fixes: 5cdf2e3fea5e ("blkcg: associate blkg when associating a device")
Signed-off-by: Dennis Zhou <dennis@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
---
 block/blk-iolatency.c     | 2 +-
 block/blk-rq-qos.h        | 5 +++++
 include/linux/blk_types.h | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index bee092727cad..fc714ef402a6 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -593,7 +593,7 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
 	bool enabled = false;
 
 	blkg = bio->bi_blkg;
-	if (!blkg)
+	if (!blkg || !bio_flagged(bio, BIO_TRACKED))
 		return;
 
 	iolat = blkg_to_lat(bio->bi_blkg);
diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index fd8a0c5debd3..58f62483b537 100644
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -170,6 +170,11 @@ static inline void rq_qos_done_bio(struct request_queue *q, struct bio *bio)
 
 static inline void rq_qos_throttle(struct request_queue *q, struct bio *bio)
 {
+	/*
+	 * BIO_TRACKED lets controllers know that a bio went through the
+	 * normal rq_qos path.
+	 */
+	bio_set_flag(bio, BIO_TRACKED);
 	if (q->rq_qos)
 		__rq_qos_throttle(q->rq_qos, bio);
 }
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 46c005d601ac..fc99474ac968 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -228,6 +228,7 @@ struct bio {
 #define BIO_TRACE_COMPLETION 10	/* bio_endio() should trace the final completion
 				 * of this bio. */
 #define BIO_QUEUE_ENTERED 11	/* can use blk_queue_enter_live() */
+#define BIO_TRACKED 12		/* set if bio goes through the rq_qos path */
 
 /* See BVEC_POOL_OFFSET below before adding new flags */
 
-- 
2.17.1

