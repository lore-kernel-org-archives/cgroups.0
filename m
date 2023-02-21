From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 5/9] sched/fair: Take into account latency priority at wakeup
Date: Tue, 21 Feb 2023 15:21:54 +0100
Message-ID: <CAKfTPtAk2A8zPgOfpbN0s4LZv+d7ABB9=5tAEMCbVrf263XtjA@mail.gmail.com>
References: <20230113141234.260128-1-vincent.guittot@linaro.org>
 <20230113141234.260128-6-vincent.guittot@linaro.org> <Y/TBdB23akBbUjqd@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=V7OOFYL+9a+DRriFIjyujp84znXjDZJVpnPQuMpQ90k=;
        b=uxXrXBivm84NQWwQYwLWkE3/QZuLMx8nAcxbhDvr3LCb32j58QCfPCWF9PRiwKN4rU
         bQcv+JQNONAnY/fDXnUVEM4w8U+O+CGCxIJG1roGRgJ7H6wvq6YF1NN4Ne530NS4O3OA
         Zbk6VkeDag4aHh9BFe7ZRabDCWJNb8m//dz6aToW0Lr7knW8nlgSJ4p8L/tMaWefru6W
         OK33p5NlRRDuk07EUn0aNKUfOQ9ZWZ9QliQCHlxevjzfprRpmncMGHGQP00ShcI8L1pG
         QW4WWlvOIPACNzDF/TEj3aU5hjRkeoELxyF6v3hqo6wzD38unTh3BufChDvkRbHTShn/
         KxJw==
In-Reply-To: <Y/TBdB23akBbUjqd-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, patrick.bellasi-X6neQFFVdzGsTnJN9+BGXg@public.gmane.org, David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timj-mXXj517/zsQ@public.gmane.org, kprateek.nayak-5C7GfCeVMHo@public.gmane.org, yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, youssefesmat-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org

On Tue, 21 Feb 2023 at 14:05, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Fri, Jan 13, 2023 at 03:12:30PM +0100, Vincent Guittot wrote:
> > @@ -6155,6 +6159,35 @@ static int sched_idle_cpu(int cpu)
> >  }
> >  #endif
> >
> > +static void set_next_buddy(struct sched_entity *se);
> > +
> > +static void check_preempt_from_others(struct cfs_rq *cfs, struct sched_entity *se)
> > +{
> > +     struct sched_entity *next;
> > +
> > +     if (se->latency_offset >= 0)
> > +             return;
> > +
> > +     if (cfs->nr_running <= 1)
> > +             return;
> > +     /*
> > +      * When waking from another class, we don't need to check to preempt at
> > +      * wakeup and don't set next buddy as a candidate for being picked in
> > +      * priority.
> > +      * In case of simultaneous wakeup when current is another class, the
> > +      * latency sensitive tasks lost opportunity to preempt non sensitive
> > +      * tasks which woke up simultaneously.
> > +      */
> > +
> > +     if (cfs->next)
> > +             next = cfs->next;
> > +     else
> > +             next = __pick_first_entity(cfs);
> > +
> > +     if (next && wakeup_preempt_entity(next, se) == 1)
> > +             set_next_buddy(se);
> > +}
> > +
> >  /*
> >   * The enqueue_task method is called before nr_running is
> >   * increased. Here we update the fair scheduling stats and
> > @@ -6241,14 +6274,15 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
> >       if (!task_new)
> >               update_overutilized_status(rq);
> >
> > +     if (rq->curr->sched_class != &fair_sched_class)
> > +             check_preempt_from_others(cfs_rq_of(&p->se), &p->se);
> > +
> >  enqueue_throttle:
> >       assert_list_leaf_cfs_rq(rq);
> >
> >       hrtick_update(rq);
> >  }
>
> Hmm.. This sets a next selection when the task gets enqueued while not
> running a fair task -- and looses a wakeup preemption opportunity.
>
> Should we perhaps also do this for latency_nice == 0?, in any case I
> think this can be moved to its own patch to avoid doing too much in the
> one patch. It seems fairly self contained.

This function is then removed by patch 9 as the additional rb tree
fixes all cases

>
