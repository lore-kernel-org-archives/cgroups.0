From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 6/8] cgroup: move v1 mount functions to kernel/cgroup/cgroup-v1.c
Date: Tue, 20 Dec 2016 16:08:25 -0500
Message-ID: <20161220210827.11176-7-tj@kernel.org>
References: <20161220210827.11176-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JQx9XVH/DbTKwrT/gecNf2qWyxq6aVFxvZP70ROAQlc=;
        b=l7jQ2/EtWI7mgK5KJkyIMlymi6vvnT6+FwZ/c0ZI37Th7uUFWd7QytApPm2kg0oMPu
         /KHxlPztBU4dnZTLLiHx7SzrX0zTrqfvszTPbE7uUnQKNoRcVIut0pc3UJjk5F028OS1
         h5YQqE6U3BX3k1i/FQ29QdowW/LASuDq97J8KAmxfI1Bobglaa1NPp/RHiC3H5h8zM4l
         qHBOsf70MPo8/lIftVhYoE8kHBGqTrlv1Ht7EPOuJ7FvusgKTEzfTlcMfEoo3JpFzaTy
         UfvE/rJXEAsvMZr/TVXmqc3TWOtyAWwjXHpM/FT9v20uV9eOjqgb3L3M48tmoqe7wJ/w
         pHrg==
In-Reply-To: <20161220210827.11176-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Now that the v1 mount code is split into separate functions, move them
to kernel/cgroup/cgroup-v1.c along with the mount option handling
code.  As this puts all v1-only kernfs_syscall_ops in cgroup-v1.c,
move cgroup1_kf_syscall_ops to cgroup-v1.c too.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup/cgroup-internal.h |  28 ++-
 kernel/cgroup/cgroup-v1.c       | 381 ++++++++++++++++++++++++++++++++++++-
 kernel/cgroup/cgroup.c          | 410 +---------------------------------------
 3 files changed, 413 insertions(+), 406 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 7b8182e..3d431b6 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -26,6 +26,16 @@ struct cgrp_cset_link {
 	struct list_head	cgrp_link;
 };
 
+struct cgroup_sb_opts {
+	u16 subsys_mask;
+	unsigned int flags;
+	char *release_agent;
+	bool cpuset_clone_children;
+	char *name;
+	/* User explicitly requested empty subsystem */
+	bool none;
+};
+
 extern struct cgroup_subsys *cgroup_subsys[];
 extern struct list_head cgroup_roots;
 extern struct file_system_type cgroup_fs_type;
@@ -64,7 +74,13 @@ void cgroup_kn_unlock(struct kernfs_node *kn);
 int cgroup_path_ns_locked(struct cgroup *cgrp, char *buf, size_t buflen,
 			  struct cgroup_namespace *ns);
 
+void cgroup_free_root(struct cgroup_root *root);
+void init_cgroup_root(struct cgroup_root *root, struct cgroup_sb_opts *opts);
+int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask);
 int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask);
+struct dentry *cgroup_do_mount(struct file_system_type *fs_type, int flags,
+			       struct cgroup_root *root, unsigned long magic,
+			       struct cgroup_namespace *ns);
 
 bool cgroup_may_migrate_to(struct cgroup *dst_cgrp);
 void cgroup_migrate_finish(struct list_head *preloaded_csets);
@@ -84,18 +100,24 @@ ssize_t cgroup_procs_write(struct kernfs_open_file *of, char *buf, size_t nbytes
 
 void cgroup_lock_and_drain_offline(struct cgroup *cgrp);
 
+int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode);
+int cgroup_rmdir(struct kernfs_node *kn);
+int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
+		     struct kernfs_root *kf_root);
+
 /*
  * cgroup-v1.c
  */
-extern spinlock_t release_agent_path_lock;
 extern struct cftype cgroup_legacy_base_files[];
 extern const struct file_operations proc_cgroupstats_operations;
+extern struct kernfs_syscall_ops cgroup1_kf_syscall_ops;
 
 bool cgroup_ssid_no_v1(int ssid);
 void cgroup_pidlist_destroy_all(struct cgroup *cgrp);
-int cgroup1_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
-		   const char *new_name_str);
 void cgroup_release_agent(struct work_struct *work);
 void check_for_release(struct cgroup *cgrp);
+struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
+			     void *data, unsigned long magic,
+			     struct cgroup_namespace *ns);
 
 #endif /* __CGROUP_INTERNAL_H */
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 0b2c24f..ae240c0 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -1,7 +1,9 @@
 #include "cgroup-internal.h"
 
+#include <linux/ctype.h>
 #include <linux/kmod.h>
 #include <linux/sort.h>
+#include <linux/delay.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
@@ -32,7 +34,7 @@ static struct workqueue_struct *cgroup_pidlist_destroy_wq;
  * Protects cgroup_subsys->release_agent_path.  Modifying it also requires
  * cgroup_mutex.  Reading requires either cgroup_mutex or this spinlock.
  */
-DEFINE_SPINLOCK(release_agent_path_lock);
+static DEFINE_SPINLOCK(release_agent_path_lock);
 
 bool cgroup_ssid_no_v1(int ssid)
 {
@@ -800,8 +802,8 @@ void cgroup_release_agent(struct work_struct *work)
 /*
  * cgroup_rename - Only allow simple rename of directories in place.
  */
-int cgroup1_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
-		   const char *new_name_str)
+static int cgroup1_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
+			  const char *new_name_str)
 {
 	struct cgroup *cgrp = kn->priv;
 	int ret;
@@ -832,6 +834,379 @@ int cgroup1_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
 	return ret;
 }
 
