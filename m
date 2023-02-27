From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v10 8/9] sched/fair: Add latency list
Date: Mon, 27 Feb 2023 14:29:27 +0100
Message-ID: <Y/ywN3Sz33gHO3Vj@hirez.programming.kicks-ass.net>
References: <20230113141234.260128-1-vincent.guittot@linaro.org>
 <20230113141234.260128-9-vincent.guittot@linaro.org>
 <Y/XlR+wLtn54CkE4@hirez.programming.kicks-ass.net>
 <CAKfTPtBJD6So-0-S3sgFqTE1HVMypg_S23+uuH6BnGk5atxUKA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AB/JJQoz7Q3YSgyTBOyspLv2ZEi2yhJlHwTRl8RgmcI=; b=IDrwwV6BUNud8U9fRntTASkSMH
        ZjLWpC+aiFuWVnovyo1te3tMFRKO3ZyDIO3x0iNv1YskrQJfmFGjmxxDGeJlTozh5OBHwQyzynoqh
        Y8JW086CTgeio8ueWCt8u4l9XYG7mOKI1mreVzU0qgCbUDhqU+qhJoT9TatgBw7x6MOXUwoa3M1ug
        L5bVFP8oY5Gwl5WHdDLKHYhHl+pPD22GB6D0EeWABivGof/q9ZmfVRzEwEyAvCg0+Ku1qNiE3ziEB
        VLQUqEGyheEFwIXLT9NatbYetmw4JO3CBOa3+qEDij/Bard6BM7EcWJYjLYZckNyAlaH0HMn5fWkZ
        rJigvvyg==;
Content-Disposition: inline
In-Reply-To: <CAKfTPtBJD6So-0-S3sgFqTE1HVMypg_S23+uuH6BnGk5atxUKA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, patrick.bellasi-X6neQFFVdzGsTnJN9+BGXg@public.gmane.org, David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timj-mXXj517/zsQ@public.gmane.org, kprateek.nayak-5C7GfCeVMHo@public.gmane.org, yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, youssefesmat-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org

On Wed, Feb 22, 2023 at 12:16:29PM +0100, Vincent Guittot wrote:
> On Wed, 22 Feb 2023 at 10:50, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> >
> > On Fri, Jan 13, 2023 at 03:12:33PM +0100, Vincent Guittot wrote:
> >
> > > +static void __enqueue_latency(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
> > > +{
> > > +
> > > +     /* Only latency sensitive entity can be added to the list */
> > > +     if (se->latency_offset >= 0)
> > > +             return;
> > > +
> > > +     if (!RB_EMPTY_NODE(&se->latency_node))
> > > +             return;
> > > +
> > > +     /*
> > > +      * An execution time less than sysctl_sched_min_granularity means that
> > > +      * the entity has been preempted by a higher sched class or an entity
> > > +      * with higher latency constraint.
> > > +      * Put it back in the list so it gets a chance to run 1st during the
> > > +      * next slice.
> > > +      */
> > > +     if (!(flags & ENQUEUE_WAKEUP)) {
> > > +             u64 delta_exec = se->sum_exec_runtime - se->prev_sum_exec_runtime;
> > > +
> > > +             if (delta_exec >= sysctl_sched_min_granularity)
> > > +                     return;
> > > +     }
> >
> > I'm not a big fan of this dynamic enqueueing condition; it makes it
> > rather hard to interpret the below addition to pick_next_entity().
> >
> > Let me think about this more... at the very least the comment with
> > __pick_first_latency() use below needs to be expanded upon if we keep it
> > like so.
>
> Only the waking tasks should be added in the latency rb tree so they

But that's what I'm saying, you can game this by doing super short
sleeps every min_gran.

> can be selected to run 1st (as long as they don't use too much
> runtime). But task A can wake up, preempts current task B thanks to
> its latency nice , starts to run few usecs but then is immediately
> preempted by a RT task C as an example. In this case, we consider that
> the task A didn't get a chance to run after its wakeup and we put it
> back to the latency rb tree just as if task A has just woken up but
> didn't preempted the new current task C.

So ideally, and this is where I'm very slow with thinking, that
wakeup_preempt_entity() condition here:

> > > @@ -5008,6 +5082,12 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
> > >               se = cfs_rq->last;
> > >       }
> > >
> > > +     /* Check for latency sensitive entity waiting for running */
> > > +     latency = __pick_first_latency(cfs_rq);
> > > +     if (latency && (latency != se) &&
> > > +         wakeup_preempt_entity(latency, se) < 1)
> > > +             se = latency;

should be sufficient to provide fair bandwidth usage. The EEVDF paper
achieves this by selecting the leftmost elegible task, where elegibility
is dependent on negative lag. Only those tasks that are behind the pack
are allowed runtime.

Now clearly our min_vruntime is unsuited for that exact scheme, but iirc
wake_preempt_entity() does not allow for starvation, so we should be
good, even without that weird condition in __enqueue_latency(), hmm?
