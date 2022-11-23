From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 01/11] blk-throttle: Limit whole system if root group is configured when on the default hierarchy
Date: Wed, 23 Nov 2022 14:03:51 +0800
Message-ID: <20221123060401.20392-2-shikemeng@huawei.com>
References: <20221123060401.20392-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221123060401.20392-1-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Quoted from comment in throtl_pd_init: "If on the default hierarchy, we
switch to properly hierarchical behavior where limits on a given
throtl_grp are applied to the whole subtree rather than just the group
itself. e.g. If 16M read_bps limit is set on the root group, the whole
system can' exceed 16M for the device."
Commit b22c417c885ea9 ("blk-throttle: configure bps/iops limit for
cgroup in low limit") broke this rule and did not explain why.
Restore the ability to limit the whole system by root group.

Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 847721dc2b2b..96aa53e30e28 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -150,9 +150,6 @@ static uint64_t tg_bps_limit(struct throtl_grp *tg, int rw)
 	struct throtl_data *td;
 	uint64_t ret;
 
-	if (cgroup_subsys_on_dfl(io_cgrp_subsys) && !blkg->parent)
-		return U64_MAX;
-
 	td = tg->td;
 	ret = tg->bps[rw][td->limit_index];
 	if (ret == 0 && td->limit_index == LIMIT_LOW) {
@@ -180,9 +177,6 @@ static unsigned int tg_iops_limit(struct throtl_grp *tg, int rw)
 	struct throtl_data *td;
 	unsigned int ret;
 
-	if (cgroup_subsys_on_dfl(io_cgrp_subsys) && !blkg->parent)
-		return UINT_MAX;
-
 	td = tg->td;
 	ret = tg->iops[rw][td->limit_index];
 	if (ret == 0 && tg->td->limit_index == LIMIT_LOW) {
-- 
2.30.0

