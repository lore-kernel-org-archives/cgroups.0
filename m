From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/8] cgroup: factor out cgroup_kn_lock_live() and cgroup_kn_unlock()
Date: Tue,  6 May 2014 16:19:31 -0400
Message-ID: <1399407574-21472-6-git-send-email-tj@kernel.org>
References: <1399407574-21472-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kkxCUpsbGzhYaUb6bqp5h7xwbGOOF9qNqS5rAiTGc1k=;
        b=qsxEsZ7yqHz3YRcSXVq9q5qjnTduy1uihsOlTAG9w09bgkwlm0OkM3C4pG5bSkw0Dr
         h1tWZX9gspiQvkln0fEMkuYIOBBK1KxlmEftMl3Z0hZR1Snzv9GnIi5llZrw+6ng+AmJ
         qO8CUGd3VwmOw6pKjr2InZ/RZhFas9xRULEq2mEorOiVlDDprNHNyPWZ25t6Gi+8j7uY
         BoDZXuXopRy9PpNNn3WAU1Wt/+r/SfByGAbyLH7m7/aI8JJRgeaC6GVm9+kYPN7RzpCk
         oPLQTNPRpwVfi9j5QvAEtBTg/uFznnshDVwGl6BcQJjlVXGzLVL1fau8TvDSv2EC0W0j
         Jprw==
In-Reply-To: <1399407574-21472-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

cgroup_mkdir(), cgroup_rmdir() and cgroup_subtree_control_write()
share the logic to break active protection so that they can grab
cgroup_tree_mutex which nests above active protection and/or remove
self.  Factor out this logic into cgroup_kn_lock_live() and
cgroup_kn_unlock().

This patch doesn't introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 157 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 90 insertions(+), 67 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3118a63..1d0d5f7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1093,6 +1093,75 @@ static void cgroup_put(struct cgroup *cgrp)
 	call_rcu(&cgrp->rcu_head, cgroup_free_rcu);
 }
 
+/**
+ * cgroup_kn_unlock - unlocking helper for cgroup kernfs methods
+ * @kn: the kernfs_node being serviced
+ *
+ * This helper undoes cgroup_kn_lock_live() and should be invoked before
+ * the method finishes if locking succeeded.  Note that once this function
+ * returns the cgroup returned by cgroup_kn_lock_live() may become
+ * inaccessible any time.  If the caller intends to continue to access the
+ * cgroup, it should pin it before invoking this function.
+ */
+static void cgroup_kn_unlock(struct kernfs_node *kn)
+{
+	struct cgroup *cgrp;
+
+	if (kernfs_type(kn) == KERNFS_DIR)
+		cgrp = kn->priv;
+	else
+		cgrp = kn->parent->priv;
+
+	mutex_unlock(&cgroup_mutex);
+	mutex_unlock(&cgroup_tree_mutex);
+
+	kernfs_unbreak_active_protection(kn);
+	cgroup_put(cgrp);
+}
+
+/**
+ * cgroup_kn_lock_live - locking helper for cgroup kernfs methods
+ * @kn: the kernfs_node being serviced
+ *
+ * This helper is to be used by a cgroup kernfs method currently servicing
+ * @kn.  It breaks the active protection, performs cgroup locking and
+ * verifies that the associated cgroup is alive.  Returns the cgroup if
+ * alive; otherwise, %NULL.  A successful return should be undone by a
+ * matching cgroup_kn_unlock() invocation.
+ *
+ * Any cgroup kernfs method implementation which requires locking the
+ * associated cgroup should use this helper.  It avoids nesting cgroup
+ * locking under kernfs active protection and allows all kernfs operations
+ * including self-removal.
+ */
+static struct cgroup *cgroup_kn_lock_live(struct kernfs_node *kn)
+{
+	struct cgroup *cgrp;
+
+	if (kernfs_type(kn) == KERNFS_DIR)
+		cgrp = kn->priv;
+	else
+		cgrp = kn->parent->priv;
+
+	/*
+	 * We're gonna grab cgroup_tree_mutex which nests outside kernfs
+	 * active_ref.  cgroup liveliness check alone provides enough
+	 * protection against removal.  Ensure @cgrp stays accessible and
+	 * break the active_ref protection.
+	 */
+	cgroup_get(cgrp);
+	kernfs_break_active_protection(kn);
+
+	mutex_lock(&cgroup_tree_mutex);
+	mutex_lock(&cgroup_mutex);
+
+	if (!cgroup_is_dead(cgrp))
+		return cgrp;
+
+	cgroup_kn_unlock(kn);
+	return NULL;
+}
+
 static void cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 {
 	char name[CGROUP_FILE_NAME_MAX];
@@ -2541,7 +2610,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 					    loff_t off)
 {
 	unsigned int enable = 0, disable = 0;
-	struct cgroup *cgrp = of_css(of)->cgroup, *child;
+	struct cgroup *cgrp, *child;
 	struct cgroup_subsys *ss;
 	char *tok;
 	int ssid, ret;
@@ -2573,20 +2642,9 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 			return -EINVAL;
 	}
 
