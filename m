From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 16/17] cgroup/drm: Expose memory stats
Date: Wed, 26 Jul 2023 09:44:44 -1000
Message-ID: <ZMF3rLioJK9QJ0yj@slm.duckdns.org>
References: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
 <20230712114605.519432-17-tvrtko.ursulin@linux.intel.com>
 <ZLsFBHqCQdPHoZVw@slm.duckdns.org>
 <ea64d7bf-c01b-f4ad-a36b-f77e2c2ea931@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690400686; x=1691005486;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VIQUF5pxDq7OaH/cq+/yDjYiLBedFBP8ulSYElZmLwU=;
        b=lABXBtPFwn3FCtQv5Cb3csSuJ2Td+KIqkY5ygJK0lT+9ay/TSKzRV3T/qdi98zeoJe
         oirsG2ATytq9UM5BIwjUrJMCjNvs/M8LRIKHCmOWwOA5XgTn6g/wTI9hbwmoN5jBAyeR
         r+c0pgllRpNRDT39CCHZcjyopLj5wXSO4zaJMbVwNJGLOp1Mrm0vWbBj9kIfL+80Q3/Y
         y4VZiF1TKsaNGhoxjq1SQuk+3lm4Cf73LWjQlG1jt2Ece5jOgByA80o/KGwosJv0zjw8
         AFI2VC6F+beS2/t3y7sKqyAUHeziG+oPhfCT7qB3RLIYWwVJ4q/rAVag/eFqSaSpAe9m
         tx2Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ea64d7bf-c01b-f4ad-a36b-f77e2c2ea931-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eero Tamminen <eero.t.tamminen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hello,

On Wed, Jul 26, 2023 at 12:14:24PM +0200, Maarten Lankhorst wrote:
> > So, yeah, if you want to add memory controls, we better think through how
> > the fd ownership migration should work.
>
> I've taken a look at the series, since I have been working on cgroup memory
> eviction.
> 
> The scheduling stuff will work for i915, since it has a purely software
> execlist scheduler, but I don't think it will work for GuC (firmware)
> scheduling or other drivers that use the generic drm scheduler.
> 
> For something like this,  you would probably want it to work inside the drm
> scheduler first. Presumably, this can be done by setting a weight on each
> runqueue, and perhaps adding a callback to update one for a running queue.
> Calculating the weights hierarchically might be fun..

I don't have any idea on this front. The basic idea of making high level
distribution decisions in core code and letting individual drivers enforce
that in a way which fits them the best makes sense to me but I don't know
enough to have an opinion here.

> I have taken a look at how the rest of cgroup controllers change ownership
> when moved to a different cgroup, and the answer was: not at all. If we

For persistent resources, that's the general rule. Whoever instantiates a
resource gets to own it until the resource gets freed. There is an exception
with the pid controller and there are discussions around whether we want
some sort of migration behavior with memcg but yes by and large instantiator
being the owner is the general model cgroup follows.

> attempt to create the scheduler controls only on the first time the fd is
> used, you could probably get rid of all the tracking.
> This can be done very easily with the drm scheduler.
>
> WRT memory, I think the consensus is to track system memory like normal
> memory. Stolen memory doesn't need to be tracked. It's kernel only memory,
> used for internal bookkeeping  only.
> 
> The only time userspace can directly manipulate stolen memory, is by mapping
> the pinned initial framebuffer to its own address space. The only allocation
> it can do is when a framebuffer is displayed, and framebuffer compression
> creates some stolen memory. Userspace is not
> aware of this though, and has no way to manipulate those contents.

So, my dumb understanding:

* Ownership of an fd can be established on the first ioctl call and doesn't
  need to be migrated afterwards. There are no persistent resources to
  migration on the first call.

* Memory then can be tracked in a similar way to memcg. Memory gets charged
  to the initial instantiator and doesn't need to be moved around
  afterwards. There may be some discrepancies around stolen memory but the
  magnitude of inaccuracy introduced that way is limited and bound and can
  be safely ignored.

Is that correct?

Thanks.

-- 
tejun
