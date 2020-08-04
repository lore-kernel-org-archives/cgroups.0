From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2][next] mm: memcontrol: Use the preferred form for
 passing the size of a structure type
Date: Tue, 4 Aug 2020 15:25:47 +0200
Message-ID: <20200804132547.GD7306@dhcp22.suse.cz>
References: <cover.1596214831.git.gustavoars@kernel.org>
 <773e013ff2f07fe2a0b47153f14dea054c0c04f1.1596214831.git.gustavoars@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <773e013ff2f07fe2a0b47153f14dea054c0c04f1.1596214831.git.gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri 31-07-20 12:13:14, Gustavo A. R. Silva wrote:
> Use the preferred form for passing the size of a structure type. The
> alternative form where the structure type is spelled out hurts
> readability and introduces an opportunity for a bug when the object
> type is changed but the corresponding object identifier to which the
> sizeof operator is applied is not.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index bd7f972ceea4..bd0f56785841 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4255,7 +4255,7 @@ static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
>  	new->entries[size - 1].threshold = threshold;
>  
>  	/* Sort thresholds. Registering of new threshold isn't time-critical */
> -	sort(new->entries, size, sizeof(struct mem_cgroup_threshold),
> +	sort(new->entries, size, sizeof(*new->entries),
>  			compare_thresholds, NULL);
>  
>  	/* Find current threshold */
> -- 
> 2.27.0

-- 
Michal Hocko
SUSE Labs
