From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/2] memcg: dump memory.stat during cgroup OOM for v1
Date: Fri, 28 Apr 2023 13:24:06 +0000
Message-ID: <20230428132406.2540811-3-yosryahmed@google.com>
References: <20230428132406.2540811-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682688254; x=1685280254;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gCrHQjiS2fwiby7dz0V9ThMkUe63uEws1Bin2T2dpU8=;
        b=jcuVTOAp1c8K+ch7YCMLi+8POwhTwb1WrUalORmat2684E/X82MLP/H/sTNZiGTSzw
         ILJbHonyleAOPNozrhCp7XJpKzpTbzSV2WanXyhxQyxv5lSFZW8pMKziOeeK25UM/lM3
         JtO2LiFUAPtV+zJkr/lmiV+hDnMAOdwrsD7W9rNnMigwvNIYtIDxnNjAK3lyudpZp5yI
         5vpaP0vtG6m4sW2kgSy3vvkx/O8FeePG6gnTT8455Z1wkWEJFKZg0VnC7g7BQBECbTSk
         07ULhu3kIczPuOMcJkwFO/y0wcnsFUVJfVg87WLuR8H+9rMQZ0u8212WdRLWh+a/t1bT
         beJw==
In-Reply-To: <20230428132406.2540811-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Commit c8713d0b2312 ("mm: memcontrol: dump memory.stat during cgroup
OOM") made sure we dump all the stats in memory.stat during a cgroup
OOM, but it also introduced a slight behavioral change. The code used to
print the non-hierarchical v1 cgroup stats for the entire cgroup
subtree, now it only prints the v2 cgroup stats for the cgroup under
OOM.

For cgroup v1 users, this introduces a few problems:
(a) The non-hierarchical stats of the memcg under OOM are no longer
shown.
(b) A couple of v1-only stats (e.g. pgpgin, pgpgout) are no longer
shown.
(c) We show the list of cgroup v2 stats, even in cgroup v1. This list of
stats is not tracked with v1 in mind. While most of the stats seem to be
working on v1, there may be some stats that are not fully or correctly
tracked.

Although OOM log is not set in stone, we should not change it for no
reason. When upgrading the kernel version to a version including
commit c8713d0b2312 ("mm: memcontrol: dump memory.stat during cgroup
OOM"), these behavioral changes are noticed in cgroup v1.

The fix is simple. Commit c8713d0b2312 ("mm: memcontrol: dump memory.stat
during cgroup OOM") separated stats formatting from stats display for
v2, to reuse the stats formatting in the OOM logs. Do the same for v1.

Move the v2 specific formatting from memory_stat_format() to
memcg_stat_format(), add memcg1_stat_format() for v1, and make
memory_stat_format() select between them based on cgroup version.
Since memory_stat_show() now works for both v1 & v2, drop
memcg_stat_show().

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 60 ++++++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 25 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5922940f92c9..2b492f8d540c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1551,7 +1551,7 @@ static inline unsigned long memcg_page_state_output(struct mem_cgroup *memcg,
 	return memcg_page_state(memcg, item) * memcg_page_state_unit(item);
 }
 
-static void memory_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
+static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 {
 	int i;
 
@@ -1604,6 +1604,17 @@ static void memory_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 	WARN_ON_ONCE(seq_buf_has_overflowed(s));
 }
 
+static void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
+
+static void memory_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
+{
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		memcg_stat_format(memcg, s);
+	else
+		memcg1_stat_format(memcg, s);
+	WARN_ON_ONCE(seq_buf_has_overflowed(s));
+}
+
 #define K(x) ((x) << (PAGE_SHIFT-10))
 /**
  * mem_cgroup_print_oom_context: Print OOM information relevant to
@@ -4078,9 +4089,8 @@ static const unsigned int memcg1_events[] = {
 	PGMAJFAULT,
 };
 
-static int memcg_stat_show(struct seq_file *m, void *v)
+static void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 {
-	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 	unsigned long memory, memsw;
 	struct mem_cgroup *mi;
 	unsigned int i;
@@ -4095,18 +4105,18 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
 			continue;
 		nr = memcg_page_state_local(memcg, memcg1_stats[i]);
-		seq_printf(m, "%s %lu\n", memcg1_stat_names[i],
+		seq_buf_printf(s, "%s %lu\n", memcg1_stat_names[i],
 			   nr * memcg_page_state_unit(memcg1_stats[i]));
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
-		seq_printf(m, "%s %lu\n", vm_event_name(memcg1_events[i]),
-			   memcg_events_local(memcg, memcg1_events[i]));
+		seq_buf_printf(s, "%s %lu\n", vm_event_name(memcg1_events[i]),
+			       memcg_events_local(memcg, memcg1_events[i]));
 
 	for (i = 0; i < NR_LRU_LISTS; i++)
-		seq_printf(m, "%s %lu\n", lru_list_name(i),
-			   memcg_page_state_local(memcg, NR_LRU_BASE + i) *
-			   PAGE_SIZE);
+		seq_buf_printf(s, "%s %lu\n", lru_list_name(i),
+			       memcg_page_state_local(memcg, NR_LRU_BASE + i) *
+			       PAGE_SIZE);
 
 	/* Hierarchical information */
 	memory = memsw = PAGE_COUNTER_MAX;
@@ -4114,11 +4124,11 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 		memory = min(memory, READ_ONCE(mi->memory.max));
 		memsw = min(memsw, READ_ONCE(mi->memsw.max));
 	}
-	seq_printf(m, "hierarchical_memory_limit %llu\n",
-		   (u64)memory * PAGE_SIZE);
+	seq_buf_printf(s, "hierarchical_memory_limit %llu\n",
+		       (u64)memory * PAGE_SIZE);
 	if (do_memsw_account())
-		seq_printf(m, "hierarchical_memsw_limit %llu\n",
-			   (u64)memsw * PAGE_SIZE);
+		seq_buf_printf(s, "hierarchical_memsw_limit %llu\n",
+			       (u64)memsw * PAGE_SIZE);
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
@@ -4126,19 +4136,19 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
 			continue;
 		nr = memcg_page_state(memcg, memcg1_stats[i]);
-		seq_printf(m, "total_%s %llu\n", memcg1_stat_names[i],
+		seq_buf_printf(s, "total_%s %llu\n", memcg1_stat_names[i],
 			   (u64)nr * memcg_page_state_unit(memcg1_stats[i]));
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
-		seq_printf(m, "total_%s %llu\n",
-			   vm_event_name(memcg1_events[i]),
-			   (u64)memcg_events(memcg, memcg1_events[i]));
+		seq_buf_printf(s, "total_%s %llu\n",
+			       vm_event_name(memcg1_events[i]),
+			       (u64)memcg_events(memcg, memcg1_events[i]));
 
 	for (i = 0; i < NR_LRU_LISTS; i++)
-		seq_printf(m, "total_%s %llu\n", lru_list_name(i),
-			   (u64)memcg_page_state(memcg, NR_LRU_BASE + i) *
-			   PAGE_SIZE);
+		seq_buf_printf(s, "total_%s %llu\n", lru_list_name(i),
+			       (u64)memcg_page_state(memcg, NR_LRU_BASE + i) *
+			       PAGE_SIZE);
 
 #ifdef CONFIG_DEBUG_VM
 	{
@@ -4153,12 +4163,10 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 			anon_cost += mz->lruvec.anon_cost;
 			file_cost += mz->lruvec.file_cost;
 		}
-		seq_printf(m, "anon_cost %lu\n", anon_cost);
-		seq_printf(m, "file_cost %lu\n", file_cost);
+		seq_buf_printf(s, "anon_cost %lu\n", anon_cost);
+		seq_buf_printf(s, "file_cost %lu\n", file_cost);
 	}
 #endif
-
-	return 0;
 }
 
 static u64 mem_cgroup_swappiness_read(struct cgroup_subsys_state *css,
@@ -4998,6 +5006,8 @@ static int mem_cgroup_slab_show(struct seq_file *m, void *p)
 }
 #endif
 
+static int memory_stat_show(struct seq_file *m, void *v);
+
 static struct cftype mem_cgroup_legacy_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -5030,7 +5040,7 @@ static struct cftype mem_cgroup_legacy_files[] = {
 	},
 	{
 		.name = "stat",
-		.seq_show = memcg_stat_show,
+		.seq_show = memory_stat_show,
 	},
 	{
 		.name = "force_empty",
-- 
2.40.1.495.gc816e09b53d-goog

