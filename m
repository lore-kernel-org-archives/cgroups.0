From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v3 3/5] mm/memcg: Protect per-CPU counter by disabling
 preemption on PREEMPT_RT where needed.
Date: Mon, 21 Feb 2022 13:12:55 +0100
Message-ID: <YhOBxzv+4OuYMCqa@linutronix.de>
References: <20220217094802.3644569-1-bigeasy@linutronix.de>
 <20220217094802.3644569-4-bigeasy@linutronix.de>
 <CALvZod4eZWVfibhxu0P0ZQ35cB=vDbde=VNeXiBZfED=k3YPOQ@mail.gmail.com>
 <YhN4BSQ1RLomLoyl@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645445577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yd/Pv+4yxzI82Y3+KCMMwqZi8uHiedOULtnxyEsK9t8=;
        b=m3j5uZqP2GnBz9hR9+ahcnj5LxQ2aWpUFQWTc7iK8aShO6qeDylvW3GDy0Y/y1umG/5PwK
        VxOLm+MUozqKrjqM0G04ESo/lBfFZ0h+ZMjVk4m88VhPuM48tw+0TYVWYDKEsdRpzXgEl5
        p5dzpEZ/O9sRbmkp+V1hQVvocMXOAUZL7/jpatstowYBwKVAMrwiANNR0YUbXLIqIxJwsW
        hYruaD48dcrYGwsXMmRo2GfzlU6sxZDRcNesCoaa2IA3cwHTNJrTRUlW7MA8NXa+WueGle
        zkN2DcDejQNJq3/tXQN9Ll9CxWj46szVpZ0p/Qf6Hiwma8poJcFCpCe1ZLEQvQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645445577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yd/Pv+4yxzI82Y3+KCMMwqZi8uHiedOULtnxyEsK9t8=;
        b=6+LQBW68DRyoQknMvgtM57egwQzQtY3fDE2Hj5+0FOFcN17uowYcI+ITQiy/OpYjcowS1T
        upjLeYDCV0zU35Dw==
Content-Disposition: inline
In-Reply-To: <YhN4BSQ1RLomLoyl-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On 2022-02-21 12:31:18 [+0100], To Shakeel Butt wrote:
> > The call chains from rmap.c have not really disabled irqs. Actually
> > there is a comment in do_page_add_anon_rmap() "We use the irq-unsafe
> > __{inc|mod}_zone_page_stat because these counters are not modified in
> > interrupt context, and pte lock(a spinlock) is held, which implies
> > preemption disabled".
> > 
> > VM_BUG_ON(!irqs_disabled()) within memcg_stats_lock() would be giving
> > false error reports for CONFIG_PREEMPT_NONE kernels.
> 
> So three caller, including do_page_add_anon_rmap():
>    __mod_lruvec_page_state() -> __mod_lruvec_state() -> __mod_memcg_lruvec_state()
> 
> is affected. Here we get false warnings because interrupts may not be
> disabled and it is intended. Hmmm.
> The odd part is that this only affects certain idx so any kind of
> additional debugging would need to take this into account.
> What about memcg_rstat_updated()? It does:
> 
> |         x = __this_cpu_add_return(stats_updates, abs(val));
> |         if (x > MEMCG_CHARGE_BATCH) {
> |                 atomic_add(x / MEMCG_CHARGE_BATCH, &stats_flush_threshold);
> |                 __this_cpu_write(stats_updates, 0);
> |         }
> 
> The writes to stats_updates can happen from IRQ-context and with
> disabled preemption only. So this is not good, right?

So I made the following to avoid the wrong assert. Still not sure how
bad the hunk above.

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 97a88b63ee983..1bac4798b72ba 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -645,6 +645,13 @@ static void memcg_stats_lock(void)
 #endif
 }
 
+static void __memcg_stats_lock(void)
+{
+#ifdef CONFIG_PREEMPT_RT
+      preempt_disable();
+#endif
+}
+
 static void memcg_stats_unlock(void)
 {
 #ifdef CONFIG_PREEMPT_RT
@@ -728,7 +735,20 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
 	memcg = pn->memcg;
 
-	memcg_stats_lock();
+	/*
+	 * The caller from rmap relay on disabled preemption becase they never
+	 * update their counter from in-interrupt context. For these two
+	 * counters we check that the update is never performed from an
+	 * interrupt context while other caller need to have disabled interrupt.
+	 */
+	__memcg_stats_lock();
+	if (IS_ENABLED(CONFIG_DEBUG_VM)) {
+		if (idx == NR_ANON_MAPPED || idx == NR_FILE_MAPPED)
+			WARN_ON_ONCE(!in_task());
+		else
+			WARN_ON_ONCE(!irqs_disabled());
+	}
+
 	/* Update memcg */
 	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
 

Sebastian
