From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 3/5] mm/memcg: Protect per-CPU counter by disabling
 preemption on PREEMPT_RT where needed.
Date: Fri, 18 Feb 2022 09:25:29 -0800
Message-ID: <CALvZod4eZWVfibhxu0P0ZQ35cB=vDbde=VNeXiBZfED=k3YPOQ@mail.gmail.com>
References: <20220217094802.3644569-1-bigeasy@linutronix.de> <20220217094802.3644569-4-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uJsUkkYuKsFjmFuSrzJx6Z65BOc8raptsVlPvLM8N1M=;
        b=DQrnOr+7ZnH78FYvqffaE346vGIkV2x2C9ECWU9yqE4RVKdgMog75eA1y87iH06bUW
         xH0/fu78Skp4CvfXhzy6o2zYv3LGx/qwRJulidi4KrOjrA2U42XmP28RlZShOeNgqbka
         Cs4C0ETSQhG/vv/IDOf0o2HHaiUmd1ZFgIfwxIZLWbO/MOvqIYCazVduLcs8zp0wuuhI
         4+v5fciZgeeBNgdpAYcl2j/woTbUupNnDfY1AItJjxVg8pIpsVMjcLjfamvYsBd9zqnU
         mIcZXICCAD8nhgSnUNP4ziv0mZr+imOkr6s1d5lyGDxGlLaYYsjX1lA1RAZE9JqtUBeI
         EzSw==
In-Reply-To: <20220217094802.3644569-4-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Thu, Feb 17, 2022 at 1:48 AM Sebastian Andrzej Siewior
<bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
>
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
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> ---
>  mm/memcontrol.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0b5117ed2ae08..36ab3660f2c6d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -630,6 +630,28 @@ static DEFINE_SPINLOCK(stats_flush_lock);
>  static DEFINE_PER_CPU(unsigned int, stats_updates);
>  static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
>
> +/*
> + * Accessors to ensure that preemption is disabled on PREEMPT_RT because it can
> + * not rely on this as part of an acquired spinlock_t lock. These functions are
> + * never used in hardirq context on PREEMPT_RT and therefore disabling preemtion
> + * is sufficient.
> + */
> +static void memcg_stats_lock(void)
> +{
> +#ifdef CONFIG_PREEMPT_RT
> +      preempt_disable();
> +#else
> +      VM_BUG_ON(!irqs_disabled());
> +#endif
> +}
> +
> +static void memcg_stats_unlock(void)
> +{
> +#ifdef CONFIG_PREEMPT_RT
> +      preempt_enable();
> +#endif
> +}
> +
>  static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
>  {
>         unsigned int x;
> @@ -706,6 +728,7 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
>         pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
>         memcg = pn->memcg;)
>
> +       memcg_stats_lock();

The call chains from rmap.c have not really disabled irqs. Actually
there is a comment in do_page_add_anon_rmap() "We use the irq-unsafe
__{inc|mod}_zone_page_stat because these counters are not modified in
interrupt context, and pte lock(a spinlock) is held, which implies
preemption disabled".

VM_BUG_ON(!irqs_disabled()) within memcg_stats_lock() would be giving
false error reports for CONFIG_PREEMPT_NONE kernels.
