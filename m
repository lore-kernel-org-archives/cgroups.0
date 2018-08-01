From: David Howells <dhowells@redhat.com>
Subject: [PATCH 20/33] kernfs, sysfs, cgroup,
 intel_rdt: Support fs_context [ver #11]
Date: Wed, 01 Aug 2018 16:26:21 +0100
Message-ID: <153313718136.13253.5769367761996938690.stgit@warthog.procyon.org.uk>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: viro@zeniv.linux.org.uk
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, fenghua.yu@intel.com, torvalds@linux-foundation.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Make kernfs support superblock creation/mount/remount with fs_context.

This requires that sysfs, cgroup and intel_rdt, which are built on kernfs,
be made to support fs_context also.

Notes:

 (1) A kernfs_fs_context struct is created to wrap fs_context and the
     kernfs mount parameters are moved in here (or are in fs_context).

 (2) kernfs_mount{,_ns}() are made into kernfs_get_tree().  The extra
     namespace tag parameter is passed in the context if desired

 (3) kernfs_free_fs_context() is provided as a destructor for the
     kernfs_fs_context struct, but for the moment it does nothing except
     get called in the right places.

 (4) sysfs doesn't wrap kernfs_fs_context since it has no parameters to
     pass, but possibly this should be done anyway in case someone wants to
     add a parameter in future.

 (5) A cgroup_fs_context struct is created to wrap kernfs_fs_context and
     the cgroup v1 and v2 mount parameters are all moved there.

 (6) cgroup1 parameter parsing error messages are now handled by invalf(),
     which allows userspace to collect them directly.

 (7) cgroup1 parameter cleanup is now done in the context destructor rather
     than in the mount/get_tree and remount functions.

Weirdies:

 (*) cgroup_do_get_tree() calls cset_cgroup_from_root() with locks held,
     but then uses the resulting pointer after dropping the locks.  I'm
     told this is okay and needs commenting.

 (*) The cgroup refcount web.  This really needs documenting.

 (*) cgroup2 only has one root?

Add a suggestion from Thomas Gleixner in which the RDT enablement code is
placed into its own function.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Tejun Heo <tj@kernel.org>
cc: Li Zefan <lizefan@huawei.com>
cc: Johannes Weiner <hannes@cmpxchg.org>
cc: cgroups@vger.kernel.org
cc: fenghua.yu@intel.com
---

 arch/x86/kernel/cpu/intel_rdt.h          |   15 +
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c |  184 ++++++++++------
 fs/kernfs/mount.c                        |   87 ++++----
 fs/sysfs/mount.c                         |   67 ++++--
 include/linux/cgroup.h                   |    3 
 include/linux/kernfs.h                   |   39 ++-
 kernel/cgroup/cgroup-internal.h          |   50 +++-
 kernel/cgroup/cgroup-v1.c                |  347 +++++++++++++++++-------------
 kernel/cgroup/cgroup.c                   |  256 ++++++++++++++--------
 kernel/cgroup/cpuset.c                   |    4 
 10 files changed, 635 insertions(+), 417 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_rdt.h b/arch/x86/kernel/cpu/intel_rdt.h
index be152b3b2543..82dda4daec7f 100644
--- a/arch/x86/kernel/cpu/intel_rdt.h
+++ b/arch/x86/kernel/cpu/intel_rdt.h
@@ -33,6 +33,21 @@
 #define RMID_VAL_ERROR			BIT_ULL(63)
 #define RMID_VAL_UNAVAIL		BIT_ULL(62)
 
+
+struct rdt_fs_context {
+	struct kernfs_fs_context	kfc;
+	bool				enable_cdpl2;
+	bool				enable_cdpl3;
+	bool				enable_mba_mbps;
+};
+
+static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
+{
+	struct kernfs_fs_context *kfc = fc->fs_private;
+
+	return container_of(kfc, struct rdt_fs_context, kfc);
+}
+
 DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
 
 /**
diff --git a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
index c74365b78253..b11d81dafa9a 100644
--- a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
+++ b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
@@ -22,6 +22,7 @@
 
 #include <linux/cpu.h>
 #include <linux/fs.h>
+#include <linux/fs_parser.h>
 #include <linux/sysfs.h>
 #include <linux/kernfs.h>
 #include <linux/seq_buf.h>
@@ -1131,43 +1132,6 @@ static void cdp_disable_all(void)
 		cdpl2_disable();
 }
 
-static int parse_rdtgroupfs_options(char *data)
-{
-	char *token, *o = data;
-	int ret = 0;
-
-	while ((token = strsep(&o, ",")) != NULL) {
-		if (!*token) {
-			ret = -EINVAL;
-			goto out;
-		}
-
-		if (!strcmp(token, "cdp")) {
-			ret = cdpl3_enable();
-			if (ret)
-				goto out;
-		} else if (!strcmp(token, "cdpl2")) {
-			ret = cdpl2_enable();
-			if (ret)
-				goto out;
-		} else if (!strcmp(token, "mba_MBps")) {
-			ret = set_mba_sc(true);
-			if (ret)
-				goto out;
-		} else {
-			ret = -EINVAL;
-			goto out;
-		}
-	}
-
-	return 0;
-
-out:
-	pr_err("Invalid mount option \"%s\"\n", token);
-
-	return ret;
-}
-
 /*
  * We don't allow rdtgroup directories to be created anywhere
  * except the root directory. Thus when looking for the rdtgroup
@@ -1236,13 +1200,27 @@ static int mkdir_mondata_all(struct kernfs_node *parent_kn,
 			     struct rdtgroup *prgrp,
 			     struct kernfs_node **mon_data_kn);
 
-static struct dentry *rdt_mount(struct file_system_type *fs_type,
-				int flags, const char *unused_dev_name,
-				void *data, size_t data_size)
+static int rdt_enable_ctx(struct rdt_fs_context *ctx)
 {
+	int ret = 0;
+
+	if (ctx->enable_cdpl2)
+		ret = cdpl2_enable();
+
+	if (!ret && ctx->enable_cdpl3)
+		ret = cdpl3_enable();
+
+	if (!ret && ctx->enable_mba_mbps)
+		ret = set_mba_sc(true);
+
+	return ret;
+}
+
+static int rdt_get_tree(struct fs_context *fc)
+{
+	struct rdt_fs_context *ctx = rdt_fc2context(fc);
 	struct rdt_domain *dom;
 	struct rdt_resource *r;
-	struct dentry *dentry;
 	int ret;
 
 	cpus_read_lock();
@@ -1251,53 +1229,42 @@ static struct dentry *rdt_mount(struct file_system_type *fs_type,
 	 * resctrl file system can only be mounted once.
 	 */
 	if (static_branch_unlikely(&rdt_enable_key)) {
-		dentry = ERR_PTR(-EBUSY);
+		ret = -EBUSY;
 		goto out;
 	}
 
-	ret = parse_rdtgroupfs_options(data);
-	if (ret) {
-		dentry = ERR_PTR(ret);
+	ret = rdt_enable_ctx(ctx);
+	if (ret < 0)
 		goto out_cdp;
-	}
 
 	closid_init();
 
 	ret = rdtgroup_create_info_dir(rdtgroup_default.kn);
-	if (ret) {
-		dentry = ERR_PTR(ret);
-		goto out_cdp;
-	}
+	if (ret < 0)
+		goto out_mba;
 
 	if (rdt_mon_capable) {
 		ret = mongroup_create_dir(rdtgroup_default.kn,
 					  NULL, "mon_groups",
 					  &kn_mongrp);
-		if (ret) {
-			dentry = ERR_PTR(ret);
+		if (ret < 0)
 			goto out_info;
-		}
 		kernfs_get(kn_mongrp);
 
 		ret = mkdir_mondata_all(rdtgroup_default.kn,
 					&rdtgroup_default, &kn_mondata);
-		if (ret) {
-			dentry = ERR_PTR(ret);
+		if (ret < 0)
 			goto out_mongrp;
-		}
 		kernfs_get(kn_mondata);
 		rdtgroup_default.mon.mon_data_kn = kn_mondata;
 	}
 
 	ret = rdt_pseudo_lock_init();
-	if (ret) {
-		dentry = ERR_PTR(ret);
+	if (ret)
 		goto out_mondata;
-	}
 
-	dentry = kernfs_mount(fs_type, flags, rdt_root,
-			      RDTGROUP_SUPER_MAGIC, NULL);
-	if (IS_ERR(dentry))
+	ret = kernfs_get_tree(fc);
+	if (ret < 0)
 		goto out_psl;
 
 	if (rdt_alloc_capable)
@@ -1326,14 +1293,98 @@ static struct dentry *rdt_mount(struct file_system_type *fs_type,
 		kernfs_remove(kn_mongrp);
 out_info:
 	kernfs_remove(kn_info);
+out_mba:
+	if (ctx->enable_mba_mbps)
+		set_mba_sc(false);
 out_cdp:
 	cdp_disable_all();
 out:
 	rdt_last_cmd_clear();
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
+	return ret;
+}
+
+enum rdt_param {
+	Opt_cdp,
+	Opt_cdpl2,
+	Opt_mba_mpbs,
+	nr__rdt_params
+};
+
+static const struct fs_parameter_spec rdt_param_specs[nr__rdt_params] = {
+	[Opt_cdp]	= { fs_param_takes_no_value },
+	[Opt_cdpl2]	= { fs_param_takes_no_value },
+	[Opt_mba_mpbs]	= { fs_param_takes_no_value },
+};
+
+static const struct constant_table rdt_param_keys[] = {
+	{ "cdp",	Opt_cdp },
+	{ "cdpl2",	Opt_cdpl2 },
+	{ "mba_mbps",	Opt_mba_mpbs },
+};
+
+static const struct fs_parameter_description rdt_fs_parameters = {
+	.name		= "rdt",
+	.nr_params	= nr__rdt_params,
+	.nr_keys	= ARRAY_SIZE(rdt_param_keys),
+	.keys		= rdt_param_keys,
+	.specs		= rdt_param_specs,
+	.no_source	= true,
+};
+
+static int rdt_parse_param(struct fs_context *fc, struct fs_parameter *param)
+{
+	struct rdt_fs_context *ctx = rdt_fc2context(fc);
+	struct fs_parse_result result;
+	int ret;
+
+	ret = fs_parse(fc, &rdt_fs_parameters, param, &result);
+	if (ret < 0)
+		return ret;
+
+	switch (result.key) {
+	case Opt_cdp:
+		ctx->enable_cdpl3 = true;
+		return 0;
+	case Opt_cdpl2:
+		ctx->enable_cdpl2 = true;
+		return 0;
+	case Opt_mba_mpbs:
+		ctx->enable_mba_mbps = true;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static void rdt_fs_context_free(struct fs_context *fc)
+{
+	struct rdt_fs_context *ctx = rdt_fc2context(fc);
 
-	return dentry;
+	kernfs_free_fs_context(fc);
+	kfree(ctx);
+}
+
+static const struct fs_context_operations rdt_fs_context_ops = {
+	.free		= rdt_fs_context_free,
+	.parse_param	= rdt_parse_param,
+	.get_tree	= rdt_get_tree,
+};
+
+static int rdt_init_fs_context(struct fs_context *fc, struct dentry *reference)
+{
+	struct rdt_fs_context *ctx;
+
+	ctx = kzalloc(sizeof(struct rdt_fs_context), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->kfc.root = rdt_root;
+	ctx->kfc.magic = RDTGROUP_SUPER_MAGIC;
+	fc->fs_private = &ctx->kfc;
+	fc->ops = &rdt_fs_context_ops;
+	return 0;
 }
 
 static int reset_all_ctrls(struct rdt_resource *r)
@@ -1500,9 +1551,10 @@ static void rdt_kill_sb(struct super_block *sb)
 }
 
 static struct file_system_type rdt_fs_type = {
-	.name    = "resctrl",
-	.mount   = rdt_mount,
-	.kill_sb = rdt_kill_sb,
+	.name			= "resctrl",
+	.init_fs_context	= rdt_init_fs_context,
+	.parameters		= &rdt_fs_parameters,
+	.kill_sb		= rdt_kill_sb,
 };
 
 static int mon_addfile(struct kernfs_node *parent_kn, const char *name,
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index f70e0b69e714..188c683eab14 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -22,14 +22,13 @@
 
 struct kmem_cache *kernfs_node_cache;
 
-static int kernfs_sop_remount_fs(struct super_block *sb, int *flags,
-				 char *data, size_t data_size)
+static int kernfs_sop_reconfigure(struct super_block *sb, struct fs_context *fc)
 {
 	struct kernfs_root *root = kernfs_info(sb)->root;
 	struct kernfs_syscall_ops *scops = root->syscall_ops;
 
-	if (scops && scops->remount_fs)
-		return scops->remount_fs(root, flags, data);
+	if (scops && scops->reconfigure)
+		return scops->reconfigure(root, fc);
 	return 0;
 }
 
@@ -61,7 +60,7 @@ const struct super_operations kernfs_sops = {
 	.drop_inode	= generic_delete_inode,
 	.evict_inode	= kernfs_evict_inode,
 
-	.remount_fs	= kernfs_sop_remount_fs,
+	.reconfigure	= kernfs_sop_reconfigure,
 	.show_options	= kernfs_sop_show_options,
 	.show_path	= kernfs_sop_show_path,
 };
@@ -219,7 +218,7 @@ struct dentry *kernfs_node_dentry(struct kernfs_node *kn,
 	} while (true);
 }
 
-static int kernfs_fill_super(struct super_block *sb, unsigned long magic)
+static int kernfs_fill_super(struct super_block *sb, struct kernfs_fs_context *kfc)
 {
 	struct kernfs_super_info *info = kernfs_info(sb);
 	struct inode *inode;
@@ -230,7 +229,7 @@ static int kernfs_fill_super(struct super_block *sb, unsigned long magic)
 	sb->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
 	sb->s_blocksize = PAGE_SIZE;
 	sb->s_blocksize_bits = PAGE_SHIFT;
-	sb->s_magic = magic;
+	sb->s_magic = kfc->magic;
 	sb->s_op = &kernfs_sops;
 	sb->s_xattr = kernfs_xattr_handlers;
 	if (info->root->flags & KERNFS_ROOT_SUPPORT_EXPORTOP)
@@ -257,21 +256,20 @@ static int kernfs_fill_super(struct super_block *sb, unsigned long magic)
 	return 0;
 }
 
-static int kernfs_test_super(struct super_block *sb, void *data)
+static int kernfs_test_super(struct super_block *sb, struct fs_context *fc)
 {
 	struct kernfs_super_info *sb_info = kernfs_info(sb);
-	struct kernfs_super_info *info = data;
+	struct kernfs_super_info *info = fc->s_fs_info;
 
 	return sb_info->root == info->root && sb_info->ns == info->ns;
 }
 
-static int kernfs_set_super(struct super_block *sb, void *data)
+static int kernfs_set_super(struct super_block *sb, struct fs_context *fc)
 {
-	int error;
-	error = set_anon_super(sb, data);
-	if (!error)
-		sb->s_fs_info = data;
-	return error;
+	struct kernfs_fs_context *kfc = fc->fs_private;
+
+	kfc->ns_tag = NULL;
+	return set_anon_super_fc(sb, fc);
 }
 
 /**
@@ -288,63 +286,60 @@ const void *kernfs_super_ns(struct super_block *sb)
 }
 
 /**
- * kernfs_mount_ns - kernfs mount helper
- * @fs_type: file_system_type of the fs being mounted
- * @flags: mount flags specified for the mount
- * @root: kernfs_root of the hierarchy being mounted
- * @magic: file system specific magic number
- * @new_sb_created: tell the caller if we allocated a new superblock
- * @ns: optional namespace tag of the mount
- *
- * This is to be called from each kernfs user's file_system_type->mount()
- * implementation, which should pass through the specified @fs_type and
- * @flags, and specify the hierarchy and namespace tag to mount via @root
- * and @ns, respectively.
+ * kernfs_get_tree - kernfs filesystem access/retrieval helper
+ * @fc: The filesystem context.
  *
- * The return value can be passed to the vfs layer verbatim.
+ * This is to be called from each kernfs user's fs_context->ops->get_tree()
+ * implementation, which should set the specified ->@fs_type and ->@flags, and
+ * specify the hierarchy and namespace tag to mount via ->@root and ->@ns,
+ * respectively.
  */
-struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
-				struct kernfs_root *root, unsigned long magic,
-				bool *new_sb_created, const void *ns)
+int kernfs_get_tree(struct fs_context *fc)
 {
+	struct kernfs_fs_context *kfc = fc->fs_private;
 	struct super_block *sb;
 	struct kernfs_super_info *info;
 	int error;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
-	info->root = root;
-	info->ns = ns;
+	info->root = kfc->root;
+	info->ns = kfc->ns_tag;
 	INIT_LIST_HEAD(&info->node);
 
-	sb = sget_userns(fs_type, kernfs_test_super, kernfs_set_super, flags,
-			 &init_user_ns, info);
-	if (IS_ERR(sb) || sb->s_fs_info != info)
-		kfree(info);
+	fc->s_fs_info = info;
+	sb = sget_fc(fc, kernfs_test_super, kernfs_set_super);
 	if (IS_ERR(sb))
-		return ERR_CAST(sb);
-
-	if (new_sb_created)
-		*new_sb_created = !sb->s_root;
+		return PTR_ERR(sb);
 
 	if (!sb->s_root) {
 		struct kernfs_super_info *info = kernfs_info(sb);
 
-		error = kernfs_fill_super(sb, magic);
+		kfc->new_sb_created = true;
+
+		error = kernfs_fill_super(sb, kfc);
 		if (error) {
 			deactivate_locked_super(sb);
-			return ERR_PTR(error);
+			return error;
 		}
 		sb->s_flags |= SB_ACTIVE;
 
 		mutex_lock(&kernfs_mutex);
-		list_add(&info->node, &root->supers);
+		list_add(&info->node, &info->root->supers);
 		mutex_unlock(&kernfs_mutex);
 	}
 
-	return dget(sb->s_root);
+	fc->root = dget(sb->s_root);
+	return 0;
+}
+
+void kernfs_free_fs_context(struct fs_context *fc)
+{
+	/* Note that we don't deal with kfc->ns_tag here. */
+	kfree(fc->s_fs_info);
+	fc->s_fs_info = NULL;
 }
 
 /**
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 77302c35b0ff..1e1c0ccc6a36 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -13,6 +13,7 @@
 #include <linux/magic.h>
 #include <linux/mount.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/user_namespace.h>
 
 #include "sysfs.h"
@@ -20,27 +21,55 @@
 static struct kernfs_root *sysfs_root;
 struct kernfs_node *sysfs_root_kn;
 
-static struct dentry *sysfs_mount(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, size_t data_size)
+static int sysfs_get_tree(struct fs_context *fc)
 {
-	struct dentry *root;
-	void *ns;
-	bool new_sb = false;
+	struct kernfs_fs_context *kfc = fc->fs_private;
+	int ret;
 
-	if (!(flags & SB_KERNMOUNT)) {
+	ret = kernfs_get_tree(fc);
+	if (ret)
+		return ret;
+
+	if (kfc->new_sb_created)
+		fc->root->d_sb->s_iflags |= SB_I_USERNS_VISIBLE;
+	return 0;
+}
+
+static void sysfs_fs_context_free(struct fs_context *fc)
+{
+	struct kernfs_fs_context *kfc = fc->fs_private;
+
+	if (kfc->ns_tag)
+		kobj_ns_drop(KOBJ_NS_TYPE_NET, kfc->ns_tag);
+	kernfs_free_fs_context(fc);
+	kfree(kfc);
+}
+
+static const struct fs_context_operations sysfs_fs_context_ops = {
+	.free		= sysfs_fs_context_free,
+	.get_tree	= sysfs_get_tree,
+};
+
+static int sysfs_init_fs_context(struct fs_context *fc,
+				 struct dentry *reference)
+{
+	struct kernfs_fs_context *kfc;
+
+	if (!(fc->sb_flags & SB_KERNMOUNT)) {
 		if (!kobj_ns_current_may_mount(KOBJ_NS_TYPE_NET))
-			return ERR_PTR(-EPERM);
+			return -EPERM;
 	}
 
-	ns = kobj_ns_grab_current(KOBJ_NS_TYPE_NET);
-	root = kernfs_mount_ns(fs_type, flags, sysfs_root,
-				SYSFS_MAGIC, &new_sb, ns);
-	if (!new_sb)
-		kobj_ns_drop(KOBJ_NS_TYPE_NET, ns);
-	else if (!IS_ERR(root))
-		root->d_sb->s_iflags |= SB_I_USERNS_VISIBLE;
+	kfc = kzalloc(sizeof(struct kernfs_fs_context), GFP_KERNEL);
+	if (!kfc)
+		return -ENOMEM;
 
-	return root;
+	kfc->ns_tag = kobj_ns_grab_current(KOBJ_NS_TYPE_NET);
+	kfc->root = sysfs_root;
+	kfc->magic = SYSFS_MAGIC;
+	fc->fs_private = kfc;
+	fc->ops = &sysfs_fs_context_ops;
+	return 0;
 }
 
 static void sysfs_kill_sb(struct super_block *sb)
@@ -52,10 +81,10 @@ static void sysfs_kill_sb(struct super_block *sb)
 }
 
 static struct file_system_type sysfs_fs_type = {
-	.name		= "sysfs",
-	.mount		= sysfs_mount,
-	.kill_sb	= sysfs_kill_sb,
-	.fs_flags	= FS_USERNS_MOUNT,
+	.name			= "sysfs",
+	.init_fs_context	= sysfs_init_fs_context,
+	.kill_sb		= sysfs_kill_sb,
+	.fs_flags		= FS_USERNS_MOUNT,
 };
 
 int __init sysfs_init(void)
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index c9fdf6f57913..ac198f0c466f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -829,10 +829,11 @@ copy_cgroup_ns(unsigned long flags, struct user_namespace *user_ns,
 
 #endif /* !CONFIG_CGROUPS */
 
-static inline void get_cgroup_ns(struct cgroup_namespace *ns)
+static inline struct cgroup_namespace *get_cgroup_ns(struct cgroup_namespace *ns)
 {
 	if (ns)
 		refcount_inc(&ns->count);
+	return ns;
 }
 
 static inline void put_cgroup_ns(struct cgroup_namespace *ns)
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index ab25c8b6d9e3..627fa3956146 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -16,6 +16,7 @@
 #include <linux/rbtree.h>
 #include <linux/atomic.h>
 #include <linux/wait.h>
+#include <linux/fs_context.h>
 
 struct file;
 struct dentry;
@@ -25,6 +26,7 @@ struct vm_area_struct;
 struct super_block;
 struct file_system_type;
 
+struct kernfs_fs_context;
 struct kernfs_open_node;
 struct kernfs_iattrs;
 
@@ -166,7 +168,7 @@ struct kernfs_node {
  * kernfs_node parameter.
  */
 struct kernfs_syscall_ops {
-	int (*remount_fs)(struct kernfs_root *root, int *flags, char *data);
+	int (*reconfigure)(struct kernfs_root *root, struct fs_context *fc);
 	int (*show_options)(struct seq_file *sf, struct kernfs_root *root);
 
 	int (*mkdir)(struct kernfs_node *parent, const char *name,
@@ -267,6 +269,18 @@ struct kernfs_ops {
 #endif
 };
 
+/*
+ * The kernfs superblock creation/mount parameter context.
+ */
+struct kernfs_fs_context {
+	struct kernfs_root	*root;		/* Root of the hierarchy being mounted */
+	void			*ns_tag;	/* Namespace tag of the mount (or NULL) */
+	unsigned long		magic;		/* File system specific magic number */
+
+	/* The following are set/used by kernfs_mount() */
+	bool			new_sb_created;	/* Set to T if we allocated a new sb */
+};
+
 #ifdef CONFIG_KERNFS
 
 static inline enum kernfs_node_type kernfs_type(struct kernfs_node *kn)
@@ -350,9 +364,8 @@ int kernfs_setattr(struct kernfs_node *kn, const struct iattr *iattr);
 void kernfs_notify(struct kernfs_node *kn);
 
 const void *kernfs_super_ns(struct super_block *sb);
-struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
-			       struct kernfs_root *root, unsigned long magic,
-			       bool *new_sb_created, const void *ns);
+int kernfs_get_tree(struct fs_context *fc);
+void kernfs_free_fs_context(struct fs_context *fc);
 void kernfs_kill_sb(struct super_block *sb);
 struct super_block *kernfs_pin_sb(struct kernfs_root *root, const void *ns);
 
@@ -454,11 +467,10 @@ static inline void kernfs_notify(struct kernfs_node *kn) { }
 static inline const void *kernfs_super_ns(struct super_block *sb)
 { return NULL; }
 
-static inline struct dentry *
-kernfs_mount_ns(struct file_system_type *fs_type, int flags,
-		struct kernfs_root *root, unsigned long magic,
-		bool *new_sb_created, const void *ns)
-{ return ERR_PTR(-ENOSYS); }
+static inline int kernfs_get_tree(struct fs_context *fc)
+{ return -ENOSYS; }
+
+static inline void kernfs_free_fs_context(struct fs_context *fc) { }
 
 static inline void kernfs_kill_sb(struct super_block *sb) { }
 
@@ -535,13 +547,4 @@ static inline int kernfs_rename(struct kernfs_node *kn,
 	return kernfs_rename_ns(kn, new_parent, new_name, NULL);
 }
 
-static inline struct dentry *
-kernfs_mount(struct file_system_type *fs_type, int flags,
-		struct kernfs_root *root, unsigned long magic,
-		bool *new_sb_created)
-{
-	return kernfs_mount_ns(fs_type, flags, root,
-				magic, new_sb_created, NULL);
-}
-
 #endif	/* __LINUX_KERNFS_H */
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 77ff1cd6a252..19da314b3405 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -8,6 +8,33 @@
 #include <linux/list.h>
 #include <linux/refcount.h>
 
+/*
+ * The cgroup filesystem superblock creation/mount context.
+ */
+struct cgroup_fs_context {
+	struct kernfs_fs_context kfc;
+	struct cgroup_root	*root;
+	struct cgroup_namespace	*ns;
+	u8		version;		/* cgroups version */
+	unsigned int	flags;			/* CGRP_ROOT_* flags */
+
+	/* cgroup1 bits */
+	bool		cpuset_clone_children;
+	bool		none;			/* User explicitly requested empty subsystem */
+	bool		all_ss;			/* Seen 'all' option */
+	bool		one_ss;			/* Seen 'none' option */
+	u16		subsys_mask;		/* Selected subsystems */
+	char		*name;			/* Hierarchy name */
+	char		*release_agent;		/* Path for release notifications */
+};
+
+static inline struct cgroup_fs_context *cgroup_fc2context(struct fs_context *fc)
+{
+	struct kernfs_fs_context *kfc = fc->fs_private;
+
+	return container_of(kfc, struct cgroup_fs_context, kfc);
+}
+
 /*
  * A cgroup can be associated with multiple css_sets as different tasks may
  * belong to different cgroups on different hierarchies.  In the other
@@ -89,16 +116,6 @@ struct cgroup_mgctx {
 #define DEFINE_CGROUP_MGCTX(name)						\
 	struct cgroup_mgctx name = CGROUP_MGCTX_INIT(name)
 
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
 extern struct mutex cgroup_mutex;
 extern spinlock_t css_set_lock;
 extern struct cgroup_subsys *cgroup_subsys[];
@@ -169,12 +186,10 @@ int cgroup_path_ns_locked(struct cgroup *cgrp, char *buf, size_t buflen,
 			  struct cgroup_namespace *ns);
 
 void cgroup_free_root(struct cgroup_root *root);
-void init_cgroup_root(struct cgroup_root *root, struct cgroup_sb_opts *opts);
+void init_cgroup_root(struct cgroup_fs_context *ctx);
 int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask, int ref_flags);
 int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask);
-struct dentry *cgroup_do_mount(struct file_system_type *fs_type, int flags,
-			       struct cgroup_root *root, unsigned long magic,
-			       struct cgroup_namespace *ns);
+int cgroup_do_get_tree(struct fs_context *fc);
 
 int cgroup_migrate_vet_dst(struct cgroup *dst_cgrp);
 void cgroup_migrate_finish(struct cgroup_mgctx *mgctx);
@@ -218,14 +233,15 @@ extern const struct proc_ns_operations cgroupns_operations;
  */
 extern struct cftype cgroup1_base_files[];
 extern struct kernfs_syscall_ops cgroup1_kf_syscall_ops;
+extern const struct fs_parameter_description cgroup1_fs_parameters;
 
 int proc_cgroupstats_show(struct seq_file *m, void *v);
 bool cgroup1_ssid_disabled(int ssid);
 void cgroup1_pidlist_destroy_all(struct cgroup *cgrp);
 void cgroup1_release_agent(struct work_struct *work);
 void cgroup1_check_for_release(struct cgroup *cgrp);
-struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
-			     void *data, unsigned long magic,
-			     struct cgroup_namespace *ns);
+int cgroup1_parse_param(struct fs_context *fc, struct fs_parameter *param);
+int cgroup1_validate(struct fs_context *fc);
+int cgroup1_get_tree(struct fs_context *fc);
 
 #endif /* __CGROUP_INTERNAL_H */
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 8b4f0768efd6..4238a89ca721 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -13,9 +13,12 @@
 #include <linux/delayacct.h>
 #include <linux/pid_namespace.h>
 #include <linux/cgroupstats.h>
+#include <linux/fs_parser.h>
 
 #include <trace/events/cgroup.h>
 
+#define cg_invalf(fc, fmt, ...) ({ pr_err(fmt, ## __VA_ARGS__); -EINVAL; })
+
 /*
  * pidlists linger the following amount before being destroyed.  The goal
  * is avoiding frequent destruction in the middle of consecutive read calls
@@ -903,92 +906,65 @@ static int cgroup1_show_options(struct seq_file *seq, struct kernfs_root *kf_roo
 	return 0;
 }
 
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
+enum cgroup1_param {
+	Opt_none,
+	Opt_all,
+	Opt_noprefix,
+	Opt_clone_children,
+	Opt_xattr,
+	Opt_release_agent,
+	Opt_name,
+	Opt_cpuset_v2_mode,
+	nr__cgroup1_params
+};
 
-	memset(opts, 0, sizeof(*opts));
+static const struct fs_parameter_spec cgroup1_param_specs[nr__cgroup1_params] = {
+	[Opt_all]		= { fs_param_takes_no_value },
+	[Opt_clone_children]	= { fs_param_takes_no_value },
+	[Opt_cpuset_v2_mode]	= { fs_param_takes_no_value },
+	[Opt_name]		= { fs_param_is_string },
+	[Opt_none]		= { fs_param_takes_no_value },
+	[Opt_noprefix]		= { fs_param_takes_no_value },
+	[Opt_release_agent]	= { fs_param_takes_no_value },
+	[Opt_xattr]		= { fs_param_takes_no_value },
+};
 
-	while ((token = strsep(&o, ",")) != NULL) {
-		nr_opts++;
+static const struct constant_table cgroup1_param_keys[] = {
+	{ "all",		Opt_all },
+	{ "clone_children",	Opt_clone_children },
+	{ "cpuset_v2_mode",	Opt_cpuset_v2_mode },
+	{ "name",		Opt_name },
+	{ "none",		Opt_none },
+	{ "noprefix",		Opt_noprefix },
+	{ "release_agent",	Opt_release_agent },
+	{ "xattr",		Opt_xattr },
+};
 
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
-		if (!strcmp(token, "cpuset_v2_mode")) {
-			opts->flags |= CGRP_ROOT_CPUSET_V2_MODE;
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
+const struct fs_parameter_description cgroup1_fs_parameters = {
+	.name		= "cgroup1",
+	.nr_params	= nr__cgroup1_params,
+	.nr_keys	= ARRAY_SIZE(cgroup1_param_keys),
+	.keys		= cgroup1_param_keys,
+	.specs		= cgroup1_param_specs,
+	.ignore_unknown	= true,
+	.no_source	= true,
+};
 
-			continue;
-		}
+int cgroup1_parse_param(struct fs_context *fc, struct fs_parameter *param)
+{
+	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
+	struct cgroup_subsys *ss;
+	struct fs_parse_result result;
+	int ret, i;
 
+	ret = fs_parse(fc, &cgroup1_fs_parameters, param, &result);
+	if (ret < 0)
+		return ret;
+	if (ret == 0) {
+		if (strcmp(param->key, "source") == 0)
+			return 0;
 		for_each_subsys(ss, i) {
-			if (strcmp(token, ss->legacy_name))
+			if (strcmp(param->key, ss->legacy_name) != 0)
 				continue;
 			if (!cgroup_ssid_enabled(i))
 				continue;
@@ -996,75 +972,142 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 				continue;
 
 			/* Mutually exclusive option 'all' + subsystem name */
-			if (all_ss)
-				return -EINVAL;
-			opts->subsys_mask |= (1 << i);
-			one_ss = true;
+			if (ctx->all_ss)
+				return cg_invalf(fc, "cgroup1: subsys name conflicts with all");
+			ctx->subsys_mask |= (1 << i);
+			ctx->one_ss = true;
+			return 0;
+		}
 
-			break;
+		return cg_invalf(fc, "cgroup1: Unknown subsys name '%s'", param->key);
+	}
+
+	switch (result.key) {
+	case Opt_none:
+		/* Explicitly have no subsystems */
+		ctx->none = true;
+		return 0;
+	case Opt_all:
+		/* Mutually exclusive option 'all' + subsystem name */
+		if (ctx->one_ss)
+			return cg_invalf(fc, "cgroup1: all conflicts with subsys name");
+		ctx->all_ss = true;
+		return 0;
+	case Opt_noprefix:
+		ctx->flags |= CGRP_ROOT_NOPREFIX;
+		return 0;
+	case Opt_clone_children:
+		ctx->cpuset_clone_children = true;
+		return 0;
+	case Opt_cpuset_v2_mode:
+		ctx->flags |= CGRP_ROOT_CPUSET_V2_MODE;
+		return 0;
+	case Opt_xattr:
+		ctx->flags |= CGRP_ROOT_XATTR;
+		return 0;
+	case Opt_release_agent:
+		/* Specifying two release agents is forbidden */
+		if (ctx->release_agent)
+			return cg_invalf(fc, "cgroup1: release_agent respecified");
+		ctx->release_agent = param->string;
+		param->string = NULL;
+		if (!ctx->release_agent)
+			return -ENOMEM;
+		return 0;
+
+	case Opt_name:
+		/* Can't specify an empty name */
+		if (!param->size)
+			return cg_invalf(fc, "cgroup1: Empty name");
+		if (param->size > MAX_CGROUP_ROOT_NAMELEN - 1)
+			return cg_invalf(fc, "cgroup1: Name too long");
+		/* Must match [\w.-]+ */
+		for (i = 0; i < param->size; i++) {
+			char c = param->string[i];
+			if (isalnum(c))
+				continue;
+			if ((c == '.') || (c == '-') || (c == '_'))
+				continue;
+			return cg_invalf(fc, "cgroup1: Invalid name");
 		}
-		if (i == CGROUP_SUBSYS_COUNT)
-			return -ENOENT;
+		/* Specifying two names is forbidden */
+		if (ctx->name)
+			return cg_invalf(fc, "cgroup1: name respecified");
+		ctx->name = param->string;
+		param->string = NULL;
+		return 0;
 	}
 
+	return 0;
+}
+
+/*
+ * Validate the options that have been parsed.
+ */
+int cgroup1_validate(struct fs_context *fc)
+{
+	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
+	struct cgroup_subsys *ss;
+	u16 mask = U16_MAX;
+	int i;
+
+#ifdef CONFIG_CPUSETS
+	mask = ~((u16)1 << cpuset_cgrp_id);
+#endif
+
 	/*
 	 * If the 'all' option was specified select all the subsystems,
 	 * otherwise if 'none', 'name=' and a subsystem name options were
 	 * not specified, let's default to 'all'
 	 */
-	if (all_ss || (!one_ss && !opts->none && !opts->name))
+	if (ctx->all_ss || (!ctx->one_ss && !ctx->none && !ctx->name))
 		for_each_subsys(ss, i)
 			if (cgroup_ssid_enabled(i) && !cgroup1_ssid_disabled(i))
-				opts->subsys_mask |= (1 << i);
+				ctx->subsys_mask |= (1 << i);
 
 	/*
 	 * We either have to specify by name or by subsystems. (So all
 	 * empty hierarchies must have a name).
 	 */
-	if (!opts->subsys_mask && !opts->name)
-		return -EINVAL;
+	if (!ctx->subsys_mask && !ctx->name)
+		return cg_invalf(fc, "cgroup1: Need name or subsystem set");
 
 	/*
 	 * Option noprefix was introduced just for backward compatibility
 	 * with the old cpuset, so we allow noprefix only if mounting just
 	 * the cpuset subsystem.
 	 */
-	if ((opts->flags & CGRP_ROOT_NOPREFIX) && (opts->subsys_mask & mask))
-		return -EINVAL;
+	if ((ctx->flags & CGRP_ROOT_NOPREFIX) && (ctx->subsys_mask & mask))
+		return cg_invalf(fc, "cgroup1: noprefix used incorrectly");
 
 	/* Can't specify "none" and some subsystems */
-	if (opts->subsys_mask && opts->none)
-		return -EINVAL;
+	if (ctx->subsys_mask && ctx->none)
+		return cg_invalf(fc, "cgroup1: none used incorrectly");
 
 	return 0;
 }
 
