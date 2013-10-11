From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v2 04/12] cpuset: inherit ancestor's masks if  effective_{cpus,mems}
 becomes empty
Date: Fri, 11 Oct 2013 17:50:18 +0800
Message-ID: <5257C9DA.80609@huawei.com>
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

To make cs->effective_{cpus,mems} to be effective masks, we need to
  - change the effective masks at hotplug
  - change the effective masks at config change
  - take on ancestor's mask when the effective mask is empty

This won't introduce behavior change.

v2:
- Add comments to explain effective masks are the same with configured
masks for !sane_behavior.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 48 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index bdc6047..6723b88 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -899,16 +899,22 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpuset *trialcs,
 		struct cpuset *parent = parent_cs(cp);
 		struct cpumask *new_cpus = trialcs->effective_cpus;
 
-		cpumask_and(new_cpus, cp->cpus_allowed,
-			    parent->effective_cpus);
+		/*
+		 * If !sane_behavior, new_cpus will equals cpus_allowed,
+		 * which is not empty, so it's guaranteed the effective mask
+		 * is the same with the configured mask.
+		 */
+		cpumask_and(new_cpus, cp->cpus_allowed, parent->effective_cpus);
 
 		/*
-		 * Skip the whole subtree if the cpumask remains the same
-		 * and isn't empty. If it's empty, we need to update tasks
-		 * to take on an ancestor's cpumask.
+		 * If it becomes empty, inherit the effective mask of the
+		 * parent, which is guaranteed to have some CPUs.
 		 */
-		if (cpumask_equal(new_cpus, cp->effective_cpus) &&
-		    ((cp == cs) || !cpumask_empty(new_cpus))) {
+		if (cpumask_empty(new_cpus))
+			cpumask_copy(new_cpus, parent->effective_cpus);
+
+		/* Skip the whole subtree if the cpumask remains the same. */
+		if (cpumask_equal(new_cpus, cp->effective_cpus)) {
 			pos_css = css_rightmost_descendant(pos_css);
 			continue;
 		}
@@ -1163,16 +1169,22 @@ static void update_nodemasks_hier(struct cpuset *cs, struct cpuset *trialcs,
 		struct cpuset *parent = parent_cs(cp);
 		nodemask_t *new_mems = &trialcs->effective_mems;
 
-		nodes_and(*new_mems, cp->mems_allowed,
-			  parent->effective_mems);
+		/*
+		 * If !sane_behavior, new_mems will equal mems_allowed,
+		 * which is not empty, so it's guaranteed the effective mask
+		 * is the same with the configured mask.
+		 */
+		nodes_and(*new_mems, cp->mems_allowed, parent->effective_mems);
 
 		/*
-		 * Skip the whole subtree if the nodemask remains the same
-		 * and isn't empty. If it's empty, we need to update tasks
-		 * to take on an ancestor's nodemask.
+		 * If it becomes empty, inherit the effective mask of the
+		 * parent, which is guaranteed to have some MEMs.
 		 */
-		if (nodes_equal(*new_mems, cp->effective_mems) &&
-		    ((cp == cs) || !nodes_empty(*new_mems))) {
+		if (nodes_empty(*new_mems))
+			*new_mems = parent->effective_mems;
+
+		/* Skip the whole subtree if the nodemask is not changed. */
+		if (nodes_equal(*new_mems, cp->effective_mems)) {
 			pos_css = css_rightmost_descendant(pos_css);
 			continue;
 		}
@@ -2203,7 +2215,11 @@ retry:
 
 	mutex_lock(&callback_mutex);
 	cpumask_andnot(cs->cpus_allowed, cs->cpus_allowed, &off_cpus);
+
+	/* Inherit the effective mask of the parent, if it becomes empty. */
 	cpumask_andnot(cs->effective_cpus, cs->effective_cpus, &off_cpus);
+	if (sane && cpumask_empty(cs->effective_cpus))
+		cpumask_copy(cs->effective_cpus, parent_cs(cs)->effective_cpus);
 	mutex_unlock(&callback_mutex);
 
 	/*
@@ -2218,7 +2234,11 @@ retry:
 
 	mutex_lock(&callback_mutex);
 	nodes_andnot(cs->mems_allowed, cs->mems_allowed, off_mems);
+
+	/* Inherit the effective mask of the parent, if it becomes empty */
 	nodes_andnot(cs->effective_mems, cs->effective_mems, off_mems);
+	if (sane && nodes_empty(cs->effective_mems))
+		cs->effective_mems = parent_cs(cs)->effective_mems;
 	mutex_unlock(&callback_mutex);
 
 	/*
-- 
1.8.0.2
