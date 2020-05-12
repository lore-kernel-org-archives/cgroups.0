From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH mm v2 1/3] mm: prepare for swap over-high accounting and
 penalty calculation
Date: Tue, 12 May 2020 09:08:58 +0200
Message-ID: <20200512070858.GO29153@dhcp22.suse.cz>
References: <20200511225516.2431921-1-kuba@kernel.org>
 <20200511225516.2431921-2-kuba@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200511225516.2431921-2-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Mon 11-05-20 15:55:14, Jakub Kicinski wrote:
> Slice the memory overage calculation logic a little bit so we can
> reuse it to apply a similar penalty to the swap. The logic which
> accesses the memory-specific fields (use and high values) has to
> be taken out of calculate_high_delay().
> 
> Signed-off-by: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

some recommendations below.

> ---
>  mm/memcontrol.c | 62 ++++++++++++++++++++++++++++---------------------
>  1 file changed, 35 insertions(+), 27 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 05dcb72314b5..8a9b671c3249 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2321,41 +2321,48 @@ static void high_work_func(struct work_struct *work)
>   #define MEMCG_DELAY_PRECISION_SHIFT 20
>   #define MEMCG_DELAY_SCALING_SHIFT 14
>  
> -/*
> - * Get the number of jiffies that we should penalise a mischievous cgroup which
> - * is exceeding its memory.high by checking both it and its ancestors.
> - */
> -static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
> -					  unsigned int nr_pages)
> +static u64 calculate_overage(unsigned long usage, unsigned long high)

the naming is slightly confusing. I would concider the return value
to be in memory units rather than time because I would read it as
overrage of high. calculate_throttle_penalty would be more clear to me.

>  {
> -	unsigned long penalty_jiffies;
> -	u64 max_overage = 0;
> -
> -	do {
> -		unsigned long usage, high;
> -		u64 overage;
> +	u64 overage;
>  
> -		usage = page_counter_read(&memcg->memory);
> -		high = READ_ONCE(memcg->high);
> +	if (usage <= high)
> +		return 0;
>  
> -		if (usage <= high)
> -			continue;
> +	/*
> +	 * Prevent division by 0 in overage calculation by acting as if
> +	 * it was a threshold of 1 page
> +	 */
> +	high = max(high, 1UL);
>  
> -		/*
> -		 * Prevent division by 0 in overage calculation by acting as if
> -		 * it was a threshold of 1 page
> -		 */
> -		high = max(high, 1UL);
> +	overage = usage - high;
> +	overage <<= MEMCG_DELAY_PRECISION_SHIFT;
> +	return div64_u64(overage, high);
> +}
>  
> -		overage = usage - high;
> -		overage <<= MEMCG_DELAY_PRECISION_SHIFT;
> -		overage = div64_u64(overage, high);
> +static u64 mem_find_max_overage(struct mem_cgroup *memcg)

This would then become find_high_throttle_penalty

> +{
> +	u64 overage, max_overage = 0;
>  
> -		if (overage > max_overage)
> -			max_overage = overage;
> +	do {
> +		overage = calculate_overage(page_counter_read(&memcg->memory),
> +					    READ_ONCE(memcg->high));
> +		max_overage = max(overage, max_overage);
>  	} while ((memcg = parent_mem_cgroup(memcg)) &&
>  		 !mem_cgroup_is_root(memcg));
>  
> +	return max_overage;
> +}
> +
> +/*
> + * Get the number of jiffies that we should penalise a mischievous cgroup which
> + * is exceeding its memory.high by checking both it and its ancestors.
> + */
> +static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
> +					  unsigned int nr_pages,
> +					  u64 max_overage)
> +{
> +	unsigned long penalty_jiffies;
> +
>  	if (!max_overage)
>  		return 0;
>  
> @@ -2411,7 +2418,8 @@ void mem_cgroup_handle_over_high(void)
>  	 * memory.high is breached and reclaim is unable to keep up. Throttle
>  	 * allocators proactively to slow down excessive growth.
>  	 */
> -	penalty_jiffies = calculate_high_delay(memcg, nr_pages);
> +	penalty_jiffies = calculate_high_delay(memcg, nr_pages,
> +					       mem_find_max_overage(memcg));
>  
>  	/*
>  	 * Don't sleep if the amount of jiffies this memcg owes us is so low
> -- 
> 2.25.4

-- 
Michal Hocko
SUSE Labs
