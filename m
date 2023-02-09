From: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] sched/psi: iterate through cgroups directly
Date: Thu, 9 Feb 2023 23:32:03 +0800
Message-ID: <CAMgjq7AVQBfbr+zqrsGfJMkD-PeciEmOQMbwR4+FLpGQcdyAkw@mail.gmail.com>
References: <20230208161654.99556-1-ryncsn@gmail.com> <20230208161654.99556-3-ryncsn@gmail.com>
 <Y+P0wLTdZcOPiKPZ@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DTRyrjKJiUmJMr1cI3Ls247CRHoBTq6abpoHxw5vv6k=;
        b=CkkXpOB+B6zJbRDbAJUxxvNXz2R1GRxWWZnS6q3zol30Nc240hQpc34IKiClJBfagp
         BSR6lcvR3n6ykkf1+P5n/I/jyjNU0/R8erJhHHFLMFaBDEYSgzwPm1sUgVHhAtYNXjG9
         8ixK+PqOMEXtTnH1hNegzCIs6esp1s2iXlwV+g5OlB5ZtdTZ8PHLJvlkDVi6g/8QCg8/
         901+kt7wxw9q0A+tOYAiSnaU7ZWdUqFPN+svq4G3K+cdvf8rv/ScwMpKautirFgfteoO
         /SMzFfi5STvFVDfvORFnBcP8ToTSBVp1fFhB/c8+sqbmdVTpfg6U6zNMMKO5yiRe67GQ
         422w==
