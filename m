From: Ionut Alexa <ionut.m.alexa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] kernel:cgroup :fixed coding style issues
Date: Fri, 11 Jul 2014 22:23:53 +0300
Message-ID: <1405106633-7938-1-git-send-email-ionut.m.alexa@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=rQ6C4Qcs0/jR8gdm7AJyBJKYVUv8PJTqGZXqIUYjtPI=;
        b=hZw4w3gcwJ0Lza/iz4DfHKvIzGhlsa4Bd8qsBx9olLY7EBPf94NwEiSUsFzxCqdQY6
         Lz/pKj/hRmDuyBMI2zYE2zxxKP437FWwEdaRVYp22iafHW2GziPs2ZsbORTg1OsVKqae
         n22DACwXe3qhGhciA2CBWsiS4NAQtKO/s51tA0FT7pMpjkbXztIRjcWmxBXGfDGe1uB6
         qQv29n0l1dKB5zxSXqIMI06QTyy0EyNPWhCHuQReBEyl1/5hSOxHPltHZHbbOxTXfvmG
         Tv0mvtjEJHIC6fD8ZLdFPsJF7oOMcJB3Dk1XnFxlV7ynS7PBEiatdgxLcd4YhDf+CKPE
         XguQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ionut Alexa <johnnyalexa-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>

From: Ionut Alexa <johnnyalexa-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>

Fixed coding style issues.

Signed-off-by: Ionut Alexa <johnnyalexa-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 70776ae..fb6a4fd 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -83,8 +83,8 @@
  */
 #ifdef CONFIG_PROVE_RCU
 DEFINE_MUTEX(cgroup_mutex);
-DECLARE_RWSEM(css_set_rwsem);
 EXPORT_SYMBOL_GPL(cgroup_mutex);
+DECLARE_RWSEM(css_set_rwsem);
 EXPORT_SYMBOL_GPL(css_set_rwsem);
 #else
 static DEFINE_MUTEX(cgroup_mutex);
@@ -106,7 +106,7 @@ static DEFINE_SPINLOCK(release_agent_path_lock);
 #define cgroup_assert_mutex_or_rcu_locked()				\
 	rcu_lockdep_assert(rcu_read_lock_held() ||			\
 			   lockdep_is_held(&cgroup_mutex),		\
-			   "cgroup_mutex or RCU read lock required");
+			   "cgroup_mutex or RCU read lock required")
 
 /*
  * cgroup destruction makes heavy use of work items and there can be a lot
@@ -123,15 +123,17 @@ static struct workqueue_struct *cgroup_destroy_wq;
 static struct workqueue_struct *cgroup_pidlist_destroy_wq;
 
 /* generate an array of cgroup subsystem pointers */
-#define SUBSYS(_x) [_x ## _cgrp_id] = &_x ## _cgrp_subsys,
+#define SUBSYS(_x)							\
+		[_x ## _cgrp_id] = &_x ## _cgrp_subsys,
 static struct cgroup_subsys *cgroup_subsys[] = {
 #include <linux/cgroup_subsys.h>
 };
 #undef SUBSYS
 
 /* array of cgroup subsystem names */
-#define SUBSYS(_x) [_x ## _cgrp_id] = #_x,
-static const char *cgroup_subsys_name[] = {
+#define SUBSYS(_x)							\
+		[_x ## _cgrp_id] = #_x,
+static const char * const cgroup_subsys_name[] = {
 #include <linux/cgroup_subsys.h>
 };
 #undef SUBSYS
@@ -1325,6 +1327,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 			/* Must match [\w.-]+ */
 			for (i = 0; i < strlen(name); i++) {
 				char c = name[i];
+
 				if (isalnum(c))
 					continue;
 				if ((c == '.') || (c == '-') || (c == '_'))
@@ -1694,7 +1697,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 
 		if (!percpu_ref_tryget_live(&ss->root->cgrp.self.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
-			msleep(10);
+			usleep_range(10000, 11000);
 			ret = restart_syscall();
 			goto out_free;
 		}
@@ -1758,7 +1761,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 			mutex_unlock(&cgroup_mutex);
 			if (!IS_ERR_OR_NULL(pinned_sb))
 				deactivate_super(pinned_sb);
-			msleep(10);
+			usleep_range(10000, 11000);
 			ret = restart_syscall();
 			goto out_free;
 		}
@@ -2191,7 +2194,7 @@ static int cgroup_migrate(struct cgroup *cgrp, struct task_struct *leader,
 		if (list_empty(&cset->mg_dst_cset->mg_node))
 			list_move_tail(&cset->mg_dst_cset->mg_node,
 				       &tset.dst_csets);
-	next:
+next:
 		if (!threadgroup)
 			break;
 	} while_each_thread(leader, task);
@@ -2764,6 +2767,7 @@ err_undo_css:
 
 		cgroup_for_each_live_child(child, cgrp) {
 			struct cgroup_subsys_state *css = cgroup_css(child, ss);
+
 			if (css)
 				kill_css(css);
 		}
@@ -2800,12 +2804,16 @@ static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 
 	if (cft->write_u64) {
 		unsigned long long v;
+
 		ret = kstrtoull(buf, 0, &v);
+
 		if (!ret)
 			ret = cft->write_u64(css, cft, v);
 	} else if (cft->write_s64) {
 		long long v;
+
 		ret = kstrtoll(buf, 0, &v);
+
 		if (!ret)
 			ret = cft->write_s64(css, cft, v);
 	} else {
@@ -3954,6 +3962,7 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
 
 		while (index < end) {
 			int mid = (index + end) / 2;
+
 			if (cgroup_pid_fry(cgrp, l->list[mid]) == pid) {
 				index = mid;
 				break;
@@ -4682,7 +4691,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 {
 	struct cgroup_subsys_state *css;
 
-	printk(KERN_INFO "Initializing cgroup subsys %s\n", ss->name);
+	pr_info("Initializing cgroup subsys %s\n", ss->name);
 
 	mutex_lock(&cgroup_mutex);
 
@@ -4736,8 +4745,8 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
  */
 int __init cgroup_init_early(void)
 {
-	static struct cgroup_sb_opts __initdata opts =
-		{ .flags = CGRP_ROOT_SANE_BEHAVIOR };
+	static struct cgroup_sb_opts opts __initdata =	{
+		.flags = CGRP_ROOT_SANE_BEHAVIOR };
 	struct cgroup_subsys *ss;
 	int i;
 
@@ -5195,8 +5204,7 @@ static int __init cgroup_disable(char *str)
 		for_each_subsys(ss, i) {
 			if (!strcmp(token, ss->name)) {
 				ss->disabled = 1;
-				printk(KERN_INFO "Disabling %s control group"
-					" subsystem\n", ss->name);
+				pr_info("Disabling %s control group subsystem\n", ss->name);
 				break;
 			}
 		}
@@ -5350,7 +5358,7 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 			seq_printf(seq, "  task %d\n", task_pid_vnr(task));
 		}
 		continue;
-	overflow:
+overflow:
 		seq_puts(seq, "  ...\n");
 	}
 	up_read(&css_set_rwsem);
-- 
1.7.10.4
