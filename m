From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 1/8] cgroup: convert cgroup_ida to cgroup_idr
Date: Mon, 29 Jul 2013 15:07:48 +0800
Message-ID: <51F614C4.7060602@huawei.com>
References: <51F614B2.6010503@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51F614B2.6010503-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

This enables us to lookup a cgroup by its id.

v3:
- on success, idr_alloc() returns the id but not 0, so fix the BUG_ON()
  in cgroup_init().
- pass the right value to idr_alloc() so that the id for dummy cgroup is 0.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 include/linux/cgroup.h |  4 ++--
 kernel/cgroup.c        | 28 ++++++++++++++++++++++------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 297462b..2bd052d 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -161,7 +161,7 @@ struct cgroup_name {
 struct cgroup {
 	unsigned long flags;		/* "unsigned long" so bitops work */
 
-	int id;				/* ida allocated in-hierarchy ID */
+	int id;				/* idr allocated in-hierarchy ID */
 
 	/*
 	 * We link our 'sibling' struct into our parent's 'children'.
@@ -322,7 +322,7 @@ struct cgroupfs_root {
 	unsigned long flags;
 
 	/* IDs for cgroups in this hierarchy */
-	struct ida cgroup_ida;
+	struct idr cgroup_idr;
 
 	/* The path to use for release notifications. */
 	char release_agent_path[PATH_MAX];
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 345fac8..b7c7c68 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -866,8 +866,6 @@ static void cgroup_free_fn(struct work_struct *work)
 	 */
 	dput(cgrp->parent->dentry);
 
-	ida_simple_remove(&cgrp->root->cgroup_ida, cgrp->id);
-
 	/*
 	 * Drop the active superblock reference that we took when we
 	 * created the cgroup. This will free cgrp->root, if we are
@@ -1379,6 +1377,7 @@ static void init_cgroup_root(struct cgroupfs_root *root)
 	cgrp->root = root;
 	RCU_INIT_POINTER(cgrp->name, &root_cgroup_name);
 	init_cgroup_housekeeping(cgrp);
+	idr_init(&root->cgroup_idr);
 }
 
 static int cgroup_init_root_id(struct cgroupfs_root *root, int start, int end)
@@ -1451,7 +1450,6 @@ static struct cgroupfs_root *cgroup_root_from_opts(struct cgroup_sb_opts *opts)
 	 */
 	root->subsys_mask = opts->subsys_mask;
 	root->flags = opts->flags;
-	ida_init(&root->cgroup_ida);
 	if (opts->release_agent)
 		strcpy(root->release_agent_path, opts->release_agent);
 	if (opts->name)
@@ -1467,7 +1465,7 @@ static void cgroup_free_root(struct cgroupfs_root *root)
 		/* hierarhcy ID shoulid already have been released */
 		WARN_ON_ONCE(root->hierarchy_id);
 
-		ida_destroy(&root->cgroup_ida);
+		idr_destroy(&root->cgroup_idr);
 		kfree(root);
 	}
 }
@@ -1582,6 +1580,11 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		mutex_lock(&cgroup_mutex);
 		mutex_lock(&cgroup_root_mutex);
 
+		root_cgrp->id = idr_alloc(&root->cgroup_idr, root_cgrp,
+					   0, 1, GFP_KERNEL);
+		if (root_cgrp->id < 0)
+			goto unlock_drop;
+
 		/* Check for name clashes with existing mounts */
 		ret = -EBUSY;
 		if (strlen(root->name))
@@ -4273,7 +4276,11 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 		goto err_free_cgrp;
 	rcu_assign_pointer(cgrp->name, name);
 
-	cgrp->id = ida_simple_get(&root->cgroup_ida, 1, 0, GFP_KERNEL);
+	/*
+	 * Temporarily set the pointer to NULL, so idr_find() won't return
+	 * a half-baked cgroup.
+	 */
+	cgrp->id = idr_alloc(&root->cgroup_idr, NULL, 1, 0, GFP_KERNEL);
 	if (cgrp->id < 0)
 		goto err_free_name;
 
@@ -4371,6 +4378,8 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 		}
 	}
 
+	idr_replace(&root->cgroup_idr, cgrp, cgrp->id);
+
 	err = cgroup_addrm_files(cgrp, NULL, cgroup_base_files, true);
 	if (err)
 		goto err_destroy;
@@ -4397,7 +4406,7 @@ err_free_all:
 	/* Release the reference count that we took on the superblock */
 	deactivate_super(sb);
 err_free_id:
-	ida_simple_remove(&root->cgroup_ida, cgrp->id);
+	idr_remove(&root->cgroup_idr, cgrp->id);
 err_free_name:
 	kfree(rcu_dereference_raw(cgrp->name));
 err_free_cgrp:
@@ -4590,6 +4599,9 @@ static void cgroup_offline_fn(struct work_struct *work)
 	/* delete this cgroup from parent->children */
 	list_del_rcu(&cgrp->sibling);
 
+	if (cgrp->id)
+		idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
+
 	dput(d);
 
 	set_bit(CGRP_RELEASABLE, &parent->flags);
@@ -4915,6 +4927,10 @@ int __init cgroup_init(void)
 
 	BUG_ON(cgroup_init_root_id(&cgroup_dummy_root, 0, 1));
 
+	err = idr_alloc(&cgroup_dummy_root.cgroup_idr, cgroup_dummy_top,
+			0, 1, GFP_KERNEL);
+	BUG_ON(err < 0);
+
 	mutex_unlock(&cgroup_root_mutex);
 	mutex_unlock(&cgroup_mutex);
 
-- 
1.8.0.2
