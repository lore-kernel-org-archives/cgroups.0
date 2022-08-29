From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH v9 2/4] blk-throttle: prevent overflow while calculating wait time
Date: Mon, 29 Aug 2022 10:22:38 +0800
Message-ID: <20220829022240.3348319-3-yukuai1@huaweicloud.com>
References: <20220829022240.3348319-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220829022240.3348319-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk, tj@kernel.org, mkoutny@suse.com, ming.lei@redhat.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

There is a problem found by code review in tg_with_in_bps_limit() that
'bps_limit * jiffy_elapsed_rnd' might overflow. Fix the problem by
calling mul_u64_u64_div_u64() instead.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-throttle.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 7a4c815e0f23..d193a738a966 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -809,7 +809,7 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 				 u64 bps_limit, unsigned long *wait)
 {
 	bool rw = bio_data_dir(bio);
-	u64 bytes_allowed, extra_bytes, tmp;
+	u64 bytes_allowed, extra_bytes;
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 	unsigned int bio_size = throtl_bio_data_size(bio);
 
@@ -827,10 +827,8 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 		jiffy_elapsed_rnd = tg->td->throtl_slice;
 
 	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, tg->td->throtl_slice);
-
-	tmp = bps_limit * jiffy_elapsed_rnd;
-	do_div(tmp, HZ);
-	bytes_allowed = tmp;
+	bytes_allowed = mul_u64_u64_div_u64(bps_limit, (u64)jiffy_elapsed_rnd,
+					    (u64)HZ);
 
 	if (tg->bytes_disp[rw] + bio_size <= bytes_allowed) {
 		if (wait)
-- 
2.31.1