-	/*
-	 * We're gonna grab cgroup_tree_mutex which nests outside kernfs
-	 * active_ref.  cgroup_lock_live_group() already provides enough
-	 * protection.  Ensure @cgrp stays accessible and break the
-	 * active_ref protection.
-	 */
-	cgroup_get(cgrp);
-	kernfs_break_active_protection(of->kn);
-
-	mutex_lock(&cgroup_tree_mutex);
-	if (!cgroup_lock_live_group(cgrp)) {
-		ret = -ENODEV;
-		goto out_unlock_tree;
-	}
+	cgrp = cgroup_kn_lock_live(of->kn);
+	if (!cgrp)
+		return -ENODEV;
 
 	for_each_subsys(ss, ssid) {
 		if (enable & (1 << ssid)) {
@@ -2610,14 +2668,12 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 				cgroup_get(child);
 				prepare_to_wait(&child->offline_waitq, &wait,
 						TASK_UNINTERRUPTIBLE);
-				mutex_unlock(&cgroup_mutex);
-				mutex_unlock(&cgroup_tree_mutex);
+				cgroup_kn_unlock(of->kn);
 				schedule();
 				finish_wait(&child->offline_waitq, &wait);
 				cgroup_put(child);
 
-				ret = restart_syscall();
-				goto out_unbreak;
+				return restart_syscall();
 			}
 
 			/* unavailable or not enabled on the parent? */
@@ -2693,12 +2749,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	kernfs_activate(cgrp->kn);
 	ret = 0;
 out_unlock:
-	mutex_unlock(&cgroup_mutex);
-out_unlock_tree:
-	mutex_unlock(&cgroup_tree_mutex);
-out_unbreak:
-	kernfs_unbreak_active_protection(of->kn);
-	cgroup_put(cgrp);
+	cgroup_kn_unlock(of->kn);
 	return ret ?: nbytes;
 
 err_undo_css:
@@ -4239,25 +4290,16 @@ err_free_css:
 static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 			umode_t mode)
 {
-	struct cgroup *parent = parent_kn->priv, *cgrp;
-	struct cgroup_root *root = parent->root;
+	struct cgroup *parent, *cgrp;
+	struct cgroup_root *root;
 	struct cgroup_subsys *ss;
 	struct kernfs_node *kn;
 	int ssid, ret;
 
-	/*
-	 * cgroup_mkdir() grabs cgroup_tree_mutex which nests outside
-	 * kernfs active_ref and cgroup_create() already synchronizes
-	 * properly against removal through cgroup_lock_live_group().
-	 * Break it before calling cgroup_create().
-	 */
-	cgroup_get(parent);
-	kernfs_break_active_protection(parent_kn);
-	mutex_lock(&cgroup_tree_mutex);
-	if (!cgroup_lock_live_group(parent)) {
-		ret = -ENODEV;
-		goto out_unlock_tree;
-	}
+	parent = cgroup_kn_lock_live(parent_kn);
+	if (!parent)
+		return -ENODEV;
+	root = parent->root;
 
 	/* allocate the cgroup and its ID, 0 is reserved for the root */
 	cgrp = kzalloc(sizeof(*cgrp), GFP_KERNEL);
@@ -4349,11 +4391,7 @@ out_free_id:
 out_free_cgrp:
 	kfree(cgrp);
 out_unlock:
-	mutex_unlock(&cgroup_mutex);
-out_unlock_tree:
-	mutex_unlock(&cgroup_tree_mutex);
-	kernfs_unbreak_active_protection(parent_kn);
-	cgroup_put(parent);
+	cgroup_kn_unlock(parent_kn);
 	return ret;
 
 out_destroy:
@@ -4580,32 +4618,17 @@ static void cgroup_destroy_css_killed(struct cgroup *cgrp)
 
 static int cgroup_rmdir(struct kernfs_node *kn)
 {
-	struct cgroup *cgrp = kn->priv;
+	struct cgroup *cgrp;
 	int ret = 0;
 
-	/*
-	 * This is self-destruction but @kn can't be removed while this
-	 * callback is in progress.  Let's break active protection.  Once
-	 * the protection is broken, @cgrp can be destroyed at any point.
-	 * Pin it so that it stays accessible.
-	 */
-	cgroup_get(cgrp);
-	kernfs_break_active_protection(kn);
-
-	mutex_lock(&cgroup_tree_mutex);
-	mutex_lock(&cgroup_mutex);
-
-	/*
-	 * @cgrp might already have been destroyed while we're trying to
-	 * grab the mutexes.
-	 */
-	if (!cgroup_is_dead(cgrp))
-		ret = cgroup_destroy_locked(cgrp);
+	cgrp = cgroup_kn_lock_live(kn);
+	if (!cgrp)
+		return 0;
+	cgroup_get(cgrp);	/* for @kn->priv clearing */
 
-	mutex_unlock(&cgroup_mutex);
-	mutex_unlock(&cgroup_tree_mutex);
+	ret = cgroup_destroy_locked(cgrp);
 
-	kernfs_unbreak_active_protection(kn);
+	cgroup_kn_unlock(kn);
 
 	/*
 	 * There are two control paths which try to determine cgroup from
-- 
1.9.0
