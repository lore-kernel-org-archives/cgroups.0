From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH 2/2] memcg: dump memory.stat during cgroup OOM for v1
Date: Wed, 26 Apr 2023 13:39:19 +0000
Message-ID: <20230426133919.1342942-3-yosryahmed@google.com>
References: <20230426133919.1342942-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682516366; x=1685108366;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B3i7jLy77aXSdzt8MLnlwJrjLWa5VGev4cAQ6nx3Pzk=;
        b=VzLG+6h5CSkfvQZli1OGIiAHvWLeZ1UxaxLHwKBOnH2MCjUETX1QJE/sogMe69eqk7
         vBbIbWZIN20q7FnUgXd+PGfMXTGUTczgWU8KKwjcZ8lBbyiyhGbKQYcc5cO7TX8Z3V4f
         8DEtCJMSayke/qyFUeJHi41Q8w5O3Vw3jYELxMD9G2Yd43hlJ+5i9W56SzV8e4Y7qupz
         hvIeqP/bkO4QBcA+CZnvstw3SEisBauI073SKtvHsPG/3CBfKdbOME1DsBqBxapdAL07
         yrZBPGmoTvf0k16+hlujpoOSCW6OIVEIvr6tqUDY4KOlfvJdizlM78YwN2B4KBUKjdh4
         yo1Q==
In-Reply-To: <20230426133919.1342942-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, Sergey Senozhatsky <senozhatsky@chromium.org>, Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.com>, Chris Li <chrisl@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

Commit c8713d0b2312 ("mm: memcontrol: dump memory.stat during cgroup
OOM") made sure we dump all the stats in memory.stat during a cgroup
OOM, but it also introduced a slight behavioral change. The code used to
print the non-hierarchical v1 cgroup stats for the entire cgroup
subtree, not it only prints the v2 cgroup stats for the cgroup under
OOM.

Although v2 stats are a superset of v1 stats, some of them have
different naming. We also lost the non-hierarchical stats for the cgroup
under OOM in v1.

Move the v2 specific formatting from memory_stat_format() to
memcg_stat_format(), add memcg1_stat_format() for v1, and make
memory_stat_format() select between them based on cgroup version.
Since memory_stat_show() now works for both v1 & v2, drop
memcg_stat_show().

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
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

