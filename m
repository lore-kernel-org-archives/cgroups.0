From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 05/10] cpuset: don't update tasks' cpumask and nodemask in
 an empty cpuset
Date: Fri, 19 Apr 2013 20:27:05 +0800
Message-ID: <51713819.8050708@huawei.com>
References: <517137A7.4020605@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <517137A7.4020605@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Containers <containers@lists.linux-foundation.org>, Glauber Costa <glommer@parallels.com>

I think this was introduced unintentionally when cpuset hotplug was
made asynchronous. Fortunately it does no harm, as updating tasks'
cpumask will just return failure and there's a guarantee_online_mems()
when updating nodemask, and then the tasks will be moved to an ancestor
cpuset.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 8b0e433..2e4c5af 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2013,7 +2013,9 @@ static void cpuset_propagate_hotplug_workfn(struct work_struct *work)
 		mutex_lock(&callback_mutex);
 		cpumask_andnot(cs->cpus_allowed, cs->cpus_allowed, &off_cpus);
 		mutex_unlock(&callback_mutex);
-		update_tasks_cpumask(cs, NULL);
+
+		if (!cpumask_empty(cs->cpus_allowed))
+			update_tasks_cpumask(cs, NULL);
 	}
 
 	/* remove offline mems from @cs */
@@ -2022,7 +2024,9 @@ static void cpuset_propagate_hotplug_workfn(struct work_struct *work)
 		mutex_lock(&callback_mutex);
 		nodes_andnot(cs->mems_allowed, cs->mems_allowed, off_mems);
 		mutex_unlock(&callback_mutex);
-		update_tasks_nodemask(cs, &tmp_mems, NULL);
+
+		if (!nodes_empty(cs->mems_allowed))
+			update_tasks_nodemask(cs, &tmp_mems, NULL);
 	}
 
 	is_empty = cpumask_empty(cs->cpus_allowed) ||
-- 
1.8.0.2
