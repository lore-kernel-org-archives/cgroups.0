From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v4 23/32] mm/memcg: Convert slab objcgs from struct page
 to struct slab
Date: Wed, 5 Jan 2022 19:36:10 -0800
Message-ID: <YdZjqhGqVH38WJIw@carbon.dhcp.thefacebook.com>
References: <20220104001046.12263-1-vbabka@suse.cz>
 <20220104001046.12263-24-vbabka@suse.cz>
 <YdUFXUbeYGdFbVbq@carbon.dhcp.thefacebook.com>
 <56c7a92b-f830-93dd-3fd0-4b6f1eb723ef@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=qkz1Pv8C1y2G22lxSfzpVfLn7dnQsSOXhRwupD3WzTM=;
 b=dgLFAaQDZTMboX8tCExR/SlvVETZu7Aj07LA9RVfgXwRW8qMl6MLpZoixzjlk5lXfttU
 GNVS3ZRM7HOQnQcTLB6ZbKqXLKDBLvVu19ehCiJhLHmYjzJYkpPGS7du86oD9BwA2dT9
 EFjnvr5Ze7lTVfqTM4pFmHHXZzmNn5uAKIw= 
Content-Disposition: inline
In-Reply-To: <56c7a92b-f830-93dd-3fd0-4b6f1eb723ef-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 05, 2022 at 06:08:45PM +0100, Vlastimil Babka wrote:
> On 1/5/22 03:41, Roman Gushchin wrote:
> > On Tue, Jan 04, 2022 at 01:10:37AM +0100, Vlastimil Babka wrote:
> >> page->memcg_data is used with MEMCG_DATA_OBJCGS flag only for slab pages
> >> so convert all the related infrastructure to struct slab. Also use
> >> struct folio instead of struct page when resolving object pointers.
> >> 
> >> This is not just mechanistic changing of types and names. Now in
> >> mem_cgroup_from_obj() we use folio_test_slab() to decide if we interpret
> >> the folio as a real slab instead of a large kmalloc, instead of relying
> >> on MEMCG_DATA_OBJCGS bit that used to be checked in page_objcgs_check().
> >> Similarly in memcg_slab_free_hook() where we can encounter
> >> kmalloc_large() pages (here the folio slab flag check is implied by
> >> virt_to_slab()). As a result, page_objcgs_check() can be dropped instead
> >> of converted.
> >> 
> >> To avoid include cycles, move the inline definition of slab_objcgs()
> >> from memcontrol.h to mm/slab.h.
> >> 
> >> Signed-off-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
> >> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> >> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> Cc: <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> >>  	/*
> >>  	 * Slab objects are accounted individually, not per-page.
> >>  	 * Memcg membership data for each individual object is saved in
> >>  	 * the page->obj_cgroups.
> >                ^^^^^^^^^^^^^^^^^
> > 	       slab->memcg_data
> 
> Good catch, fixed.
>  
> >>  	 */
> >> -	if (page_objcgs_check(page)) {
> >> -		struct obj_cgroup *objcg;
> >> +	if (folio_test_slab(folio)) {
> >> +		struct obj_cgroup **objcgs;
> >> +		struct slab *slab;
> >>  		unsigned int off;
> >>  
> >> -		off = obj_to_index(page->slab_cache, page_slab(page), p);
> >> -		objcg = page_objcgs(page)[off];
> >> -		if (objcg)
> >> -			return obj_cgroup_memcg(objcg);
> >> +		slab = folio_slab(folio);
> >> +		objcgs = slab_objcgs(slab);
> >> +		if (!objcgs)
> >> +			return NULL;
> >> +
> >> +		off = obj_to_index(slab->slab_cache, slab, p);
> >> +		if (objcgs[off])
> >> +			return obj_cgroup_memcg(objcgs[off]);
> >>  
> >>  		return NULL;
> >>  	}
> > 
> > There is a comment below, which needs some changes:
> > 	/*
> > 	 * page_memcg_check() is used here, because page_has_obj_cgroups()
> > 	 * check above could fail because the object cgroups vector wasn't set
> > 	 * at that moment, but it can be set concurrently.
> > 	 * page_memcg_check(page) will guarantee that a proper memory
> > 	 * cgroup pointer or NULL will be returned.
> > 	 */
> > 
> > In reality the folio's slab flag can be cleared before releasing the objcgs \
> > vector. It seems that there is no such possibility at setting the flag,
> > it's always set before allocating and assigning the objcg vector.
> 
> You're right. I'm changing it to:
> 
>          * page_memcg_check() is used here, because in theory we can encounter
>          * a folio where the slab flag has been cleared already, but
>          * slab->memcg_data has not been freed yet
>          * page_memcg_check(page) will guarantee that a proper memory
>          * cgroup pointer or NULL will be returned.
> 
> I wrote "in theory" because AFAICS it implies a race as we would have to be
> freeing a slab and at the same time query an object address. We probably
> could have used the non-check version, but at this point I don't want to
> make any functional changes besides these comment fixes.

Sounds good to me.

> 
> I assume your patch on top would cover it?

I tried to master it and remembered why we have this bit in place: there is
a /proc/kpagecgroup interface which just scans over pages and reads their
memcg data. It has zero control over the lifetime of pages, so it's prone
to all kinds of races with setting and clearing the slab flag. So it's
probably better to leave the MEMCG_DATA_OBJCGS bit in place.

> 
> >> @@ -2896,7 +2901,7 @@ struct mem_cgroup *mem_cgroup_from_obj(void *p)
> >>  	 * page_memcg_check(page) will guarantee that a proper memory
> >>  	 * cgroup pointer or NULL will be returned.
> >>  	 */
> >> -	return page_memcg_check(page);
> >> +	return page_memcg_check(folio_page(folio, 0));
> >>  }
> >>  
> >>  __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
> >> diff --git a/mm/slab.h b/mm/slab.h
> >> index bca9181e96d7..36e0022d8267 100644
> >> --- a/mm/slab.h
> >> +++ b/mm/slab.h
> >> @@ -412,15 +412,36 @@ static inline bool kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t fla
> >>  }
> >>  
> >>  #ifdef CONFIG_MEMCG_KMEM
> >> -int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
> >> -				 gfp_t gfp, bool new_page);
> >> +/*
> >> + * slab_objcgs - get the object cgroups vector associated with a slab
> >> + * @slab: a pointer to the slab struct
> >> + *
> >> + * Returns a pointer to the object cgroups vector associated with the slab,
> >> + * or NULL. This function assumes that the slab is known to have an
> >> + * associated object cgroups vector. It's not safe to call this function
> >> + * against slabs with underlying pages, which might have an associated memory
> >> + * cgroup: e.g.  kernel stack pages.
> > 
> > Hm, is it still true? I don't think so. It must be safe to call it for any
> > slab now.
> 
> Right, forgot to update after removing the _check variant.
> Changing to:
> 
>   * Returns a pointer to the object cgroups vector associated with the slab,
>   * or NULL if no such vector has been associated yet.

Perfect!

Thanks!
