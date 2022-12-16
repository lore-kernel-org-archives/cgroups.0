From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: [PATCH v2 10/10] block, bfq: remove check of bfq_wr_max_softrt_rate which is always greater than 0
Date: Fri, 16 Dec 2022 19:12:30 +0800
Message-ID: <20221216111230.3638832-11-shikemeng@huaweicloud.com>
References: <20221216111230.3638832-1-shikemeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221216111230.3638832-1-shikemeng@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, paolo.valente@linaro.org, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linfeilong@huawei.com, liuzhiqiang@26.com, shikemeng@huaweicloud.com

bfqd->bfq_wr_max_softrt_rate is assigned with 7000 in bfq_init_queue and
never changed. So we can remove bfqd->bfq_wr_max_softrt_rate > 0 check
which is always true.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
---
 block/bfq-iosched.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 91bc68fba72d..00cdd42ac02a 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -1788,8 +1788,7 @@ static void bfq_bfqq_handle_idle_busy_switch(struct bfq_data *bfqd,
 	 *   to control its weight explicitly)
 	 */
 	in_burst = bfq_bfqq_in_large_burst(bfqq);
-	soft_rt = bfqd->bfq_wr_max_softrt_rate > 0 &&
-		!BFQQ_TOTALLY_SEEKY(bfqq) &&
+	soft_rt = !BFQQ_TOTALLY_SEEKY(bfqq) &&
 		!in_burst &&
 		time_is_before_jiffies(bfqq->soft_rt_next_start) &&
 		bfqq->dispatched == 0 &&
@@ -4284,8 +4283,7 @@ void bfq_bfqq_expire(struct bfq_data *bfqd,
 	if (bfqd->low_latency && bfqq->wr_coeff == 1)
 		bfqq->last_wr_start_finish = jiffies;
 
-	if (bfqd->low_latency && bfqd->bfq_wr_max_softrt_rate > 0 &&
-	    RB_EMPTY_ROOT(&bfqq->sort_list)) {
+	if (bfqd->low_latency && RB_EMPTY_ROOT(&bfqq->sort_list)) {
 		/*
 		 * If we get here, and there are no outstanding
 		 * requests, then the request pattern is isochronous
-- 
2.30.0

