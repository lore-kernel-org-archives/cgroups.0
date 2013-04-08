From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/8] cgroup: implement cgroup_from_id()
Date: Mon, 8 Apr 2013 16:20:59 +0800
Message-ID: <51627DEB.4090104@huawei.com>
References: <51627DA9.7020507@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51627DA9.7020507-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

This will be used as a replacement for css_lookup().

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h |  1 +
 kernel/cgroup.c        | 31 +++++++++++++++++++++++++------
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 96072e4..6ae8ae1 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -732,6 +732,7 @@ unsigned short css_depth(struct cgroup_subsys_state *css);
 struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id);
 
 bool cgroup_is_ancestor(struct cgroup *child, struct cgroup *root);
+struct cgroup *cgroup_from_id(struct cgroup_subsys *ss, int id);
 
 #else /* !CONFIG_CGROUPS */
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e87872c..5ae1e87 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -139,7 +139,7 @@ struct cgroupfs_root {
 	unsigned long flags;
 
 	/* IDs for cgroups in this hierarchy */
-	struct ida cgroup_ida;
+	struct idr cgroup_idr;
 
 	/* The path to use for release notifications. */
 	char release_agent_path[PATH_MAX];
@@ -908,7 +908,7 @@ static void cgroup_free_fn(struct work_struct *work)
 
 	simple_xattrs_free(&cgrp->xattrs);
 
-	ida_simple_remove(&cgrp->root->cgroup_ida, cgrp->id);
+	idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
 	kfree(rcu_dereference_raw(cgrp->name));
 	kfree(cgrp);
 }
@@ -1512,7 +1512,8 @@ static struct cgroupfs_root *cgroup_root_from_opts(struct cgroup_sb_opts *opts)
 
 	root->subsys_mask = opts->subsys_mask;
 	root->flags = opts->flags;
-	ida_init(&root->cgroup_ida);
+	idr_init(&root->cgroup_idr);
+
 	if (opts->release_agent)
 		strcpy(root->release_agent_path, opts->release_agent);
 	if (opts->name)
@@ -1531,7 +1532,7 @@ static void cgroup_drop_root(struct cgroupfs_root *root)
 	spin_lock(&hierarchy_id_lock);
 	ida_remove(&hierarchy_ida, root->hierarchy_id);
 	spin_unlock(&hierarchy_id_lock);
-	ida_destroy(&root->cgroup_ida);
+	idr_destroy(&root->cgroup_idr);
 	kfree(root);
 }
 
@@ -1645,6 +1646,11 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		mutex_lock(&cgroup_mutex);
 		mutex_lock(&cgroup_root_mutex);
 
+		root_cgrp->id = idr_alloc(&root->cgroup_idr, root_cgrp,
+					  0, 0, GFP_KERNEL);
+		if (root_cgrp->id < 0)
+			goto unlock_drop;
+
 		/* Check for name clashes with existing mounts */
 		ret = -EBUSY;
 		if (strlen(root->name))
@@ -4104,7 +4110,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 		goto err_free_cgrp;
 	rcu_assign_pointer(cgrp->name, name);
 
-	cgrp->id = ida_simple_get(&root->cgroup_ida, 1, 0, GFP_KERNEL);
+	cgrp->id = idr_alloc(&root->cgroup_idr, cgrp, 1, 0, GFP_KERNEL);
 	if (cgrp->id < 0)
 		goto err_free_name;
 
@@ -4215,7 +4221,7 @@ err_free_all:
 	/* Release the reference count that we took on the superblock */
 	deactivate_super(sb);
 err_free_id:
-	ida_simple_remove(&root->cgroup_ida, cgrp->id);
+	idr_remove(&root->cgroup_idr, cgrp->id);
 err_free_name:
 	kfree(rcu_dereference_raw(cgrp->name));
 err_free_cgrp:
@@ -5320,6 +5326,19 @@ bool cgroup_is_ancestor(struct cgroup *child, struct cgroup *root)
 	return (child == root);
 }
 
+/**
+ * cgroup_from_id - lookup cgroup by id
+ * @ss: cgroup subsys to be looked into.
+ * @id: the id
+ *
+ * Returns pointer to cgroup if there is valid one with id.
+ * NULL if not. Should be called under rcu_read_lock()
+ */
+struct cgroup *cgroup_from_id(struct cgroup_subsys *ss, int id)
+{
+	return idr_find(&ss->root->cgroup_idr, id);
+}
+
 #ifdef CONFIG_CGROUP_DEBUG
 static struct cgroup_subsys_state *debug_css_alloc(struct cgroup *cont)
 {
-- 
1.8.0.2
