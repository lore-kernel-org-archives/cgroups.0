From: Kemeng Shi <shikemeng@huawei.com>
Subject: [PATCH 08/11] blk-throttle: remove repeat check of elapsed time from last upgrade in throtl_hierarchy_can_downgrade
Date: Wed, 23 Nov 2022 14:03:58 +0800
Message-ID: <20221123060401.20392-9-shikemeng@huawei.com>
References: <20221123060401.20392-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221123060401.20392-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com

There is no need to check elapsed time from last upgrade for each node in
hierarchy. Move this check before traversing as throtl_can_upgrade do
to remove repeat check.

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
---
 block/blk-throttle.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index bd07f562c799..3eccc7af4368 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1932,8 +1932,7 @@ static bool throtl_tg_can_downgrade(struct throtl_grp *tg)
 	 * If cgroup is below low limit, consider downgrade and throttle other
 	 * cgroups
 	 */
-	if (time_after_eq(now, td->low_upgrade_time + td->throtl_slice) &&
-	    time_after_eq(now, tg_last_low_overflow_time(tg) +
+	if (time_after_eq(now, tg_last_low_overflow_time(tg) +
 					td->throtl_slice) &&
 	    (!throtl_tg_is_idle(tg) ||
 	     !list_empty(&tg_to_blkg(tg)->blkcg->css.children)))
@@ -1943,6 +1942,9 @@ static bool throtl_tg_can_downgrade(struct throtl_grp *tg)
 
 static bool throtl_hierarchy_can_downgrade(struct throtl_grp *tg)
 {
+	if (time_before(now, tg->td->low_upgrade_time + td->throtl_slice))
+		return false;
+
 	while (true) {
 		if (!throtl_tg_can_downgrade(tg))
 			return false;
-- 
2.30.0

