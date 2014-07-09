From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v3 04/12] cpuset: inherit ancestor's masks if effective_{cpus,mems}
 becomes empty
Date: Wed, 9 Jul 2014 16:47:41 +0800
Message-ID: <53BD01AD.6070003@huawei.com>
References: <53BD0174.4060002@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53BD0174.4060002@huawei.com>
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

Those behavior changes are for default hierarchy only. For legacy
hierarchy, effective_mask and configured_mask are the same, so we won't
break old interfaces.

To make cs->effective_{cpus,mems} to be effective masks, we need to
  - update the effective masks at hotplug
  - update the effective masks at config change
  - take on ancestor's mask when the effective mask is empty

The last item is done here.

This won't introduce behavior change.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index da766c3..f834002 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -877,6 +877,13 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 
 		cpumask_and(new_cpus, cp->cpus_allowed, parent->effective_cpus);
 
+		/*
+		 * If it becomes empty, inherit the effective mask of the
+		 * parent, which is guaranteed to have some CPUs.
+		 */
+		if (cpumask_empty(new_cpus))
+			cpumask_copy(new_cpus, parent->effective_cpus);
+
 		/* Skip the whole subtree if the cpumask remains the same. */
 		if (cpumask_equal(new_cpus, cp->effective_cpus)) {
 			pos_css = css_rightmost_descendant(pos_css);
@@ -1123,6 +1130,13 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 
 		nodes_and(*new_mems, cp->mems_allowed, parent->effective_mems);
 
+		/*
+		 * If it becomes empty, inherit the effective mask of the
+		 * parent, which is guaranteed to have some MEMs.
+		 */
+		if (nodes_empty(*new_mems))
+			*new_mems = parent->effective_mems;
+
 		/* Skip the whole subtree if the nodemask remains the same. */
 		if (nodes_equal(*new_mems, cp->effective_mems)) {
 			pos_css = css_rightmost_descendant(pos_css);
@@ -2102,7 +2116,11 @@ retry:
 
 	mutex_lock(&callback_mutex);
 	cpumask_andnot(cs->cpus_allowed, cs->cpus_allowed, &off_cpus);
+
+	/* Inherit the effective mask of the parent, if it becomes empty. */
 	cpumask_andnot(cs->effective_cpus, cs->effective_cpus, &off_cpus);
+	if (on_dfl && cpumask_empty(cs->effective_cpus))
+		cpumask_copy(cs->effective_cpus, parent_cs(cs)->effective_cpus);
 	mutex_unlock(&callback_mutex);
 
 	/*
@@ -2117,7 +2135,11 @@ retry:
 
 	mutex_lock(&callback_mutex);
 	nodes_andnot(cs->mems_allowed, cs->mems_allowed, off_mems);
+
+	/* Inherit the effective mask of the parent, if it becomes empty */
 	nodes_andnot(cs->effective_mems, cs->effective_mems, off_mems);
+	if (on_dfl && nodes_empty(cs->effective_mems))
+		cs->effective_mems = parent_cs(cs)->effective_mems;
 	mutex_unlock(&callback_mutex);
 
 	/*
-- 
1.8.0.2
