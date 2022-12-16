From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: [PATCH v2 01/10] block, bfq: correctly raise inject limit in bfq_choose_bfqq_for_injection
Date: Fri, 16 Dec 2022 19:12:21 +0800
Message-ID: <20221216111230.3638832-2-shikemeng@huaweicloud.com>
References: <20221216111230.3638832-1-shikemeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221216111230.3638832-1-shikemeng@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, paolo.valente@linaro.org, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linfeilong@huawei.com, liuzhiqiang@26.com, shikemeng@huaweicloud.com

Function bfq_choose_bfqq_for_injection may temporarily raise inject limit
to one request if current inject_limit is 0 before search of the source
queue for injection. However the search below will reset inject limit to
bfqd->in_service_queue which is zero for raised inject limit. Then the
temporarily raised inject limit never works as expected.
Assigment limit to bfqd->in_service_queue in search is needed as limit
maybe overwriten to min_t(unsigned int, 1, limit) for condition that
a large in-flight request is on non-rotational devices in found queue.
So we need to reset limit to bfqd->in_service_queue for normal case.

Actually, we have already make sure bfqd->rq_in_driver is < limit before
search, then
 -Limit is >= 1 as bfqd->rq_in_driver is >= 0. Then min_t(unsigned int,
1, limit) is always 1. So we can simply check bfqd->rq_in_driver with
1 instead of result of min_t(unsigned int, 1, limit) for larget request in
non-rotational device case to avoid overwritting limit and the bug is gone.
 -For normal case, we have already check bfqd->rq_in_driver is < limit,
so we can return found bfqq unconditionally to remove unncessary check.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
---
 block/bfq-iosched.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index a72304c728fc..1220c41fc767 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -4641,12 +4641,10 @@ bfq_choose_bfqq_for_injection(struct bfq_data *bfqd)
 			 */
 			if (blk_queue_nonrot(bfqd->queue) &&
 			    blk_rq_sectors(bfqq->next_rq) >=
-			    BFQQ_SECT_THR_NONROT)
-				limit = min_t(unsigned int, 1, limit);
-			else
-				limit = in_serv_bfqq->inject_limit;
-
-			if (bfqd->rq_in_driver < limit) {
+			    BFQQ_SECT_THR_NONROT &&
+			    bfqd->rq_in_driver >= 1)
+				continue;
+			else {
 				bfqd->rqs_injected = true;
 				return bfqq;
 			}
-- 
2.30.0

