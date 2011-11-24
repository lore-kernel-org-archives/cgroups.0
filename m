From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 4/8] mm: memcg: lookup_page_cgroup (almost) never returns
 NULL
Date: Thu, 24 Nov 2011 11:26:06 +0100
Message-ID: <20111124102606.GF26036@tiehlicka.suse.cz>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
 <1322062951-1756-5-git-send-email-hannes@cmpxchg.org>
 <20111124095251.GD26036@tiehlicka.suse.cz>
 <20111124100549.GH6843@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111124100549.GH6843-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 24-11-11 11:05:49, Johannes Weiner wrote:
> On Thu, Nov 24, 2011 at 10:52:51AM +0100, Michal Hocko wrote:
> > On Wed 23-11-11 16:42:27, Johannes Weiner wrote:
> > > From: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > 
> > > Pages have their corresponding page_cgroup descriptors set up before
> > > they are used in userspace, and thus managed by a memory cgroup.
> > > 
> > > The only time where lookup_page_cgroup() can return NULL is in the
> > > page sanity checking code that executes while feeding pages into the
> > > page allocator for the first time.
> > > 
> > > Remove the NULL checks against lookup_page_cgroup() results from all
> > > callsites where we know that corresponding page_cgroup descriptors
> > > must be allocated.
> > 
> > OK, shouldn't we add
> > 
> > diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> > index 2d123f9..cb93f64 100644
> > --- a/mm/page_cgroup.c
> > +++ b/mm/page_cgroup.c
> > @@ -35,8 +35,7 @@ struct page_cgroup *lookup_page_cgroup(struct page *page)
> >  	struct page_cgroup *base;
> >  
> >  	base = NODE_DATA(page_to_nid(page))->node_page_cgroup;
> > -	if (unlikely(!base))
> > -		return NULL;
> > +	BUG_ON(!base);
> >  
> >  	offset = pfn - NODE_DATA(page_to_nid(page))->node_start_pfn;
> >  	return base + offset;
> > @@ -112,8 +111,7 @@ struct page_cgroup *lookup_page_cgroup(struct page *page)
> >  	unsigned long pfn = page_to_pfn(page);
> >  	struct mem_section *section = __pfn_to_section(pfn);
> >  
> > -	if (!section->page_cgroup)
> > -		return NULL;
> > +	BUG_ON(!section->page_cgroup);
> >  	return section->page_cgroup + pfn;
> >  }
> >  
> > just to make it explicit?
> 
> No, see the last hunk in this patch.  It's actually possible for this
> to run, although only while feeding fresh pages into the allocator:

Bahh. Yes, I have noticed the hunk but then I started thinking about
how to make the NULL case explicit and totally forgot about that.
Sorry about the noise.

> 
> > > @@ -3326,6 +3321,7 @@ static struct page_cgroup *lookup_page_cgroup_used(struct page *page)
> > >  	struct page_cgroup *pc;
> > >  
> > >  	pc = lookup_page_cgroup(page);
> > > +	/* Can be NULL while bootstrapping the page allocator */
> > >  	if (likely(pc) && PageCgroupUsed(pc))
> > >  		return pc;
> > >  	return NULL;
> 
> We could add a lookup_page_cgroup_safe() for this DEBUG_VM-only
> callsite as an optimization separately and remove the NULL check from
> lookup_page_cgroup() itself.  But this patch was purely about removing
> the actively misleading checks.

Yes, but I am not sure whether code duplication is worth it. Let's just
stick with current form. Maybe just move the comment when it can be NULL
to the lookup_page_cgroup directly?

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
