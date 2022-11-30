From: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next v2 9/9] blk-iocost: fix walk_list corruption
Date: Wed, 30 Nov 2022 21:21:56 +0800
Message-ID: <20221130132156.2836184-10-linan122@huawei.com>
References: <20221130132156.2836184-1-linan122@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221130132156.2836184-1-linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Our test report a problem:

------------[ cut here ]------------
list_del corruption. next->prev should be ffff888127e0c4b0, but was ffff888127e090b0
WARNING: CPU: 2 PID: 3117789 at lib/list_debug.c:62 __list_del_entry_valid+0x119/0x130
RIP: 0010:__list_del_entry_valid+0x119/0x130
RIP: 0010:__list_del_entry_valid+0x119/0x130
Call Trace:
 <IRQ>
 iocg_flush_stat.isra.0+0x11e/0x230
 ? ioc_rqos_done+0x230/0x230
 ? ioc_now+0x14f/0x180
 ioc_timer_fn+0x569/0x1640

We haven't reporduced it yet, but we think this is due to parent iocg is
freed before child iocg, and then in ioc_timer_fn, walk_list is
corrupted.

1) Remove child cgroup can concurrent with remove parent cgroup, and
ioc_pd_free for parent iocg can be called before child iocg. This can be
fixed by moving the handle of walk_list to ioc_pd_offline, since that
offline from child is ensured to be called before parent.

2) ioc_pd_free can be triggered from both removing device and removing
cgroup, this patch fix the problem by deleting timer before deactivating
policy, so that free parent iocg first in this case won't matter.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-iocost.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 710cf63a1643..d2b873908f88 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2813,13 +2813,14 @@ static void ioc_rqos_exit(struct rq_qos *rqos)
 {
 	struct ioc *ioc = rqos_to_ioc(rqos);
 
+	del_timer_sync(&ioc->timer);
+
 	blkcg_deactivate_policy(rqos->q, &blkcg_policy_iocost);
 
 	spin_lock_irq(&ioc->lock);
 	ioc->running = IOC_STOP;
 	spin_unlock_irq(&ioc->lock);
 
-	del_timer_sync(&ioc->timer);
 	free_percpu(ioc->pcpu_stat);
 	kfree(ioc);
 }
-- 
2.31.1

