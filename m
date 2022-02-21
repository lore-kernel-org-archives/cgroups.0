From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v3 3/5] mm/memcg: Protect per-CPU counter by disabling
 preemption on PREEMPT_RT where needed.
Date: Mon, 21 Feb 2022 12:31:17 +0100
Message-ID: <YhN4BSQ1RLomLoyl@linutronix.de>
References: <20220217094802.3644569-1-bigeasy@linutronix.de>
 <20220217094802.3644569-4-bigeasy@linutronix.de>
 <CALvZod4eZWVfibhxu0P0ZQ35cB=vDbde=VNeXiBZfED=k3YPOQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645443078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RulSMPiCVHplqpEdAg1RSNzopKMgaNgDwROyd5kzhU4=;
        b=ygUsaiTcDR+YlYfCOVWfPbfQf/So/3FCW/1vcZ1r6O/gZ2uUd2cOkrbTYu7EXiVVCRtZB9
        9M5gS95vfitEMWKspuml850mok/MtwaGbTmnGPH4KXpZ//JvGcSHviDSp0eNDzMPY+cgle
        0G/uKP2CehjErGJMA6QkgawDKeQjXz8xuHYr30BOOZVmk1M3Ux4X6cK5nrhWHplRcNBhWz
        xoL0OnZqhIJvgUL/5J0D0ns6PohpEQ0vJS9wpvg941pIglsRnIxYIWNekdXaMM0L75qO29
        HP7MSCOivDHhNpSxDsPBeJJU2z5vxRscUEexNQo2/BjDO7F5CQ8cUxx/PiQD6g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645443078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RulSMPiCVHplqpEdAg1RSNzopKMgaNgDwROyd5kzhU4=;
        b=JYXtgNXu15YB09O4e1vbfUTzL3s4Xp30WcFxpRTR4AKtOAYP5bVC0eTdATimWakaj2Wcw0
        op4C0mo+TYJGeKDw==
Content-Disposition: inline
In-Reply-To: <CALvZod4eZWVfibhxu0P0ZQ35cB=vDbde=VNeXiBZfED=k3YPOQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On 2022-02-18 09:25:29 [-0800], Shakeel Butt wrote:
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 0b5117ed2ae08..36ab3660f2c6d 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -630,6 +630,28 @@ static DEFINE_SPINLOCK(stats_flush_lock);
> >  static DEFINE_PER_CPU(unsigned int, stats_updates);
> >  static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
> >
> > +/*
> > + * Accessors to ensure that preemption is disabled on PREEMPT_RT because it can
> > + * not rely on this as part of an acquired spinlock_t lock. These functions are
> > + * never used in hardirq context on PREEMPT_RT and therefore disabling preemtion
> > + * is sufficient.
> > + */
> > +static void memcg_stats_lock(void)
> > +{
> > +#ifdef CONFIG_PREEMPT_RT
> > +      preempt_disable();
> > +#else
> > +      VM_BUG_ON(!irqs_disabled());
> > +#endif
> > +}
> > +
> > +static void memcg_stats_unlock(void)
> > +{
> > +#ifdef CONFIG_PREEMPT_RT
> > +      preempt_enable();
> > +#endif
> > +}
> > +
> >  static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
> >  {
> >         unsigned int x;
> > @@ -706,6 +728,7 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
> >         pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> >         memcg = pn->memcg;)
> >
> > +       memcg_stats_lock();
> 
> The call chains from rmap.c have not really disabled irqs. Actually
> there is a comment in do_page_add_anon_rmap() "We use the irq-unsafe
> __{inc|mod}_zone_page_stat because these counters are not modified in
> interrupt context, and pte lock(a spinlock) is held, which implies
> preemption disabled".
> 
> VM_BUG_ON(!irqs_disabled()) within memcg_stats_lock() would be giving
> false error reports for CONFIG_PREEMPT_NONE kernels.

So three caller, including do_page_add_anon_rmap():
   __mod_lruvec_page_state() -> __mod_lruvec_state() -> __mod_memcg_lruvec_state()

is affected. Here we get false warnings because interrupts may not be
disabled and it is intended. Hmmm.
The odd part is that this only affects certain idx so any kind of
additional debugging would need to take this into account.
What about memcg_rstat_updated()? It does:

|         x = __this_cpu_add_return(stats_updates, abs(val));
|         if (x > MEMCG_CHARGE_BATCH) {
|                 atomic_add(x / MEMCG_CHARGE_BATCH, &stats_flush_threshold);
|                 __this_cpu_write(stats_updates, 0);
|         }

The writes to stats_updates can happen from IRQ-context and with
disabled preemption only. So this is not good, right?

Sebastian
