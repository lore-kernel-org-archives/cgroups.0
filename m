From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Tue, 28 Apr 2020 10:24:32 -0400
Message-ID: <20200428142432.GA78561@cmpxchg.org>
References: <20200421142746.GA341682@cmpxchg.org>
 <20200421161138.GL27314@dhcp22.suse.cz>
 <20200421165601.GA345998@cmpxchg.org>
 <20200422132632.GG30312@dhcp22.suse.cz>
 <20200422141514.GA362484@cmpxchg.org>
 <20200422154318.GK30312@dhcp22.suse.cz>
 <20200422171328.GC362484@cmpxchg.org>
 <20200422184921.GB4206@dhcp22.suse.cz>
 <20200423150015.GE362484@cmpxchg.org>
 <20200424150510.GH11591@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I6AbEn76tF7ilFMynEexuwTbZLLuOZ/x0hiX+p73flg=;
        b=LwMQfy+rgLQKCygQ1YlP0dg9puBRV2xLN/oWrxUJiCVsPg1b5y6qQbvcZ0ti0N3m/N
         ZzJ4EBVhJdWgvp7VrlQuflDkFSQC8MhPc62QsPla+/ARGn6qu2cNGOoK8gJ0JSDfyTsC
         pEMUG6uhNf4TASDhGJWecX9ieWDJl6kY5lvRabRN7EvJC7/dLSZFUsqHBj1cTyGXATUO
         ma1gGPo7a4bqHUpNYsnjXCFZGC8nhtBG0+LljCvquyTMldykhz2rAurU1r1hq8uNJZn8
         gVYl3M2MXnybJXdXE7/QlG4HtzNR060TfEM/KgeaBZGca+REGSPAtXt34DfEFNR8Slay
         US7g==
Content-Disposition: inline
In-Reply-To: <20200424150510.GH11591-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Apr 24, 2020 at 05:05:10PM +0200, Michal Hocko wrote:
> On Thu 23-04-20 11:00:15, Johannes Weiner wrote:
> > On Wed, Apr 22, 2020 at 08:49:21PM +0200, Michal Hocko wrote:
> > > On Wed 22-04-20 13:13:28, Johannes Weiner wrote:
> > > > On Wed, Apr 22, 2020 at 05:43:18PM +0200, Michal Hocko wrote:
> > > > > On Wed 22-04-20 10:15:14, Johannes Weiner wrote:
> > > > > I am also missing some information about what the user can actually do
> > > > > about this situation and call out explicitly that the throttling is
> > > > > not going away until the swap usage is shrunk and the kernel is not
> > > > > capable of doing that on its own without a help from the userspace. This
> > > > > is really different from memory.high which has means to deal with the
> > > > > excess and shrink it down in most cases. The following would clarify it
> > > > 
> > > > I think we may be talking past each other. The user can do the same
> > > > thing as in any OOM situation: wait for the kill.
> > > 
> > > That assumes that reaching swap.high is going to converge to the OOM
> > > eventually. And that is far from the general case. There might be a
> > > lot of other reclaimable memory to reclaim and stay in the current
> > > state.
> > 
> > No, that's really the general case. And that's based on what users
> > widely experience, including us at FB. When swap is full, it's over.
> > Multiple parties have independently reached this conclusion.
> 
> But we are talking about two things. You seem to be focusing on the full
> swap (quota) while I am talking about swap.high which doesn't imply
> that the quota/full swap is going to be reached soon.

Hm, I'm not quite sure I understand. swap.high is supposed to set this
quota. It's supposed to say: the workload has now shown such an
appetite for swap that it's unlikely to survive for much longer - draw
out its death just long enough for userspace OOM handling.

Maybe this is our misunderstanding?

It certainly doesn't make much sense to set swap.high to 0 or
relatively low values. Should we add the above to the doc text?

> > Once the workload expands its set of *used* pages past memory.high, we
> > are talking about indefinite slowdowns / OOM situations. Because at
> > that point, reclaim cannot push the workload back and everything will
> > be okay: the pages it takes off mean refaults and continued reclaim,
> > i.e. throttling. You get slowed down either way, and whether you
> > reclaim or sleep() is - to the workload - an accounting difference.
> >
> > Reclaim does NOT have the power to help the workload get better. It
> > can only do amputations to protect the rest of the system, but it
> > cannot reduce the number of pages the workload is trying to access.
> 
> Yes I do agree with you here and I believe this scenario wasn't really
> what the dispute is about. As soon as the real working set doesn't
> fit into the high limit and still growing then you are effectively
> OOM and either you do handle that from the userspace or you have to
> waaaaaaaaait for the kernel oom killer to trigger.
> 
> But I believe this scenario is much easier to understand because the
> memory consumption is growing. What I find largely unintuitive from the
> user POV is that the throttling will remain in place without a userspace
> intervention even when there is no runaway.
> 
> Let me give you an example. Say you have a peak load which pushes
> out a large part of an idle memory to swap. So much it fills up the
> swap.high. The peak eventually finishes freeing up its resources.  The
> swap situation remains the same because that memory is not refaulted and
> we do not pro-actively swap in memory (aka reclaim the swap space). You
> are left with throttling even though the overall memcg consumption is
> really low. Kernel is currently not able to do anything about that
> and the userspace would need to be aware of the situation to fault in
> swapped out memory back to get a normal behavior. Do you think this
> is something so obvious that people would keep it in mind when using
> swap.high?

Okay, thanks for clarifying, I understand your concern now.

This is not a scenario that swap.high is supposed to handle. It should
*not* be set to an amount of memory that the workload can reasonably
have sitting around idle. For example, if your memory allowance is
10G, it doesn't make sense to have swap.high at 200M or something.

It should be set to "we don't expect healthy workloads to get here".

And now I also understand what you mean by being different to
memory.high. memory.high is definitely *expected* to get hit because
of the cache trimming usecase. We just don't expect the *throttling*
part to get into play unless the workload is truly unhealthy. But I
can see how user expectations toward swap.high could be different.

> Anyway, it seems that we are not making progress here. As I've said I
> believe that swap.high might lead to a surprising behavior and therefore
> I would appreciate more clarity in the documentation. If you see a
> problem with that for some reason then I can live with that. This is not
> a reason to nack.

No, I agree we should document this. How about the following?

  memory.swap.high
       A read-write single value file which exists on non-root
       cgroups.  The default is "max".

       Swap usage throttle limit.  If a cgroup's swap usage exceeds
       this limit, all its further allocations will be throttled to
       allow userspace to implement custom out-of-memory procedures.

       This limit marks a point of no return for the cgroup. It is NOT
       designed to manage the amount of swapping a workload does
       during regular operation. Compare to memory.swap.max, which
       prohibits swapping past a set amount, but lets the cgroup
       continue unimpeded as long as other memory can be reclaimed.
