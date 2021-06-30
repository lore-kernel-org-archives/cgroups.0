From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/vmpressure: replace vmpressure_to_css() with
 vmpressure_to_memcg()
Date: Wed, 30 Jun 2021 14:22:07 +0200
Message-ID: <YNxh72LydwZPE4qY@dhcp22.suse.cz>
References: <20210630112146.455103-1-suhui@zeku.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625055728; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jy9BUnnL9F4MU2WhkG8c4GL66SNmDqJ6jDqN3uAgDRg=;
        b=Wvb5ZzhZYyujUgG5/ndOGyrXHa6nuv/37LimXf4fJjhnFF1SLhtKTP3v1Zp01GJzK5BJ2R
        G8YmkcX2a9fEuckIv4jYOZvUCsCH6bSnITCJiHwJ+gymd2RTQVnkPnpJy24U5ben1NVDi4
        qP7FxhuqHkGHj1ceUp9W5Wb3lPtIXaI=
Content-Disposition: inline
In-Reply-To: <20210630112146.455103-1-suhui-OtvJRZzVyoU@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hui Su <suhui-OtvJRZzVyoU@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed 30-06-21 19:21:46, Hui Su wrote:
> We can get memcg directly form vmpr instead of vmpr->memcg->css->memcg,
> so add a new func helper vmpressure_to_memcg().
> And no code will use vmpressure_to_css(), so delete it.

Nice cleanup.

> Signed-off-by: Hui Su <suhui-OtvJRZzVyoU@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!
> ---
>  include/linux/vmpressure.h | 2 +-
>  mm/memcontrol.c            | 4 ++--
>  mm/vmpressure.c            | 3 +--
>  3 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
> index 6d28bc433c1c..6a2f51ebbfd3 100644
> --- a/include/linux/vmpressure.h
> +++ b/include/linux/vmpressure.h
> @@ -37,7 +37,7 @@ extern void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio);
>  extern void vmpressure_init(struct vmpressure *vmpr);
>  extern void vmpressure_cleanup(struct vmpressure *vmpr);
>  extern struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg);
> -extern struct cgroup_subsys_state *vmpressure_to_css(struct vmpressure *vmpr);
> +extern struct mem_cgroup *vmpressure_to_memcg(struct vmpressure *vmpr);
>  extern int vmpressure_register_event(struct mem_cgroup *memcg,
>  				     struct eventfd_ctx *eventfd,
>  				     const char *args);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 64ada9e650a5..62163a9cee63 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -247,9 +247,9 @@ struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg)
>  	return &memcg->vmpressure;
>  }
>  
> -struct cgroup_subsys_state *vmpressure_to_css(struct vmpressure *vmpr)
> +struct mem_cgroup *vmpressure_to_memcg(struct vmpressure *vmpr)
>  {
> -	return &container_of(vmpr, struct mem_cgroup, vmpressure)->css;
> +	return container_of(vmpr, struct mem_cgroup, vmpressure);
>  }
>  
>  #ifdef CONFIG_MEMCG_KMEM
> diff --git a/mm/vmpressure.c b/mm/vmpressure.c
> index d69019fc3789..04e81ac6d5d8 100644
> --- a/mm/vmpressure.c
> +++ b/mm/vmpressure.c
> @@ -74,8 +74,7 @@ static struct vmpressure *work_to_vmpressure(struct work_struct *work)
>  
>  static struct vmpressure *vmpressure_parent(struct vmpressure *vmpr)
>  {
> -	struct cgroup_subsys_state *css = vmpressure_to_css(vmpr);
> -	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> +	struct mem_cgroup *memcg = vmpressure_to_memcg(vmpr);
>  
>  	memcg = parent_mem_cgroup(memcg);
>  	if (!memcg)
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs
