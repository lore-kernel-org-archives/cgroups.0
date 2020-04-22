From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Wed, 22 Apr 2020 13:13:28 -0400
Message-ID: <20200422171328.GC362484@cmpxchg.org>
References: <20200420164740.GF43469@mtj.thefacebook.com>
 <20200420170318.GV27314@dhcp22.suse.cz>
 <20200420170650.GA169746@mtj.thefacebook.com>
 <20200421110612.GD27314@dhcp22.suse.cz>
 <20200421142746.GA341682@cmpxchg.org>
 <20200421161138.GL27314@dhcp22.suse.cz>
 <20200421165601.GA345998@cmpxchg.org>
 <20200422132632.GG30312@dhcp22.suse.cz>
 <20200422141514.GA362484@cmpxchg.org>
 <20200422154318.GK30312@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MwyrCZRymIVF3h654uJnEBCqJ3AtG9v1tu0i4qSd6eM=;
        b=F2ZOPuj4V9GN5VN2W2CWgq90Bsax8po7aVqM1xq+7b9iqcwd18SeQRka8DMGRAn49q
         yEpOG0Dk9eyRg9YdDAT9SJjMRPiYO8K3H+ay8NJpFWLDyf6HaQ/kHCU0YCSbvJbWsN6f
         u8sRX/o8oozGqL1Cor/m1Yiz5xjCIvFul5nTjImnrorX4mgTe16FLVlGf6enl/AOro3y
         hQaaT81hzANlcFf96zPfyAegU79G5D+fOJg6aj4MxEJnxl30aGLJQR9N/JIjm9z/VdOg
         ymr7qpM4ZZV1CP7M6DG3XmEYq86spnTBkC7abrHnqcBmx/rIQb9FXDTN+4YQ0tPSwM4V
         3B1w==
Content-Disposition: inline
In-Reply-To: <20200422154318.GK30312-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Apr 22, 2020 at 05:43:18PM +0200, Michal Hocko wrote:
> On Wed 22-04-20 10:15:14, Johannes Weiner wrote:
> > On Wed, Apr 22, 2020 at 03:26:32PM +0200, Michal Hocko wrote:
> > > That being said I believe our discussion is missing an important part.
> > > There is no description of the swap.high semantic. What can user expect
> > > when using it?
> > 
> > Good point, we should include that in cgroup-v2.rst. How about this?
> > 
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > index bcc80269bb6a..49e8733a9d8a 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1370,6 +1370,17 @@ PAGE_SIZE multiple when read back.
> >  	The total amount of swap currently being used by the cgroup
> >  	and its descendants.
> >  
> > +  memory.swap.high
> > +	A read-write single value file which exists on non-root
> > +	cgroups.  The default is "max".
> > +
> > +	Swap usage throttle limit.  If a cgroup's swap usage exceeds
> > +	this limit, allocations inside the cgroup will be throttled.
> 
> Hm, so this doesn't talk about which allocatios are affected. This is
> good for potential future changes but I am not sure this is useful to
> make any educated guess about the actual effects. One could expect that
> only those allocations which could contribute to future memory.swap
> usage. I fully realize that we do not want to be very specific but we
> want to provide something useful I believe. I am sorry but I do not have
> a good suggestion on how to make this better. Mostly because I still
> struggle on how this should behave to be sane.

I honestly don't really follow you here. Why is it not helpful to say
all allocations will slow down when condition X is met? We do the same
for memory.high.

> I am also missing some information about what the user can actually do
> about this situation and call out explicitly that the throttling is
> not going away until the swap usage is shrunk and the kernel is not
> capable of doing that on its own without a help from the userspace. This
> is really different from memory.high which has means to deal with the
> excess and shrink it down in most cases. The following would clarify it

I think we may be talking past each other. The user can do the same
thing as in any OOM situation: wait for the kill.

Swap being full is an OOM situation.

Yes, that does not match the kernel's internal definition of an OOM
situation. But we've already established that kernel OOM killing has a
different objective (memory deadlock avoidance) than userspace OOM
killing (quality of life)[1]

[1] https://lkml.org/lkml/2019/8/4/15

As Tejun said, things like earlyoom and oomd already kill based on
swap exhaustion, no further questions asked. Reclaim has been running
for a while, it went after all the low-hanging fruit: it doesn't swap
as long as there is easy cache; it also didn't just swap a little, it
filled up all of swap; and the pages in swap are all cold too, because
refaults would free that space again.

The workingset is hugely oversized for the available capacity, and
nobody has any interest in sticking around to see what tricks reclaim
still has up its sleeves (hint: nothing good). From here on out, it's
all thrashing and pain. The kernel might not OOM kill yet, but the quality
of life expectancy for a workload with full swap is trending toward zero.

We've been killing based on swap exhaustion as a stand-alone trigger
for several years now and it's never been the wrong call.

All swap.high does is acknowledge that swap-full is a common OOM
situation from a userspace view, and helps it handle that situation.

Just like memory.high acknowledges that if reclaim fails per kernel
definition, it's an OOM situation from a kernel view, and it helps
userspace handle that.

> for me
> 	"Once the limit is exceeded it is expected that the userspace
> 	 is going to act and either free up the swapped out space
> 	 or tune the limit based on needs. The kernel itself is not
> 	 able to do that on its own.
> 	"

I mean, in rare cases, maybe userspace can do some loadshedding and be
smart about it. But we certainly don't expect it to. Just like we
don't expect it to when memory.high starts injecting sleeps. We expect
the workload to die, usually.
