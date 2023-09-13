From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 15/19] kernfs: split ->kill_sb
Date: Wed, 13 Sep 2023 08:10:09 -0300
Message-ID: <20230913111013.77623-16-hch@lst.de>
References: <20230913111013.77623-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=jn5ICPS6Cu3mMpYD0UB1kTuR5uyOOiABwMdLvnOtIfU=; b=I3scjSHfsBsZKX4zg8bnuhQHsb
        L3D0sDT6s/4yq5F4to0o72PLjQG35an4Sv/o+6kBl3zPhQizwvxc1Vv94bX/s1vxKz63No7hqVkKI
        gWJbhENB7ONGbyTxRi9Gv1DEh0gDvIcWJHRwu1P6rs8npYTuo1UIXBtLZ38Wlebq+1FFq9+VHM7Az
        +jae9GXG1lqZMs+ZGJwbbUVJ6q5h0hnWc4XzoeXLC5wu+H2D0ovks788KuWtl7gm8n1P4Sxc2UGSY
        8bLx9Xo2rlm7RGXwKDt0MFo2pkmo0JFDXTAIdQjuxgPocFwF+Sc8uVwpnbl8kZpZdL5Yj8yjzaPQK
        g2rznLfA==;
In-Reply-To: <20230913111013.77623-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Split the kernfs_kill_sb helper into helpers for the new split
shutdown_sb and free_sb methods.  Note that resctrl has very odd
locking in ->kill_sb, so this commit only releases the locking
acquired in rdt_shutdown_sb in rdt_free_sb.  This is not very good
code and relies on ->shutdown_sb and ->free_sb to always be called
in pairs, which it currently is.  The next commit will try to clean
this up.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 12 +++++++++---
 fs/kernfs/mount.c                      | 18 ++++++++----------
 fs/sysfs/mount.c                       |  7 ++++---
 include/linux/kernfs.h                 |  5 ++---
 kernel/cgroup/cgroup.c                 | 10 ++++++----
 5 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 725344048f85da..8db767fd80df6b 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2772,7 +2772,7 @@ static void rmdir_all_sub(void)
 	kernfs_remove(kn_mondata);
 }
 
-static void rdt_kill_sb(struct super_block *sb)
+static void rdt_shutdown_sb(struct super_block *sb)
 {
 	struct rdt_resource *r;
 
@@ -2792,7 +2792,12 @@ static void rdt_kill_sb(struct super_block *sb)
 	static_branch_disable_cpuslocked(&rdt_alloc_enable_key);
 	static_branch_disable_cpuslocked(&rdt_mon_enable_key);
 	static_branch_disable_cpuslocked(&rdt_enable_key);
-	kernfs_kill_sb(sb);
+	kernfs_shutdown_sb(sb);
+}
+
+static void rdt_free_sb(struct super_block *sb)
+{
+	kernfs_free_sb(sb);
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
 }
@@ -2801,7 +2806,8 @@ static struct file_system_type rdt_fs_type = {
 	.name			= "resctrl",
 	.init_fs_context	= rdt_init_fs_context,
 	.parameters		= rdt_fs_parameters,
-	.kill_sb		= rdt_kill_sb,
+	.shutdown_sb		= rdt_shutdown_sb,
+	.free_sb		= rdt_free_sb,
 };
 
 static int mon_addfile(struct kernfs_node *parent_kn, const char *name,
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index d6d3cba669dbdd..32ec4ec3c878f6 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -379,14 +379,14 @@ void kernfs_free_fs_context(struct fs_context *fc)
 }
 
 /**
- * kernfs_kill_sb - kill_sb for kernfs
+ * kernfs_shutdown_sb - shutdown_sb for kernfs
  * @sb: super_block being killed
  *
- * This can be used directly for file_system_type->kill_sb().  If a kernfs
- * user needs extra cleanup, it can implement its own kill_sb() and call
+ * This can be used directly for file_system_type->shutdown_sb().  If a kernfs
+ * user needs extra cleanup, it can implement its own shutdown_sb() and call
  * this function at the end.
  */
