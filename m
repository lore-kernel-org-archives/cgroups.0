From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next v3 1/3] blk-cgroup: dropping parent refcount after pd_free_fn() is done
Date: Thu, 19 Jan 2023 19:03:48 +0800
Message-ID: <20230119110350.2287325-2-yukuai1@huaweicloud.com>
References: <20230119110350.2287325-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230119110350.2287325-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Some cgroup policies will access parent pd through child pd even
after pd_offline_fn() is done. If pd_free_fn() for parent is called
before child, then UAF can be triggered. Hence it's better to guarantee
the order of pd_free_fn().

Currently refcount of parent blkg is dropped in __blkg_release(), which
is before pd_free_fn() is called in blkg_free_work_fn() while
blkg_free_work_fn() is called asynchronously.

This patch make sure pd_free_fn() called from removing cgroup is ordered
by delaying dropping parent refcount after calling pd_free_fn() for
child.

BTW, pd_free_fn() will also be called from blkcg_deactivate_policy()
from deleting device, and following patches will guarantee the order.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4c94a6560f62..c6d7d1fce65a 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -124,6 +124,8 @@ static void blkg_free_workfn(struct work_struct *work)
 		if (blkg->pd[i])
 			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
 
+	if (blkg->parent)
+		blkg_put(blkg->parent);
 	if (blkg->q)
 		blk_put_queue(blkg->q);
 	free_percpu(blkg->iostat_cpu);
@@ -158,8 +160,6 @@ static void __blkg_release(struct rcu_head *rcu)
 
 	/* release the blkcg and parent blkg refs this blkg has been holding */
 	css_put(&blkg->blkcg->css);
-	if (blkg->parent)
-		blkg_put(blkg->parent);
 	blkg_free(blkg);
 }
 
-- 
2.31.1

