From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/3] mm: memcontrol: Use cgroup_rstat for event accounting
Date: Wed, 4 Apr 2018 10:18:50 -0400
Message-ID: <20180404141850.GC28966@cmpxchg.org>
References: <20180324160901.512135-1-tj@kernel.org>
 <20180324160901.512135-2-tj@kernel.org>
 <20180404140855.GA28966@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Mjnc2QxCQfVwZOSJcZSR3xq/zHEu+b/sXGTJ01/sN2s=; b=v9IoPJMuZ5qItKLD62uGK3Ezmc
        93uAlx5KOxiyNL28qDk1ZBsjIyTKUNVsPy0nCuj3NSV1ySPQuz0GTjgtRCub8W7x0HCPKYyFhKoW/
        F3lRcBwsi+9UyUPSEPyd3lcDO3K1qJTMFiSRCQ/2YQXNFBSBfyUzCPsc7MYmKCWHEB7I=;
Content-Disposition: inline
In-Reply-To: <20180404140855.GA28966@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: mhocko@kernel.org, vdavydov.dev@gmail.com, guro@fb.com, riel@surriel.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, linux-mm@kvack.org

On Wed, Apr 04, 2018 at 10:08:55AM -0400, Johannes Weiner wrote:
> On Sat, Mar 24, 2018 at 09:08:59AM -0700, Tejun Heo wrote:
> > @@ -91,6 +91,9 @@ struct mem_cgroup_stat_cpu {
> >  	unsigned long events[MEMCG_NR_EVENTS];
> >  	unsigned long nr_page_events;
> >  	unsigned long targets[MEM_CGROUP_NTARGETS];
> > +
> > +	/* for cgroup rstat delta calculation */
> > +	unsigned long last_events[MEMCG_NR_EVENTS];
> >  };
> >  
> >  struct mem_cgroup_reclaim_iter {
> > @@ -233,7 +236,11 @@ struct mem_cgroup {
> >  
> >  	struct mem_cgroup_stat_cpu __percpu *stat_cpu;
> >  	atomic_long_t		stat[MEMCG_NR_STAT];
> > -	atomic_long_t		events[MEMCG_NR_EVENTS];
> > +
> > +	/* events is managed by cgroup rstat */
> > +	unsigned long long	events[MEMCG_NR_EVENTS];	/* local */
> > +	unsigned long long	tree_events[MEMCG_NR_EVENTS];	/* subtree */
> > +	unsigned long long	pending_events[MEMCG_NR_EVENTS];/* propagation */
> 
> The lazy updates are neat, but I'm a little concerned at the memory
> footprint. On a 64-cpu machine for example, this adds close to 9000
> words to struct mem_cgroup. And we really only need the accuracy for
> the 4 cgroup items in memory.events, not all VM events and stats.
> 
> Why not restrict the patch to those? It would also get rid of the
> weird sharing between VM and cgroup enums.

In fact, I wonder if we need per-cpuness for MEMCG_LOW, MEMCG_HIGH
etc. in the first place. They describe super high-level reclaim and
OOM events, so they're not nearly as hot as other VM events and
stats. We could probably just have a per-memcg array of atomics.
