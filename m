From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH v2] block: fix iolat timestamp and restore accounting semantics
Date: Tue, 11 Dec 2018 18:01:14 -0500
Message-ID: <20181211230114.65967-1-dennis@kernel.org>
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

The recent series, to tag all bios w/ blkgs in [1] changed the timing
incorrectly as well. First, the iolatency controller was tagging bios
and using that information if it should process it in rq_qos_done_bio().
However, now that all bios are tagged, this caused the atomic_t for the
struct rq_wait inflight count to underflow resulting in a stall. Second,
now the timing was using the duration a bio from generic_make_request()
rather than the timing mentioned above.

This patch fixes these issues by reusing the BLK_QUEUE_ENTERED flag to
determine if a bio has entered the request layer and is responsible for
starting a request. Stacked drivers don't recurse through
blk_mq_make_request(), so the overhead of using time between
generic_make_request() and the blk_mq_get_request() should be minimal.
blk-iolatency now checks if this flag is set to determine if it should
process the bio in rq_qos_done_bio().

[1] https://lore.kernel.org/lkml/20181205171039.73066-1-dennis@kernel.org/

Fixes: 5cdf2e3fea5e ("blkcg: associate blkg when associating a device")
Signed-off-by: Dennis Zhou <dennis@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
---
v2:
- Switched to reusing BIO_QUEUE_ENTERED rather than adding a second
  timestamp to the bio struct.

 block/blk-iolatency.c |  2 +-
 block/blk-mq.c        | 12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index bee092727cad..e408282bdc4c 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -593,7 +593,7 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
 	bool enabled = false;
 
 	blkg = bio->bi_blkg;
-	if (!blkg)
+	if (!blkg || !bio_flagged(bio, BIO_QUEUE_ENTERED))
 		return;
 
 	iolat = blkg_to_lat(bio->bi_blkg);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9690f4f8de7e..05ac940e6671 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1920,6 +1920,17 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	struct request *same_queue_rq = NULL;
 	blk_qc_t cookie;
 
+	/*
+	 * The flag BIO_QUEUE_ENTERED is used for two purposes.  First, it
+	 * determines if a bio is being split and has already entered the queue.
+	 * This happens in blk_queue_split() where we can recursively call
+	 * generic_make_request().  The second use is to mark bios that will
+	 * call rq_qos_throttle() and subseqently blk_mq_get_request().  These
+	 * are the bios that fail plug-merging and bio-merging with the primary
+	 * use case for this being the blk-iolatency controller.
+	 */
+	bio_clear_flag(bio, BIO_QUEUE_ENTERED);
+
 	blk_queue_bounce(q, &bio);
 
 	blk_queue_split(q, &bio);
@@ -1934,6 +1945,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	if (blk_mq_sched_bio_merge(q, bio))
 		return BLK_QC_T_NONE;
 
+	bio_set_flag(bio, BIO_QUEUE_ENTERED);
 	rq_qos_throttle(q, bio);
 
 	rq = blk_mq_get_request(q, bio, &data);
-- 
2.17.1

