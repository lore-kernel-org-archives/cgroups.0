From: Kemeng Shi <shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH v3 8/9] blk-throttle: remove repeat check of elapsed time from last upgrade in throtl_hierarchy_can_downgrade
Date: Mon,  5 Dec 2022 19:57:08 +0800
Message-ID: <20221205115709.251489-9-shikemeng@huaweicloud.com>
References: <20221205115709.251489-1-shikemeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221205115709.251489-1-shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linfeilong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuzhiqiang26-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

There is no need to check elapsed time from last upgrade for each node in
hierarchy. Move this check before traversing as throtl_can_upgrade do
to remove repeat check.

Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Kemeng Shi <shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
---
 block/blk-throttle.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index e6a087de414d..413e668249cf 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1955,8 +1955,7 @@ static bool throtl_tg_can_downgrade(struct throtl_grp *tg)
 	 * If cgroup is below low limit, consider downgrade and throttle other
 	 * cgroups
 	 */
-	if (time_after_eq(now, td->low_upgrade_time + td->throtl_slice) &&
-	    time_after_eq(now, tg_last_low_overflow_time(tg) +
+	if (time_after_eq(now, tg_last_low_overflow_time(tg) +
 					td->throtl_slice) &&
 	    (!throtl_tg_is_idle(tg) ||
 	     !list_empty(&tg_to_blkg(tg)->blkcg->css.children)))
@@ -1966,6 +1965,11 @@ static bool throtl_tg_can_downgrade(struct throtl_grp *tg)
 
 static bool throtl_hierarchy_can_downgrade(struct throtl_grp *tg)
 {
+	struct throtl_data *td = tg->td;
+
+	if (time_before(jiffies, td->low_upgrade_time + td->throtl_slice))
+		return false;
+
 	while (true) {
 		if (!throtl_tg_can_downgrade(tg))
 			return false;
-- 
2.30.0

