From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v2 1/1] cgroup: make per-cgroup pressure stall tracking configurable
Date: Mon, 24 May 2021 12:58:22 -0700
Message-ID: <CAJuCfpEMybpu_ALyu=SSLg4-YDC50bQa3jmeNUXSq9UKXfh5UQ@mail.gmail.com>
References: <20210518020200.1790058-1-surenb@google.com> <20210518185251.GI5618@worktop.programming.kicks-ass.net>
 <CAJuCfpFVEmYdnqDz+-txLtxM3OhLTyQUJPPP-jLq1YPg0fZ_dA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WJ6tyfSEArP9hZm90tcyE3NQZnpl/6fI+B8ESdNfuho=;
        b=DGiMbn2oWBHJGlquzFbClTelbBRbm6EbopgxGjWgk/Utr3/zBOwHFEGbLBpdvji4Td
         r2re7GIDGTlYE2Y58CiJKz08whvTgviabFbWPfBc9xp4lN6YLJ1UYj5cwUfJhzM0P6qY
         tsSHIphGc1Dc8Yx6HNyLBr/xRllCLcwUeOOujJ+rsLiY1Tubi8Z9ijH9QbBmpwqKlTsA
         scYxl7X9h9gYP+m9+78Q5lmPxLW9w6o9v944+eZEoK/nzc/RCEFJL3DW6o7IzcoxAQKf
         TD9AAK4a603BtCQe8P9zDowyC7j7iCO7pCYuwFFyTKe94LeiRYNmbC7RxBwVLpn3QUMl
         QJxA==
In-Reply-To: <CAJuCfpFVEmYdnqDz+-txLtxM3OhLTyQUJPPP-jLq1YPg0fZ_dA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Zefan Li <lizefan.x@bytedance.com>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Benjamin Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Daniel Bristot de Oliveira <bristot@redhat.com>, "Paul E . McKenney" <paulmck@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, macro@orcam.me.uk, Viresh Kumar <viresh.kumar@linaro.org>, Mike Kravetz <mike.kravetz@oracle.com>, linux-doc@vger.ke

On Tue, May 18, 2021 at 11:55 AM Suren Baghdasaryan <surenb@google.com> wrote:
>
> On Tue, May 18, 2021 at 11:52 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Mon, May 17, 2021 at 07:02:00PM -0700, Suren Baghdasaryan wrote:
> >
> > > diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> > > index cc25a3cff41f..4b8e72640ac9 100644
> > > --- a/kernel/sched/psi.c
> > > +++ b/kernel/sched/psi.c
> > > @@ -148,6 +148,7 @@
> > >  static int psi_bug __read_mostly;
> > >
> > >  DEFINE_STATIC_KEY_FALSE(psi_disabled);
> > > +DEFINE_STATIC_KEY_FALSE(psi_cgroups_disabled);
> >
> > I'm thinking the whole thing will be easier/clearer when you make this:
> >
> > DEFINE_STATIC_KEY_TRUE(psi_cgroups_enabled);
> >
>
> Sounds good. Will respin another version. Thanks for reviewing!

v3 is posted at https://lore.kernel.org/patchwork/patch/1435705

>
>
> > >
> > >  #ifdef CONFIG_PSI_DEFAULT_DISABLED
> > >  static bool psi_enable;
> > > @@ -211,6 +212,9 @@ void __init psi_init(void)
> > >               return;
> > >       }
> > >
> > > +     if (!cgroup_psi_enabled())
> > > +             static_branch_enable(&psi_cgroups_disabled);
> >
> >         if (!cgroup_psi_enabled())
> >                 static_branch_disable(&psi_cgroups_enabled);
> >
> > > +
> > >       psi_period = jiffies_to_nsecs(PSI_FREQ);
> > >       group_init(&psi_system);
> > >  }
> > > @@ -744,23 +748,23 @@ static void psi_group_change(struct psi_group *group, int cpu,
> > >
> > >  static struct psi_group *iterate_groups(struct task_struct *task, void **iter)
> > >  {
> > > +     if (*iter == &psi_system)
> > > +             return NULL;
> > > +
> > >  #ifdef CONFIG_CGROUPS
> > > +     if (!static_branch_likely(&psi_cgroups_disabled)) {
> >
> >         if (static_branch_likely(&psi_cgroups_enabled)) {
> >
> > > +             struct cgroup *cgroup = NULL;
> > >
> > > +             if (!*iter)
> > > +                     cgroup = task->cgroups->dfl_cgrp;
> > > +             else
> > > +                     cgroup = cgroup_parent(*iter);
> > >
> > > +             if (cgroup && cgroup_parent(cgroup)) {
> > > +                     *iter = cgroup;
> > > +                     return cgroup_psi(cgroup);
> > > +             }
> > >       }
> > >  #endif
> > >       *iter = &psi_system;
> > >       return &psi_system;
> >
> > But yes, very nice.
> >
> > --
> > To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> >
