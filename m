From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/6] memcg: move recent_rotated and recent_scanned informations
Date: Sat, 23 Jun 2012 14:17:39 +0800
Message-ID: <1340432259-5317-1-git-send-email-liwp.linux@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=dYUk+hNDmpVOiaNjD+p1mbABtOpzlTwMuJIuFb9a+qU=;
        b=zqzAhAnV1HXv++mdLb9tLnpt7xyLYVAM/iywdjAS0OC2/YPxHrZolxhBFsA4dTXJwL
         eNjaGMLzKVxQIvoO/M8eW1HO/vDfSfsOGbUN/0hXTLxIQ/ege5bt5I91zW1hRBBa/XQ8
         M3XNDImXj96V/+atQuogwF8ohXs4hovBc9CfgALsLkomUvRlf+W617iY1CrGIU1XrvBX
         l/qk+2EbPHisJDVzIE4/doC608YCrOQ/csJ1kYe82gJNx+m+RojFEaPsKhNgpEpSke55
         8E0WoNiThrSffWyk7fNCo1BbaaPTKnjB+THYzdwy7WCrgW3NQKfBBGrbrEF1OcNj9DVU
         YJbQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gavin Shan <shangw-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Move recent_rotated and recent_scanned prints next to inactive_anon,
ative_anon, inactive_file, active_file, and unevictable prints to
save developers' time. Since they have to go a long way(when cat memory.stat)
to find recent_rotated and recent_scanned prints which has relationship
with the memory cgroup we care. These prints are behind total_* which
not just focus on the memory cgroup we care currently.

Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c |   50 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2e81328..c821e36 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4080,6 +4080,31 @@ static int mem_cgroup_stat_show(struct cgroup *cont, struct cftype *cft,
 		seq_printf(m, "%s %lu\n", mem_cgroup_lru_names[i],
 			   mem_cgroup_nr_lru_pages(memcg, BIT(i)) * PAGE_SIZE);
 
+#ifdef CONFIG_DEBUG_VM
+	{
+		int nid, zid;
+		struct mem_cgroup_per_zone *mz;
+		struct zone_reclaim_stat *rstat;
+		unsigned long recent_rotated[2] = {0, 0};
+		unsigned long recent_scanned[2] = {0, 0};
+
+		for_each_online_node(nid)
+			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+				mz = mem_cgroup_zoneinfo(memcg, nid, zid);
+				rstat = &mz->lruvec.reclaim_stat;
+
+				recent_rotated[0] += rstat->recent_rotated[0];
+				recent_rotated[1] += rstat->recent_rotated[1];
+				recent_scanned[0] += rstat->recent_scanned[0];
+				recent_scanned[1] += rstat->recent_scanned[1];
+			}
+		seq_printf(m, "recent_rotated_anon %lu\n", recent_rotated[0]);
+		seq_printf(m, "recent_rotated_file %lu\n", recent_rotated[1]);
+		seq_printf(m, "recent_scanned_anon %lu\n", recent_scanned[0]);
+		seq_printf(m, "recent_scanned_file %lu\n", recent_scanned[1]);
+	}
+#endif
+
 	/* Hierarchical information */
 	{
 		unsigned long long limit, memsw_limit;
@@ -4117,31 +4142,6 @@ static int mem_cgroup_stat_show(struct cgroup *cont, struct cftype *cft,
 		seq_printf(m, "total_%s %llu\n", mem_cgroup_lru_names[i], val);
 	}
 
-#ifdef CONFIG_DEBUG_VM
-	{
-		int nid, zid;
-		struct mem_cgroup_per_zone *mz;
-		struct zone_reclaim_stat *rstat;
-		unsigned long recent_rotated[2] = {0, 0};
-		unsigned long recent_scanned[2] = {0, 0};
-
-		for_each_online_node(nid)
-			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-				mz = mem_cgroup_zoneinfo(memcg, nid, zid);
-				rstat = &mz->lruvec.reclaim_stat;
-
-				recent_rotated[0] += rstat->recent_rotated[0];
-				recent_rotated[1] += rstat->recent_rotated[1];
-				recent_scanned[0] += rstat->recent_scanned[0];
-				recent_scanned[1] += rstat->recent_scanned[1];
-			}
-		seq_printf(m, "recent_rotated_anon %lu\n", recent_rotated[0]);
-		seq_printf(m, "recent_rotated_file %lu\n", recent_rotated[1]);
-		seq_printf(m, "recent_scanned_anon %lu\n", recent_scanned[0]);
-		seq_printf(m, "recent_scanned_file %lu\n", recent_scanned[1]);
-	}
-#endif
-
 	return 0;
 }
 
-- 
1.7.9.5
