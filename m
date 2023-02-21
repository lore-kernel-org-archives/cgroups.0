From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 6/9] sched/fair: Add sched group latency support
Date: Tue, 21 Feb 2023 16:32:37 +0100
Message-ID: <CAKfTPtBsFn3SW+DLYFNLiaroqFox5sXwBy8zVWZ24F9SKg7FJg@mail.gmail.com>
References: <20230113141234.260128-1-vincent.guittot@linaro.org>
 <20230113141234.260128-7-vincent.guittot@linaro.org> <Y/TcwkmiVXJmQ9nw@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1676993568;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ehh0eemONObY4KTgZxfTyrJ90BFUoWQW75KmGdpJJUU=;
        b=Y2YGEjYzRv62HOvaoOMPOPH3yegCdyyoIldwK+TxmcJiHo3mLPKK2G0bDGyrWCH3FD
         SkEmK4DcPWsY7pslsIrb4z4w+hREUjckAQRiRcvpOB0hb+WoonFfg1JVMhiSrcBS7U5z
         xCDl0RSJXQsR6+8xr1imkZB2ZWKxTmHCxGMpzatiEdosMpvV61wkcEkN0YZtOQP5k5bI
         3ypUuVzovLYI3ak4HSjxDy1HOYGoWTwG7+7WRCZqZsKSkmyqlM477TEvYdh2JdLMFF1g
         plc3+kBgE7JgPFKcq75owdW2ME8rLkLd/KGBhrSzZcoxKjBZGrjq/da7V1fTU+NEfiV2
         LrlA==
In-Reply-To: <Y/TcwkmiVXJmQ9nw-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, patrick.bellasi-X6neQFFVdzGsTnJN9+BGXg@public.gmane.org, David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timj-mXXj517/zsQ@public.gmane.org, kprateek.nayak-5C7GfCeVMHo@public.gmane.org, yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, youssefesmat-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org

On Tue, 21 Feb 2023 at 16:01, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Fri, Jan 13, 2023 at 03:12:31PM +0100, Vincent Guittot wrote:
>
> > +static s64 cpu_latency_nice_read_s64(struct cgroup_subsys_state *css,
> > +                                 struct cftype *cft)
> > +{
> > +     int prio, delta, last_delta = INT_MAX;
> > +     s64 weight;
> > +
> > +     weight = css_tg(css)->latency_offset * NICE_LATENCY_WEIGHT_MAX;
> > +     weight = div_s64(weight, get_sleep_latency(false));
> > +
> > +     /* Find the closest nice value to the current weight */
>
> This comment isn't entirely accurate, since we only have the nice_write
> interface below, this will be an exact match. The thing with weight is
> that we first had the raw weight value interface and then the nice
> interface had to map random values back to a 'nice' value.

Yes, there was a long discussion about the interface and without any
simple raw value to share, we decided to only use latency_nice until
we found a generic metric
>
> Arguably we can simply store the raw nice value in write and print it
> out again here.

Probably, I just wanted to prevent the latency.nice being the main
value saved in cgroup . But I suppose it could be ok to save it
directly

>
> > +     for (prio = 0; prio < ARRAY_SIZE(sched_latency_to_weight); prio++) {
> > +             delta = abs(sched_latency_to_weight[prio] - weight);
> > +             if (delta >= last_delta)
> > +                     break;
> > +             last_delta = delta;
> > +     }
> > +
> > +     return LATENCY_TO_NICE(prio-1);
> > +}
> > +
> > +static int cpu_latency_nice_write_s64(struct cgroup_subsys_state *css,
> > +                                  struct cftype *cft, s64 nice)
> > +{
> > +     s64 latency_offset;
> > +     long weight;
> > +     int idx;
> > +
> > +     if (nice < MIN_LATENCY_NICE || nice > MAX_LATENCY_NICE)
> > +             return -ERANGE;
> > +
> > +     idx = NICE_TO_LATENCY(nice);
> > +     idx = array_index_nospec(idx, LATENCY_NICE_WIDTH);
> > +     weight = sched_latency_to_weight[idx];
> > +
> > +     latency_offset = weight * get_sleep_latency(false);
> > +     latency_offset = div_s64(latency_offset, NICE_LATENCY_WEIGHT_MAX);
> > +
> > +     return sched_group_set_latency(css_tg(css), latency_offset);
> > +}
