From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 4/7] swap.h: move memcg related stuff to the end of
 the file
Date: Wed, 13 Jan 2016 17:48:17 +0100
Message-ID: <20160113164817.GH17512@dhcp22.suse.cz>
References: <cover.1450352791.git.vdavydov@virtuozzo.com>
 <77dd7375cd8360829093b4c347db2e557334da21.1450352792.git.vdavydov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <77dd7375cd8360829093b4c347db2e557334da21.1450352792.git.vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 17-12-15 15:29:57, Vladimir Davydov wrote:
> The following patches will add more functions to the memcg section of
> include/linux/swap.h. Some of them will need values defined below the
> current location of the section. So let's move the section to the end of
> the file. No functional changes intended.
> 
> Signed-off-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  include/linux/swap.h | 70 ++++++++++++++++++++++++++++------------------------
>  1 file changed, 38 insertions(+), 32 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 478e7dd038c7..f8fb4e06c4bd 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -350,39 +350,7 @@ extern void check_move_unevictable_pages(struct page **, int nr_pages);
>  
>  extern int kswapd_run(int nid);
>  extern void kswapd_stop(int nid);
> -#ifdef CONFIG_MEMCG
> -static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
> -{
> -	/* root ? */
> -	if (mem_cgroup_disabled() || !memcg->css.parent)
> -		return vm_swappiness;
> -
> -	return memcg->swappiness;
> -}
>  
> -#else
> -static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
> -{
> -	return vm_swappiness;
> -}
> -#endif
> -#ifdef CONFIG_MEMCG_SWAP
> -extern void mem_cgroup_swapout(struct page *page, swp_entry_t entry);
> -extern int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry);
> -extern void mem_cgroup_uncharge_swap(swp_entry_t entry);
> -#else
> -static inline void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
> -{
> -}
> -static inline int mem_cgroup_try_charge_swap(struct page *page,
> -					     swp_entry_t entry)
> -{
> -	return 0;
> -}
> -static inline void mem_cgroup_uncharge_swap(swp_entry_t entry)
> -{
> -}
> -#endif
>  #ifdef CONFIG_SWAP
>  /* linux/mm/page_io.c */
>  extern int swap_readpage(struct page *);
> @@ -561,5 +529,43 @@ static inline swp_entry_t get_swap_page(void)
>  }
>  
>  #endif /* CONFIG_SWAP */
> +
> +#ifdef CONFIG_MEMCG
> +static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
> +{
> +	/* root ? */
> +	if (mem_cgroup_disabled() || !memcg->css.parent)
> +		return vm_swappiness;
> +
> +	return memcg->swappiness;
> +}
> +
> +#else
> +static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
> +{
> +	return vm_swappiness;
> +}
> +#endif
> +
> +#ifdef CONFIG_MEMCG_SWAP
> +extern void mem_cgroup_swapout(struct page *page, swp_entry_t entry);
> +extern int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry);
> +extern void mem_cgroup_uncharge_swap(swp_entry_t entry);
> +#else
> +static inline void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
> +{
> +}
> +
> +static inline int mem_cgroup_try_charge_swap(struct page *page,
> +					     swp_entry_t entry)
> +{
> +	return 0;
> +}
> +
> +static inline void mem_cgroup_uncharge_swap(swp_entry_t entry)
> +{
> +}
> +#endif
> +
>  #endif /* __KERNEL__*/
>  #endif /* _LINUX_SWAP_H */
> -- 
> 2.1.4
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Michal Hocko
SUSE Labs
