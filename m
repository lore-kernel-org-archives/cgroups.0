From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] cgroup: make per-cgroup pressure stall tracking configurable
Date: Fri, 14 May 2021 08:54:47 -0700
Message-ID: <CAJuCfpHy+MknCepfjx9XYUA1j42Auauv7MFQbt+zOU-tA4gasA@mail.gmail.com>
References: <20210513175349.959661-1-surenb@google.com> <YJ5iAvqAmIhzJRot@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y052LogTUvmTYDDB+WfKoZ5F+9wGSH/Xp6XYfMNjiT0=;
        b=rmOj1JlGNHpx+uPiVKXp2GXMWFkLj/A2WtlyaZyD5pZFxwhlsqd9zu0CmNdx2nQKz3
         hyKBSMJEwq4rkRa1IKAxZNhcGDAR+T6fks73i5T1b7VEfpOp/gDb2G/+5nFgGIONK+KE
         5WTx5ufZ/30+cWeOlNLTJcwxWCkVh7nMAyWjrV77SCuEV9Vv+/qhYpaSzCD2TSPjXpbE
         pthBuekUFWiKhmAdMmrAYeNIhk//NcnHznalrkjl4A1UoLj5Q/zs2/74f2tVtHRtlnn6
         LkS6QSRN4TUGoxGxletRTqpWwfMbv6aWju2Cxk02zuImCHGjcle6K1d3PDeirZ5+JyYO
         DsaA==
In-Reply-To: <YJ5iAvqAmIhzJRot-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Benjamin Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, mgorman-l3A5Bk7waGM@public.gmane.org, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "Paul E . McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, macro-fOkVWZO6G+f10XsdtD+oqA@public.gmane.org, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, May 14, 2021 at 4:42 AM Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Thu, May 13, 2021 at 10:53:49AM -0700, Suren Baghdasaryan wrote:
>
> > +bool cgroup_psi_enabled(void)
> > +{
> > +     return (cgroup_feature_disable_mask & (1 << OPT_FEATURE_PRESSURE)) == 0;
> > +}
>
> > diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> > index cc25a3cff41f..c73efd7d4fba 100644
> > --- a/kernel/sched/psi.c
> > +++ b/kernel/sched/psi.c
> > @@ -747,9 +747,12 @@ static struct psi_group *iterate_groups(struct task_struct *task, void **iter)
> >  #ifdef CONFIG_CGROUPS
> >       struct cgroup *cgroup = NULL;
> >
> > -     if (!*iter)
> > +     if (!*iter) {
> > +             /* Skip to psi_system if per-cgroup accounting is disabled */
> > +             if (!cgroup_psi_enabled())
> > +                     goto update_sys;
> >               cgroup = task->cgroups->dfl_cgrp;
> > -     else if (*iter == &psi_system)
> > +     } else if (*iter == &psi_system)
> >               return NULL;
> >       else
> >               cgroup = cgroup_parent(*iter);
> > @@ -758,6 +761,7 @@ static struct psi_group *iterate_groups(struct task_struct *task, void **iter)
> >               *iter = cgroup;
> >               return cgroup_psi(cgroup);
> >       }
> > +update_sys:
> >  #else
> >       if (*iter)
> >               return NULL;
>
> I'm confused; shouldn't that do the same as that #else branch?

Correct, for this function CONFIG_CGROUPS=n and
cgroup_disable=pressure are treated the same. True, from the code it's
not very obvious. Do you have some refactoring in mind that would make
it more explicit?

>Also, can you pretty please make cgroup_psi_enabled() a static_key ?

Certainly, will post an update on Monday.
Thanks for the feedback, Peter!

>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe-z5hGa2qSFaTowKkBSvOlow@public.gmane.org
>
