From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 03/16] cgroup: reorder operations in cgroup_mkdir()
Date: Wed, 24 Feb 2016 17:02:35 -0500
Message-ID: <1456351368-786-4-git-send-email-tj@kernel.org>
References: <1456351368-786-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UEcBk35kcqZ32LQWT9/XZRPjbFYWRkFJwAZDRrqasbY=;
        b=Nq9WnoAXHzlGU1G5HKmvrwasElINIYMBkFwn3L6a6RJDczKEw8aylXAVHmSCNlBxbX
         b0t+NTtko+AdQEPZQOc3UUDGXoy52frBvhecTl65MahRRfvRGZAIIvQ2Y00/YtAR2GwN
         B9YuZnoQYoj2bJZvdzE1CvR1DFn7LcJDb/X/JeNwSAsm/FWn4i2Z/rvpTOw9w28ehqJR
         rGiGsc4/bPLDOVzeMO+2QoVdOWIhOqAptcNh0XumscqbOf6zl3gULfBsGXb8bJG92ekt
         zwUKYz9WznsHKggQj/CPterRDMluVTnlWwgFfsKKYQBFe6dI6Q8+5WaamIGPO2ocNUqx
         uNVg==
In-Reply-To: <1456351368-786-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Currently, operations to initialize internal objects and create
interface directory and files are intermixed in cgroup_mkdir().  We're
in the process of refactoring cgroup and css management paths to
separate them out to eventually allow cgroups which aren't visible
through cgroup fs.

This patch reorders operations inside cgroup_mkdir() so that interface
directory and file handling comes after internal object
initialization.  This will enable further refactoring.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 61 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 30 insertions(+), 31 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c5fa761..204f78a 100644
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
