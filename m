From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: effective memory.high reclaim for remote charging
Date: Mon, 11 May 2020 12:07:11 +0200
Message-ID: <20200511100711.GD29153@dhcp22.suse.cz>
References: <20200507163301.229070-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200507163301.229070-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 07-05-20 09:33:01, Shakeel Butt wrote:
> Currently the reclaim of excessive usage over memory.high is scheduled
> to run on returning to the userland. The main reason behind this
> approach was simplicity i.e. always reclaim with GFP_KERNEL context.
> However the underlying assumptions behind this approach are: the current
> task shares the memcg hierarchy with the given memcg and the memcg of
> the current task most probably will not change on return to userland.
> 
> With the remote charging, the first assumption breaks and it allows the
> usage to grow way beyond the memory.high as the reclaim and the
> throttling becomes ineffective.
> 
> This patch forces the synchronous reclaim and potentially throttling for
> the callers with context that allows blocking. For unblockable callers
> or whose synch high reclaim is still not successful, a high reclaim is
> scheduled either to return-to-userland if current task shares the
> hierarchy with the given memcg or to system work queue.
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

I would just make the early break a bit more clear.

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

			/*
			 * reclaim_over_high reclaims parents up the
			 * hierarchy so we can break out early here.
			 */
> +			if (page_counter_read(&memcg->memory) <=
> +			    READ_ONCE(memcg->high))
> +				break;
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
