From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] memcg: infrastructure to flush memcg stats
Date: Tue, 13 Jul 2021 13:24:12 -0700
Message-ID: <20210713202412.248252-2-shakeelb@google.com>
References: <20210713202412.248252-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EHAYE05GAu+niMbde+c2BkAYKkWBFNQ1NKRMcAVAVMc=;
        b=gKeP0lrlLzavl+bP2FEXh/IMOv/on+DOO4SjIuZd90lujGClYWiPwVADRjnqM6k4rL
         VUdsQJeumADj1m9LGp5Kb+Vgd1H8iFqcTZjsVOUDQ5e4PPf7bET8MCIOGQhMiyyaNm3X
         mdTHi7e0RJQ3gvmuWttCxxw9rfydRGVRrObaNXXYipMVOUlUldWoCgaXawR4RpU5uYZ1
         sPyayHFWIth2GWlSa8CSPGgj83LtxlEG8em/J7DD/6RJL9K0eMVPM70QUVzBFimfvu6d
         7KCHAomuOwUbrVoZ81kD/VN8s014fjFRhpGPkWmDe25p3XhCrRIuf0R1sdFj1nL3gqWq
         cN+g==
In-Reply-To: <20210713202412.248252-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

At the moment memcg stats are read in four contexts:

1. memcg stat user interfaces
2. dirty throttling
3. page fault
4. memory reclaim

Currently the kernel flushes the stats for first two cases. Flushing the
stats for remaining two casese may have performance impact. Always
flushing the memcg stats on the page fault code path may negatively
impacts the performance of the applications. In addition flushing in the
memory reclaim code path, though treated as slowpath, can become the
source of contention for the global lock taken for stat flushing because
when system or memcg is under memory pressure, many tasks may enter the
reclaim path.

This patch uses following mechanisms to solve these challenges:

1. Periodically flush the stats from root memcg every 2 seconds. This
will time limit the out of sync stats.

2. Asynchronously flush the stats after fixed number of stat updates.
In the worst case the stat can be out of sync by O(nr_cpus * BATCH) for
2 seconds.

3. For avoiding thundering herd to flush the stats particularly from the
memory reclaim context, introduce memcg local spinlock and let only one
flusher active at a time. This could have been done through
cgroup_rstat_lock lock but that lock is used by other subsystem and for
userspace reading memcg stats. So, it is better to keep flushers
introduced by this patch decoupled from cgroup_rstat_lock.
---
Changes since v2:
- Changed the subject of the patch
- Added mechanism to bound errors to nr_cpus instead of nr_cgroups
- memcg local lock to let one active flusher

Changes since v1:
- use system_unbound_wq for flushing the memcg stats

 include/linux/memcontrol.h |  6 ++++++
 mm/memcontrol.c            | 34 ++++++++++++++++++++++++++++++++++
 mm/vmscan.c                |  6 ++++++
 3 files changed, 46 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0bfa0409af22..fa095a94ae56 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -991,6 +991,8 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	return x;
 }
 
+void mem_cgroup_flush_stats(void);
+
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			      int val);
 void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
@@ -1400,6 +1402,10 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
+static inline void mem_cgroup_flush_stats(void)
+{
+}
+
 static inline void __mod_memcg_lruvec_state(struct lruvec *lruvec,
 					    enum node_stat_item idx, int val)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 848d711bf576..39a00991fc80 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -103,6 +103,14 @@ static bool do_memsw_account(void)
 	return !cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_noswap;
 }
 
+/* memcg and lruvec stats flushing */
+static void flush_memcg_stats_dwork(struct work_struct *w);
+static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
+static void flush_memcg_stats_work(struct work_struct *w);
+static DECLARE_WORK(stats_flush_work, flush_memcg_stats_work);
+static DEFINE_PER_CPU(unsigned int, stats_flush_threshold);
+static DEFINE_SPINLOCK(stats_flush_lock);
+
 #define THRESHOLDS_EVENTS_TARGET 128
 #define SOFTLIMIT_EVENTS_TARGET 1024
 
@@ -685,6 +693,8 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 
 	/* Update lruvec */
 	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
+	if (!(__this_cpu_inc_return(stats_flush_threshold) % MEMCG_CHARGE_BATCH))
+		queue_work(system_unbound_wq, &stats_flush_work);
 }
 
 /**
@@ -5248,6 +5258,10 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	/* Online state pins memcg ID, memcg ID pins CSS */
 	refcount_set(&memcg->id.ref, 1);
 	css_get(css);
+
+	if (unlikely(mem_cgroup_is_root(memcg)))
+		queue_delayed_work(system_unbound_wq, &stats_flush_dwork,
+				   2UL*HZ);
 	return 0;
 }
 
@@ -5339,6 +5353,26 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	memcg_wb_domain_size_changed(memcg);
 }
 
+void mem_cgroup_flush_stats(void)
+{
+	if (!spin_trylock(&stats_flush_lock))
+		return;
+
+	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
+	spin_unlock(&stats_flush_lock);
+}
+
+static void flush_memcg_stats_dwork(struct work_struct *w)
+{
+	mem_cgroup_flush_stats();
+	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, 2UL*HZ);
+}
+
+static void flush_memcg_stats_work(struct work_struct *w)
+{
+	mem_cgroup_flush_stats();
+}
+
 static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index a7602f71ec04..1cc05ab8ca15 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2893,6 +2893,12 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 	target_lruvec = mem_cgroup_lruvec(sc->target_mem_cgroup, pgdat);
 
 again:
+	/*
+	 * Flush the memory cgroup stats, so that we read accurate per-memcg
+	 * lruvec stats for heuristics.
+	 */
+	mem_cgroup_flush_stats();
+
 	memset(&sc->nr, 0, sizeof(sc->nr));
 
 	nr_reclaimed = sc->nr_reclaimed;
-- 
2.32.0.93.g670b81a890-goog

