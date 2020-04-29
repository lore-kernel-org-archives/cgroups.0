From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Wed, 29 Apr 2020 11:55:09 +0200
Message-ID: <20200429095509.GY28637@dhcp22.suse.cz>
References: <20200421161138.GL27314@dhcp22.suse.cz>
 <20200421165601.GA345998@cmpxchg.org>
 <20200422132632.GG30312@dhcp22.suse.cz>
 <20200422141514.GA362484@cmpxchg.org>
 <20200422154318.GK30312@dhcp22.suse.cz>
 <20200422171328.GC362484@cmpxchg.org>
 <20200422184921.GB4206@dhcp22.suse.cz>
 <20200423150015.GE362484@cmpxchg.org>
 <20200424150510.GH11591@dhcp22.suse.cz>
 <20200428142432.GA78561@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200428142432.GA78561-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue 28-04-20 10:24:32, Johannes Weiner wrote:
> On Fri, Apr 24, 2020 at 05:05:10PM +0200, Michal Hocko wrote:
> > On Thu 23-04-20 11:00:15, Johannes Weiner wrote:
> > > On Wed, Apr 22, 2020 at 08:49:21PM +0200, Michal Hocko wrote:
> > > > On Wed 22-04-20 13:13:28, Johannes Weiner wrote:
> > > > > On Wed, Apr 22, 2020 at 05:43:18PM +0200, Michal Hocko wrote:
> > > > > > On Wed 22-04-20 10:15:14, Johannes Weiner wrote:
> > > > > > I am also missing some information about what the user can actually do
> > > > > > about this situation and call out explicitly that the throttling is
> > > > > > not going away until the swap usage is shrunk and the kernel is not
> > > > > > capable of doing that on its own without a help from the userspace. This
> > > > > > is really different from memory.high which has means to deal with the
> > > > > > excess and shrink it down in most cases. The following would clarify it
> > > > > 
> > > > > I think we may be talking past each other. The user can do the same
> > > > > thing as in any OOM situation: wait for the kill.
> > > > 
> > > > That assumes that reaching swap.high is going to converge to the OOM
> > > > eventually. And that is far from the general case. There might be a
> > > > lot of other reclaimable memory to reclaim and stay in the current
> > > > state.
> > > 
> > > No, that's really the general case. And that's based on what users
> > > widely experience, including us at FB. When swap is full, it's over.
> > > Multiple parties have independently reached this conclusion.
> > 
> > But we are talking about two things. You seem to be focusing on the full
> > swap (quota) while I am talking about swap.high which doesn't imply
> > that the quota/full swap is going to be reached soon.
> 
> Hm, I'm not quite sure I understand. swap.high is supposed to set this
> quota. It's supposed to say: the workload has now shown such an
> appetite for swap that it's unlikely to survive for much longer - draw
> out its death just long enough for userspace OOM handling.
> 
> Maybe this is our misunderstanding?

Probably. We already have a quota for swap (swap.max). Workload is not
allowed to swap out when the quota is reached. swap.high is supposed to
act as a preliminary action towards slowing down swap consumption beyond
its limit.

> It certainly doesn't make much sense to set swap.high to 0 or
> relatively low values. Should we add the above to the doc text?
> 
> > > Once the workload expands its set of *used* pages past memory.high, we
> > > are talking about indefinite slowdowns / OOM situations. Because at
> > > that point, reclaim cannot push the workload back and everything will
> > > be okay: the pages it takes off mean refaults and continued reclaim,
> > > i.e. throttling. You get slowed down either way, and whether you
> > > reclaim or sleep() is - to the workload - an accounting difference.
> > >
> > > Reclaim does NOT have the power to help the workload get better. It
> > > can only do amputations to protect the rest of the system, but it
> > > cannot reduce the number of pages the workload is trying to access.
> > 
> > Yes I do agree with you here and I believe this scenario wasn't really
> > what the dispute is about. As soon as the real working set doesn't
> > fit into the high limit and still growing then you are effectively
> > OOM and either you do handle that from the userspace or you have to
> > waaaaaaaaait for the kernel oom killer to trigger.
> > 
> > But I believe this scenario is much easier to understand because the
> > memory consumption is growing. What I find largely unintuitive from the
> > user POV is that the throttling will remain in place without a userspace
> > intervention even when there is no runaway.
> > 
> > Let me give you an example. Say you have a peak load which pushes
> > out a large part of an idle memory to swap. So much it fills up the
> > swap.high. The peak eventually finishes freeing up its resources.  The
> > swap situation remains the same because that memory is not refaulted and
> > we do not pro-actively swap in memory (aka reclaim the swap space). You
> > are left with throttling even though the overall memcg consumption is
> > really low. Kernel is currently not able to do anything about that
> > and the userspace would need to be aware of the situation to fault in
> > swapped out memory back to get a normal behavior. Do you think this
> > is something so obvious that people would keep it in mind when using
> > swap.high?
> 
> Okay, thanks for clarifying, I understand your concern now.

Great that we are on the same page!

[...]

> No, I agree we should document this. How about the following?
> 
>   memory.swap.high
>        A read-write single value file which exists on non-root
>        cgroups.  The default is "max".
> 
>        Swap usage throttle limit.  If a cgroup's swap usage exceeds
>        this limit, all its further allocations will be throttled to
>        allow userspace to implement custom out-of-memory procedures.
> 
>        This limit marks a point of no return for the cgroup. It is NOT
>        designed to manage the amount of swapping a workload does
>        during regular operation. Compare to memory.swap.max, which
>        prohibits swapping past a set amount, but lets the cgroup
>        continue unimpeded as long as other memory can be reclaimed.

OK, this makes the intented use much more clear. I believe that it would
be helpful to also add your note that the value should be set to "we
don't expect healthy workloads to get here".

The usecase is quite narrow and I expect people will start asking about
something to help to manage the swap space somehow and this will not be
a good fit. This would require much more work to achieve a sane semantic
though. I am not aware of usacases at this moment so this is really hard
to argue about. I hope this will not backfire when we reach that point
though.

That being said, I am not a huge fan of the new interface but I can see
how it can be useful. I will not ack the patchset but I will not block
it either.

Thanks for refining the documentation and please make sure that
changelogs in the next version describe the intented usecase as
mentioned in this email thread.
-- 
Michal Hocko
SUSE Labs
