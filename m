From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] cgroup: reorganize cgroup.procs / task write path
Date: Sun, 16 Jul 2017 22:07:16 -0400
Message-ID: <20170717020721.3612468-2-tj@kernel.org>
References: <20170717020721.3612468-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KUgo9LkDntVyzARCPzm7t3RK1fFRdZMxHhGqMsRaL6k=;
        b=kDYFFvLspX6NhkdkUCePDYbdZpHGGzw0U2l5Kkj2pxmRRaLU+3kJASUnx9wvuQu2/4
         bgIRotUadAg5L/0/nkQgNPzNAdXJF52rOlm1slXWWZhHDMSJGD6+aLs0/LfnSQH2hqwX
         fRMjpoPlmqh9hLH3uOrhOH5/2AhYYL2ZVx823TK9ci10hPp/OikDpU2MX5wHJX0xkCNi
         V2h0OdzJ/6prta7b8H5tVxEnHiBBDZYlqAlPd8kGBp7EDpIZmE3NdgN3VUkm7gK8Qp3T
         yaetwPRtC1HNJglK6i2jTjyWFMgCxdYM55RMM/V4bmas+Aj0i/DJr7N80YgB7SUlj07N
         OEFQ==
In-Reply-To: <20170717020721.3612468-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com, Tejun Heo <tj@kernel.org>

Currently, writes "cgroup.procs" and "cgroup.tasks" files are all
handled by __cgroup_procs_write() on both v1 and v2.  This patch
reoragnizes the write path so that there are common helper functions
that different write paths use.

While this somewhat increases LOC, the different paths are no longer
intertwined and each path has more flexibility to implement different
behaviors which will be necessary for the planned v2 thread support.

v3: - Restructured so that cgroup_procs_write_permission() takes
      @src_cgrp and @dst_cgrp.

v2: - Rolled in Waiman's task reference count fix.
    - Updated on top of nsdelegate changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cgroup-internal.h |   8 +-
 kernel/cgroup/cgroup-v1.c       |  58 ++++++++++--
 kernel/cgroup/cgroup.c          | 192 ++++++++++++++++++++--------------------
 3 files changed, 152 insertions(+), 106 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 793565c..0e81c61 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -180,10 +180,10 @@ int cgroup_migrate(struct task_struct *leader, bool threadgroup,
 
 int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 		       bool threadgroup);
-ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
-			     size_t nbytes, loff_t off, bool threadgroup);
-ssize_t cgroup_procs_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
-			   loff_t off);
+struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup)
+	__acquires(&cgroup_threadgroup_rwsem);
+void cgroup_procs_write_finish(struct task_struct *task)
+	__releases(&cgroup_threadgroup_rwsem);
 
 void cgroup_lock_and_drain_offline(struct cgroup *cgrp);
 
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 7bf4b15..60f7247 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -510,10 +510,58 @@ static int cgroup_pidlist_show(struct seq_file *s, void *v)
 	return 0;
 }
 
-static ssize_t cgroup_tasks_write(struct kernfs_open_file *of,
-				  char *buf, size_t nbytes, loff_t off)
+static ssize_t __cgroup1_procs_write(struct kernfs_open_file *of,
+				     char *buf, size_t nbytes, loff_t off,
+				     bool threadgroup)
 {
-	return __cgroup_procs_write(of, buf, nbytes, off, false);
+	struct cgroup *cgrp;
+	struct task_struct *task;
+	const struct cred *cred, *tcred;
+	ssize_t ret;
+
+	cgrp = cgroup_kn_lock_live(of->kn, false);
+	if (!cgrp)
+		return -ENODEV;
+
+	task = cgroup_procs_write_start(buf, threadgroup);
+	ret = PTR_ERR_OR_ZERO(task);
+	if (ret)
+		goto out_unlock;
+
+	/*
+	 * Even if we're attaching all tasks in the thread group, we only
+	 * need to check permissions on one of them.
+	 */
+	cred = current_cred();
+	tcred = get_task_cred(task);
+	if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
+	    !uid_eq(cred->euid, tcred->uid) &&
+	    !uid_eq(cred->euid, tcred->suid))
+		ret = -EACCES;
+	put_cred(tcred);
+	if (ret)
+		goto out_finish;
+
+	ret = cgroup_attach_task(cgrp, task, threadgroup);
+
+out_finish:
+	cgroup_procs_write_finish(task);
+out_unlock:
+	cgroup_kn_unlock(of->kn);
+
+	return ret ?: nbytes;
+}
+
+static ssize_t cgroup1_procs_write(struct kernfs_open_file *of,
+				   char *buf, size_t nbytes, loff_t off)
+{
+	return __cgroup1_procs_write(of, buf, nbytes, off, true);
+}
+
+static ssize_t cgroup1_tasks_write(struct kernfs_open_file *of,
+				   char *buf, size_t nbytes, loff_t off)
+{
+	return __cgroup1_procs_write(of, buf, nbytes, off, false);
 }
 
 static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
