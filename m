From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/4] mm/memcg: Protect per-CPU counter by disabling
 preemption on PREEMPT_RT where needed.
Date: Wed, 26 Jan 2022 15:56:52 +0100
Message-ID: <YfFhNOZgZGEGswsU@dhcp22.suse.cz>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
 <20220125164337.2071854-3-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643209015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UeaomIGUdhSiqk8Q8VOQigps7LLu2LVmLRRyq9SaCY4=;
        b=KRy7/W1n2hWD1uB+K3X+aGTi9kfJu58jX2jUbpS/1gPVT1rZKrOJtY4fDEiASSaUbzo5pY
        WpTWZsmJJeW4G65E1maueXQ5/1gsvuSmq+SixKRHa97eTjiCYc1eXuvnAMSjppF4bcuISy
        cMyQgYk5Gm92IJZEKba0IVDsbT/hBo0=
Content-Disposition: inline
In-Reply-To: <20220125164337.2071854-3-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue 25-01-22 17:43:35, Sebastian Andrzej Siewior wrote:
> The per-CPU counter are modified with the non-atomic modifier. The
> consistency is ensured by disabling interrupts for the update.
> On non PREEMPT_RT configuration this works because acquiring a
> spinlock_t typed lock with the _irq() suffix disables interrupts. On
> PREEMPT_RT configurations the RMW operation can be interrupted.
> 
> Another problem is that mem_cgroup_swapout() expects to be invoked with
> disabled interrupts because the caller has to acquire a spinlock_t which
> is acquired with disabled interrupts. Since spinlock_t never disables
> interrupts on PREEMPT_RT the interrupts are never disabled at this
> point.
> 
> The code is never called from in_irq() context on PREEMPT_RT therefore
> disabling preemption during the update is sufficient on PREEMPT_RT.
> The sections which explicitly disable interrupts can remain on
> PREEMPT_RT because the sections remain short and they don't involve
> sleeping locks (memcg_check_events() is doing nothing on PREEMPT_RT).
> 
> Disable preemption during update of the per-CPU variables which do not
> explicitly disable interrupts.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

I can see that you have already discussed the choice for open coded
version with Vlastimil. I do not have a strong opinion but I have to say
I dislike the construct because it is not really clear just from reading
the code. A wrapper could go and explain the underlying problem -
including potential asserts for !PREEMPT_RT. One way or the other the
change looks correct AFAICS.

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 36d27db673ca9..3d1b7cdd83db0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -667,6 +667,8 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
>  	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
>  	memcg = pn->memcg;
>  
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT))
> +		preempt_disable();
>  	/* Update memcg */
>  	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
>  
> @@ -674,6 +676,8 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
>  	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
>  
>  	memcg_rstat_updated(memcg, val);
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT))
> +		preempt_enable();
>  }
>  
>  /**
> @@ -756,8 +760,12 @@ void __count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
>  	if (mem_cgroup_disabled())
>  		return;
>  
> +	if (IS_ENABLED(PREEMPT_RT))
> +		preempt_disable();
>  	__this_cpu_add(memcg->vmstats_percpu->events[idx], count);
>  	memcg_rstat_updated(memcg, count);
> +	if (IS_ENABLED(PREEMPT_RT))
> +		preempt_enable();
>  }
>  
>  static unsigned long memcg_events(struct mem_cgroup *memcg, int event)
> @@ -7194,9 +7202,18 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
>  	 * i_pages lock which is taken with interrupts-off. It is
>  	 * important here to have the interrupts disabled because it is the
>  	 * only synchronisation we have for updating the per-CPU variables.
> +	 * On PREEMPT_RT interrupts are never disabled and the updates to per-CPU
> +	 * variables are synchronised by keeping preemption disabled.
>  	 */
> -	VM_BUG_ON(!irqs_disabled());
> -	mem_cgroup_charge_statistics(memcg, -nr_entries);
> +	if (!IS_ENABLED(CONFIG_PREEMPT_RT)) {
> +		VM_BUG_ON(!irqs_disabled());
> +		mem_cgroup_charge_statistics(memcg, -nr_entries);
> +	} else {
> +		preempt_disable();
> +		mem_cgroup_charge_statistics(memcg, -nr_entries);
> +		preempt_enable();
> +	}
> +
>  	memcg_check_events(memcg, page_to_nid(page));
>  
>  	css_put(&memcg->css);
> -- 
> 2.34.1

-- 
Michal Hocko
SUSE Labs
