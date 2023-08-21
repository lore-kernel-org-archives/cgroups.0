From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] mm: memcg: use non-unified stats flushing for userspace reads
Date: Mon, 21 Aug 2023 20:54:58 +0000
Message-ID: <20230821205458.1764662-4-yosryahmed@google.com>
References: <20230821205458.1764662-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692651323; x=1693256123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=II24bAIuGVg2YyiqwiCMReE2mVTE25qmDUAuXBGJ4Ok=;
        b=KmH6O0vZ9sBp7HHBae0PwJCnRa8ujSumjQ0AlsGJ1pi5KbQIxpyrvcCO0krC5ztY+u
         N8ljzGOzIX6jer2HV1GxzZPCURYnOZC6D1lrlNXbpCHNDpRJB0nITXoN0mon6iaCy4e1
         QkiLalZ25r1ZxplkbXN+NiDkoW8GDcA+Uj1Shac+wu5psshTskn8q8Lf6B5bKZffckoB
         jKrEuG2Vw03aNvOQfFER14s8IkriQqDS2U2JTgSKgCtg7TmcMJ9q3B18uyHoSMZM7lnj
         ioj21pXqwFO1fJbsQwZ0rFa+1Vc07Ob56riuci9Ea7Iw13vPBzZ96Hsd5+OoDw6zGDiR
         3h5Q==
In-Reply-To: <20230821205458.1764662-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

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
subtree), as well as the freshness of the stats. Since userspace readers
are not expected to have similar concurrency to in-kernel flushers,
serializing them among themselves and among in-kernel flushers should be
okay.

This was tested on a machine with 256 cpus by running a synthetic test
The script that creates 50 top-level cgroups, each with 5 children (250
leaf cgroups). Each leaf cgroup has 10 processes running that allocate
memory beyond the cgroup limit, invoking reclaim (which is an in-kernel
unified flusher). Concurrently, one thread is spawned per-cgroup to read
the stats every second (including root, top-level, and leaf cgroups --
so total 251 threads). No regressions were observed in the total running
time; which means that non-unified userspace readers are not slowing
down in-kernel unified flushers:

Base (mm-unstable):

real	0m18.228s
user	0m9.463s
sys	60m15.879s

real	0m20.828s
user	0m8.535s
sys	70m12.364s

real	0m19.789s
user	0m9.177s
sys	66m10.798s

With this patch:

real	0m19.632s
user	0m8.608s
sys	64m23.483s

real	0m18.463s
user	0m7.465s
sys	60m34.089s

real	0m20.309s
user	0m7.754s
sys	68m2.392s

Additionally, the average latency for reading stats went from roughly
40ms to 5 ms, because we mostly read the stats of leaf cgroups in this
script, so we only have to flush one cgroup, instead of *sometimes*
flushing the entire tree with unified flushing.

[1]https://lore.kernel.org/lkml/CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 90f08b35fa77..d3b13a06224c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1606,7 +1606,7 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 	 *
 	 * Current memory state:
 	 */
-	mem_cgroup_try_flush_stats();
+	do_stats_flush(memcg);
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		u64 size;
@@ -4048,7 +4048,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 	int nid;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	mem_cgroup_try_flush_stats();
+	do_stats_flush(memcg);
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
 		seq_printf(m, "%s=%lu", stat->name,
@@ -4123,7 +4123,7 @@ static void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));
 
-	mem_cgroup_try_flush_stats();
+	do_stats_flush(memcg);
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
@@ -4625,7 +4625,7 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
 
-	mem_cgroup_try_flush_stats();
+	do_stats_flush(memcg);
 
 	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
 	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
@@ -6640,7 +6640,7 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 	int i;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	mem_cgroup_try_flush_stats();
+	do_stats_flush(memcg);
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		int nid;
-- 
2.42.0.rc1.204.g551eb34607-goog

