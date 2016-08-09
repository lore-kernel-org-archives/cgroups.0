From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] cgroup: make cgroup_path() and friends behave in the style of strlcpy()
Date: Tue,  9 Aug 2016 01:23:24 -0400
Message-ID: <1470720204-4605-5-git-send-email-tj@kernel.org>
References: <1470720204-4605-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mCVU76A8WY5MUiI12BE1BDTKbWs9REEpKL092P2VMGI=;
        b=MhlfABU6EuDjrzKiCw+L52lKdTxYiJB7LG81qt2vuTMgO+XQgxJVKo/4knpcfANQ8/
         +/rG75183XRQ03tl71aViim2NpSKX8/kGqtcNZjhvG7V0H2mNGnzZf4Zi/H68ZkskJ5G
         yAFPHC3SQDamZqPAJ2XEmD7yE9IgSc4GErggyaPRSUDOhwX4e2ayuwGlvztR39RQ1ltM
         GInzZMB/k4CUm0V/cEhXCXOQHsRRAqYNQp3jqi0C/Tj9GdWXEsNGQyM4BpaKz6N9spN9
         qM5un/SXH9sKuEbCn0A72N27wFHv27WRJk/wPV0LxKeTbaoxDUabQqfpXy/71oEQ6+ch
         o7Mw==
In-Reply-To: <1470720204-4605-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org, serge.hallyn@ubuntu.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, hannes@cmpxchg.org, lizefan@huawei.com, Tejun Heo <tj@kernel.org>

cgroup_path() and friends used to format the path from the end and
thus the resulting path usually didn't start at the start of the
passed in buffer.  Also, when the buffer was too small, the partial
result was truncated from the head rather than tail and there was no
way to tell how long the full path would be.  These make the functions
less robust and more awkward to use.

With recent updates to kernfs_path(), cgroup_path() and friends can be
made to behave in strlcpy() style.

* cgroup_path(), cgroup_path_ns[_locked]() and task_cgroup_path() now
  always return the length of the full path.  If buffer is too small,
  it contains nul terminated truncated output.

* All users updated accordingly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/blk-cgroup.h | 11 +----------
 include/linux/cgroup.h     | 16 +++++-----------
 kernel/cgroup.c            | 48 +++++++++++++++++++++-------------------------
 kernel/cpuset.c            | 12 ++++++------
 4 files changed, 34 insertions(+), 53 deletions(-)

diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 10648e3..4e8c215 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -343,16 +343,7 @@ static inline struct blkcg *cpd_to_blkcg(struct blkcg_policy_data *cpd)
  */
 static inline int blkg_path(struct blkcg_gq *blkg, char *buf, int buflen)
 {
-	char *p;
-
-	p = cgroup_path(blkg->blkcg->css.cgroup, buf, buflen);
-	if (!p) {
-		strncpy(buf, "<unavailable>", buflen);
-		return -ENAMETOOLONG;
-	}
-
-	memmove(buf, p, buf + buflen - p);
-	return 0;
+	return cgroup_path(blkg->blkcg->css.cgroup, buf, buflen);
 }
 
 /**
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5a9abde..6df3636 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -97,7 +97,7 @@ int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 int cgroup_rm_cftypes(struct cftype *cfts);
 void cgroup_file_notify(struct cgroup_file *cfile);
 
-char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
+int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
 int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry);
 int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		     struct pid *pid, struct task_struct *tsk);
@@ -538,15 +538,9 @@ static inline int cgroup_name(struct cgroup *cgrp, char *buf, size_t buflen)
 	return kernfs_name(cgrp->kn, buf, buflen);
 }
 
-static inline char * __must_check cgroup_path(struct cgroup *cgrp, char *buf,
-					      size_t buflen)
+static inline int cgroup_path(struct cgroup *cgrp, char *buf, size_t buflen)
 {
-	int ret;
-
-	ret = kernfs_path(cgrp->kn, buf, buflen);
-	if (ret < 0 || ret >= buflen)
-		return NULL;
-	return buf;
+	return kernfs_path(cgrp->kn, buf, buflen);
 }
 
 static inline void pr_cont_cgroup_name(struct cgroup *cgrp)
@@ -639,8 +633,8 @@ struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
 					struct user_namespace *user_ns,
 					struct cgroup_namespace *old_ns);
 
-char *cgroup_path_ns(struct cgroup *cgrp, char *buf, size_t buflen,
-		     struct cgroup_namespace *ns);
+int cgroup_path_ns(struct cgroup *cgrp, char *buf, size_t buflen,
+		   struct cgroup_namespace *ns);
 
 #else /* !CONFIG_CGROUPS */
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d1c51b7..3861161 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2315,22 +2315,18 @@ static struct file_system_type cgroup2_fs_type = {
 	.fs_flags = FS_USERNS_MOUNT,
 };
 
-static char *cgroup_path_ns_locked(struct cgroup *cgrp, char *buf, size_t buflen,
-				   struct cgroup_namespace *ns)
+static int cgroup_path_ns_locked(struct cgroup *cgrp, char *buf, size_t buflen,
+				 struct cgroup_namespace *ns)
 {
 	struct cgroup *root = cset_cgroup_from_root(ns->root_cset, cgrp->root);
-	int ret;
 
-	ret = kernfs_path_from_node(cgrp->kn, root->kn, buf, buflen);
-	if (ret < 0 || ret >= buflen)
-		return NULL;
-	return buf;
+	return kernfs_path_from_node(cgrp->kn, root->kn, buf, buflen);
 }
 
