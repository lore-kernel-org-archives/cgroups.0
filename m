From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 07/16] cgroup: factor out cgroup_apply_control_disable() from cgroup_subtree_control_write()
Date: Wed, 24 Feb 2016 17:02:39 -0500
Message-ID: <1456351368-786-8-git-send-email-tj@kernel.org>
References: <1456351368-786-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uIm3QqKx8Z5QKKrVPiMPVGX5TVym12J1wr/qkJHOU8E=;
        b=E0EtjVnN2lfPfr8yy1JCKnBDwDiDCR8U6BIYG25r7qbVgpS6KLpxNHiIJmuLsdvCCn
         wfvyVsJ3qw6vXcly+M1vIqN71fZX5Ev5b68UedgPcPLzW2V3uhEXBukI7WYfNnXcFX4n
         V/7Ct0Nbtic5+sCnmKJsYc+36NXBVu2ez8R+nE1nOt6UpmYeiw4e3rx4H+XOpKc6SapV
         pH9YvttVnO2DZPYng6Jl7hPvP4J6A6cONqYoAs3/qa1+obO+PPLdqjGjx904Cg2M0ydy
         F0z9C95stICX6o9oEkacTU60h8tcbI+fn+Msce3dUzgO/sP8pHGJZMDbq47+cbNdXGpr
         TS8g==
In-Reply-To: <1456351368-786-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Factor out css disabling and hiding into cgroup_apply_control_disable().

* Nest subsystem walk inside child walk.  The child walk will later be
  converted to subtree walk which is a bit more expensive.

* Instead of operating on the differential masks @css_enable and
  @css_disable, simply disable or hide csses according to the current
  cgroup_control() and cgroup_ss_mask().  This leads to the same
  result and is simpler and more robust.

* This allows error handling path to share the same code.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 74 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 41 insertions(+), 33 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7f1c636..4b8a6eb 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3011,6 +3011,43 @@ static bool cgroup_drain_offline(struct cgroup *cgrp)
 	return false;
 }
 
+/**
+ * cgroup_apply_control_disable - kill or hide csses according to control
+ * @cgrp: parent of the target cgroups
+ *
+ * Walk @cgrp's children and kill and hide csses so that they match
+ * cgroup_ss_mask() and cgroup_visible_mask().
+ *
+ * A css is hidden when the userland requests it to be disabled while other
+ * subsystems are still depending on it.  The css must not actively control
+ * resources and be in the vanilla state if it's made visible again later.
+ * Controllers which may be depended upon should provide ->css_reset() for
+ * this purpose.
+ */
+static void cgroup_apply_control_disable(struct cgroup *cgrp)
+{
+	struct cgroup *dsct;
+	struct cgroup_subsys *ss;
+	int ssid;
+
+	cgroup_for_each_live_child(dsct, cgrp) {
+		for_each_subsys(ss, ssid) {
+			struct cgroup_subsys_state *css = cgroup_css(dsct, ss);
+
+			if (!css)
+				continue;
+
+			if (!(cgroup_ss_mask(dsct) & (1 << ss->id))) {
+				kill_css(css);
+			} else if (!(cgroup_control(dsct) & (1 << ss->id))) {
+				css_clear_dir(css, NULL);
+				if (ss->css_reset)
+					ss->css_reset(css);
+			}
+		}
+	}
+}
+
 /* change the enabled child controllers for a cgroup in the default hierarchy */
 static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 					    char *buf, size_t nbytes,
@@ -3159,27 +3196,8 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	if (ret)
 		goto err_undo_css;
 
-	/*
-	 * All tasks are migrated out of disabled csses.  Kill or hide
-	 * them.  A css is hidden when the userland requests it to be
-	 * disabled while other subsystems are still depending on it.  The
-	 * css must not actively control resources and be in the vanilla
-	 * state if it's made visible again later.  Controllers which may
-	 * be depended upon should provide ->css_reset() for this purpose.
-	 */
-	do_each_subsys_mask(ss, ssid, disable) {
-		cgroup_for_each_live_child(child, cgrp) {
-			struct cgroup_subsys_state *css = cgroup_css(child, ss);
-
-			if (css_disable & (1 << ssid)) {
-				kill_css(css);
-			} else {
-				css_clear_dir(css, NULL);
-				if (ss->css_reset)
-					ss->css_reset(css);
-			}
-		}
-	} while_each_subsys_mask();
+	/* all tasks are migrated out of disabled csses, commit disable */
+	cgroup_apply_control_disable(cgrp);
 
 	kernfs_activate(cgrp->kn);
 	ret = 0;
@@ -3188,22 +3206,12 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	return ret ?: nbytes;
 
 err_undo_css:
+	/* restore masks and shoot down new csses */
 	cgrp->subtree_control = old_sc;
 	cgrp->subtree_ss_mask = old_ss;
 
-	do_each_subsys_mask(ss, ssid, enable) {
-		cgroup_for_each_live_child(child, cgrp) {
-			struct cgroup_subsys_state *css = cgroup_css(child, ss);
-
-			if (!css)
-				continue;
+	cgroup_apply_control_disable(cgrp);
 
-			if (css_enable & (1 << ssid))
-				kill_css(css);
-			else
-				css_clear_dir(css, NULL);
-		}
-	} while_each_subsys_mask();
 	goto out_unlock;
 }
 
-- 
2.5.0
