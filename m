From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 6/8] memcg: add stats for offline memcgs recharging
Date: Thu, 20 Jul 2023 07:08:23 +0000
Message-ID: <20230720070825.992023-7-yosryahmed@google.com>
References: <20230720070825.992023-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689836919; x=1692428919;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YhI2s0e+GIGqReCnHtRMQPrzSnIqjbw1XBQvBPYjKY0=;
        b=oBM+gyrvc4kZmfzCDqqW014mddb+6ng6aUJcvm1PGzKPmmatk8vBmxnaO+jvawg8Cc
         cf0h8c+uRGKv+PpUjZOjju465YCs/RMkGS7FOfpfBg905u8KA48PZPv9pv5l5xU64hAu
         RRIbJwf2dG4G9KtiFyA18EerxfR/ghn9NkJLcaUskUA8yTC4t3T0XaugdSZxINO7vhKx
         oM7NXvmkzb7JDGBaiO8CTn60src/z33GmAEJWb+ZSh6IMofXorSGDhYJD6lnOVdfNi/O
         3BRMWtylTLjUhnMgpCj7SaSMPCTWyEH1d0Cr6gcddMeYKbX7Wxwr5jKmhdVPpppLRUDQ
         nHOQ==
In-Reply-To: <20230720070825.992023-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Add vm events for scanning pages for recharge, successfully recharging
pages, and cancelling a recharge due to failure to charge the target
memcg.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/vm_event_item.h | 5 +++++
 mm/memcontrol.c               | 6 ++++++
 mm/vmstat.c                   | 6 +++++-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 8abfa1240040..cd80c00c50c2 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -60,6 +60,11 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		PAGEOUTRUN, PGROTATED,
 		DROP_PAGECACHE, DROP_SLAB,
 		OOM_KILL,
+#ifdef CONFIG_MEMCG
+		RECHARGE_PGSCANNED,
+		RECHARGE_PGMOVED,
+		RECHARGE_PGCANCELLED,
+#endif
 #ifdef CONFIG_NUMA_BALANCING
 		NUMA_PTE_UPDATES,
 		NUMA_HUGE_PTE_UPDATES,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cf9fb51ecfcc..2fe9c6f1be80 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6394,6 +6394,8 @@ static bool mem_cgroup_recharge_folio(struct folio *folio,
 				      old_memcg, new_memcg);
 	cancel_charge(err ? new_memcg : old_memcg, nr_pages);
 out:
+	count_vm_events(err ? RECHARGE_PGCANCELLED : RECHARGE_PGMOVED,
+			nr_pages);
 	return err == 0;
 }
 
@@ -6469,6 +6471,7 @@ static bool memcg_recharge_lruvec_list(struct lruvec *lruvec,
 	int isolated_idx = NR_ISOLATED_ANON + is_file_lru(lru);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	unsigned long *nr_recharged = arg;
+	unsigned long nr_scanned = 0;
 	unsigned long nr_staged = 0;
 	LIST_HEAD(folios_skipped);
 	LIST_HEAD(folios_staged);
@@ -6505,6 +6508,7 @@ static bool memcg_recharge_lruvec_list(struct lruvec *lruvec,
 			continue;
 		}
 
+		nr_scanned += folio_nr_pages(folio);
 		if (unlikely(!folio_try_get(folio))) {
 			list_move(&folio->lru, &folios_skipped);
 			continue;
@@ -6543,6 +6547,7 @@ static bool memcg_recharge_lruvec_list(struct lruvec *lruvec,
 	}
 	mem_cgroup_end_move_charge(memcg);
 	mod_lruvec_state(lruvec, isolated_idx, -nr_staged);
+	count_vm_events(RECHARGE_PGSCANNED, nr_scanned);
 	return false;
 }
 
@@ -6679,6 +6684,7 @@ void folio_memcg_deferred_recharge(struct folio *folio)
 	if (unlikely(!memcg_recharge_wq))
 		return;
 
+	count_vm_events(RECHARGE_PGSCANNED, folio_nr_pages(folio));
 	if (unlikely(!folio_try_get(folio)))
 		return;
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index b731d57996c5..e425a1aa7890 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1303,7 +1303,11 @@ const char * const vmstat_text[] = {
 	"drop_pagecache",
 	"drop_slab",
 	"oom_kill",
-
+#ifdef CONFIG_MEMCG
+	"recharge_pgs_scanned",
+	"recharge_pgs_moved",
+	"recharge_pgs_cancelled",
+#endif
 #ifdef CONFIG_NUMA_BALANCING
 	"numa_pte_updates",
 	"numa_huge_pte_updates",
-- 
2.41.0.255.g8b1d071c50-goog

