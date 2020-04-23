From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Thu, 23 Apr 2020 11:00:15 -0400
Message-ID: <20200423150015.GE362484@cmpxchg.org>
References: <20200420170650.GA169746@mtj.thefacebook.com>
 <20200421110612.GD27314@dhcp22.suse.cz>
 <20200421142746.GA341682@cmpxchg.org>
 <20200421161138.GL27314@dhcp22.suse.cz>
 <20200421165601.GA345998@cmpxchg.org>
 <20200422132632.GG30312@dhcp22.suse.cz>
 <20200422141514.GA362484@cmpxchg.org>
 <20200422154318.GK30312@dhcp22.suse.cz>
 <20200422171328.GC362484@cmpxchg.org>
 <20200422184921.GB4206@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oENiaGCCgBNwU5CHpSWbzNiCtZrcoAbIQaEpyFI4Zyc=;
        b=F2+EdRXA4b1rXFir1jFJSgrXJrJ5o9riv22KqA2p86kWQCyPvSUKy4wKB5WLOdHwtU
         7D96mkRjvmaweBXzPi2GEsXuxbq388HMxcRU83Er8dCV4lcCg2/DOORi0sDl7O8iRp+5
         vbtBgli28f2Zs+HaIMLOMCfturcG/BAnCI32bf3pSvbAReVR0eDHy8HtNXzG0/QRSBH+
         qWU3i1iD+MXHatIKUEESuiFrTAosErCOciZ8HryVPP9t0jX8GY7r407zg/uK0sxKkAYo
         C2Bu6rQN59Wzr3dWDCUOUHAgilY68HaBE2geARf+DZppq7vAmSW8D9fq7H4C3yZFmVK6
         SaQg==
Content-Disposition: inline
In-Reply-To: <20200422184921.GB4206-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Apr 22, 2020 at 08:49:21PM +0200, Michal Hocko wrote:
> On Wed 22-04-20 13:13:28, Johannes Weiner wrote:
> > On Wed, Apr 22, 2020 at 05:43:18PM +0200, Michal Hocko wrote:
> > > On Wed 22-04-20 10:15:14, Johannes Weiner wrote:
> > > I am also missing some information about what the user can actually do
> > > about this situation and call out explicitly that the throttling is
> > > not going away until the swap usage is shrunk and the kernel is not
> > > capable of doing that on its own without a help from the userspace. This
> > > is really different from memory.high which has means to deal with the
> > > excess and shrink it down in most cases. The following would clarify it
> > 
> > I think we may be talking past each other. The user can do the same
> > thing as in any OOM situation: wait for the kill.
> 
> That assumes that reaching swap.high is going to converge to the OOM
> eventually. And that is far from the general case. There might be a
> lot of other reclaimable memory to reclaim and stay in the current
> state.

No, that's really the general case. And that's based on what users
widely experience, including us at FB. When swap is full, it's over.
Multiple parties have independently reached this conclusion.

This will be the default assumption in major distributions soon:
https://fedoraproject.org/wiki/Changes/EnableEarlyoom

> > > for me
> > > 	"Once the limit is exceeded it is expected that the userspace
> > > 	 is going to act and either free up the swapped out space
> > > 	 or tune the limit based on needs. The kernel itself is not
> > > 	 able to do that on its own.
> > > 	"
> > 
> > I mean, in rare cases, maybe userspace can do some loadshedding and be
> > smart about it. But we certainly don't expect it to.
> 
> I really didn't mean to suggest any clever swap management.  All I
> wanted so say and have documented is that users of swap.high should
> be aware of the fact that kernel is not able to do much to reduce the
> throttling. This is really different from memory.high where the kernel
> pro-actively tries to keep the memory usage below the watermark.  So a
> certain level of userspace cooperation is really needed unless you can
> tolerate a workload to be throttled to the end of times.

That's exactly what happens with memory.high. We've seen this. The
workload can go into a crawl and just stay there.

It's not unlike disabling the oom killer in cgroup1 without anybody
handling it. With memory.high, workloads *might* recover, but you have
to handle the ones that don't. Again, we inject sleeps into
memory.high when reclaim *is not* pushing back the workload anymore,
when reclaim is *failing*. The state isn't as stable as with
oom_control=0, but these indefinite hangs really happen in practice.
Realistically, you cannot use memory.high without an OOM manager.

The assymetry you see between memory.high and swap.high comes from the
page cache. memory.high can set a stop to the mindless expansion of
the file cache and remove *unused* cache pages from the application's
workingset. It cannot permanently remove used cache pages, they'll
just refault. So unused cache is where reclaim is useful.

Once the workload expands its set of *used* pages past memory.high, we
are talking about indefinite slowdowns / OOM situations. Because at
that point, reclaim cannot push the workload back and everything will
be okay: the pages it takes off mean refaults and continued reclaim,
i.e. throttling. You get slowed down either way, and whether you
reclaim or sleep() is - to the workload - an accounting difference.

Reclaim does NOT have the power to help the workload get better. It
can only do amputations to protect the rest of the system, but it
cannot reduce the number of pages the workload is trying to access.

The only sustainable way out of such a throttling situation is either
an OOM kill or the workload voluntarily shrinking and reducing the
total number of pages it uses. And doesn't that sound familiar? :-)

The actual, observable effects of memory.high and swap.high semantics
are much more similar than you think they are: When the workload's
true workingset (not throwaway cache) grows past capacity (memory or
swap), we slow down further expansion until it either changes its mind
and shrinks, or userspace OOM handling takes care of it.
