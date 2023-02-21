From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v10 8/9] sched/fair: Add latency list
Date: Tue, 21 Feb 2023 16:11:51 +0100
Message-ID: <Y/TfN1upxApdSERP@hirez.programming.kicks-ass.net>
References: <20230113141234.260128-1-vincent.guittot@linaro.org>
 <20230113141234.260128-9-vincent.guittot@linaro.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aANriw9LXZj51WG6ahVVJ0TaMZ+z3iaUteIrENxaYmY=; b=NWvP0uylx8quy1DxJTGHiiDS7E
        qPPOrbMXMdN9swpO6tVdcuRXftSvwIA/eYexS6q8672AdB682Z5sC1yMUwoU/gXK2+IZBU3YDa8Cw
        AFkkdNlkucjXLYPSp6AgPViCZp/hdwdpWp++u/ZQSeUNcAf7gO6usbnH5sl1dqNtikdJ8mFoXpq/y
        ZDsdEZV7cW7vFQUFJOLNi05P5FQ5L4uLesWh1UWt70ebLpfGGRYzSWvFcUUO9ERXQs6cCwwO/3r3T
        Dbi/I3EFGUNwvf6Hg4M4WMlx5NA4WZYvXruUrIKjyOhl5dd+I3ltvsDQF+K0jwXcUyUMRRP9Evgln
        hQrFntvA==;
Content-Disposition: inline
In-Reply-To: <20230113141234.260128-9-vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, patrick.bellasi-X6neQFFVdzGsTnJN9+BGXg@public.gmane.org, David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timj-mXXj517/zsQ@public.gmane.org, kprateek.nayak-5C7GfCeVMHo@public.gmane.org, yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, youssefesmat-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org

On Fri, Jan 13, 2023 at 03:12:33PM +0100, Vincent Guittot wrote:
> @@ -12552,8 +12634,15 @@ int sched_group_set_latency(struct task_group *tg, s64 latency)
>  
>  	for_each_possible_cpu(i) {
>  		struct sched_entity *se = tg->se[i];
> +		struct rq *rq = cpu_rq(i);
> +		struct rq_flags rf;
> +
> +		rq_lock_irqsave(rq, &rf);
>  
> +		__dequeue_latency(se->cfs_rq, se);
>  		WRITE_ONCE(se->latency_offset, latency);
> +
> +		rq_unlock_irqrestore(rq, &rf);
>  	}

This seems asymmetric; maybe something like:

	queued = __dequeue_latency(..);
	WRITE_ONCE(...);
	if (queued)
		__enqueue_latency(...);

?
