From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v2 05/12] cpuset: use effective cpumask to build sched domains
Date: Fri, 11 Oct 2013 17:50:38 +0800
Message-ID: <5257C9EE.9080902@huawei.com>
References: <5257C9A1.1030404@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5257C9A1.1030404@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>

We're going to have separate user-configured masks and effective ones.

Eventually configured masks can only be changed by writing cpuset.cpus
and cpuset.mems, and they won't be restricted by parent cpuset. While
effective masks reflect cpu/memory hotplug and hierachical restriction,
and these are the real masks that apply to the tasks in the cpuset.

We calculate effective mask this way:
  - top cpuset's effective_mask == online_mask, otherwise
  - cpuset's effective_mask == configured_mask & parent effective_mask,
    if the result is empty, it inherits parent effective mask.

Those behavior changes are for sane_behavior only. For !sane_behavior
effective_mask and configured_mask are the same, so we won't break old
interfaces.

This patch updatse cpuset to use effective masks to build sched domains.

This won't introduce behavior change.

v2:
- Add a comment for the call of rebuild_sched_domains(), suggested
by Tejun.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 6723b88..360e547 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -499,11 +499,11 @@ out:
 #ifdef CONFIG_SMP
 /*
  * Helper routine for generate_sched_domains().
- * Do cpusets a, b have overlapping cpus_allowed masks?
+ * Do cpusets a, b have overlapping effective cpus_allowed masks?
  */
 static int cpusets_overlap(struct cpuset *a, struct cpuset *b)
 {
-	return cpumask_intersects(a->cpus_allowed, b->cpus_allowed);
+	return cpumask_intersects(a->effective_cpus, b->effective_cpus);
 }
 
 static void
@@ -620,7 +620,7 @@ static int generate_sched_domains(cpumask_var_t **domains,
 			*dattr = SD_ATTR_INIT;
 			update_domain_attr_tree(dattr, &top_cpuset);
 		}
-		cpumask_copy(doms[0], top_cpuset.cpus_allowed);
+		cpumask_copy(doms[0], top_cpuset.effective_cpus);
 
 		goto done;
 	}
@@ -727,7 +727,7 @@ restart:
 			struct cpuset *b = csa[j];
 
 			if (apn == b->pn) {
-				cpumask_or(dp, dp, b->cpus_allowed);
+				cpumask_or(dp, dp, b->effective_cpus);
 				if (dattr)
 					update_domain_attr_tree(dattr + nslot, b);
 
@@ -893,6 +893,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpuset *trialcs,
 {
 	struct cgroup_subsys_state *pos_css;
 	struct cpuset *cp;
+	bool need_rebuild_sched_domains = false;
 
 	rcu_read_lock();
 	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
@@ -930,10 +931,21 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpuset *trialcs,
 
 		update_tasks_cpumask(cp, heap);
 
+		/*
+		 * If the effective cpumask of any non-empty cpuset is
+		 * changed, we need to rebuild sched domains.
+		 */
+		if (!cpumask_empty(cp->cpus_allowed) &&
+		    is_sched_load_balance(cp))
+			need_rebuild_sched_domains = true;
+
 		rcu_read_lock();
 		css_put(&cp->css);
 	}
 	rcu_read_unlock();
+
+	if (need_rebuild_sched_domains)
+		rebuild_sched_domains_locked();
 }
 
 /**
@@ -987,9 +999,6 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	update_cpumasks_hier(cs, trialcs, &heap);
 
 	heap_free(&heap);
-
-	if (is_sched_load_balance(cs))
-		rebuild_sched_domains_locked();
 	return 0;
 }
 
-- 
1.8.0.2
