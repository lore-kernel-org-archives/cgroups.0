From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH V3 6/8] memcg: Don't account root_mem_cgroup page
 statistics
Date: Wed, 2 Jan 2013 13:27:12 +0100
Message-ID: <20130102122712.GE22160@dhcp22.suse.cz>
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com>
 <1356456447-14740-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1356456447-14740-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Wed 26-12-12 01:27:27, Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> 
> If memcg is enabled and no non-root memcg exists, all allocated pages
> belongs to root_mem_cgroup and go through root memcg statistics routines
> which brings some overheads. So for the sake of performance, we can give
> up accounting stats of root memcg for MEM_CGROUP_STAT_FILE_MAPPED/FILE_DIRTY
> /WRITEBACK

I do not like this selective approach. We should handle all the stat
types in the same way. SWAP is not a hot path but RSS and CACHE should
be optimized as well. It seems that thresholds events might be a
complication here but it shouldn't be that a big deal (mem_cgroup_usage
would need some treat).

> and instead we pay special attention while showing root
> memcg numbers in memcg_stat_show(): as we don't account root memcg stats
> anymore, the root_mem_cgroup->stat numbers are actually 0.

Yes, this is reasonable.

> But because of hierachy, figures of root_mem_cgroup may just represent
> numbers of pages used by its own tasks(not belonging to any other
> child cgroup).

I am not sure what the above means. root might have use_hierarchy set to
1 as well.

> So here we fake these root numbers by using stats of global state and
> all other memcg.  That is for root memcg:
> 	nr(MEM_CGROUP_STAT_FILE_MAPPED) = global_page_state(NR_FILE_MAPPED) -
>                               sum_of_all_memcg(MEM_CGROUP_STAT_FILE_MAPPED);
> Dirty/Writeback pages accounting are in the similar way.
> 
> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

I like the approach but I do not like the implementation. See details
bellow.

> ---
>  mm/memcontrol.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 68 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index fc20ac9..728349d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
[...]
> @@ -5396,18 +5406,70 @@ static inline void mem_cgroup_lru_names_not_uptodate(void)
>  	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
>  }
>  
> +long long root_memcg_local_stat(unsigned int i, long long val,
> +					long long nstat[])

Function should be static
also
nstat parameter is ugly because this can be done by the caller
and also expecting that the caller already calculated val is not
nice (and undocumented). This approach is really hackish and error
prone. Why should we define a specific function rather than hooking into
mem_cgroup_read_stat and doing all the stuff there? I think that would
be much more maintainable.

> +{
> +	long long res = 0;
> +
> +	switch (i) {
> +	case MEM_CGROUP_STAT_FILE_MAPPED:
> +		res = global_page_state(NR_FILE_MAPPED);
> +		break;
> +	case MEM_CGROUP_STAT_FILE_DIRTY:
> +		res = global_page_state(NR_FILE_DIRTY);
> +		break;
> +	case MEM_CGROUP_STAT_WRITEBACK:
> +		res = global_page_state(NR_WRITEBACK);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	res = (res <= val) ? 0 : (res - val) * PAGE_SIZE;
> +	nstat[i] = res;
> +
> +	return res;
> +}
> +
>  static int memcg_stat_show(struct cgroup *cont, struct cftype *cft,
>  				 struct seq_file *m)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
>  	struct mem_cgroup *mi;
>  	unsigned int i;
> +	long long nstat[MEM_CGROUP_STAT_NSTATS] = {0};

s/nstat/root_stat/

>  
>  	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
> +		long long val = 0, res = 0;
> +
>  		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
>  			continue;
> -		seq_printf(m, "%s %ld\n", mem_cgroup_stat_names[i],
> -			   mem_cgroup_read_stat(memcg, i) * PAGE_SIZE);
> +		if (i == MEM_CGROUP_STAT_SWAP || i == MEM_CGROUP_STAT_CACHE ||
> +			i == MEM_CGROUP_STAT_RSS) {

This is plain ugly. If nothing else it asks for a comment why those are
special.

> +			seq_printf(m, "%s %ld\n", mem_cgroup_stat_names[i],
> +				   mem_cgroup_read_stat(memcg, i) * PAGE_SIZE);
> +			continue;
> +		}
> +
> +		/* As we don't account root memcg stats anymore, the
> +		 * root_mem_cgroup->stat numbers are actually 0. But because of
> +		 * hierachy, figures of root_mem_cgroup may just represent
> +		 * numbers of pages used by its own tasks(not belonging to any
> +		 * other child cgroup). So here we fake these root numbers by
> +		 * using stats of global state and all other memcg. That is for
> +		 * root memcg:
> +		 * nr(MEM_CGROUP_STAT_FILE_MAPPED) = global_page_state(NR_FILE_
> +		 * 	MAPPED) - sum_of_all_memcg(MEM_CGROUP_STAT_FILE_MAPPED)
> +		 * Dirty/Writeback pages accounting are in the similar way.
> +		 */
> +		if (memcg == root_mem_cgroup) {
> +			for_each_mem_cgroup(mi)
> +				val += mem_cgroup_read_stat(mi, i);
> +			res = root_memcg_local_stat(i, val, nstat);
> +		} else
> +			res = mem_cgroup_read_stat(memcg, i) * PAGE_SIZE;
> +
> +		seq_printf(m, "%s %lld\n", mem_cgroup_stat_names[i], res);
>  	}
>  
>  	for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++)
> @@ -5435,6 +5497,10 @@ static int memcg_stat_show(struct cgroup *cont, struct cftype *cft,
>  			continue;
>  		for_each_mem_cgroup_tree(mi, memcg)
>  			val += mem_cgroup_read_stat(mi, i) * PAGE_SIZE;
> +
> +		/* Adding local stats of root memcg */
> +		if (memcg == root_mem_cgroup)
> +			val += nstat[i];
>  		seq_printf(m, "total_%s %lld\n", mem_cgroup_stat_names[i], val);
>  	}
>  
> -- 
> 1.7.9.5
> 

-- 
Michal Hocko
SUSE Labs
