From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: asynchronous reclaim for memory.high
Date: Thu, 27 Feb 2020 07:50:11 -0500
Message-ID: <20200227125011.GB39625@cmpxchg.org>
References: <20200219181219.54356-1-hannes@cmpxchg.org>
 <CALvZod7fya+o8mO+qo=FXjk3WgNje=2P=sxM5StgdBoGNeXRMg@mail.gmail.com>
 <20200226222642.GB30206@cmpxchg.org>
 <2be6ac8d-e290-0a85-5cfa-084968a7fe36@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+/pCx60f/1X+9oiLWtdCr7slRVvciDKJGzX506kGhKA=;
        b=LwZJ5hvMkch1yo5ly172o7GJ3mfainNjJJKqHYsyqJ2MSPmvQnLSjknp31jnre3Ema
         1FUB9Tef3NCtRijJuv9eFIoeetxVNKLwMWAJBDQVp46vYR2nLb8T/5gzw6xZc3TWEzzo
         aDoDQV65wdYVhTygc0oRW+ctO9RbCHUwfFlxd8mbUxnldyd90iPPcsHHN9LEXURzD+Bd
         4A58qRoJNQrHoYHUxFysgDEityuGQQVtrnQt/dAaNpSvwaM6omm5Oyk7vd9jXJhW23jD
         2BKJgPA7rfl6RdxiivWiiA6tQiPXyQIoXHWk919tGT2rNBcQLL89YyEXXEhwilHkkHU0
         /U5A==
Content-Disposition: inline
In-Reply-To: <2be6ac8d-e290-0a85-5cfa-084968a7fe36-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Wed, Feb 26, 2020 at 04:12:23PM -0800, Yang Shi wrote:
> On 2/26/20 2:26 PM, Johannes Weiner wrote:
> > So we should be able to fully resolve this problem inside the kernel,
> > without going through userspace, by accounting CPU cycles used by the
> > background reclaim worker to the cgroup that is being reclaimed.
> 
> Actually I'm wondering if we really need account CPU cycles used by
> background reclaimer or not. For our usecase (this may be not general), the
> purpose of background reclaimer is to avoid latency sensitive workloads get
> into direct relcaim (avoid the stall from direct relcaim). In fact it just
> "steal" CPU cycles from lower priority or best-effort workloads to guarantee
> latency sensitive workloads behave well. If the "stolen" CPU cycles are
> accounted, it means the latency sensitive workloads would get throttled from
> somewhere else later, i.e. by CPU share.

That doesn't sound right.

"Not accounting" isn't an option. If we don't annotate the reclaim
work, the cycles will go to the root cgroup. That means that the
latency-sensitive workload can steal cycles from the low-pri job, yes,
but also that the low-pri job can steal from the high-pri one.

Say your two workloads on the system are a web server and a compile
job and the CPU shares are allocated 80:20. The compile job will cause
most of the reclaim. If the reclaim cycles can escape to the root
cgroup, the compile job will effectively consume more than 20 shares
and the low-pri job will get less than 80.

But let's say we executed all background reclaim in the low-pri group,
to allow the high-pri group to steal cycles from the low-pri group,
but not the other way round. Again an 80:20 CPU distribution. Now the
reclaim work competes with the compile job over a very small share of
CPU. The reclaim work that the high priority job is relying on is
running at low priority. That means that the compile job can cause the
web server to go into direct reclaim. That's a priority inversion.

> We definitely don't want to the background reclaimer eat all CPU cycles. So,
> the whole background reclaimer is opt in stuff. The higher level cluster
> management and administration components make sure the cgroups are setup
> correctly, i.e. enable for specific cgroups, setup watermark properly, etc.
> 
> Of course, this may be not universal and may be just fine for some specific
> configurations or usecases.

Yes, I suspect it works for you because you set up watermarks on the
high-pri job but not on the background jobs, thus making sure only
high-pri jobs can steal cycles from the rest of the system.

However, we do want low-pri jobs to have background reclaim as well. A
compile job may not be latency-sensitive, but it still benefits from a
throughput POV when the reclaim work runs concurrently. And if there
are idle CPU cycles available that the high-pri work isn't using right
now, it would be wasteful not to make use of them.

So yes, I can see how such an accounting loophole can be handy. By
letting reclaim CPU cycles sneak out of containment, you can kind of
use it for high-pri jobs. Or rather *one* high-pri job, because more
than one becomes unsafe again, where one can steal a large number of
cycles from others at the same priority.

But it's more universally useful to properly account CPU cycles that
are actually consumed by a cgroup, to that cgroup, and then reflect
the additional CPU explicitly in the CPU weight configuration. That
way you can safely have background reclaim on jobs of all priorities.
