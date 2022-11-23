From: Kemeng Shi <shikemeng@huawei.com>
Subject: [PATCH 09/11] blk-throttle: remove unnecessary check for validation of limit index
Date: Wed, 23 Nov 2022 14:03:59 +0800
Message-ID: <20221123060401.20392-10-shikemeng@huawei.com>
References: <20221123060401.20392-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221123060401.20392-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com

We always keep limit index valid as following:
Max limit is always valid and low limit can only be invalidated in
blk_throtl_update_limit_valid. Each time low limit may become invalid
after blk_throtl_update_limit_valid is called, we will check and make
sure current limit index is valid.

It's reasonable to always keep limit index valid, so we can remove this
check.

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
---
 block/blk-throttle.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 3eccc7af4368..6f509cadd92b 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -418,12 +418,10 @@ static void tg_update_has_rules(struct throtl_grp *tg)
 	for (rw = READ; rw <= WRITE; rw++) {
 		tg->has_rules_iops[rw] =
 			(parent_tg && parent_tg->has_rules_iops[rw]) ||
-			(td->limit_valid[td->limit_index] &&
-			  tg_iops_limit(tg, rw) != UINT_MAX);
+			  (tg_iops_limit(tg, rw) != UINT_MAX);
 		tg->has_rules_bps[rw] =
 			(parent_tg && parent_tg->has_rules_bps[rw]) ||
-			(td->limit_valid[td->limit_index] &&
-			 (tg_bps_limit(tg, rw) != U64_MAX));
+			 (tg_bps_limit(tg, rw) != U64_MAX);
 	}
 }
 
-- 
2.30.0

