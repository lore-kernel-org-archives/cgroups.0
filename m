From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 5/6] cgroup: use do_each_subsys_mask() where applicable
Date: Mon, 22 Feb 2016 18:05:48 -0500
Message-ID: <1456182349-18156-6-git-send-email-tj@kernel.org>
References: <1456182349-18156-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/gGlq+DV1f3fb49OLOLxYVA072OsJq7NPU9jF5vHLPo=;
        b=nm3Tfey8PYQSn4+fYwXKznI+eAvxPAdUpCi4GYVRcgUMxvQRu62hCgYwSdK31zuEb8
         GrSnPcjrjvh9upF79ZdcYEOOnbaE/7SZCijSrzb4OtKzUih3Vr30LFS8nFo+p4nL9ryf
         yV9T9EYKR3VfHrNgHMdsixECrXu6LyqSaR/7U1fZhWRyTFeWkBmiPtYRjwaakGc9gEzc
         be8hff23qWS4/yY78gUL1OV+U054Izk+ALikbo90yirLp2cgW9K+hPEfsI9o3ja9aA4Z
         7cKSVPsDYRsVuk1JQl34bjJthp1Y2fK/YIwZ35LU+/OJXjahPsbIphG+rgxE7qdKDGvo
         pmPg==
In-Reply-To: <1456182349-18156-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

There are several places in cgroup_subtree_control_write() which can
use do_each_subsys_mask() instead of manual mask testing.  Use it.

No functional changes.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5d10298..1e561bd 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3082,10 +3082,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	 * dependency.  An invisible css is made visible when the userland
 	 * explicitly enables it.
 	 */
-	for_each_subsys(ss, ssid) {
-		if (!(enable & (1 << ssid)))
-			continue;
-
+	do_each_subsys_mask(ss, ssid, enable) {
 		cgroup_for_each_live_child(child, cgrp) {
 			if (css_enable & (1 << ssid))
 				ret = create_css(child, ss,
@@ -3096,7 +3093,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 			if (ret)
 				goto err_undo_css;
 		}
-	}
+	} while_each_subsys_mask();
 
 	/*
 	 * At this point, cgroup_e_css() results reflect the new csses
@@ -3115,10 +3112,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	 * state if it's made visible again later.  Controllers which may
 	 * be depended upon should provide ->css_reset() for this purpose.
 	 */
-	for_each_subsys(ss, ssid) {
-		if (!(disable & (1 << ssid)))
-			continue;
-
+	do_each_subsys_mask(ss, ssid, disable) {
 		cgroup_for_each_live_child(child, cgrp) {
 			struct cgroup_subsys_state *css = cgroup_css(child, ss);
 
@@ -3130,7 +3124,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 					ss->css_reset(css);
 			}
 		}
-	}
+	} while_each_subsys_mask();
 
 	kernfs_activate(cgrp->kn);
 	ret = 0;
@@ -3142,10 +3136,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	cgrp->subtree_control = old_sc;
 	cgrp->subtree_ss_mask = old_ss;
 
-	for_each_subsys(ss, ssid) {
-		if (!(enable & (1 << ssid)))
-			continue;
-
+	do_each_subsys_mask(ss, ssid, enable) {
 		cgroup_for_each_live_child(child, cgrp) {
 			struct cgroup_subsys_state *css = cgroup_css(child, ss);
 
@@ -3157,7 +3148,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 			else
 				css_clear_dir(css, NULL);
 		}
-	}
+	} while_each_subsys_mask();
 	goto out_unlock;
 }
 
@@ -4973,14 +4964,12 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 		goto out_destroy;
 
 	/* let's create and online css's */
-	for_each_subsys(ss, ssid) {
-		if (parent->subtree_ss_mask & (1 << ssid)) {
-			ret = create_css(cgrp, ss,
-					 parent->subtree_control & (1 << ssid));
-			if (ret)
-				goto out_destroy;
-		}
-	}
+	do_each_subsys_mask(ss, ssid, parent->subtree_ss_mask) {
+		ret = create_css(cgrp, ss,
+				 parent->subtree_control & (1 << ssid));
+		if (ret)
+			goto out_destroy;
+	} while_each_subsys_mask();
 
 	/*
 	 * On the default hierarchy, a child doesn't automatically inherit
-- 
2.5.0
