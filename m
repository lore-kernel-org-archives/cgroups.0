From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: remove useless check on page->mem_cgroup
Date: Fri, 31 Jul 2020 11:16:55 -0400
Message-ID: <20200731151655.GB491801@cmpxchg.org>
References: <1596166480-22814-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pNskHEW12lh46n0Zlsd60MF+6OVuuX4EV9sgDes5FR4=;
        b=vmpN/XsHGRmAJzX5ODCmQOdU9dwEyRp4t7ZUCD4yk9xdf2LrjaQbv+MGtE58Gw5Hk0
         fCc1sTUG9N2JEiTEPZ02eEnWasxmDlL+3cufg1hkd5Br741rCh0DLfqCA12pW9rmoS5w
         S2sLfPoLcfilrvfhKBcLMpVBeLGqe3V5nPNIcPIPTjtGEVHhmBxlFHl033WuVronNsQT
         CMJWEYn2c7vUpTzI1ChIzAoJXE7ERBOkILmts0mZvxCifvZDsDuRBSUTs6RYS0BbfSIi
         FRv4zq27dRtme/tQsrb1pIB2YY/c2B8VEBWij6lB4lORsAREM0tk9dV7ZmS9bSEQKZUO
         38Dw==
Content-Disposition: inline
In-Reply-To: <1596166480-22814-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jul 31, 2020 at 11:34:40AM +0800, Alex Shi wrote:
> Since readahead page will be charged on memcg too. We don't need to
> check this exception now. Rmove them is safe as all user pages are
> charged before use.
> 
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  mm/memcontrol.c | 21 ++++-----------------
>  1 file changed, 4 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e84c2b5596f2..9e44ae22d591 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1322,12 +1322,7 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgd
>  	}
>  
>  	memcg = page->mem_cgroup;
> -	/*
> -	 * Swapcache readahead pages are added to the LRU - and
> -	 * possibly migrated - before they are charged.
> -	 */
> -	if (!memcg)
> -		memcg = root_mem_cgroup;
> +	VM_BUG_ON_PAGE(!memcg, page);
>  
>  	mz = mem_cgroup_page_nodeinfo(memcg, page);
>  	lruvec = &mz->lruvec;
> @@ -6897,10 +6892,8 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
>  	if (newpage->mem_cgroup)
>  		return;
>  
> -	/* Swapcache readahead pages can get replaced before being charged */
>  	memcg = oldpage->mem_cgroup;
> -	if (!memcg)
> -		return;
> +	VM_BUG_ON_PAGE(!memcg, oldpage);
>  
>  	/* Force-charge the new page. The old one will be freed soon */
>  	nr_pages = thp_nr_pages(newpage);
> @@ -7094,10 +7087,7 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
>  		return;
>  
>  	memcg = page->mem_cgroup;
> -
> -	/* Readahead page, never charged */
> -	if (!memcg)
> -		return;
> +	VM_BUG_ON_PAGE(!memcg, page);
>  
>  	/*
>  	 * In case the memcg owning these pages has been offlined and doesn't
> @@ -7158,10 +7148,7 @@ int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
>  		return 0;
>  
>  	memcg = page->mem_cgroup;
> -
> -	/* Readahead page, never charged */
> -	if (!memcg)
> -		return 0;
> +	VM_BUG_ON_PAGE(!memcg, page);
>  
>  	if (!entry.val) {
>  		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);

Uncharged readahead pages are gone, but I'm not 100% sure uncharged
pages in general are gone. ISTR that the !page->mem_cgroup check in
mem_cgroup_uncharge() prevented a crash - although that is of course a
much broader interface, whereas the ones you change should only apply
to LRU pages (which are hopefully all charged).

Nevertheless, to avoid unnecessary crashes if we discover that we've
been wrong, how about leaving the branches for now, but adding a (new)
VM_WARN_ON_ONCE_PAGE() to them?
