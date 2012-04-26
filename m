From: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFD/RFC v2] event about group change
Date: Thu, 26 Apr 2012 10:04:46 +0400
Message-ID: <4F98E57E.1040201@samsung.com>
References: <4F98E4E5.6020602@samsung.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_f8opUkPXv9At+MuL5/z8qQ)"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <4F98E4E5.6020602-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Dmitry Solodkiy <d.solodkiy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

This is a multi-part message in MIME format.

--Boundary_(ID_f8opUkPXv9At+MuL5/z8qQ)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT



--Boundary_(ID_f8opUkPXv9At+MuL5/z8qQ)
Content-type: text/x-patch; name=cgroup_fsnotify.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=cgroup_fsnotify.patch

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5a85b34..3594c40 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -179,6 +179,8 @@ struct cgroup {
 	struct cgroup *parent;		/* my parent */
 	struct dentry __rcu *dentry;	/* cgroup fs entry, RCU protected */
 
+	struct dentry *tasks_dentry;	/* "tasks" dentry */
+
 	/* Private pointers for each registered subsystem */
 	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
 
@@ -387,7 +389,8 @@ struct cgroup_scanner {
  * called by subsystems from within a populate() method
  */
 int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
-		       const struct cftype *cft);
+		       const struct cftype *cft,
+		       int tasks);
 
 /*
  * Add a set of new files to the given cgroup directory. Should
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ed64cca..9ba3c02 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -60,6 +60,7 @@
 #include <linux/eventfd.h>
 #include <linux/poll.h>
 #include <linux/flex_array.h> /* used in cgroup_attach_proc */
+#include <linux/fsnotify.h>
 
 #include <linux/atomic.h>
 
@@ -699,6 +700,21 @@ static struct cgroup *task_cgroup_from_root(struct task_struct *task,
 	return res;
 }
 
+static inline void fsnotify_cgroup(struct task_struct *tsk, __u32 mask)
+{
+	struct cgroupfs_root *root;
+	struct inode	*d_inode;
+	struct cgroup	*cgrp;
+
+	for_each_active_root(root) {
+		cgrp = task_cgroup_from_root(tsk, root);
+		d_inode = cgrp->tasks_dentry->d_inode;
+
+		fsnotify_parent(NULL, cgrp->tasks_dentry, mask);
+		fsnotify(d_inode, mask, d_inode, FSNOTIFY_EVENT_INODE, NULL, 0);
+	}
+}
+
 /*
  * There is one global cgroup mutex. We also require taking
  * task_lock() when dereferencing a task's cgroup subsys pointers.
@@ -1924,6 +1940,9 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 		goto out;
 	}
 
+	/* send event to the userspace */
+	fsnotify_cgroup(tsk, FS_MODIFY);
+
 	cgroup_task_migrate(cgrp, oldcgrp, tsk, newcg);
 
 	for_each_subsys(root, ss) {
@@ -2605,7 +2624,8 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
 
 int cgroup_add_file(struct cgroup *cgrp,
 		       struct cgroup_subsys *subsys,
-		       const struct cftype *cft)
+		       const struct cftype *cft,
+		       int tasks)
 {
 	struct dentry *dir = cgrp->dentry;
 	struct dentry *dentry;
@@ -2629,6 +2649,12 @@ int cgroup_add_file(struct cgroup *cgrp,
 		dput(dentry);
 	} else
 		error = PTR_ERR(dentry);
+
+	if(tasks) {
+		pr_warn("%s(): cft name: %s\n", __func__, name);
+		cgrp->tasks_dentry = dentry;
+	}
+
 	return error;
 }
 EXPORT_SYMBOL_GPL(cgroup_add_file);
@@ -2640,7 +2666,7 @@ int cgroup_add_files(struct cgroup *cgrp,
 {
 	int i, err;
 	for (i = 0; i < count; i++) {
-		err = cgroup_add_file(cgrp, subsys, &cft[i]);
+		err = cgroup_add_file(cgrp, subsys, &cft[i], 0);
 		if (err)
 			return err;
 	}
@@ -3642,12 +3668,16 @@ static int cgroup_populate_dir(struct cgroup *cgrp)
 	/* First clear out any existing files */
 	cgroup_clear_directory(cgrp->dentry);
 
-	err = cgroup_add_files(cgrp, NULL, files, ARRAY_SIZE(files));
+	err = cgroup_add_file(cgrp, NULL, files, 1);
+	if (err)
+		return err;
+
+	err = cgroup_add_files(cgrp, NULL, files + 1, ARRAY_SIZE(files) - 1);
 	if (err < 0)
 		return err;
 
 	if (cgrp == cgrp->top_cgroup) {
-		if ((err = cgroup_add_file(cgrp, NULL, &cft_release_agent)) < 0)
+		if ((err = cgroup_add_file(cgrp, NULL, &cft_release_agent, 0)) < 0)
 			return err;
 	}
 
@@ -4480,6 +4510,7 @@ static const struct file_operations proc_cgroupstats_operations = {
  */
 void cgroup_fork(struct task_struct *child)
 {
+
 	/*
 	 * We don't need to task_lock() current because current->cgroups
 	 * can't be changed concurrently here. The parent obviously hasn't
@@ -4489,6 +4520,10 @@ void cgroup_fork(struct task_struct *child)
 	child->cgroups = current->cgroups;
 	get_css_set(child->cgroups);
 	INIT_LIST_HEAD(&child->cg_list);
+
+	cgroup_lock();
+	fsnotify_cgroup(child, FS_MODIFY);
+	cgroup_unlock();
 }
 
 /**
@@ -4611,6 +4646,11 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
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

--Boundary_(ID_f8opUkPXv9At+MuL5/z8qQ)--
