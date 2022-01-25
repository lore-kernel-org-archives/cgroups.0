From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [PATCH 2/4] mm/memcg: Protect per-CPU counter by disabling preemption on PREEMPT_RT where needed.
Date: Tue, 25 Jan 2022 17:43:35 +0100
Message-ID: <20220125164337.2071854-3-bigeasy@linutronix.de>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643129023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kssWja8AcLmfLvl1uaYz9JdYKOU1whUKqM7uXu9+L88=;
        b=GBnx7cgLFTcbVyQ/Q+alsUQWbr4UcDhBg23jZ4wgHrUwwuqtifn8uQAjXiwyNqIO/G0vTB
        QPeayPJKb62ciMf/bavQRmI/8LD8RAAouNXxogwe+7gXbnr4k1/dREOU0Xzf6fuwa6bLBp
        crQGWuELODMIe5AA5/LdVbmnoxZuVH/nOlJu41iaFBhBPgcAcOjCc2pyQUVZTHCHbln8Hr
        E9dsv+2Ds+H8cnONMxmPemztfW5H8rNr6vRo6LXhlO3Rkwfiui0mHMwzfVFg8mSwz63m+B
        bp8f+kQ16QQB1dz6QKMZUTOVN1iiDQbYA3SAq089CzYeU0n7JPdYKxvGRssniw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643129023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kssWja8AcLmfLvl1uaYz9JdYKOU1whUKqM7uXu9+L88=;
        b=kfupKdh4Zcr2PH0nfRsWpBdXCc1KpYrqVL7NCWTcRk3XkXKdcdx1C905K5ReYv7OsPjosi
        kS7NZ+DXUfjU7yBA==
In-Reply-To: <20220125164337.2071854-1-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

The per-CPU counter are modified with the non-atomic modifier. The
consistency is ensured by disabling interrupts for the update.
On non PREEMPT_RT configuration this works because acquiring a
spinlock_t typed lock with the _irq() suffix disables interrupts. On
PREEMPT_RT configurations the RMW operation can be interrupted.

Another problem is that mem_cgroup_swapout() expects to be invoked with
disabled interrupts because the caller has to acquire a spinlock_t which
is acquired with disabled interrupts. Since spinlock_t never disables
interrupts on PREEMPT_RT the interrupts are never disabled at this
point.

The code is never called from in_irq() context on PREEMPT_RT therefore
disabling preemption during the update is sufficient on PREEMPT_RT.
The sections which explicitly disable interrupts can remain on
PREEMPT_RT because the sections remain short and they don't involve
sleeping locks (memcg_check_events() is doing nothing on PREEMPT_RT).

Disable preemption during update of the per-CPU variables which do not
explicitly disable interrupts.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---
 mm/memcontrol.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 36d27db673ca9..3d1b7cdd83db0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -667,6 +667,8 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, en=
um node_stat_item idx,
 	pn =3D container_of(lruvec, struct mem_cgroup_per_node, lruvec);
 	memcg =3D pn->memcg;
=20
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
 	/* Update memcg */
 	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
=20
@@ -674,6 +676,8 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, en=
um node_stat_item idx,
 	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
=20
 	memcg_rstat_updated(memcg, val);
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
 }
=20
 /**
@@ -756,8 +760,12 @@ void __count_memcg_events(struct mem_cgroup *memcg, en=
um vm_event_item idx,
 	if (mem_cgroup_disabled())
 		return;
=20
+	if (IS_ENABLED(PREEMPT_RT))
+		preempt_disable();
 	__this_cpu_add(memcg->vmstats_percpu->events[idx], count);
 	memcg_rstat_updated(memcg, count);
+	if (IS_ENABLED(PREEMPT_RT))
+		preempt_enable();
 }
=20
 static unsigned long memcg_events(struct mem_cgroup *memcg, int event)
@@ -7194,9 +7202,18 @@ void mem_cgroup_swapout(struct page *page, swp_entry=
_t entry)
 	 * i_pages lock which is taken with interrupts-off. It is
 	 * important here to have the interrupts disabled because it is the
 	 * only synchronisation we have for updating the per-CPU variables.
+	 * On PREEMPT_RT interrupts are never disabled and the updates to per-CPU
+	 * variables are synchronised by keeping preemption disabled.
 	 */
-	VM_BUG_ON(!irqs_disabled());
-	mem_cgroup_charge_statistics(memcg, -nr_entries);
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT)) {
+		VM_BUG_ON(!irqs_disabled());
+		mem_cgroup_charge_statistics(memcg, -nr_entries);
+	} else {
+		preempt_disable();
+		mem_cgroup_charge_statistics(memcg, -nr_entries);
+		preempt_enable();
+	}
+
 	memcg_check_events(memcg, page_to_nid(page));
=20
 	css_put(&memcg->css);
--=20
2.34.1

