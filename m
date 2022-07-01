From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH RESEND v6 1/8] blk-throttle: fix that io throttle can only work for single bio
Date: Fri,  1 Jul 2022 17:34:34 +0800
Message-ID: <20220701093441.885741-2-yukuai1@huaweicloud.com>
References: <20220701093441.885741-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220701093441.885741-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, mkoutny@suse.com, axboe@kernel.dk, ming.lei@redhat.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

commit 9f5ede3c01f9 ("block: throttle split bio in case of iops limit")
introduce a new problem, for example:

Test scripts:
cd /sys/fs/cgroup/blkio/
echo "8:0 1024" > blkio.throttle.write_bps_device
echo $$ > cgroup.procs
dd if=/dev/zero of=/dev/sda bs=10k count=1 oflag=direct &
dd if=/dev/zero of=/dev/sda bs=10k count=1 oflag=direct &

Test result:
10240 bytes (10 kB, 10 KiB) copied, 10.0134 s, 1.0 kB/s
10240 bytes (10 kB, 10 KiB) copied, 10.0135 s, 1.0 kB/s

The problem is that the second bio is finished after 10s instead of 20s.
This is because if some bios are already queued, current bio is queued
directly and the flag 'BIO_THROTTLED' is set. And later, when former
bios are dispatched, this bio will be dispatched without waiting at all,
this is due to tg_with_in_bps_limit() return 0 for this bio.

In order to fix the problem, don't skip flaged bio in
tg_with_in_bps_limit(), and for the problem that split bio can be
double accounted, compensate the over-accounting in __blk_throtl_bio().

Fixes: 9f5ede3c01f9 ("block: throttle split bio in case of iops limit")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-throttle.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 139b2d7a99e2..5c1d1c4d8188 100644
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
@@ -921,11 +921,8 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 	unsigned int bio_size = throtl_bio_data_size(bio);
 
 	/* Charge the bio to the group */
-	if (!bio_flagged(bio, BIO_THROTTLED)) {
-		tg->bytes_disp[rw] += bio_size;
-		tg->last_bytes_disp[rw] += bio_size;
-	}
-
+	tg->bytes_disp[rw] += bio_size;
+	tg->last_bytes_disp[rw] += bio_size;
 	tg->io_disp[rw]++;
 	tg->last_io_disp[rw]++;
 
@@ -2121,6 +2118,21 @@ bool __blk_throtl_bio(struct bio *bio)
 			tg->last_low_overflow_time[rw] = jiffies;
 		throtl_downgrade_check(tg);
 		throtl_upgrade_check(tg);
+
+		/*
+		 * re-entered bio has accounted bytes already, so try to
+		 * compensate previous over-accounting. However, if new
+		 * slice is started, just forget it.
+		 */
+		if (bio_flagged(bio, BIO_THROTTLED)) {
+			unsigned int bio_size = throtl_bio_data_size(bio);
+
+			if (tg->bytes_disp[rw] >= bio_size)
+				tg->bytes_disp[rw] -= bio_size;
+			if (tg->last_bytes_disp[rw] >= bio_size)
+				tg->last_bytes_disp[rw] -= bio_size;
+		}
+
 		/* throtl is FIFO - if bios are already queued, should queue */
 		if (sq->nr_queued[rw])
 			break;
-- 
2.31.1

