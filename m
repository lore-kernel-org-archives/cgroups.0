From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 8/9] sched/fair: Add latency list
Date: Wed, 22 Feb 2023 12:16:29 +0100
Message-ID: <CAKfTPtBJD6So-0-S3sgFqTE1HVMypg_S23+uuH6BnGk5atxUKA@mail.gmail.com>
References: <20230113141234.260128-1-vincent.guittot@linaro.org>
 <20230113141234.260128-9-vincent.guittot@linaro.org> <Y/XlR+wLtn54CkE4@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677064600;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=x+BI276LAtkDkFkhbO8UzGamxJ+PETieQFjUz5/ET20=;
        b=mb1mn3MhGDW6cSSFeJGsoejg4FxJ9bOZTCBKtgQJiOvDt4d1akIBSE+tToXBmRv0E5
         V1RjjG21ff9Kjre2RNazc44d3hTcEmIkgSFqWEpspIH5YNcw2ZPZ9r0NED4OVol31OIk
         c1FCoGYVnOwaAdFQel8Vc8L/nWNUWKWpc9TVrPyy5bJpqSeaBu3cL2aDuUSqd23BXnkF
         51MGu3neCN1nafaepdFkzyI4Q4TgVGhAOmxvaLMeEXBCG1ZcSA74MnRquSp8+8auIb6l
         cSay+rcKRs8F96+IAhYtQl/e9pRuw7aZmFwWgT/skm/DBXycpX/cSqdnUslHt0Ko/5Qq
         Y5EA==
In-Reply-To: <Y/XlR+wLtn54CkE4-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, patrick.bellasi-X6neQFFVdzGsTnJN9+BGXg@public.gmane.org, David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timj-mXXj517/zsQ@public.gmane.org, kprateek.nayak-5C7GfCeVMHo@public.gmane.org, yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, youssefesmat-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org

On Wed, 22 Feb 2023 at 10:50, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Fri, Jan 13, 2023 at 03:12:33PM +0100, Vincent Guittot wrote:
>
> > +static void __enqueue_latency(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
> > +{
> > +
> > +     /* Only latency sensitive entity can be added to the list */
> > +     if (se->latency_offset >= 0)
> > +             return;
> > +
> > +     if (!RB_EMPTY_NODE(&se->latency_node))
> > +             return;
> > +
> > +     /*
> > +      * An execution time less than sysctl_sched_min_granularity means that
> > +      * the entity has been preempted by a higher sched class or an entity
> > +      * with higher latency constraint.
> > +      * Put it back in the list so it gets a chance to run 1st during the
> > +      * next slice.
> > +      */
> > +     if (!(flags & ENQUEUE_WAKEUP)) {
> > +             u64 delta_exec = se->sum_exec_runtime - se->prev_sum_exec_runtime;
> > +
> > +             if (delta_exec >= sysctl_sched_min_granularity)
> > +                     return;
> > +     }
>
> I'm not a big fan of this dynamic enqueueing condition; it makes it
> rather hard to interpret the below addition to pick_next_entity().
>
> Let me think about this more... at the very least the comment with
> __pick_first_latency() use below needs to be expanded upon if we keep it
> like so.

Only the waking tasks should be added in the latency rb tree so they
can be selected to run 1st (as long as they don't use too much
runtime). But task A can wake up, preempts current task B thanks to
its latency nice , starts to run few usecs but then is immediately
preempted by a RT task C as an example. In this case, we consider that
the task A didn't get a chance to run after its wakeup and we put it
back to the latency rb tree just as if task A has just woken up but
didn't preempted the new current task C.

I have used sysctl_sched_min_granularity has this is min runtime for a
task before being possibly preempted at tick by another cfs task with
a lower vruntime so if it runs less than sysctl_sched_min_granularity
we are sure that it has been preempted by higher prio tasks and it's
not because it used all its runtime compared to others

>
> > +
> > +     rb_add_cached(&se->latency_node, &cfs_rq->latency_timeline, __latency_less);
> > +}
>
> > @@ -4966,7 +5040,7 @@ static struct sched_entity *
> >  pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
> >  {
> >       struct sched_entity *left = __pick_first_entity(cfs_rq);
> > -     struct sched_entity *se;
> > +     struct sched_entity *latency, *se;
> >
> >       /*
> >        * If curr is set we have to see if its left of the leftmost entity
> > @@ -5008,6 +5082,12 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
> >               se = cfs_rq->last;
> >       }
> >
> > +     /* Check for latency sensitive entity waiting for running */
> > +     latency = __pick_first_latency(cfs_rq);
> > +     if (latency && (latency != se) &&
> > +         wakeup_preempt_entity(latency, se) < 1)
> > +             se = latency;
>
> I'm not quite sure why this condition isn't sufficient on it's own.
> After all, if a task does a 'spurious' nanosleep it can get around the
> 'restriction' in __enqueue_latency() without any great penalty to it's
> actual bandwidth consumption.

Yes it until it used all its runtime.
