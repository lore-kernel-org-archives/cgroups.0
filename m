From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/8] cgroup: separate out cgroup1_kf_syscall_ops
Date: Tue, 20 Dec 2016 16:08:24 -0500
Message-ID: <20161220210827.11176-6-tj@kernel.org>
References: <20161220210827.11176-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FXPLMS/MX0uybx/95Ap4DVrYg5srZ1kAzmYTBeRi0i4=;
        b=qJVzaWHuozGshD6lb2v4nGsE8AoiTLHuwHcwB61LuxVeWYG7FAN2SlrX2abch52Z1G
         Fy6JXnQUsg9/GmCs+TjXahHmWzqpyvHZaR5UzEDhXR37ZDpWr0359eYD/AWRGrkkgcGF
         mDG3XYsEcqPF/mkfZg6Ue9+mBPRrLO9vLzQLEx10b+Hjuh7awNdOE+QsJSZ+OIQJwJRp
         FlZQd5A0W8ERhGGWcqIFwVAgRI1hqbaGdlgFp66+8plXFhxA2ZKqxiN2PDUxcKU38rsg
         DjNofzESYzsMuY1OFcVLazDaUR1rkILLTr6XJiRc1MtnFXaD0XwEpJjsXuvXzhzhqgyO
         nFeQ==
In-Reply-To: <20161220210827.11176-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Currently, cgroup_kf_syscall_ops is shared by v1 and v2 and the
specific methods test the version and take different actions.  Split
out v1 functions and put them in cgroup1_kf_syscall_ops and remove the
now unnecessary explicit branches in specific methods.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/cgroup-internal.h |  4 ++--
 kernel/cgroup/cgroup-v1.c       | 11 ++---------
 kernel/cgroup/cgroup.c          | 40 ++++++++++++++++++++++++++--------------
 3 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index d86fbbc..7b8182e 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -93,8 +93,8 @@ extern const struct file_operations proc_cgroupstats_operations;
 
 bool cgroup_ssid_no_v1(int ssid);
 void cgroup_pidlist_destroy_all(struct cgroup *cgrp);
-int cgroup_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
-		  const char *new_name_str);
+int cgroup1_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
+		   const char *new_name_str);
 void cgroup_release_agent(struct work_struct *work);
 void check_for_release(struct cgroup *cgrp);
 
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 7af745a..0b2c24f 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -800,8 +800,8 @@ void cgroup_release_agent(struct work_struct *work)
 /*
  * cgroup_rename - Only allow simple rename of directories in place.
  */
-int cgroup_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
-		  const char *new_name_str)
+int cgroup1_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
+		   const char *new_name_str)
 {
 	struct cgroup *cgrp = kn->priv;
 	int ret;
@@ -812,13 +812,6 @@ int cgroup_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
 		return -EIO;
 
 	/*
-	 * This isn't a proper migration and its usefulness is very
-	 * limited.  Disallow on the default hierarchy.
-	 */
-	if (cgroup_on_dfl(cgrp))
-		return -EPERM;
-
-	/*
 	 * We're gonna grab cgroup_mutex which nests outside kernfs
 	 * active_ref.  kernfs_rename() doesn't require active_ref
 	 * protection.  Break them before grabbing cgroup_mutex.
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 6225c4b..f1b71fb 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1234,6 +1234,7 @@ struct cgroup *task_cgroup_from_root(struct task_struct *task,
  * update of a tasks cgroup pointer by cgroup_attach_task()
  */
 
+static struct kernfs_syscall_ops cgroup1_kf_syscall_ops;
 static struct kernfs_syscall_ops cgroup_kf_syscall_ops;
 
 static char *cgroup_file_name(struct cgroup *cgrp, const struct cftype *cft,
@@ -1568,16 +1569,15 @@ static int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
 	return len;
 }
 
-static int cgroup_show_options(struct seq_file *seq, struct kernfs_root *kf_root)
+static int cgroup1_show_options(struct seq_file *seq, struct kernfs_root *kf_root)
 {
 	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
 	struct cgroup_subsys *ss;
 	int ssid;
 
-	if (root != &cgrp_dfl_root)
-		for_each_subsys(ss, ssid)
-			if (root->subsys_mask & (1 << ssid))
-				seq_show_option(seq, ss->legacy_name, NULL);
+	for_each_subsys(ss, ssid)
+		if (root->subsys_mask & (1 << ssid))
+			seq_show_option(seq, ss->legacy_name, NULL);
 	if (root->flags & CGRP_ROOT_NOPREFIX)
 		seq_puts(seq, ",noprefix");
 	if (root->flags & CGRP_ROOT_XATTR)
@@ -1738,18 +1738,13 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 	return 0;
 }
 
-static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
+static int cgroup1_remount(struct kernfs_root *kf_root, int *flags, char *data)
 {
 	int ret = 0;
 	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
 	struct cgroup_sb_opts opts;
 	u16 added_mask, removed_mask;
 
-	if (root == &cgrp_dfl_root) {
-		pr_err("remount is not allowed\n");
-		return -EINVAL;
-	}
-
 	cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
 
 	/* See what subsystems are wanted */
@@ -1800,6 +1795,12 @@ static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 	return ret;
 }
 
+static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
+{
+	pr_err("remount is not allowed\n");
+	return -EINVAL;
+}
+
 /*
  * To reduce the fork() overhead for systems that are not actually using
  * their cgroups capability, we don't maintain the lists running through
@@ -1902,6 +1903,7 @@ static int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 {
 	LIST_HEAD(tmp_links);
 	struct cgroup *root_cgrp = &root->cgrp;
+	struct kernfs_syscall_ops *kf_sops;
 	struct css_set *cset;
 	int i, ret;
 
@@ -1933,7 +1935,10 @@ static int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 	if (ret)
 		goto cancel_ref;
 
-	root->kf_root = kernfs_create_root(&cgroup_kf_syscall_ops,
+	kf_sops = root == &cgrp_dfl_root ?
+		&cgroup_kf_syscall_ops : &cgroup1_kf_syscall_ops;
+
+	root->kf_root = kernfs_create_root(kf_sops,
 					   KERNFS_ROOT_CREATE_DEACTIVATED,
 					   root_cgrp);
 	if (IS_ERR(root->kf_root)) {
@@ -4815,12 +4820,19 @@ static int cgroup_rmdir(struct kernfs_node *kn)
 	return ret;
 }
 
+static struct kernfs_syscall_ops cgroup1_kf_syscall_ops = {
+	.remount_fs		= cgroup1_remount,
+	.show_options		= cgroup1_show_options,
+	.rename			= cgroup1_rename,
+	.mkdir			= cgroup_mkdir,
+	.rmdir			= cgroup_rmdir,
+	.show_path		= cgroup_show_path,
+};
+
 static struct kernfs_syscall_ops cgroup_kf_syscall_ops = {
 	.remount_fs		= cgroup_remount,
-	.show_options		= cgroup_show_options,
 	.mkdir			= cgroup_mkdir,
 	.rmdir			= cgroup_rmdir,
-	.rename			= cgroup_rename,
 	.show_path		= cgroup_show_path,
 };
 
-- 
2.9.3

