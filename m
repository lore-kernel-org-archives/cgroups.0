From: Maninder Singh <maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/1] mmzone: code cleanup for LRU stats.
Date: Mon, 18 Jan 2016 12:48:12 +0530
Message-ID: <1453101492-37125-1-git-send-email-maninder1.s@samsung.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, baiyaowei-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ajeet.y-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, pankaj.m-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Maninder Singh <maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Vaneet Narang <v.narang-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Replacing hardcoded values with enum lru_stats for LRU stats.

Signed-off-by: Maninder Singh <maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Vaneet Narang <v.narang-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/mmzone.h |   12 ++++++++----
 mm/memcontrol.c        |   20 ++++++++++----------
 mm/vmscan.c            |   20 ++++++++++----------
 3 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 68cc063..fd993e4 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -198,17 +198,21 @@ static inline int is_active_lru(enum lru_list lru)
 	return (lru == LRU_ACTIVE_ANON || lru == LRU_ACTIVE_FILE);
 }
 
+enum lru_stats {
+	LRU_ANON_STAT, /* anon LRU stats */
+	LRU_FILE_STAT, /* file LRU stats */
+	LRU_MAX_STAT
+};
+
 struct zone_reclaim_stat {
 	/*
 	 * The pageout code in vmscan.c keeps track of how many of the
 	 * mem/swap backed and file backed pages are referenced.
 	 * The higher the rotated/scanned ratio, the more valuable
 	 * that cache is.
-	 *
-	 * The anon LRU stats live in [0], file LRU stats in [1]
 	 */
-	unsigned long		recent_rotated[2];
-	unsigned long		recent_scanned[2];
+	unsigned long		recent_rotated[LRU_MAX_STAT];
+	unsigned long		recent_scanned[LRU_MAX_STAT];
 };
 
 struct lruvec {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 11e97e0..49c8e4d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3373,23 +3373,23 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 		int nid, zid;
 		struct mem_cgroup_per_zone *mz;
 		struct zone_reclaim_stat *rstat;
-		unsigned long recent_rotated[2] = {0, 0};
-		unsigned long recent_scanned[2] = {0, 0};
+		unsigned long recent_rotated[LRU_MAX_STAT] = {0, 0};
+		unsigned long recent_scanned[LRU_MAX_STAT] = {0, 0};
 
 		for_each_online_node(nid)
 			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 				mz = &memcg->nodeinfo[nid]->zoneinfo[zid];
 				rstat = &mz->lruvec.reclaim_stat;
 
-				recent_rotated[0] += rstat->recent_rotated[0];
-				recent_rotated[1] += rstat->recent_rotated[1];
-				recent_scanned[0] += rstat->recent_scanned[0];
-				recent_scanned[1] += rstat->recent_scanned[1];
+				recent_rotated[LRU_ANON_STAT] += rstat->recent_rotated[LRU_ANON_STAT];
+				recent_rotated[LRU_FILE_STAT] += rstat->recent_rotated[LRU_FILE_STAT];
+				recent_scanned[LRU_ANON_STAT] += rstat->recent_scanned[LRU_ANON_STAT];
+				recent_scanned[LRU_FILE_STAT] += rstat->recent_scanned[LRU_FILE_STAT];
 			}
-		seq_printf(m, "recent_rotated_anon %lu\n", recent_rotated[0]);
-		seq_printf(m, "recent_rotated_file %lu\n", recent_rotated[1]);
-		seq_printf(m, "recent_scanned_anon %lu\n", recent_scanned[0]);
-		seq_printf(m, "recent_scanned_file %lu\n", recent_scanned[1]);
+		seq_printf(m, "recent_rotated_anon %lu\n", recent_rotated[LRU_ANON_STAT]);
+		seq_printf(m, "recent_rotated_file %lu\n", recent_rotated[LRU_FILE_STAT]);
+		seq_printf(m, "recent_scanned_anon %lu\n", recent_scanned[LRU_ANON_STAT]);
+		seq_printf(m, "recent_scanned_file %lu\n", recent_scanned[LRU_FILE_STAT]);
 	}
 #endif
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ee3bbd5..7a66554 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2176,14 +2176,14 @@ static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
 		get_lru_size(lruvec, LRU_INACTIVE_FILE);
 
 	spin_lock_irq(&zone->lru_lock);
-	if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
-		reclaim_stat->recent_scanned[0] /= 2;
-		reclaim_stat->recent_rotated[0] /= 2;
+	if (unlikely(reclaim_stat->recent_scanned[LRU_ANON_STAT] > anon / 4)) {
+		reclaim_stat->recent_scanned[LRU_ANON_STAT] /= 2;
+		reclaim_stat->recent_rotated[LRU_ANON_STAT] /= 2;
 	}
 
-	if (unlikely(reclaim_stat->recent_scanned[1] > file / 4)) {
-		reclaim_stat->recent_scanned[1] /= 2;
-		reclaim_stat->recent_rotated[1] /= 2;
+	if (unlikely(reclaim_stat->recent_scanned[LRU_FILE_STAT] > file / 4)) {
+		reclaim_stat->recent_scanned[LRU_FILE_STAT] /= 2;
+		reclaim_stat->recent_rotated[LRU_FILE_STAT] /= 2;
 	}
 
 	/*
@@ -2191,11 +2191,11 @@ static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
 	 * proportional to the fraction of recently scanned pages on
 	 * each list that were recently referenced and in active use.
 	 */
-	ap = anon_prio * (reclaim_stat->recent_scanned[0] + 1);
-	ap /= reclaim_stat->recent_rotated[0] + 1;
+	ap = anon_prio * (reclaim_stat->recent_scanned[LRU_ANON_STAT] + 1);
+	ap /= reclaim_stat->recent_rotated[LRU_ANON_STAT] + 1;
 
-	fp = file_prio * (reclaim_stat->recent_scanned[1] + 1);
-	fp /= reclaim_stat->recent_rotated[1] + 1;
+	fp = file_prio * (reclaim_stat->recent_scanned[LRU_FILE_STAT] + 1);
+	fp /= reclaim_stat->recent_rotated[LRU_FILE_STAT] + 1;
 	spin_unlock_irq(&zone->lru_lock);
 
 	fraction[0] = ap;
-- 
1.7.9.5
