From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] cgroup: convert cgroup_cft_commit() to use
 cgroup_for_each_descendant_pre()
Date: Tue, 18 Jun 2013 11:16:53 -0700
Message-ID: <20130618181653.GB1596@htj.dyndns.org>
References: <51C03AF2.7050702@huawei.com>
 <51C03B05.4080504@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ikJtyA1E06tzo1PixH7M07l+LQMuGzFYOuYDB6kPN2k=;
        b=H6YbB69I8o2/wzMz2E7b1wJuT3dVHVsL+GsFdQFjCDdseBNbr2TRO1aJz1GvTyNtAL
         LaIAr/HyOrIDhIJUJO9/qOTIQS5XYriG+oM6vR2XSBShB8pl/0jMp1HpAhObJrSKtHCL
         SX9qxn4BYe3D1KkIJ4YCUkvf6ld0tRm4GVoBzEblmxp+IbbjyfVT7dhq6dl6EbHXRmbR
         lMbZ6ngujyI33vhK59OpHZiw1nxFV5ZDgTxi+IraPxzHudpOw2xnuhms7N5KF8rRQAns
         ljl56EfAsWtFFPws0LHpVv8qr6hwYTpxIkzwmSycbFXdXWkn/azIcFdYH//iQub7tmgG
         v63g==
Content-Disposition: inline
In-Reply-To: <51C03B05.4080504-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From e8c82d20a9f729cf4b9f73043f7fd4e0872bebfd Mon Sep 17 00:00:00 2001
From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Date: Tue, 18 Jun 2013 18:48:37 +0800

We used root->allcg_list to iterate cgroup hierarchy because at that time
cgroup_for_each_descendant_pre() hasn't been invented.

tj: In cgroup_cfts_commit(), s/@serial_nr/@update_upto/, move the
    assignment right above releasing cgroup_mutex and explain what's
    going on there.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Applied to cgroup/for-3.11 with some minor updates.

Thanks.

 include/linux/cgroup.h |  6 ----
 kernel/cgroup.c        | 80 +++++++++++++++++++++++++++-----------------------
 2 files changed, 44 insertions(+), 42 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f975227..b283658 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -206,9 +206,6 @@ struct cgroup {
 	 */
 	struct list_head cset_links;
 
-	struct list_head allcg_node;	/* cgroupfs_root->allcg_list */
-	struct list_head cft_q_node;	/* used during cftype add/rm */
-
 	/*
 	 * Linked list running through all cgroups that can
 	 * potentially be reaped by the release agent. Protected by
@@ -313,9 +310,6 @@ struct cgroupfs_root {
 	/* A list running through the active hierarchies */
 	struct list_head root_list;
 
-	/* All cgroups on this root, cgroup_mutex protected */
-	struct list_head allcg_list;
-
 	/* Hierarchy-specific flags */
 	unsigned long flags;
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e6571ca..0ed7d8d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1399,7 +1399,6 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	INIT_LIST_HEAD(&cgrp->children);
 	INIT_LIST_HEAD(&cgrp->files);
 	INIT_LIST_HEAD(&cgrp->cset_links);
-	INIT_LIST_HEAD(&cgrp->allcg_node);
 	INIT_LIST_HEAD(&cgrp->release_list);
 	INIT_LIST_HEAD(&cgrp->pidlists);
 	mutex_init(&cgrp->pidlist_mutex);
@@ -1414,12 +1413,10 @@ static void init_cgroup_root(struct cgroupfs_root *root)
 
 	INIT_LIST_HEAD(&root->subsys_list);
 	INIT_LIST_HEAD(&root->root_list);
-	INIT_LIST_HEAD(&root->allcg_list);
 	root->number_of_cgroups = 1;
 	cgrp->root = root;
 	cgrp->name = &root_cgroup_name;
 	init_cgroup_housekeeping(cgrp);
-	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
 }
 
 static int cgroup_init_root_id(struct cgroupfs_root *root)
@@ -2785,65 +2782,78 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 	return ret;
 }
 
-static DEFINE_MUTEX(cgroup_cft_mutex);
-
 static void cgroup_cfts_prepare(void)
