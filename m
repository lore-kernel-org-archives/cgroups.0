From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next v4 2/4] blk-throttle: prevent overflow while calculating wait time
Date: Mon, 23 May 2022 16:26:31 +0800
Message-ID: <20220523082633.2324980-3-yukuai3@huawei.com>
References: <20220523082633.2324980-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220523082633.2324980-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

in tg_with_in_bps_limit(), 'bps_limit * jiffy_elapsed_rnd' might
overflow, handle the case by calling mul_u64_u64_div_u64() instead.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 0c37be08ff28..7e0c31e920dd 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -806,7 +806,7 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 				 u64 bps_limit, unsigned long *wait)
 {
 	bool rw = bio_data_dir(bio);
-	u64 bytes_allowed, extra_bytes, tmp;
+	u64 bytes_allowed, extra_bytes;
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 	unsigned int bio_size = throtl_bio_data_size(bio);
 
@@ -824,10 +824,8 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
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

