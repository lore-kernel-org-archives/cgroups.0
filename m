From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/5] mm, memcg: remove unused functions
Date: Fri, 30 Jul 2021 08:45:12 +0200
Message-ID: <YQOf+OAKmGxE6+k/@dhcp22.suse.cz>
References: <20210729125755.16871-1-linmiaohe@huawei.com>
 <20210729125755.16871-2-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1627627513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WGSyxiu3mrpSdkjXI3OCcCS7NGg99qcrN67xRlpt+bI=;
        b=IWh87TmkxKW563aoJcyB30+0gBdeVgoR4oJhyn/AYZvZFSpSJXs26QYdLwE5pjm4gdPxBa
        hzHiMc9UMDaYVP718QqWr/dn9w7IizFkFnIHAKFFvOfwzZNUDRrGAKFN8A0EdbAuy5/vSv
        JbSeOr284ji3GsEFA12JxCn9klheDSo=
Content-Disposition: inline
In-Reply-To: <20210729125755.16871-2-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 29-07-21 20:57:51, Miaohe Lin wrote:
> Since commit 2d146aa3aa84 ("mm: memcontrol: switch to rstat"), last user
> of memcg_stat_item_in_bytes() is gone. And since commit fa40d1ee9f15 ("mm:
> vmscan: memcontrol: remove mem_cgroup_select_victim_node()"), only the
> declaration of mem_cgroup_select_victim_node() is remained here. Remove
> them.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  include/linux/memcontrol.h | 12 ------------
>  1 file changed, 12 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 7028d8e4a3d7..04437504444f 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -606,13 +606,6 @@ static inline bool PageMemcgKmem(struct page *page)
>  	return folio_memcg_kmem(page_folio(page));
>  }
>  
> -static __always_inline bool memcg_stat_item_in_bytes(int idx)
> -{
> -	if (idx == MEMCG_PERCPU_B)
> -		return true;
> -	return vmstat_item_in_bytes(idx);
> -}
> -
>  static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
>  {
>  	return (memcg == root_mem_cgroup);
> @@ -916,11 +909,6 @@ static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
>  	return !!(memcg->css.flags & CSS_ONLINE);
>  }
>  
> -/*
> - * For memory reclaim.
> - */
> -int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
> -
>  void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
>  		int zid, int nr_pages);
>  
> -- 
> 2.23.0

-- 
Michal Hocko
SUSE Labs