+static int cgroup1_show_options(struct seq_file *seq, struct kernfs_root *kf_root)
+{
+	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
+	struct cgroup_subsys *ss;
+	int ssid;
+
+	for_each_subsys(ss, ssid)
+		if (root->subsys_mask & (1 << ssid))
+			seq_show_option(seq, ss->legacy_name, NULL);
+	if (root->flags & CGRP_ROOT_NOPREFIX)
+		seq_puts(seq, ",noprefix");
+	if (root->flags & CGRP_ROOT_XATTR)
+		seq_puts(seq, ",xattr");
+
+	spin_lock(&release_agent_path_lock);
+	if (strlen(root->release_agent_path))
+		seq_show_option(seq, "release_agent",
+				root->release_agent_path);
+	spin_unlock(&release_agent_path_lock);
+
+	if (test_bit(CGRP_CPUSET_CLONE_CHILDREN, &root->cgrp.flags))
+		seq_puts(seq, ",clone_children");
+	if (strlen(root->name))
+		seq_show_option(seq, "name", root->name);
+	return 0;
+}
+
+static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
+{
+	char *token, *o = data;
+	bool all_ss = false, one_ss = false;
+	u16 mask = U16_MAX;
+	struct cgroup_subsys *ss;
+	int nr_opts = 0;
+	int i;
+
+#ifdef CONFIG_CPUSETS
+	mask = ~((u16)1 << cpuset_cgrp_id);
+#endif
+
+	memset(opts, 0, sizeof(*opts));
+
+	while ((token = strsep(&o, ",")) != NULL) {
+		nr_opts++;
+
+		if (!*token)
+			return -EINVAL;
+		if (!strcmp(token, "none")) {
+			/* Explicitly have no subsystems */
+			opts->none = true;
+			continue;
+		}
+		if (!strcmp(token, "all")) {
+			/* Mutually exclusive option 'all' + subsystem name */
+			if (one_ss)
+				return -EINVAL;
+			all_ss = true;
+			continue;
+		}
+		if (!strcmp(token, "noprefix")) {
+			opts->flags |= CGRP_ROOT_NOPREFIX;
+			continue;
+		}
+		if (!strcmp(token, "clone_children")) {
+			opts->cpuset_clone_children = true;
+			continue;
+		}
+		if (!strcmp(token, "xattr")) {
+			opts->flags |= CGRP_ROOT_XATTR;
+			continue;
+		}
+		if (!strncmp(token, "release_agent=", 14)) {
+			/* Specifying two release agents is forbidden */
+			if (opts->release_agent)
+				return -EINVAL;
+			opts->release_agent =
+				kstrndup(token + 14, PATH_MAX - 1, GFP_KERNEL);
+			if (!opts->release_agent)
+				return -ENOMEM;
+			continue;
+		}
+		if (!strncmp(token, "name=", 5)) {
+			const char *name = token + 5;
+			/* Can't specify an empty name */
+			if (!strlen(name))
+				return -EINVAL;
+			/* Must match [\w.-]+ */
+			for (i = 0; i < strlen(name); i++) {
+				char c = name[i];
+				if (isalnum(c))
+					continue;
+				if ((c == '.') || (c == '-') || (c == '_'))
+					continue;
+				return -EINVAL;
+			}
+			/* Specifying two names is forbidden */
+			if (opts->name)
+				return -EINVAL;
+			opts->name = kstrndup(name,
+					      MAX_CGROUP_ROOT_NAMELEN - 1,
+					      GFP_KERNEL);
+			if (!opts->name)
+				return -ENOMEM;
+
+			continue;
+		}
+
+		for_each_subsys(ss, i) {
+			if (strcmp(token, ss->legacy_name))
+				continue;
+			if (!cgroup_ssid_enabled(i))
+				continue;
+			if (cgroup_ssid_no_v1(i))
+				continue;
+
+			/* Mutually exclusive option 'all' + subsystem name */
+			if (all_ss)
+				return -EINVAL;
+			opts->subsys_mask |= (1 << i);
+			one_ss = true;
+
+			break;
+		}
+		if (i == CGROUP_SUBSYS_COUNT)
+			return -ENOENT;
+	}
+
+	/*
+	 * If the 'all' option was specified select all the subsystems,
+	 * otherwise if 'none', 'name=' and a subsystem name options were
+	 * not specified, let's default to 'all'
+	 */
+	if (all_ss || (!one_ss && !opts->none && !opts->name))
+		for_each_subsys(ss, i)
+			if (cgroup_ssid_enabled(i) && !cgroup_ssid_no_v1(i))
+				opts->subsys_mask |= (1 << i);
+
+	/*
+	 * We either have to specify by name or by subsystems. (So all
+	 * empty hierarchies must have a name).
+	 */
+	if (!opts->subsys_mask && !opts->name)
+		return -EINVAL;
+
+	/*
+	 * Option noprefix was introduced just for backward compatibility
+	 * with the old cpuset, so we allow noprefix only if mounting just
+	 * the cpuset subsystem.
+	 */
+	if ((opts->flags & CGRP_ROOT_NOPREFIX) && (opts->subsys_mask & mask))
+		return -EINVAL;
+
+	/* Can't specify "none" and some subsystems */
+	if (opts->subsys_mask && opts->none)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int cgroup1_remount(struct kernfs_root *kf_root, int *flags, char *data)
+{
+	int ret = 0;
+	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
+	struct cgroup_sb_opts opts;
+	u16 added_mask, removed_mask;
+
+	cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
+
+	/* See what subsystems are wanted */
+	ret = parse_cgroupfs_options(data, &opts);
+	if (ret)
+		goto out_unlock;
+
+	if (opts.subsys_mask != root->subsys_mask || opts.release_agent)
+		pr_warn("option changes via remount are deprecated (pid=%d comm=%s)\n",
+			task_tgid_nr(current), current->comm);
+
+	added_mask = opts.subsys_mask & ~root->subsys_mask;
+	removed_mask = root->subsys_mask & ~opts.subsys_mask;
+
+	/* Don't allow flags or name to change at remount */
+	if ((opts.flags ^ root->flags) ||
+	    (opts.name && strcmp(opts.name, root->name))) {
+		pr_err("option or name mismatch, new: 0x%x \"%s\", old: 0x%x \"%s\"\n",
+		       opts.flags, opts.name ?: "", root->flags, root->name);
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	/* remounting is not allowed for populated hierarchies */
+	if (!list_empty(&root->cgrp.self.children)) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	ret = rebind_subsystems(root, added_mask);
+	if (ret)
+		goto out_unlock;
+
+	WARN_ON(rebind_subsystems(&cgrp_dfl_root, removed_mask));
+
+	if (opts.release_agent) {
+		spin_lock(&release_agent_path_lock);
+		strcpy(root->release_agent_path, opts.release_agent);
+		spin_unlock(&release_agent_path_lock);
+	}
+
+	trace_cgroup_remount(root);
+
+ out_unlock:
+	kfree(opts.release_agent);
+	kfree(opts.name);
+	mutex_unlock(&cgroup_mutex);
+	return ret;
+}
+
+struct kernfs_syscall_ops cgroup1_kf_syscall_ops = {
+	.rename			= cgroup1_rename,
+	.show_options		= cgroup1_show_options,
+	.remount_fs		= cgroup1_remount,
+	.mkdir			= cgroup_mkdir,
+	.rmdir			= cgroup_rmdir,
+	.show_path		= cgroup_show_path,
+};
+
+struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
+			     void *data, unsigned long magic,
+			     struct cgroup_namespace *ns)
+{
+	struct super_block *pinned_sb = NULL;
+	struct cgroup_sb_opts opts;
+	struct cgroup_root *root;
+	struct cgroup_subsys *ss;
+	struct dentry *dentry;
+	int i, ret;
+
+	cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
+
+	/* First find the desired set of subsystems */
+	ret = parse_cgroupfs_options(data, &opts);
+	if (ret)
+		goto out_unlock;
+
+	/*
+	 * Destruction of cgroup root is asynchronous, so subsystems may
+	 * still be dying after the previous unmount.  Let's drain the
+	 * dying subsystems.  We just need to ensure that the ones
+	 * unmounted previously finish dying and don't care about new ones
+	 * starting.  Testing ref liveliness is good enough.
+	 */
+	for_each_subsys(ss, i) {
+		if (!(opts.subsys_mask & (1 << i)) ||
+		    ss->root == &cgrp_dfl_root)
+			continue;
+
+		if (!percpu_ref_tryget_live(&ss->root->cgrp.self.refcnt)) {
+			mutex_unlock(&cgroup_mutex);
+			msleep(10);
+			ret = restart_syscall();
+			goto out_free;
+		}
+		cgroup_put(&ss->root->cgrp);
+	}
+
+	for_each_root(root) {
+		bool name_match = false;
+
+		if (root == &cgrp_dfl_root)
+			continue;
+
+		/*
+		 * If we asked for a name then it must match.  Also, if
+		 * name matches but sybsys_mask doesn't, we should fail.
+		 * Remember whether name matched.
+		 */
+		if (opts.name) {
+			if (strcmp(opts.name, root->name))
+				continue;
+			name_match = true;
+		}
+
+		/*
+		 * If we asked for subsystems (or explicitly for no
+		 * subsystems) then they must match.
+		 */
+		if ((opts.subsys_mask || opts.none) &&
+		    (opts.subsys_mask != root->subsys_mask)) {
+			if (!name_match)
+				continue;
+			ret = -EBUSY;
+			goto out_unlock;
+		}
+
+		if (root->flags ^ opts.flags)
+			pr_warn("new mount options do not match the existing superblock, will be ignored\n");
+
+		/*
+		 * We want to reuse @root whose lifetime is governed by its
+		 * ->cgrp.  Let's check whether @root is alive and keep it
+		 * that way.  As cgroup_kill_sb() can happen anytime, we
+		 * want to block it by pinning the sb so that @root doesn't
+		 * get killed before mount is complete.
+		 *
+		 * With the sb pinned, tryget_live can reliably indicate
+		 * whether @root can be reused.  If it's being killed,
+		 * drain it.  We can use wait_queue for the wait but this
+		 * path is super cold.  Let's just sleep a bit and retry.
+		 */
+		pinned_sb = kernfs_pin_sb(root->kf_root, NULL);
+		if (IS_ERR(pinned_sb) ||
+		    !percpu_ref_tryget_live(&root->cgrp.self.refcnt)) {
+			mutex_unlock(&cgroup_mutex);
+			if (!IS_ERR_OR_NULL(pinned_sb))
+				deactivate_super(pinned_sb);
+			msleep(10);
+			ret = restart_syscall();
+			goto out_free;
+		}
+
+		ret = 0;
+		goto out_unlock;
+	}
+
+	/*
+	 * No such thing, create a new one.  name= matching without subsys
+	 * specification is allowed for already existing hierarchies but we
+	 * can't create new one without subsys specification.
+	 */
+	if (!opts.subsys_mask && !opts.none) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	/* Hierarchies may only be created in the initial cgroup namespace. */
+	if (ns != &init_cgroup_ns) {
+		ret = -EPERM;
+		goto out_unlock;
+	}
+
+	root = kzalloc(sizeof(*root), GFP_KERNEL);
+	if (!root) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	init_cgroup_root(root, &opts);
+
+	ret = cgroup_setup_root(root, opts.subsys_mask);
+	if (ret)
+		cgroup_free_root(root);
+
+out_unlock:
+	mutex_unlock(&cgroup_mutex);
+out_free:
+	kfree(opts.release_agent);
+	kfree(opts.name);
+
+	if (ret)
+		return ERR_PTR(ret);
+
+	dentry = cgroup_do_mount(&cgroup_fs_type, flags, root,
+				 CGROUP_SUPER_MAGIC, ns);
+
+	/*
+	 * If @pinned_sb, we're reusing an existing root and holding an
+	 * extra ref on its sb.  Mount is complete.  Put the extra ref.
+	 */
+	if (pinned_sb)
+		deactivate_super(pinned_sb);
+
+	return dentry;
+}
+
 static int __init cgroup1_wq_init(void)
 {
 	/*
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f1b71fb..ae25f14 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -31,7 +31,6 @@
 #include "cgroup-internal.h"
 
 #include <linux/cred.h>
-#include <linux/ctype.h>
 #include <linux/errno.h>
 #include <linux/init_task.h>
 #include <linux/kernel.h>
@@ -49,7 +48,6 @@
 #include <linux/hashtable.h>
 #include <linux/idr.h>
 #include <linux/kthread.h>
-#include <linux/delay.h>
 #include <linux/atomic.h>
 #include <linux/cpuset.h>
 #include <linux/proc_ns.h>
@@ -1080,7 +1078,7 @@ static void cgroup_exit_root_id(struct cgroup_root *root)
 	idr_remove(&cgroup_hierarchy_idr, root->hierarchy_id);
 }
 
-static void cgroup_free_root(struct cgroup_root *root)
+void cgroup_free_root(struct cgroup_root *root)
 {
 	if (root) {
 		idr_destroy(&root->cgroup_idr);
@@ -1234,7 +1232,6 @@ struct cgroup *task_cgroup_from_root(struct task_struct *task,
  * update of a tasks cgroup pointer by cgroup_attach_task()
  */
 
-static struct kernfs_syscall_ops cgroup1_kf_syscall_ops;
 static struct kernfs_syscall_ops cgroup_kf_syscall_ops;
 
 static char *cgroup_file_name(struct cgroup *cgrp, const struct cftype *cft,
@@ -1542,8 +1539,8 @@ int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 	return 0;
 }
 
-static int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
-			    struct kernfs_root *kf_root)
+int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
+		     struct kernfs_root *kf_root)
 {
 	int len = 0;
 	char *buf = NULL;
@@ -1569,232 +1566,6 @@ static int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
 	return len;
 }
 
