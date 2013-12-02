From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch] mm: memcg: do not declare OOM from __GFP_NOFAIL
 allocations
Date: Mon, 2 Dec 2013 14:22:01 +0100
Message-ID: <20131202132201.GC18838@dhcp22.suse.cz>
References: <1385140676-5677-1-git-send-email-hannes@cmpxchg.org>
 <alpine.DEB.2.02.1311261658170.21003@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1311261931210.5973@chino.kir.corp.google.com>
 <20131127163916.GB3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271336220.9222@chino.kir.corp.google.com>
 <20131127225340.GE3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271526080.22848@chino.kir.corp.google.com>
 <20131128102049.GF2761@dhcp22.suse.cz>
 <alpine.DEB.2.02.1311291543400.22413@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311291543400.22413-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 29-11-13 15:46:16, David Rientjes wrote:
> On Thu, 28 Nov 2013, Michal Hocko wrote:
> 
> > > Ok, so let's forget about GFP_KERNEL | __GFP_NOFAIL since anything doing 
> > > __GFP_FS should not be holding such locks, we have some of those in the 
> > > drivers code and that makes sense that they are doing GFP_KERNEL.
> > > 
> > > Focusing on the GFP_NOFS | __GFP_NOFAIL allocations in the filesystem 
> > > code, the kernel oom killer independent of memcg never gets called because 
> > > !__GFP_FS and they'll simply loop around the page allocator forever.
> > > 
> > > In the past, Andrew has expressed the desire to get rid of __GFP_NOFAIL 
> > > entirely since it's flawed when combined with GFP_NOFS (and GFP_KERNEL | 
> > > __GFP_NOFAIL could simply be reimplemented in the caller) because of the 
> > > reason you point out in addition to making it very difficult in the page 
> > > allocator to free memory independent of memcg.
> > > 
> > > So I'm wondering if we should just disable the oom killer in memcg for 
> > > __GFP_NOFAIL as you've done here, but not bypass to the root memcg and 
> > > just allow them to spin?  I think we should be focused on the fixing the 
> > > callers rather than breaking memcg isolation.
> > 
> > What if the callers simply cannot deal with the allocation failure?
> > 84235de394d97 (fs: buffer: move allocation failure loop into the
> > allocator) describes one such case when __getblk_slow tries desperately
> > to grow buffers relying on the reclaim to free something. As there might
> > be no reclaim going on we are screwed.
> > 
> 
> My suggestion is to spin, not return NULL. 

Spin on which level? The whole point of this change was to not spin for
ever because the caller might sit on top of other locks which might
prevent somebody else to die although it has been killed.

> Bypassing to the root memcg 
> can lead to a system oom condition whereas if memcg weren't involved at 
> all the page allocator would just spin (because of !__GFP_FS).

I am confused now. The page allocation has already happened at the time
we are doing the charge. So the global OOM would have happened already.

> > That being said, while I do agree with you that we should strive for
> > isolation as much as possible there are certain cases when this is
> > impossible to achieve without seeing much worse consequences. For now,
> > we hope that __GFP_NOFAIL is used very scarcely.
> 
> If that's true, why not bypass the per-zone min watermarks in the page 
> allocator as well to allow these allocations to succeed?

Allocations are already done. We simply cannot charge that allocation
because we have reached the hard limit. And the said allocation might
prevent OOM action to proceed due to held locks.
-- 
Michal Hocko
SUSE Labs
