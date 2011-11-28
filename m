From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 4/8] mm: memcg: lookup_page_cgroup (almost) never returns
 NULL
Date: Mon, 28 Nov 2011 11:12:25 +0100
Message-ID: <20111128101225.GC18337@tiehlicka.suse.cz>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
 <1322062951-1756-5-git-send-email-hannes@cmpxchg.org>
 <20111124095251.GD26036@tiehlicka.suse.cz>
 <20111124100549.GH6843@cmpxchg.org>
 <20111124102606.GF26036@tiehlicka.suse.cz>
 <20111128091518.GA9356@cmpxchg.org>
 <20111128093435.GC9356@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111128093435.GC9356-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 28-11-11 10:34:35, Johannes Weiner wrote:
> On Mon, Nov 28, 2011 at 10:15:18AM +0100, Johannes Weiner wrote:
> > On Thu, Nov 24, 2011 at 11:26:06AM +0100, Michal Hocko wrote:
> > > On Thu 24-11-11 11:05:49, Johannes Weiner wrote:
> > > > On Thu, Nov 24, 2011 at 10:52:51AM +0100, Michal Hocko wrote:
> > > > > On Wed 23-11-11 16:42:27, Johannes Weiner wrote:
[...]
> > > > > > @@ -3326,6 +3321,7 @@ static struct page_cgroup *lookup_page_cgroup_used(struct page *page)
> > > > > >  	struct page_cgroup *pc;
> > > > > >  
> > > > > >  	pc = lookup_page_cgroup(page);
> > > > > > +	/* Can be NULL while bootstrapping the page allocator */
> > > > > >  	if (likely(pc) && PageCgroupUsed(pc))
> > > > > >  		return pc;
> > > > > >  	return NULL;
> > > > 
> > > > We could add a lookup_page_cgroup_safe() for this DEBUG_VM-only
> > > > callsite as an optimization separately and remove the NULL check from
> > > > lookup_page_cgroup() itself.  But this patch was purely about removing
> > > > the actively misleading checks.
> > > 
> > > Yes, but I am not sure whether code duplication is worth it. Let's just
> > > stick with current form. Maybe just move the comment when it can be NULL
> > > to the lookup_page_cgroup directly?
> > 
> > Don't underestimate it, this function is used quite heavily while the
> > case of the array being NULL is a minor fraction of all calls.  But
> > it's for another patch, anyway.
> 
> Hm, how about this?

yes, makes sense.
Thanks

> 
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index a14655d..58405ca 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -28,9 +28,16 @@ struct page_cgroup *lookup_page_cgroup(struct page *page)
>  	struct page_cgroup *base;
>  
>  	base = NODE_DATA(page_to_nid(page))->node_page_cgroup;
> +#ifdef CONFIG_DEBUG_VM
> +	/*
> +	 * The sanity checks the page allocator does upon freeing a
> +	 * page can reach here before the page_cgroup arrays are
> +	 * allocated when feeding a range of pages to the allocator
> +	 * for the first time during bootup or memory hotplug.
> +	 */
>  	if (unlikely(!base))
>  		return NULL;
> -
> +#endif
>  	offset = pfn - NODE_DATA(page_to_nid(page))->node_start_pfn;
>  	return base + offset;
>  }
> @@ -87,9 +94,16 @@ struct page_cgroup *lookup_page_cgroup(struct page *page)
>  {
>  	unsigned long pfn = page_to_pfn(page);
>  	struct mem_section *section = __pfn_to_section(pfn);
> -
> +#ifdef CONFIG_DEBUG_VM
> +	/*
> +	 * The sanity checks the page allocator does upon freeing a
> +	 * page can reach here before the page_cgroup arrays are
> +	 * allocated when feeding a range of pages to the allocator
> +	 * for the first time during bootup or memory hotplug.
> +	 */
>  	if (!section->page_cgroup)
>  		return NULL;
> +#endif
>  	return section->page_cgroup + pfn;
>  }
>  

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
