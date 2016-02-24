From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 13/16] cgroup: use cgroup_apply_enable_control() in cgroup creation path
Date: Wed, 24 Feb 2016 17:02:45 -0500
Message-ID: <1456351368-786-14-git-send-email-tj@kernel.org>
References: <1456351368-786-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QR/MOY7rEiL8VWfl2qNz2BIa73+9dQ+GywzomnfxZ0I=;
        b=GbUnTlU+aHpzhd91gl5d+oz6n7PS6mw3GecyX+EWGIA6hB0fJDTabfKPTGDZ2ftzR4
         fBQHeMAuU45cV1a9f3uZ3Bjm0Xos/oP7uplMZiA/0nf81z1yftzINtAxhRIyf4uaT2GM
         BlNDXWHA2VDQybeakQShuZ/xg+GKsuzrv3apkSXypCGfZmt3HEP8LZe0FtNe4xFfTI6I
         qkmP9r6v+NRRHhQIr2/M/daRwPoCPNC4pwnm51e1SEan9KnvTVdD1Jxx0ZHzBQ8rjG5s
         iuR+otDgojqzsvZSLzldBrHxHLl9fACd6nvT2kec3W4rrh/ZhEr+Bt9o9BW745k3uYWI
         HjPw==
In-Reply-To: <1456351368-786-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

cgroup_create() manually updates control masks and creates child csses
which cgroup_mkdir() then manually populates.  Both can be simplified
by using cgroup_apply_enable_control() and friends.  The only catch is
that it calls css_populate_dir() with NULL cgroup->kn during
cgroup_create().  This is worked around by making the function noop on
NULL kn.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 38 ++++++++++++++------------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b1c6fe2..efeaa54 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1489,7 +1489,7 @@ static int css_populate_dir(struct cgroup_subsys_state *css,
 	struct cftype *cfts, *failed_cfts;
 	int ret;
 
-	if (css->flags & CSS_VISIBLE)
+	if ((css->flags & CSS_VISIBLE) || !cgrp->kn)
 		return 0;
 
 	if (!css->ss) {
@@ -5038,10 +5038,9 @@ static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
 static struct cgroup *cgroup_create(struct cgroup *parent)
 {
 	struct cgroup_root *root = parent->root;
-	struct cgroup_subsys *ss;
 	struct cgroup *cgrp, *tcgrp;
 	int level = parent->level + 1;
-	int ssid, ret;
+	int ret;
 
 	/* allocate the cgroup and its ID, 0 is reserved for the root */
 	cgrp = kzalloc(sizeof(*cgrp) +
@@ -5091,25 +5090,19 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 	 */
 	cgroup_idr_replace(&root->cgroup_idr, cgrp, cgrp->id);
 
-	/* create the csses */
-	do_each_subsys_mask(ss, ssid, cgroup_ss_mask(cgrp)) {
-		struct cgroup_subsys_state *css;
-
-		css = css_create(cgrp, ss);
-		if (IS_ERR(css)) {
-			ret = PTR_ERR(css);
-			goto out_destroy;
-		}
-	} while_each_subsys_mask();
-
 	/*
 	 * On the default hierarchy, a child doesn't automatically inherit
 	 * subtree_control from the parent.  Each is configured manually.
 	 */
-	if (!cgroup_on_dfl(cgrp)) {
+	if (!cgroup_on_dfl(cgrp))
 		cgrp->subtree_control = cgroup_control(cgrp);
-		cgroup_refresh_subtree_ss_mask(cgrp);
-	}
+
+	cgroup_propagate_control(cgrp);
+
+	/* @cgrp doesn't have dir yet so the following will only create csses */
+	ret = cgroup_apply_control_enable(cgrp);
+	if (ret)
+		goto out_destroy;
 
 	return cgrp;
 
@@ -5127,9 +5120,8 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 			umode_t mode)
 {
 	struct cgroup *parent, *cgrp;
-	struct cgroup_subsys *ss;
 	struct kernfs_node *kn;
-	int ssid, ret;
+	int ret;
 
 	/* do not accept '\n' to prevent making /proc/<pid>/cgroup unparsable */
 	if (strchr(name, '\n'))
@@ -5167,11 +5159,9 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	if (ret)
 		goto out_destroy;
 
-	do_each_subsys_mask(ss, ssid, cgroup_control(cgrp)) {
-		ret = css_populate_dir(cgroup_css(cgrp, ss), NULL);
-		if (ret)
-			goto out_destroy;
-	} while_each_subsys_mask();
+	ret = cgroup_apply_control_enable(cgrp);
+	if (ret)
+		goto out_destroy;
 
 	/* let's create and online css's */
 	kernfs_activate(kn);
-- 
2.5.0
