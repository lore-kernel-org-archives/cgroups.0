From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/10] cgroup: reorganize cgroup.procs / task write path
Date: Sat, 10 Jun 2017 10:03:43 -0400
Message-ID: <20170610140351.10703-3-tj@kernel.org>
References: <20170610140351.10703-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ly6Oh2m3Rb6xUtWIt86+XQ5jgEy36ic19GxSoy9Zih4=;
        b=l8d+OoKkW7rtOwTRDv1u/FLYAIq0GH/+MwyamGj11sLFIzPpfhfKlsmoxpHfdGZVvV
         /jnAd8GG81Z6d0LIUd4Xcv+OCc+S3BJ/0yxI33sRnKMSoFppcW4hpUvhO2WH8dom4ejk
         RpFfXRWtg1UAH3KjwINhz7XvABvX3YvOlJl7GFch7F3Un2XtClgc2PVNR5NT1SAM6QaH
         eaS9pYOoLn+bz8DwzbGL9kBt94vzoAPW3SEXOvNPV6dqSKeKn1junrsRh70FKqtDjszM
         jnsR9s9vf3BEqzZLcjjAXApCS/9ppCNoEJqN4z8hWRTeqgaj2YBcvnzOdlz/Gace8L3b
         JnSg==
In-Reply-To: <20170610140351.10703-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Tejun Heo <tj@kernel.org>

Currently, writes "cgroup.procs" and "cgroup.tasks" files are all
handled by __cgroup_procs_write() on both v1 and v2.  This patch
reoragnizes the write path so that there are common helper functions
that different write paths use.

While this somewhat increases LOC, the different paths are no longer
intertwined and each path has more flexibility to implement different
behaviors which will be necessary for the planned v2 thread support.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/cgroup-internal.h |   8 +-
 kernel/cgroup/cgroup-v1.c       |  58 ++++++++++++--
 kernel/cgroup/cgroup.c          | 163 +++++++++++++++++++++-------------------
 3 files changed, 142 insertions(+), 87 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 00f4d6bf048f..f0a0dba97bad 100644
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
+void cgroup_procs_write_finish(void)
+	__releases(&cgroup_threadgroup_rwsem);
 
 void cgroup_lock_and_drain_offline(struct cgroup *cgrp);
 
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 85d75152402d..f13ccab992c7 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -514,10 +514,58 @@ static int cgroup_pidlist_show(struct seq_file *s, void *v)
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
+	cgroup_procs_write_finish();
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
@@ -596,7 +644,7 @@ struct cftype cgroup1_base_files[] = {
 		.seq_stop = cgroup_pidlist_stop,
 		.seq_show = cgroup_pidlist_show,
 		.private = CGROUP_FILE_PROCS,
-		.write = cgroup_procs_write,
+		.write = cgroup1_procs_write,
 	},
 	{
 		.name = "cgroup.clone_children",
@@ -615,7 +663,7 @@ struct cftype cgroup1_base_files[] = {
 		.seq_stop = cgroup_pidlist_stop,
 		.seq_show = cgroup_pidlist_show,
 		.private = CGROUP_FILE_TASKS,
-		.write = cgroup_tasks_write,
+		.write = cgroup1_tasks_write,
 	},
 	{
 		.name = "notify_on_release",
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index dcd120af4084..78a2c9788d40 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1943,6 +1943,23 @@ int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 }
 EXPORT_SYMBOL_GPL(task_cgroup_path);
 
+static struct cgroup *cgroup_migrate_common_ancestor(struct task_struct *task,
+						     struct cgroup *dst_cgrp)
+{
+	struct cgroup *cgrp;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	spin_lock_irq(&css_set_lock);
+	cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
+	spin_unlock_irq(&css_set_lock);
+
+	while (!cgroup_is_descendant(dst_cgrp, cgrp))
+		cgrp = cgroup_parent(cgrp);
+
+	return cgrp;
+}
+
 /**
  * cgroup_migrate_add_task - add a migration target task to a migration context
  * @task: target task
@@ -2375,76 +2392,23 @@ int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 	return ret;
 }
 
-static int cgroup_procs_write_permission(struct task_struct *task,
-					 struct cgroup *dst_cgrp,
-					 struct kernfs_open_file *of)
-{
-	int ret = 0;
-
-	if (cgroup_on_dfl(dst_cgrp)) {
-		struct super_block *sb = of->file->f_path.dentry->d_sb;
-		struct cgroup *cgrp;
-		struct inode *inode;
-
-		spin_lock_irq(&css_set_lock);
-		cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
-		spin_unlock_irq(&css_set_lock);
-
-		while (!cgroup_is_descendant(dst_cgrp, cgrp))
-			cgrp = cgroup_parent(cgrp);
-
-		ret = -ENOMEM;
-		inode = kernfs_get_inode(sb, cgrp->procs_file.kn);
-		if (inode) {
-			ret = inode_permission(inode, MAY_WRITE);
-			iput(inode);
-		}
-	} else {
-		const struct cred *cred = current_cred();
-		const struct cred *tcred = get_task_cred(task);
-
-		/*
-		 * even if we're attaching all tasks in the thread group,
-		 * we only need to check permissions on one of them.
-		 */
-		if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
-		    !uid_eq(cred->euid, tcred->uid) &&
-		    !uid_eq(cred->euid, tcred->suid))
-			ret = -EACCES;
-		put_cred(tcred);
-	}
-
-	return ret;
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
@@ -2460,35 +2424,30 @@ ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	 * cgroup with no rt_runtime allocated.  Just say no.
 	 */
 	if (tsk->no_cgroup_migration || (tsk->flags & PF_NO_SETAFFINITY)) {
-		ret = -EINVAL;
-		goto out_unlock_rcu;
+		tsk = ERR_PTR(-EINVAL);
+		goto out_unlock_threadgroup;
 	}
 
 	get_task_struct(tsk);
