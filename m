From: Alex Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH V4 1/1] cgroup: add inotify FS_MODIFY event on changing tasks
 file
Date: Fri, 04 May 2012 13:46:45 +0400
Message-ID: <1336124805-6704-2-git-send-email-a.nikiforov@samsung.com>
References: <1336124805-6704-1-git-send-email-a.nikiforov@samsung.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1336124805-6704-1-git-send-email-a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, d.solodkiy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Alex Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Currently, user can get inotify FS_MODIFY event only if
"tasks" file changed from user space side (for example
echo $$ > /patch/to/cgroup/tasks), but if another process forked
user don't get FS_MODIFY event. This patch add this feature.
With this user can get FS_MODIFY on do_fork()/do_exit()/move PID
from one group to another.

Signed-off-by: Alex Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/cgroup.h |    2 +
 kernel/cgroup.c        |   81 ++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 66 insertions(+), 17 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index d3f5fba..9d0d622 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -181,6 +181,8 @@ struct cgroup {
 	struct cgroup *parent;		/* my parent */
 	struct dentry __rcu *dentry;	/* cgroup fs entry, RCU protected */
 
+	struct cfent *tasks_cfe;	/* "tasks" cfent */
+
 	/* Private pointers for each registered subsystem */
 	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ad8eae5..f246c7d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -60,6 +60,7 @@
 #include <linux/eventfd.h>
 #include <linux/poll.h>
 #include <linux/flex_array.h> /* used in cgroup_attach_proc */
+#include <linux/fsnotify.h> /* used in fsnotify_cgroup() */
 #include <linux/kthread.h>
 
 #include <linux/atomic.h>
@@ -738,6 +739,24 @@ static struct cgroup *task_cgroup_from_root(struct task_struct *task,
 	return res;
 }
 
+static void fsnotify_cgroup(struct task_struct *tsk, __u32 mask)
+{
+	struct cgroupfs_root *root;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	for_each_active_root(root) {
+		struct inode *d_inode;
+		struct cgroup *cgrp;
+
+		cgrp = task_cgroup_from_root(tsk, root);
+		d_inode = cgrp->tasks_cfe->dentry->d_inode;
+
+		fsnotify_parent(NULL, cgrp->tasks_cfe->dentry, mask);
+		fsnotify(d_inode, mask, d_inode, FSNOTIFY_EVENT_INODE, NULL, 0);
+	}
+}
+
 /*
  * There is one global cgroup mutex. We also require taking
  * task_lock() when dereferencing a task's cgroup subsys pointers.
@@ -1978,6 +1997,8 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 		goto out;
 	}
 
+	fsnotify_cgroup(tsk, FS_MODIFY);
+
 	cgroup_task_migrate(cgrp, oldcgrp, tsk, newcg);
 
 	for_each_subsys(root, ss) {
@@ -2669,7 +2690,7 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
 	return mode;
 }
 
-static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
+static struct cfent* cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 			   const struct cftype *cft)
 {
 	struct dentry *dir = cgrp->dentry;
@@ -2696,12 +2717,13 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 
 	cfe = kzalloc(sizeof(*cfe), GFP_KERNEL);
 	if (!cfe)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	dentry = lookup_one_len(name, dir, strlen(name));
 	if (IS_ERR(dentry)) {
 		error = PTR_ERR(dentry);
-		goto out;
+		kfree(cfe);
+		return (struct cfent *)dentry;
 	}
 
 	mode = cgroup_file_mode(cft);
@@ -2711,29 +2733,31 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 		cfe->dentry = dentry;
 		dentry->d_fsdata = cfe;
 		list_add_tail(&cfe->node, &parent->files);
-		cfe = NULL;
 	}
 	dput(dentry);
-out:
-	kfree(cfe);
-	return error;
+
+	return cfe;
 }
 
 static int cgroup_addrm_files(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 			      const struct cftype cfts[], bool is_add)
 {
 	const struct cftype *cft;
-	int err, ret = 0;
+	struct cfent *cfe;
+	int ret = 0;
 
 	for (cft = cfts; cft->name[0] != '\0'; cft++) {
-		if (is_add)
-			err = cgroup_add_file(cgrp, subsys, cft);
-		else
-			err = cgroup_rm_file(cgrp, cft);
-		if (err) {
-			pr_warning("cgroup_addrm_files: failed to %s %s, err=%d\n",
-				   is_add ? "add" : "remove", cft->name, err);
-			ret = err;
+		if (is_add) {
+			cfe = cgroup_add_file(cgrp, subsys, cft);
+			if (IS_ERR(cfe)) {
+				pr_warn("%s: failed to add %s\n", __func__, cft->name);
+				ret = -1;
+			}
+		} else {
+			if (cgroup_rm_file(cgrp, cft)) {
+				pr_warn("%s: failed to remove %s\n", __func__, cft->name);
+				ret = -1;
+			}
 		}
 	}
 	return ret;
@@ -3804,6 +3828,10 @@ static int cgroup_clone_children_write(struct cgroup *cgrp,
 #define CGROUP_FILE_GENERIC_PREFIX "cgroup."
 static struct cftype files[] = {
 	{
+		/*
+		 * don't move tasks from first place, cgroup_populate_dir()
+		 * thinks that "tasks" is first
+		 */
 		.name = "tasks",
 		.open = cgroup_tasks_open,
 		.write_u64 = cgroup_tasks_write,
@@ -3846,8 +3874,18 @@ static int cgroup_populate_dir(struct cgroup *cgrp)
 {
 	int err;
 	struct cgroup_subsys *ss;
+	struct cfent *cfe;
 
-	err = cgroup_addrm_files(cgrp, NULL, files, true);
+	/* create "tasks" file, save cfent */
+	cfe = cgroup_add_file(cgrp, NULL, files);
+	if (IS_ERR(cfe)) {
+		pr_warn("%s: failed to add %s\n", __func__, files[0].name);
+		return -1;
+	}
+	cgrp->tasks_cfe = cfe;
+
+	/* add files after "tasks" */
+	err = cgroup_addrm_files(cgrp, NULL, files + 1, true);
 	if (err < 0)
 		return err;
 
@@ -4757,6 +4795,10 @@ void cgroup_fork(struct task_struct *child)
 	child->cgroups = current->cgroups;
 	get_css_set(child->cgroups);
 	INIT_LIST_HEAD(&child->cg_list);
+
+	cgroup_lock();
+	fsnotify_cgroup(child, FS_MODIFY);
+	cgroup_unlock();
 }
 
 /**
@@ -4879,6 +4921,11 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 	/* Reassign the task to the init_css_set. */
 	task_lock(tsk);
 	cg = tsk->cgroups;
+
+	cgroup_lock();
+	fsnotify_cgroup(tsk, FS_MODIFY);
+	cgroup_unlock();
+
 	tsk->cgroups = &init_css_set;
 
 	if (run_callbacks && need_forkexit_callback) {
-- 
1.7.5.4
