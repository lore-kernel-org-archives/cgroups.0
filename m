From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 1/4] mm: memcontrol: clean up memory.events counting function
Date: Tue,  4 Apr 2017 18:01:45 -0400
Message-ID: <20170404220148.28338-1-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SIQTHITrA2LsixNOaxX/PQ/nwlyqUVVfjjWOpNvy7hk=; b=egPS7QQNAepm5xKlfeFTbWfVEH
	UVXRzFinIrr/PlA6XQLNw3UBaaAJFttX/q7Xanl7aQ3ffNKpwoXoS5YEG53oHFBwhmB0ovRpn0H2I
	X8g3REsR+SD7lxL+9tKqe3m0faGkPqq53QrV45SGm1d4soakquAXDakoeauwGS+ed1sk=;
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

We only ever count single events, drop the @nr parameter. Rename the
function accordingly. Remove low-information kerneldoc.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/memcontrol.h | 18 +++++-------------
 mm/memcontrol.c            |  8 ++++----
 mm/vmscan.c                |  2 +-
 3 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index cfa91a3ca0ca..bc0c16e284c0 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -287,17 +287,10 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
-/**
- * mem_cgroup_events - count memory events against a cgroup
- * @memcg: the memory cgroup
- * @idx: the event index
- * @nr: the number of events to account for
- */
-static inline void mem_cgroup_events(struct mem_cgroup *memcg,
-		       enum mem_cgroup_events_index idx,
-		       unsigned int nr)
+static inline void mem_cgroup_event(struct mem_cgroup *memcg,
+				    enum mem_cgroup_events_index idx)
 {
-	this_cpu_add(memcg->stat->events[idx], nr);
+	this_cpu_inc(memcg->stat->events[idx]);
 	cgroup_file_notify(&memcg->events_file);
 }
 
@@ -614,9 +607,8 @@ static inline bool mem_cgroup_disabled(void)
 	return true;
 }
 
-static inline void mem_cgroup_events(struct mem_cgroup *memcg,
-				     enum mem_cgroup_events_index idx,
-				     unsigned int nr)
+static inline void mem_cgroup_event(struct mem_cgroup *memcg,
+				    enum mem_cgroup_events_index idx)
 {
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 108d5b097db1..1ffa3ad201ea 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1825,7 +1825,7 @@ static void reclaim_high(struct mem_cgroup *memcg,
 	do {
 		if (page_counter_read(&memcg->memory) <= memcg->high)
 			continue;
-		mem_cgroup_events(memcg, MEMCG_HIGH, 1);
+		mem_cgroup_event(memcg, MEMCG_HIGH);
 		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
 	} while ((memcg = parent_mem_cgroup(memcg)));
 }
@@ -1916,7 +1916,7 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (!gfpflags_allow_blocking(gfp_mask))
 		goto nomem;
 
-	mem_cgroup_events(mem_over_limit, MEMCG_MAX, 1);
+	mem_cgroup_event(mem_over_limit, MEMCG_MAX);
 
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
 						    gfp_mask, may_swap);
@@ -1959,7 +1959,7 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (fatal_signal_pending(current))
 		goto force;
 
-	mem_cgroup_events(mem_over_limit, MEMCG_OOM, 1);
+	mem_cgroup_event(mem_over_limit, MEMCG_OOM);
 
 	mem_cgroup_oom(mem_over_limit, gfp_mask,
 		       get_order(nr_pages * PAGE_SIZE));
@@ -5142,7 +5142,7 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 			continue;
 		}
 
-		mem_cgroup_events(memcg, MEMCG_OOM, 1);
+		mem_cgroup_event(memcg, MEMCG_OOM);
 		if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0))
 			break;
 	}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b3f62cf37097..18731310ca36 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2526,7 +2526,7 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 					sc->memcg_low_skipped = 1;
 					continue;
 				}
-				mem_cgroup_events(memcg, MEMCG_LOW, 1);
+				mem_cgroup_event(memcg, MEMCG_LOW);
 			}
 
 			reclaimed = sc->nr_reclaimed;
-- 
2.12.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
