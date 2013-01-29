From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 3/6] memcg: introduce memsw_accounting_users
Date: Tue, 29 Jan 2013 15:24:47 +0100
Message-ID: <20130129142447.GD29574@dhcp22.suse.cz>
References: <510658E3.1020306@oracle.com>
 <510658F0.9050802@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <510658F0.9050802-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 28-01-13 18:54:40, Jeff Liu wrote:
> As we don't account the swap stat number for the root_mem_cgroup anymore,
> here we can just return an invalid CSS ID if there is no non-root memcg
> is alive.  Also, introduce memsw_accounting_users to track the number of
> active non-root memcgs.
> 
> Signed-off-by: Jie Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> CC: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> CC: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> 
> ---
>  mm/page_cgroup.c |   16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index c945254..189fbf5 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -336,6 +336,8 @@ struct swap_cgroup {
>  };
>  #define SC_PER_PAGE	(PAGE_SIZE/sizeof(struct swap_cgroup))
>  
> +static atomic_t memsw_accounting_users = ATOMIC_INIT(0);

Nobody manipulates whith this number. I suspect the next patch will do
but it is generally better to have also users of the introduced counters
in the same patch. For one thing this patch would introduce a regression
because no pages would be accounted at this stage (for example during
git bisect).

> +
>  /*
>   * SwapCgroup implements "lookup" and "exchange" operations.
>   * In typical usage, this swap_cgroup is accessed via memcg's charge/uncharge
> @@ -389,6 +391,9 @@ static struct swap_cgroup *lookup_swap_cgroup(swp_entry_t ent,
>  	struct page *mappage;
>  	struct swap_cgroup *sc;
>  
> +	if (!atomic_read(&memsw_accounting_users))
> +		return NULL;
> +
>  	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
>  	if (ctrlp)
>  		*ctrlp = ctrl;
> @@ -416,6 +421,8 @@ unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
>  	unsigned short retval;
>  
>  	sc = lookup_swap_cgroup(ent, &ctrl);
> +	if (!sc)
> +		return 0;
>  
>  	spin_lock_irqsave(&ctrl->lock, flags);
>  	retval = sc->id;
> @@ -443,6 +450,8 @@ unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)
>  	unsigned long flags;
>  
>  	sc = lookup_swap_cgroup(ent, &ctrl);
> +	if (!sc)
> +		return 0;
>  
>  	spin_lock_irqsave(&ctrl->lock, flags);
>  	old = sc->id;
> @@ -460,7 +469,9 @@ unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)
>   */
>  unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
>  {
> -	return lookup_swap_cgroup(ent, NULL)->id;
> +	struct swap_cgroup *sc = lookup_swap_cgroup(ent, NULL);
> +
> +	return sc ? sc->id : 0;
>  }
>  
>  int swap_cgroup_swapon(int type, unsigned long max_pages)
> @@ -471,6 +482,9 @@ int swap_cgroup_swapon(int type, unsigned long max_pages)
>  	if (!do_swap_account)
>  		return 0;
>  
> +	if (!atomic_read(&memsw_accounting_users))
> +		return 0;
> +
>  	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
>  
>  	ctrl = &swap_cgroup_ctrl[type];
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
