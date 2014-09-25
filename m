From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 2/3] mm: memcontrol: simplify detecting when the
 memory+swap limit is hit
Date: Thu, 25 Sep 2014 17:27:54 +0200
Message-ID: <20140925152754.GF11080@dhcp22.suse.cz>
References: <1411571338-8178-1-git-send-email-hannes@cmpxchg.org>
 <1411571338-8178-3-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=LJZ5jRGjwsTEoL5HpOsePxmXLGdVwtlfETrvsf8kOP4=;
        b=BbxBIVa92yMc0ZK/IkrstHXUCUV02T9oAjXRZQ1FZbq2+pv2S8hY5aOPMcnFxX1c+/
         LD/N8i/05eBzH5i4pI1mL6EGnlD0Wy+hb1f5G7SGDHrzAJygAsSW/H7Q+B/yBGMPNGiF
         e2xSLhIiTg7fMCQZjeiZv5gAdk3MyAI/ArT/ZwwoQI3NaIkULfhxrbZDnS0E9NuEKdf9
         GsZGu0tF/LeWY/8VaDAftIVExEE3xAiMP5kzZ86a8b+/kZp39W1LKc7iDa6SiI4tvDvl
         bdjqwXL59k+5Q18DisKigXp2smLFb+713b1T35r2SEr1LsOe6JDh/IEQk+dtGBOvJsPx
         +YxQ==
Content-Disposition: inline
In-Reply-To: <1411571338-8178-3-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 24-09-14 11:08:57, Johannes Weiner wrote:
> When attempting to charge pages, we first charge the memory counter
> and then the memory+swap counter.  If one of the counters is at its
> limit, we enter reclaim, but if it's the memory+swap counter, reclaim
> shouldn't swap because that wouldn't change the situation.  However,
> if the counters have the same limits, we never get to the memory+swap
> limit.  To know whether reclaim should swap or not, there is a state
> flag that indicates whether the limits are equal and whether hitting
> the memory limit implies hitting the memory+swap limit.
> 
> Just try the memory+swap counter first.

OK, this makes sense and makes the reclaim code little bit more
readable (). I would just add that the patch shouldn't have any visible
effectes because that is not apparent from the description.

> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c | 47 +++++++++++++----------------------------------
>  1 file changed, 13 insertions(+), 34 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1ec22bf380d0..89c920156c2a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -315,9 +315,6 @@ struct mem_cgroup {
>  	/* OOM-Killer disable */
>  	int		oom_kill_disable;
>  
> -	/* set when res.limit == memsw.limit */
> -	bool		memsw_is_minimum;
> -
>  	/* protect arrays of thresholds */
>  	struct mutex thresholds_lock;
>  
> @@ -1804,8 +1801,6 @@ static unsigned long mem_cgroup_reclaim(struct mem_cgroup *memcg,
>  
>  	if (flags & MEM_CGROUP_RECLAIM_NOSWAP)
>  		noswap = true;
> -	if (!(flags & MEM_CGROUP_RECLAIM_SHRINK) && memcg->memsw_is_minimum)
> -		noswap = true;
>  
>  	for (loop = 0; loop < MEM_CGROUP_MAX_RECLAIM_LOOPS; loop++) {
>  		if (loop)
> @@ -2543,16 +2538,17 @@ retry:
>  		goto done;
>  
>  	size = batch * PAGE_SIZE;
> -	if (!res_counter_charge(&memcg->res, size, &fail_res)) {
> -		if (!do_swap_account)
> +	if (!do_swap_account ||
> +	    !res_counter_charge(&memcg->memsw, size, &fail_res)) {
> +		if (!res_counter_charge(&memcg->res, size, &fail_res))
>  			goto done_restock;
> -		if (!res_counter_charge(&memcg->memsw, size, &fail_res))
> -			goto done_restock;
> -		res_counter_uncharge(&memcg->res, size);
> +		if (do_swap_account)
> +			res_counter_uncharge(&memcg->memsw, size);
> +		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
> +	} else {
>  		mem_over_limit = mem_cgroup_from_res_counter(fail_res, memsw);
>  		flags |= MEM_CGROUP_RECLAIM_NOSWAP;
> -	} else
> -		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
> +	}
>  
>  	if (batch > nr_pages) {
>  		batch = nr_pages;
> @@ -3615,7 +3611,6 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>  				unsigned long long val)
>  {
>  	int retry_count;
> -	u64 memswlimit, memlimit;
>  	int ret = 0;
>  	int children = mem_cgroup_count_children(memcg);
>  	u64 curusage, oldusage;
> @@ -3642,24 +3637,16 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>  		 * We have to guarantee memcg->res.limit <= memcg->memsw.limit.
>  		 */
>  		mutex_lock(&set_limit_mutex);
> -		memswlimit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
> -		if (memswlimit < val) {
> +		if (res_counter_read_u64(&memcg->memsw, RES_LIMIT) < val) {
>  			ret = -EINVAL;
>  			mutex_unlock(&set_limit_mutex);
>  			break;
>  		}
>  
> -		memlimit = res_counter_read_u64(&memcg->res, RES_LIMIT);
> -		if (memlimit < val)
> +		if (res_counter_read_u64(&memcg->res, RES_LIMIT) < val)
>  			enlarge = 1;
>  
>  		ret = res_counter_set_limit(&memcg->res, val);
> -		if (!ret) {
> -			if (memswlimit == val)
> -				memcg->memsw_is_minimum = true;
> -			else
> -				memcg->memsw_is_minimum = false;
> -		}
>  		mutex_unlock(&set_limit_mutex);
>  
>  		if (!ret)
> @@ -3684,7 +3671,7 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
>  					unsigned long long val)
>  {
>  	int retry_count;
> -	u64 memlimit, memswlimit, oldusage, curusage;
> +	u64 oldusage, curusage;
>  	int children = mem_cgroup_count_children(memcg);
>  	int ret = -EBUSY;
>  	int enlarge = 0;
> @@ -3703,22 +3690,14 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
>  		 * We have to guarantee memcg->res.limit <= memcg->memsw.limit.
>  		 */
>  		mutex_lock(&set_limit_mutex);
> -		memlimit = res_counter_read_u64(&memcg->res, RES_LIMIT);
> -		if (memlimit > val) {
> +		if (res_counter_read_u64(&memcg->res, RES_LIMIT) > val) {
>  			ret = -EINVAL;
>  			mutex_unlock(&set_limit_mutex);
>  			break;
>  		}
> -		memswlimit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
> -		if (memswlimit < val)
> +		if (res_counter_read_u64(&memcg->memsw, RES_LIMIT) < val)
>  			enlarge = 1;
>  		ret = res_counter_set_limit(&memcg->memsw, val);
> -		if (!ret) {
> -			if (memlimit == val)
> -				memcg->memsw_is_minimum = true;
> -			else
> -				memcg->memsw_is_minimum = false;
> -		}
>  		mutex_unlock(&set_limit_mutex);
>  
>  		if (!ret)
> -- 
> 2.1.0
> 

-- 
Michal Hocko
SUSE Labs
