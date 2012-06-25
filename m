From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v3 2/4] memcg: change mem_control_xxx to mem_cgroup_xxx
Date: Mon, 25 Jun 2012 11:43:41 +0200
Message-ID: <20120625094341.GE19805@tiehlicka.suse.cz>
References: <1340613848-9536-1-git-send-email-liwp.linux@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1340613848-9536-1-git-send-email-liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Arun Sharma <asharma-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 25-06-12 16:44:08, Wanpeng Li wrote:
> From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> Unify memcg functions to mem_cgroup_xxx.
> 
> Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Thanks
> ---
>  mm/memcontrol.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ccda728..2e81328 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3999,7 +3999,7 @@ static int mem_cgroup_move_charge_write(struct cgroup *cgrp,
>  #endif
>  
>  #ifdef CONFIG_NUMA
> -static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
> +static int mem_cgroup_numa_stat_show(struct cgroup *cont, struct cftype *cft,
>  				      struct seq_file *m)
>  {
>  	int nid;
> @@ -4058,7 +4058,7 @@ static inline void mem_cgroup_lru_names_not_uptodate(void)
>  	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
>  }
>  
> -static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
> +static int mem_cgroup_stat_show(struct cgroup *cont, struct cftype *cft,
>  				 struct seq_file *m)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
> @@ -4572,7 +4572,7 @@ static struct cftype mem_cgroup_files[] = {
>  	},
>  	{
>  		.name = "stat",
> -		.read_seq_string = mem_control_stat_show,
> +		.read_seq_string = mem_cgroup_stat_show,
>  	},
>  	{
>  		.name = "force_empty",
> @@ -4604,7 +4604,7 @@ static struct cftype mem_cgroup_files[] = {
>  #ifdef CONFIG_NUMA
>  	{
>  		.name = "numa_stat",
> -		.read_seq_string = mem_control_numa_stat_show,
> +		.read_seq_string = mem_cgroup_numa_stat_show,
>  	},
>  #endif
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
