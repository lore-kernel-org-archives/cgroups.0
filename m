From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v3 02/12] cpuset: update cpuset->effective_{cpus,mems} at
 hotplug
Date: Wed, 9 Jul 2014 16:47:16 +0800
Message-ID: <53BD0194.6020300@huawei.com>
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

The first item is done here.

This won't introduce behavior change.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index ef0974c..94f651d 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2082,6 +2082,7 @@ retry:
 
 	mutex_lock(&callback_mutex);
 	cpumask_andnot(cs->cpus_allowed, cs->cpus_allowed, &off_cpus);
+	cpumask_andnot(cs->effective_cpus, cs->effective_cpus, &off_cpus);
 	mutex_unlock(&callback_mutex);
 
 	/*
@@ -2096,6 +2097,7 @@ retry:
 
 	mutex_lock(&callback_mutex);
 	nodes_andnot(cs->mems_allowed, cs->mems_allowed, off_mems);
+	nodes_andnot(cs->effective_mems, cs->effective_mems, off_mems);
 	mutex_unlock(&callback_mutex);
 
 	/*
@@ -2159,6 +2161,7 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	if (cpus_updated) {
 		mutex_lock(&callback_mutex);
 		cpumask_copy(top_cpuset.cpus_allowed, &new_cpus);
+		cpumask_copy(top_cpuset.effective_cpus, &new_cpus);
 		mutex_unlock(&callback_mutex);
 		/* we don't mess with cpumasks of tasks in top_cpuset */
 	}
@@ -2167,6 +2170,7 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	if (mems_updated) {
 		mutex_lock(&callback_mutex);
 		top_cpuset.mems_allowed = new_mems;
+		top_cpuset.effective_mems = new_mems;
 		mutex_unlock(&callback_mutex);
 		update_tasks_nodemask(&top_cpuset);
 	}
-- 
1.8.0.2
