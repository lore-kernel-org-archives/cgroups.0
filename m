From: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] sched/cpuset: Keep track of SCHED_DEADLINE tasks
 in cpusets
Date: Wed, 15 Mar 2023 17:18:57 +0000
Message-ID: <ZBH+AaJV36y/HNXk@localhost.localdomain>
References: <20230315121812.206079-1-juri.lelli@redhat.com>
 <20230315121812.206079-3-juri.lelli@redhat.com>
 <20230315144927.624cbwc3yep3fwor@airbuntu>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678900742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UVXZ9RkFbzbXN9OpSinhyf/3z8cujBPcQ64MTebMFxM=;
        b=JLI2cQTLNpBxlCDmucAlw8llaSOqsgnU2bibuBEc3Op/Euk9ZfW8wDTQf2QobqVasoxZdU
        UKQjm8mPimUOo5W8TZp5UTkZnOfuwVaMTNeSmD2jjUiA32GWVrRMxb7mHeFc6ghuwBIjEv
        SUBfuLKTDxT11kGi5sq6Im1yMgRqY0U=
Content-Disposition: inline
In-Reply-To: <20230315144927.624cbwc3yep3fwor@airbuntu>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AyHOaXKfS9Lw@public.gmane.org>

On 15/03/23 14:49, Qais Yousef wrote:
> On 03/15/23 12:18, Juri Lelli wrote:

...

> > +void inc_dl_tasks_cs(struct task_struct *p)
> > +{
> > +	struct cpuset *cs = task_cs(p);
> 
> nit:
> 
> I *think* task_cs() assumes rcu_read_lock() is held, right?
> 
> Would it make sense to WARN_ON(!rcu_read_lock_held()) to at least
> annotate the deps?

Think we have that check in task_css_set_check()?

> Or maybe task_cs() should do that..
> 
> > +
> > +	cs->nr_deadline_tasks++;
> > +}
> > +
> > +void dec_dl_tasks_cs(struct task_struct *p)
> > +{
> > +	struct cpuset *cs = task_cs(p);
> 
> nit: ditto
> 
> > +
> > +	cs->nr_deadline_tasks--;
> > +}
> > +

...

> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 5902cbb5e751..d586a8440348 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -7683,6 +7683,16 @@ static int __sched_setscheduler(struct task_struct *p,
> >  		goto unlock;
> >  	}
> >  
> > +	/*
> > +	 * In case a task is setscheduled to SCHED_DEADLINE, or if a task is
> > +	 * moved to a different sched policy, we need to keep track of that on
> > +	 * its cpuset (for correct bandwidth tracking).
> > +	 */
> > +	if (dl_policy(policy) && !dl_task(p))
> > +		inc_dl_tasks_cs(p);
> > +	else if (dl_task(p) && !dl_policy(policy))
> > +		dec_dl_tasks_cs(p);
> > +
> 
> Would it be better to use switched_to_dl()/switched_from_dl() instead to
> inc/dec_dl_tasks_cs()?

Ah, makes sense. I'll play with this.

Thanks,
Juri

