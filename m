From: Jason Low <jason.low2@hp.com>
Subject: [RFC][PATCH] cpuset, sched: Fix cpuset sched_relax_domain_level
Date: Wed, 28 Jan 2015 12:47:05 -0800
Message-ID: <1422478025.4111.31.camel@j-VirtualBox>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com, Jason Low <jason.low2@hp.com>

The cpuset.sched_relax_domain_level can control how far we do
immediate load balancing on a system. However, it was found on recent
kernels that echo'ing a value into cpuset.sched_relax_domain_level
did not reduce any immediate load balancing.

The reason this occurred was because the update_domain_attr_tree() traversal
did not update for the "top_cpuset". This resulted in nothing being changed
when modifying the sched_relax_domain_level parameter.

This patch was able to address that problem by having update_domain_attr_tree()
allowing updates for the root (top_cpuset) in the cpuset traversal.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/cpuset.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 64b257f..0f58c54 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -541,15 +541,17 @@ update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
 }
 
 static void update_domain_attr_tree(struct sched_domain_attr *dattr,
-				    struct cpuset *root_cs)
+				    struct cpuset *root_cs, bool update_root)
 {
 	struct cpuset *cp;
 	struct cgroup_subsys_state *pos_css;
 
 	rcu_read_lock();
 	cpuset_for_each_descendant_pre(cp, pos_css, root_cs) {
-		if (cp == root_cs)
-			continue;
+		if (cp == root_cs) {
+			if (!update_root)
+				continue;
+		}
 
 		/* skip the whole subtree if @cp doesn't have any CPU */
 		if (cpumask_empty(cp->cpus_allowed)) {
@@ -644,7 +646,7 @@ static int generate_sched_domains(cpumask_var_t **domains,
 		dattr = kmalloc(sizeof(struct sched_domain_attr), GFP_KERNEL);
 		if (dattr) {
 			*dattr = SD_ATTR_INIT;
-			update_domain_attr_tree(dattr, &top_cpuset);
+			update_domain_attr_tree(dattr, &top_cpuset, true);
 		}
 		cpumask_copy(doms[0], top_cpuset.effective_cpus);
 
@@ -752,7 +754,7 @@ restart:
 			if (apn == b->pn) {
 				cpumask_or(dp, dp, b->effective_cpus);
 				if (dattr)
-					update_domain_attr_tree(dattr + nslot, b);
+					update_domain_attr_tree(dattr + nslot, b, false);
 
 				/* Done with this partition */
 				b->pn = -1;
-- 
1.7.1


