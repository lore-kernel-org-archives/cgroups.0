From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 8/9] sched/fair: Add latency list
Date: Tue, 21 Feb 2023 16:42:38 +0100
Message-ID: <CAKfTPtDQ0hgiqdO7ywUEw3htpiBS3NxWMxXL9LqmBpA8E25quw@mail.gmail.com>
References: <20230113141234.260128-1-vincent.guittot@linaro.org>
 <20230113141234.260128-9-vincent.guittot@linaro.org> <Y/TfN1upxApdSERP@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pgJoew5uSEhDOZSrg2jVXTz7ZRs9T5t38ejwKJjnfNc=;
        b=vRuRw5Ip1otM+28WxOzAbghLRjYEHZe4RWCNG7lf98qoXAKX0zLO5rRroIHpTA8tCW
         cidxPyx4eumCtj3ns4zK3AB4YSqL8rusHgjnG1O6cXngiSERzr5ReARfFOIMud8JBr9s
         4ZLtqam/3ItxgRS2GEoRDZsamVjWTagDE0EZ4Yna2QAxEp2tIuTgJkAtMNXsdJJF4hAe
         dwEdodqsbiQEhYaGGdXryLnumt7MYgqzPo/qnqwJAXvqXGUqa2fS/CzOzYJITAk+a+Mu
         lH70xu4ZNSpWSsZ2tDnb3WWX6jx83qZUMl8gLqlsgIyUkhRpG3Q6EcitnziuodUyVmpL
         J/kg==
In-Reply-To: <Y/TfN1upxApdSERP-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, patrick.bellasi-X6neQFFVdzGsTnJN9+BGXg@public.gmane.org, David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timj-mXXj517/zsQ@public.gmane.org, kprateek.nayak-5C7GfCeVMHo@public.gmane.org, yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, youssefesmat-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org

On Tue, 21 Feb 2023 at 16:12, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Fri, Jan 13, 2023 at 03:12:33PM +0100, Vincent Guittot wrote:
> > @@ -12552,8 +12634,15 @@ int sched_group_set_latency(struct task_group *tg, s64 latency)
> >
> >       for_each_possible_cpu(i) {
> >               struct sched_entity *se = tg->se[i];
> > +             struct rq *rq = cpu_rq(i);
> > +             struct rq_flags rf;
> > +
> > +             rq_lock_irqsave(rq, &rf);
> >
> > +             __dequeue_latency(se->cfs_rq, se);
> >               WRITE_ONCE(se->latency_offset, latency);
> > +
> > +             rq_unlock_irqrestore(rq, &rf);
> >       }
>
> This seems asymmetric; maybe something like:
>
>         queued = __dequeue_latency(..);
>         WRITE_ONCE(...);
>         if (queued)
>                 __enqueue_latency(...);
>
> ?

Fair enough
