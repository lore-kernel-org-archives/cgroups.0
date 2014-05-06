From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/8] cgroup: reorganize cgroup_create()
Date: Tue,  6 May 2014 16:19:27 -0400
Message-ID: <1399407574-21472-2-git-send-email-tj@kernel.org>
References: <1399407574-21472-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E52svHjwCFsRQh5i9JVwOOwaqvD5FGK/Yb3kMGhaCXA=;
        b=eF03hZja6ACSQi5C2zosBdqZjhB2WeJe6kP+5OhtHIzpjvOd/7bvBXHBrq4UOqPP5j
         lWE94o77ZPiKxbRegVwkRkjXBHz8/1vtWVkmk/QT3a55mzAqMIq1fk6mMytaO+jHBv09
         /LhUQt3c+ojl3IgcRLbgjgeU4ouMmc7oMO27w2vmovUqT9NV0stTWSqBMN9reQjkshiu
         +cqTQvlp5MS3SG53kWjHakn17hDhNozuFwJ2pszlCECs7+LXtydQIa/4eadayFjauGWb
         kdWb9X2px4YbVayG2BeeZxgX43dp1wI+eSKKnDp/04IIwUsG3cEgtCMip0pjG3Xxw7NM
         4jMg==
In-Reply-To: <1399407574-21472-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Reorganize cgroup_create() so that all paths share unlock out path.

* All err_* labels are renamed to out_* as they're now shared by both
  success and failure paths.

* @err renamed to @ret for the similar reason as above and so that
  it's more consistent with other functions.

* cgroup memory allocation moved after locking so that freeing failed
  cgroup happens before unlocking.  While this moves more code inside
  critical section, memory allocations inside cgroup locking are
  already pretty common and this is unlikely to make any noticeable
  difference.

* While at it, replace a stray @parent->root dereference with @root.

This reorganization will help simplifying locking.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 69 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 34 insertions(+), 35 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index da493a4..4d58229 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4247,15 +4247,10 @@ static long cgroup_create(struct cgroup *parent, const char *name,
 {
 	struct cgroup *cgrp;
 	struct cgroup_root *root = parent->root;
-	int ssid, err;
+	int ssid, ret;
 	struct cgroup_subsys *ss;
 	struct kernfs_node *kn;
 
-	/* allocate the cgroup and its ID, 0 is reserved for the root */
-	cgrp = kzalloc(sizeof(*cgrp), GFP_KERNEL);
-	if (!cgrp)
-		return -ENOMEM;
-
 	mutex_lock(&cgroup_tree_mutex);
 
 	/*
@@ -4266,8 +4261,15 @@ static long cgroup_create(struct cgroup *parent, const char *name,
 	 * don't get nasty surprises if we ever grow another caller.
 	 */
 	if (!cgroup_lock_live_group(parent)) {
-		err = -ENODEV;
-		goto err_unlock_tree;
+		ret = -ENODEV;
+		goto out_unlock_tree;
+	}
+
+	/* allocate the cgroup and its ID, 0 is reserved for the root */
+	cgrp = kzalloc(sizeof(*cgrp), GFP_KERNEL);
+	if (!cgrp) {
+		ret = -ENOMEM;
+		goto out_unlock;
 	}
 
 	/*
@@ -4276,15 +4278,15 @@ static long cgroup_create(struct cgroup *parent, const char *name,
 	 */
 	cgrp->id = cgroup_idr_alloc(&root->cgroup_idr, NULL, 2, 0, GFP_NOWAIT);
 	if (cgrp->id < 0) {
-		err = -ENOMEM;
-		goto err_unlock;
+		ret = -ENOMEM;
+		goto out_free_cgrp;
 	}
 
 	init_cgroup_housekeeping(cgrp);
 
 	cgrp->parent = parent;
 	cgrp->dummy_css.parent = &parent->dummy_css;
-	cgrp->root = parent->root;
+	cgrp->root = root;
 
 	if (notify_on_release(parent))
 		set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
@@ -4295,8 +4297,8 @@ static long cgroup_create(struct cgroup *parent, const char *name,
 	/* create the directory */
 	kn = kernfs_create_dir(parent->kn, name, mode, cgrp);
 	if (IS_ERR(kn)) {
-		err = PTR_ERR(kn);
-		goto err_free_id;
+		ret = PTR_ERR(kn);
+		goto out_free_id;
 	}
 	cgrp->kn = kn;
 
@@ -4319,20 +4321,20 @@ static long cgroup_create(struct cgroup *parent, const char *name,
 	 */
 	cgroup_idr_replace(&root->cgroup_idr, cgrp, cgrp->id);
 
-	err = cgroup_kn_set_ugid(kn);
-	if (err)
-		goto err_destroy;
+	ret = cgroup_kn_set_ugid(kn);
+	if (ret)
+		goto out_destroy;
 
-	err = cgroup_addrm_files(cgrp, cgroup_base_files, true);
-	if (err)
-		goto err_destroy;
+	ret = cgroup_addrm_files(cgrp, cgroup_base_files, true);
+	if (ret)
+		goto out_destroy;
 
 	/* let's create and online css's */
 	for_each_subsys(ss, ssid) {
 		if (parent->child_subsys_mask & (1 << ssid)) {
-			err = create_css(cgrp, ss);
-			if (err)
-				goto err_destroy;
+			ret = create_css(cgrp, ss);
+			if (ret)
+				goto out_destroy;
 		}
 	}
 
@@ -4345,25 +4347,22 @@ static long cgroup_create(struct cgroup *parent, const char *name,
 
 	kernfs_activate(kn);
 
-	mutex_unlock(&cgroup_mutex);
-	mutex_unlock(&cgroup_tree_mutex);
-
-	return 0;
+	ret = 0;
+	goto out_unlock;
 
-err_free_id:
+out_free_id:
 	cgroup_idr_remove(&root->cgroup_idr, cgrp->id);
-err_unlock:
+out_free_cgrp:
+	kfree(cgrp);
+out_unlock:
 	mutex_unlock(&cgroup_mutex);
-err_unlock_tree:
+out_unlock_tree:
 	mutex_unlock(&cgroup_tree_mutex);
-	kfree(cgrp);
-	return err;
+	return ret;
 
-err_destroy:
+out_destroy:
 	cgroup_destroy_locked(cgrp);
-	mutex_unlock(&cgroup_mutex);
-	mutex_unlock(&cgroup_tree_mutex);
-	return err;
+	goto out_unlock;
 }
 
 static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
-- 
1.9.0
