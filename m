From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH v7 5/9] blk-throttle: improve handling of re-entered bio for bps limit
Date: Tue,  2 Aug 2022 22:04:11 +0800
Message-ID: <20220802140415.2960284-6-yukuai1@huaweicloud.com>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220802140415.2960284-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Currently, if new slice is started while bio is re-entered, such bio
will count multiple times for bps limit. Since 'bytes_skipped'
represents how many bytes will be skipped while dispatching bios, which
can handle that case, increasing it instead of decreasing 'bytes_disp'.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 8 ++++----
 block/blk-throttle.h | 4 +++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 621402cf2576..237668328e98 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2183,14 +2183,14 @@ bool __blk_throtl_bio(struct bio *bio)
 		 * Splited bios can be re-entered because iops limit should be
 		 * counted again, however, bps limit should not. Since bps limit
 		 * will be counted again while dispatching it, compensate the
-		 * over-accounting here. Noted that compensation can fail if
-		 * new slice is started.
+		 * over-accounting here. Since decrement of 'bytes_disp' can't
+		 * handle the case that new slice is started, increase
+		 * 'bytes_skipped' instead.
 		 */
 		if (bio_flagged(bio, BIO_THROTTLED)) {
 			unsigned int bio_size = throtl_bio_data_size(bio);
 
-			if (tg->bytes_disp[rw] >= bio_size)
-				tg->bytes_disp[rw] -= bio_size;
+			tg->bytes_skipped[rw] += bio_size;
 			if (tg->last_bytes_disp[rw] >= bio_size)
 				tg->last_bytes_disp[rw] -= bio_size;
 		}
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index 0163aa9104c3..c9545616ba12 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -121,7 +121,9 @@ struct throtl_grp {
 	 * bytes/io are waited already in previous configuration, and they will
 	 * be used to calculate wait time under new configuration.
 	 *
-	 * Number of bytes will be skipped in current slice
+	 * Number of bytes will be skipped in current slice. In addition, this
+	 * field will help to handle re-entered bio for bps limit, see details
+	 * in __blk_throtl_bio().
 	 */
 	uint64_t bytes_skipped[2];
 	/* Number of bio will be skipped in current slice */
-- 
2.31.1

