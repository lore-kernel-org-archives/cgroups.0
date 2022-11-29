From: Kemeng Shi <shikemeng@huawei.com>
Subject: [PATCH v2 09/10] blk-throttle: Use more siutable time_after check for update of slice_start
Date: Tue, 29 Nov 2022 11:01:46 +0800
Message-ID: <20221129030147.27400-10-shikemeng@huawei.com>
References: <20221129030147.27400-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221129030147.27400-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com

There is no need to update tg->slice_start[rw] to start when they are
equal already. So remove "eq" part of check before update slice_start.

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
---
 block/blk-throttle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 94d850b57462..4c80f2aa1e29 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -645,7 +645,7 @@ static inline void throtl_start_new_slice_with_credit(struct throtl_grp *tg,
 	 * that bandwidth. Do try to make use of that bandwidth while giving
 	 * credit.
 	 */
-	if (time_after_eq(start, tg->slice_start[rw]))
+	if (time_after(start, tg->slice_start[rw]))
 		tg->slice_start[rw] = start;
 
 	tg->slice_end[rw] = jiffies + tg->td->throtl_slice;
-- 
2.30.0

