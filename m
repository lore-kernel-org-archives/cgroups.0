From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] cgroup: make per-cgroup pressure stall tracking configurable
Date: Fri, 14 May 2021 11:50:06 -0700
Message-ID: <CAJuCfpH2X47_3VvfZXs_eWhYDziOh13qdUwcfxPJe=Zg_Nkvqw@mail.gmail.com>
References: <20210513175349.959661-1-surenb@google.com> <YJ5iAvqAmIhzJRot@hirez.programming.kicks-ass.net>
 <CAJuCfpHy+MknCepfjx9XYUA1j42Auauv7MFQbt+zOU-tA4gasA@mail.gmail.com>
 <YJ64xHoogrowXTok@hirez.programming.kicks-ass.net> <CAJuCfpGkj9HxbkXnYN58JXJp1j6kVkvQhqscnEfjyB5unKg1NQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+muSPPrBFQS9BSc0XLvqjbGXmXt1qzS3v/wikaP3SFA=;
        b=cwimqVsxRhMfLl3BUVdKOfBuVUWCAaEwy2N+oSpdJihUEyOv8KKE9wmrwBugETu4Cj
         kAd6i6KkaTWyq3+xAesgB78ZLsomdzHKjUXLyq8QjJWV699jE//SYZ5t+qj9oGmbQb+l
         /n4+uqQtvp119b5o+bzYd/ZXfdyUDJG+tfJgKObJvZlSWmIdFo+ClW8Zq1X1gXgYIiZO
         pvabe/l9/8HvLZVMbg6T53jeQfdupvP/ZLB10YmnZHUQm3ezR7yNEk1WsBfSTKa668k0
         36W1W3jvk4s0ju35RM4z7N7RkN8ipSFlYIkFzc6G1ssd60DJm0j9WY1TXAmzJgNqcTeE
         7m0w==
In-Reply-To: <CAJuCfpGkj9HxbkXnYN58JXJp1j6kVkvQhqscnEfjyB5unKg1NQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Benjamin Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, mgorman-l3A5Bk7waGM@public.gmane.org, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "Paul E . McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, macro-fOkVWZO6G+f10XsdtD+oqA@public.gmane.org, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, May 14, 2021 at 11:20 AM Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Fri, May 14, 2021 at 10:52 AM Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> >
> > On Fri, May 14, 2021 at 08:54:47AM -0700, Suren Baghdasaryan wrote:
> >
> > > Correct, for this function CONFIG_CGROUPS=n and
> > > cgroup_disable=pressure are treated the same. True, from the code it's
> > > not very obvious. Do you have some refactoring in mind that would make
> > > it more explicit?
> >
> > Does this make sense?
> >
> > --- a/kernel/sched/psi.c
> > +++ b/kernel/sched/psi.c
> > @@ -744,24 +744,26 @@ static void psi_group_change(struct psi_
> >
> >  static struct psi_group *iterate_groups(struct task_struct *task, void **iter)
> >  {
> > +       if (cgroup_psi_enabled()) {
> >  #ifdef CONFIG_CGROUPS
> > -       struct cgroup *cgroup = NULL;
> > +               struct cgroup *cgroup = NULL;
> >
> > -       if (!*iter)
> > -               cgroup = task->cgroups->dfl_cgrp;
> > -       else if (*iter == &psi_system)
> > -               return NULL;
> > -       else
> > -               cgroup = cgroup_parent(*iter);
> > +               if (!*iter)
> > +                       cgroup = task->cgroups->dfl_cgrp;
> > +               else if (*iter == &psi_system)
> > +                       return NULL;
> > +               else
> > +                       cgroup = cgroup_parent(*iter);
> >
> > -       if (cgroup && cgroup_parent(cgroup)) {
> > -               *iter = cgroup;
> > -               return cgroup_psi(cgroup);
> > -       }
> > -#else
> > -       if (*iter)
> > -               return NULL;
> > +               if (cgroup && cgroup_parent(cgroup)) {
> > +                       *iter = cgroup;
> > +                       return cgroup_psi(cgroup);
> > +               }
> >  #endif
> > +       } else {
> > +               if (*iter)
> > +                       return NULL;
> > +       }
> >         *iter = &psi_system;
> >         return &psi_system;
> >  }
>
> Hmm. Looks like the case when cgroup_psi_enabled()==true and
> CONFIG_CGROUPS=n would miss the "if (*iter) return NULL;" condition.
> Effectively with CONFIG_CGROUPS=n this becomes:
>
>        if (cgroup_psi_enabled()) {           <== assume this is true
> #ifdef CONFIG_CGROUPS                <== compiled out
> #endif
>        } else {
>                if (*iter)                                  <== this
> statement will never execute
>                        return NULL;
>        }
>        *iter = &psi_system;
>         return &psi_system;
>

Ah, sorry. I forgot that CONFIG_CGROUPS=n would force
cgroup_psi_enabled()==false (the way function is defined in cgroup.h),
so (CONFIG_CGROUPS=n && cgroup_psi_enabled()==true) is an invalid
configuration. I think adding a comment to your suggestion would make
it more clear.
So your suggestion seems to work. I'll test it and include it in the
next revision. Thanks!


> >
> > --
> > To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe-z5hGa2qSFaTowKkBSvOlow@public.gmane.org
> >
