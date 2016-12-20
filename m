From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/8] cgroup: refactor mount path and clearly distinguish v1 and v2 paths
Date: Tue, 20 Dec 2016 16:08:23 -0500
Message-ID: <20161220210827.11176-5-tj@kernel.org>
References: <20161220210827.11176-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QdFM98jplcB7zdz0I/CzFqv19+bRacwOH2bp09pKgIM=;
        b=b41ahozz12vift0gbJIatcTo6Qp0ZjHzoci0Vlfq7J+dxrk6IOY4poVks5nwQqVpGq
         5LYtCtnuHMfDSssr5D4thN9oFnC2mwXUHtcj8l4P4UwGI2+BBVtzqhsQGdI9LSura4RZ
         7K1j5XuKRlfzAiG0Ox+v95+KliUSgQfnKdEXzmJ8bFUm+TCW0ZjSoJyV7m2Z3VfoWcO1
         urUX/soRdDd1smSl9rJVV+Hf7oODcrs6syDDnBOIDemX3/ZGcdobrIsLu1KmCLaHCE0Q
         0EEy1e5oTPuTzrDjqOQ82K80oiWeMfOudYqyWtncTMGmHM8FmOnYZwDEmSl7mgawXdtV
         XOVw==
In-Reply-To: <20161220210827.11176-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

While sharing some mechanisms, the mount paths of v1 and v2 are
substantially different.  Their implementations were mixed in
cgroup_mount().  This patch splits them out so that they're easier to
follow and organize.

This patch causes one functional change - the WARN_ON(new_sb) gets
lost.  This is because the actual mounting gets moved to
cgroup_do_mount() and thus @new_sb is no longer accessible by default
to cgroup1_mount().  While we can add it as an explicit out parameter
to cgroup_do_mount(), this part of code hasn't changed and the warning
hasn't triggered for quite a while.  Dropping it should be fine.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/cgroup.c | 140 ++++++++++++++++++++++++++++---------------------
 1 file changed, 79 insertions(+), 61 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index cb0d29e..6225c4b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1991,48 +1991,55 @@ static int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 	return ret;
 }
 
-static struct dentry *cgroup_mount(struct file_system_type *fs_type,
-			 int flags, const char *unused_dev_name,
-			 void *data)
+static struct dentry *cgroup_do_mount(struct file_system_type *fs_type,
+				      int flags, struct cgroup_root *root,
+				      unsigned long magic,
+				      struct cgroup_namespace *ns)
 {
-	bool is_v2 = fs_type == &cgroup2_fs_type;
-	struct super_block *pinned_sb = NULL;
-	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
-	struct cgroup_subsys *ss;
-	struct cgroup_root *root;
-	struct cgroup_sb_opts opts;
 	struct dentry *dentry;
-	int ret;
-	int i;
 	bool new_sb;
 
-	get_cgroup_ns(ns);
-
-	/* Check if the caller has permission to mount. */
-	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN)) {
-		put_cgroup_ns(ns);
-		return ERR_PTR(-EPERM);
-	}
+	dentry = kernfs_mount(fs_type, flags, root->kf_root, magic, &new_sb);
 
 	/*
-	 * The first time anyone tries to mount a cgroup, enable the list
-	 * linking each css_set to its tasks and fix up all existing tasks.
+	 * In non-init cgroup namespace, instead of root cgroup's dentry,
+	 * we return the dentry corresponding to the cgroupns->root_cgrp.
 	 */
