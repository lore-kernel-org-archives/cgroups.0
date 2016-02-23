From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/12] cgroup: reorder operations in cgroup_mkdir()
Date: Mon, 22 Feb 2016 22:45:37 -0500
Message-ID: <1456199146-14765-4-git-send-email-tj@kernel.org>
References: <1456199146-14765-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cmvto3vbqj4nShhdLn479GUESjUEipHQ9GmLoG6mx9k=;
        b=R2S8pXxr6v7jSonNnxsuKFGZAPbi6PKQReHVkvnbfmRYKnyQHwCWVAST2o1TlZok8F
         DgIHulLJ76mePv147RVZ2ATf8wo2xPiK30y+8prSB5irtWiua5vfT1c/z0gAdTU5FXd9
         cjwRyN2MjSo7Czdd9RAdf/PLPJL7y5IVMFX9kHeQsrYW9smCprcR8K+1JV1yl5ou5CzG
         HyYPAd3xSxJOcR6NORvXppBP5tX8VVJPLKi3Oe+5SiYN9KYKT6v+tLQLrUp2TjkFQP0v
         45Ncw5I5ljksnqsagJl+7f4WdWCc9JR0r2p5txhMw/nHrQqccXZH986HvCRHoWMnzPeX
         QFnw==
In-Reply-To: <1456199146-14765-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Currently, operations to initialize internal objects and create
interface directory and files are intermixed in cgroup_mkdir().  We're
in the process of refactoring cgroup and css management paths to
separate them out to eventually allow cgroups which aren't visible
through cgroup fs.

This patch reorders operations inside cgroup_mkdir() so that interface
directory and file handling comes after internal object
initialization.  This will enable further refactoring.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 61 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 30 insertions(+), 31 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9e5caf0..dd550b3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4941,20 +4941,6 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	if (test_bit(CGRP_CPUSET_CLONE_CHILDREN, &parent->flags))
 		set_bit(CGRP_CPUSET_CLONE_CHILDREN, &cgrp->flags);
 
-	/* create the directory */
-	kn = kernfs_create_dir(parent->kn, name, mode, cgrp);
-	if (IS_ERR(kn)) {
-		ret = PTR_ERR(kn);
-		goto out_free_id;
-	}
-	cgrp->kn = kn;
-
-	/*
-	 * This extra ref will be put in cgroup_free_fn() and guarantees
-	 * that @cgrp->kn is always accessible.
-	 */
-	kernfs_get(kn);
-
 	cgrp->self.serial_nr = css_serial_nr_next++;
 
 	/* allocation complete, commit to creation */
@@ -4968,15 +4954,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	 */
 	cgroup_idr_replace(&root->cgroup_idr, cgrp, cgrp->id);
 
-	ret = cgroup_kn_set_ugid(kn);
-	if (ret)
-		goto out_destroy;
-
-	ret = css_populate_dir(&cgrp->self, NULL);
-	if (ret)
-		goto out_destroy;
-
-	/* let's create and online css's */
+	/* create the csses */
 	do_each_subsys_mask(ss, ssid, parent->subtree_ss_mask) {
 		struct cgroup_subsys_state *css;
 
@@ -4985,12 +4963,6 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 			ret = PTR_ERR(css);
 			goto out_destroy;
 		}
-
-		if (parent->subtree_control & (1 << ssid)) {
-			ret = css_populate_dir(css, NULL);
-			if (ret)
-				goto out_destroy;
-		}
 	} while_each_subsys_mask();
 
 	/*
@@ -5002,13 +4974,40 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 		cgroup_refresh_subtree_ss_mask(cgrp);
 	}
 
+	/* create the directory */
+	kn = kernfs_create_dir(parent->kn, name, mode, cgrp);
+	if (IS_ERR(kn)) {
+		ret = PTR_ERR(kn);
+		goto out_destroy;
+	}
+	cgrp->kn = kn;
+
+	/*
+	 * This extra ref will be put in cgroup_free_fn() and guarantees
+	 * that @cgrp->kn is always accessible.
+	 */
+	kernfs_get(kn);
+
+	ret = cgroup_kn_set_ugid(kn);
+	if (ret)
+		goto out_destroy;
+
+	ret = css_populate_dir(&cgrp->self, NULL);
+	if (ret)
+		goto out_destroy;
+
+	do_each_subsys_mask(ss, ssid, parent->subtree_control) {
+		ret = css_populate_dir(cgroup_css(cgrp, ss), NULL);
+		if (ret)
+			goto out_destroy;
+	} while_each_subsys_mask();
+
+	/* let's create and online css's */
 	kernfs_activate(kn);
 
 	ret = 0;
 	goto out_unlock;
 
-out_free_id:
-	cgroup_idr_remove(&root->cgroup_idr, cgrp->id);
 out_cancel_ref:
 	percpu_ref_exit(&cgrp->self.refcnt);
 out_free_cgrp:
-- 
2.5.0

