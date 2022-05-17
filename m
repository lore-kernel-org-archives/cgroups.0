From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH -next] blk-throttle: delay the setting of 'BIO_THROTTLED' to when throttle is done
Date: Tue, 17 May 2022 21:49:09 +0800
Message-ID: <20220517134909.2910251-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk, ming.lei@redhat.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

commit 9f5ede3c01f9 ("block: throttle split bio in case of iops limit")
introduce a new problem, for example:

[root@localhost ~]# echo "8:0 1024" > /sys/fs/cgroup/blkio/blkio.throttle.write_bps_device
[root@localhost ~]# echo $$ > /sys/fs/cgroup/blkio/cgroup.procs
[root@localhost ~]# dd if=/dev/zero of=/dev/sda bs=10k count=1 oflag=direct &
[1] 620
[root@localhost ~]# dd if=/dev/zero of=/dev/sda bs=10k count=1 oflag=direct &
[2] 626
[root@localhost ~]# 1+0 records in
1+0 records out
10240 bytes (10 kB, 10 KiB) copied, 10.0038 s, 1.0 kB/s1+0 records in
1+0 records out

10240 bytes (10 kB, 10 KiB) copied, 9.23076 s, 1.1 kB/s
-> the second bio is issued after 10s instead of 20s.

This is because if some bios are already queued, current bio is queued
directly and the flag 'BIO_THROTTLED' is set. And later, when former
bios are dispatched, this bio will be dispatched without waiting at all,
this is due to tg_with_in_bps_limit() will return 0 if the flag is set.

Instead of setting the flag when bio starts throttle, delay to when
throttle is done to fix the problem.

Fixes: 9f5ede3c01f9 ("block: throttle split bio in case of iops limit")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-throttle.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 447e1b8722f7..f952f2d942ff 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -811,7 +811,7 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 	unsigned int bio_size = throtl_bio_data_size(bio);
 
 	/* no need to throttle if this bio's bytes have been accounted */
-	if (bps_limit == U64_MAX || bio_flagged(bio, BIO_THROTTLED)) {
+	if (bps_limit == U64_MAX) {
 		if (wait)
 			*wait = 0;
 		return true;
@@ -1226,8 +1226,10 @@ static void blk_throtl_dispatch_work_fn(struct work_struct *work)
 
 	spin_lock_irq(&q->queue_lock);
 	for (rw = READ; rw <= WRITE; rw++)
-		while ((bio = throtl_pop_queued(&td_sq->queued[rw], NULL)))
+		while ((bio = throtl_pop_queued(&td_sq->queued[rw], NULL))) {
+			bio_set_flag(bio, BIO_THROTTLED);
 			bio_list_add(&bio_list_on_stack, bio);
+		}
 	spin_unlock_irq(&q->queue_lock);
 
 	if (!bio_list_empty(&bio_list_on_stack)) {
@@ -2134,7 +2136,8 @@ bool __blk_throtl_bio(struct bio *bio)
 			}
 			break;
 		}
-
+		/* this bio will be issued directly */
+		bio_set_flag(bio, BIO_THROTTLED);
 		/* within limits, let's charge and dispatch directly */
 		throtl_charge_bio(tg, bio);
 
@@ -2190,7 +2193,6 @@ bool __blk_throtl_bio(struct bio *bio)
 
 out_unlock:
 	spin_unlock_irq(&q->queue_lock);
-	bio_set_flag(bio, BIO_THROTTLED);
 
 #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
 	if (throttled || !td->track_bio_latency)
-- 
2.31.1

