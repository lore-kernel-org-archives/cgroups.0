From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Wed, 22 Apr 2020 20:49:21 +0200
Message-ID: <20200422184921.GB4206@dhcp22.suse.cz>
References: <20200420170318.GV27314@dhcp22.suse.cz>
 <20200420170650.GA169746@mtj.thefacebook.com>
 <20200421110612.GD27314@dhcp22.suse.cz>
 <20200421142746.GA341682@cmpxchg.org>
 <20200421161138.GL27314@dhcp22.suse.cz>
 <20200421165601.GA345998@cmpxchg.org>
 <20200422132632.GG30312@dhcp22.suse.cz>
 <20200422141514.GA362484@cmpxchg.org>
 <20200422154318.GK30312@dhcp22.suse.cz>
 <20200422171328.GC362484@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200422171328.GC362484-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed 22-04-20 13:13:28, Johannes Weiner wrote:
> On Wed, Apr 22, 2020 at 05:43:18PM +0200, Michal Hocko wrote:
> > On Wed 22-04-20 10:15:14, Johannes Weiner wrote:
[...]
> > > +	Swap usage throttle limit.  If a cgroup's swap usage exceeds
> > > +	this limit, allocations inside the cgroup will be throttled.
> > 
> > Hm, so this doesn't talk about which allocatios are affected. This is
> > good for potential future changes but I am not sure this is useful to
> > make any educated guess about the actual effects. One could expect that
> > only those allocations which could contribute to future memory.swap
> > usage. I fully realize that we do not want to be very specific but we
> > want to provide something useful I believe. I am sorry but I do not have
> > a good suggestion on how to make this better. Mostly because I still
> > struggle on how this should behave to be sane.
> 
> I honestly don't really follow you here. Why is it not helpful to say
> all allocations will slow down when condition X is met?

This might be just me and I definitely do not want to pick on words here
but your wording was not specific on which allocations. You can very
well interpret that as really all allocations but I wouldn't be surprised
if some would interpret it in a way that the kernel doesn't throttle
unnecessarily and if allocations cannot really contribute to more swap
then why should they be throttled.

> We do the same for memory.high.
>
> > I am also missing some information about what the user can actually do
> > about this situation and call out explicitly that the throttling is
> > not going away until the swap usage is shrunk and the kernel is not
> > capable of doing that on its own without a help from the userspace. This
> > is really different from memory.high which has means to deal with the
> > excess and shrink it down in most cases. The following would clarify it
> 
> I think we may be talking past each other. The user can do the same
> thing as in any OOM situation: wait for the kill.

That assumes that reaching swap.high is going to converge to the OOM
eventually. And that is far from the general case. There might be a
lot of other reclaimable memory to reclaim and stay in the current
state.
 
[...]

> > for me
> > 	"Once the limit is exceeded it is expected that the userspace
> > 	 is going to act and either free up the swapped out space
> > 	 or tune the limit based on needs. The kernel itself is not
> > 	 able to do that on its own.
> > 	"
> 
> I mean, in rare cases, maybe userspace can do some loadshedding and be
> smart about it. But we certainly don't expect it to.

I really didn't mean to suggest any clever swap management.  All I
wanted so say and have documented is that users of swap.high should
be aware of the fact that kernel is not able to do much to reduce the
throttling. This is really different from memory.high where the kernel
pro-actively tries to keep the memory usage below the watermark.  So a
certain level of userspace cooperation is really needed unless you can
tolerate a workload to be throttled to the end of times.

So let me be clear here. This is a very tricky interface to use and the
more verbose we can be the better.
-- 
Michal Hocko
SUSE Labs
