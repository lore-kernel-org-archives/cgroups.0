From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] sched/fair: keep load_avg and load_sum synced
Date: Thu, 27 May 2021 15:05:30 +0200
Message-ID: <YK+ZGlfPxK3JCySS@hirez.programming.kicks-ass.net>
References: <20210527122916.27683-1-vincent.guittot@linaro.org>
 <20210527122916.27683-2-vincent.guittot@linaro.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ta5zzhet5s6C63/o89LSX98k9lWRcXUPZemLvb4KNvQ=; b=HfZz8BRqIZXWTWn2p5hFQrTao1
        iZJDgiZEi8Vmr//6oJzinMu3kuu4Ml+cC6TbN1ZUZbFoneVoVqYU6ToKxiVj+zmnsHgM0n9x/C6gi
        YskpjrBH3Iy4bfMKsgzjbw6nrOQZUsOq/w8OhTbVYCG1L22P8iKayEM1QBSpxKe7xfMmeKTwXKJaQ
        Y70SXnvSfe2Onl36lQFJPV7gs1cMho/hn+fSKLpy9EKVyHKktR0iNePLo7wbjftr+8ONOWeuQI/sJ
        JaL11rfLez3fAapFrYnmnCpl8yvk5haitSvJF4/24ddTToylmg0qN15ojjibz7eUrHp+UnwCNLCV1
        9om/d5IQ==;
Content-Disposition: inline
In-Reply-To: <20210527122916.27683-2-vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, odin-RObV4cXtwVA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, May 27, 2021 at 02:29:15PM +0200, Vincent Guittot wrote:

> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3509,7 +3509,8 @@ update_tg_cfs_load(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cfs_rq
>  	se->avg.load_sum = runnable_sum;
>  	se->avg.load_avg = load_avg;
>  	add_positive(&cfs_rq->avg.load_avg, delta_avg);
> -	add_positive(&cfs_rq->avg.load_sum, delta_sum);
> +	cfs_rq->avg.load_sum = cfs_rq->avg.load_avg * divider;

If I'm not mistaken, this makes delta_sum unused, so we can remove it
entirely, see below.

> +

This extra blank space, we really need that? :-)

>  }

---
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 161b92aa1c79..2b99e687fe7a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3453,10 +3453,9 @@ update_tg_cfs_runnable(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cf
 static inline void
 update_tg_cfs_load(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cfs_rq *gcfs_rq)
 {
-	long delta_avg, running_sum, runnable_sum = gcfs_rq->prop_runnable_sum;
+	long running_sum, runnable_sum = gcfs_rq->prop_runnable_sum;
 	unsigned long load_avg;
 	u64 load_sum = 0;
-	s64 delta_sum;
 	u32 divider;
 
 	if (!runnable_sum)
@@ -3503,13 +3502,11 @@ update_tg_cfs_load(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cfs_rq
 	load_sum = (s64)se_weight(se) * runnable_sum;
 	load_avg = div_s64(load_sum, divider);
 
-	delta_sum = load_sum - (s64)se_weight(se) * se->avg.load_sum;
-	delta_avg = load_avg - se->avg.load_avg;
-
 	se->avg.load_sum = runnable_sum;
 	se->avg.load_avg = load_avg;
-	add_positive(&cfs_rq->avg.load_avg, delta_avg);
-	add_positive(&cfs_rq->avg.load_sum, delta_sum);
+
+	add_positive(&cfs_rq->avg.load_avg, (long)(load_avg - se->avg.load_avg));
+	cfs_rq->avg.load_sum = cfs_rq->avg.load_avg * divider;
 }
 
 static inline void add_tg_cfs_propagate(struct cfs_rq *cfs_rq, long runnable_sum)
