From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cpuset: simplify proc_cpuset_show()
Date: Thu, 18 Sep 2014 16:03:36 +0800
Message-ID: <541A91D8.8070407@huawei.com>
References: <541A91C3.9000305@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <541A91C3.9000305-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Use the ONE macro instead of REG, and we can simplify proc_cpuset_show().

Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 fs/proc/base.c         | 20 ++------------------
 include/linux/cpuset.h |  3 ++-
 kernel/cpuset.c        | 15 +++------------
 3 files changed, 7 insertions(+), 31 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6b96892..4e8aa35 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -376,22 +376,6 @@ static const struct file_operations proc_lstats_operations = {
 
 #endif
 
-#ifdef CONFIG_PROC_PID_CPUSET
-
-static int cpuset_open(struct inode *inode, struct file *file)
-{
-	struct pid *pid = PROC_I(inode)->pid;
-	return single_open(file, proc_cpuset_show, pid);
-}
-
-static const struct file_operations proc_cpuset_operations = {
-	.open		= cpuset_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-#endif
-
 static int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
 			  struct pid *pid, struct task_struct *task)
 {
@@ -2558,7 +2542,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("latency",  S_IRUGO, proc_lstats_operations),
 #endif
 #ifdef CONFIG_PROC_PID_CPUSET
-	REG("cpuset",     S_IRUGO, proc_cpuset_operations),
+	ONE("cpuset",     S_IRUGO, proc_cpuset_show),
 #endif
 #ifdef CONFIG_CGROUPS
 	ONE("cgroup",  S_IRUGO, proc_cgroup_show),
@@ -2904,7 +2888,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("latency",  S_IRUGO, proc_lstats_operations),
 #endif
 #ifdef CONFIG_PROC_PID_CPUSET
-	REG("cpuset",    S_IRUGO, proc_cpuset_operations),
+	ONE("cpuset",    S_IRUGO, proc_cpuset_show),
 #endif
 #ifdef CONFIG_CGROUPS
 	ONE("cgroup",  S_IRUGO, proc_cgroup_show),
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index ade2390..0d4e067 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -86,7 +86,8 @@ extern void __cpuset_memory_pressure_bump(void);
 
 extern void cpuset_task_status_allowed(struct seq_file *m,
 					struct task_struct *task);
-extern int proc_cpuset_show(struct seq_file *, void *);
+extern int proc_cpuset_show(struct seq_file *m, struct pid_namespace *ns,
+			    struct pid *pid, struct task_struct *tsk);
 
 extern int cpuset_mem_spread_node(void);
 extern int cpuset_slab_spread_node(void);
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 22874d7..a37f4ed 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2729,10 +2729,9 @@ void __cpuset_memory_pressure_bump(void)
  *    and we take cpuset_mutex, keeping cpuset_attach() from changing it
  *    anyway.
  */
-int proc_cpuset_show(struct seq_file *m, void *unused_v)
+int proc_cpuset_show(struct seq_file *m, struct pid_namespace *ns,
+		     struct pid *pid, struct task_struct *tsk)
 {
-	struct pid *pid;
-	struct task_struct *tsk;
 	char *buf, *p;
 	struct cgroup_subsys_state *css;
 	int retval;
@@ -2742,24 +2741,16 @@ int proc_cpuset_show(struct seq_file *m, void *unused_v)
 	if (!buf)
 		goto out;
 
-	retval = -ESRCH;
-	pid = m->private;
-	tsk = get_pid_task(pid, PIDTYPE_PID);
-	if (!tsk)
-		goto out_free;
-
 	retval = -ENAMETOOLONG;
 	rcu_read_lock();
 	css = task_css(tsk, cpuset_cgrp_id);
 	p = cgroup_path(css->cgroup, buf, PATH_MAX);
 	rcu_read_unlock();
 	if (!p)
-		goto out_put_task;
+		goto out_free;
 	seq_puts(m, p);
 	seq_putc(m, '\n');
 	retval = 0;
-out_put_task:
-	put_task_struct(tsk);
 out_free:
 	kfree(buf);
 out:
-- 
1.8.0.2
