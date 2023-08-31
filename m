From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 4/4] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Thu, 31 Aug 2023 16:56:11 +0000
Message-ID: <20230831165611.2610118-5-yosryahmed@google.com>
References: <20230831165611.2610118-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693500982; x=1694105782; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lVjKd06WEqwLUbomPNwpng6u2PnrisAzbeEHsBpSLQA=;
        b=W38E5uAeTvyzvdugULNx6GuUlSmhzK+I1kCU5GpDRcJ/kzbDYMV1Zpgq3yvogCW+HO
         a0u1glBoatfXyeCi5dgKcnvjkmpqHQVt5p96qMBgQ4BpDaCVmJd2g9Sn47VyHINS6ZC5
         ip1m/0C/p5Kk00qY0HhGlwqUdf6zss1JkrqMgMj37Ag0nlc/atAxGJoDTHRQieBEwkyd
         gQp2xt5/QtSgFC219yqziibx6jWWlEcqeux7rSE1dzLAqdyWJDyoQX5Op0VOfUXGPO3y
         ghSojvpv6+c296PaorTE6B016I4p+0Bxg/OafrYRFGt/Ez6FSKXw/E/CsMa8zgshkxqz
         WSyQ==
In-Reply-To: <20230831165611.2610118-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Unified flushing allows for great concurrency for paths that attempt to
flush the stats, at the expense of potential staleness and a single
flusher paying the extra cost of flushing the full tree.

This tradeoff makes sense for in-kernel flushers that may observe high
concurrency (e.g. reclaim, refault). For userspace readers, stale stats
may be unexpected and problematic, especially when such stats are used
for critical paths such as userspace OOM handling. Additionally, a
userspace reader will occasionally pay the cost of flushing the entire
hierarchy, which also causes problems in some cases [1].

Opt userspace reads out of unified flushing. This makes the cost of
reading the stats more predictable (proportional to the size of the
subtree), as well as the freshness of the stats. Userspace readers are
not expected to have similar concurrency to in-kernel flushers,
serializing them among themselves and among in-kernel flushers should be
okay. Nonetheless, for extra safety, introduce a mutex when flushing for
userspace readers to make sure only a single userspace reader can compete
with in-kernel flushers at a time. This takes away userspace ability to
directly influence or hurt in-kernel lock contention.

An alternative is to remove flushing from the stats reading path
completely, and rely on the periodic flusher. This should be accompanied
by making the periodic flushing period tunable, and providing an
interface for userspace to force a flush, following a similar model to
/proc/vmstat. However, such a change will be hard to reverse if the
implementation needs to be changed because:
- The cost of reading stats will be very cheap and we won't be able to
  take that back easily.
- There are user-visible interfaces involved.

Hence, let's go with the change that's most reversible first and revisit
as needed.

This was tested on a machine with 256 cpus by running a synthetic test
script [2] that creates 50 top-level cgroups, each with 5 children (250
leaf cgroups). Each leaf cgroup has 10 processes running that allocate
memory beyond the cgroup limit, invoking reclaim (which is an in-kernel
unified flusher). Concurrently, one thread is spawned per-cgroup to read
the stats every second (including root, top-level, and leaf cgroups --
so total 251 threads). No significant regressions were observed in the
total run time, which means that userspace readers are not significantly
affecting in-kernel flushers:

Base (mm-unstable):

real	0m22.500s
user	0m9.399s
sys	73m41.381s

real	0m22.749s
user	0m15.648s
sys	73m13.113s

real	0m22.466s
user	0m10.000s
sys	73m11.933s

With this patch:

real	0m23.092s
user	0m10.110s
sys	75m42.774s

real	0m22.277s
user	0m10.443s
sys	72m7.182s

real	0m24.127s
user	0m12.617s
sys	78m52.765s

[1]https://lore.kernel.org/lkml/CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
[2]https://lore.kernel.org/lkml/CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 94d5a6751a9e..46a7abf71c73 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -588,6 +588,7 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
 static void flush_memcg_stats_dwork(struct work_struct *w);
 static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
 static DEFINE_PER_CPU(unsigned int, stats_updates);
+static DEFINE_MUTEX(stats_user_flush_mutex);
 static atomic_t stats_unified_flush_ongoing = ATOMIC_INIT(0);
 static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
 static u64 flush_next_time;
@@ -655,6 +656,21 @@ static void do_stats_flush(struct mem_cgroup *memcg)
 	cgroup_rstat_flush(memcg->css.cgroup);
 }
 
+/*
+ * mem_cgroup_user_flush_stats - do a stats flush for a user read
+ * @memcg: memory cgroup to flush
+ *
+ * Flush the subtree of @memcg. A mutex is used for userspace readers to gate
+ * the global rstat spinlock. This protects in-kernel flushers from userspace
+ * readers hogging the lock.
+ */
+static void mem_cgroup_user_flush_stats(struct mem_cgroup *memcg)
+{
+	mutex_lock(&stats_user_flush_mutex);
+	do_stats_flush(memcg);
+	mutex_unlock(&stats_user_flush_mutex);
+}
+
 /*
  * do_unified_stats_flush - do a unified flush of memory cgroup statistics
  *
@@ -1608,7 +1624,7 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 	 *
 	 * Current memory state:
 	 */
-	mem_cgroup_try_flush_stats();
+	mem_cgroup_user_flush_stats(memcg);
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		u64 size;
@@ -4050,7 +4066,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 	int nid;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	mem_cgroup_try_flush_stats();
+	mem_cgroup_user_flush_stats(memcg);
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
 		seq_printf(m, "%s=%lu", stat->name,
@@ -4125,7 +4141,7 @@ static void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));
 
-	mem_cgroup_try_flush_stats();
+	mem_cgroup_user_flush_stats(memcg);
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
@@ -6642,7 +6658,7 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 	int i;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	mem_cgroup_try_flush_stats();
+	mem_cgroup_user_flush_stats(memcg);
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		int nid;
-- 
2.42.0.rc2.253.gd59a3bf2b4-goog

