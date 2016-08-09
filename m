From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cpuset: make sure new tasks conform to the current config of
 the cpuset
Date: Tue, 9 Aug 2016 11:25:01 +0800
Message-ID: <57A94D0D.5040006@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

A new task inherits cpus_allowed and mems_allowed masks from its parent,
but if someone changes cpuset's config by writing to cpuset.cpus/cpuset.mems
before this new task is inserted into the cgroup's task list, the new task
won't be updated accordingly.

Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index c7fd277..c27e533 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2069,6 +2069,20 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
 	mutex_unlock(&cpuset_mutex);
 }
 
+/*
+ * Make sure the new task conform to the current state of its parent,
+ * which could have been changed by cpuset just after it inherits the
+ * state from the parent and before it sits on the cgroup's task list.
+ */
+void cpuset_fork(struct task_struct *task)
+{
+	if (task_css_is_root(task, cpuset_cgrp_id))
+		return;
+
+	set_cpus_allowed_ptr(task, &current->cpus_allowed);
+	task->mems_allowed = current->mems_allowed;
+}
+
 struct cgroup_subsys cpuset_cgrp_subsys = {
 	.css_alloc	= cpuset_css_alloc,
 	.css_online	= cpuset_css_online,
@@ -2079,6 +2093,7 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
 	.attach		= cpuset_attach,
 	.post_attach	= cpuset_post_attach,
 	.bind		= cpuset_bind,
+	.fork		= cpuset_fork,
 	.legacy_cftypes	= files,
 	.early_init	= true,
 };
-- 
1.8.2.2
