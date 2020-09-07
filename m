From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH 5/5] blk-throttle: Avoid checking bps/iops limitation if bps or iops is unlimited
Date: Mon,  7 Sep 2020 16:10:17 +0800
Message-ID: <a4fab3f329b3334850c508e824e137dfc9b29025.1599458244.git.baolin.wang@linux.alibaba.com>
References: <cover.1599458244.git.baolin.wang@linux.alibaba.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <cover.1599458244.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <cover.1599458244.git.baolin.wang@linux.alibaba.com>
References: <cover.1599458244.git.baolin.wang@linux.alibaba.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: baolin.wang@linux.alibaba.com, baolin.wang7@gmail.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Do not need check the bps or iops limitation if bps or iops is unlimited.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 block/blk-throttle.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 8719e37..36ba61c 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -901,6 +901,12 @@ static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bio,
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 	u64 tmp;
 
+	if (iops_limit == UINT_MAX) {
+		if (wait)
+			*wait = 0;
+		return true;
+	}
+
 	jiffy_elapsed = jiffies - tg->slice_start[rw];
 
 	/* Round up to the next throttle slice, wait time must be nonzero */
@@ -943,6 +949,12 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 	unsigned int bio_size = throtl_bio_data_size(bio);
 
+	if (bps_limit == U64_MAX) {
+		if (wait)
+			*wait = 0;
+		return true;
+	}
+
 	jiffy_elapsed = jiffy_elapsed_rnd = jiffies - tg->slice_start[rw];
 
 	/* Slice has just started. Consider one slice interval */
-- 
1.8.3.1