In-Reply-To: <Y+P0wLTdZcOPiKPZ-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> =E4=BA=8E2023=E5=B9=B42=E6=9C=889=E6=
=97=A5=E5=91=A8=E5=9B=9B 03:15=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Feb 09, 2023 at 12:16:54AM +0800, Kairui Song wrote:
> > From: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> >
> > psi_group->parent has the same hierarchy as the cgroup it's in.
> > So just iterate through cgroup instead.
> >
> > By adjusting the iteration logic, save some space in psi_group
> > struct, and the performance is actually better. I see a measurable
> > performance gain using mmtests/perfpipe:
> >
> > (AVG of 100 test, ops/sec, the higher the better)
> > KVM guest on a i7-9700:
> >         psi=3D0         root cgroup   5 levels of cgroup
> > Before: 59221         55352         47821
> > After:  60100         56036         50884
> >
> > KVM guest on a Ryzen 9 5900HX:
> >         psi=3D0         root cgroup   5 levels of cgroup
> > Before: 144566        138919        128888
> > After:  145812        139580        133514
> >
> > Signed-off-by: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> > Signed-off-by: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Awesome!
>
> A few comments below:
>
> > @@ -858,15 +858,34 @@ static void psi_group_change(struct psi_group *gr=
oup, int cpu,
> >               schedule_delayed_work(&group->avgs_work, PSI_FREQ);
> >  }
> >
> > -static inline struct psi_group *task_psi_group(struct task_struct *tas=
k)
> > +static inline struct psi_group *psi_iter_first(struct task_struct *tas=
k, void **iter)
>
> Please name these psi_groups_first() and psi_groups_next().
>
> >  #ifdef CONFIG_CGROUPS
> > -     if (static_branch_likely(&psi_cgroups_enabled))
> > -             return cgroup_psi(task_dfl_cgroup(task));
> > +     if (static_branch_likely(&psi_cgroups_enabled)) {
> > +             struct cgroup *cgroup =3D task_dfl_cgroup(task);
> > +
> > +             *iter =3D cgroup_parent(cgroup);
> > +             return cgroup_psi(cgroup);
> > +     }
> >  #endif
> >       return &psi_system;
> >  }
> >
> > +static inline struct psi_group *psi_iter_next(void **iter)
> > +{
> > +#ifdef CONFIG_CGROUPS
> > +     if (static_branch_likely(&psi_cgroups_enabled)) {
> > +             struct cgroup *cgroup =3D *iter;
> > +
> > +             if (cgroup) {
> > +                     *iter =3D cgroup_parent(cgroup);
> > +                     return cgroup_psi(cgroup);
> > +             }
> > +     }
> > +#endif
> > +     return NULL;
> > +}
>
> > @@ -886,6 +905,7 @@ void psi_task_change(struct task_struct *task, int =
clear, int set)
> >  {
> >       int cpu =3D task_cpu(task);
> >       struct psi_group *group;
> > +     void *iter;
> >       u64 now;
> >
> >       if (!task->pid)
> > @@ -895,16 +915,17 @@ void psi_task_change(struct task_struct *task, in=
t clear, int set)
> >
> >       now =3D cpu_clock(cpu);
> >
> > -     group =3D task_psi_group(task);
> > +     group =3D psi_iter_first(task, &iter);
> >       do {
> >               psi_group_change(group, cpu, clear, set, now, true);
> > -     } while ((group =3D group->parent));
> > +     } while ((group =3D psi_iter_next(&iter)));
> >  }
> >
> >  void psi_task_switch(struct task_struct *prev, struct task_struct *nex=
t,
> >                    bool sleep)
> >  {
> >       struct psi_group *group, *common =3D NULL;
> > +     void *iter;
> >       int cpu =3D task_cpu(prev);
> >       u64 now =3D cpu_clock(cpu);
>
> Please add @iter at the end to keep line length sorting.
>
> > @@ -915,7 +936,7 @@ void psi_task_switch(struct task_struct *prev, stru=
ct task_struct *next,
> >                * ancestors with @prev, those will already have @prev's
> >                * TSK_ONCPU bit set, and we can stop the iteration there=
.
> >                */
> > -             group =3D task_psi_group(next);
> > +             group =3D psi_iter_first(prev, &iter);
> >               do {
> >                       if (per_cpu_ptr(group->pcpu, cpu)->state_mask &
> >                           PSI_ONCPU) {
> > @@ -924,7 +945,7 @@ void psi_task_switch(struct task_struct *prev, stru=
ct task_struct *next,
> >                       }
> >
> >                       psi_group_change(group, cpu, 0, TSK_ONCPU, now, t=
rue);
> > -             } while ((group =3D group->parent));
> > +             } while ((group =3D psi_iter_next(&iter)));
> >       }
> >
> >       if (prev->pid) {
> > @@ -957,12 +978,12 @@ void psi_task_switch(struct task_struct *prev, st=
ruct task_struct *next,
> >
> >               psi_flags_change(prev, clear, set);
> >
> > -             group =3D task_psi_group(prev);
> > +             group =3D psi_iter_first(prev, &iter);
> >               do {
> >                       if (group =3D=3D common)
> >                               break;
> >                       psi_group_change(group, cpu, clear, set, now, wak=
e_clock);
> > -             } while ((group =3D group->parent));
> > +             } while ((group =3D psi_iter_next(&iter)));
> >
> >               /*
> >                * TSK_ONCPU is handled up to the common ancestor. If the=
re are
> > @@ -972,7 +993,7 @@ void psi_task_switch(struct task_struct *prev, stru=
ct task_struct *next,
> >                */
> >               if ((prev->psi_flags ^ next->psi_flags) & ~TSK_ONCPU) {
> >                       clear &=3D ~TSK_ONCPU;
> > -                     for (; group; group =3D group->parent)
> > +                     for (; group; group =3D psi_iter_next(&iter))
> >                               psi_group_change(group, cpu, clear, set, =
now, wake_clock);
> >               }
> >       }
> > @@ -983,6 +1004,7 @@ void psi_account_irqtime(struct task_struct *task,=
 u32 delta)
> >  {
> >       int cpu =3D task_cpu(task);
> >       struct psi_group *group;
> > +     void *iter;
> >       struct psi_group_cpu *groupc;
> >       u64 now;
>
> Ditto. You can move @groupc in the same patch.
>
> Otherwise, this looks good to me. Please add:
>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Thanks! I'll update the patch as you suggested.
