From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm: correctly charge compressed memory to its memcg
Date: Thu, 11 Aug 2022 17:12:36 -0700
Message-ID: <YvWa9MOQWBICInjO@P9FQF9L96D.corp.robot.car>
References: <20220811081913.102770-1-liliguang@baidu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660263175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uFp8sxdZCqziEXG2pBLb8/hRTqBA78it3qFFGSkqrcI=;
        b=HzumCH6sIq9pLPq+y0DiDANXUz4otZQI3BmvtlO/AJOEzlyerWa5fsgw5u3nzpa4tMuxAN
        B2qBYAioS1mV+YIxvc1EyuP9WQYkNZ52dKalM14OQy5NYHbYMIn0xRxb6tdfBnNLf54ojK
        +uwJqQT+wLTi05K/FImRS/B8e28U5fs=
Content-Disposition: inline
In-Reply-To: <20220811081913.102770-1-liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: liliguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On Thu, Aug 11, 2022 at 04:19:13PM +0800, liliguang wrote:
> From: Li Liguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
> 
> Kswapd will reclaim memory when memory pressure is high, the
> annonymous memory will be compressed and stored in the zpool
> if zswap is enabled. The memcg_kmem_bypass() in
> get_obj_cgroup_from_page() will bypass the kernel thread and
> cause the compressed memory not charged to its memory cgroup.
> 
> Remove the memcg_kmem_bypass() and properly charge compressed
> memory to its corresponding memory cgroup.
> 
> Signed-off-by: Li Liguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b69979c9ced5..6a95ea7c5ee7 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2971,7 +2971,7 @@ struct obj_cgroup *get_obj_cgroup_from_page(struct page *page)
>  {
>  	struct obj_cgroup *objcg;
>  
> -	if (!memcg_kmem_enabled() || memcg_kmem_bypass())
> +	if (!memcg_kmem_enabled())
>  		return NULL;
>  
>  	if (PageMemcgKmem(page)) {
> -- 
> 2.32.0 (Apple Git-132)
> 

Hi Li!

The fix looks good to me! As we get objcg pointer from a page and not from
the current task, memcg_kmem_bypass() doesn't makes much sense.

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Probably, we need to add
Fixes: f4840ccfca25 ("zswap: memcg accounting")

Thank you!
