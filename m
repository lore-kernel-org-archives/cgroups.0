From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] memcg: unify mem_control_xxx to memcg_xxx
Date: Wed, 27 Jun 2012 08:16:15 +0800
Message-ID: <1340756175-3420-1-git-send-email-liwp.linux@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=KXYUBnaFaJcLo+I39FTUQS0r4+aEBIxnNEH9eYp4AXY=;
        b=tAmRBWC7/Adxnp9s3C0p/e/YoCYwrcvJyn/Ws/Y9XHXwPzbCYlSJl170N+IWMqPCEd
         LLKDpxp1olf6hMHHiAFYE7B4BCsHpL+f6iGGBOe/BRyqPwP7Aa5kuSphq9KA4uPcgG25
         6kO5OwCL0Dko37Ak+CosSSipRmlQDrXkmXiB9wgYfdIgwlfdAtr6ULdGo/TtDr1W3E6n
         7vwFksOoLbTZ7s6El6BKP2JD3ThgPxHqSTEXJPL6goEfnRZMNlUDP+4P4wZxXpcVzPaw
         2/vy2FARvnWuNSnU8KmgxaW4imf1ofqBRkheuXftlRAClbyxzlm2zA6qhFsq6Lou76rO
         0AbQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Changelog:

V2 -> V1:

* replace memory_cgroup_xxx by memcg_xxx

Unify memcg functions to memcg_xxx.

Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
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
+static int memcg_numa_stat_show(struct cgroup *cont, struct cftype *cft,
 				      struct seq_file *m)
 {
 	int nid;
@@ -4058,7 +4058,7 @@ static inline void mem_cgroup_lru_names_not_uptodate(void)
 	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
 }
 
-static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
+static int memcg_stat_show(struct cgroup *cont, struct cftype *cft,
 				 struct seq_file *m)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
@@ -4572,7 +4572,7 @@ static struct cftype mem_cgroup_files[] = {
 	},
 	{
 		.name = "stat",
-		.read_seq_string = mem_control_stat_show,
+		.read_seq_string = memcg_stat_show,
 	},
 	{
 		.name = "force_empty",
@@ -4604,7 +4604,7 @@ static struct cftype mem_cgroup_files[] = {
 #ifdef CONFIG_NUMA
 	{
 		.name = "numa_stat",
-		.read_seq_string = mem_control_numa_stat_show,
+		.read_seq_string = memcg_numa_stat_show,
 	},
 #endif
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
-- 
1.7.9.5
