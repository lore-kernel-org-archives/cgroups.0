From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] mm: memcontrol: cleanup css_reset callback
Date: Tue, 1 Mar 2016 17:04:04 +0100
Message-ID: <20160301160403.GL9461@dhcp22.suse.cz>
References: <69629961aefc48c021b895bb0c8297b56c11a577.1456830735.git.vdavydov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <69629961aefc48c021b895bb0c8297b56c11a577.1456830735.git.vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 01-03-16 14:13:12, Vladimir Davydov wrote:
>  - Do not take memcg_limit_mutex for resetting limits - the cgroup
>    cannot be altered from userspace anymore, so no need to protect them.
> 
>  - Use plain page_counter_limit() for resetting ->memory and ->memsw
>    limits instead of mem_cgrouop_resize_* helpers - we enlarge the
>    limits, so no need in special handling.
> 
>  - Reset ->swap and ->tcpmem limits as well.
> 
> Signed-off-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ae8b81c55685..8615b066b642 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4257,9 +4257,11 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
>  
> -	mem_cgroup_resize_limit(memcg, PAGE_COUNTER_MAX);
> -	mem_cgroup_resize_memsw_limit(memcg, PAGE_COUNTER_MAX);
> -	memcg_update_kmem_limit(memcg, PAGE_COUNTER_MAX);
> +	page_counter_limit(&memcg->memory, PAGE_COUNTER_MAX);
> +	page_counter_limit(&memcg->swap, PAGE_COUNTER_MAX);
> +	page_counter_limit(&memcg->memsw, PAGE_COUNTER_MAX);
> +	page_counter_limit(&memcg->kmem, PAGE_COUNTER_MAX);
> +	page_counter_limit(&memcg->tcpmem, PAGE_COUNTER_MAX);
>  	memcg->low = 0;
>  	memcg->high = PAGE_COUNTER_MAX;
>  	memcg->soft_limit = PAGE_COUNTER_MAX;
> -- 
> 2.1.4

-- 
Michal Hocko
SUSE Labs
