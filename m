From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: [PATCH v2 06/10] block, bfq: remove redundant bfqd->rq_in_driver > 0 check in bfq_add_request
Date: Fri, 16 Dec 2022 19:12:26 +0800
Message-ID: <20221216111230.3638832-7-shikemeng@huaweicloud.com>
References: <20221216111230.3638832-1-shikemeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221216111230.3638832-1-shikemeng@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, paolo.valente@linaro.org, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linfeilong@huawei.com, liuzhiqiang@26.com, shikemeng@huaweicloud.com

The bfqd->rq_in_driver > 0 check is along with previous
"bfqd->rq_in_driver == 0 ||" check, so no need to re-check
bfqd->rq_in_driver > 0.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
---
 block/bfq-iosched.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index ebcafe3c4c3b..7c91d16dbf6f 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2204,8 +2204,7 @@ static void bfq_add_request(struct request *rq)
 		 */
 		if (bfqq == bfqd->in_service_queue &&
 		    (bfqd->rq_in_driver == 0 ||
-		     (bfqq->last_serv_time_ns > 0 &&
-		      bfqd->rqs_injected && bfqd->rq_in_driver > 0)) &&
+		     (bfqq->last_serv_time_ns > 0 && bfqd->rqs_injected)) &&
 		    time_is_before_eq_jiffies(bfqq->decrease_time_jif +
 					      msecs_to_jiffies(10))) {
 			bfqd->last_empty_occupied_ns = ktime_get_ns();
-- 
2.30.0

