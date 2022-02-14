From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 3/4] mm/memcg: Protect per-CPU counter by disabling
 preemption on PREEMPT_RT where needed.
Date: Mon, 14 Feb 2022 11:46:00 -0500
Message-ID: <YgqHSIa/WvJSXERe@cmpxchg.org>
References: <20220211223537.2175879-1-bigeasy@linutronix.de>
 <20220211223537.2175879-4-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QeA+W5UTyGJnefg3/KfG82NxGUq6cPYrEgrwO7WmFzM=;
        b=5yIaMy4IIema7swz7szhTLQYzc7X1qKWeHs6ELx7V9WGKbrNr1ofviMV6o/sHSGbrc
         uLfdlz7wGzHoatYQxr5nUEpWoHnlhNVKoTx2HouziKIlrkfigiEHFIAPKTW2HrjBuAlH
         4XFgAruRhogInTYSVI6dL1oi1lzUBa6OiLOPwPpiwEJ+mjzCzdvNHNo4W/69YIyRh4ry
         AcHDh7S5iqjBNQRDfnJKvNm47fbVELJEri4BTe97JKH0o/AeRL4VFBF96C7RsZLgoXYX
         tr9X6J3+CGE9dz+4WrXcat40YjfIU8NbRMCgfq79U/Ui5WuIUUBNYdkLypy9vVxwo7LK
         hDZw==
Content-Disposition: inline
In-Reply-To: <20220211223537.2175879-4-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Fri, Feb 11, 2022 at 11:35:36PM +0100, Sebastian Andrzej Siewior wrote:
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
> ---
>  mm/memcontrol.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c1caa662946dc..466466f285cea 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -705,6 +705,8 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
>  	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
>  	memcg = pn->memcg;
>  
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT))
> +		preempt_disable();
>  	/* Update memcg */
>  	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
>  
> @@ -712,6 +714,8 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
>  	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
>  
>  	memcg_rstat_updated(memcg, val);
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT))
> +		preempt_enable();
>  }

I notice you didn't annoate __mod_memcg_state(). I suppose that is
because it's called with explicit local_irq_disable(), and that
disables preemption on rt? And you only need another preempt_disable()
for stacks that rely on coming from spin_lock_irq(save)?

That makes sense, but it's difficult to maintain. It'll easily break
if somebody adds more memory accounting sites that may also rely on an
irq-disabled spinlock somewhere.

So better to make this an unconditional locking protocol:

static void memcg_stats_lock(void)
{
#ifdef CONFIG_PREEMPT_RT
	preempt_disable();
#else
	VM_BUG_ON(!irqs_disabled());
#endif
}

static void memcg_stats_unlock(void)
{
#ifdef CONFIG_PREEMPT_RT
	preempt_enable();
#endif
}

and always use these around the counter updates.
