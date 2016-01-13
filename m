From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 2/2] mm: memcontrol: add "sock" to cgroup2 memory.stat
Date: Wed, 13 Jan 2016 17:01:09 -0500
Message-ID: <1452722469-24704-3-git-send-email-hannes@cmpxchg.org>
References: <1452722469-24704-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1452722469-24704-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@virtuozzo.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Provide statistics on how much of a cgroup's memory footprint is made
up of socket buffers from network connections owned by the group.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/memcontrol.h | 5 ++++-
 mm/memcontrol.c            | 6 ++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 1666617..9ae48d4 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -50,6 +50,9 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_WRITEBACK,	/* # of pages under writeback */
 	MEM_CGROUP_STAT_SWAP,		/* # of pages, swapped out */
 	MEM_CGROUP_STAT_NSTATS,
+	/* default hierarchy stats */
+	MEMCG_SOCK,
+	MEMCG_NR_STAT,
 };
 
 struct mem_cgroup_reclaim_cookie {
@@ -87,7 +90,7 @@ enum mem_cgroup_events_target {
 
 #ifdef CONFIG_MEMCG
 struct mem_cgroup_stat_cpu {
-	long count[MEM_CGROUP_STAT_NSTATS];
+	long count[MEMCG_NR_STAT];
 	unsigned long events[MEMCG_NR_EVENTS];
 	unsigned long nr_page_events;
 	unsigned long targets[MEM_CGROUP_NTARGETS];
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8645852..6bb23a7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5118,6 +5118,8 @@ static int memory_stat_show(struct seq_file *m, void *v)
 		   tree_stat(memcg, MEM_CGROUP_STAT_RSS) * PAGE_SIZE);
 	seq_printf(m, "file %lu\n",
 		   tree_stat(memcg, MEM_CGROUP_STAT_CACHE) * PAGE_SIZE);
+	seq_printf(m, "sock %lu\n",
+		   tree_stat(memcg, MEMCG_SOCK) * PAGE_SIZE);
 
 	/* Per-consumer breakdowns */
 
@@ -5619,6 +5621,8 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 	if (in_softirq())
 		gfp_mask = GFP_NOWAIT;
 
+	this_cpu_add(memcg->stat->count[MEMCG_SOCK], nr_pages);
+
 	if (try_charge(memcg, gfp_mask, nr_pages) == 0)
 		return true;
 
@@ -5638,6 +5642,8 @@ void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 		return;
 	}
 
+	this_cpu_sub(memcg->stat->count[MEMCG_SOCK], nr_pages);
+
 	page_counter_uncharge(&memcg->memory, nr_pages);
 	css_put_many(&memcg->css, nr_pages);
 }
-- 
2.7.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
