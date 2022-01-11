From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 4/4] mm/memcg: refine
 mem_cgroup_threshold_ary->current_threshold calculation
Date: Tue, 11 Jan 2022 09:44:45 +0100
Message-ID: <Yd1DffvquQeNM9V+@dhcp22.suse.cz>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
 <20220111010302.8864-4-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1641890686; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mbrh8o5uN1/tgvpBhMqXNUGgxMrcNwDYDBYIA0jYuaY=;
        b=h6Bh2WrfzZxuKm0ypf4OxrSKB5htlBNyF36T2helWv0NY4KsJtc1cBZCaWiDHBdWe7XY2A
        TZDxZ7UvmhbkPRcw6H+RnCVx5xXaXaNQmSh0jU14yD1xbyUK/ADD44SIlBAOkOhTDytzLM
        y9kPJ3t+se/D1A1ozarFY5iBGTAuzFw=
Content-Disposition: inline
In-Reply-To: <20220111010302.8864-4-richard.weiyang@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang@gmail.com>
Cc: hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, guro@fb.com, vbabka@suse.cz, willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com, surenb@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Tue 11-01-22 01:03:02, Wei Yang wrote:
> mem_cgroup_threshold_ary->current_threshold points to the last entry
> who's threshold is less or equal to usage.
> 
> Instead of iterating entries to get the correct index, we can leverage
> primary->current_threshold to get it. If the threshold added is less or
> equal to usage, current_threshold should increase by one. Otherwise, it
> doesn't change.

Why do we want/need this change?

> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---
>  mm/memcontrol.c | 31 +++++++++++++++++--------------
>  1 file changed, 17 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a504616f904a..ce7060907df2 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4161,7 +4161,7 @@ static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
>  	struct mem_cgroup_threshold_ary *new;
>  	unsigned long threshold;
>  	unsigned long usage;
> -	int i, size, ret;
> +	int size, ret;
>  
>  	ret = page_counter_memparse(args, "-1", &threshold);
>  	if (ret)
> @@ -4193,9 +4193,13 @@ static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
>  	new->size = size;
>  
>  	/* Copy thresholds (if any) to new array */
> -	if (thresholds->primary)
> +	if (thresholds->primary) {
>  		memcpy(new->entries, thresholds->primary->entries,
>  		       flex_array_size(new, entries, size - 1));
> +		new->current_threshold = thresholds->primary->current_threshold;
> +	} else {
> +		new->current_threshold = -1;
> +	}
>  
>  	/* Add new threshold */
>  	new->entries[size - 1].eventfd = eventfd;
> @@ -4205,18 +4209,17 @@ static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
>  	sort(new->entries, size, sizeof(*new->entries),
>  			compare_thresholds, NULL);
>  
> -	/* Find current threshold */
> -	new->current_threshold = -1;
> -	for (i = 0; i < size; i++) {
> -		if (new->entries[i].threshold <= usage) {
> -			/*
> -			 * new->current_threshold will not be used until
> -			 * rcu_assign_pointer(), so it's safe to increment
> -			 * it here.
> -			 */
> -			++new->current_threshold;
> -		} else
> -			break;
> +	/*
> +	 * If the threshold added here is less or equal to usage, this means
> +	 * current_threshold need to increase by one.
> +	 */
> +	if (threshold <= usage) {
> +		/*
> +		 * new->current_threshold will not be used until
> +		 * rcu_assign_pointer(), so it's safe to increment
> +		 * it here.
> +		 */
> +		new->current_threshold++;
>  	}
>  
>  	/* Free old spare buffer and save old primary buffer as spare */
> -- 
> 2.33.1

-- 
Michal Hocko
SUSE Labs
