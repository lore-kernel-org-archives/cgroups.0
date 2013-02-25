From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] cpuset: use cgroup_name() in cpuset_print_task_mems_allowed()
Date: Mon, 25 Feb 2013 14:18:50 +0800
Message-ID: <512B024A.7080702@huawei.com>
References: <512B01FA.5020506@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <512B01FA.5020506-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Use cgroup_name() instead of cgrp->dentry->name. This makes the code
simpler.

While at it, remove cpuset_name and make cpuset_nodelist a local variable
to cpuset_print_task_mems_allowed().

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4f9dfe4..ace5bfc 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -265,17 +265,6 @@ static DEFINE_MUTEX(cpuset_mutex);
 static DEFINE_MUTEX(callback_mutex);
 
 /*
- * cpuset_buffer_lock protects both the cpuset_name and cpuset_nodelist
- * buffers.  They are statically allocated to prevent using excess stack
- * when calling cpuset_print_task_mems_allowed().
- */
-#define CPUSET_NAME_LEN		(128)
-#define	CPUSET_NODELIST_LEN	(256)
-static char cpuset_name[CPUSET_NAME_LEN];
-static char cpuset_nodelist[CPUSET_NODELIST_LEN];
-static DEFINE_SPINLOCK(cpuset_buffer_lock);
-
-/*
  * CPU / memory hotplug is handled asynchronously.
  */
 static struct workqueue_struct *cpuset_propagate_hotplug_wq;
@@ -2592,6 +2581,8 @@ int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
 	return nodes_intersects(tsk1->mems_allowed, tsk2->mems_allowed);
 }
 
+#define CPUSET_NODELIST_LEN	(256)
+
 /**
  * cpuset_print_task_mems_allowed - prints task's cpuset and mems_allowed
  * @task: pointer to task_struct of some task.
@@ -2602,24 +2593,19 @@ int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
  */
 void cpuset_print_task_mems_allowed(struct task_struct *tsk)
 {
-	struct dentry *dentry;
+	 /* Statically allocated to prevent using excess stack. */
+	static char cpuset_nodelist[CPUSET_NODELIST_LEN];
+	static DEFINE_SPINLOCK(cpuset_buffer_lock);
 
-	dentry = task_cs(tsk)->css.cgroup->dentry;
-	spin_lock(&cpuset_buffer_lock);
+	struct cgroup *cgrp = task_cs(tsk)->css.cgroup;
 
-	if (!dentry) {
-		strcpy(cpuset_name, "/");
-	} else {
-		spin_lock(&dentry->d_lock);
-		strlcpy(cpuset_name, (const char *)dentry->d_name.name,
-			CPUSET_NAME_LEN);
-		spin_unlock(&dentry->d_lock);
-	}
+	spin_lock(&cpuset_buffer_lock);
 
 	nodelist_scnprintf(cpuset_nodelist, CPUSET_NODELIST_LEN,
 			   tsk->mems_allowed);
 	printk(KERN_INFO "%s cpuset=%s mems_allowed=%s\n",
-	       tsk->comm, cpuset_name, cpuset_nodelist);
+	       tsk->comm, cgroup_name(cgrp), cpuset_nodelist);
+
 	spin_unlock(&cpuset_buffer_lock);
 }
 
-- 
1.8.0.2
