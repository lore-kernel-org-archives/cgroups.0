From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [patch] mm: memcg: shorten preempt-disabled section around
 event checks
Date: Tue, 22 Nov 2011 09:52:23 +0900
Message-ID: <20111122095223.0baefec9.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111121110954.GE1771@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111121110954.GE1771-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Yong Zhang <yong.zhang0-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Luis Henriques <henrix-CCGZq9okbVlg9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 21 Nov 2011 12:09:54 +0100
Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> -rt ran into a problem with the soft limit spinlock inside the
> non-preemptible section, because that is sleeping inside an atomic
> context.  But I think it makes sense for vanilla, too, to keep the
> non-preemptible section as short as possible.  Also, -3 lines.
> 
> Yong, Luis, could you add your Tested-bys?
> 
> ---
> Only the ratelimit checks themselves have to run with preemption
> disabled, the resulting actions - checking for usage thresholds,
> updating the soft limit tree - can and should run with preemption
> enabled.
> 
> Signed-off-by: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reported-by: Yong Zhang <yong.zhang0-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Reported-by: Luis Henriques <henrix-CCGZq9okbVlg9hUCZPvPmw@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

> ---
>  mm/memcontrol.c |   73 ++++++++++++++++++++++++++----------------------------
>  1 files changed, 35 insertions(+), 38 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6aff93c..8e62d3e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -683,37 +683,32 @@ static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
>  	return total;
>  }
>  
> -static bool __memcg_event_check(struct mem_cgroup *memcg, int target)
> +static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
> +				       enum mem_cgroup_events_target target)
>  {
>  	unsigned long val, next;
>  
>  	val = __this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
>  	next = __this_cpu_read(memcg->stat->targets[target]);
>  	/* from time_after() in jiffies.h */
> -	return ((long)next - (long)val < 0);
> -}
> -
> -static void __mem_cgroup_target_update(struct mem_cgroup *memcg, int target)
> -{
> -	unsigned long val, next;
> -
> -	val = __this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
> -
> -	switch (target) {
> -	case MEM_CGROUP_TARGET_THRESH:
> -		next = val + THRESHOLDS_EVENTS_TARGET;
> -		break;
> -	case MEM_CGROUP_TARGET_SOFTLIMIT:
> -		next = val + SOFTLIMIT_EVENTS_TARGET;
> -		break;
> -	case MEM_CGROUP_TARGET_NUMAINFO:
> -		next = val + NUMAINFO_EVENTS_TARGET;
> -		break;
> -	default:
> -		return;
> +	if ((long)next - (long)val < 0) {
> +		switch (target) {
> +		case MEM_CGROUP_TARGET_THRESH:
> +			next = val + THRESHOLDS_EVENTS_TARGET;
> +			break;
> +		case MEM_CGROUP_TARGET_SOFTLIMIT:
> +			next = val + SOFTLIMIT_EVENTS_TARGET;
> +			break;
> +		case MEM_CGROUP_TARGET_NUMAINFO:
> +			next = val + NUMAINFO_EVENTS_TARGET;
> +			break;
> +		default:
> +			break;
> +		}
> +		__this_cpu_write(memcg->stat->targets[target], next);
> +		return true;
>  	}
> -
> -	__this_cpu_write(memcg->stat->targets[target], next);
> +	return false;
>  }
>  
>  /*
> @@ -724,25 +719,27 @@ static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
>  {
>  	preempt_disable();
>  	/* threshold event is triggered in finer grain than soft limit */
> -	if (unlikely(__memcg_event_check(memcg, MEM_CGROUP_TARGET_THRESH))) {
> +	if (unlikely(mem_cgroup_event_ratelimit(memcg,
> +						MEM_CGROUP_TARGET_THRESH))) {
> +		bool do_softlimit, do_numainfo;
> +
> +		do_softlimit = mem_cgroup_event_ratelimit(memcg,
> +						MEM_CGROUP_TARGET_SOFTLIMIT);
> +#if MAX_NUMNODES > 1
> +		do_numainfo = mem_cgroup_event_ratelimit(memcg,
> +						MEM_CGROUP_TARGET_NUMAINFO);
> +#endif
> +		preempt_enable();
> +
>  		mem_cgroup_threshold(memcg);
> -		__mem_cgroup_target_update(memcg, MEM_CGROUP_TARGET_THRESH);
> -		if (unlikely(__memcg_event_check(memcg,
> -			     MEM_CGROUP_TARGET_SOFTLIMIT))) {
> +		if (unlikely(do_softlimit))
>  			mem_cgroup_update_tree(memcg, page);
> -			__mem_cgroup_target_update(memcg,
> -						   MEM_CGROUP_TARGET_SOFTLIMIT);
> -		}
>  #if MAX_NUMNODES > 1
> -		if (unlikely(__memcg_event_check(memcg,
> -			MEM_CGROUP_TARGET_NUMAINFO))) {
> +		if (unlikely(do_numainfo))
>  			atomic_inc(&memcg->numainfo_events);
> -			__mem_cgroup_target_update(memcg,
> -				MEM_CGROUP_TARGET_NUMAINFO);
> -		}
>  #endif
> -	}
> -	preempt_enable();
> +	} else
> +		preempt_enable();
>  }
>  
>  static struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
