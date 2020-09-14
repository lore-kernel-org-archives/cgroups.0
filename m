From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 1/3] mm/memcg: Clean up obsolete enum charge_type
Date: Mon, 14 Sep 2020 13:37:22 +0200
Message-ID: <20200914113722.GL16999@dhcp22.suse.cz>
References: <20200914024452.19167-1-longman@redhat.com>
 <20200914024452.19167-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200914024452.19167-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Sun 13-09-20 22:44:50, Waiman Long wrote:
> Since commit 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API") and
> commit 00501b531c47 ("mm: memcontrol: rewrite charge API") in v3.17, the
> enum charge_type was no longer used anywhere. However, the enum itself
> was not removed at that time. Remove the obsolete enum charge_type now.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index cfa6cbad21d5..8c74f1200261 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -197,14 +197,6 @@ static struct move_charge_struct {
>  #define	MEM_CGROUP_MAX_RECLAIM_LOOPS		100
>  #define	MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS	2
>  
> -enum charge_type {
> -	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
> -	MEM_CGROUP_CHARGE_TYPE_ANON,
> -	MEM_CGROUP_CHARGE_TYPE_SWAPOUT,	/* for accounting swapcache */
> -	MEM_CGROUP_CHARGE_TYPE_DROP,	/* a page was unused swap cache */
> -	NR_CHARGE_TYPE,
> -};
> -
>  /* for encoding cft->private value on file */
>  enum res_type {
>  	_MEM,
> -- 
> 2.18.1
> 

-- 
Michal Hocko
SUSE Labs
