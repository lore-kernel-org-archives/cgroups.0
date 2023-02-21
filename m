From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v10 5/9] sched/fair: Take into account latency priority
 at wakeup
Date: Tue, 21 Feb 2023 13:52:58 +0100
Message-ID: <Y/S+qrschy+N+QCQ@hirez.programming.kicks-ass.net>
References: <20230113141234.260128-1-vincent.guittot@linaro.org>
 <20230113141234.260128-6-vincent.guittot@linaro.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=e9/aDKUyKuBkvQEPm0dRHwCaOcpHf48fdU5SrQYxTGU=; b=JzguKagadVRr3rixX4uXLHmau0
        TQB4/qsx/1x8zlkUZ96fpp4lrLhNALumwpcOgnjtABhSK+Kz8vm/BSPvrOr+/PeOXoXsqqig167wU
        vILS1G+iDltVxiZCQSG9QnXkFk9Xc1AcdDrNEVaDlEv8yzN7kjgY3GTwbxObgSiFULOVjbv3UIwSj
        Fz8NtAhQtoKW6bbaBj7H1LczrWALWyAC+tcT0qRn+rIJTjJS8UcsnOeCRlRH2OYliM3k18wYcROdp
        OT+rxrVI7PzhV6CXHz9NGhl6jkR2aPgNwPIILZMrUjZx5OUu2g5l2b9UU4t1+qjtqPpWHpOHpejT3
        s3RNwmwQ==;
Content-Disposition: inline
In-Reply-To: <20230113141234.260128-6-vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, patrick.bellasi-X6neQFFVdzGsTnJN9+BGXg@public.gmane.org, David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timj-mXXj517/zsQ@public.gmane.org, kprateek.nayak-5C7GfCeVMHo@public.gmane.org, yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, youssefesmat-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org

On Fri, Jan 13, 2023 at 03:12:30PM +0100, Vincent Guittot wrote:

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 6c61bde49152..38decae3e156 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -568,6 +568,8 @@ struct sched_entity {
>  	/* cached value of my_q->h_nr_running */
>  	unsigned long			runnable_weight;
>  #endif
> +	/* preemption offset in ns */
> +	long				latency_offset;

I wonder about the type here; does it make sense to have it depend on
the bitness; that is if s32 is big enough on 32bit then surely it is so
too on 64bit, and if not, then it should be unconditionally s64.


> +static void set_latency_offset(struct task_struct *p)
> +{
> +	long weight = sched_latency_to_weight[p->latency_prio];
> +	s64 offset;
> +
> +	offset = weight * get_sleep_latency(false);
> +	offset = div_s64(offset, NICE_LATENCY_WEIGHT_MAX);
> +	p->se.latency_offset = (long)offset;
> +}

> +/*
> + * latency weight for wakeup preemption
> + */
> +const int sched_latency_to_weight[40] = {
> + /* -20 */     -1024,     -973,     -922,      -870,      -819,
> + /* -15 */      -768,     -717,     -666,      -614,      -563,
> + /* -10 */      -512,     -461,     -410,      -358,      -307,
> + /*  -5 */      -256,     -205,     -154,      -102,       -51,
> + /*   0 */         0,       51,      102,       154,       205,
> + /*   5 */       256,      307,      358,       410,       461,
> + /*  10 */       512,      563,      614,       666,       717,
> + /*  15 */       768,      819,      870,       922,       973,
> +};

I'm slightly confused by this table, isn't that simply the linear
function?

Isn't all that the same as:

	se->se.latency_offset = get_sleep_latency * nice / (NICE_LATENCY_WIDTH/2);

? The reason we have prio_to_weight[] is because it's an exponential,
which is a bit more cumbersome to calculate, but surely we can do a
linear function at runtime.