@@ -592,7 +640,7 @@ struct cftype cgroup1_base_files[] = {
 		.seq_stop = cgroup_pidlist_stop,
 		.seq_show = cgroup_pidlist_show,
 		.private = CGROUP_FILE_PROCS,
-		.write = cgroup_procs_write,
+		.write = cgroup1_procs_write,
 	},
 	{
 		.name = "cgroup.clone_children",
@@ -611,7 +659,7 @@ struct cftype cgroup1_base_files[] = {
 		.seq_stop = cgroup_pidlist_stop,
 		.seq_show = cgroup_pidlist_show,
 		.private = CGROUP_FILE_TASKS,
-		.write = cgroup_tasks_write,
+		.write = cgroup1_tasks_write,
 	},
 	{
 		.name = "notify_on_release",
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index d5b6231..e3bda075 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2421,96 +2421,23 @@ int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 	return ret;
 }
 
-static int cgroup_procs_write_permission(struct task_struct *task,
-					 struct cgroup *dst_cgrp,
-					 struct kernfs_open_file *of)
-{
-	struct super_block *sb = of->file->f_path.dentry->d_sb;
-	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
-	struct cgroup *root_cgrp = ns->root_cset->dfl_cgrp;
-	struct cgroup *src_cgrp, *com_cgrp;
-	struct inode *inode;
-	int ret;
-
-	if (!cgroup_on_dfl(dst_cgrp)) {
-		const struct cred *cred = current_cred();
-		const struct cred *tcred = get_task_cred(task);
-
-		/*
-		 * even if we're attaching all tasks in the thread group,
-		 * we only need to check permissions on one of them.
-		 */
-		if (uid_eq(cred->euid, GLOBAL_ROOT_UID) ||
-		    uid_eq(cred->euid, tcred->uid) ||
-		    uid_eq(cred->euid, tcred->suid))
-			ret = 0;
-		else
-			ret = -EACCES;
-
-		put_cred(tcred);
-		return ret;
-	}
-
-	/* find the source cgroup */
-	spin_lock_irq(&css_set_lock);
-	src_cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
-	spin_unlock_irq(&css_set_lock);
-
-	/* and the common ancestor */
-	com_cgrp = src_cgrp;
-	while (!cgroup_is_descendant(dst_cgrp, com_cgrp))
-		com_cgrp = cgroup_parent(com_cgrp);
-
-	/* %current should be authorized to migrate to the common ancestor */
-	inode = kernfs_get_inode(sb, com_cgrp->procs_file.kn);
-	if (!inode)
-		return -ENOMEM;
-
-	ret = inode_permission(inode, MAY_WRITE);
-	iput(inode);
-	if (ret)
-		return ret;
-
-	/*
-	 * If namespaces are delegation boundaries, %current must be able
-	 * to see both source and destination cgroups from its namespace.
-	 */
-	if ((cgrp_dfl_root.flags & CGRP_ROOT_NS_DELEGATE) &&
-	    (!cgroup_is_descendant(src_cgrp, root_cgrp) ||
-	     !cgroup_is_descendant(dst_cgrp, root_cgrp)))
-		return -ENOENT;
-
-	return 0;
-}
-
-/*
- * Find the task_struct of the task to attach by vpid and pass it along to the
- * function to attach either it or all tasks in its threadgroup. Will lock
- * cgroup_mutex and threadgroup.
- */
-ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
-			     size_t nbytes, loff_t off, bool threadgroup)
+struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup)
+	__acquires(&cgroup_threadgroup_rwsem)
 {
 	struct task_struct *tsk;
-	struct cgroup_subsys *ss;
-	struct cgroup *cgrp;
 	pid_t pid;
-	int ssid, ret;
 
 	if (kstrtoint(strstrip(buf), 0, &pid) || pid < 0)
-		return -EINVAL;
-
-	cgrp = cgroup_kn_lock_live(of->kn, false);
-	if (!cgrp)
-		return -ENODEV;
+		return ERR_PTR(-EINVAL);
 
 	percpu_down_write(&cgroup_threadgroup_rwsem);
+
 	rcu_read_lock();
 	if (pid) {
 		tsk = find_task_by_vpid(pid);
 		if (!tsk) {
-			ret = -ESRCH;
-			goto out_unlock_rcu;
+			tsk = ERR_PTR(-ESRCH);
+			goto out_unlock_threadgroup;
 		}
 	} else {
 		tsk = current;
@@ -2526,35 +2453,33 @@ ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	 * cgroup with no rt_runtime allocated.  Just say no.
 	 */
 	if (tsk->no_cgroup_migration || (tsk->flags & PF_NO_SETAFFINITY)) {
-		ret = -EINVAL;
-		goto out_unlock_rcu;
+		tsk = ERR_PTR(-EINVAL);
+		goto out_unlock_threadgroup;
 	}
 
 	get_task_struct(tsk);
+	goto out_unlock_rcu;
+
+out_unlock_threadgroup:
+	percpu_up_write(&cgroup_threadgroup_rwsem);
+out_unlock_rcu:
 	rcu_read_unlock();
+	return tsk;
+}
 
-	ret = cgroup_procs_write_permission(tsk, cgrp, of);
-	if (!ret)
-		ret = cgroup_attach_task(cgrp, tsk, threadgroup);
+void cgroup_procs_write_finish(struct task_struct *task)
+	__releases(&cgroup_threadgroup_rwsem)
+{
+	struct cgroup_subsys *ss;
+	int ssid;
 
-	put_task_struct(tsk);
-	goto out_unlock_threadgroup;
+	/* release reference from cgroup_procs_write_start() */
+	put_task_struct(task);
 
-out_unlock_rcu:
-	rcu_read_unlock();
-out_unlock_threadgroup:
 	percpu_up_write(&cgroup_threadgroup_rwsem);
 	for_each_subsys(ss, ssid)
 		if (ss->post_attach)
 			ss->post_attach();
-	cgroup_kn_unlock(of->kn);
-	return ret ?: nbytes;
-}
-
-ssize_t cgroup_procs_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
-			   loff_t off)
-{
-	return __cgroup_procs_write(of, buf, nbytes, off, true);
 }
 
 static void cgroup_print_ss_mask(struct seq_file *seq, u16 ss_mask)
