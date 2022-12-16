From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: [PATCH v2 02/10] block, bfq: remove unsed parameter reason in bfq_bfqq_is_slow
Date: Fri, 16 Dec 2022 19:12:22 +0800
Message-ID: <20221216111230.3638832-3-shikemeng@huaweicloud.com>
References: <20221216111230.3638832-1-shikemeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221216111230.3638832-1-shikemeng@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, paolo.valente@linaro.org, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linfeilong@huawei.com, liuzhiqiang@26.com, shikemeng@huaweicloud.com

Parameter reason is never used, just remove it.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
---
 block/bfq-iosched.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 1220c41fc767..5a6d9e8c329d 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -4066,8 +4066,7 @@ static void __bfq_bfqq_recalc_budget(struct bfq_data *bfqd,
  * function to evaluate the I/O speed of a process.
  */
 static bool bfq_bfqq_is_slow(struct bfq_data *bfqd, struct bfq_queue *bfqq,
-				 bool compensate, enum bfqq_expiration reason,
-				 unsigned long *delta_ms)
+				 bool compensate, unsigned long *delta_ms)
 {
 	ktime_t delta_ktime;
 	u32 delta_usecs;
@@ -4263,7 +4262,7 @@ void bfq_bfqq_expire(struct bfq_data *bfqd,
 	/*
 	 * Check whether the process is slow (see bfq_bfqq_is_slow).
 	 */
-	slow = bfq_bfqq_is_slow(bfqd, bfqq, compensate, reason, &delta);
+	slow = bfq_bfqq_is_slow(bfqd, bfqq, compensate, &delta);
 
 	/*
 	 * As above explained, charge slow (typically seeky) and
-- 
2.30.0

