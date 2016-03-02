From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 17/17] cgroup: update css iteration in
 cgroup_update_dfl_csses()
Date: Wed, 2 Mar 2016 13:14:15 -0500
Message-ID: <20160302181415.GC11029@mtj.duckdns.org>
References: <1456351368-786-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hyoLZrgmrvtDDL+6Ce0B7wgTC8pnyTbUFr8wXUC6dBs=;
        b=boLhZogHNC8hOFbBFfttjAOdp9QGz/wawzFht3YYKmXTxmQ+m73tMMsFN/R95a5H71
         MldVUyeFdbqdW1uswM3V/R/u/C05eU/C5PzZBv+z5iPhK+tNg19q0lkED049TwZX3kzr
         wYe3pvkRlDC+7GmGo00KfdQ5TjFQQ7Pr+bJy4j3aYvL5QiqdeYIrggnKwTHw/h5V9GsL
         +pJGRG4Akz7P1Y5vV9rtW6Wy+7/KETiZZxJ891fm9Lw9uOJQT7gJ9CXODMMp6k5W1N2m
         sH0GOM8yFpgQv5K9jXF01aKBYtSFenqdqw2Gnjj4TkWVu4CUofOvSzV2zmcXcs32KXKa
         XlIA==
Content-Disposition: inline
In-Reply-To: <1456351368-786-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

From 9b9af540f2d55d80b4900ff94ca3d2c2980002bf Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Wed, 2 Mar 2016 13:10:41 -0500

The existing sequences of operations ensure that the offlining csses
are drained before cgroup_update_dfl_csses(), so even though
cgroup_update_dfl_csses() uses css_for_each_descendant_pre() to walk
the target cgroups, it doesn't end up operating on dead cgroups.
Also, the function explicitly excludes the subtree root from
operation.

This is fragile and inconsistent with the rest of css update
operations.  This patch updates cgroup_update_dfl_csses() to use
cgroup_for_each_live_descendant_pre() instead and include the subtree
root.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Hello,

One extra patch in the series.  The patchset has been rebased on top
of the following two patches without any content change.

 http://lkml.kernel.org/g/20160302180712.GA11029-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org
 http://lkml.kernel.org/g/20160302180756.GB11029-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org

The git branch has been updated accordingly.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-recursive-control

Thanks.

 kernel/cgroup.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 40ed329..c63fce0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2877,16 +2877,17 @@ static int cgroup_subtree_control_show(struct seq_file *seq, void *v)
  * cgroup_update_dfl_csses - update css assoc of a subtree in default hierarchy
  * @cgrp: root of the subtree to update csses for
  *
- * @cgrp's subtree_ss_mask has changed and its subtree's (self excluded)
- * css associations need to be updated accordingly.  This function looks up
- * all css_sets which are attached to the subtree, creates the matching
- * updated css_sets and migrates the tasks to the new ones.
+ * @cgrp's control masks have changed and its subtree's css associations
+ * need to be updated accordingly.  This function looks up all css_sets
+ * which are attached to the subtree, creates the matching updated css_sets
+ * and migrates the tasks to the new ones.
  */
 static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 {
 	LIST_HEAD(preloaded_csets);
 	struct cgroup_taskset tset = CGROUP_TASKSET_INIT(tset);
-	struct cgroup_subsys_state *css;
+	struct cgroup_subsys_state *d_css;
+	struct cgroup *dsct;
 	struct css_set *src_cset;
 	int ret;
 
@@ -2896,14 +2897,10 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 
 	/* look up all csses currently attached to @cgrp's subtree */
 	spin_lock_bh(&css_set_lock);
-	css_for_each_descendant_pre(css, cgroup_css(cgrp, NULL)) {
+	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
 		struct cgrp_cset_link *link;
 
-		/* self is not affected by subtree_ss_mask change */
-		if (css->cgroup == cgrp)
-			continue;
-
-		list_for_each_entry(link, &css->cgroup->cset_links, cset_link)
+		list_for_each_entry(link, &dsct->cset_links, cset_link)
 			cgroup_migrate_add_src(link->cset, cgrp,
 					       &preloaded_csets);
 	}
-- 
2.5.0
