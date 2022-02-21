From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [PATCH v4 6/6] mm/memcg: Disable migration instead of preemption in drain_all_stock().
Date: Mon, 21 Feb 2022 19:25:40 +0100
Message-ID: <20220221182540.380526-7-bigeasy@linutronix.de>
References: <20220221182540.380526-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645467969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gvKLAjshqPjuJx5ztcwEtexZwZtdDzb7fAKUE2HVkQU=;
        b=PEzb3aIxfpjcvav45uwZ/XAP5tsylptBaf3coAMien+gIDOi0YgXo5W4taoeELpQnpJoQG
        dQwtURHyc3f2B992/qnd7aSncUnevwjtF2DQyTpU5LXD6Wl7xRHEIpycSFxb/io7sZlB/H
        QCw1DctrICIXLOOj1FFz3rrHknrGZWyKHfwKfHhgAp2NjrekZJScmRrh0nQErd6rv4L10c
        Wl9YiTaqNcTbElCaUKxzb5UhpUeAfmGnwVG294T8xFTjlnlBhA8iltld2TleYSsFFAdMNl
        sUs/8ovN0BpRyW3awA/TUkX/pHzD11/0ubUQ9rJqtsGL/DxIx29YFtNrQ7s4Wg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645467969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gvKLAjshqPjuJx5ztcwEtexZwZtdDzb7fAKUE2HVkQU=;
        b=HNtHCBGBc/LlVUnDbybDcjrsjJz/mWiGnlx9SA6zjIRlEJG006jryfCkj40bgGuuuO8Zqp
        gJRFgF773pmfxiCQ==
In-Reply-To: <20220221182540.380526-1-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Before the for-each-CPU loop, preemption is disabled so that so that
drain_local_stock() can be invoked directly instead of scheduling a
worker. Ensuring that drain_local_stock() completed on the local CPU is
not correctness problem. It _could_ be that the charging path will be
forced to reclaim memory because cached charges are still waiting for
their draining.

Disabling preemption before invoking drain_local_stock() is problematic
on PREEMPT_RT due to the sleeping locks involved. To ensure that no CPU
migrations happens across the for_each_online_cpu() it is enouhg to use
migrate_disable() which disables migration and keeps context preemptible
to a sleeping lock can be acquired.

Use migrate_disable() instead of get_cpu() around the
for_each_online_cpu() loop.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---
 mm/memcontrol.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3d7ccb104374c..9c29b1a0e6bec 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2293,7 +2293,8 @@ static void drain_all_stock(struct mem_cgroup *root_m=
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
@@ -2316,7 +2317,7 @@ static void drain_all_stock(struct mem_cgroup *root_m=
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