-	__acquires(&cgroup_cft_mutex) __acquires(&cgroup_mutex)
+	__acquires(&cgroup_mutex)
 {
 	/*
 	 * Thanks to the entanglement with vfs inode locking, we can't walk
 	 * the existing cgroups under cgroup_mutex and create files.
-	 * Instead, we increment reference on all cgroups and build list of
-	 * them using @cgrp->cft_q_node.  Grab cgroup_cft_mutex to ensure
-	 * exclusive access to the field.
+	 * Instead, we use cgroup_for_each_descendant_pre() and drop RCU
+	 * read lock before calling cgroup_addrm_files().
 	 */
-	mutex_lock(&cgroup_cft_mutex);
 	mutex_lock(&cgroup_mutex);
 }
 
 static void cgroup_cfts_commit(struct cgroup_subsys *ss,
 			       struct cftype *cfts, bool is_add)
-	__releases(&cgroup_mutex) __releases(&cgroup_cft_mutex)
+	__releases(&cgroup_mutex)
 {
 	LIST_HEAD(pending);
-	struct cgroup *cgrp, *n;
+	struct cgroup *cgrp, *root = &ss->root->top_cgroup;
 	struct super_block *sb = ss->root->sb;
+	struct dentry *prev = NULL;
+	struct inode *inode;
+	u64 update_upto;
 
 	/* %NULL @cfts indicates abort and don't bother if @ss isn't attached */
-	if (cfts && ss->root != &rootnode &&
-	    atomic_inc_not_zero(sb->s_active)) {
-		list_for_each_entry(cgrp, &ss->root->allcg_list, allcg_node) {
-			dget(cgrp->dentry);
-			list_add_tail(&cgrp->cft_q_node, &pending);
-		}
-	} else {
-		sb = NULL;
+	if (!cfts || ss->root == &rootnode ||
+	    !atomic_inc_not_zero(&sb->s_active)) {
+		mutex_unlock(&cgroup_mutex);
+		return;
 	}
 
-	mutex_unlock(&cgroup_mutex);
-
 	/*
-	 * All new cgroups will see @cfts update on @ss->cftsets.  Add/rm
-	 * files for all cgroups which were created before.
+	 * All cgroups which are created after we drop cgroup_mutex will
+	 * have the updated set of files, so we only need to update the
+	 * cgroups created before the current @cgroup_serial_nr_cursor.
 	 */
-	list_for_each_entry_safe(cgrp, n, &pending, cft_q_node) {
-		struct inode *inode = cgrp->dentry->d_inode;
+	update_upto = atomic64_read(&cgroup_serial_nr_cursor);
+
+	mutex_unlock(&cgroup_mutex);
+
+	/* @root always needs to be updated */
+	inode = root->dentry->d_inode;
+	mutex_lock(&inode->i_mutex);
+	mutex_lock(&cgroup_mutex);
+	cgroup_addrm_files(root, ss, cfts, is_add);
+	mutex_unlock(&cgroup_mutex);
+	mutex_unlock(&inode->i_mutex);
+
+	/* add/rm files for all cgroups created before */
+	rcu_read_lock();
+	cgroup_for_each_descendant_pre(cgrp, root) {
+		if (cgroup_is_dead(cgrp))
+			continue;
+
+		inode = cgrp->dentry->d_inode;
+		dget(cgrp->dentry);
+		rcu_read_unlock();
+
+		dput(prev);
+		prev = cgrp->dentry;
 
 		mutex_lock(&inode->i_mutex);
 		mutex_lock(&cgroup_mutex);
-		if (!cgroup_is_dead(cgrp))
+		if (cgrp->serial_nr <= update_upto && !cgroup_is_dead(cgrp))
 			cgroup_addrm_files(cgrp, ss, cfts, is_add);
 		mutex_unlock(&cgroup_mutex);
 		mutex_unlock(&inode->i_mutex);
 
-		list_del_init(&cgrp->cft_q_node);
-		dput(cgrp->dentry);
+		rcu_read_lock();
 	}
-
-	if (sb)
-		deactivate_super(sb);
-
-	mutex_unlock(&cgroup_cft_mutex);
+	rcu_read_unlock();
+	dput(prev);
+	deactivate_super(sb);
 }
 
 /**
@@ -4320,7 +4330,6 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	cgrp->serial_nr = atomic64_inc_return(&cgroup_serial_nr_cursor);
 
 	/* allocation complete, commit to creation */
-	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
 	list_add_tail_rcu(&cgrp->sibling, &cgrp->parent->children);
 	root->number_of_cgroups++;
 
@@ -4559,7 +4568,6 @@ static void cgroup_offline_fn(struct work_struct *work)
 
 	/* delete this cgroup from parent->children */
 	list_del_rcu(&cgrp->sibling);
-	list_del_init(&cgrp->allcg_node);
 
 	dput(d);
 
-- 
1.8.2.1
