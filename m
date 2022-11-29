From: Kemeng Shi <shikemeng@huawei.com>
Subject: [PATCH v2 07/10] blk-throttle: remove incorrect comment for tg_last_low_overflow_time
Date: Tue, 29 Nov 2022 11:01:44 +0800
Message-ID: <20221129030147.27400-8-shikemeng@huawei.com>
References: <20221129030147.27400-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221129030147.27400-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com

Function tg_last_low_overflow_time is called with intermediate node as
following:
throtl_hierarchy_can_downgrade
  throtl_tg_can_downgrade
    tg_last_low_overflow_time

throtl_hierarchy_can_upgrade
  throtl_tg_can_upgrade
    tg_last_low_overflow_time

throtl_hierarchy_can_downgrade/throtl_hierarchy_can_upgrade will traverse
from leaf node to sub-root node and pass traversed intermediate node
to tg_last_low_overflow_time.

No such limit could be found from context and implementation of
tg_last_low_overflow_time, so remove this limit in comment.

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-throttle.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 4b11099625da..3ddd8a15aa3f 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1762,7 +1762,6 @@ static unsigned long __tg_last_low_overflow_time(struct throtl_grp *tg)
 	return min(rtime, wtime);
 }
 
-/* tg should not be an intermediate node */
 static unsigned long tg_last_low_overflow_time(struct throtl_grp *tg)
 {
 	struct throtl_service_queue *parent_sq;
-- 
2.30.0

