From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH mm-unstable RFC 3/5] memcg: calculate root usage from global state
Date: Mon,  3 Apr 2023 22:03:35 +0000
Message-ID: <20230403220337.443510-4-yosryahmed@google.com>
References: <20230403220337.443510-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680559424;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kF9j9xhVt+HAtgUv/sW6MmUPAVRA6NHiHn3mXAJRGAA=;
        b=QZZrc3A9Ala3Y1fUrUeH9aHQEpEHIm56zSkCNE0A0d2CfnkVvyEn83miymwgAbVi5v
         9d0zVCVjgbHefP1pXO+Nwo1Ul1PtmNl2tpG2LpPChio/My4WZElf1o1jchSNOgvJZUsW
         WbV5lrmHTcH3fAqoJ7gZenJSRA3/dWbn3kNYUTeryGOWXdDf83/N+i1IFVKcpHglHDCj
         nH4nWeMmhgItD/X0NlX5brqxxgrkgNj//KowEl9SOf+dOa58iks3E9glke7V87blHVFo
         T2x7kiC5rzRzeUUzMZ/tXlij1MqA5Wi+XXZnHplS+57XrL+yaVLwig14jPX/om3gIc+M
         IAag==
In-Reply-To: <20230403220337.443510-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Yosry Ahmed <yosryahmed@google.com>

Currently, we approximate the root usage by adding the memcg stats for
anon, file, and conditionally swap (for memsw). To read the memcg stats
we need to invoke an rstat flush. rstat flushes can be expensive, they
scale with the number of cpus and cgroups on the system.

mem_cgroup_usage() is called by memcg_events()->mem_cgroup_threshold()
with irqs disabled, so such an expensive operation with irqs disabled
can cause problems.

Instead, approximate the root usage from global state. This is not 100%
accurate, but the root usage has always been ill-defined anyway.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 mm/memcontrol.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bdd52fe9e7e4b..e7fe18c0c0ef2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3698,27 +3698,13 @@ static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 
 	if (mem_cgroup_is_root(memcg)) {
 		/*
-		 * We can reach here from irq context through:
-		 * uncharge_batch()
-		 * |--memcg_check_events()
-		 *    |--mem_cgroup_threshold()
-		 *       |--__mem_cgroup_threshold()
-		 *          |--mem_cgroup_usage
-		 *
-		 * rstat flushing is an expensive operation that should not be
-		 * done from irq context; use stale stats in this case.
-		 * Arguably, usage threshold events are not reliable on the root
-		 * memcg anyway since its usage is ill-defined.
-		 *
-		 * Additionally, other call paths through memcg_check_events()
-		 * disable irqs, so make sure we are flushing stats atomically.
+		 * Approximate root's usage from global state. This isn't
+		 * perfect, but the root usage was always an approximation.
 		 */
-		if (in_task())
-			mem_cgroup_flush_stats_atomic();
-		val = memcg_page_state(memcg, NR_FILE_PAGES) +
-			memcg_page_state(memcg, NR_ANON_MAPPED);
+		val = global_node_page_state(NR_FILE_PAGES) +
+			global_node_page_state(NR_ANON_MAPPED);
 		if (swap)
-			val += memcg_page_state(memcg, MEMCG_SWAP);
+			val += total_swap_pages - get_nr_swap_pages();
 	} else {
 		if (!swap)
 			val = page_counter_read(&memcg->memory);
-- 
2.40.0.348.gf938b09366-goog