-char *cgroup_path_ns(struct cgroup *cgrp, char *buf, size_t buflen,
-		     struct cgroup_namespace *ns)
+int cgroup_path_ns(struct cgroup *cgrp, char *buf, size_t buflen,
+		   struct cgroup_namespace *ns)
 {
-	char *ret;
+	int ret;
 
 	mutex_lock(&cgroup_mutex);
 	spin_lock_irq(&css_set_lock);
@@ -2357,12 +2353,12 @@ EXPORT_SYMBOL_GPL(cgroup_path_ns);
  *
  * Return value is the same as kernfs_path().
  */
-char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
+int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 {
 	struct cgroup_root *root;
 	struct cgroup *cgrp;
 	int hierarchy_id = 1;
-	char *path = NULL;
+	int ret;
 
 	mutex_lock(&cgroup_mutex);
 	spin_lock_irq(&css_set_lock);
@@ -2371,16 +2367,15 @@ char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 
 	if (root) {
 		cgrp = task_cgroup_from_root(task, root);
-		path = cgroup_path_ns_locked(cgrp, buf, buflen, &init_cgroup_ns);
+		ret = cgroup_path_ns_locked(cgrp, buf, buflen, &init_cgroup_ns);
 	} else {
 		/* if no hierarchy exists, everyone is in "/" */
-		if (strlcpy(buf, "/", buflen) < buflen)
-			path = buf;
+		ret = strlcpy(buf, "/", buflen);
 	}
 
 	spin_unlock_irq(&css_set_lock);
 	mutex_unlock(&cgroup_mutex);
-	return path;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(task_cgroup_path);
 
@@ -5716,7 +5711,7 @@ core_initcall(cgroup_wq_init);
 int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		     struct pid *pid, struct task_struct *tsk)
 {
-	char *buf, *path;
+	char *buf;
 	int retval;
 	struct cgroup_root *root;
 
@@ -5759,18 +5754,18 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		 * " (deleted)" is appended to the cgroup path.
 		 */
 		if (cgroup_on_dfl(cgrp) || !(tsk->flags & PF_EXITING)) {
-			path = cgroup_path_ns_locked(cgrp, buf, PATH_MAX,
+			retval = cgroup_path_ns_locked(cgrp, buf, PATH_MAX,
 						current->nsproxy->cgroup_ns);
-			if (!path) {
+			if (retval >= PATH_MAX) {
 				retval = -ENAMETOOLONG;
 				goto out_unlock;
 			}
+
+			seq_puts(m, buf);
 		} else {
-			path = "/";
+			seq_puts(m, "/");
 		}
 
-		seq_puts(m, path);
-
 		if (cgroup_on_dfl(cgrp) && cgroup_is_dead(cgrp))
 			seq_puts(m, " (deleted)\n");
 		else
@@ -6035,8 +6030,9 @@ static void cgroup_release_agent(struct work_struct *work)
 {
 	struct cgroup *cgrp =
 		container_of(work, struct cgroup, release_agent_work);
-	char *pathbuf = NULL, *agentbuf = NULL, *path;
+	char *pathbuf = NULL, *agentbuf = NULL;
 	char *argv[3], *envp[3];
+	int ret;
 
 	mutex_lock(&cgroup_mutex);
 
@@ -6046,13 +6042,13 @@ static void cgroup_release_agent(struct work_struct *work)
 		goto out;
 
 	spin_lock_irq(&css_set_lock);
-	path = cgroup_path_ns_locked(cgrp, pathbuf, PATH_MAX, &init_cgroup_ns);
+	ret = cgroup_path_ns_locked(cgrp, pathbuf, PATH_MAX, &init_cgroup_ns);
 	spin_unlock_irq(&css_set_lock);
-	if (!path)
+	if (ret >= PATH_MAX)
 		goto out;
 
 	argv[0] = agentbuf;
-	argv[1] = path;
+	argv[1] = pathbuf;
 	argv[2] = NULL;
 
 	/* minimal command environment */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index c7fd277..793ae6f 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2689,7 +2689,7 @@ void __cpuset_memory_pressure_bump(void)
 int proc_cpuset_show(struct seq_file *m, struct pid_namespace *ns,
 		     struct pid *pid, struct task_struct *tsk)
 {
-	char *buf, *p;
+	char *buf;
 	struct cgroup_subsys_state *css;
 	int retval;
 
@@ -2700,18 +2700,18 @@ int proc_cpuset_show(struct seq_file *m, struct pid_namespace *ns,
 
 	retval = -ENAMETOOLONG;
 	css = task_get_css(tsk, cpuset_cgrp_id);
-	p = cgroup_path_ns(css->cgroup, buf, PATH_MAX,
-			   current->nsproxy->cgroup_ns);
+	retval = cgroup_path_ns(css->cgroup, buf, PATH_MAX,
+				current->nsproxy->cgroup_ns);
 	css_put(css);
-	if (!p)
+	if (retval >= PATH_MAX)
 		goto out_free;
-	seq_puts(m, p);
+	seq_puts(m, buf);
 	seq_putc(m, '\n');
 	retval = 0;
 out_free:
 	kfree(buf);
 out:
-	return retval;
+	return 0;
 }
 #endif /* CONFIG_PROC_PID_CPUSET */
 
-- 
2.7.4

