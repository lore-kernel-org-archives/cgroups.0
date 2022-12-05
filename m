From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: [PATCH v3 9/9] blk-throttle: Use more siutable time_after check for update of slice_start
Date: Mon,  5 Dec 2022 19:57:09 +0800
Message-ID: <20221205115709.251489-10-shikemeng@huaweicloud.com>
References: <20221205115709.251489-1-shikemeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221205115709.251489-1-shikemeng@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com, linfeilong@huawei.com, liuzhiqiang26@huawei.com

From: Kemeng Shi <shikemeng@huawei.com>

There is no need to update tg->slice_start[rw] to start when they are
equal already. So remove "eq" part of check before update slice_start.

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
---
 block/blk-throttle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 413e668249cf..6fb5a2f9e1ee 100644
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

