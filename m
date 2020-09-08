From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: no one use charge_type
Date: Tue, 8 Sep 2020 10:27:19 +0200
Message-ID: <20200908082719.GB26850@dhcp22.suse.cz>
References: <1599552727-60003-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1599552727-60003-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 08-09-20 16:12:07, Alex Shi wrote:
> After commit 0a31bc97c80c3f mm: memcontrol: rewrite uncharge API, no one
> using MEM_CGROUP_CHARGE_TYPE_xxx, let's remove them.
> 
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> 
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> 
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> 
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> 
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org 
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org 
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org 

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> ---
>  mm/memcontrol.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5d52b8a88bea..d925905920bf 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -199,14 +199,6 @@ struct mem_cgroup_event {
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
> 1.8.3.1

-- 
Michal Hocko
SUSE Labs
