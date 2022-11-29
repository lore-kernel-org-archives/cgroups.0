From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 05/10] blk-throttle: simpfy low limit reached check in throtl_tg_can_upgrade
Date: Tue, 29 Nov 2022 11:01:42 +0800
Message-ID: <20221129030147.27400-6-shikemeng@huawei.com>
References: <20221129030147.27400-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221129030147.27400-1-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Commit c79892c557616 ("blk-throttle: add upgrade logic for LIMIT_LOW
state") added upgrade logic for low limit and methioned that
1. "To determine if a cgroup exceeds its limitation, we check if the cgroup
has pending request. Since cgroup is throttled according to the limit,
pending request means the cgroup reaches the limit."
2. "If a cgroup has limit set for both read and write, we consider the
combination of them for upgrade. The reason is read IO and write IO can
interfere with each other. If we do the upgrade based in one direction IO,
the other direction IO could be severly harmed."
Besides, we also determine that cgroup reaches low limit if low limit is 0,
see comment in throtl_tg_can_upgrade.

Collect the information above, the desgin of upgrade check is as following:
1.The low limit is reached if limit is zero or io is already queued.
2.Cgroup will pass upgrade check if low limits of READ and WRITE are both
reached.

Simpfy the check code described above to removce repeat check and improve
readability. There is no functional change.

Detail equivalence proof is as following:
All replaced conditions to return true are as following:
condition 1
(!read_limit && !write_limit)
condition 2
read_limit && sq->nr_queued[READ] && (!write_limit || sq->nr_queued[WRITE])
condition 3
write_limit && sq->nr_queued[WRITE] && (!read_limit || sq->nr_queued[READ])

Transferring condition 2 as following:
read_limit && sq->nr_queued[READ] && (!write_limit || sq->nr_queued[WRITE])
is equivalent to
(read_limit && sq->nr_queued[READ]) &&
(!write_limit || (write_limit && sq->nr_queued[WRITE]))
is equivalent to
condition 2.1
(read_limit && sq->nr_queued[READ] && !write_limit) ||
condition 2.2
(read_limit && sq->nr_queued[READ] &&
(write_limit && sq->nr_queued[WRITE]))

Transferring condition 3 as following:
write_limit && sq->nr_queued[WRITE] && (!read_limit || sq->nr_queued[READ])
is equivalent to
(write_limit && sq->nr_queued[WRITE]) &&
(!read_limit || (read_limit && sq->nr_queued[READ]))
is equivalent to
condition 3.1
((write_limit && sq->nr_queued[WRITE]) && !read_limit) ||
condition 3.2
((write_limit && sq->nr_queued[WRITE]) &&
(read_limit && sq->nr_queued[READ]))

Condition 3.2 is the same as condition 2.2, so all conditions we get to
return are as following:
(!read_limit && !write_limit) (1)
(!read_limit && (write_limit && sq->nr_queued[WRITE])) (3.1)
((read_limit && sq->nr_queued[READ]) && !write_limit) (2.1)
((write_limit && sq->nr_queued[WRITE]) &&
(read_limit && sq->nr_queued[READ])) (2.2)

As we can extract conditions "(a1 || a2) && (b1 || b2)" to:
a1 && b1
a1 && b2
a2 && b1
ab && b2

Considering that:
a1 = !read_limit
a2 = read_limit && sq->nr_queued[READ]
b1 = !write_limit
b2 = write_limit && sq->nr_queued[WRITE]

We can pack replaced conditions to
(!read_limint || (read_limit && sq->nr_queued[READ])) &&
(!write_limit || (write_limit && sq->nr_queued[WRITE])
which is equivalent to
(!read_limint || sq->nr_queued[READ]) &&
(!write_limit || sq->nr_queued[WRITE])

Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 block/blk-throttle.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 06e4193b064e..4977fac56a00 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1816,24 +1816,29 @@ static bool throtl_tg_is_idle(struct throtl_grp *tg)
 	return ret;
 }
 
-static bool throtl_tg_can_upgrade(struct throtl_grp *tg)
+static bool throtl_tg_reach_low_limit(struct throtl_grp *tg, int rw)
 {
 	struct throtl_service_queue *sq = &tg->service_queue;
-	bool read_limit, write_limit;
+	bool limit = tg->bps[rw][LIMIT_LOW] || tg->iops[rw][LIMIT_LOW];
 
 	/*
-	 * if cgroup reaches low limit (if low limit is 0, the cgroup always
-	 * reaches), it's ok to upgrade to next limit
+	 * if low limit is zero, low limit is always reached.
+	 * if low limit is non-zero, we can check if there is any request
+	 * is queued to determine if low limit is reached as we throttle
+	 * request according to limit.
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
+	return !limit || sq->nr_queued[rw];
+}
+
+static bool throtl_tg_can_upgrade(struct throtl_grp *tg)
+{
+	/*
+	 * cgroup reaches low limit when low limit of READ and WRITE are
+	 * both reached, it's ok to upgrade to next limit if cgroup reaches
+	 * low limit
+	 */
+	if (throtl_tg_reach_low_limit(tg, READ) &&
+	    throtl_tg_reach_low_limit(tg, WRITE))
 		return true;
 
 	if (time_after_eq(jiffies,
-- 
2.30.0

