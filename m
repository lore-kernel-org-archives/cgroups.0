From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 14/18] mm/memcg: Convert mem_cgroup_move_account() to
 use a folio
Date: Wed, 30 Jun 2021 10:30:38 +0200
Message-ID: <YNwrrl6cn48t6w5B@dhcp22.suse.cz>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-15-willy@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625041839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hy9SMJKljau3xo3CbYGL/3mx9qmeFAeMDpxjJFGvvs0=;
        b=BhOWSG/lPlXCd3i93v2gs3c8SbvLrJQESrM9QfMyEr42n8vpzQAsfFgL3IceJ0n2Ny4onN
        4H8gmS8Dlu6caoDnSoIZvCIqyfvKLs8/W4ERpQpo7ktwBTRvOhBAhNFDvC0sg+gnUsVWRO
        cFXSCpqPGEjlt/L4rkV9HM3aRWaTYSM=
Content-Disposition: inline
In-Reply-To: <20210630040034.1155892-15-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed 30-06-21 05:00:30, Matthew Wilcox wrote:
> This saves dozens of bytes of text by eliminating a lot of calls to
> compound_head().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> ---
>  mm/memcontrol.c | 37 +++++++++++++++++++------------------
>  1 file changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b94a6122f27d..95795b65ae3e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5585,38 +5585,39 @@ static int mem_cgroup_move_account(struct page *page,
>  				   struct mem_cgroup *from,
>  				   struct mem_cgroup *to)
>  {
> +	struct folio *folio = page_folio(page);
>  	struct lruvec *from_vec, *to_vec;
>  	struct pglist_data *pgdat;
> -	unsigned int nr_pages = compound ? thp_nr_pages(page) : 1;
> +	unsigned int nr_pages = compound ? folio_nr_pages(folio) : 1;
>  	int nid, ret;
>  
>  	VM_BUG_ON(from == to);
> -	VM_BUG_ON_PAGE(PageLRU(page), page);
> -	VM_BUG_ON(compound && !PageTransHuge(page));
> +	VM_BUG_ON_FOLIO(folio_lru(folio), folio);
> +	VM_BUG_ON(compound && !folio_multi(folio));
>  
>  	/*
>  	 * Prevent mem_cgroup_migrate() from looking at
>  	 * page's memory cgroup of its source page while we change it.
>  	 */
>  	ret = -EBUSY;
> -	if (!trylock_page(page))
> +	if (!folio_trylock(folio))
>  		goto out;
>  
>  	ret = -EINVAL;
> -	if (page_memcg(page) != from)
> +	if (folio_memcg(folio) != from)
>  		goto out_unlock;
>  
> -	pgdat = page_pgdat(page);
> +	pgdat = folio_pgdat(folio);
>  	from_vec = mem_cgroup_lruvec(from, pgdat);
>  	to_vec = mem_cgroup_lruvec(to, pgdat);
>  
> -	lock_page_memcg(page);
> +	folio_memcg_lock(folio);
>  
> -	if (PageAnon(page)) {
> -		if (page_mapped(page)) {
> +	if (folio_anon(folio)) {
> +		if (folio_mapped(folio)) {
>  			__mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
>  			__mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
> -			if (PageTransHuge(page)) {
> +			if (folio_multi(folio)) {

Shouldn't be folio_transhuge? The resulting code is the same but
folio_transhuge is more explicit and matches the THP aspect.

-- 
Michal Hocko
SUSE Labs
