From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 08/12] cgroup: factor out cgroup_apply_control_enable() from cgroup_subtree_control_write()
Date: Mon, 22 Feb 2016 22:45:42 -0500
Message-ID: <1456199146-14765-9-git-send-email-tj@kernel.org>
References: <1456199146-14765-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FMRwC/RmLaz45WZnPVp6Jfz+0WP92K2R5/vm7VQM2Gw=;
        b=Q7CNfB0YlSQuDJ8UgYclhW31gMcRQJR9dl65l3q6Kuv+MmFe7iXvYtrqMcOHzLP5Xp
         BB2R1zpHNI4BSsky4npzhY+sBXo4jrGw1VOT951rCkUGYx8fS2cblVkMxizrVqGwC5pt
         zFGMfq0mS3bGID/BYLpPtlGAizK73h84F94UjpmMQ1uJaZQU04+EiIZwa3go+krEafoP
         1psXi09d/GCSyGxlzMuAM3P2yBNrqt4KT/1HjromigHH+ICgGqIWXb+99kETkQ/W0ESW
         +otgxOqouqmTS63yoQoeRHov+vYOBwrhDaNiFLTIwXKNdZyE5j4ulNGwb34BalSn97yG
         GGEQ==
In-Reply-To: <1456199146-14765-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Factor out css enabling and showing into cgroup_apply_control_enable().

* Nest subsystem walk inside child walk.  The child walk will later be
  converted to subtree walk which is a bit more expensive.

* Instead of operating on the differential masks @css_enable, simply
  enable or show csses according to the current cgroup_control() and
  cgroup_ss_mask().  This leads to the same result and is simpler and
  more robust.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 77 +++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 47 insertions(+), 30 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index da178ed..5a5cb52 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3008,6 +3008,49 @@ static bool cgroup_drain_offline(struct cgroup *cgrp)
 }
 
 /**
+ * cgroup_apply_control_enable - enable or show csses according to control
+ * @cgrp: parent of the target cgroups
+ *
+ * Walk @cgrp's children and create new csses or make the existing ones
+ * visible.  A css is created invisible if it's being implicitly enabled
+ * through dependency.  An invisible css is made visible when the userland
+ * explicitly enables it.
+ *
+ * Returns 0 on success, -errno on failure.  On failure, csses which have
+ * been processed already aren't cleaned up.  The caller is responsible for
+ * cleaning up with cgroup_apply_control_disble().
+ */
+static int cgroup_apply_control_enable(struct cgroup *cgrp)
+{
+	struct cgroup *dsct;
+	struct cgroup_subsys *ss;
+	int ssid, ret;
+
+	cgroup_for_each_live_child(dsct, cgrp) {
+		for_each_subsys(ss, ssid) {
+			struct cgroup_subsys_state *css = cgroup_css(dsct, ss);
+
+			if (!(cgroup_ss_mask(dsct) & (1 << ss->id)))
+				continue;
+
+			if (!css) {
+				css = css_create(dsct, ss);
+				if (IS_ERR(css))
+					return PTR_ERR(css);
+			}
+
+			if (cgroup_control(dsct) & (1 << ss->id)) {
+				ret = css_populate_dir(css, NULL);
+				if (ret)
+					return ret;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/**
  * cgroup_apply_control_disable - kill or hide csses according to control
  * @cgrp: parent of the target cgroups
  *
@@ -3155,36 +3198,10 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	cgrp->subtree_control = new_sc;
 	cgrp->subtree_ss_mask = new_ss;
 
-	/*
-	 * Create new csses or make the existing ones visible.  A css is
-	 * created invisible if it's being implicitly enabled through
-	 * dependency.  An invisible css is made visible when the userland
-	 * explicitly enables it.
-	 */
-	do_each_subsys_mask(ss, ssid, enable) {
-		cgroup_for_each_live_child(child, cgrp) {
-			if (css_enable & (1 << ssid)) {
-				struct cgroup_subsys_state *css;
-
-				css = css_create(child, ss);
-				if (IS_ERR(css)) {
-					ret = PTR_ERR(css);
-					goto err_undo_css;
-				}
-
-				if (cgrp->subtree_control & (1 << ssid)) {
-					ret = css_populate_dir(css, NULL);
-					if (ret)
-						goto err_undo_css;
-				}
-			} else {
-				ret = css_populate_dir(cgroup_css(child, ss),
-						       NULL);
-				if (ret)
-					goto err_undo_css;
-			}
-		}
-	} while_each_subsys_mask();
+	/* prepare csses */
+	ret = cgroup_apply_control_enable(cgrp);
+	if (ret)
+		goto err_undo_css;
 
 	/*
 	 * At this point, cgroup_e_css() results reflect the new csses
-- 
2.5.0
