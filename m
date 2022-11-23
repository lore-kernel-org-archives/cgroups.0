From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/11] blk-throttle: simpfy low limit reached check in throtl_tg_can_upgrade
Date: Wed, 23 Nov 2022 14:03:55 +0800
Message-ID: <20221123060401.20392-6-shikemeng@huawei.com>
References: <20221123060401.20392-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221123060401.20392-1-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Cgroup reaches low limit if limit is zero or io is already queued. Cgroup
will pass upgrade check if low limits of READ and WRITE are both reached.
Simpfy the check code described above to removce repeat check and improve
readability. There is no functional change.

Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 01e30380c19b..322a6ee38fb6 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1800,24 +1800,22 @@ static bool throtl_tg_is_idle(struct throtl_grp *tg)
 	return ret;
 }
 
-static bool throtl_tg_can_upgrade(struct throtl_grp *tg)
+static bool throtl_tg_reach_low_limit(struct throtl_grp *tg, int rw)
 {
 	struct throtl_service_queue *sq = &tg->service_queue;
-	bool read_limit, write_limit;
+	bool limit = tg->bps[rw][LIMIT_LOW] || tg->iops[rw][LIMIT_LOW];
 
 	/*
 	 * if cgroup reaches low limit (if low limit is 0, the cgroup always
 	 * reaches), it's ok to upgrade to next limit
 	 */
-	read_limit = tg->bps[READ][LIMIT_LOW] || tg->iops[READ][LIMIT_LOW];
-	write_limit = tg->bps[WRITE][LIMIT_LOW] || tg->iops[WRITE][LIMIT_LOW];
-	if (!read_limit && !write_limit)
-		return true;
-	if (read_limit && sq->nr_queued[READ] &&
-	    (!write_limit || sq->nr_queued[WRITE]))
-		return true;
-	if (write_limit && sq->nr_queued[WRITE] &&
-	    (!read_limit || sq->nr_queued[READ]))
+	return !limit || sq->nr_queued[rw].
+}
+
+static bool throtl_tg_can_upgrade(struct throtl_grp *tg)
+{
+	if (throtl_tg_reach_low_limit(tg, READ) &&
+	    throtl_tg_reach_low_limit(tg, WRITE))
 		return true;
 
 	if (time_after_eq(jiffies,
-- 
2.30.0

