From: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] sched/psi: iterate through cgroups directly
Date: Fri, 10 Feb 2023 00:08:40 +0800
Message-ID: <CAMgjq7Bem+8g8A_OR26PHhYYx-A7LHHO3tyQNR_tMnaaKNxkug@mail.gmail.com>
References: <20230208161654.99556-1-ryncsn@gmail.com> <20230208161654.99556-3-ryncsn@gmail.com>
 <20230208172956.GF24523@blackbody.suse.cz> <Y+P17OVZZWVpYIb0@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZWmpAN7z+mnIIM1VS6ygj9xj2/3VBtdPQMRi1uNDD0=;
        b=IxGLmL0/yJ2qV/iwG4f069e7/09g6UC26Xw5OIymQepANRtD29sTgbDiRe7d36F7R7
         jUywBAcvanvgJmhJrtfUskpENyPLxm3nVY3HxCUO6uS5EK6Ie89bctANX4HvaHLHS8MW
         5ZPD1rP9Q5vl/Y4+B6yo6ArXQp9RpvWSwh1vBpIvs7uVD21eOWhZPLEHcuJcBTKd1rE1
         O4Vmi+OItjh/5qnPZcVqZtwvq9J7L18CCc7FthYdoTBkv8ewHUVHSPn74wRA6fW5pOEE
         TH24O7smcRvp2NtYoFnvFNdhFWyPklRnGXVIXijQg8SuRYGIpQCcVTHcUYbxcDQ1HXFF
         TnAw==
In-Reply-To: <Y+P17OVZZWVpYIb0-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> =E4=BA=8E2023=E5=B9=B42=E6=9C=889=E6=
=97=A5=E5=91=A8=E5=9B=9B 03:20=E5=86=99=E9=81=93=EF=BC=9A
> On Wed, Feb 08, 2023 at 06:29:56PM +0100, Michal Koutn=C3=BD wrote:
> > On Thu, Feb 09, 2023 at 12:16:54AM +0800, Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
> wrote:
> > > Signed-off-by: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> > > Signed-off-by: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >
> > Typo?
> >
> > > -static inline struct psi_group *task_psi_group(struct task_struct *t=
ask)
> > > +static inline struct psi_group *psi_iter_first(struct task_struct *t=
ask, void **iter)
> > >  {
> > >  #ifdef CONFIG_CGROUPS
> > > -   if (static_branch_likely(&psi_cgroups_enabled))
> > > -           return cgroup_psi(task_dfl_cgroup(task));
> > > +   if (static_branch_likely(&psi_cgroups_enabled)) {
> > > +           struct cgroup *cgroup =3D task_dfl_cgroup(task);
> > > +
> > > +           *iter =3D cgroup_parent(cgroup);
> >
> > This seems to skip a cgroup level -- maybe that's the observed
> > performance gain?
>
> Hm, I don't think it does. It sets up *iter to point to the parent for
> the _next() call, but it returns task_dfl_cgroup()->psi. The next call
> does the same: cgroup =3D *iter, *iter =3D parent, return cgroup->psi.
>
> It could be a bit more readable to have *iter always point to the
> current cgroup - but no strong preference either way from me:
>
> psi_groups_first(task, iter)
> {
> #ifdef CONFIG_CGROUPS
>         if (static_branch_likely(&psi_cgroups_enabled)) {
>                 struct cgroup *cgroup =3D task_dfl_cgroup(task);
>
>                 *iter =3D cgroup;
>                 return cgroup_psi(cgroup);
>         }
> #endif
>         return &psi_system;
> }
>
> psi_groups_next(iter)
> {
> #ifdef CONFIG_CGROUPS
>         if (static_branch_likely(&psi_cgroups_enabled)) {
>                 struct cgroup *cgroup =3D *iter;
>
>                 if (cgroup) {
>                         *iter =3D cgroup_parent(cgroup);
>                         return cgroup_psi(cgroup);
>                 }
>         }
>         return NULL;
> #endif
> }
> psi_groups_next(iter)
> {
> #ifdef CONFIG_CGROUPS
>         if (static_branch_likely(&psi_cgroups_enabled)) {
>                 struct cgroup *cgroup =3D *iter;
>
>                 if (cgroup) {
>                         *iter =3D cgroup_parent(cgroup);
>                         return cgroup_psi(cgroup);
>                 }
>         }
>         return NULL;
> #endif
> }

It should be like this, right? For psi_groups_next, retrieving cgroup
parent should be done before "if (cgroup)".
+ psi_groups_next(iter)
+ {
+ #ifdef CONFIG_CGROUPS
+         if (static_branch_likely(&psi_cgroups_enabled)) {
+                 struct cgroup *cgroup =3D *iter;
+
+                 cgroup =3D cgroup_parent(cgroup);
+                 if (cgroup) {
+                         *iter =3D cgroup;
+                         return cgroup_psi(cgroup);
+                 }
+         }
+         return NULL;
+ #endif
+ }

Thanks for the suggestion!

I think your style is better indeed.

I tried to re-benchmark the code just in case, and found it seems my
previous benchmark result is not accurate enough now, some results
changed after I did a rebase to latest master, or maybe just 100 times
of perfpipe is not enough to get a stable result.

With a few times of retest, the final conclusion of the commit message
is still valid, will post V2 later just after more test.
