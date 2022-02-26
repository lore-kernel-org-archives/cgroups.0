From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: async flush memcg stats from perf sensitive codepaths
Date: Fri, 25 Feb 2022 16:24:12 -0800
Message-ID: <20220226002412.113819-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=c5XxepI0RiJzH9nImzDTpadEG2SO2IU4ZT8K2Wm0fgw=;
        b=iwU9nbdapI4QDtZoaxiJdFfKk1Aeelgfe69uZJ/lOO24OOX3A5QLJPiH4qboOUz+2t
         zQ09GP9qcVBfCxpp8LeUQrCciTFqyr3ZfNXtHmQcDdshuU8oBAZQYGNMMsLvF1rrJSy0
         xgl5ybIbuKPpkxSdP4WL+dvjKkd+mHI6inkn2YcaLxC09Mz1DhKHMnY5GFhO+SCythBy
         J5KTKZYcptRIR/A8cB0AHU+KBOeaXdbwJSaeFWuzemzTsZh9FW8r2PUqyNenl0z+4moK
         scvXa+QlOZ7lJ9J3duby8Kr1w1z/3ERSbJTInf29y1U66/ojmBs2Psy+xnZMhY6dGx+E
         5nFA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Daniel Dao <dqminh-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Daniel Dao has reported [1] a regression on workloads that may trigger
a lot of refaults (anon and file). The underlying issue is that flushing
rstat is expensive. Although rstat flush are batched with (nr_cpus *
MEMCG_BATCH) stat updates, it seems like there are workloads which
genuinely do stat updates larger than batch value within short amount of
time. Since the rstat flush can happen in the performance critical
codepaths like page faults, such workload can suffer greatly.

The easiest fix for now is for performance critical codepaths trigger
the rstat flush asynchronously. This patch converts the refault codepath
to use async rstat flush. In addition, this patch has premptively
converted mem_cgroup_wb_stats and shrink_node to also use the async
rstat flush as they may also similar performance regressions.

Link: https://lore.kernel.org/all/CA+wXwBSyO87ZX5PVwdHm-=dBjZYECGmfnydUicUyrQqndgX2MQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org [1]
Fixes: 1f828223b799 ("memcg: flush lruvec stats in the refault")
Reported-by: Daniel Dao <dqminh-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 10 +++++++++-
 mm/vmscan.c                |  2 +-
 mm/workingset.c            |  2 +-
 4 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ef4b445392a9..bfdd48be60ff 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -998,6 +998,7 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 }
 
 void mem_cgroup_flush_stats(void);
+void mem_cgroup_flush_stats_async(void);
 
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			      int val);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c695608c521c..4338e8d779b2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -690,6 +690,14 @@ void mem_cgroup_flush_stats(void)
 		__mem_cgroup_flush_stats();
 }
 
+void mem_cgroup_flush_stats_async(void)
+{
+	if (atomic_read(&stats_flush_threshold) > num_online_cpus()) {
+		atomic_set(&stats_flush_threshold, 0);
+		mod_delayed_work(system_unbound_wq, &stats_flush_dwork, 0);
+	}
+}
+
 static void flush_memcg_stats_dwork(struct work_struct *w)
 {
 	__mem_cgroup_flush_stats();
@@ -4522,7 +4530,7 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
 
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats_async();
 
 	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
 	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c6f77e3e6d59..b6c6b165c1ef 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3188,7 +3188,7 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 	 * Flush the memory cgroup stats, so that we read accurate per-memcg
 	 * lruvec stats for heuristics.
 	 */
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats_async();
 
 	memset(&sc->nr, 0, sizeof(sc->nr));
 
diff --git a/mm/workingset.c b/mm/workingset.c
index b717eae4e0dd..a4f2b1aa5bcc 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -355,7 +355,7 @@ void workingset_refault(struct folio *folio, void *shadow)
 
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats_async();
 	/*
 	 * Compare the distance to the existing workingset size. We
 	 * don't activate pages that couldn't stay resident even if
-- 
2.35.1.574.g5d30c73bfb-goog

