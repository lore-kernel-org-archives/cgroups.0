From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 11/12] cgroup: Factor out cgroup_{apply|finalize}_control() from cgroup_subtree_control_write()
Date: Mon, 22 Feb 2016 22:45:45 -0500
Message-ID: <1456199146-14765-12-git-send-email-tj@kernel.org>
References: <1456199146-14765-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Q5JiG0nqr8873hD+iI2xojczvfaQqyTR6b5+YdcW8t0=;
        b=NydCIekSIjqb5qfh83a272YWMcDG2hpzBP6XUjTlwpk4j7ylRRzP/yOwoD9kKFM93m
         pq0alDruujeCrfyGNREZyiqnJCNfngh1rbPF6npWfXEUvEhMOh+gC1yp72D/08nDFYxQ
         5ibC31ijE8OSlQ4PWytICGBJwLkA3WjkyQ79Lph77+QacdStL9/zwegukpxkiFfC0D5u
         C/sapsRmDEPCaRNzNXnubuzBACVRsr0NzRNAm6uSOG/FziXvIKo4R1Vx8i+KGH6Qde4T
         hL9Va0hNOPczxRgSKbUJZo2tW6R4LOl0AO4d86zE+35iUXGlm7nJ42MFMSQfAC1CJdod
         9YMw==
In-Reply-To: <1456199146-14765-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Factor out cgroup_{apply|finalize}_control() so that control mask
update can be done in several simple steps.  This patch doesn't
introduce behavior changes.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 81 +++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 58 insertions(+), 23 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 86d7bcb..a1f82fa 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3164,6 +3164,62 @@ static void cgroup_apply_control_disable(struct cgroup *cgrp)
 	}
 }
 
+/**
+ * cgroup_apply_control - apply control mask updates to the subtree
+ * @cgrp: root of the target subtree
+ *
+ * subsystems can be enabled and disabled in a subtree using the following
+ * steps.
+ *
+ * 1. Call cgroup_save_control() to stash the current state.
+ * 2. Update ->subtree_control masks in the subtree as desired.
+ * 3. Call cgroup_apply_control() to apply the changes.
+ * 4. Optionally perform other related operations.
+ * 5. Call cgroup_finalize_control() to finish up.
+ *
+ * This function implements step 3 and propagates the mask changes
+ * throughout @cgrp's subtree, updates csses accordingly and perform
+ * process migrations.
+ */
+static int cgroup_apply_control(struct cgroup *cgrp)
+{
+	int ret;
+
+	cgroup_propagate_control(cgrp);
+
+	ret = cgroup_apply_control_enable(cgrp);
+	if (ret)
+		return ret;
+
+	/*
+	 * At this point, cgroup_e_css() results reflect the new csses
+	 * making the following cgroup_update_dfl_csses() properly update
+	 * css associations of all tasks in the subtree.
+	 */
+	ret = cgroup_update_dfl_csses(cgrp);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+/**
+ * cgroup_finalize_control - finalize control mask update
+ * @cgrp: root of the target subtree
+ * @ret: the result of the update
+ *
+ * Finalize control mask update.  See cgroup_apply_control() for more info.
+ */
+static void cgroup_finalize_control(struct cgroup *cgrp, int ret)
+{
+	if (ret) {
+		cgroup_restore_control(cgrp);
+		cgroup_propagate_control(cgrp);
+	}
+
+	cgroup_apply_control_disable(cgrp);
+}
+
 /* change the enabled child controllers for a cgroup in the default hierarchy */
 static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 					    char *buf, size_t nbytes,
@@ -3262,36 +3318,15 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	cgrp->subtree_control |= enable;
 	cgrp->subtree_control &= ~disable;
 
-	cgroup_propagate_control(cgrp);
+	ret = cgroup_apply_control(cgrp);
 
-	ret = cgroup_apply_control_enable(cgrp);
-	if (ret)
-		goto err_undo_css;
-
-	/*
-	 * At this point, cgroup_e_css() results reflect the new csses
-	 * making the following cgroup_update_dfl_csses() properly update
-	 * css associations of all tasks in the subtree.
-	 */
-	ret = cgroup_update_dfl_csses(cgrp);
-	if (ret)
-		goto err_undo_css;
-
-	/* all tasks are migrated out of disabled csses, commit disable */
-	cgroup_apply_control_disable(cgrp);
+	cgroup_finalize_control(cgrp, ret);
 
 	kernfs_activate(cgrp->kn);
 	ret = 0;
 out_unlock:
 	cgroup_kn_unlock(of->kn);
 	return ret ?: nbytes;
-
-err_undo_css:
-	/* restore masks and shoot down new csses */
-	cgroup_restore_control(cgrp);
-	cgroup_apply_control_disable(cgrp);
-
-	goto out_unlock;
 }
 
 static int cgroup_events_show(struct seq_file *seq, void *v)
-- 
2.5.0
