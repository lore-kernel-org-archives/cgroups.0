From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 1/2] mm: page-writeback: inline account_page_dirtied()
 into single caller
Date: Thu, 23 Oct 2014 14:21:54 +0200
Message-ID: <20141023122154.GB23011@dhcp22.suse.cz>
References: <1414002568-21042-1-git-send-email-hannes@cmpxchg.org>
 <1414002568-21042-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414002568-21042-2-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 22-10-14 14:29:27, Johannes Weiner wrote:
> A follow-up patch would have changed the call signature.  To save the
> trouble, just fold it instead.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: "3.17" <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

It seems that the function was added just for nilfs but that wasn't using
the symbol at the time memcg part went in. Funny...

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  include/linux/mm.h  |  1 -
>  mm/page-writeback.c | 23 ++++-------------------
>  2 files changed, 4 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 27eb1bfbe704..b46461116cd2 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1235,7 +1235,6 @@ int __set_page_dirty_no_writeback(struct page *page);
>  int redirty_page_for_writepage(struct writeback_control *wbc,
>  				struct page *page);
>  void account_page_dirtied(struct page *page, struct address_space *mapping);
> -void account_page_writeback(struct page *page);
>  int set_page_dirty(struct page *page);
>  int set_page_dirty_lock(struct page *page);
>  int clear_page_dirty_for_io(struct page *page);
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index ff24c9d83112..ff6a5b07211e 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2116,23 +2116,6 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
>  EXPORT_SYMBOL(account_page_dirtied);
>  
>  /*
> - * Helper function for set_page_writeback family.
> - *
> - * The caller must hold mem_cgroup_begin/end_update_page_stat() lock
> - * while calling this function.
> - * See test_set_page_writeback for example.
> - *
> - * NOTE: Unlike account_page_dirtied this does not rely on being atomic
> - * wrt interrupts.
> - */
> -void account_page_writeback(struct page *page)
> -{
> -	mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
> -	inc_zone_page_state(page, NR_WRITEBACK);
> -}
> -EXPORT_SYMBOL(account_page_writeback);
> -
> -/*
>   * For address_spaces which do not use buffers.  Just tag the page as dirty in
>   * its radix tree.
>   *
> @@ -2410,8 +2393,10 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
>  	} else {
>  		ret = TestSetPageWriteback(page);
>  	}
> -	if (!ret)
> -		account_page_writeback(page);
> +	if (!ret) {
> +		mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
> +		inc_zone_page_state(page, NR_WRITEBACK);
> +	}
>  	mem_cgroup_end_update_page_stat(page, &locked, &memcg_flags);
>  	return ret;
>  
> -- 
> 2.1.2
> 

-- 
Michal Hocko
SUSE Labs
