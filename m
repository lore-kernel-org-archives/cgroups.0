From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] mm: memcontrol: deprecate swapaccounting=0 mode
Date: Fri, 19 Mar 2021 11:20:26 -0700
Message-ID: <CALvZod7gFUcZW0meF8kHUk3rizkUrrQW5knFKX_Rcb1g_dnW+Q@mail.gmail.com>
References: <20210319054944.50048-1-hannes@cmpxchg.org> <20210319054944.50048-2-hannes@cmpxchg.org>
 <CALvZod6HYfoSnBoq7JGW1ifLmLMmwSAyCqjh+bJ6L9evAPVGLQ@mail.gmail.com> <YFThD2qnSCx5MJEh@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tz1A3bSsj9rkyv4dGud826X0c/D6fAibU1rcdURNzxA=;
        b=e2CW/V/+A9LjGE8tySVsj6k7xbzbHKqLyuKGKMK14Suap+1kHtnu0Twb29yzjixeCR
         85VI6Nz3sh840fxOdohZP6w7DS0gzzeCTGkigI2SWWKv/bidA3QlMY86meg/eNVLQQqD
         CPNEfQkn+yHZ17r5meKdKTJoEJ5Y6uAqGklYv0e0b12pBI0KrVkyLNI2ovG9LxbRn4d5
         9R5rMzUfzFAacvaYyrdjTyMgng185K5kKsbNOJnG3au2hZjCuMvBJmeJI5mvEsY2tWDb
         lscjrFmxER3OOEuixRLQxKZ1cRz5Y060Z1wJmfXryCJUKF9b+ujDQhqsAVdBcprNsTIG
         k/YA==
In-Reply-To: <YFThD2qnSCx5MJEh-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Fri, Mar 19, 2021 at 10:36 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Fri, Mar 19, 2021 at 06:49:55AM -0700, Shakeel Butt wrote:
> > On Thu, Mar 18, 2021 at 10:49 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > >
> > > The swapaccounting= commandline option already does very little
> > > today. To close a trivial containment failure case, the swap ownership
> > > tracking part of the swap controller has recently become mandatory
> > > (see commit 2d1c498072de ("mm: memcontrol: make swap tracking an
> > > integral part of memory control") for details), which makes up the
> > > majority of the work during swapout, swapin, and the swap slot map.
> > >
> > > The only thing left under this flag is the page_counter operations and
> > > the visibility of the swap control files in the first place, which are
> > > rather meager savings. There also aren't many scenarios, if any, where
> > > controlling the memory of a cgroup while allowing it unlimited access
> > > to a global swap space is a workable resource isolation stragegy.
> >
> > *strategy
>
> Will fix :)
>
> > > On the other hand, there have been several bugs and confusion around
> > > the many possible swap controller states (cgroup1 vs cgroup2 behavior,
> > > memory accounting without swap accounting, memcg runtime disabled).
> > >
> > > This puts the maintenance overhead of retaining the toggle above its
> > > practical benefits. Deprecate it.
> > >
> > > Suggested-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > [...]
> > >
> > >  static int __init setup_swap_account(char *s)
> > >  {
> > > -       if (!strcmp(s, "1"))
> > > -               cgroup_memory_noswap = false;
> > > -       else if (!strcmp(s, "0"))
> > > -               cgroup_memory_noswap = true;
> > > -       return 1;
> > > +       pr_warn_once("The swapaccount= commandline option is deprecated. "
> > > +                    "Please report your usecase to linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org if you "
> > > +                    "depend on this functionality.\n");
> > > +       return 0;
> >
> > What's the difference between returning 0 or 1 here?
>
> It signals whether the parameter is "recognized" by the kernel as a
> valid thing to pass, or whether it's unknown. If it's unknown, it'll
> be passed on to the init system (which ignores it), so this resembles
> the behavior we'll have when we remove the __setup in the future.
>
> If somebody can make an argument why we should go with one over the
> other, I'll happily go with that.
>
> > >  __setup("swapaccount=", setup_swap_account);
> > >
> > > @@ -7291,27 +7287,13 @@ static struct cftype memsw_files[] = {
> > >         { },    /* terminate */
> > >  };
> > >
> > > -/*
> > > - * If mem_cgroup_swap_init() is implemented as a subsys_initcall()
> > > - * instead of a core_initcall(), this could mean cgroup_memory_noswap still
> > > - * remains set to false even when memcg is disabled via "cgroup_disable=memory"
> > > - * boot parameter. This may result in premature OOPS inside
> > > - * mem_cgroup_get_nr_swap_pages() function in corner cases.
> > > - */
> > >  static int __init mem_cgroup_swap_init(void)
> > >  {
> > > -       /* No memory control -> no swap control */
> > > -       if (mem_cgroup_disabled())
> > > -               cgroup_memory_noswap = true;
> > > -
> > > -       if (cgroup_memory_noswap)
> > > -               return 0;
> > > -
> >
> > Do we need a mem_cgroup_disabled() check here?
>
> cgroup_add_cftypes() implies this check from the cgroup side and will
> just do nothing and return success. So we don't need it now.
>
> But it is something we'd have to remember to add if we do add more
> code to this function later on.
>
> Either way works for me. I can add it if people think it's better.
>

I am fine with either way. For this patch:

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
