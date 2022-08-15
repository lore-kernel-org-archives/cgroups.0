From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: correctly charge compressed memory to its memcg
Date: Mon, 15 Aug 2022 11:20:11 -0400
Message-ID: <YvpkK8fwCEPGmif+@cmpxchg.org>
References: <20220811081913.102770-1-liliguang@baidu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=lyZgYwibx9tzRtJlNLbCd26XMkmBuOumcQ8OAPPucbg=;
        b=YNpjJEf/4VMEm5B9xVp7Zc/3JUCCu7KwjTesSoI4+6XzsgemIUvKR0QSyGpBvFShug
         3agDi7/sx0KMMGRwjNIUSg2RSHBVg9M/i246c5cNS8UZgbePBR1PVixVNZ9VdhLHXF8h
         pyIaajA/ZcivyGZKVcZsEOtvVxrkGfQDqv6Rqu8Bmri/u13C/72Zx4cYMjfpH9Jk8fgE
         Zr9AhY0jNdu+0jVXAk0F428lR6eLJ7NqwHEB8yA1Xi4G3hlMU9z+tUvmMTtVosnQSR2m
         0jBcy2ZKGUUXdP06l6Z0IpCY0Vo5R37acO2WSr6dWshFN6xZGc3eq+af27clNABV4Cth
         acDQ==
Content-Disposition: inline
In-Reply-To: <20220811081913.102770-1-liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: liliguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

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

Great catch. I think this qualifies for stable.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 5.19
Fixes: f4840ccfca25 ("zswap: memcg accounting")
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Andrew, can you please take this through the MM tree?

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
