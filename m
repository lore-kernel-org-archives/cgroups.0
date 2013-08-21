From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 03/11] cpuset: update cpuset->real_{cpus,mems}_allowed at
 hotplug
Date: Wed, 21 Aug 2013 17:59:23 +0800
Message-ID: <52148F7B.7040302@huawei.com>
References: <52148F52.0@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52148F52.0@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Containers <containers@lists.linux-foundation.org>

We're going to have separate user-configured masks and effective ones.

At last configured masks can only be changed by writing cpuset.cpus
and cpuset.mems, and they won't be restricted by parent cpuset. While
effective masks reflect cpu/memory hotplug and hierachical restriction.

This is a preparation to make real_{cpus,mems}_allowed to be effective
masks of the cpuset:

- change the effective masks at hotplug: done
- change the effective masks at config change: todo
- take on ancestor's mask when the effective mask is empty: todo

This won't introduce behavior change.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 404fea5..ab89c1e 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2185,6 +2185,8 @@ retry:
 
 	mutex_lock(&callback_mutex);
 	cpumask_andnot(cs->cpus_allowed, cs->cpus_allowed, &off_cpus);
+	cpumask_andnot(cs->real_cpus_allowed, cs->real_cpus_allowed,
+		       &off_cpus);
 	mutex_unlock(&callback_mutex);
 
 	/*
@@ -2199,6 +2201,7 @@ retry:
 
 	mutex_lock(&callback_mutex);
 	nodes_andnot(cs->mems_allowed, cs->mems_allowed, off_mems);
+	nodes_andnot(cs->real_mems_allowed, cs->real_mems_allowed, off_mems);
 	mutex_unlock(&callback_mutex);
 
 	/*
@@ -2262,6 +2265,7 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	if (cpus_updated) {
 		mutex_lock(&callback_mutex);
 		cpumask_copy(top_cpuset.cpus_allowed, &new_cpus);
+		cpumask_copy(top_cpuset.real_cpus_allowed, &new_cpus);
 		mutex_unlock(&callback_mutex);
 		/* we don't mess with cpumasks of tasks in top_cpuset */
 	}
@@ -2270,6 +2274,7 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	if (mems_updated) {
 		mutex_lock(&callback_mutex);
 		top_cpuset.mems_allowed = new_mems;
+		top_cpuset.real_mems_allowed = new_mems;
 		mutex_unlock(&callback_mutex);
 		update_tasks_nodemask(&top_cpuset, NULL);
 	}
-- 
1.8.0.2