-void kernfs_kill_sb(struct super_block *sb)
+void kernfs_shutdown_sb(struct super_block *sb)
 {
 	struct kernfs_super_info *info = kernfs_info(sb);
 	struct kernfs_root *root = info->root;
@@ -394,13 +394,11 @@ void kernfs_kill_sb(struct super_block *sb)
 	down_write(&root->kernfs_supers_rwsem);
 	list_del(&info->node);
 	up_write(&root->kernfs_supers_rwsem);
+}
 
-	/*
-	 * Remove the superblock from fs_supers/s_instances
-	 * so we can't find it, before freeing kernfs_super_info.
-	 */
-	generic_shutdown_super(sb);
-	kfree(info);
+void kernfs_free_sb(struct super_block *sb)
+{
+	kfree(kernfs_info(sb));
 }
 
 static void __init kernfs_mutex_init(void)
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 98467bb7673781..804391342599bc 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -79,18 +79,19 @@ static int sysfs_init_fs_context(struct fs_context *fc)
 	return 0;
 }
 
-static void sysfs_kill_sb(struct super_block *sb)
+static void sysfs_free_sb(struct super_block *sb)
 {
 	void *ns = (void *)kernfs_super_ns(sb);
 
-	kernfs_kill_sb(sb);
+	kernfs_free_sb(sb);
 	kobj_ns_drop(KOBJ_NS_TYPE_NET, ns);
 }
 
 static struct file_system_type sysfs_fs_type = {
 	.name			= "sysfs",
 	.init_fs_context	= sysfs_init_fs_context,
-	.kill_sb		= sysfs_kill_sb,
+	.shutdown_sb		= kernfs_shutdown_sb,
+	.free_sb		= sysfs_free_sb,
 	.fs_flags		= FS_USERNS_MOUNT,
 };
 
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 2a36f3218b5106..940059251deac8 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -453,7 +453,8 @@ int kernfs_xattr_set(struct kernfs_node *kn, const char *name,
 const void *kernfs_super_ns(struct super_block *sb);
 int kernfs_get_tree(struct fs_context *fc);
 void kernfs_free_fs_context(struct fs_context *fc);
-void kernfs_kill_sb(struct super_block *sb);
+void kernfs_shutdown_sb(struct super_block *sb);
+void kernfs_free_sb(struct super_block *sb);
 
 void kernfs_init(void);
 
@@ -572,8 +573,6 @@ static inline int kernfs_get_tree(struct fs_context *fc)
 
 static inline void kernfs_free_fs_context(struct fs_context *fc) { }
 
-static inline void kernfs_kill_sb(struct super_block *sb) { }
-
 static inline void kernfs_init(void) { }
 
 #endif	/* CONFIG_KERNFS */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1fb7f562289d53..a6c5e6ed1b6e2d 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2249,7 +2249,7 @@ static int cgroup_init_fs_context(struct fs_context *fc)
 	return 0;
 }
 
-static void cgroup_kill_sb(struct super_block *sb)
+static void cgroup_shutdown_sb(struct super_block *sb)
 {
 	struct kernfs_root *kf_root = kernfs_root_from_sb(sb);
 	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
@@ -2266,14 +2266,15 @@ static void cgroup_kill_sb(struct super_block *sb)
 		percpu_ref_kill(&root->cgrp.self.refcnt);
 	}
 	cgroup_put(&root->cgrp);
-	kernfs_kill_sb(sb);
+	kernfs_shutdown_sb(sb);
 }
 
 struct file_system_type cgroup_fs_type = {
 	.name			= "cgroup",
 	.init_fs_context	= cgroup_init_fs_context,
 	.parameters		= cgroup1_fs_parameters,
-	.kill_sb		= cgroup_kill_sb,
+	.shutdown_sb		= cgroup_shutdown_sb,
+	.free_sb		= kernfs_free_sb,
 	.fs_flags		= FS_USERNS_MOUNT,
 };
 
@@ -2281,7 +2282,8 @@ static struct file_system_type cgroup2_fs_type = {
 	.name			= "cgroup2",
 	.init_fs_context	= cgroup_init_fs_context,
 	.parameters		= cgroup2_fs_parameters,
-	.kill_sb		= cgroup_kill_sb,
+	.shutdown_sb		= cgroup_shutdown_sb,
+	.free_sb		= kernfs_free_sb,
 	.fs_flags		= FS_USERNS_MOUNT,
 };
 
-- 
2.39.2

