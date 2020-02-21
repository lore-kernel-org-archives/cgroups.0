From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Fri, 21 Feb 2020 11:11:47 +0100
Message-ID: <20200221101147.GO20509@dhcp22.suse.cz>
References: <20200213154731.GE31689@dhcp22.suse.cz>
 <20200213155249.GI88887@mtj.thefacebook.com>
 <20200213163636.GH31689@dhcp22.suse.cz>
 <20200213165711.GJ88887@mtj.thefacebook.com>
 <20200214071537.GL31689@dhcp22.suse.cz>
 <20200214135728.GK88887@mtj.thefacebook.com>
 <20200214151318.GC31689@dhcp22.suse.cz>
 <20200214165311.GA253674@cmpxchg.org>
 <20200217084100.GE31531@dhcp22.suse.cz>
 <20200218195253.GA13406@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200218195253.GA13406-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

[Sorry I didn't get to this email thread sooner]

On Tue 18-02-20 14:52:53, Johannes Weiner wrote:
> On Mon, Feb 17, 2020 at 09:41:00AM +0100, Michal Hocko wrote:
> > On Fri 14-02-20 11:53:11, Johannes Weiner wrote:
> > [...]
> > > The proper solution to implement the kind of resource hierarchy you
> > > want to express in cgroup2 is to reflect it in the cgroup tree. Yes,
> > > the_workload might have been started by user 100 in session c2, but in
> > > terms of resources, it's prioritized over system.slice and user.slice,
> > > and so that's the level where it needs to sit:
> > > 
> > >                                root
> > >                        /        |                 \
> > >                system.slice  user.slice       the_workload
> > >                /    |           |
> > >            cron  journal     user-100.slice
> > >                                 |
> > >                              session-c2.scope
> > >                                 |
> > >                              misc
> > > 
> > > Then you can configure not just memory.low, but also a proper io
> > > weight and a cpu weight. And the tree correctly reflects where the
> > > workload is in the pecking order of who gets access to resources.
> > 
> > I have already mentioned that this would be the only solution when the
> > protection would work, right. But I am also saying that this a trivial
> > example where you simply _can_ move your workload to the 1st level. What
> > about those that need to reflect organization into the hierarchy. Please
> > have a look at http://lkml.kernel.org/r/20200214075916.GM31689-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org
> > Are you saying they are just not supported? Are they supposed to use
> > cgroup v1 for the organization and v2 for the resource control?
> 
> >From that email:
> 
>     > Let me give you an example. Say you have a DB workload which is the
>     > primary thing running on your system and which you want to protect from
>     > an unrelated activity (backups, frontends, etc). Running it inside a
>     > cgroup with memory.low while other components in other cgroups without
>     > any protection achieves that. If those cgroups are top level then this
>     > is simple and straightforward configuration.
>     > 
>     > Things would get much more tricky if you want run the same workload
>     > deeper down the hierarchy - e.g. run it in a container. Now your
>     > "root" has to use an explicit low protection as well and all other
>     > potential cgroups that are in the same sub-hierarchy (read in the same
>     > container) need to opt-out from the protection because they are not
>     > meant to be protected.
> 
> You can't prioritize some parts of a cgroup higher than the outside of
> the cgroup, and other parts lower than the outside. That's just not
> something that can be sanely supported from the controller interface.

I am sorry but I do not follow. We do allow to opt out from the reclaim
protection with the current semantic and it seems to be reasonably sane.
I also have hard time to grasp what you actually mean by the above.
Let's say you have hiearchy where you split out low limit unevenly
              root (5G of memory)
             /    \
   (low 3G) A      D (low 1,5G)
           / \
 (low 1G) B   C (low 2G)

B gets lower priority than C and D while C gets higher priority than
D? Is there any problem with such a configuration from the semantic
point of view?

> However, that doesn't mean this usecase isn't supported. You *can*
> always split cgroups for separate resource policies.

What if the split up is not possible or impractical. Let's say you want
to control how much CPU share does your container workload get comparing
to other containers running on the system? Or let's say you want to
treat the whole container as a single entity from the OOM perspective
(this would be an example of the logical organization constrain) because
you do not want to leave any part of that workload lingering behind if
the global OOM kicks in. I am pretty sure there are many other reasons
to run related workload that doesn't really share the memory protection
demand under a shared cgroup hierarchy.
-- 
Michal Hocko
SUSE Labs
