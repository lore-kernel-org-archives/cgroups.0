From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cgroup: simplify proc_cgroup_show()
Date: Thu, 18 Sep 2014 16:03:15 +0800
Message-ID: <541A91C3.9000305@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Use the ONE macro instead of REG, and we can simplify proc_cgroup_show().

Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 fs/proc/base.c         | 19 ++-----------------
 include/linux/cgroup.h |  3 ++-
 kernel/cgroup.c        | 18 +++---------------
 3 files changed, 7 insertions(+), 33 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index baf852b..6b96892 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -376,21 +376,6 @@ static const struct file_operations proc_lstats_operations = {
 
 #endif
 
-#ifdef CONFIG_CGROUPS
-static int cgroup_open(struct inode *inode, struct file *file)
-{
-	struct pid *pid = PROC_I(inode)->pid;
-	return single_open(file, proc_cgroup_show, pid);
-}
-
-static const struct file_operations proc_cgroup_operations = {
-	.open		= cgroup_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-#endif
-
 #ifdef CONFIG_PROC_PID_CPUSET
 
 static int cpuset_open(struct inode *inode, struct file *file)
@@ -2576,7 +2561,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("cpuset",     S_IRUGO, proc_cpuset_operations),
 #endif
 #ifdef CONFIG_CGROUPS
-	REG("cgroup",  S_IRUGO, proc_cgroup_operations),
+	ONE("cgroup",  S_IRUGO, proc_cgroup_show),
 #endif
 	ONE("oom_score",  S_IRUGO, proc_oom_score),
 	REG("oom_adj",    S_IRUGO|S_IWUSR, proc_oom_adj_operations),
@@ -2922,7 +2907,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("cpuset",    S_IRUGO, proc_cpuset_operations),
 #endif
 #ifdef CONFIG_CGROUPS
-	REG("cgroup",  S_IRUGO, proc_cgroup_operations),
+	ONE("cgroup",  S_IRUGO, proc_cgroup_show),
 #endif
 	ONE("oom_score", S_IRUGO, proc_oom_score),
 	REG("oom_adj",   S_IRUGO|S_IWUSR, proc_oom_adj_operations),
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f7898e0..a5d9b8f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -37,7 +37,8 @@ extern void cgroup_exit(struct task_struct *p);
 extern int cgroupstats_build(struct cgroupstats *stats,
 				struct dentry *dentry);
 
-extern int proc_cgroup_show(struct seq_file *, void *);
+extern int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
+			    struct pid *pid, struct task_struct *tsk);
 
 /* define the enumeration of all cgroup subsystems */
 #define SUBSYS(_x) _x ## _cgrp_id,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1abb554..e91bc3c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5040,12 +5040,9 @@ core_initcall(cgroup_wq_init);
  *  - Print task's cgroup paths into seq_file, one line for each hierarchy
  *  - Used for /proc/<pid>/cgroup.
  */
-
-/* TODO: Use a proper seq_file iterator */
-int proc_cgroup_show(struct seq_file *m, void *v)
+int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
+		     struct pid *pid, struct task_struct *tsk)
 {
-	struct pid *pid;
-	struct task_struct *tsk;
 	char *buf, *path;
 	int retval;
 	struct cgroup_root *root;
@@ -5055,14 +5052,6 @@ int proc_cgroup_show(struct seq_file *m, void *v)
 	if (!buf)
 		goto out;
 
-	retval = -ESRCH;
-	pid = m->private;
-	tsk = get_pid_task(pid, PIDTYPE_PID);
-	if (!tsk)
-		goto out_free;
-
-	retval = 0;
-
 	mutex_lock(&cgroup_mutex);
 	down_read(&css_set_rwsem);
 
@@ -5092,11 +5081,10 @@ int proc_cgroup_show(struct seq_file *m, void *v)
 		seq_putc(m, '\n');
 	}
 
+	retval = 0;
 out_unlock:
 	up_read(&css_set_rwsem);
 	mutex_unlock(&cgroup_mutex);
-	put_task_struct(tsk);
-out_free:
 	kfree(buf);
 out:
 	return retval;
-- 
1.8.0.2
