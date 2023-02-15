From: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] sched/psi: iterate through cgroups directly
Date: Thu, 16 Feb 2023 01:49:22 +0800
Message-ID: <CAMgjq7CKG_pNxm5ofciK-aBKwGuRCiyWPm1BXhjmcg=N0bfFcg@mail.gmail.com>
References: <20230208161654.99556-1-ryncsn@gmail.com> <20230208161654.99556-3-ryncsn@gmail.com>
 <20230208172956.GF24523@blackbody.suse.cz> <Y+P17OVZZWVpYIb0@cmpxchg.org> <CAMgjq7Bem+8g8A_OR26PHhYYx-A7LHHO3tyQNR_tMnaaKNxkug@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NyGYVMaZ8vym5t9MdFQCIrY2IHROAIwSOISQjEfCwxo=;
        b=YNyD754CRXfmTDAUV3IZLfoR/2KiTIE3gmA3PyX6HnyHAwQzzzEmRuZsGNnGanwfcD
         c8d7jUgm1LBM+4SVlH3OzFtO/VzSFCt/Q17mUUwRcULTyJLJih+jORayIgghgK/WSylD
         Wd4giTAmuiK0G2xRKXMeBbdtVxmMcwmJHocFU3BIfEiW9dlmBA6zavXtON+kyEPR1AmF
         PxmW/PB6OOTRrqWDst7srWXplM6cnk3CgUtuIbCMj7ssPGptIT3DvcaAOrpQE9USN3sg
         /+dfZRyM/n8+g5EFYZqtVWg0ec9B1w+aPJwspwIAZZEa6P52r3ONyU1cZBu3yjIIcpY0
         l6Kw==
In-Reply-To: <CAMgjq7Bem+8g8A_OR26PHhYYx-A7LHHO3tyQNR_tMnaaKNxkug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =E4=BA=8E2023=E5=B9=B42=E6=9C=8810=E6=97=A5=
=E5=91=A8=E4=BA=94 00:08=E5=86=99=E9=81=93=EF=BC=9A
> Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> =E4=BA=8E2023=E5=B9=B42=E6=9C=889=E6=
=97=A5=E5=91=A8=E5=9B=9B 03:20=E5=86=99=E9=81=93=EF=BC=9A
> > On Wed, Feb 08, 2023 at 06:29:56PM +0100, Michal Koutn=C3=BD wrote:
> > > On Thu, Feb 09, 2023 at 12:16:54AM +0800, Kairui Song <ryncsn@gmail.c=
om> wrote:
> > > > Signed-off-by: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> > > > Signed-off-by: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > >
> > > Typo?
> > >
> > > > -static inline struct psi_group *task_psi_group(struct task_struct =
*task)
> > > > +static inline struct psi_group *psi_iter_first(struct task_struct =
*task, void **iter)
> > > >  {
> > > >  #ifdef CONFIG_CGROUPS
> > > > -   if (static_branch_likely(&psi_cgroups_enabled))
> > > > -           return cgroup_psi(task_dfl_cgroup(task));
> > > > +   if (static_branch_likely(&psi_cgroups_enabled)) {
> > > > +           struct cgroup *cgroup =3D task_dfl_cgroup(task);
> > > > +
> > > > +           *iter =3D cgroup_parent(cgroup);
> > >
> > > This seems to skip a cgroup level -- maybe that's the observed
> > > performance gain?
> >
> > Hm, I don't think it does. It sets up *iter to point to the parent for
> > the _next() call, but it returns task_dfl_cgroup()->psi. The next call
> > does the same: cgroup =3D *iter, *iter =3D parent, return cgroup->psi.
> >
> > It could be a bit more readable to have *iter always point to the
> > current cgroup - but no strong preference either way from me:
> >
> > psi_groups_first(task, iter)
> > {
> > #ifdef CONFIG_CGROUPS
> >         if (static_branch_likely(&psi_cgroups_enabled)) {
> >                 struct cgroup *cgroup =3D task_dfl_cgroup(task);
> >
> >                 *iter =3D cgroup;
> >                 return cgroup_psi(cgroup);
> >         }
> > #endif
> >         return &psi_system;
> > }
> >
> > psi_groups_next(iter)
> > {
> > #ifdef CONFIG_CGROUPS
> >         if (static_branch_likely(&psi_cgroups_enabled)) {
> >                 struct cgroup *cgroup =3D *iter;
> >
> >                 if (cgroup) {
> >                         *iter =3D cgroup_parent(cgroup);
> >                         return cgroup_psi(cgroup);
> >                 }
> >         }
> >         return NULL;
> > #endif
> > }
> > psi_groups_next(iter)
> > {
> > #ifdef CONFIG_CGROUPS
> >         if (static_branch_likely(&psi_cgroups_enabled)) {
> >                 struct cgroup *cgroup =3D *iter;
> >
> >                 if (cgroup) {
> >                         *iter =3D cgroup_parent(cgroup);
> >                         return cgroup_psi(cgroup);
> >                 }
> >         }
> >         return NULL;
> > #endif
> > }
>
> It should be like this, right? For psi_groups_next, retrieving cgroup
> parent should be done before "if (cgroup)".
> + psi_groups_next(iter)
> + {
> + #ifdef CONFIG_CGROUPS
> +         if (static_branch_likely(&psi_cgroups_enabled)) {
> +                 struct cgroup *cgroup =3D *iter;
> +
> +                 cgroup =3D cgroup_parent(cgroup);
> +                 if (cgroup) {
> +                         *iter =3D cgroup;
> +                         return cgroup_psi(cgroup);
> +                 }
> +         }
> +         return NULL;
> + #endif
> + }
>
> Thanks for the suggestion!
>
> I think your style is better indeed.
>
> I tried to re-benchmark the code just in case, and found it seems my
> previous benchmark result is not accurate enough now, some results
> changed after I did a rebase to latest master, or maybe just 100 times
> of perfpipe is not enough to get a stable result.
>
> With a few times of retest, the final conclusion of the commit message
> is still valid, will post V2 later just after more test.

Hi, I just ran perf bench test for a few days on a machine to get an
stable average for latest rebased patch.
And found it is indeed faster when the cgroup hierarchy is not too deep:

With rootcg:
55718.9 op/s (unpatched) compared to 55862.2 (patched)
With 5 levels:
49975.5 op/s (unpatched) compared to 50778.5 op/s (patched)

Previous tests are a bit biased since I only run the test for 100 * 3
times, or maybe it is sensitive to some random kernel structure
changes.

But I ignored one important thing in my previous test, that the
performance actually drops heavily with deeper levers of cgroups:
With 8 levels:
48902.4 op/s (unpatched) compared to 47476.6 op/s (patched)
With 50 levels of cgroup:
25605.7375 op/s (unpatched) compared to 20417.275 op/s (patched)

That's a terrible regression :( , guess when there are too many cgroup
structures, CPU cache can't hold them, and since the *parent shares
same cacheline with rest of psi_group struct (like the bool enblaed,
which are access every time), so unpatched will be faster.

Sorry for missing such a critical point in v1, let's drop this series
until there is a better way to optimize it.
