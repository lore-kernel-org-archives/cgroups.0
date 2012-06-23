From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/6] memcg: change mem_control_xxx to mem_cgroup_xxx
Date: Sat, 23 Jun 2012 14:17:01 +0800
Message-ID: <1340432221-5268-1-git-send-email-liwp.linux@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=8V6fMKBZR8NYBn1y4RFJ32yw1pDDkVHxFkYH+19lX10=;
        b=Z4hLJ3UOYpXhEfTqZbZYkZgDf+0vef28YdFV3IrS9v+oo/JWMvbgHCe39QoBofk9Gy
         4dHebvI8qi9D5X8r5qtTSeh2xvCEjxIIv2ywYjho0CRYrXHZpwINgIt7QuGlNOZH3HgU
         kI6JIsOTpzv9MM47WQERkiIe0MAHXMT5pDPSiLBAhgTVDItbDM+Wo8KdMbGywqz7rr3o
         wivlzCWrMB2v+bMI2rSOHbIIqYZo5Oa5/JR/moNkIBk1oRIsHncR9ZqyS8t/ivnl+d/5
         crztPbwZn/u6LpGRwoZi6UD7xdl272UOOo5RT2qbAGvMsOFu9isnHom4MHgnkYr/m1Ju
         hEpw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gavin Shan <shangw-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Unify memcg functions to mem_cgroup_xxx.

Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ccda728..2e81328 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3999,7 +3999,7 @@ static int mem_cgroup_move_charge_write(struct cgroup *cgrp,
 #endif
 
 #ifdef CONFIG_NUMA
-static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
+static int mem_cgroup_numa_stat_show(struct cgroup *cont, struct cftype *cft,
 				      struct seq_file *m)
 {
 	int nid;
@@ -4058,7 +4058,7 @@ static inline void mem_cgroup_lru_names_not_uptodate(void)
 	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
 }
 
-static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
+static int mem_cgroup_stat_show(struct cgroup *cont, struct cftype *cft,
 				 struct seq_file *m)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
@@ -4572,7 +4572,7 @@ static struct cftype mem_cgroup_files[] = {
 	},
 	{
 		.name = "stat",
-		.read_seq_string = mem_control_stat_show,
+		.read_seq_string = mem_cgroup_stat_show,
 	},
 	{
 		.name = "force_empty",
@@ -4604,7 +4604,7 @@ static struct cftype mem_cgroup_files[] = {
 #ifdef CONFIG_NUMA
 	{
 		.name = "numa_stat",
-		.read_seq_string = mem_control_numa_stat_show,
+		.read_seq_string = mem_cgroup_numa_stat_show,
 	},
 #endif
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
-- 
1.7.9.5
