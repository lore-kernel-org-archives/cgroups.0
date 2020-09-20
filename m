From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH 2/4] blk-throttle: Avoid getting the current time if tg->last_finish_time is 0
Date: Sun, 20 Sep 2020 17:10:19 +0800
Message-ID: <534c289866f74d1587806f7818baac789b49c484.1600592693.git.baolin.wang@linux.alibaba.com>
References: <cover.1600592693.git.baolin.wang@linux.alibaba.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <cover.1600592693.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <cover.1600592693.git.baolin.wang@linux.alibaba.com>
References: <cover.1600592693.git.baolin.wang@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: baolin.wang@linux.alibaba.com, baolin.wang7@gmail.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

We only update the tg->last_finish_time when the low limitaion is
enabled, so we can move the tg->last_finish_time validation a little
forward to avoid getting the unnecessary current time stamp if the
the low limitation is not enabled.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 block/blk-throttle.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 4007b26..7e72102 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2077,10 +2077,14 @@ static void throtl_downgrade_check(struct throtl_grp *tg)
 
 static void blk_throtl_update_idletime(struct throtl_grp *tg)
 {
-	unsigned long now = ktime_get_ns() >> 10;
+	unsigned long now;
 	unsigned long last_finish_time = tg->last_finish_time;
 
-	if (now <= last_finish_time || last_finish_time == 0 ||
+	if (last_finish_time == 0)
+		return;
+
+	now = ktime_get_ns() >> 10;
+	if (now <= last_finish_time ||
 	    last_finish_time == tg->checked_last_finish_time)
 		return;
 
-- 
1.8.3.1

