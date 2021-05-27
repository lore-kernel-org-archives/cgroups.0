From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] sched/fair: keep load_avg and load_sum synced
Date: Thu, 27 May 2021 14:29:15 +0200
Message-ID: <20210527122916.27683-2-vincent.guittot@linaro.org>
References: <20210527122916.27683-1-vincent.guittot@linaro.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QWStSJ3Mvu9DtMYYM9x+7xh68F47755bbITjY+nefqs=;
        b=AHaKDLnLuRJfIci3AkxXBqi4e05z2oMlIvhgL33xmK0xo03xisGDmxUic9JzYcZ9IL
         9KJ9ZIn9KZpnuLnaXq2+C8HtvBVTsp46oFuBsBBrrt3yd8z2VjgVfMyqyVKi/wmNPBwF
         tqfDXoPXKzMpmzRQQ/2R+ir8B4PHzGdoYQoXLoboyJ+Sbap97hGDlFQhWtDf/+UpLnqK
         dLDmXirnm85YDscTHrlOB6H9huSPBuReQ+MVJi0QVtAjzrnSxwHOc3miY22XzIXGK+GV
         q5bJFwtaV10CDUsDZM8zFi7vy3OjyXkSLrUWOW64DFCJNAg8Tmdd0C8C1rH/A6Q/tZqH
         zuCg==
In-Reply-To: <20210527122916.27683-1-vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, odin-RObV4cXtwVA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

when removing a cfs_rq from the list we only check _sum value so we must
ensure that _avg and _sum stay synced so load_sum can't be null whereas
load_avg is not after propagating load in the cgroup hierarchy.

Use load_avg to compute load_sum similarly to what is done for util_sum
and runnable_sum.

Fixes: 0e2d2aaaae52 ("sched/fair: Rewrite PELT migration propagation")
Reported-by: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Signed-off-by: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 kernel/sched/fair.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 161b92aa1c79..2859545d95fb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3509,7 +3509,8 @@ update_tg_cfs_load(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cfs_rq
 	se->avg.load_sum = runnable_sum;
 	se->avg.load_avg = load_avg;
 	add_positive(&cfs_rq->avg.load_avg, delta_avg);
-	add_positive(&cfs_rq->avg.load_sum, delta_sum);
+	cfs_rq->avg.load_sum = cfs_rq->avg.load_avg * divider;
+
 }
 
 static inline void add_tg_cfs_propagate(struct cfs_rq *cfs_rq, long runnable_sum)
-- 
2.17.1

