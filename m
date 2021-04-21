From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC] memory reserve for userspace oom-killer
Date: Wed, 21 Apr 2021 09:23:05 +0200
Message-ID: <YH/S2dVxk2le8SMw@dhcp22.suse.cz>
References: <CALvZod7vtDxJZtNhn81V=oE-EPOf=4KZB2Bv6Giz+u3bFFyOLg@mail.gmail.com>
 <YH8o5iIau85FaeLw@carbon.DHCP.thefacebook.com>
 <CALvZod7dXuFPeMv5NGu96uCosFpWY_Gy07iDsfSORCA0dT_zsA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618989786; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dp1wmWCgke/XdGEWD5zHfkjSz85fgdsugbIVZroCUDQ=;
        b=OJYaL42cTzaT6k4aidF/zvvFEKpsBC2O/ZqXbkPl3IoRTDZBfNGIMNGZzKtGLCemXvKfwX
        +FQvLaLFMwqMFGhbpw3AVFG0nvk5LPhAmPZhvPqECINdfpbP4Xp/mfLBJ9XRhFH+9Clikz
        OgYnoCY12/z+efAZmQ/qQqHw6RY+hOs=
Content-Disposition: inline
In-Reply-To: <CALvZod7dXuFPeMv5NGu96uCosFpWY_Gy07iDsfSORCA0dT_zsA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dragos Sbirlea <dragoss-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Priya Duraisamy <padmapriyad-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue 20-04-21 18:18:29, Shakeel Butt wrote:
> On Tue, Apr 20, 2021 at 12:18 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> >
> > On Mon, Apr 19, 2021 at 06:44:02PM -0700, Shakeel Butt wrote:
> [...]
> > > 1. prctl(PF_MEMALLOC)
> > >
> > > The idea is to give userspace oom-killer (just one thread which is
> > > finding the appropriate victims and will be sending SIGKILLs) access
> > > to MEMALLOC reserves. Most of the time the preallocation, mlock and
> > > memory.min will be good enough but for rare occasions, when the
> > > userspace oom-killer needs to allocate, the PF_MEMALLOC flag will
> > > protect it from reclaim and let the allocation dip into the memory
> > > reserves.
> > >
> > > The misuse of this feature would be risky but it can be limited to
> > > privileged applications. Userspace oom-killer is the only appropriate
> > > user of this feature. This option is simple to implement.
> >
> > Hello Shakeel!
> >
> > If ordinary PAGE_SIZE and smaller kernel allocations start to fail,
> > the system is already in a relatively bad shape. Arguably the userspace
> > OOM killer should kick in earlier, it's already a bit too late.
> 
> Please note that these are not allocation failures but rather reclaim
> on allocations (which is very normal). Our observation is that this
> reclaim is very unpredictable and depends on the type of memory
> present on the system which depends on the workload. If there is a
> good amount of easily reclaimable memory (e.g. clean file pages), the
> reclaim would be really fast. However for other types of reclaimable
> memory the reclaim time varies a lot. The unreclaimable memory, pinned
> memory, too many direct reclaimers, too many isolated memory and many
> other things/heuristics/assumptions make the reclaim further
> non-deterministic.
> 
> In our observation the global reclaim is very non-deterministic at the
> tail and dramatically impacts the reliability of the system. We are
> looking for a solution which is independent of the global reclaim.

I believe it is worth purusing a solution that would make the memory
reclaim more predictable. I have seen direct reclaim memory throttling
in the past. For some reason which I haven't tried to examine this has
become less of a problem with newer kernels. Maybe the memory access
patterns have changed or those problems got replaced by other issues but
an excessive throttling is definitely something that we want to address
rather than work around by some user visible APIs.

> > Allowing to use reserves just pushes this even further, so we're risking
> > the kernel stability for no good reason.
> 
> Michal has suggested ALLOC_OOM which is less risky.
> 
> >
> > But I agree that throttling the oom daemon in direct reclaim makes no sense.
> > I wonder if we can introduce a per-task flag which will exclude the task from
> > throttling, but instead all (large) allocations will just fail under a
> > significant memory pressure more easily. In this case if there is a significant
> > memory shortage the oom daemon will not be fully functional (will get -ENOMEM
> > for an attempt to read some stats, for example), but still will be able to kill
> > some processes and make the forward progress.
> 
> So, the suggestion is to have a per-task flag to (1) indicate to not
> throttle and (2) fail allocations easily on significant memory
> pressure.
> 
> For (1), the challenge I see is that there are a lot of places in the
> reclaim code paths where a task can get throttled. There are
> filesystems that block/throttle in slab shrinking. Any process can get
> blocked on an unrelated page or inode writeback within reclaim.
> 
> For (2), I am not sure how to deterministically define "significant
> memory pressure". One idea is to follow the __GFP_NORETRY semantics
> and along with (1) the userspace oom-killer will see ENOMEM more
> reliably than stucking in the reclaim.

Some of the interfaces (e.g. seq_file uses GFP_KERNEL reclaim strength)
could be more relaxed and rather fail than OOM kill but wouldn't your
OOM handler be effectivelly dysfunctional when not able to collect data
to make a decision?
-- 
Michal Hocko
SUSE Labs
