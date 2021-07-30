From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/5] mm, memcg: save some atomic ops when flush is
 already true
Date: Fri, 30 Jul 2021 08:51:27 +0200
Message-ID: <YQOhbwhJWuk5NOro@dhcp22.suse.cz>
References: <20210729125755.16871-1-linmiaohe@huawei.com>
 <20210729125755.16871-4-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1627627888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JU3Y5J8NTdc7M6n9NoKsTCUbYMjkBBca/WKKJGoryDo=;
        b=GksVOKRfYmeR2RUP8XIfL2vg5hb5LIxjAS39cHhBHoJxg0KFftVR4wUpO4WzV5vGdycJ4z
        hG5JPhKddpFhD+SLE24qLZDzQU9riORLVGFrm71HqUSLeY3Dv21rQ4lq2lZXPefXht0JA9
        nFpJIKLuppdSXu0VUNaji7ebeIY7DU0=
Content-Disposition: inline
In-Reply-To: <20210729125755.16871-4-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 29-07-21 20:57:53, Miaohe Lin wrote:
> Add 'else' to save some atomic ops in obj_stock_flush_required() when
> flush is already true. No functional change intended here.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a03e24e57cd9..5b4592d1e0f2 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2231,7 +2231,7 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
>  		if (memcg && stock->nr_pages &&
>  		    mem_cgroup_is_descendant(memcg, root_memcg))
>  			flush = true;
> -		if (obj_stock_flush_required(stock, root_memcg))
> +		else if (obj_stock_flush_required(stock, root_memcg))
>  			flush = true;
>  		rcu_read_unlock();
>  
> -- 
> 2.23.0

-- 
Michal Hocko
SUSE Labs
