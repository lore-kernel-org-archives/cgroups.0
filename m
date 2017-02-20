From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm/cgroup: avoid panic when init with low memory
Date: Mon, 20 Feb 2017 14:01:23 +0100
Message-ID: <20170220130123.GI2431@dhcp22.suse.cz>
References: <1487154969-6704-1-git-send-email-ldufour@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1487154969-6704-1-git-send-email-ldufour-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Laurent Dufour <ldufour-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 15-02-17 11:36:09, Laurent Dufour wrote:
> The system may panic when initialisation is done when almost all the
> memory is assigned to the huge pages using the kernel command line
> parameter hugepage=xxxx. Panic may occur like this:

I am pretty sure the system might blow up in many other ways when you
misconfigure it and pull basically all the memory out. Anyway...

[...]
 
> This is a chicken and egg issue where the kernel try to get free
> memory when allocating per node data in mem_cgroup_init(), but in that
> path mem_cgroup_soft_limit_reclaim() is called which assumes that
> these data are allocated.
> 
> As mem_cgroup_soft_limit_reclaim() is best effort, it should return
> when these data are not yet allocated.

... this makes some sense. Especially when there is no soft limit
configured. So this is a good step. I would just like to ask you to go
one step further. Can we make the whole soft reclaim thing uninitialized
until the soft limit is actually set? Soft limit is not used in cgroup
v2 at all and I would strongly discourage it in v1 as well. We will save
few bytes as a bonus.
 
> Signed-off-by: Laurent Dufour <ldufour-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1fd6affcdde7..213f96b2f601 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2556,7 +2556,7 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
>  	 * is empty. Do it lockless to prevent lock bouncing. Races
>  	 * are acceptable as soft limit is best effort anyway.
>  	 */
> -	if (RB_EMPTY_ROOT(&mctz->rb_root))
> +	if (!mctz || RB_EMPTY_ROOT(&mctz->rb_root))
>  		return 0;
>  
>  	/*
> -- 
> 2.7.4

-- 
Michal Hocko
SUSE Labs
