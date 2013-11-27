From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch] mm: memcg: do not declare OOM from __GFP_NOFAIL
 allocations
Date: Wed, 27 Nov 2013 11:39:16 -0500
Message-ID: <20131127163916.GB3556@cmpxchg.org>
References: <1385140676-5677-1-git-send-email-hannes@cmpxchg.org>
 <alpine.DEB.2.02.1311261658170.21003@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1311261931210.5973@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=UzBoLpMlwiqmCwYN8YdzVopDmVPqIej5++B/AJ0z5/U=;
	b=eD7Lj5NM0e7ATrypLQDSHbunLCTzJfRDDIToivGUWPYVJt3kW/dwV0BM5FRMccmYip+6qP9mgvr57Ntpr1LvZlDkX+EGCGL+3LKPVwfi+Y2sP0saAM/wH0fYy/ZtU08Rfj76iKPHJJCrMxFMDdOoQI2enV3wgto/wQ/wQksSQz0=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311261931210.5973-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 26, 2013 at 07:33:12PM -0800, David Rientjes wrote:
> On Tue, 26 Nov 2013, David Rientjes wrote:
> 
> > On Fri, 22 Nov 2013, Johannes Weiner wrote:
> > 
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 13b9d0f..cc4f9cb 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -2677,6 +2677,9 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
> > >  	if (unlikely(task_in_memcg_oom(current)))
> > >  		goto bypass;
> > >  
> > > +	if (gfp_mask & __GFP_NOFAIL)
> > > +		oom = false;
> > > +
> > >  	/*
> > >  	 * We always charge the cgroup the mm_struct belongs to.
> > >  	 * The mm_struct's mem_cgroup changes on task migration if the
> > 
> > Sorry, I don't understand this.  What happens in the following scenario:
> > 
> >  - memory.usage_in_bytes == memory.limit_in_bytes,
> > 
> >  - memcg reclaim fails to reclaim memory, and
> > 
> >  - all processes (perhaps only one) attached to the memcg are doing one of
> >    the over dozen __GFP_NOFAIL allocations in the kernel?
> > 
> > How do we make forward progress if you cannot oom kill something?

Bypass the limit.

> Ah, this is because of 3168ecbe1c04 ("mm: memcg: use proper memcg in limit 
> bypass") which just bypasses all of these allocations and charges the root 
> memcg.  So if allocations want to bypass memcg isolation they just have to 
> be __GFP_NOFAIL?

I don't think we have another option.
