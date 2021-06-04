From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] memcg: periodically flush the memcg stats
Date: Thu,  3 Jun 2021 18:56:40 -0700
Message-ID: <20210604015640.2586269-2-shakeelb@google.com>
References: <20210604015640.2586269-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uh6gy4nZthBorhbRuZ4nfT30dGL+1kaEEjjmFJIUwIQ=;
        b=h7Se6qB/0cnnCs0FMOVwiNEYheVr2wFbzsatoLiYi1xkHnTgTljxG000R1EPRE5ksS
         U7kt5w744nMgfzzUltQKJlatxrPjqhQrX854XWGGw9u8WKzNKIw1cNdCphoH0IGL1TmS
         am3i4nOxfIT/O1nwzP4vL2sQFhbvB+BgMpB1gFQ0atXxtderGtY9fbqR3UkgUh7C9zLd
         XAX7q51IotP73K7SCw3RpR8taqAuzA9JYPJcC+onu5jJV0p06AfWOxlwtJIuhJWLJmHs
         ABfgbKc+cD+knNVJI6OUd42yvxwL65tayeQ0AD9qpxyRMjLJAGgL9eOixg6HpzneCLeW
         89Pw==
In-Reply-To: <20210604015640.2586269-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

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

Instead of synchronously flushing the stats, this patch adds support of
asynchronous periodic flushing of the memcg stats. For now the flushing
period is hardcoded to 2*HZ but that can be changed later through maybe
sysctl if need arise.

This patch does add the explicit flushing in the kswapd thread as the
number of kswapd threads which corresponds to the number of nodes on
realistic machines are usually low.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h | 10 ++++++++++
 mm/memcontrol.c            | 14 ++++++++++++++
 mm/vmscan.c                |  6 ++++++
 3 files changed, 30 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 81d65d32ec2a..222c00e76ef9 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -991,6 +991,12 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	return x;
 }
 
+static inline void mem_cgroup_flush_stats(void)
+{
+	if (!mem_cgroup_disabled())
+		cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
+}
+
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			      int val);
 void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
@@ -1394,6 +1400,10 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
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
index d48f727bec05..6c8578faa8b4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -96,6 +96,10 @@ bool cgroup_memory_noswap __read_mostly;
 static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
 #endif
 
+/* Periodically flush memcg and lruvec stats. */
+static void flush_memcg_stats(struct work_struct *w);
+static DECLARE_DEFERRABLE_WORK(stats_flush, flush_memcg_stats);
+
 /* Whether legacy memory+swap accounting is active */
 static bool do_memsw_account(void)
 {
@@ -5230,6 +5234,10 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	/* Online state pins memcg ID, memcg ID pins CSS */
 	refcount_set(&memcg->id.ref, 1);
 	css_get(css);
+
+	if (unlikely(mem_cgroup_is_root(memcg)))
+		schedule_delayed_work(&stats_flush, round_jiffies(2UL*HZ));
+
 	return 0;
 }
 
@@ -5321,6 +5329,12 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	memcg_wb_domain_size_changed(memcg);
 }
 
+static void flush_memcg_stats(struct work_struct *w)
+{
+	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
+	schedule_delayed_work(&stats_flush, round_jiffies(2UL*HZ));
+}
+
 static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 60a19fd6ea3f..16546a5be922 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3872,6 +3872,12 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 		sc.may_writepage = !laptop_mode && !nr_boost_reclaim;
 		sc.may_swap = !nr_boost_reclaim;
 
+		/*
+		 * Flush the memory cgroup stats, so that we read accurate
+		 * per-memcg lruvec stats for heuristics later.
+		 */
+		mem_cgroup_flush_stats();
+
 		/*
 		 * Do some background aging of the anon list, to give
 		 * pages a chance to be referenced before reclaiming. All
-- 
2.32.0.rc1.229.g3e70b5a671-goog

