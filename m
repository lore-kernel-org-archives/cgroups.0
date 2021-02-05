From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix missing wakeup oom task
Date: Fri, 5 Feb 2021 09:24:43 +0100
Message-ID: <YB0Ay+epP/hnFmDS@dhcp22.suse.cz>
References: <20210205062310.74268-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612513484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SUs0oFDd/E1bOdAXdbbVbAD1+nLxACMkGmS9iKg9WAk=;
        b=mYo7dKgPs68rijoKaJCFctzUwf0uAHx+85FPPOwF+ebXspxPeNxvYFF/pdHRvSmQuSPHNT
        jz99FRwyKrE7IcQZDfN2cw5zZhEPMD/STL2B/2Lno6831+b8yqHp65WWiH9E65SESmId5f
        YD8L1gk+FOq6rrOBa1L9V1k/BWICpwM=
Content-Disposition: inline
In-Reply-To: <20210205062310.74268-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 05-02-21 14:23:10, Muchun Song wrote:
> We call memcg_oom_recover() in the uncharge_batch() to wakeup OOM task
> when page uncharged, but for the slab pages, we do not do this when page
> uncharged.

How does the patch deal with this?

> When we drain per cpu stock, we also should do this.

Can we have anything the per-cpu stock while entering the OOM path. IIRC
we do drain all cpus before entering oom path.

> The memcg_oom_recover() is small, so make it inline.

Does this lead to any code generation improvements? I would expect
compiler to be clever enough to inline static functions if that pays
off. If yes make this a patch on its own.

> And the parameter
> of memcg cannot be NULL, so remove the check.

2bd9bb206b338 has introduced the check without any explanation
whatsoever. I indeed do not see any potential path to provide a NULL
memcg here. This is an internal function so the check is unnecessary
indeed. Please make it a patch on its own.

> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> ---
>  mm/memcontrol.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8c035846c7a4..8569f4dbea2a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1925,7 +1925,7 @@ static int memcg_oom_wake_function(wait_queue_entry_t *wait,
>  	return autoremove_wake_function(wait, mode, sync, arg);
>  }
>  
> -static void memcg_oom_recover(struct mem_cgroup *memcg)
> +static inline void memcg_oom_recover(struct mem_cgroup *memcg)
>  {
>  	/*
>  	 * For the following lockless ->under_oom test, the only required
> @@ -1935,7 +1935,7 @@ static void memcg_oom_recover(struct mem_cgroup *memcg)
>  	 * achieved by invoking mem_cgroup_mark_under_oom() before
>  	 * triggering notification.
>  	 */
> -	if (memcg && memcg->under_oom)
> +	if (memcg->under_oom)
>  		__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
>  }
>  
> @@ -2313,6 +2313,7 @@ static void drain_stock(struct memcg_stock_pcp *stock)
>  		page_counter_uncharge(&old->memory, stock->nr_pages);
>  		if (do_memsw_account())
>  			page_counter_uncharge(&old->memsw, stock->nr_pages);
> +		memcg_oom_recover(old);
>  		stock->nr_pages = 0;
>  	}
>  
> -- 
> 2.11.0

-- 
Michal Hocko
SUSE Labs