-static int cgroup1_show_options(struct seq_file *seq, struct kernfs_root *kf_root)
-{
-	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
-	struct cgroup_subsys *ss;
-	int ssid;
-
-	for_each_subsys(ss, ssid)
-		if (root->subsys_mask & (1 << ssid))
-			seq_show_option(seq, ss->legacy_name, NULL);
-	if (root->flags & CGRP_ROOT_NOPREFIX)
-		seq_puts(seq, ",noprefix");
-	if (root->flags & CGRP_ROOT_XATTR)
-		seq_puts(seq, ",xattr");
-
-	spin_lock(&release_agent_path_lock);
-	if (strlen(root->release_agent_path))
-		seq_show_option(seq, "release_agent",
-				root->release_agent_path);
-	spin_unlock(&release_agent_path_lock);
-
-	if (test_bit(CGRP_CPUSET_CLONE_CHILDREN, &root->cgrp.flags))
-		seq_puts(seq, ",clone_children");
-	if (strlen(root->name))
-		seq_show_option(seq, "name", root->name);
-	return 0;
-}
-
-struct cgroup_sb_opts {
-	u16 subsys_mask;
-	unsigned int flags;
-	char *release_agent;
-	bool cpuset_clone_children;
-	char *name;
-	/* User explicitly requested empty subsystem */
-	bool none;
-};
-
-static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
-{
-	char *token, *o = data;
-	bool all_ss = false, one_ss = false;
-	u16 mask = U16_MAX;
-	struct cgroup_subsys *ss;
-	int nr_opts = 0;
-	int i;
-
-#ifdef CONFIG_CPUSETS
-	mask = ~((u16)1 << cpuset_cgrp_id);
-#endif
-
-	memset(opts, 0, sizeof(*opts));
-
-	while ((token = strsep(&o, ",")) != NULL) {
-		nr_opts++;
-
-		if (!*token)
-			return -EINVAL;
-		if (!strcmp(token, "none")) {
-			/* Explicitly have no subsystems */
-			opts->none = true;
-			continue;
-		}
-		if (!strcmp(token, "all")) {
-			/* Mutually exclusive option 'all' + subsystem name */
-			if (one_ss)
-				return -EINVAL;
-			all_ss = true;
-			continue;
-		}
-		if (!strcmp(token, "noprefix")) {
-			opts->flags |= CGRP_ROOT_NOPREFIX;
-			continue;
-		}
-		if (!strcmp(token, "clone_children")) {
-			opts->cpuset_clone_children = true;
-			continue;
-		}
-		if (!strcmp(token, "xattr")) {
-			opts->flags |= CGRP_ROOT_XATTR;
-			continue;
-		}
-		if (!strncmp(token, "release_agent=", 14)) {
-			/* Specifying two release agents is forbidden */
-			if (opts->release_agent)
-				return -EINVAL;
-			opts->release_agent =
-				kstrndup(token + 14, PATH_MAX - 1, GFP_KERNEL);
-			if (!opts->release_agent)
-				return -ENOMEM;
-			continue;
-		}
-		if (!strncmp(token, "name=", 5)) {
-			const char *name = token + 5;
-			/* Can't specify an empty name */
-			if (!strlen(name))
-				return -EINVAL;
-			/* Must match [\w.-]+ */
-			for (i = 0; i < strlen(name); i++) {
-				char c = name[i];
-				if (isalnum(c))
-					continue;
-				if ((c == '.') || (c == '-') || (c == '_'))
-					continue;
-				return -EINVAL;
-			}
-			/* Specifying two names is forbidden */
-			if (opts->name)
-				return -EINVAL;
-			opts->name = kstrndup(name,
-					      MAX_CGROUP_ROOT_NAMELEN - 1,
-					      GFP_KERNEL);
-			if (!opts->name)
-				return -ENOMEM;
-
-			continue;
-		}
-
-		for_each_subsys(ss, i) {
-			if (strcmp(token, ss->legacy_name))
-				continue;
-			if (!cgroup_ssid_enabled(i))
-				continue;
-			if (cgroup_ssid_no_v1(i))
-				continue;
-
-			/* Mutually exclusive option 'all' + subsystem name */
-			if (all_ss)
-				return -EINVAL;
-			opts->subsys_mask |= (1 << i);
-			one_ss = true;
-
-			break;
-		}
-		if (i == CGROUP_SUBSYS_COUNT)
-			return -ENOENT;
-	}
-
-	/*
-	 * If the 'all' option was specified select all the subsystems,
-	 * otherwise if 'none', 'name=' and a subsystem name options were
-	 * not specified, let's default to 'all'
-	 */
-	if (all_ss || (!one_ss && !opts->none && !opts->name))
-		for_each_subsys(ss, i)
-			if (cgroup_ssid_enabled(i) && !cgroup_ssid_no_v1(i))
-				opts->subsys_mask |= (1 << i);
-
-	/*
-	 * We either have to specify by name or by subsystems. (So all
-	 * empty hierarchies must have a name).
-	 */
-	if (!opts->subsys_mask && !opts->name)
-		return -EINVAL;
-
-	/*
-	 * Option noprefix was introduced just for backward compatibility
-	 * with the old cpuset, so we allow noprefix only if mounting just
-	 * the cpuset subsystem.
-	 */
-	if ((opts->flags & CGRP_ROOT_NOPREFIX) && (opts->subsys_mask & mask))
-		return -EINVAL;
-
-	/* Can't specify "none" and some subsystems */
-	if (opts->subsys_mask && opts->none)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int cgroup1_remount(struct kernfs_root *kf_root, int *flags, char *data)
-{
-	int ret = 0;
-	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
-	struct cgroup_sb_opts opts;
-	u16 added_mask, removed_mask;
-
-	cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
-
-	/* See what subsystems are wanted */
-	ret = parse_cgroupfs_options(data, &opts);
-	if (ret)
-		goto out_unlock;
-
-	if (opts.subsys_mask != root->subsys_mask || opts.release_agent)
-		pr_warn("option changes via remount are deprecated (pid=%d comm=%s)\n",
-			task_tgid_nr(current), current->comm);
-
-	added_mask = opts.subsys_mask & ~root->subsys_mask;
-	removed_mask = root->subsys_mask & ~opts.subsys_mask;
-
-	/* Don't allow flags or name to change at remount */
-	if ((opts.flags ^ root->flags) ||
-	    (opts.name && strcmp(opts.name, root->name))) {
-		pr_err("option or name mismatch, new: 0x%x \"%s\", old: 0x%x \"%s\"\n",
-		       opts.flags, opts.name ?: "", root->flags, root->name);
-		ret = -EINVAL;
-		goto out_unlock;
-	}
-
-	/* remounting is not allowed for populated hierarchies */
-	if (!list_empty(&root->cgrp.self.children)) {
-		ret = -EBUSY;
-		goto out_unlock;
-	}
-
-	ret = rebind_subsystems(root, added_mask);
-	if (ret)
-		goto out_unlock;
-
-	WARN_ON(rebind_subsystems(&cgrp_dfl_root, removed_mask));
-
-	if (opts.release_agent) {
-		spin_lock(&release_agent_path_lock);
-		strcpy(root->release_agent_path, opts.release_agent);
-		spin_unlock(&release_agent_path_lock);
-	}
-
-	trace_cgroup_remount(root);
-
- out_unlock:
-	kfree(opts.release_agent);
-	kfree(opts.name);
-	mutex_unlock(&cgroup_mutex);
-	return ret;
-}
-
 static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 {
 	pr_err("remount is not allowed\n");
@@ -1879,8 +1650,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	INIT_WORK(&cgrp->release_agent_work, cgroup_release_agent);
 }
 
-static void init_cgroup_root(struct cgroup_root *root,
-			     struct cgroup_sb_opts *opts)
+void init_cgroup_root(struct cgroup_root *root, struct cgroup_sb_opts *opts)
 {
 	struct cgroup *cgrp = &root->cgrp;
 
@@ -1899,7 +1669,7 @@ static void init_cgroup_root(struct cgroup_root *root,
 		set_bit(CGRP_CPUSET_CLONE_CHILDREN, &root->cgrp.flags);
 }
 
-static int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
+int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 {
 	LIST_HEAD(tmp_links);
 	struct cgroup *root_cgrp = &root->cgrp;
@@ -1996,10 +1766,9 @@ static int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 	return ret;
 }
 
-static struct dentry *cgroup_do_mount(struct file_system_type *fs_type,
-				      int flags, struct cgroup_root *root,
-				      unsigned long magic,
-				      struct cgroup_namespace *ns)
+struct dentry *cgroup_do_mount(struct file_system_type *fs_type, int flags,
+			       struct cgroup_root *root, unsigned long magic,
+			       struct cgroup_namespace *ns)
 {
 	struct dentry *dentry;
 	bool new_sb;
@@ -2033,155 +1802,6 @@ static struct dentry *cgroup_do_mount(struct file_system_type *fs_type,
 	return dentry;
 }
 
-static struct dentry *cgroup1_mount(struct file_system_type *fs_type,
-				    int flags, void *data,
-				    unsigned long magic,
-				    struct cgroup_namespace *ns)
-{
-	struct super_block *pinned_sb = NULL;
-	struct cgroup_sb_opts opts;
-	struct cgroup_root *root;
-	struct cgroup_subsys *ss;
-	struct dentry *dentry;
-	int i, ret;
-
-	cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
-
-	/* First find the desired set of subsystems */
-	ret = parse_cgroupfs_options(data, &opts);
-	if (ret)
-		goto out_unlock;
-
-	/*
-	 * Destruction of cgroup root is asynchronous, so subsystems may
-	 * still be dying after the previous unmount.  Let's drain the
-	 * dying subsystems.  We just need to ensure that the ones
-	 * unmounted previously finish dying and don't care about new ones
-	 * starting.  Testing ref liveliness is good enough.
-	 */
-	for_each_subsys(ss, i) {
-		if (!(opts.subsys_mask & (1 << i)) ||
-		    ss->root == &cgrp_dfl_root)
-			continue;
-
-		if (!percpu_ref_tryget_live(&ss->root->cgrp.self.refcnt)) {
-			mutex_unlock(&cgroup_mutex);
-			msleep(10);
-			ret = restart_syscall();
-			goto out_free;
-		}
-		cgroup_put(&ss->root->cgrp);
-	}
-
-	for_each_root(root) {
-		bool name_match = false;
-
-		if (root == &cgrp_dfl_root)
-			continue;
-
-		/*
-		 * If we asked for a name then it must match.  Also, if
-		 * name matches but sybsys_mask doesn't, we should fail.
-		 * Remember whether name matched.
-		 */
-		if (opts.name) {
-			if (strcmp(opts.name, root->name))
-				continue;
-			name_match = true;
-		}
-
-		/*
-		 * If we asked for subsystems (or explicitly for no
-		 * subsystems) then they must match.
-		 */
-		if ((opts.subsys_mask || opts.none) &&
-		    (opts.subsys_mask != root->subsys_mask)) {
-			if (!name_match)
-				continue;
-			ret = -EBUSY;
-			goto out_unlock;
-		}
-
-		if (root->flags ^ opts.flags)
-			pr_warn("new mount options do not match the existing superblock, will be ignored\n");
-
-		/*
-		 * We want to reuse @root whose lifetime is governed by its
-		 * ->cgrp.  Let's check whether @root is alive and keep it
-		 * that way.  As cgroup_kill_sb() can happen anytime, we
-		 * want to block it by pinning the sb so that @root doesn't
-		 * get killed before mount is complete.
-		 *
-		 * With the sb pinned, tryget_live can reliably indicate
-		 * whether @root can be reused.  If it's being killed,
-		 * drain it.  We can use wait_queue for the wait but this
-		 * path is super cold.  Let's just sleep a bit and retry.
-		 */
-		pinned_sb = kernfs_pin_sb(root->kf_root, NULL);
-		if (IS_ERR(pinned_sb) ||
-		    !percpu_ref_tryget_live(&root->cgrp.self.refcnt)) {
-			mutex_unlock(&cgroup_mutex);
-			if (!IS_ERR_OR_NULL(pinned_sb))
-				deactivate_super(pinned_sb);
-			msleep(10);
-			ret = restart_syscall();
-			goto out_free;
-		}
-
-		ret = 0;
-		goto out_unlock;
-	}
-
-	/*
-	 * No such thing, create a new one.  name= matching without subsys
-	 * specification is allowed for already existing hierarchies but we
-	 * can't create new one without subsys specification.
-	 */
-	if (!opts.subsys_mask && !opts.none) {
-		ret = -EINVAL;
-		goto out_unlock;
-	}
-
-	/* Hierarchies may only be created in the initial cgroup namespace. */
-	if (ns != &init_cgroup_ns) {
-		ret = -EPERM;
-		goto out_unlock;
-	}
-
-	root = kzalloc(sizeof(*root), GFP_KERNEL);
-	if (!root) {
-		ret = -ENOMEM;
-		goto out_unlock;
-	}
-
-	init_cgroup_root(root, &opts);
-
-	ret = cgroup_setup_root(root, opts.subsys_mask);
-	if (ret)
-		cgroup_free_root(root);
-
-out_unlock:
-	mutex_unlock(&cgroup_mutex);
-out_free:
-	kfree(opts.release_agent);
-	kfree(opts.name);
-
-	if (ret)
-		return ERR_PTR(ret);
-
-	dentry = cgroup_do_mount(&cgroup_fs_type, flags, root,
-				 CGROUP_SUPER_MAGIC, ns);
-
-	/*
-	 * If @pinned_sb, we're reusing an existing root and holding an
-	 * extra ref on its sb.  Mount is complete.  Put the extra ref.
-	 */
-	if (pinned_sb)
-		deactivate_super(pinned_sb);
-
-	return dentry;
-}
-
 static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 			 int flags, const char *unused_dev_name,
 			 void *data)
@@ -4589,8 +4209,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 	return ERR_PTR(ret);
 }
 
-static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
-			umode_t mode)
+int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode)
 {
 	struct cgroup *parent, *cgrp;
 	struct kernfs_node *kn;
@@ -4802,7 +4421,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	return 0;
 };
 
-static int cgroup_rmdir(struct kernfs_node *kn)
+int cgroup_rmdir(struct kernfs_node *kn)
 {
 	struct cgroup *cgrp;
 	int ret = 0;
@@ -4820,15 +4439,6 @@ static int cgroup_rmdir(struct kernfs_node *kn)
 	return ret;
 }
 
-static struct kernfs_syscall_ops cgroup1_kf_syscall_ops = {
-	.remount_fs		= cgroup1_remount,
-	.show_options		= cgroup1_show_options,
-	.rename			= cgroup1_rename,
-	.mkdir			= cgroup_mkdir,
-	.rmdir			= cgroup_rmdir,
-	.show_path		= cgroup_show_path,
-};
-
 static struct kernfs_syscall_ops cgroup_kf_syscall_ops = {
 	.remount_fs		= cgroup_remount,
 	.mkdir			= cgroup_mkdir,
-- 
2.9.3