@@ -3870,6 +3795,79 @@ static int cgroup_procs_show(struct seq_file *s, void *v)
 	return 0;
 }
 
+static int cgroup_procs_write_permission(struct cgroup *src_cgrp,
+					 struct cgroup *dst_cgrp,
+					 struct super_block *sb)
+{
+	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
+	struct cgroup *com_cgrp = src_cgrp;
+	struct inode *inode;
+	int ret;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	/* find the common ancestor */
+	while (!cgroup_is_descendant(dst_cgrp, com_cgrp))
+		com_cgrp = cgroup_parent(com_cgrp);
+
+	/* %current should be authorized to migrate to the common ancestor */
+	inode = kernfs_get_inode(sb, com_cgrp->procs_file.kn);
+	if (!inode)
+		return -ENOMEM;
+
+	ret = inode_permission(inode, MAY_WRITE);
+	iput(inode);
+	if (ret)
+		return ret;
+
+	/*
+	 * If namespaces are delegation boundaries, %current must be able
+	 * to see both source and destination cgroups from its namespace.
+	 */
+	if ((cgrp_dfl_root.flags & CGRP_ROOT_NS_DELEGATE) &&
+	    (!cgroup_is_descendant(src_cgrp, ns->root_cset->dfl_cgrp) ||
+	     !cgroup_is_descendant(dst_cgrp, ns->root_cset->dfl_cgrp)))
+		return -ENOENT;
+
+	return 0;
+}
+
+static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
+				  char *buf, size_t nbytes, loff_t off)
+{
+	struct cgroup *src_cgrp, *dst_cgrp;
+	struct task_struct *task;
+	ssize_t ret;
+
+	dst_cgrp = cgroup_kn_lock_live(of->kn, false);
+	if (!dst_cgrp)
+		return -ENODEV;
+
+	task = cgroup_procs_write_start(buf, true);
+	ret = PTR_ERR_OR_ZERO(task);
+	if (ret)
+		goto out_unlock;
+
+	/* find the source cgroup */
+	spin_lock_irq(&css_set_lock);
+	src_cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
+	spin_unlock_irq(&css_set_lock);
+
+	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp,
+					    of->file->f_path.dentry->d_sb);
+	if (ret)
+		goto out_finish;
+
+	ret = cgroup_attach_task(dst_cgrp, task, true);
+
+out_finish:
+	cgroup_procs_write_finish(task);
+out_unlock:
+	cgroup_kn_unlock(of->kn);
+
+	return ret ?: nbytes;
+}
+
 /* cgroup core interface files for the default hierarchy */
 static struct cftype cgroup_base_files[] = {
 	{
-- 
2.9.3

