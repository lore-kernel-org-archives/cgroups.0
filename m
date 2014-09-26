From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch] mm: memcontrol: do not iterate uninitialized memcgs
Date: Fri, 26 Sep 2014 15:39:25 +0200
Message-ID: <20140926133925.GG4140@worktop.programming.kicks-ass.net>
References: <1411612278-4707-1-git-send-email-hannes@cmpxchg.org>
 <20140925025758.GA6903@mtj.dyndns.org>
 <20140925134342.GB22508@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140925134342.GB22508@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 09:43:42AM -0400, Johannes Weiner wrote:
> > > +		if (next_css == &root->css ||
> > > +		    css_tryget_online(next_css)) {
> > > +			struct mem_cgroup *memcg;
> > > +
> > > +			memcg = mem_cgroup_from_css(next_css);
> > > +			if (memcg->initialized) {
> > > +				/*
> > > +				 * Make sure the caller's accesses to
> > > +				 * the memcg members are issued after
> > > +				 * we see this flag set.
> > 
> > I usually prefer if the comment points to the exact location that the
> > matching memory barriers live.  Sometimes it's difficult to locate the
> > partner barrier even w/ the functional explanation.

That is indeed good practise! :-)

> > > +				 */
> > > +				smp_rmb();
> > > +				return memcg;
> > 
> > In an unlikely event this rmb becomes an issue, a self-pointing
> > pointer which is set/read using smp_store_release() and
> > smp_load_acquire() respectively can do with plain barrier() on the
> > reader side on archs which don't need data dependency barrier
> > (basically everything except alpha).  Not sure whether that'd be more
> > or less readable than this tho.

> So as far as I understand memory-barriers.txt we do not even need a
> data dependency here to use store_release and load_acquire:
> 
> mem_cgroup_css_online():
> <initialize memcg>
> smp_store_release(&memcg->initialized, 1);
> 
> mem_cgroup_iter():
> <look up maybe-initialized memcg>
> if (smp_load_acquire(&memcg->initialized))
>   return memcg;
> 
> So while I doubt that the smp_rmb() will become a problem in this
> path, it would be neat to annotate the state flag around which we
> synchronize like this, rather than have an anonymous barrier.
> 
> Peter, would you know if this is correct, or whether these primitives
> actually do require a data dependency?

I'm fairly sure you do not. load_acquire() has the same barrier in on
Alpha that read_barrier_depends() does, and that's the only arch that
matters.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
