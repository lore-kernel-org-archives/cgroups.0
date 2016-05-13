From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup fixes for v4.6-rc7
Date: Fri, 13 May 2016 17:35:15 -0400
Message-ID: <20160513213515.GQ7110@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=xZkXFrt3IIIjvIs/1G2KTj6RDsyTY5wdGeCulPcHn8o=;
        b=twRnxY7ZRj5JcrKPpqBgBs7ug13OfrZIy0SE+VAuBiXz/nK3aqf53FcKr3fvk7AMb7
         C8KyKLA3KVhzrjUqpSitYo71VgCTQYHv1a4fD1FodG/9pfyxldIh7mH5zukMV55dy2qf
         DgzyccvwWg+2Wm0bci5u7TtOn1CzKmSRVnkE0WU2xRQw9YPdLAduvhU+wet5Ohs84Yqn
         uviHS1/gQIyFY4REA0rMUtcF9n4H1fda/e8XEvfJoUVNsTlX6EUfnA37DpivKVOCsli2
         lH5NSQV/6GILJm2ClFbXd6nbhwmaq4dwrXGwV2GCg1AiOpLAfKG9mlDCXCrXUILbsRpp
         6ZHg==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Serge Hallyn <serge.hallyn@ubuntu.com>

Hello, Linus.

During v4.6-rc1 cgroup namespace support was merged.  There is an
issue where it's impossible to tell whether a given cgroup mount point
is bind mounted or namespaced.  Serge has been working on the issue
but it took longer than expected to resolve, so the late pull request.

Given that it's a completely new feature and the patches don't touch
anything else, the risk seems acceptable.  However, if this is too
late, an alternative is plugging new cgroup ns creation for v4.6 and
retrying for v4.7.

Thanks.

The following changes since commit 264a0ae164bc0e9144bebcd25ff030d067b1a878:

  memcg: relocate charge moving from ->attach to ->post_attach (2016-04-25 15:45:14 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.6-fixes

for you to fetch changes up to 09be4c824ebdbf3c043a07d2d9537a0164a1ecfe:

  cgroup: fix compile warning (2016-05-12 11:05:27 -0400)

----------------------------------------------------------------
Felipe Balbi (1):
      cgroup: fix compile warning

Serge E. Hallyn (2):
      cgroup, kernfs: make mountinfo show properly scoped path for cgroup namespaces
      kernfs: kernfs_sop_show_path: don't return 0 after seq_dentry call

Serge Hallyn (1):
      kernfs_path_from_node_locked: don't overwrite nlen

 fs/kernfs/dir.c        |  6 ++---
 fs/kernfs/mount.c      | 15 ++++++++++++
 include/linux/kernfs.h |  2 ++
 kernel/cgroup.c        | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 83 insertions(+), 3 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 03b688d..37f9678 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -153,9 +153,9 @@ static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
 	p = buf + len + nlen;
 	*p = '\0';
 	for (kn = kn_to; kn != common; kn = kn->parent) {
-		nlen = strlen(kn->name);
-		p -= nlen;
-		memcpy(p, kn->name, nlen);
+		size_t tmp = strlen(kn->name);
+		p -= tmp;
+		memcpy(p, kn->name, tmp);
 		*(--p) = '/';
 	}
 
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index f73541f..3d670a3 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/pagemap.h>
 #include <linux/namei.h>
+#include <linux/seq_file.h>
 
 #include "kernfs-internal.h"
 
@@ -40,6 +41,19 @@ static int kernfs_sop_show_options(struct seq_file *sf, struct dentry *dentry)
 	return 0;
 }
 
+static int kernfs_sop_show_path(struct seq_file *sf, struct dentry *dentry)
+{
+	struct kernfs_node *node = dentry->d_fsdata;
+	struct kernfs_root *root = kernfs_root(node);
+	struct kernfs_syscall_ops *scops = root->syscall_ops;
+
+	if (scops && scops->show_path)
+		return scops->show_path(sf, node, root);
+
+	seq_dentry(sf, dentry, " \t\n\\");
+	return 0;
+}
+
 const struct super_operations kernfs_sops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
@@ -47,6 +61,7 @@ const struct super_operations kernfs_sops = {
 
 	.remount_fs	= kernfs_sop_remount_fs,
 	.show_options	= kernfs_sop_show_options,
+	.show_path	= kernfs_sop_show_path,
 };
 
 /**
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index c06c442..30f089e 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -152,6 +152,8 @@ struct kernfs_syscall_ops {
 	int (*rmdir)(struct kernfs_node *kn);
 	int (*rename)(struct kernfs_node *kn, struct kernfs_node *new_parent,
 		      const char *new_name);
+	int (*show_path)(struct seq_file *sf, struct kernfs_node *kn,
+			 struct kernfs_root *root);
 };
 
 struct kernfs_root {
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 909a7d3..86cb5c6 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1215,6 +1215,41 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 	cgroup_free_root(root);
 }
 
+/*
+ * look up cgroup associated with current task's cgroup namespace on the
+ * specified hierarchy
+ */
+static struct cgroup *
+current_cgns_cgroup_from_root(struct cgroup_root *root)
+{
+	struct cgroup *res = NULL;
+	struct css_set *cset;
+
+	lockdep_assert_held(&css_set_lock);
+
+	rcu_read_lock();
+
+	cset = current->nsproxy->cgroup_ns->root_cset;
+	if (cset == &init_css_set) {
+		res = &root->cgrp;
+	} else {
+		struct cgrp_cset_link *link;
+
+		list_for_each_entry(link, &cset->cgrp_links, cgrp_link) {
+			struct cgroup *c = link->cgrp;
+
+			if (c->root == root) {
+				res = c;
+				break;
+			}
+		}
+	}
+	rcu_read_unlock();
+
+	BUG_ON(!res);
+	return res;
+}
+
 /* look up cgroup associated with given css_set on the specified hierarchy */
 static struct cgroup *cset_cgroup_from_root(struct css_set *cset,
 					    struct cgroup_root *root)
@@ -1593,6 +1628,33 @@ static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 	return 0;
 }
 
+static int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
+			    struct kernfs_root *kf_root)
+{
+	int len = 0;
+	char *buf = NULL;
+	struct cgroup_root *kf_cgroot = cgroup_root_from_kf(kf_root);
+	struct cgroup *ns_cgroup;
+
+	buf = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	spin_lock_bh(&css_set_lock);
+	ns_cgroup = current_cgns_cgroup_from_root(kf_cgroot);
+	len = kernfs_path_from_node(kf_node, ns_cgroup->kn, buf, PATH_MAX);
+	spin_unlock_bh(&css_set_lock);
+
+	if (len >= PATH_MAX)
+		len = -ERANGE;
+	else if (len > 0) {
+		seq_escape(sf, buf, " \t\n\\");
+		len = 0;
+	}
+	kfree(buf);
+	return len;
+}
+
 static int cgroup_show_options(struct seq_file *seq,
 			       struct kernfs_root *kf_root)
 {
@@ -5433,6 +5495,7 @@ static struct kernfs_syscall_ops cgroup_kf_syscall_ops = {
 	.mkdir			= cgroup_mkdir,
 	.rmdir			= cgroup_rmdir,
 	.rename			= cgroup_rename,
+	.show_path		= cgroup_show_path,
 };
 
 static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
