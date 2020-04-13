From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 00/11] new cgroup controller for gpu/drm subsystem
Date: Mon, 13 Apr 2020 16:54:36 -0400
Message-ID: <20200413205436.GM60335@mtj.duckdns.org>
References: <20200226190152.16131-1-Kenny.Ho@amd.com>
 <CAOWid-eyMGZfOyfEQikwCmPnKxx6MnTm17pBvPeNpgKWi0xN-w@mail.gmail.com>
 <20200324184633.GH162390@mtj.duckdns.org>
 <CAOWid-cS-5YkFBLACotkZZCH0RSjHH94_r3VFH8vEPOubzSpPA@mail.gmail.com>
 <20200413191136.GI60335@mtj.duckdns.org>
 <CAOWid-dM=38faGOF9=-Pq=sxssaL+gm2umctyGVQWVx2etShyQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CmUANt0t5HRisX+1yPc7U3xIxP+RuSCBBQhcshkOJkc=;
        b=LgJ7itCwDGKAQT06oAw2BcDstgGiPHC+qPyVPTx9ybSe4VOwbRJeEOlzNb6BvxDnOS
         2XgnpPZo/PeMNgs33VZjEjjFJrCjGMLq/LDmBeEoVsKRa/gYhqhVzdX6VpfV5c1WsdDb
         Aj/WTeawW/z2ZzlbQH+vu4WT9XoEiCbO8uKImj8xGcjacv4TtRF4ScJAKY19KIYAgdVo
         PzASu8J/wr4PPFlUFA8LHZ5GbuMxFN4sTCClw8xS9AlN9OrB6/B2YVsSXV7ZmardGUYh
         klTTzpuooyIxMkIHHmp5P1OpDDxjTJ/JG4/ujOLdOK9dYQLDp7enbLCZJhkbgUDfWnOG
         ENYw==
Content-Disposition: inline
In-Reply-To: <CAOWid-dM=38faGOF9=-Pq=sxssaL+gm2umctyGVQWVx2etShyQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, "Kuehling, Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, "Greathouse, Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org, lkaplan-WVYJKLFxKCc@public.gmane.org

Hello,

On Mon, Apr 13, 2020 at 04:17:14PM -0400, Kenny Ho wrote:
> Perhaps we can even narrow things down to just
> gpu.weight/gpu.compute.weight as a start?  In this aspect, is the key

That sounds great to me.

> objection to the current implementation of gpu.compute.weight the
> work-conserving bit?  This work-conserving requirement is probably
> what I have missed for the last two years (and hence going in circle.)
> 
> If this is the case, can you clarify/confirm the followings?
> 
> 1) Is resource scheduling goal of cgroup purely for the purpose of
> throughput?  (at the expense of other scheduling goals such as
> latency.)

It's not; however, work-conserving mechanisms are the easiest to use (cuz you
don't lose anything) while usually challenging to implement. It tends to
clarify how control mechanisms should be structured - even what resources are.

> 2) If 1) is true, under what circumstances will the "Allocations"
> resource distribution model (as defined in the cgroup-v2) be
> acceptable?

Allocations definitely are acceptable and it's not a pre-requisite to have
work-conserving control first either. Here, given the lack of consensus in
terms of what even constitute resource units, I don't think it'd be a good
idea to commit to the proposed interface and believe it'd be beneficial to
work on interface-wise simpler work conserving controls.

> 3) If 1) is true, are things like cpuset from cgroup v1 no longer
> acceptable going forward?

Again, they're acceptable.

> To be clear, while some have framed this (time sharing vs spatial
> sharing) as a partisan issue, it is in fact a technical one.  I have
> implemented the gpu cgroup support this way because we have a class of
> users that value low latency/low jitter/predictability/synchronicity.
> For example, they would like 4 tasks to share a GPU and they would
> like the tasks to start and finish at the same time.
> 
> What is the rationale behind picking the Weight model over Allocations
> as the first acceptable implementation?  Can't we have both
> work-conserving and non-work-conserving ways of distributing GPU
> resources?  If we can, why not allow non-work-conserving
> implementation first, especially when we have users asking for such
> functionality?

I hope the rationales are clear now. What I'm objecting is inclusion of
premature interface, which is a lot easier and more tempting to do for
hardware-specific limits and the proposals up until now have been showing
ample signs of that. I don't think my position has changed much since the
beginning - do the difficult-to-implement but easy-to-use weights first and
then you and everyone would have a better idea of what hard-limit or
allocation interfaces and mechanisms should look like, or even whether they're
needed.

Thanks.

-- 
tejun
