From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 23/33] mm/memcg: Convert slab objcgs from struct page
 to struct slab
Date: Tue, 14 Dec 2021 15:43:07 +0100
Message-ID: <Ybite9s1TS7cS67J@cmpxchg.org>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-24-vbabka@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dDleZ4Lfyk2bTm2KE7iij6QxWvLTX00muEXEWoCAFGw=;
        b=iToBXoZPyX1HmEjRD9DYcj8MEGHopo9xF75hiJtC8KcXiSNm3wV+yNTOLZJg0tTXFp
         CcDnNBEVYlOJj98ra+ZqkK2W/NgaLZ60WNSJgEoN4NYNkCB2QB2oXRRd601ph8osCgLk
         fE+GP8Xg2NA97G7JWsO8n9Y/ekNxl+SIrugEV1BfoHGDD3YmGU6uuDIRymcZmbPOOIAe
         W4kbcehLY7lp4TcRp/BwMymv1KidNoHd+3va+GF5pSFIY8wfv9bThEhKSv+O5CUyk4Ct
         lvOqX4Y7g5dNI6Ub4pRj7+97axD/CYyvgWHXxLVdliIm6dJhbYT7xdDsSHD3MhaLjIsj
         SaMQ==
Content-Disposition: inline
In-Reply-To: <20211201181510.18784-24-vbabka-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Dec 01, 2021 at 07:15:00PM +0100, Vlastimil Babka wrote:
> page->memcg_data is used with MEMCG_DATA_OBJCGS flag only for slab pages
> so convert all the related infrastructure to struct slab.
> 
> To avoid include cycles, move the inline definitions of slab_objcgs() and
> slab_objcgs_check() from memcontrol.h to mm/slab.h.
> 
> This is not just mechanistic changing of types and names. Now in
> mem_cgroup_from_obj() we use PageSlab flag to decide if we interpret the page
> as slab, instead of relying on MEMCG_DATA_OBJCGS bit checked in
> page_objcgs_check() (now slab_objcgs_check()). Similarly in
> memcg_slab_free_hook() where we can encounter kmalloc_large() pages (here the
> PageSlab flag check is implied by virt_to_slab()).

Yup, this is great.

> @@ -2865,24 +2865,31 @@ int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
>   */
>  struct mem_cgroup *mem_cgroup_from_obj(void *p)
>  {
> -	struct page *page;
> +	struct folio *folio;
>  
>  	if (mem_cgroup_disabled())
>  		return NULL;
>  
> -	page = virt_to_head_page(p);
> +	folio = virt_to_folio(p);
>  
>  	/*
>  	 * Slab objects are accounted individually, not per-page.
>  	 * Memcg membership data for each individual object is saved in
>  	 * the page->obj_cgroups.
>  	 */
> -	if (page_objcgs_check(page)) {
> +	if (folio_test_slab(folio)) {
> +		struct obj_cgroup **objcgs;
>  		struct obj_cgroup *objcg;
> +		struct slab *slab;
>  		unsigned int off;
>  
> -		off = obj_to_index(page->slab_cache, page_slab(page), p);
> -		objcg = page_objcgs(page)[off];
> +		slab = folio_slab(folio);
> +		objcgs = slab_objcgs_check(slab);

AFAICS the change to the _check() variant was accidental.

folio_test_slab() makes sure it's a slab page, so the legit options
for memcg_data are NULL or |MEMCG_DATA_OBJCGS; using slab_objcgs()
here would include the proper asserts, like page_objcgs() used to.
