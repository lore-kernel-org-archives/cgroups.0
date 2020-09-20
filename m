From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH 1/4] blk-throttle: Remove a meaningless parameter for throtl_downgrade_state()
Date: Sun, 20 Sep 2020 17:10:18 +0800
Message-ID: <fe8fb1acbcfaf5bd9b38787f8c7cc4ae5a301ae9.1600592693.git.baolin.wang@linux.alibaba.com>
References: <cover.1600592693.git.baolin.wang@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1600592693.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <cover.1600592693.git.baolin.wang@linux.alibaba.com>
References: <cover.1600592693.git.baolin.wang@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: baolin.wang@linux.alibaba.com, baolin.wang7@gmail.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

The throtl_downgrade_state() is always used to change to LIMIT_LOW
limitation, thus remove the latter meaningless parameter which
indicates the limitation index.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 block/blk-throttle.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 36ba61c..4007b26 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1970,7 +1970,7 @@ static void throtl_upgrade_state(struct throtl_data *td)
 	queue_work(kthrotld_workqueue, &td->dispatch_work);
 }
 
-static void throtl_downgrade_state(struct throtl_data *td, int new)
+static void throtl_downgrade_state(struct throtl_data *td)
 {
 	td->scale /= 2;
 
@@ -1980,7 +1980,7 @@ static void throtl_downgrade_state(struct throtl_data *td, int new)
 		return;
 	}
 
-	td->limit_index = new;
+	td->limit_index = LIMIT_LOW;
 	td->low_downgrade_time = jiffies;
 }
 
@@ -2067,7 +2067,7 @@ static void throtl_downgrade_check(struct throtl_grp *tg)
 	 * cgroups
 	 */
 	if (throtl_hierarchy_can_downgrade(tg))
-		throtl_downgrade_state(tg->td, LIMIT_LOW);
+		throtl_downgrade_state(tg->td);
 
 	tg->last_bytes_disp[READ] = 0;
 	tg->last_bytes_disp[WRITE] = 0;
-- 
1.8.3.1

