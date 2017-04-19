From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: avoid attaching a cgroup root to two different
 superblocks, take 2
Date: Wed, 19 Apr 2017 10:15:59 +0800
Message-ID: <58F6C85F.10706@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Commit bfb0b80db5f9 is broken. Now we try to fix the race by delaying
the initialization of cgroup root refcnt until a superblock has been
allocated.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 3.16+
Reported-by: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reported-by: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Tested-by: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---

I agree we apply this for 4.12.

Again I didn't receive your reply. I believe the problem is in my side.
I'll see if there's some network administrator who can look into this
issue, but I don't have much hope...

---
 kernel/cgroup/cgroup-internal.h |  2 +-
 kernel/cgroup/cgroup-v1.c       | 16 +++++++++++++++-
 kernel/cgroup/cgroup.c          |  8 ++++----
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 9203bfb..e470268 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -163,7 +163,7 @@ int cgroup_path_ns_locked(struct cgroup *cgrp, char *buf, size_t buflen,
 
 void cgroup_free_root(struct cgroup_root *root);
 void init_cgroup_root(struct cgroup_root *root, struct cgroup_sb_opts *opts);
-int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask);
+int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask, int ref_flags);
 int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask);
 struct dentry *cgroup_do_mount(struct file_system_type *fs_type, int flags,
 			       struct cgroup_root *root, unsigned long magic,
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 1dc22f6..6ca9b12 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -1072,6 +1072,7 @@ struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
 	struct cgroup_subsys *ss;
 	struct dentry *dentry;
 	int i, ret;
+	bool new_root = false;
 
 	cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
 
@@ -1181,10 +1182,11 @@ struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
 		ret = -ENOMEM;
 		goto out_unlock;
 	}
+	new_root = true;
 
 	init_cgroup_root(root, &opts);
 
-	ret = cgroup_setup_root(root, opts.subsys_mask);
+	ret = cgroup_setup_root(root, opts.subsys_mask, PERCPU_REF_INIT_DEAD);
 	if (ret)
 		cgroup_free_root(root);
 
@@ -1201,6 +1203,18 @@ struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
 				 CGROUP_SUPER_MAGIC, ns);
 
 	/*
+	 * There's a race window after we release cgroup_mutex and before
+	 * allocating a superblock. Make sure a concurrent process won't
+	 * be able to re-use the root during this window by delaying the
+	 * initialization of root refcnt.
+	 */
+	if (new_root) {
+		mutex_lock(&cgroup_mutex);
+		percpu_ref_reinit(&root->cgrp.self.refcnt);
+		mutex_unlock(&cgroup_mutex);
+	}
+
+	/*
 	 * If @pinned_sb, we're reusing an existing root and holding an
 	 * extra ref on its sb.  Mount is complete.  Put the extra ref.
 	 */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 4885132..0f98010 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1640,7 +1640,7 @@ void init_cgroup_root(struct cgroup_root *root, struct cgroup_sb_opts *opts)
 		set_bit(CGRP_CPUSET_CLONE_CHILDREN, &root->cgrp.flags);
 }
 
-int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
+int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask, int ref_flags)
 {
 	LIST_HEAD(tmp_links);
 	struct cgroup *root_cgrp = &root->cgrp;
@@ -1656,8 +1656,8 @@ int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 	root_cgrp->id = ret;
 	root_cgrp->ancestor_ids[0] = ret;
 
-	ret = percpu_ref_init(&root_cgrp->self.refcnt, css_release, 0,
-			      GFP_KERNEL);
+	ret = percpu_ref_init(&root_cgrp->self.refcnt, css_release,
+			      ref_flags, GFP_KERNEL);
 	if (ret)
 		goto out;
 
@@ -4512,7 +4512,7 @@ int __init cgroup_init(void)
 	hash_add(css_set_table, &init_css_set.hlist,
 		 css_set_hash(init_css_set.subsys));
 
-	BUG_ON(cgroup_setup_root(&cgrp_dfl_root, 0));
+	BUG_ON(cgroup_setup_root(&cgrp_dfl_root, 0, 0));
 
 	mutex_unlock(&cgroup_mutex);
 
-- 
1.8.3.1
