From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH v3 1/4] memcg: cleanup useless LRU_ALL_EVICTABLE
Date: Mon, 25 Jun 2012 11:33:28 +0200
Message-ID: <20120625093328.GD19805@tiehlicka.suse.cz>
References: <1340613812-9458-1-git-send-email-liwp.linux@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1340613812-9458-1-git-send-email-liwp.linux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Balbir Singh <bsingharora@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Eric Dumazet <eric.dumazet@gmail.com>, Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Marking this patch as memcg is quite misleading. mm is more suitable.

On Mon 25-06-12 16:43:32, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Since LRU_ALL_EVICTABLE is useless, just remove it.

It's really strange but I do not see any usage of this except for it's
introduction. So agreed to remove it.

> Add LRU_ALL_UNEVICTABLE to mask unevictable pages.

Does it really make sense to introduce just for two uses in a single
function?

> 
> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
> ---
>  include/linux/mmzone.h |    2 +-
>  mm/memcontrol.c        |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 68c569f..5873620 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -209,7 +209,7 @@ struct lruvec {
>  /* Mask used at gathering information at once (see memcontrol.c) */
>  #define LRU_ALL_FILE (BIT(LRU_INACTIVE_FILE) | BIT(LRU_ACTIVE_FILE))
>  #define LRU_ALL_ANON (BIT(LRU_INACTIVE_ANON) | BIT(LRU_ACTIVE_ANON))
> -#define LRU_ALL_EVICTABLE (LRU_ALL_FILE | LRU_ALL_ANON)
> +#define LRU_ALL_UNEVICTABLE (BIT(LRU_UNEVICTABLE))
>  #define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
>  
>  /* Isolate clean file */
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 724bd02..ccda728 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4033,11 +4033,11 @@ static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
>  	}
>  	seq_putc(m, '\n');
>  
> -	unevictable_nr = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_UNEVICTABLE));
> +	unevictable_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL_UNEVICTABLE);
>  	seq_printf(m, "unevictable=%lu", unevictable_nr);
>  	for_each_node_state(nid, N_HIGH_MEMORY) {
>  		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
> -				BIT(LRU_UNEVICTABLE));
> +				LRU_ALL_UNEVICTABLE);
>  		seq_printf(m, " N%d=%lu", nid, node_nr);
>  	}
>  	seq_putc(m, '\n');
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
