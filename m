From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Fri, 3 Feb 2023 16:21:09 +0100
Message-ID: <Y90mZQhW89HtYfT9@dhcp22.suse.cz>
References: <20230125073502.743446-1-leobras@redhat.com>
 <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
 <Y9G36AiqPPFDlax3@P9FQF9L96D.corp.robot.car>
 <Y9Iurktut9B9T+Tl@dhcp22.suse.cz>
 <Y9MI42NSLooyVZNu@P9FQF9L96D.corp.robot.car>
 <Y9N5CI8PpsfiaY9c@dhcp22.suse.cz>
 <Y9PYe1X7dRQOcahg@dhcp22.suse.cz>
 <Y9QVWwAreTlDVdZ0@P9FQF9L96D.corp.robot.car>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675437670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+71rVrs5ZtdXbUgSgq6MBdY/wG/sltNAW0iIaM9D09U=;
        b=k5S9UVYKf/aovkCa8B4Dl6MXE7YfOvX+foI5ZXfG/2sotHPrv7SJRxEqcpu6Q6LXB/Yne7
        yf8F690NY4F0U9QNOOSmEAqkoR7wY0NbCc0oqX46KuZR9PO4nzXKkIChygBlio4kLsri57
        xmr6ZvvrrXx1WRqSO0Tqp+oiDndKnQQ=
Content-Disposition: inline
In-Reply-To: <Y9QVWwAreTlDVdZ0-+xijCwNIfdoLQcUKs7qKB+WAnPUfkyWGUBSOeVevoDU@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbecker-l3A5Bk7waGM@public.gmane.org>

OK, so this is a speculative patch. cpu_is_isolated doesn't exist yet. I
have talked to Frederic off-list and he is working on an implementation.
I will be offline next whole week (will be back Feb 13th) so I am
sending this early but this patch cannot be merged without his one of
course.

I have tried to summarize the reasoning behind both approach should we
ever need to revisit this approach. For now I strongly believe a simpler
solution should be preferred.

Roman, I have added your ack as you indicated but if you disagree with
the reasoning please let me know.
--- 
From 6d99c4d7a238809ff2eb7c362b45d002ca212c70 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Date: Fri, 3 Feb 2023 15:54:38 +0100
Subject: [PATCH] memcg: do not drain charge pcp caches on remote isolated cpus

Leonardo Bras has noticed that pcp charge cache draining might be
disruptive on workloads relying on 'isolated cpus', a feature commonly
used on workloads that are sensitive to interruption and context
switching such as vRAN and Industrial Control Systems.

There are essentially two ways how to approach the issue. We can either
allow the pcp cache to be drained on a different rather than a local cpu
or avoid remote flushing on isolated cpus.

The current pcp charge cache is really optimized for high performance
and it always relies to stick with its cpu. That means it only requires
local_lock (preempt_disable on !RT) and draining is handed over to pcp
WQ to drain locally again.

The former solution (remote draining) would require to add an additional
locking to prevent local charges from racing with the draining. This
adds an atomic operation to otherwise simple arithmetic fast path in the
try_charge path. Another concern is that the remote draining can cause a
lock contention for the isolated workloads and therefore interfere with
it indirectly via user space interfaces.

Another option is to avoid draining scheduling on isolated cpus
altogether. That means that those remote cpus would keep their charges
even after drain_all_stock returns. This is certainly not optimal either
but it shouldn't really cause any major problems. In the worst case
(many isolated cpus with charges - each of them with MEMCG_CHARGE_BATCH
i.e 64 page) the memory consumption of a memcg would be artificially
higher than can be immediately used from other cpus.

Theoretically a memcg OOM killer could be triggered pre-maturely.
Currently it is not really clear whether this is a practical problem
though. Tight memcg limit would be really counter productive to cpu
isolated workloads pretty much by definition because any memory
reclaimed induced by memcg limit could break user space timing
expectations as those usually expect execution in the userspace most of
the time.

Also charges could be left behind on memcg removal. Any future charge on
those isolated cpus will drain that pcp cache so this won't be a
permanent leak.

Considering cons and pros of both approaches this patch is implementing
the second option and simply do not schedule remote draining if the
target cpu is isolated. This solution is much more simpler. It doesn't
add any new locking and it is more more predictable from the user space
POV. Should the pre-mature memcg OOM become a real life problem, we can
revisit this decision.

Reported-by: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Signed-off-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ab457f0394ab..55e440e54504 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2357,7 +2357,7 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
 		    !test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags)) {
 			if (cpu == curcpu)
 				drain_local_stock(&stock->work);
-			else
+			else if (!cpu_is_isolated(cpu))
 				schedule_work_on(cpu, &stock->work);
 		}
 	}
-- 
2.30.2

-- 
Michal Hocko
SUSE Labs
