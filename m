From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v10 5/9] sched/fair: Take into account latency priority
 at wakeup
Date: Tue, 21 Feb 2023 14:04:52 +0100
Message-ID: <Y/TBdB23akBbUjqd@hirez.programming.kicks-ass.net>
References: <20230113141234.260128-1-vincent.guittot@linaro.org>
 <20230113141234.260128-6-vincent.guittot@linaro.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KMz2u5YNJyb58TDhqNZ0GZQlDsGmXtQeWI7CV86ksic=; b=HU9hZUeUVYy4kyNrrHBVgHCYdQ
        WvVhnyzTEnM40u3E1huX5m3mMNtJYBuMj+etXdA72WJD1/TrbUlxPnF9VDU6DsUNq1P90evmuZOvg
        DAM0L26hCOmw3kOYoY1Fhp+sxEGLcXmbBSe4CXFGM1UYzLx44I8wwduqer+4zhdGuWmDo4zG4EMef
        6rCal2isiQT9VgJ1HeJNoqDcr0WMfHCBzwGRCXMRkEOg5vls+XbC2/7KzQeOxIs6fem+zvodxu2tI
        87DNmOYPhqwcnkgPsRhidulJZubK2EJrVKQe8tBMbPsBfaYUuDH/+PL7f8BS3uTgfkzbky0OsvTt4
        qeSgjWVQ==;
Content-Disposition: inline
In-Reply-To: <20230113141234.260128-6-vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, patrick.bellasi-X6neQFFVdzGsTnJN9+BGXg@public.gmane.org, David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timj-mXXj517/zsQ@public.gmane.org, kprateek.nayak-5C7GfCeVMHo@public.gmane.org, yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, youssefesmat-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org

On Fri, Jan 13, 2023 at 03:12:30PM +0100, Vincent Guittot wrote:
> @@ -6155,6 +6159,35 @@ static int sched_idle_cpu(int cpu)
>  }
>  #endif
>  
> +static void set_next_buddy(struct sched_entity *se);
> +
> +static void check_preempt_from_others(struct cfs_rq *cfs, struct sched_entity *se)
> +{
> +	struct sched_entity *next;
> +
> +	if (se->latency_offset >= 0)
> +		return;
> +
> +	if (cfs->nr_running <= 1)
> +		return;
> +	/*
> +	 * When waking from another class, we don't need to check to preempt at
> +	 * wakeup and don't set next buddy as a candidate for being picked in
> +	 * priority.
> +	 * In case of simultaneous wakeup when current is another class, the
> +	 * latency sensitive tasks lost opportunity to preempt non sensitive
> +	 * tasks which woke up simultaneously.
> +	 */
> +
> +	if (cfs->next)
> +		next = cfs->next;
> +	else
> +		next = __pick_first_entity(cfs);
> +
> +	if (next && wakeup_preempt_entity(next, se) == 1)
> +		set_next_buddy(se);
> +}
> +
>  /*
>   * The enqueue_task method is called before nr_running is
>   * increased. Here we update the fair scheduling stats and
> @@ -6241,14 +6274,15 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  	if (!task_new)
>  		update_overutilized_status(rq);
>  
> +	if (rq->curr->sched_class != &fair_sched_class)
> +		check_preempt_from_others(cfs_rq_of(&p->se), &p->se);
> +
>  enqueue_throttle:
>  	assert_list_leaf_cfs_rq(rq);
>  
>  	hrtick_update(rq);
>  }

Hmm.. This sets a next selection when the task gets enqueued while not
running a fair task -- and looses a wakeup preemption opportunity.

Should we perhaps also do this for latency_nice == 0?, in any case I
think this can be moved to its own patch to avoid doing too much in the
one patch. It seems fairly self contained.

