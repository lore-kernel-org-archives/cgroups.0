From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: Fix do not put the css reference
Date: Mon, 15 Jun 2020 13:50:07 +0200
Message-ID: <20200615115007.GI25296@dhcp22.suse.cz>
References: <20200614122653.98829-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200614122653.98829-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, cai-J5quhbR+WMc@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun 14-06-20 20:26:53, Muchun Song wrote:
> We should put the css reference when memory allocation failed.
> 
> Fixes: f0a3a24b532d ("mm: memcg/slab: rework non-root kmem_cache lifecycle management")
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

This looks like a stable tree material to me.

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0b38b6ad547d..2323d811ee8e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2772,8 +2772,10 @@ static void memcg_schedule_kmem_cache_create(struct mem_cgroup *memcg,
>  		return;
>  
>  	cw = kmalloc(sizeof(*cw), GFP_NOWAIT | __GFP_NOWARN);
> -	if (!cw)
> +	if (!cw) {
> +		css_put(&memcg->css);
>  		return;
> +	}
>  
>  	cw->memcg = memcg;
>  	cw->cachep = cachep;
> -- 
> 2.11.0

-- 
Michal Hocko
SUSE Labs