-	rcu_read_unlock();
-
-	ret = cgroup_procs_write_permission(tsk, cgrp, of);
-	if (!ret)
-		ret = cgroup_attach_task(cgrp, tsk, threadgroup);
-
-	put_task_struct(tsk);
-	goto out_unlock_threadgroup;
+	goto out_unlock_rcu;
 
+out_unlock_threadgroup:
+	percpu_up_write(&cgroup_threadgroup_rwsem);
 out_unlock_rcu:
 	rcu_read_unlock();
-out_unlock_threadgroup:
+	return tsk;
+}
+
+void cgroup_procs_write_finish(void)
+	__releases(&cgroup_threadgroup_rwsem)
+{
+	struct cgroup_subsys *ss;
+	int ssid;
+
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
@@ -3793,6 +3752,54 @@ static int cgroup_procs_show(struct seq_file *s, void *v)
 	return 0;
 }
 
+static int cgroup_procs_write_permission(struct cgroup *cgrp,
+					 struct super_block *sb)
+{
+	struct inode *inode;
+	int ret;
+
+	inode = kernfs_get_inode(sb, cgrp->procs_file.kn);
+	if (!inode)
+		return -ENOMEM;
+
+	ret = inode_permission(inode, MAY_WRITE);
+	iput(inode);
+	return ret;
+}
+
+static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
+				  char *buf, size_t nbytes, loff_t off)
+{
+	struct cgroup *cgrp, *common_ancestor;
+	struct task_struct *task;
+	ssize_t ret;
+
+	cgrp = cgroup_kn_lock_live(of->kn, false);
+	if (!cgrp)
+		return -ENODEV;
+
+	task = cgroup_procs_write_start(buf, true);
+	ret = PTR_ERR_OR_ZERO(task);
+	if (ret)
+		goto out_unlock;
+
+	common_ancestor = cgroup_migrate_common_ancestor(task, cgrp);
+
+	ret = cgroup_procs_write_permission(common_ancestor,
+					    of->file->f_path.dentry->d_sb);
+	if (ret)
+		goto out_finish;
+
+	ret = cgroup_attach_task(cgrp, task, true);
+
+out_finish:
+	cgroup_procs_write_finish();
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
2.13.0

