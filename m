From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH RFC] memcg: close the race window between OOM detection
 and killing
Date: Fri, 5 Jun 2015 17:21:35 +0200
Message-ID: <20150605152135.GE26113@dhcp22.suse.cz>
References: <20150603031544.GC7579@mtj.duckdns.org>
 <20150603144414.GG16201@dhcp22.suse.cz>
 <20150603193639.GH20091@mtj.duckdns.org>
 <20150604093031.GB4806@dhcp22.suse.cz>
 <20150604192936.GR20091@mtj.duckdns.org>
 <20150605143534.GD26113@dhcp22.suse.cz>
 <20150605145759.GA5946@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150605145759.GA5946-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri 05-06-15 23:57:59, Tejun Heo wrote:
> Hello, Michal.
> 
> On Fri, Jun 05, 2015 at 04:35:34PM +0200, Michal Hocko wrote:
> > > That doesn't matter because the detection and TIF_MEMDIE assertion are
> > > atomic w.r.t. oom_lock and TIF_MEMDIE essentially extends the locking
> > > by preventing further OOM kills.  Am I missing something?
> > 
> > This is true but TIF_MEMDIE releasing is not atomic wrt. the allocation
> > path. So the oom victim could have released memory and dropped
> 
> This is splitting hairs.  In vast majority of problem cases, if
> anything is gonna be locked up, it's gonna be locked up before
> releasing memory it's holding.  Yet again, this is a blunt instrument
> to unwedge the system.  It's difficult to see the point of aiming that
> level of granularity.

I was just pointing out that the OOM killer is inherently racy even for
the global case. Not sure we are talking about the same thing here.

> 
> > TIF_MEMDIE but the allocation path hasn't noticed that because it's passed
> >         /*
> >          * Go through the zonelist yet one more time, keep very high watermark
> >          * here, this is only to catch a parallel oom killing, we must fail if
> >          * we're still under heavy pressure.
> >          */
> >         page = get_page_from_freelist(gfp_mask | __GFP_HARDWALL, order,
> >                                         ALLOC_WMARK_HIGH|ALLOC_CPUSET, ac);
> > 
> > and goes on to kill another task because there is no TIF_MEMDIE
> > anymore.
> 
> Why would this be an issue if we disallow parallel killing?

I am confused. The whole thread has started by fixing a race in memcg
and I was asking about the global case which is racy currently as well.

> > > Deadlocks from infallible allocations getting interlocked are
> > > different.  OOM killer can't really get around that by itself but I'm
> > > not talking about those deadlocks but at the same time they're a lot
> > > less likely.  It's about OOM victim trapped in a deadlock failing to
> > > release memory because someone else is waiting for that memory to be
> > > released while blocking the victim. 
> > 
> > I thought those would be in the allocator context - which was the
> > example I've provided. What kind of context do you have in mind?
> 
> Yeah, sure, they'd be in the allocator context holding other resources
> which are being waited upon.  The first case was deadlock based on
> purely memory starvation where NOFAIL allocations interlock with each
> other w/o involving other resources.

OK, I guess we were just talking past each other.
-- 
Michal Hocko
SUSE Labs