-	if (!use_task_css_set_links)
-		cgroup_enable_task_cg_lists();
+	if (!IS_ERR(dentry) && ns != &init_cgroup_ns) {
+		struct dentry *nsdentry;
+		struct cgroup *cgrp;
 
-	if (is_v2) {
-		if (data) {
-			pr_err("cgroup2: unknown option \"%s\"\n", (char *)data);
-			put_cgroup_ns(ns);
-			return ERR_PTR(-EINVAL);
-		}
-		cgrp_dfl_visible = true;
-		root = &cgrp_dfl_root;
-		cgroup_get(&root->cgrp);
-		goto out_mount;
+		mutex_lock(&cgroup_mutex);
+		spin_lock_irq(&css_set_lock);
+
+		cgrp = cset_cgroup_from_root(ns->root_cset, root);
+
+		spin_unlock_irq(&css_set_lock);
+		mutex_unlock(&cgroup_mutex);
+
+		nsdentry = kernfs_node_dentry(cgrp->kn, dentry->d_sb);
+		dput(dentry);
+		dentry = nsdentry;
 	}
 
+	if (IS_ERR(dentry) || !new_sb)
+		cgroup_put(&root->cgrp);
+
+	return dentry;
+}
+
+static struct dentry *cgroup1_mount(struct file_system_type *fs_type,
+				    int flags, void *data,
+				    unsigned long magic,
+				    struct cgroup_namespace *ns)
+{
+	struct super_block *pinned_sb = NULL;
+	struct cgroup_sb_opts opts;
+	struct cgroup_root *root;
+	struct cgroup_subsys *ss;
+	struct dentry *dentry;
+	int i, ret;
+
 	cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
 
 	/* First find the desired set of subsystems */
@@ -2154,47 +2161,58 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	kfree(opts.release_agent);
 	kfree(opts.name);
 
-	if (ret) {
-		put_cgroup_ns(ns);
+	if (ret)
 		return ERR_PTR(ret);
-	}
-out_mount:
-	dentry = kernfs_mount(fs_type, flags, root->kf_root,
-			      is_v2 ? CGROUP2_SUPER_MAGIC : CGROUP_SUPER_MAGIC,
-			      &new_sb);
+
+	dentry = cgroup_do_mount(&cgroup_fs_type, flags, root,
+				 CGROUP_SUPER_MAGIC, ns);
 
 	/*
-	 * In non-init cgroup namespace, instead of root cgroup's
-	 * dentry, we return the dentry corresponding to the
-	 * cgroupns->root_cgrp.
+	 * If @pinned_sb, we're reusing an existing root and holding an
+	 * extra ref on its sb.  Mount is complete.  Put the extra ref.
 	 */
-	if (!IS_ERR(dentry) && ns != &init_cgroup_ns) {
-		struct dentry *nsdentry;
-		struct cgroup *cgrp;
+	if (pinned_sb)
+		deactivate_super(pinned_sb);
 
-		mutex_lock(&cgroup_mutex);
-		spin_lock_irq(&css_set_lock);
+	return dentry;
+}
 
-		cgrp = cset_cgroup_from_root(ns->root_cset, root);
+static struct dentry *cgroup_mount(struct file_system_type *fs_type,
+			 int flags, const char *unused_dev_name,
+			 void *data)
+{
+	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
+	struct dentry *dentry;
 
-		spin_unlock_irq(&css_set_lock);
-		mutex_unlock(&cgroup_mutex);
+	get_cgroup_ns(ns);
 
-		nsdentry = kernfs_node_dentry(cgrp->kn, dentry->d_sb);
-		dput(dentry);
-		dentry = nsdentry;
+	/* Check if the caller has permission to mount. */
+	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN)) {
+		put_cgroup_ns(ns);
+		return ERR_PTR(-EPERM);
 	}
 
-	if (IS_ERR(dentry) || !new_sb)
-		cgroup_put(&root->cgrp);
-
 	/*
-	 * If @pinned_sb, we're reusing an existing root and holding an
-	 * extra ref on its sb.  Mount is complete.  Put the extra ref.
+	 * The first time anyone tries to mount a cgroup, enable the list
+	 * linking each css_set to its tasks and fix up all existing tasks.
 	 */
-	if (pinned_sb) {
-		WARN_ON(new_sb);
-		deactivate_super(pinned_sb);
+	if (!use_task_css_set_links)
+		cgroup_enable_task_cg_lists();
+
+	if (fs_type == &cgroup2_fs_type) {
+		if (data) {
+			pr_err("cgroup2: unknown option \"%s\"\n", (char *)data);
+			put_cgroup_ns(ns);
+			return ERR_PTR(-EINVAL);
+		}
+		cgrp_dfl_visible = true;
+		cgroup_get(&cgrp_dfl_root.cgrp);
+
+		dentry = cgroup_do_mount(&cgroup2_fs_type, flags, &cgrp_dfl_root,
+					 CGROUP2_SUPER_MAGIC, ns);
+	} else {
+		dentry = cgroup1_mount(&cgroup_fs_type, flags, data,
+				       CGROUP_SUPER_MAGIC, ns);
 	}
 
 	put_cgroup_ns(ns);
-- 
2.9.3

