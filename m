From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/1] cgroup: make per-cgroup pressure stall tracking configurable
Date: Tue, 18 May 2021 11:55:59 -0700
Message-ID: <CAJuCfpFVEmYdnqDz+-txLtxM3OhLTyQUJPPP-jLq1YPg0fZ_dA@mail.gmail.com>
References: <20210518020200.1790058-1-surenb@google.com> <20210518185251.GI5618@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U5LLkV364fFy+W60IIkSO6ynttP+rk35+EuRn6ckGs8=;
        b=cxprohY/XMTUx1TEQw8jbzPmXFucnMNA2eyWUf19LpmAQx4UNLsmqbHDZHdjS/CaGr
         t03JLmDOtp4Xg8I94GL554PMO32h1RtbAqafRiUuHeVq0UM4yvTJUOloXYB06ANBfGoL
         jHHUFpm3nc2I9VvFuOTc16xcLvyF/tSSQeTmyKXCLvcacBJg/QcxMiYoGjz3FPLCq2i4
         yYN8KkaSHTDa9C4UeiuwVYyH/i+SWrdUN9pY85oTs04kt0M7iKY9mN+soWEbt1EI4dpk
         edMxfCj+tyiAfv6N8heO33kP/Uy2yt6kyaDwkgF3bgtxtw/079Q1Rsuq/cikCVm577W8
         /QhA==
In-Reply-To: <20210518185251.GI5618-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Benjamin Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E . McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, macro-fOkVWZO6G+f10XsdtD+oqA@public.gmane.org, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-doc-fy+rA21nqHI@public.gmane.org

On Tue, May 18, 2021 at 11:52 AM Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Mon, May 17, 2021 at 07:02:00PM -0700, Suren Baghdasaryan wrote:
>
> > diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> > index cc25a3cff41f..4b8e72640ac9 100644
> > --- a/kernel/sched/psi.c
> > +++ b/kernel/sched/psi.c
> > @@ -148,6 +148,7 @@
> >  static int psi_bug __read_mostly;
> >
> >  DEFINE_STATIC_KEY_FALSE(psi_disabled);
> > +DEFINE_STATIC_KEY_FALSE(psi_cgroups_disabled);
>
> I'm thinking the whole thing will be easier/clearer when you make this:
>
> DEFINE_STATIC_KEY_TRUE(psi_cgroups_enabled);
>

Sounds good. Will respin another version. Thanks for reviewing!


> >
> >  #ifdef CONFIG_PSI_DEFAULT_DISABLED
> >  static bool psi_enable;
> > @@ -211,6 +212,9 @@ void __init psi_init(void)
> >               return;
> >       }
> >
> > +     if (!cgroup_psi_enabled())
> > +             static_branch_enable(&psi_cgroups_disabled);
>
>         if (!cgroup_psi_enabled())
>                 static_branch_disable(&psi_cgroups_enabled);
>
> > +
> >       psi_period = jiffies_to_nsecs(PSI_FREQ);
> >       group_init(&psi_system);
> >  }
> > @@ -744,23 +748,23 @@ static void psi_group_change(struct psi_group *group, int cpu,
> >
> >  static struct psi_group *iterate_groups(struct task_struct *task, void **iter)
> >  {
> > +     if (*iter == &psi_system)
> > +             return NULL;
> > +
> >  #ifdef CONFIG_CGROUPS
> > +     if (!static_branch_likely(&psi_cgroups_disabled)) {
>
>         if (static_branch_likely(&psi_cgroups_enabled)) {
>
> > +             struct cgroup *cgroup = NULL;
> >
> > +             if (!*iter)
> > +                     cgroup = task->cgroups->dfl_cgrp;
> > +             else
> > +                     cgroup = cgroup_parent(*iter);
> >
> > +             if (cgroup && cgroup_parent(cgroup)) {
> > +                     *iter = cgroup;
> > +                     return cgroup_psi(cgroup);
> > +             }
> >       }
> >  #endif
> >       *iter = &psi_system;
> >       return &psi_system;
>
> But yes, very nice.
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe-z5hGa2qSFaTowKkBSvOlow@public.gmane.org
>
