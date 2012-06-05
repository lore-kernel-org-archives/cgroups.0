From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 1/3] rename MEM_CGROUP_STAT_SWAPOUT as MEM_CGROUP_STAT_SWAP
Date: Tue, 05 Jun 2012 10:32:58 +0900
Message-ID: <4FCD61CA.6010209@jp.fujitsu.com>
References: <4FCD609E.8070704@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4FCD609E.8070704@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm@kvack.org
Cc: cgroups@vger.kernel.org, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org


MEM_CGROUP_STAT_SWAPOUT represents the usage of swap rather than
the number of swap-out events. Rename it to be MEM_CGROUP_STAT_SWAP.

Changelog:
 - use MEM_CGROUP_STAT_SWAP instead of MEM_CGROUP_STAT_NR_SWAP.

Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4a6d19f..cf19b9f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -97,7 +97,7 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
 	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
 	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
-	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
+	MEM_CGROUP_STAT_SWAP, /* # of pages, swapped out */
 	MEM_CGROUP_STAT_NSTATS,
 };
 
@@ -722,7 +722,7 @@ static void mem_cgroup_swap_statistics(struct mem_cgroup *memcg,
 					 bool charge)
 {
 	int val = (charge) ? 1 : -1;
-	this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_SWAPOUT], val);
+	this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_SWAP], val);
 }
 
 static unsigned long mem_cgroup_read_events(struct mem_cgroup *memcg,
@@ -4033,7 +4033,7 @@ static inline u64 mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 	val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_RSS);
 
 	if (swap)
-		val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_SWAPOUT);
+		val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_SWAP);
 
 	return val << PAGE_SHIFT;
 }
@@ -4294,7 +4294,7 @@ static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
 	unsigned int i;
 
 	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
-		if (i == MEM_CGROUP_STAT_SWAPOUT && !do_swap_account)
+		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
 			continue;
 		seq_printf(m, "%s %ld\n", mem_cgroup_stat_names[i],
 			   mem_cgroup_read_stat(memcg, i) * PAGE_SIZE);
@@ -4321,7 +4321,7 @@ static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
 	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
 		long long val = 0;
 
-		if (i == MEM_CGROUP_STAT_SWAPOUT && !do_swap_account)
+		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
 			continue;
 		for_each_mem_cgroup_tree(mi, memcg)
 			val += mem_cgroup_read_stat(mi, i) * PAGE_SIZE;
-- 
1.7.4.1


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
