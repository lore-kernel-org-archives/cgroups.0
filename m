From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH] block: fix iolat timestamp and restore accounting semantics
Date: Mon, 10 Dec 2018 11:35:10 -0500
Message-ID: <20181210163510.58985-1-dennis@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
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

This patch fixes the errors by accounting time separately in a bio
adding the field bi_start. If this field is set, the bio should be
processed by blk-iolatency in rq_qos_done_bio().

[1] https://lore.kernel.org/lkml/20181205171039.73066-1-dennis@kernel.org/

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
---
 block/blk-iolatency.c     | 17 ++++++-----------
 include/linux/blk_types.h | 12 ++++++++++++
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index bee092727cad..52d5d7cc387c 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -463,6 +463,8 @@ static void blkcg_iolatency_throttle(struct rq_qos *rqos, struct bio *bio)
 	if (!blk_iolatency_enabled(blkiolat))
 		return;
 
+	bio->bi_start = ktime_get_ns();
+
 	while (blkg && blkg->parent) {
 		struct iolatency_grp *iolat = blkg_to_lat(blkg);
 		if (!iolat) {
@@ -480,18 +482,12 @@ static void blkcg_iolatency_throttle(struct rq_qos *rqos, struct bio *bio)
 }
 
 static void iolatency_record_time(struct iolatency_grp *iolat,
-				  struct bio_issue *issue, u64 now,
+				  struct bio *bio, u64 now,
 				  bool issue_as_root)
 {
-	u64 start = bio_issue_time(issue);
+	u64 start = bio->bi_start;
 	u64 req_time;
 
-	/*
-	 * Have to do this so we are truncated to the correct time that our
-	 * issue is truncated to.
-	 */
-	now = __bio_issue_time(now);
-
 	if (now <= start)
 		return;
 
@@ -593,7 +589,7 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
 	bool enabled = false;
 
 	blkg = bio->bi_blkg;
-	if (!blkg)
+	if (!blkg || !bio->bi_start)
 		return;
 
 	iolat = blkg_to_lat(bio->bi_blkg);
@@ -612,8 +608,7 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
 		atomic_dec(&rqw->inflight);
 		if (!enabled || iolat->min_lat_nsec == 0)
 			goto next;
-		iolatency_record_time(iolat, &bio->bi_issue, now,
-				      issue_as_root);
+		iolatency_record_time(iolat, bio, now, issue_as_root);
 		window_start = atomic64_read(&iolat->window_start);
 		if (now > window_start &&
 		    (now - window_start) >= iolat->cur_win_nsec) {
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 46c005d601ac..c2c02ec08d7c 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -181,6 +181,18 @@ struct bio {
 	 */
 	struct blkcg_gq		*bi_blkg;
 	struct bio_issue	bi_issue;
+#ifdef CONFIG_BLK_CGROUP_IOLATENCY
+	/*
+	 * blk-iolatency measure the time a bio takes between rq_qos_throttle()
+	 * and rq_qos_done_bio().  It attributes the time to the bio that gets
+	 * the request allowing any bios that can tag along via plug merging or
+	 * bio merging to be free (from blk-iolatency's perspective). This is
+	 * different from the time a bio takes from generic_make_request() to
+	 * the end of its life.  So, this also serves as a marker for which bios
+	 * should be processed by blk-iolatency.
+	 */
+	u64			bi_start;
+#endif /* CONFIG_BLK_CGROUP_IOLATENCY */
 #endif
 	union {
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
-- 
2.17.1

