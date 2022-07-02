From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH] mm: memcontrol: do not miss MEMCG_MAX events for enforced allocations
Date: Fri,  1 Jul 2022 20:35:21 -0700
Message-ID: <20220702033521.64630-1-roman.gushchin@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656732927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5sJ9uAjGXNyMkD0Jws/tWJBNd8knl6wtG6bq/f3YA7w=;
        b=sN8WCsmhKE0KUzCtuUtNjLT4uIP1cnh0sTirAyamJQmyquM0V+MwIleKB6UgonvFvXJ5vb
        RDMTVlTI0VPdjJnoYpUPGnl0prK2MNe9fEzyVUAY8oSVt0YAAKW9L5g0shONzuv5aqN7Ir
        726K4nIwztR3n+CltroepxVNRkuXoYw=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Yafang Shao <laoar.shao@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

Yafang Shao reported an issue related to the accounting of bpf
memory: if a bpf map is charged indirectly for memory consumed
from an interrupt context and allocations are enforced, MEMCG_MAX
events are not raised.

It's not/less of an issue in a generic case because consequent
allocations from a process context will trigger the reclaim and
MEMCG_MAX events. However a bpf map can belong to a dying/abandoned
memory cgroup, so it might never happen. So the cgroup can
significantly exceed the memory.max limit without even triggering
MEMCG_MAX events.

Fix this by making sure that we never enforce allocations without
raising a MEMCG_MAX event.

Reported-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: bpf@vger.kernel.org
---
 mm/memcontrol.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 655c09393ad5..eb383695659a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2577,6 +2577,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool passed_oom = false;
 	bool may_swap = true;
 	bool drained = false;
+	bool raised_max_event = false;
 	unsigned long pflags;
 
 retry:
@@ -2616,6 +2617,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto nomem;
 
 	memcg_memory_event(mem_over_limit, MEMCG_MAX);
+	raised_max_event = true;
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
@@ -2682,6 +2684,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
 		return -ENOMEM;
 force:
+	/*
+	 * If the allocation has to be enforced, don't forget to raise
+	 * a MEMCG_MAX event.
+	 */
+	if (!raised_max_event)
+		memcg_memory_event(mem_over_limit, MEMCG_MAX);
+
 	/*
 	 * The allocation either can't fail or will lead to more memory
 	 * being freed very soon.  Allow memory usage go over the limit
-- 
2.36.1

