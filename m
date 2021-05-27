From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] sched/fair: make sure to update tg contrib for blocked load
Date: Thu, 27 May 2021 14:29:16 +0200
Message-ID: <20210527122916.27683-3-vincent.guittot@linaro.org>
References: <20210527122916.27683-1-vincent.guittot@linaro.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=m34kWJFts+JlvhgMEqzYFI86nqtKcI/eABSZJKWdva0=;
        b=kuYbHjMyYaX7A1hL/W1Dafd7/P3r7j1djEoge4gerT9ds8ebtZpggipN//3meNIYDP
         H3iQ+WtGvA4nH8D5I1Ru1+OODIKfUQJ8iIGorDWT+9LxeGMuHcBcWwKvsfVjQF4R9ZJx
         iWosXULEC6chunZkDSG3YOacsMp1SzVqRbFk7zMQyQxcuu1tRoVYXmr3I/mb8wSNETJz
         qnyItuDi/nn2FdxCKLY6pPtOkj+Z0pK5RPzIc7uGXs7mT2ztDJ4l04DcXFKVJNYiXvWm
         KBKQsmHNoWu1ED+J6aPE2EHGvS+TeN/9SHszVg51Anjv8IwJrvbn0U96EVNBH1RXoS/K
         uefw==
In-Reply-To: <20210527122916.27683-1-vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, odin-RObV4cXtwVA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

During the update of fair blocked load (__update_blocked_fair()), we update
the contribution of the cfs in tg->load_avg if cfs_rq's pelt has decayed.
Nevertheless, the pelt values of a cfs_rq could have been recently updated
while propagating the change of a child. In uchthis case, cfs_rq's pelt will
not decayed because it has already been updated and we don't update
tg->load_avg.

__update_blocked_fair
  ...
  for_each_leaf_cfs_rq_safe: child cfs_rq
    update cfs_rq_load_avg() for child cfs_rq
    ...
    update_load_avg(cfs_rq_of(se), se, 0)
      ...
      update cfs_rq_load_avg() for parent cfs_rq
		-propagation of child's load makes parent cfs_rq->load_sum
		 becoming null
        -UPDATE_TG is not set so it doesn't update parent
		 cfs_rq->tg_load_avg_contrib
  ..
  for_each_leaf_cfs_rq_safe: parent cfs_rq
    update cfs_rq_load_avg() for parent cfs_rq
      - nothing to do because parent cfs_rq has already been updated
		recently so cfs_rq->tg_load_avg_contrib is not updated
    ...
    parent cfs_rq is decayed
      list_del_leaf_cfs_rq parent cfs_rq
	  - but it still contibutes to tg->load_avg

we must set UPDATE_TG flags when propagting pending load to the parent

Fixes: 039ae8bcf7a5 ("sched/fair: Fix O(nr_cgroups) in the load balancing path")
Reported-by: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Signed-off-by: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2859545d95fb..dcb3b1a6813c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8048,7 +8048,7 @@ static bool __update_blocked_fair(struct rq *rq, bool *done)
 		/* Propagate pending load changes to the parent, if any: */
 		se = cfs_rq->tg->se[cpu];
 		if (se && !skip_blocked_update(se))
-			update_load_avg(cfs_rq_of(se), se, 0);
+			update_load_avg(cfs_rq_of(se), se, UPDATE_TG);
 
 		/*
 		 * There can be a lot of idle CPU cgroups.  Don't let fully
-- 
2.17.1

