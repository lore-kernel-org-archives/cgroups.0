From: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH -V3 1/1] cgroup: Add inotify event on change tasks file (fork,
 exit, move pid from file)
Date: Thu, 03 May 2012 13:21:11 +0400
Message-ID: <4FA24E07.1010206@samsung.com>
References: <4F98E4E5.6020602@samsung.com> <4F98E57E.1040201@samsung.com>
 <20120427223455.GU26595@google.com> <4F9B82E1.3070602@samsung.com>
 <20120428214131.GB4586@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_tJ6wh1a9XdyqWP8zphS8Tg)"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20120428214131.GB4586-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Dmitry Solodkiy <d.solodkiy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

This is a multi-part message in MIME format.

--Boundary_(ID_tJ6wh1a9XdyqWP8zphS8Tg)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT



--Boundary_(ID_tJ6wh1a9XdyqWP8zphS8Tg)
Content-type: text/x-patch; name=cgroup_fsnotify.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=cgroup_fsnotify.patch

Signed-off-by: Alex Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

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
index ad8eae5..8fabfd4 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -60,6 +60,7 @@
 #include <linux/eventfd.h>
 #include <linux/poll.h>
 #include <linux/flex_array.h> /* used in cgroup_attach_proc */
+#include <linux/fsnotify.h> /* used in fsnotify_cgroup() */
 #include <linux/kthread.h>
 
 #include <linux/atomic.h>
@@ -738,6 +739,23 @@ static struct cgroup *task_cgroup_from_root(struct task_struct *task,
 	return res;
 }
 
+static void fsnotify_cgroup(struct task_struct *tsk, __u32 mask)
+{
+	struct cgroupfs_root *root;
+	struct inode	*d_inode;
+	struct cgroup	*cgrp;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	for_each_active_root(root) {
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
@@ -1978,6 +1996,9 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 		goto out;
 	}
 
+	/* cgroup_attach_task() already guarded by cgroup_lock by caller */
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
+		return NULL;
 
 	dentry = lookup_one_len(name, dir, strlen(name));
 	if (IS_ERR(dentry)) {
 		error = PTR_ERR(dentry);
-		goto out;
+		kfree(cfe);
+		return NULL;
 	}
 
 	mode = cgroup_file_mode(cft);
@@ -2711,29 +2733,34 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
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
+			if(!cfe) {
+				pr_warning("%s: failed to add %s\n",
+					   __func__, cft->name);
+				ret = -1;
+			} else if(strcmp(cft->name, "tasks") == 0)
+				cgrp->tasks_cfe = cfe;
+		} else {
+			if (cgroup_rm_file(cgrp, cft)) {
+				pr_warning("%s: failed to remove %s\n",
+					   __func__, cft->name);
+				ret = -1;
+			}
 		}
 	}
 	return ret;
@@ -4757,6 +4784,10 @@ void cgroup_fork(struct task_struct *child)
 	child->cgroups = current->cgroups;
 	get_css_set(child->cgroups);
 	INIT_LIST_HEAD(&child->cg_list);
+
+	cgroup_lock();
+	fsnotify_cgroup(child, FS_MODIFY);
+	cgroup_unlock();
 }
 
 /**
@@ -4879,6 +4910,11 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
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

--Boundary_(ID_tJ6wh1a9XdyqWP8zphS8Tg)--
