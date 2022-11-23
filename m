From: Kemeng Shi <shikemeng@huawei.com>
Subject: [PATCH 02/11] blk-throttle: Fix that bps of child could exceed bps limited in parent
Date: Wed, 23 Nov 2022 14:03:52 +0800
Message-ID: <20221123060401.20392-3-shikemeng@huawei.com>
References: <20221123060401.20392-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221123060401.20392-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com

Consider situation as following (on the default hierarchy):
 HDD
  |
root (bps limit: 4k)
  |
child (bps limit :8k)
  |
fio bs=8k
Rate of fio is supposed to be 4k, but result is 8k. Reason is as
following:
Size of single IO from fio is larger than bytes allowed in one
throtl_slice in child, so IOs are always queued in child group first.
When queued IOs in child are dispatched to parent group, BIO_BPS_THROTTLED
is set and these IOs will not be limited by tg_within_bps_limit anymore.
Fix this by:
1. Limit IO with BIO_BPS_THROTTLED flag in tg_within_bps_limit.
2. Ignore BIO_BPS_THROTTLED flag when accouting in throtl_charge_bio.
There changes have no influence on situation which is not on the default
hierarchy as each group is a single root group without parent.

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
---
 block/blk-throttle.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 96aa53e30e28..b33bcf53b36e 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -856,8 +856,7 @@ static bool tg_within_bps_limit(struct throtl_grp *tg, struct bio *bio,
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 	unsigned int bio_size = throtl_bio_data_size(bio);
 
-	/* no need to throttle if this bio's bytes have been accounted */
-	if (bps_limit == U64_MAX || bio_flagged(bio, BIO_BPS_THROTTLED)) {
+	if (bps_limit == U64_MAX) {
 		if (wait)
 			*wait = 0;
 		return true;
@@ -964,10 +963,8 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 	unsigned int bio_size = throtl_bio_data_size(bio);
 
 	/* Charge the bio to the group */
-	if (!bio_flagged(bio, BIO_BPS_THROTTLED)) {
-		tg->bytes_disp[rw] += bio_size;
-		tg->last_bytes_disp[rw] += bio_size;
-	}
+	tg->bytes_disp[rw] += bio_size;
+	tg->last_bytes_disp[rw] += bio_size;
 
 	tg->io_disp[rw]++;
 	tg->last_io_disp[rw]++;
-- 
2.30.0

