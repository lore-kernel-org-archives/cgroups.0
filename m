From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 4/6] memcg: export nr_swap_files
Date: Tue, 29 Jan 2013 15:31:39 +0100
Message-ID: <20130129143139.GF29574@dhcp22.suse.cz>
References: <510658E3.1020306@oracle.com>
 <510658F6.4010504@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <510658F6.4010504-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 28-01-13 18:54:46, Jeff Liu wrote:
> Export nr_swap_files which would be used for initializing and destorying
> swap cgroup structures in the coming patch.
> 
> Signed-off-by: Jie Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> CC: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> CC: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

You are missing definition for !CONFIG_SWAP

After this is fixed you can add my
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> 
> ---
>  include/linux/swap.h |    1 +
>  mm/swapfile.c        |    2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 68df9c1..6de44c9 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -348,6 +348,7 @@ extern struct page *swapin_readahead(swp_entry_t, gfp_t,
>  /* linux/mm/swapfile.c */
>  extern long nr_swap_pages;
>  extern long total_swap_pages;
> +extern unsigned int nr_swapfiles;
>  extern void si_swapinfo(struct sysinfo *);
>  extern swp_entry_t get_swap_page(void);
>  extern swp_entry_t get_swap_page_of_type(int);
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index e97a0e5..89cebcf 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -46,7 +46,7 @@ static void free_swap_count_continuations(struct swap_info_struct *);
>  static sector_t map_swap_entry(swp_entry_t, struct block_device**);
>  
>  DEFINE_SPINLOCK(swap_lock);
> -static unsigned int nr_swapfiles;
> +unsigned int nr_swapfiles;
>  long nr_swap_pages;
>  long total_swap_pages;
>  static int least_priority;
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
