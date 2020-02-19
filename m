From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: asynchronous reclaim for memory.high
Date: Wed, 19 Feb 2020 16:41:12 -0500
Message-ID: <20200219214112.4kt573kyzbvmbvn3@ca-dmjordan1.us.oracle.com>
References: <20200219181219.54356-1-hannes@cmpxchg.org>
 <20200219183731.GC11847@dhcp22.suse.cz>
 <20200219191618.GB54486@cmpxchg.org>
 <20200219195332.GE11847@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=CQ02yU9L3CkVYagd27UoMk+0f7/E/ZNIr/nEAq4qgrw=;
 b=sxDHcG/yZ7tARteJZLWRhuw/VLnSv4leEPcXRJi3NZ+rCWIjaQvL9MA7Pqx5SAJgDXYf
 JYr+sc9bDHvQurCSebh7BiToCjjNSk2x/iBUElo6gEHtg12l1rMC4anPIQk8cKFjS5n5
 lNMbkVKIkoo9b8mCoDT3KGJaABUq2SFJ3rhdr9zLU5kckXRdAw1E+rlCvmLT+j3fe+v5
 be10TpttHzkVZWrrzO+n0arB/B2uHEMqu0b3IJFPcxlACUCRCxpIK1/pF3md66xyVuhf
 NWU+mptwvt9mBA1cIAOcFjYW4CXe1BwCEf6jXOTPmOLrdvXtncoRaLRu0VWQaiXjS0R3 mw== 
Content-Disposition: inline
In-Reply-To: <20200219195332.GE11847-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Feb 19, 2020 at 08:53:32PM +0100, Michal Hocko wrote:
> On Wed 19-02-20 14:16:18, Johannes Weiner wrote:
> > On Wed, Feb 19, 2020 at 07:37:31PM +0100, Michal Hocko wrote:
> > > On Wed 19-02-20 13:12:19, Johannes Weiner wrote:
> > > > This patch adds asynchronous reclaim to the memory.high cgroup limit
> > > > while keeping direct reclaim as a fallback. In our testing, this
> > > > eliminated all direct reclaim from the affected workload.
> > > 
> > > Who is accounted for all the work? Unless I am missing something this
> > > just gets hidden in the system activity and that might hurt the
> > > isolation. I do see how moving the work to a different context is
> > > desirable but this work has to be accounted properly when it is going to
> > > become a normal mode of operation (rather than a rare exception like the
> > > existing irq context handling).
> > 
> > Yes, the plan is to account it to the cgroup on whose behalf we're
> > doing the work.

How are you planning to do that?

I've been thinking about how to account a kernel thread's CPU usage to a cgroup
on and off while working on the parallelizing Michal mentions below.  A few
approaches are described here:

https://lore.kernel.org/linux-mm/20200212224731.kmss6o6agekkg3mw-S51bK0XF4qpuJJETbFA3a0B3C2bhBk7L0E9HWUfgJXw@public.gmane.org/

> shows that the amount of the work required for the high limit reclaim
> can be non-trivial. Somebody has to do that work and we cannot simply
> allow everybody else to pay for that.
> 
> > The problem is that we have a general lack of usable CPU control right
> > now - see Rik's work on this: https://lkml.org/lkml/2019/8/21/1208.
> > For workloads that are contended on CPU, we cannot enable the CPU
> > controller because the scheduling latencies are too high. And for
> > workloads that aren't CPU contended, well, it doesn't really matter
> > where the reclaim cycles are accounted to.
> > 
> > Once we have the CPU controller up to speed, we can add annotations
> > like these to account stretches of execution to specific
> > cgroups. There just isn't much point to do it before we can actually
> > enable CPU control on the real workloads where it would matter.

Which annotations do you mean?  I didn't see them when skimming through Rik's
work or in this patch.
