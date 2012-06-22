From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: cleanup typos in mem cgroup
Date: Fri, 22 Jun 2012 14:32:44 +0200
Message-ID: <20120622123244.GD4814@tiehlicka.suse.cz>
References: <1340366474-28228-1-git-send-email-liwp.linux@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1340366474-28228-1-git-send-email-liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri 22-06-12 20:01:14, Wanpeng Li wrote:
> From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> ---
>  mm/memcontrol.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 776fc57..9e3c74a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -115,8 +115,8 @@ static const char * const mem_cgroup_events_names[] = {
>  
>  /*
>   * Per memcg event counter is incremented at every pagein/pageout. With THP,
> - * it will be incremated by the number of pages. This counter is used for
> - * for trigger some periodic events. This is straightforward and better
> + * it will be incremented by the number of pages. This counter is used for

.... is used to trigger ....

> + * trigger some periodic events. This is straightforward and better
>   * than using jiffies etc. to handle periodic memcg event.
>   */
>  enum mem_cgroup_events_target {
> @@ -678,7 +678,7 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
>   *
>   * If there are kernel internal actions which can make use of some not-exact
>   * value, and reading all cpu value can be performance bottleneck in some
> - * common workload, threashold and synchonization as vmstat[] should be
> + * common workload, threshold and synchonization as vmstat[] should be
>   * implemented.
>   */
>  static long mem_cgroup_read_stat(struct mem_cgroup *memcg,
> @@ -2213,7 +2213,7 @@ static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (mem_cgroup_wait_acct_move(mem_over_limit))
>  		return CHARGE_RETRY;
>  
> -	/* If we don't need to call oom-killer at el, return immediately */
> +	/* If we don't need to call oom-killer at all, return immediately */

I think the whole comment should rather go away.

>  	if (!oom_check)
>  		return CHARGE_NOMEM;
>  	/* check OOM */

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
