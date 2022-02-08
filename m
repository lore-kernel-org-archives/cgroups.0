From: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 02/12] cgroup: rstat: Make cgroup_rstat_cpu_lock name readable
Date: Tue, 8 Feb 2022 15:51:43 -0800
Message-ID: <CAM9d7cgFHxiru+1_-1_nVvgwE0dHdKGR-QS6AAVdAo0Hf0-mLA@mail.gmail.com>
References: <20220208184208.79303-1-namhyung@kernel.org> <20220208184208.79303-3-namhyung@kernel.org>
 <YgK6k4TXnRbm02dh@slm.duckdns.org> <CAM9d7cgKLycpFuXq0VgC=ADtAipXtKdfRcDqvZwMrNBz7hXd7A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAM9d7cgKLycpFuXq0VgC=ADtAipXtKdfRcDqvZwMrNBz7hXd7A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Byungchul Park <byungchul.park-Hm3cg6mZ9cc@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Radoslaw Burny <rburny-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Paul E. McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Tue, Feb 8, 2022 at 11:16 AM Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hi Tejun,
>
> On Tue, Feb 8, 2022 at 10:46 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Tue, Feb 08, 2022 at 10:41:58AM -0800, Namhyung Kim wrote:
> > > The raw_spin_lock_init() uses the argument to name its lockdep map.
> > > But passing per_cpu_ptr() macro directly makes it a very very long
> > > name as it expanded like below:
> > >
> > >   ({ do { const void *__vpp_verify = (typeof((&cgroup_rstat_cpu_lock) ...
> > >
> > > Let's fix it by passing a local variable instead.  With this change,
> > > the name now looks like:
> > >
> > >   cgrp_rstat_cpu_lock
> > >
> > > Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > > Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > > Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Signed-off-by: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >
> > Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Thanks!
>
> >
> > but maybe add a comment explaining what's going on?
>
> Sure, I'll add the comment.

Actually it depends on CONFIG_DEBUG_SPINLOCK.
If it's enabled, the name looks fine.  But if not, the macro
expansion would happen and generate the long name.

Thanks,
Namhyung
