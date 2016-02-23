From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/12] cgroup: factor out cgroup_create() out of cgroup_mkdir()
Date: Mon, 22 Feb 2016 22:45:38 -0500
Message-ID: <1456199146-14765-5-git-send-email-tj@kernel.org>
References: <1456199146-14765-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/uhjxN+HwuMO2HL2uQSx2JYqI8naENA5rfb1haf5ueg=;
        b=xIJKBWnWdeB1udetG5CDfDEw3sAMpOedMFhrbdaLfeuzLowTZyGArQq2oHYncKG14X
         x/R6aB6LdGdFoSShI5bpK+4eTqap9RWwjnSEzM2xG3P0Wsvr7kUMsDLy4hxkT9rCsq/B
         w/svCBwihGYNZe3EhIHSFysez2i3HZC2SJRMrx9yJNKUVezxyt29oi3riNNaLYb0UDtU
         VeC1Gzr4QTobgqHPDe7jZy9mUZLDdzqNiORQU3lcZtEq4rqHRGRABgv0n4DJidwgsFDK
         9Pj9GNmempEvLMPcS4zch+NYuqhe9RsI2HIZEQYDaIeJF6zjjss1l0HVbOCE0JLSYM58
         Z5bg==
In-Reply-To: <1456199146-14765-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

We're in the process of refactoring cgroup and css management paths to
separate them out to eventually allow cgroups which aren't visible
through cgroup fs.  This patch factors out cgroup_create() out of
cgroup_mkdir().  cgroup_create() contains all internal object creation
and initialization.  cgroup_mkdir() uses cgroup_create() to create the
internal cgroup and adds interface directory and file creation.

This patch doesn't cause any behavior differences.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 72 ++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 43 insertions(+), 29 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index dd550b3..16c04d1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4884,33 +4884,19 @@ static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
 	return ERR_PTR(err);
 }
 
-static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
-			umode_t mode)
+static struct cgroup *cgroup_create(struct cgroup *parent)
 {
-	struct cgroup *parent, *cgrp, *tcgrp;
-	struct cgroup_root *root;
+	struct cgroup_root *root = parent->root;
 	struct cgroup_subsys *ss;
-	struct kernfs_node *kn;
-	int level, ssid, ret;
-
-	/* Do not accept '\n' to prevent making /proc/<pid>/cgroup unparsable.
-	 */
-	if (strchr(name, '\n'))
-		return -EINVAL;
-
-	parent = cgroup_kn_lock_live(parent_kn);
-	if (!parent)
-		return -ENODEV;
-	root = parent->root;
-	level = parent->level + 1;
+	struct cgroup *cgrp, *tcgrp;
+	int level = parent->level + 1;
+	int ssid, ret;
 
 	/* allocate the cgroup and its ID, 0 is reserved for the root */
 	cgrp = kzalloc(sizeof(*cgrp) +
 		       sizeof(cgrp->ancestor_ids[0]) * (level + 1), GFP_KERNEL);
-	if (!cgrp) {
-		ret = -ENOMEM;
-		goto out_unlock;
-	}
+	if (!cgrp)
+		return ERR_PTR(-ENOMEM);
 
 	ret = percpu_ref_init(&cgrp->self.refcnt, css_release, 0, GFP_KERNEL);
 	if (ret)
@@ -4974,6 +4960,40 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 		cgroup_refresh_subtree_ss_mask(cgrp);
 	}
 
+	return cgrp;
+
+out_cancel_ref:
+	percpu_ref_exit(&cgrp->self.refcnt);
+out_free_cgrp:
+	kfree(cgrp);
+	return ERR_PTR(ret);
+out_destroy:
+	cgroup_destroy_locked(cgrp);
+	return ERR_PTR(ret);
+}
+
+static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
+			umode_t mode)
+{
+	struct cgroup *parent, *cgrp;
+	struct cgroup_subsys *ss;
+	struct kernfs_node *kn;
+	int ssid, ret;
+
+	/* do not accept '\n' to prevent making /proc/<pid>/cgroup unparsable */
+	if (strchr(name, '\n'))
+		return -EINVAL;
+
+	parent = cgroup_kn_lock_live(parent_kn);
+	if (!parent)
+		return -ENODEV;
+
+	cgrp = cgroup_create(parent);
+	if (IS_ERR(cgrp)) {
+		ret = PTR_ERR(cgrp);
+		goto out_unlock;
+	}
+
 	/* create the directory */
 	kn = kernfs_create_dir(parent->kn, name, mode, cgrp);
 	if (IS_ERR(kn)) {
@@ -5008,17 +5028,11 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	ret = 0;
 	goto out_unlock;
 
-out_cancel_ref:
-	percpu_ref_exit(&cgrp->self.refcnt);
-out_free_cgrp:
-	kfree(cgrp);
+out_destroy:
+	cgroup_destroy_locked(cgrp);
 out_unlock:
 	cgroup_kn_unlock(parent_kn);
 	return ret;
-
-out_destroy:
-	cgroup_destroy_locked(cgrp);
-	goto out_unlock;
 }
 
 /*
-- 
2.5.0

