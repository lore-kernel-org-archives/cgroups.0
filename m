From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix an unused-function warning
Date: Fri, 29 May 2020 10:19:09 +0200
Message-ID: <20200529081909.GG4406@dhcp22.suse.cz>
References: <20200528095640.151454-1-arnd@arndb.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200528095640.151454-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 28-05-20 11:56:26, Arnd Bergmann wrote:
> On NOMMU kernels without CONFIG_MEMCG_KMEM, we now get a harmless
> warning about an unused function:
> 
> mm/memcontrol.c:2595:13: error: unused function 'cancel_charge' [-Werror,-Wunused-function]
> 
> Hide this function in a matching #ifdef.
> 
> Fixes: 5bd144bf764c ("mm: memcontrol: drop unused try/commit/cancel charge API")

This is a linux-next sha1 which is not valid anymore. I would just drop
the tag.

> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!
> ---
>  mm/memcontrol.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f14da7a7348b..7bfca0abb8e1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2592,6 +2592,7 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	return 0;
>  }
>  
> +#if defined(CONFIG_MEMCG_KMEM) || defined(CONFIG_MMU)
>  static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
>  {
>  	if (mem_cgroup_is_root(memcg))
> @@ -2603,6 +2604,7 @@ static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
>  
>  	css_put_many(&memcg->css, nr_pages);
>  }
> +#endif
>  
>  static void commit_charge(struct page *page, struct mem_cgroup *memcg)
>  {
> -- 
> 2.26.2
> 

-- 
Michal Hocko
SUSE Labs
