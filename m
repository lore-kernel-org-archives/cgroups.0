From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v10 8/9] sched/fair: Add latency list
Date: Wed, 22 Feb 2023 10:49:59 +0100
Message-ID: <Y/XlR+wLtn54CkE4@hirez.programming.kicks-ass.net>
References: <20230113141234.260128-1-vincent.guittot@linaro.org>
 <20230113141234.260128-9-vincent.guittot@linaro.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CWnrS8yusi1BbXO3lj0HE+nO+dxFdr1sf7powIMllnY=; b=cAGdOrQ9sFBf37tCEgl6JuUGL3
        iK9sm/2HKSHxtzRUn8qnaECcfw8/wBTVlfDYtvVYXzhZLQLbDWglTmNSS/9RsLSBo+Ol/LMcHlAKj
        lSdAvSwVnmEJFv7b9SOayYsW7JkQsyuZODB38BOwRSbdM4HiHHO7QbkXARPLiixd2uAaeGRUSlk8X
        aXNfLIJfaa1H4u0VP813dp4RR+45ADixf8fthhiG4KfGONHheHKj207fiOv6VmNHPkRMv4ALJPzWm
        bI8h92yMiDD37+FPSKbRGhQHlvCZ+INjWW58m1dHCkWQdthArbbYa8E9Jr33A0uqZvvFd6P7OzFIb
        GQqF0KZQ==;
Content-Disposition: inline
In-Reply-To: <20230113141234.260128-9-vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, patrick.bellasi-X6neQFFVdzGsTnJN9+BGXg@public.gmane.org, David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timj-mXXj517/zsQ@public.gmane.org, kprateek.nayak-5C7GfCeVMHo@public.gmane.org, yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, youssefesmat-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org

On Fri, Jan 13, 2023 at 03:12:33PM +0100, Vincent Guittot wrote:

> +static void __enqueue_latency(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
> +{
> +
> +	/* Only latency sensitive entity can be added to the list */
> +	if (se->latency_offset >= 0)
> +		return;
> +
> +	if (!RB_EMPTY_NODE(&se->latency_node))
> +		return;
> +
> +	/*
> +	 * An execution time less than sysctl_sched_min_granularity means that
> +	 * the entity has been preempted by a higher sched class or an entity
> +	 * with higher latency constraint.
> +	 * Put it back in the list so it gets a chance to run 1st during the
> +	 * next slice.
> +	 */
> +	if (!(flags & ENQUEUE_WAKEUP)) {
> +		u64 delta_exec = se->sum_exec_runtime - se->prev_sum_exec_runtime;
> +
> +		if (delta_exec >= sysctl_sched_min_granularity)
> +			return;
> +	}

I'm not a big fan of this dynamic enqueueing condition; it makes it
rather hard to interpret the below addition to pick_next_entity().

Let me think about this more... at the very least the comment with
__pick_first_latency() use below needs to be expanded upon if we keep it
like so.

> +
> +	rb_add_cached(&se->latency_node, &cfs_rq->latency_timeline, __latency_less);
> +}

> @@ -4966,7 +5040,7 @@ static struct sched_entity *
>  pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
>  {
>  	struct sched_entity *left = __pick_first_entity(cfs_rq);
> -	struct sched_entity *se;
> +	struct sched_entity *latency, *se;
>  
>  	/*
>  	 * If curr is set we have to see if its left of the leftmost entity
> @@ -5008,6 +5082,12 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
>  		se = cfs_rq->last;
>  	}
>  
> +	/* Check for latency sensitive entity waiting for running */
> +	latency = __pick_first_latency(cfs_rq);
> +	if (latency && (latency != se) &&
> +	    wakeup_preempt_entity(latency, se) < 1)
> +		se = latency;

I'm not quite sure why this condition isn't sufficient on it's own.
After all, if a task does a 'spurious' nanosleep it can get around the
'restriction' in __enqueue_latency() without any great penalty to it's
actual bandwidth consumption.
