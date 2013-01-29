From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 1/6] memcg: refactor swap_cgroup_swapon()
Date: Tue, 29 Jan 2013 14:41:37 +0100
Message-ID: <20130129134137.GB29574@dhcp22.suse.cz>
References: <510658E3.1020306@oracle.com>
 <510658E6.9030108@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <510658E6.9030108-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 28-01-13 18:54:30, Jeff Liu wrote:
> Refector swap_cgroup_swapon() to setup the number of pages only, and
> move the rest to swap_cgroup_prepare(), so that the later can be used
> for allocating buffers when creating the first non-root memcg.
> 
> Signed-off-by: Jie Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> CC: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> CC: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Makes sense and it even saves some lines.
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> 
> ---
>  mm/page_cgroup.c |   17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index 6d757e3..c945254 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -360,6 +360,9 @@ static int swap_cgroup_prepare(int type)
>  	unsigned long idx, max;
>  
>  	ctrl = &swap_cgroup_ctrl[type];
> +	ctrl->map = vzalloc(ctrl->length * sizeof(void *));
> +	if (!ctrl->map)
> +		goto nomem;
>  
>  	for (idx = 0; idx < ctrl->length; idx++) {
>  		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
> @@ -368,11 +371,13 @@ static int swap_cgroup_prepare(int type)
>  		ctrl->map[idx] = page;
>  	}
>  	return 0;
> +
>  not_enough_page:
>  	max = idx;
>  	for (idx = 0; idx < max; idx++)
>  		__free_page(ctrl->map[idx]);
> -
> +	ctrl->map = NULL;
> +nomem:
>  	return -ENOMEM;
>  }
>  
> @@ -460,8 +465,6 @@ unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
>  
>  int swap_cgroup_swapon(int type, unsigned long max_pages)
>  {
> -	void *array;
> -	unsigned long array_size;
>  	unsigned long length;
>  	struct swap_cgroup_ctrl *ctrl;
>  
> @@ -469,23 +472,15 @@ int swap_cgroup_swapon(int type, unsigned long max_pages)
>  		return 0;
>  
>  	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
> -	array_size = length * sizeof(void *);
> -
> -	array = vzalloc(array_size);
> -	if (!array)
> -		goto nomem;
>  
>  	ctrl = &swap_cgroup_ctrl[type];
>  	mutex_lock(&swap_cgroup_mutex);
>  	ctrl->length = length;
> -	ctrl->map = array;
>  	spin_lock_init(&ctrl->lock);
>  	if (swap_cgroup_prepare(type)) {
>  		/* memory shortage */
> -		ctrl->map = NULL;
>  		ctrl->length = 0;
>  		mutex_unlock(&swap_cgroup_mutex);
> -		vfree(array);
>  		goto nomem;
>  	}
>  	mutex_unlock(&swap_cgroup_mutex);
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Michal Hocko
SUSE Labs
