From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] memcg: effective memory.high reclaim for remote charging
Date: Thu, 7 May 2020 18:46:53 +0200
Message-ID: <20200507164653.GM6345@dhcp22.suse.cz>
References: <20200507163301.229070-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200507163301.229070-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu 07-05-20 09:33:01, Shakeel Butt wrote:
[...]
> @@ -2600,8 +2596,23 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  				schedule_work(&memcg->high_work);
>  				break;
>  			}
> -			current->memcg_nr_pages_over_high += batch;
> -			set_notify_resume(current);
> +
> +			if (gfpflags_allow_blocking(gfp_mask))
> +				reclaim_over_high(memcg, gfp_mask, batch);
> +
> +			if (page_counter_read(&memcg->memory) <=
> +			    READ_ONCE(memcg->high))
> +				break;

I am half way to a long weekend so bear with me. Shouldn't this be continue? The
parent memcg might be still in excess even the child got reclaimed,
right?

> +			/*
> +			 * The above reclaim might not be able to do much. Punt
> +			 * the high reclaim to return to userland if the current
> +			 * task shares the hierarchy.
> +			 */
> +			if (current->mm && mm_match_cgroup(current->mm, memcg)) {
> +				current->memcg_nr_pages_over_high += batch;
> +				set_notify_resume(current);
> +			} else
> +				schedule_work(&memcg->high_work);
>  			break;
>  		}
>  	} while ((memcg = parent_mem_cgroup(memcg)));
> -- 
> 2.26.2.526.g744177e7f7-goog
> 

-- 
Michal Hocko
SUSE Labs
