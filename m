From: <chaixianping@huawei.com>
Subject: [PATCH] Cgroup:Fix race between fork and update cpuset mask
Date: Thu, 4 Aug 2016 19:23:03 +0800
Message-ID: <1470309783-11328-1-git-send-email-chaixianping@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, chaixianping <chaixianping@huawei.com>, Zhenghua Jia <jiazhenghua@huawei.com>, Leeyou <leeyou.li@huawei.com>, Lei Liu <liulei@huawei.com>

From: chaixianping <chaixianping@huawei.com>

Fix the race between fork and update_cpumask or update_nodemask.
Scenario as follows:
1)A process fork a child process, the child process have
inherited the parent process cpus_allowed,mems_allowed
Before being added cset->tasks list.
2)Update_cpumask or update_nodemask change the parent's allowed
to a new value, *but the child still is the old value.
after being added cset->tasks list.

Signed-off-by: Xianping Chai <chaixianping@huawei.com>
Signed-off-by: Zhenghua Jia <jiazhenghua@huawei.com>
Signed-off-by: Leeyou <leeyou.li@huawei.com>
Signed-off-by: Lei Liu <liulei@huawei.com>
---
 kernel/cpuset.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index c7fd277..ae3d092 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1015,6 +1015,34 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
 	}
 }
 
+
+/*
+ *Fix the race between fork and update_cpumask or update_nodemask.
+ *Scenario as follows:
+ *1)A process fork a child process, the child process have
+ *inherited the parent process cpus_allowed,mems_allowed
+ *Before being added cset->tasks list.
+ *2)Update_cpumask or update_nodemask change the parent's allowed
+ *to a new value, *but the child still is the old value
+ *after being added cset->tasks list.
+ */
+static void cpuset_fork(struct task_struct *task)
+{
+	nodemask_t cpuset_mems_allowed;
+
+	mutex_lock(&cpuset_mutex);
+	rcu_read_lock();
+
+	cpumask_copy(&task->cpus_allowed, task_cs(task)->effective_cpus);
+	task->nr_cpus_allowed = cpumask_weight(task_cs(task)->effective_cpus);
+
+	guarantee_online_mems(task_cs(task), &cpuset_mems_allowed);
+	task->mems_allowed = cpuset_mems_allowed;
+
+	rcu_read_unlock();
+	mutex_unlock(&cpuset_mutex);
+}
+
 static void cpuset_post_attach(void)
 {
 	flush_workqueue(cpuset_migrate_mm_wq);
@@ -2078,6 +2106,7 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
 	.cancel_attach	= cpuset_cancel_attach,
 	.attach		= cpuset_attach,
 	.post_attach	= cpuset_post_attach,
+	.fork   = cpuset_fork,
 	.bind		= cpuset_bind,
 	.legacy_cftypes	= files,
 	.early_init	= true,
-- 
2.6.2

