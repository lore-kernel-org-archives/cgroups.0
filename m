From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [PATCH v5 6/6] mm/memcg: Disable migration instead of preemption in drain_all_stock().
Date: Sat, 26 Feb 2022 21:41:44 +0100
Message-ID: <20220226204144.1008339-7-bigeasy@linutronix.de>
References: <20220226204144.1008339-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645908112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VuB/1jlIhEyPDsXw/VrUOxUQMh/b8hRGxZ9Q00QMyEw=;
        b=Ft6l+vfY/mtjKmilohDaR2FygjHI2QE8zu8W3iTBIBD8onmMtmfYo1oeZ8oEnQ/p2xDuPu
        ALZbRB6CepCK5z0ICaHCoqUQ07bv3yGEKNvnp4tiClDYlySh7fSfuV+dhGfFewOkMFOoWV
        1ADT4IB+uN99kBJP3GJz9OcBVMfz0G8gksA7ihnaHs7n+pXZPuzAvCKN2g8F9lj+yByvxh
        sx8cBN8dWgurKJyknZZMN27qKIeR6h+xJiRG6tvZvHrcntnvTSDg1ulpejxFkKP59UYGs7
        PCn+0EGrzV9TUYn1BmCmV7LIYciewy75tr2gacolu2k4NiMUjaEphkpS/Cq/Mw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645908112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VuB/1jlIhEyPDsXw/VrUOxUQMh/b8hRGxZ9Q00QMyEw=;
        b=vwOE5noON8Etg+MQn1ibZzISWjg5NtyzZxugs4RVno03ttWjNyc0HuiLypBCngSlgscdhl
        ZPuggoD0HSrn9LCA==
In-Reply-To: <20220226204144.1008339-1-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Before the for-each-CPU loop, preemption is disabled so that so that
drain_local_stock() can be invoked directly instead of scheduling a
worker. Ensuring that drain_local_stock() completed on the local CPU is
not correctness problem. It _could_ be that the charging path will be
forced to reclaim memory because cached charges are still waiting for
their draining.

Disabling preemption before invoking drain_local_stock() is problematic
on PREEMPT_RT due to the sleeping locks involved. To ensure that no CPU
migrations happens across for_each_online_cpu() it is enouhg to use
migrate_disable() which disables migration and keeps context preemptible
to a sleeping lock can be acquired.
A race with CPU hotplug is not a problem because pcp data is not going away.
In the worst case we just schedule draining of an empty stock.

Use migrate_disable() instead of get_cpu() around the
for_each_online_cpu() loop.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
---
 mm/memcontrol.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6439b0089d392..89664d8094bc0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2300,7 +2300,8 @@ static void drain_all_stock(struct mem_cgroup *root_m=
emcg)
 	 * as well as workers from this path always operate on the local
 	 * per-cpu data. CPU up doesn't touch memcg_stock at all.
 	 */
-	curcpu =3D get_cpu();
+	migrate_disable();
+	curcpu =3D smp_processor_id();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock =3D &per_cpu(memcg_stock, cpu);
 		struct mem_cgroup *memcg;
@@ -2323,7 +2324,7 @@ static void drain_all_stock(struct mem_cgroup *root_m=
emcg)
 				schedule_work_on(cpu, &stock->work);
 		}
 	}
-	put_cpu();
+	migrate_enable();
 	mutex_unlock(&percpu_charge_mutex);
 }
=20
--=20
2.35.1

