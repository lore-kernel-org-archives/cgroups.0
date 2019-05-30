From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH REBASED] mm, memcg: Make scan aggression always exclude
 protection
Date: Thu, 30 May 2019 08:12:21 +0200
Message-ID: <20190530061221.GA6703@dhcp22.suse.cz>
References: <20190228213050.GA28211@chrisdown.name>
 <20190322160307.GA3316@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190322160307.GA3316@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

[Sorry for a late reply]

On Fri 22-03-19 16:03:07, Chris Down wrote:
[...]
> With this patch, memory.low and memory.min affect reclaim pressure in a
> more understandable and composable way. For example, from a user
> standpoint, "protected" memory now remains untouchable from a reclaim
> aggression standpoint, and users can also have more confidence that
> bursty workloads will still receive some amount of guaranteed
> protection.

Maybe I am missing something so correct me if I am wrong but the new
calculation actually means that we always allow to scan even min
protected memcgs right?

Because ...

[...]

> +static inline unsigned long mem_cgroup_protection(struct mem_cgroup *memcg,
> +						  bool in_low_reclaim)
>  {
> -	if (mem_cgroup_disabled()) {
> -		*min = 0;
> -		*low = 0;
> -		return;
> -	}
> +	if (mem_cgroup_disabled())
> +		return 0;
> +
> +	if (in_low_reclaim)
> +		return READ_ONCE(memcg->memory.emin);
>  
> -	*min = READ_ONCE(memcg->memory.emin);
> -	*low = READ_ONCE(memcg->memory.elow);
> +	return max(READ_ONCE(memcg->memory.emin),
> +		   READ_ONCE(memcg->memory.elow));
>  }
[...]
> +			unsigned long cgroup_size = mem_cgroup_size(memcg);
> +
> +			/* Avoid TOCTOU with earlier protection check */
> +			cgroup_size = max(cgroup_size, protection);
> +
> +			scan = lruvec_size - lruvec_size * protection /
> +				cgroup_size;
>  
[...]
> -			scan = clamp(scan, SWAP_CLUSTER_MAX, lruvec_size);
> +			scan = max(scan, SWAP_CLUSTER_MAX);

here the zero or sub SWAP_CLUSTER_MAX scan target gets extended to
SWAP_CLUSTER_MAX. Unless I am missing something this is not correct
because min protection should be a guarantee even in in_low_reclaim
mode.

>  		} else {
>  			scan = lruvec_size;
>  		}
> -- 
> 2.21.0

-- 
Michal Hocko
SUSE Labs
