From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/8] cgroup: collapse cgroup_create() into croup_mkdir()
Date: Tue,  6 May 2014 16:19:28 -0400
Message-ID: <1399407574-21472-3-git-send-email-tj@kernel.org>
References: <1399407574-21472-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kP2HiM1OZvZvIKYZzBvrhtNC5OS2MHuwLLkQpquMLOA=;
        b=cLgy16yXWzwF7yK7v4PP1bpJQz7whUFkT/hFq4z6d6kdm2cc5GZFaSkrp9qSBT3G4v
         vGYnXVkTY4d6rxnX2fiFflDZFKyCRwvh+dGGrPPaPp/meC5SwXSFNEaSk5mjHPu0O1rC
         8/VXyU/onEq6iqPEGrQISF+r6Z74ILz0vFbZVyZODI08w7eijkbNZB+X9ZlH16NEuCO0
         VFQhhuSGnM90jq8q1JBUb2pglcFyuSl7NQS4xP6058Ibl+Ae68qHsGvrzAjpIcXINhuK
         VAEASo6GmOLaEunM1MK0TPOWeB60w6i+u55l0uvKI3xvW5DtyHRMyhBGamwmCScvw6rX
         0IBQ==
In-Reply-To: <1399407574-21472-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

cgroup_mkdir() is the sole user of cgroup_create().  Let's collapse
the latter into the former.  This will help simplifying locking.
While at it, remove now stale comment about inode locking.

This patch doesn't introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 52 +++++++++++++---------------------------------------
 1 file changed, 13 insertions(+), 39 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4d58229..69c0ed9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4236,30 +4236,24 @@ err_free_css:
 	return err;
 }
 
-/**
- * cgroup_create - create a cgroup
- * @parent: cgroup that will be parent of the new cgroup
- * @name: name of the new cgroup
- * @mode: mode to set on new cgroup
- */
-static long cgroup_create(struct cgroup *parent, const char *name,
-			  umode_t mode)
+static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
+			umode_t mode)
 {
-	struct cgroup *cgrp;
+	struct cgroup *parent = parent_kn->priv, *cgrp;
 	struct cgroup_root *root = parent->root;
-	int ssid, ret;
 	struct cgroup_subsys *ss;
 	struct kernfs_node *kn;
-
-	mutex_lock(&cgroup_tree_mutex);
+	int ssid, ret;
 
 	/*
-	 * Only live parents can have children.  Note that the liveliness
-	 * check isn't strictly necessary because cgroup_mkdir() and
-	 * cgroup_rmdir() are fully synchronized by i_mutex; however, do it
-	 * anyway so that locking is contained inside cgroup proper and we
-	 * don't get nasty surprises if we ever grow another caller.
+	 * cgroup_mkdir() grabs cgroup_tree_mutex which nests outside
+	 * kernfs active_ref and cgroup_create() already synchronizes
+	 * properly against removal through cgroup_lock_live_group().
+	 * Break it before calling cgroup_create().
 	 */
+	cgroup_get(parent);
+	kernfs_break_active_protection(parent_kn);
+	mutex_lock(&cgroup_tree_mutex);
 	if (!cgroup_lock_live_group(parent)) {
 		ret = -ENODEV;
 		goto out_unlock_tree;
@@ -4358,6 +4352,8 @@ out_unlock:
 	mutex_unlock(&cgroup_mutex);
 out_unlock_tree:
 	mutex_unlock(&cgroup_tree_mutex);
+	kernfs_unbreak_active_protection(parent_kn);
+	cgroup_put(parent);
 	return ret;
 
 out_destroy:
@@ -4365,28 +4361,6 @@ out_destroy:
 	goto out_unlock;
 }
 
-static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
-			umode_t mode)
-{
-	struct cgroup *parent = parent_kn->priv;
-	int ret;
-
-	/*
-	 * cgroup_create() grabs cgroup_tree_mutex which nests outside
-	 * kernfs active_ref and cgroup_create() already synchronizes
-	 * properly against removal through cgroup_lock_live_group().
-	 * Break it before calling cgroup_create().
-	 */
-	cgroup_get(parent);
-	kernfs_break_active_protection(parent_kn);
-
-	ret = cgroup_create(parent, name, mode);
-
-	kernfs_unbreak_active_protection(parent_kn);
-	cgroup_put(parent);
-	return ret;
-}
-
 /*
  * This is called when the refcnt of a css is confirmed to be killed.
  * css_tryget() is now guaranteed to fail.
-- 
1.9.0
