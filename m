From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 1/6] memcg: use global stat directly for root memcg usage
Date: Wed, 13 Mar 2013 10:05:15 +0900
Message-ID: <513FD0CB.4000407@jp.fujitsu.com>
References: <1363082773-3598-1-git-send-email-handai.szj@taobao.com> <1363082920-3711-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363082920-3711-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

(2013/03/12 19:08), Sha Zhengju wrote:
> Since mem_cgroup_recursive_stat(root_mem_cgroup, INDEX) will sum up
> all memcg stats without regard to root's use_hierarchy, we may use
> global stats instead for simplicity.
> 
> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> ---
>   mm/memcontrol.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 669d16a..735cd41 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4987,11 +4987,11 @@ static inline u64 mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
>   			return res_counter_read_u64(&memcg->memsw, RES_USAGE);
>   	}
>   
> -	val = mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_CACHE);
> -	val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_RSS);
> +	val = global_page_state(NR_FILE_PAGES);
> +	val += global_page_state(NR_ANON_PAGES);
>   
you missed NR_ANON_TRANSPARENT_HUGEPAGES

>   	if (swap)
> -		val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_SWAP);
> +		val += total_swap_pages - atomic_long_read(&nr_swap_pages);
>   
Double count mapped SwapCache ? Did you saw Costa's trial in a week ago ?

Thanks,
-Kame