-static int cgroup1_remount(struct kernfs_root *kf_root, int *flags, char *data)
+static int cgroup1_reconfigure(struct kernfs_root *kf_root, struct fs_context *fc)
 {
-	int ret = 0;
+	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
 	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
-	struct cgroup_sb_opts opts;
 	u16 added_mask, removed_mask;
+	int ret = 0;
 
 	cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
 
-	/* See what subsystems are wanted */
-	ret = parse_cgroupfs_options(data, &opts);
-	if (ret)
-		goto out_unlock;
-
-	if (opts.subsys_mask != root->subsys_mask || opts.release_agent)
+	if (ctx->subsys_mask != root->subsys_mask || ctx->release_agent)
 		pr_warn("option changes via remount are deprecated (pid=%d comm=%s)\n",
 			task_tgid_nr(current), current->comm);
 
-	added_mask = opts.subsys_mask & ~root->subsys_mask;
-	removed_mask = root->subsys_mask & ~opts.subsys_mask;
+	added_mask = ctx->subsys_mask & ~root->subsys_mask;
+	removed_mask = root->subsys_mask & ~ctx->subsys_mask;
 
 	/* Don't allow flags or name to change at remount */
-	if ((opts.flags ^ root->flags) ||
-	    (opts.name && strcmp(opts.name, root->name))) {
-		pr_err("option or name mismatch, new: 0x%x \"%s\", old: 0x%x \"%s\"\n",
-		       opts.flags, opts.name ?: "", root->flags, root->name);
+	if ((ctx->flags ^ root->flags) ||
+	    (ctx->name && strcmp(ctx->name, root->name))) {
+		cg_invalf(fc, "option or name mismatch, new: 0x%x \"%s\", old: 0x%x \"%s\"",
+		       ctx->flags, ctx->name ?: "", root->flags, root->name);
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -1081,17 +1124,15 @@ static int cgroup1_remount(struct kernfs_root *kf_root, int *flags, char *data)
 
 	WARN_ON(rebind_subsystems(&cgrp_dfl_root, removed_mask));
 
-	if (opts.release_agent) {
+	if (ctx->release_agent) {
 		spin_lock(&release_agent_path_lock);
-		strcpy(root->release_agent_path, opts.release_agent);
+		strcpy(root->release_agent_path, ctx->release_agent);
 		spin_unlock(&release_agent_path_lock);
 	}
 
 	trace_cgroup_remount(root);
 
  out_unlock:
-	kfree(opts.release_agent);
-	kfree(opts.name);
 	mutex_unlock(&cgroup_mutex);
 	return ret;
 }
@@ -1099,31 +1140,26 @@ static int cgroup1_remount(struct kernfs_root *kf_root, int *flags, char *data)
 struct kernfs_syscall_ops cgroup1_kf_syscall_ops = {
 	.rename			= cgroup1_rename,
 	.show_options		= cgroup1_show_options,
-	.remount_fs		= cgroup1_remount,
+	.reconfigure		= cgroup1_reconfigure,
 	.mkdir			= cgroup_mkdir,
 	.rmdir			= cgroup_rmdir,
 	.show_path		= cgroup_show_path,
 };
 
-struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
-			     void *data, unsigned long magic,
-			     struct cgroup_namespace *ns)
+/*
+ * Find or create a v1 cgroups superblock.
+ */
+int cgroup1_get_tree(struct fs_context *fc)
 {
+	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
 	struct super_block *pinned_sb = NULL;
-	struct cgroup_sb_opts opts;
 	struct cgroup_root *root;
 	struct cgroup_subsys *ss;
-	struct dentry *dentry;
 	int i, ret;
 	bool new_root = false;
 
 	cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
 
-	/* First find the desired set of subsystems */
-	ret = parse_cgroupfs_options(data, &opts);
-	if (ret)
-		goto out_unlock;
-
 	/*
 	 * Destruction of cgroup root is asynchronous, so subsystems may
 	 * still be dying after the previous unmount.  Let's drain the
@@ -1132,15 +1168,13 @@ struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
 	 * starting.  Testing ref liveliness is good enough.
 	 */
 	for_each_subsys(ss, i) {
-		if (!(opts.subsys_mask & (1 << i)) ||
+		if (!(ctx->subsys_mask & (1 << i)) ||
 		    ss->root == &cgrp_dfl_root)
 			continue;
 
 		if (!percpu_ref_tryget_live(&ss->root->cgrp.self.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
-			msleep(10);
-			ret = restart_syscall();
-			goto out_free;
+			goto err_restart;
 		}
 		cgroup_put(&ss->root->cgrp);
 	}
@@ -1156,8 +1190,8 @@ struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
 		 * name matches but sybsys_mask doesn't, we should fail.
 		 * Remember whether name matched.
 		 */
-		if (opts.name) {
-			if (strcmp(opts.name, root->name))
+		if (ctx->name) {
+			if (strcmp(ctx->name, root->name))
 				continue;
 			name_match = true;
 		}
@@ -1166,15 +1200,15 @@ struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
 		 * If we asked for subsystems (or explicitly for no
 		 * subsystems) then they must match.
 		 */
-		if ((opts.subsys_mask || opts.none) &&
-		    (opts.subsys_mask != root->subsys_mask)) {
+		if ((ctx->subsys_mask || ctx->none) &&
+		    (ctx->subsys_mask != root->subsys_mask)) {
 			if (!name_match)
 				continue;
 			ret = -EBUSY;
-			goto out_unlock;
+			goto err_unlock;
 		}
 
-		if (root->flags ^ opts.flags)
+		if (root->flags ^ ctx->flags)
 			pr_warn("new mount options do not match the existing superblock, will be ignored\n");
 
 		/*
@@ -1195,11 +1229,10 @@ struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
 			mutex_unlock(&cgroup_mutex);
 			if (!IS_ERR_OR_NULL(pinned_sb))
 				deactivate_super(pinned_sb);
-			msleep(10);
-			ret = restart_syscall();
-			goto out_free;
+			goto err_restart;
 		}
 
+		ctx->root = root;
 		ret = 0;
 		goto out_unlock;
 	}
@@ -1209,41 +1242,35 @@ struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
 	 * specification is allowed for already existing hierarchies but we
 	 * can't create new one without subsys specification.
 	 */
-	if (!opts.subsys_mask && !opts.none) {
-		ret = -EINVAL;
-		goto out_unlock;
+	if (!ctx->subsys_mask && !ctx->none) {
+		ret = cg_invalf(fc, "cgroup1: No subsys list or none specified");
+		goto err_unlock;
 	}
 
 	/* Hierarchies may only be created in the initial cgroup namespace. */
-	if (ns != &init_cgroup_ns) {
+	if (ctx->ns != &init_cgroup_ns) {
 		ret = -EPERM;
-		goto out_unlock;
+		goto err_unlock;
 	}
 
 	root = kzalloc(sizeof(*root), GFP_KERNEL);
 	if (!root) {
 		ret = -ENOMEM;
-		goto out_unlock;
+		goto err_unlock;
 	}
 	new_root = true;
+	ctx->root = root;
 
-	init_cgroup_root(root, &opts);
+	init_cgroup_root(ctx);
 
-	ret = cgroup_setup_root(root, opts.subsys_mask, PERCPU_REF_INIT_DEAD);
+	ret = cgroup_setup_root(root, ctx->subsys_mask, PERCPU_REF_INIT_DEAD);
 	if (ret)
-		cgroup_free_root(root);
+		goto err_unlock;
 
 out_unlock:
 	mutex_unlock(&cgroup_mutex);
-out_free:
-	kfree(opts.release_agent);
-	kfree(opts.name);
-
-	if (ret)
-		return ERR_PTR(ret);
 
-	dentry = cgroup_do_mount(&cgroup_fs_type, flags, root,
-				 CGROUP_SUPER_MAGIC, ns);
+	ret = cgroup_do_get_tree(fc);
 
 	/*
 	 * There's a race window after we release cgroup_mutex and before
@@ -1256,6 +1283,7 @@ struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
 		percpu_ref_reinit(&root->cgrp.self.refcnt);
 		mutex_unlock(&cgroup_mutex);
 	}
+	cgroup_get(&root->cgrp);
 
 	/*
 	 * If @pinned_sb, we're reusing an existing root and holding an
@@ -1264,7 +1292,14 @@ struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
 	if (pinned_sb)
 		deactivate_super(pinned_sb);
 
-	return dentry;
+	return ret;
+
+err_restart:
+	msleep(10);
+	return restart_syscall();
+err_unlock:
+	mutex_unlock(&cgroup_mutex);
+	return ret;
 }
 
 static int __init cgroup1_wq_init(void)
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ddb1a60ae3c0..f3238f38d152 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -54,6 +54,7 @@
 #include <linux/proc_ns.h>
 #include <linux/nsproxy.h>
 #include <linux/file.h>
+#include <linux/fs_parser.h>
 #include <linux/sched/cputime.h>
 #include <net/sock.h>
 
@@ -1734,25 +1735,52 @@ int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
 	return len;
 }
 
-static int parse_cgroup_root_flags(char *data, unsigned int *root_flags)
-{
-	char *token;
+enum cgroup2_param {
+	Opt_nsdelegate,
+	nr__cgroup2_params
+};
 
-	*root_flags = 0;
+static const struct fs_parameter_spec cgroup2_param_specs[nr__cgroup2_params] = {
+	[Opt_nsdelegate]	= { fs_param_takes_no_value },
+};
 
-	if (!data)
-		return 0;
+static const struct constant_table cgroup2_param_keys[] = {
+	{ "nsdelegate",		Opt_nsdelegate },
+};
 
-	while ((token = strsep(&data, ",")) != NULL) {
-		if (!strcmp(token, "nsdelegate")) {
-			*root_flags |= CGRP_ROOT_NS_DELEGATE;
-			continue;
-		}
+static const struct fs_parameter_description cgroup2_fs_parameters = {
+	.name		= "cgroup2",
+	.nr_params	= nr__cgroup2_params,
+	.nr_keys	= ARRAY_SIZE(cgroup2_param_keys),
+	.keys		= cgroup2_param_keys,
+	.specs		= cgroup2_param_specs,
+	.no_source	= true,
+};
 
-		pr_err("cgroup2: unknown option \"%s\"\n", token);
-		return -EINVAL;
+static int cgroup2_parse_param(struct fs_context *fc, struct fs_parameter *param)
+{
+	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
+	struct fs_parse_result result;
+	int ret;
+
+	ret = fs_parse(fc, &cgroup2_fs_parameters, param, &result);
+	if (ret < 0)
+		return ret;
+
+	switch (result.key) {
+	case Opt_nsdelegate:
+		ctx->flags |= CGRP_ROOT_NS_DELEGATE;
+		return 0;
 	}
 
+	return -EINVAL;
+}
+
+static int cgroup_show_options(struct seq_file *seq, struct kernfs_root *kf_root)
+{
+	if (current->nsproxy->cgroup_ns == &init_cgroup_ns &&
+	    cgrp_dfl_root.flags & CGRP_ROOT_NS_DELEGATE)
+		seq_puts(seq, ",nsdelegate");
 	return 0;
 }
 
@@ -1766,23 +1794,11 @@ static void apply_cgroup_root_flags(unsigned int root_flags)
 	}
 }
 
-static int cgroup_show_options(struct seq_file *seq, struct kernfs_root *kf_root)
-{
-	if (cgrp_dfl_root.flags & CGRP_ROOT_NS_DELEGATE)
-		seq_puts(seq, ",nsdelegate");
-	return 0;
-}
-
-static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
+static int cgroup_reconfigure(struct kernfs_root *kf_root, struct fs_context *fc)
 {
-	unsigned int root_flags;
-	int ret;
-
-	ret = parse_cgroup_root_flags(data, &root_flags);
-	if (ret)
-		return ret;
+	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
 
-	apply_cgroup_root_flags(root_flags);
+	apply_cgroup_root_flags(ctx->flags);
 	return 0;
 }
 
@@ -1870,8 +1886,9 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	INIT_WORK(&cgrp->release_agent_work, cgroup1_release_agent);
 }
 
-void init_cgroup_root(struct cgroup_root *root, struct cgroup_sb_opts *opts)
+void init_cgroup_root(struct cgroup_fs_context *ctx)
 {
+	struct cgroup_root *root = ctx->root;
 	struct cgroup *cgrp = &root->cgrp;
 
 	INIT_LIST_HEAD(&root->root_list);
@@ -1880,12 +1897,12 @@ void init_cgroup_root(struct cgroup_root *root, struct cgroup_sb_opts *opts)
 	init_cgroup_housekeeping(cgrp);
 	idr_init(&root->cgroup_idr);
 
-	root->flags = opts->flags;
-	if (opts->release_agent)
-		strscpy(root->release_agent_path, opts->release_agent, PATH_MAX);
-	if (opts->name)
-		strscpy(root->name, opts->name, MAX_CGROUP_ROOT_NAMELEN);
-	if (opts->cpuset_clone_children)
+	root->flags = ctx->flags;
+	if (ctx->release_agent)
+		strscpy(root->release_agent_path, ctx->release_agent, PATH_MAX);
+	if (ctx->name)
+		strscpy(root->name, ctx->name, MAX_CGROUP_ROOT_NAMELEN);
+	if (ctx->cpuset_clone_children)
 		set_bit(CGRP_CPUSET_CLONE_CHILDREN, &root->cgrp.flags);
 }
 
@@ -1990,57 +2007,53 @@ int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask, int ref_flags)
 	return ret;
 }
 
-struct dentry *cgroup_do_mount(struct file_system_type *fs_type, int flags,
-			       struct cgroup_root *root, unsigned long magic,
-			       struct cgroup_namespace *ns)
+int cgroup_do_get_tree(struct fs_context *fc)
 {
-	struct dentry *dentry;
-	bool new_sb;
+	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
+	int ret;
 
-	dentry = kernfs_mount(fs_type, flags, root->kf_root, magic, &new_sb);
+	ctx->kfc.root = ctx->root->kf_root;
+
+	ret = kernfs_get_tree(fc);
+	if (ret < 0)
+		goto out_cgrp;
 
 	/*
 	 * In non-init cgroup namespace, instead of root cgroup's dentry,
 	 * we return the dentry corresponding to the cgroupns->root_cgrp.
 	 */
-	if (!IS_ERR(dentry) && ns != &init_cgroup_ns) {
+	if (ctx->ns != &init_cgroup_ns) {
 		struct dentry *nsdentry;
 		struct cgroup *cgrp;
 
 		mutex_lock(&cgroup_mutex);
 		spin_lock_irq(&css_set_lock);
 
-		cgrp = cset_cgroup_from_root(ns->root_cset, root);
+		cgrp = cset_cgroup_from_root(ctx->ns->root_cset, ctx->root);
 
 		spin_unlock_irq(&css_set_lock);
 		mutex_unlock(&cgroup_mutex);
 
-		nsdentry = kernfs_node_dentry(cgrp->kn, dentry->d_sb);
-		dput(dentry);
-		dentry = nsdentry;
+		nsdentry = kernfs_node_dentry(cgrp->kn, fc->root->d_sb);
+		if (IS_ERR(nsdentry))
+			return PTR_ERR(nsdentry);
+		dput(fc->root);
+		fc->root = nsdentry;
 	}
 
-	if (IS_ERR(dentry) || !new_sb)
-		cgroup_put(&root->cgrp);
+	ret = 0;
+	if (ctx->kfc.new_sb_created)
+		goto out_cgrp;
+	apply_cgroup_root_flags(ctx->flags);
+	return 0;
 
-	return dentry;
+out_cgrp:
+	return ret;
 }
 
-static struct dentry *cgroup_mount(struct file_system_type *fs_type,
-			 int flags, const char *unused_dev_name,
-			 void *data, size_t data_size)
+static int cgroup_get_tree(struct fs_context *fc)
 {
-	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
-	struct dentry *dentry;
-	int ret;
-
-	get_cgroup_ns(ns);
-
-	/* Check if the caller has permission to mount. */
-	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN)) {
-		put_cgroup_ns(ns);
-		return ERR_PTR(-EPERM);
-	}
+	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
 
 	/*
 	 * The first time anyone tries to mount a cgroup, enable the list
@@ -2049,29 +2062,87 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	if (!use_task_css_set_links)
 		cgroup_enable_task_cg_lists();
 
-	if (fs_type == &cgroup2_fs_type) {
-		unsigned int root_flags;
-
-		ret = parse_cgroup_root_flags(data, &root_flags);
-		if (ret) {
-			put_cgroup_ns(ns);
-			return ERR_PTR(ret);
-		}
+	switch (ctx->version) {
+	case 1:
+		return cgroup1_get_tree(fc);
 
+	case 2:
 		cgrp_dfl_visible = true;
 		cgroup_get_live(&cgrp_dfl_root.cgrp);
 
-		dentry = cgroup_do_mount(&cgroup2_fs_type, flags, &cgrp_dfl_root,
-					 CGROUP2_SUPER_MAGIC, ns);
-		if (!IS_ERR(dentry))
-			apply_cgroup_root_flags(root_flags);
-	} else {
-		dentry = cgroup1_mount(&cgroup_fs_type, flags, data,
-				       CGROUP_SUPER_MAGIC, ns);
+		ctx->root = &cgrp_dfl_root;
+		return cgroup_do_get_tree(fc);
+
+	default:
+		BUG();
 	}
+}
+
+static int cgroup_parse_param(struct fs_context *fc, struct fs_parameter *param)
+{
+	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
+
+	if (ctx->version == 1)
+		return cgroup1_parse_param(fc, param);
+
+	return cgroup2_parse_param(fc, param);
+}
+
+static int cgroup_validate(struct fs_context *fc)
+{
+	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
+
+	if (ctx->version == 1)
+		return cgroup1_validate(fc);
+	return 0;
+}
 
-	put_cgroup_ns(ns);
-	return dentry;
+/*
+ * Destroy a cgroup filesystem context.
+ */
+static void cgroup_fs_context_free(struct fs_context *fc)
+{
+	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
+
+	kfree(ctx->name);
+	kfree(ctx->release_agent);
+	if (ctx->root)
+		cgroup_put(&ctx->root->cgrp);
+	put_cgroup_ns(ctx->ns);
+	kernfs_free_fs_context(fc);
+	kfree(ctx);
+}
+
+static const struct fs_context_operations cgroup_fs_context_ops = {
+	.free		= cgroup_fs_context_free,
+	.parse_param	= cgroup_parse_param,
+	.validate	= cgroup_validate,
+	.get_tree	= cgroup_get_tree,
+};
+
+/*
+ * Initialise the cgroup filesystem creation/reconfiguration context.  Notably,
+ * we select the namespace we're going to use.
+ */
+static int cgroup_init_fs_context(struct fs_context *fc, struct dentry *reference)
+{
+	struct cgroup_fs_context *ctx;
+	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
+
+	/* Check if the caller has permission to mount. */
+	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ctx = kzalloc(sizeof(struct cgroup_fs_context), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->ns = get_cgroup_ns(ns);
+	ctx->version = (fc->fs_type == &cgroup2_fs_type) ? 2 : 1;
+	ctx->kfc.magic = (ctx->version == 2) ? CGROUP2_SUPER_MAGIC : CGROUP_SUPER_MAGIC;
+	fc->fs_private = &ctx->kfc;
+	fc->ops = &cgroup_fs_context_ops;
+	return 0;
 }
 
 static void cgroup_kill_sb(struct super_block *sb)
@@ -2096,17 +2167,19 @@ static void cgroup_kill_sb(struct super_block *sb)
 }
 
 struct file_system_type cgroup_fs_type = {
-	.name = "cgroup",
-	.mount = cgroup_mount,
-	.kill_sb = cgroup_kill_sb,
-	.fs_flags = FS_USERNS_MOUNT,
+	.name			= "cgroup",
+	.init_fs_context	= cgroup_init_fs_context,
+	.parameters		= &cgroup1_fs_parameters,
+	.kill_sb		= cgroup_kill_sb,
+	.fs_flags		= FS_USERNS_MOUNT,
 };
 
 static struct file_system_type cgroup2_fs_type = {
-	.name = "cgroup2",
-	.mount = cgroup_mount,
-	.kill_sb = cgroup_kill_sb,
-	.fs_flags = FS_USERNS_MOUNT,
+	.name			= "cgroup2",
+	.init_fs_context	= cgroup_init_fs_context,
+	.parameters		= &cgroup2_fs_parameters,
+	.kill_sb		= cgroup_kill_sb,
+	.fs_flags		= FS_USERNS_MOUNT,
 };
 
 int cgroup_path_ns_locked(struct cgroup *cgrp, char *buf, size_t buflen,
@@ -5175,7 +5248,7 @@ int cgroup_rmdir(struct kernfs_node *kn)
 
 static struct kernfs_syscall_ops cgroup_kf_syscall_ops = {
 	.show_options		= cgroup_show_options,
-	.remount_fs		= cgroup_remount,
+	.reconfigure		= cgroup_reconfigure,
 	.mkdir			= cgroup_mkdir,
 	.rmdir			= cgroup_rmdir,
 	.show_path		= cgroup_show_path,
@@ -5242,11 +5315,12 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
  */
 int __init cgroup_init_early(void)
 {
-	static struct cgroup_sb_opts __initdata opts;
+	static struct cgroup_fs_context __initdata ctx;
 	struct cgroup_subsys *ss;
 	int i;
 
-	init_cgroup_root(&cgrp_dfl_root, &opts);
+	ctx.root = &cgrp_dfl_root;
+	init_cgroup_root(&ctx);
 	cgrp_dfl_root.cgrp.self.flags |= CSS_NO_REF;
 
 	RCU_INIT_POINTER(init_task.cgroups, &init_css_set);
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index e6582b2f5144..b02161a41d5a 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -324,10 +324,8 @@ static int cpuset_get_tree(struct fs_context *fc)
 	int ret = -ENODEV;
 
 	cgroup_fs = get_fs_type("cgroup");
-	if (cgroup_fs) {
-		ret = PTR_ERR(cgroup_fs);
+	if (!cgroup_fs)
 		goto out;
-	}
 
 	cg_fc = vfs_new_fs_context(cgroup_fs, NULL, fc->sb_flags, fc->purpose);
 	put_filesystem(cgroup_fs);

