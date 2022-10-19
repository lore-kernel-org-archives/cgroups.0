From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 00/17] DRM scheduling cgroup controller
Date: Wed, 19 Oct 2022 08:45:34 -1000
Message-ID: <Y1BFziiJdBzsIJWH@slm.duckdns.org>
References: <20221019173254.3361334-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Shq/ANspULQpM+jmY/ItEvxo0c4euo/Y2Hzyv6LpqQk=;
        b=QvkbNwKv3uL21y9WnQdugb7J5FuBi/nHAZSSHsWuLdEs990fEmSOh9O7zHz869V4k1
         GgKjtfsLhykxTdurNKEH+B2NN1L+qDnACPis99Ozn25iJ48GhoREMe+Rbcj4fXl7OX9O
         R3RUwj2vdPpv61gmRM2FB3ybZpgIn5O+dkdkGidKGn9H9GT2E8L+Dy8JmlRAIVo0gOfx
         JcDhz7+KK+mfo/esXs3dUOBbXyWUWGMU3iDSh4od4UzwFbezsC4+fryQe+ja9oqktBpM
         uJpVpzkWjZcbJWdniEVbFoVGicnafqLSfP0xrD/prDhO0duXJmrdD3uDWYUlsmetI1AW
         0zzA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221019173254.3361334-1-tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hello,

On Wed, Oct 19, 2022 at 06:32:37PM +0100, Tvrtko Ursulin wrote:
...
> DRM static priority interface files
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
>   drm.priority_levels
> 	One of:
> 	 1) And integer representing the minimum number of discrete priority
> 	    levels for the whole group.
> 	    Optionally followed by an asterisk ('*') indicating some DRM clients
> 	    in the group support more than the minimum number.
> 	 2) '0'- indicating one or more DRM clients in the group has no support
> 	    for static priority control.
> 	 3) 'n/a' - when there are no DRM clients in the configured group.
> 
>   drm.priority
> 	A read-write integer between -10000 and 10000 (inclusive) representing
> 	an abstract static priority level.
> 
>   drm.effective_priority
> 	Read only integer showing the current effective priority level for the
> 	group. Effective meaning taking into account the chain of inherited

From interface POV, this is a lot worse than the second proposal and I'd
really like to avoid this. Even if we go with mapping user priority
configuration to per-driver priorities, I'd much prefer if the interface
presented to user is weight based and let each driver try to match the
resulting hierarchical weight (ie. the absolute proportion a given cgroup
should have at the point in time) as best as they can rather than exposing
opaque priority numbers to userspace whose meaning isn't defined at all.

> DRM scheduling soft limits interface files
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
>   drm.weight
> 	Standard cgroup weight based control [1, 10000] used to configure the
> 	relative distributing of GPU time between the sibling groups.

Please take a look at io.weight. This can follow the same convention to
express both global and per-device weights.

>   drm.period_us
> 	An integer representing the period with which the controller should look
> 	at the GPU usage by the group and potentially send the over/under budget
> 	signal.
> 	Value of zero (defaul) disables the soft limit checking.

Can we not do period_us or at least make it a per-driver tuning parameter
exposed as module param? Weight, users can easily understand and configure.
period_us is a lot more an implementation detail. If we want to express the
trade-off between latency and bandwidth at the interface, we prolly should
encode the latency requirement in a more canonical way but let's leave that
for the future.

>   drm.budget_supported
> 	One of:
> 	 1) 'yes' - when all DRM clients in the group support the functionality.
> 	 2) 'no' - when at least one of the DRM clients does not support the
> 		   functionality.
> 	 3) 'n/a' - when there are no DRM clients in the group.

Yeah, I'm not sure about this. This isn't a per-cgroup property to begin
with and I'm not sure 'no' meaning at least one device not supporting is
intuitive. The distinction between 'no' and 'n/a' is kinda weird too. Please
drop this.

Another basic interface question. Is everyone happy with the drm prefix or
should it be something like gpu? Also, in the future, if there's a consensus
around how to control gpu memory, what prefix would that take?

> The second proposal is a little bit more advanced in concept and also a little
> bit less finished. Interesting thing is that it builds upon the per client GPU
> utilisation work which landed recently for a few drivers. So my thinking is that
> in principle, an intersect of drivers which support both that and some sort of
> priority scheduling control, could also in theory support this.
> 
> Another really interesting angle for this controller is that it mimics the same
> control menthod used by the CPU scheduler. That is the proportional/weight based
> GPU time budgeting. Which makes it easy to configure and does not need a new
> mental model.
> 
> However, as the introduction mentions, GPUs are much more heterogenous and
> therefore the controller uses very "soft" wording as to what it promises. The
> general statement is that it can define budgets, notify clients when they are
> over them, and let individual drivers implement best effort handling of those
> conditions.
> 
> Delegation of duties in the implementation goes likes this:
> 
>  * DRM cgroup controller implements the control files and the scanning loop.
>  * DRM core is required to track all DRM clients belonging to processes so it
>    can answer when asked how much GPU time is a process using.
>  * DRM core also provides a call back which the controller will call when a
>    certain process is over budget.
>  * Individual drivers need to implement two similar hooks, but which work for
>    a single DRM client. Over budget callback and GPU utilisation query.
> 
> What I have demonstrated in practice is that when wired to i915, in a really
> primitive way where the over-budget condition simply lowers the scheduling
> priority, the concept can be almost equally effective as the static priority
> control. I say almost because the design where budget control depends on the
> periodic usage scanning has a fundamental delay, so responsiveness will depend
> on the scanning period, which may or may not be a problem for a particular use
> case.
> 
> The unfinished part is the GPU budgeting split which currently does not
> propagate unused bandwith to children, neither can share it with siblings. But
> this is not due fundamental reasons, just to avoid spending too much time on it
> too early.

Rather than doing it hierarchically on the spot, it's usually a lot cheaper
and easier to calculate the flattened hierarchical weight per leaf cgroup
and divide the bandwidth according to the eventual portions. For an example,
please take a look at block/blk-iocost.c.

I don't know much about the drm driver side, so can't comment much on it but
I do really like the idea of having the core implementation determining who
should get how much and then letting each driver enforce the target. That
seems a lot more robust and generic than trying to somehow coax and expose
per-driver priority implementations directly.

Thanks.

-- 
tejun
