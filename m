From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: sync flush only if periodic flush is delayed
Date: Fri,  4 Mar 2022 18:40:40 +0000
Message-ID: <20220304184040.1304781-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kcmyAeGkpK7r59rcNcxz8jTE3yUE+N3ayzd6XBblM0I=;
        b=mvLff3CoVSfT2aw6kcMrK88S909hTrrgtBVT9DD32PyLCwH95gcIWOBgv7d+B5Lk94
         6hmjfyCbTACgGXuUxAuHbq2YdDtEgFXLlDJxgr16HWSidmhaQZ6/Gn0xcRhFCGj2H6To
         joT1GP1IfVR8Dsrm2glTVD3Xsj5i27miNaXmBqU2Azi8dzDhqV8o3qr/7mu6pH73YOfD
         iR8mjRPGmKQl8K5kVyArnaFqeOTwfccrAcc9Za6ETbCJER3RiaXUWmRkYm/aKORgLWsh
         7uBH2hMZTq4emcVx+Hfi9V3Yfk9hJdS9TbVc4g33OkzABHo84zPYWIo6YrfcDWw/wA7/
         lX6A==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Frank Hofmann <fhofmann-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Daniel Dao <dqminh-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Daniel Dao has reported [1] a regression on workloads that may trigger
a lot of refaults (anon and file). The underlying issue is that flushing
rstat is expensive. Although rstat flush are batched with (nr_cpus *
MEMCG_BATCH) stat updates, it seems like there are workloads which
genuinely do stat updates larger than batch value within short amount of
time. Since the rstat flush can happen in the performance critical
codepaths like page faults, such workload can suffer greatly.

This patch fixes this regression by making the rstat flushing
conditional in the performance critical codepaths. More specifically,
the kernel relies on the async periodic rstat flusher to flush the stats
and only if the periodic flusher is delayed by more than twice the
amount of its normal time window then the kernel allows rstat flushing
from the performance critical codepaths.

Now the question: what are the side-effects of this change? The worst
that can happen is the refault codepath will see 4sec old lruvec stats
and may cause false (or missed) activations of the refaulted page which
may under-or-overestimate the workingset size. Though that is not very
concerning as the kernel can already miss or do false activations.

There are two more codepaths whose flushing behavior is not changed by
this patch and we may need to come to them in future. One is the
writeback stats used by dirty throttling and second is the deactivation
heuristic in the reclaim. For now keeping an eye on them and if there is
report of regression due to these codepaths, we will reevaluate then.

Link: https://lore.kernel.org/all/CA+wXwBSyO87ZX5PVwdHm-=dBjZYECGmfnydUicUyrQqndgX2MQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org [1]
Fixes: 1f828223b799 ("memcg: flush lruvec stats in the refault")
Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reported-by: Daniel Dao <dqminh-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 include/linux/memcontrol.h |  5 +++++
 mm/memcontrol.c            | 12 +++++++++++-
 mm/workingset.c            |  2 +-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a68dce3873fc..89b14729d59f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1012,6 +1012,7 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 }
 
 void mem_cgroup_flush_stats(void);
+void mem_cgroup_flush_stats_delayed(void);
 
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			      int val);
@@ -1455,6 +1456,10 @@ static inline void mem_cgroup_flush_stats(void)
 {
 }
 
+static inline void mem_cgroup_flush_stats_delayed(void)
+{
+}
+
 static inline void __mod_memcg_lruvec_state(struct lruvec *lruvec,
 					    enum node_stat_item idx, int val)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f79bb3f25ce4..edfb337e6948 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -587,6 +587,9 @@ static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
 static DEFINE_SPINLOCK(stats_flush_lock);
 static DEFINE_PER_CPU(unsigned int, stats_updates);
 static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
+static u64 flush_next_time;
+
+#define FLUSH_TIME (2UL*HZ)
 
 /*
  * Accessors to ensure that preemption is disabled on PREEMPT_RT because it can
@@ -637,6 +640,7 @@ static void __mem_cgroup_flush_stats(void)
 	if (!spin_trylock_irqsave(&stats_flush_lock, flag))
 		return;
 
+	flush_next_time = jiffies_64 + 2*FLUSH_TIME;
 	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
 	atomic_set(&stats_flush_threshold, 0);
 	spin_unlock_irqrestore(&stats_flush_lock, flag);
@@ -648,10 +652,16 @@ void mem_cgroup_flush_stats(void)
 		__mem_cgroup_flush_stats();
 }
 
+void mem_cgroup_flush_stats_delayed(void)
+{
+	if (rstat_flush_time && time_after64(jiffies_64, flush_next_time))
+		mem_cgroup_flush_stats();
+}
+
 static void flush_memcg_stats_dwork(struct work_struct *w)
 {
 	__mem_cgroup_flush_stats();
-	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, 2UL*HZ);
+	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
 /**
diff --git a/mm/workingset.c b/mm/workingset.c
index 8a3828acc0bf..592569a8974c 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -355,7 +355,7 @@ void workingset_refault(struct folio *folio, void *shadow)
 
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats_delayed();
 	/*
 	 * Compare the distance to the existing workingset size. We
 	 * don't activate pages that couldn't stay resident even if
-- 
2.35.1.616.g0bdcbb4464-goog

