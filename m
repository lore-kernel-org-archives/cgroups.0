From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/16] cgroup: introduce cgroup_{save|propagate|restore}_control()
Date: Wed, 24 Feb 2016 17:02:42 -0500
Message-ID: <1456351368-786-11-git-send-email-tj@kernel.org>
References: <1456351368-786-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ulxuES5sIDmXxD0zc3xmVZcRro4sCVjrZUquFRS5I2g=;
        b=DHjF7fQx7+tuiOWliJbMn98lWGKgmNeaL17rQ0LNZcY6Y6W7JTWPvxwlrv5jSDG0DA
         elAgNVgCUARwmAokKnTSavLnh8dMjBu8baYfqt6oXppwjsaDA+R7WF5LjhIx0atODEFR
         v/+1bu263cz2DQ+uPrlFL8EY+ng2GMSul5fbULreIH+ux0wlit6Yg9fxqq5Lf+oKv6uD
         YyB2OO4ZB++LxhzHYdYZ5pVIxD5TGkO+4DBu789W2KBeGAWoKGuYKPEweGQicbdtSC2/
         /t1WLqJwm+M6Dw4RvxM6tk0FuMhO2MN1jvYFgSOSjBGOo2NpVilHFfFQpJ6Iry0UUKf7
         Aieg==
In-Reply-To: <1456351368-786-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

While controllers are being enabled and disabled in
cgroup_subtree_control_write(), the original subsystem masks are
stashed in local variables so that they can be restored if the
operation fails in the middle.

This patch adds dedicated fields to struct cgroup to be used instead
of the local variables and implements functions to stash the current
values, propagate the changes and restore them recursively.  Combined
with the previous changes, this makes subsystem management operations
fully recursive and modularlized.  This will be used to expand cgroup
core functionalities.

While at it, remove now unused @css_enable and @css_disable from
cgroup_subtree_control_write().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup-defs.h |  2 ++
 kernel/cgroup.c             | 82 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 64 insertions(+), 20 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 7593c1a..aae8c94 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -260,6 +260,8 @@ struct cgroup {
 	 */
 	u16 subtree_control;
 	u16 subtree_ss_mask;
+	u16 old_subtree_control;
+	u16 old_subtree_ss_mask;
 
 	/* Private pointers for each registered subsystem */
 	struct cgroup_subsys_state __rcu *subsys[CGROUP_SUBSYS_COUNT];
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 07ea063..2a55043 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3031,6 +3031,62 @@ static bool cgroup_drain_offline(struct cgroup *cgrp)
 }
 
 /**
+ * cgroup_save_control - save control masks of a subtree
+ * @cgrp: root of the target subtree
+ *
+ * Save ->subtree_control and ->subtree_ss_mask to the respective old_
+ * prefixed fields for @cgrp's subtree including @cgrp itself.
+ */
+static void cgroup_save_control(struct cgroup *cgrp)
+{
+	struct cgroup *dsct;
+	struct cgroup_subsys_state *d_css;
+
+	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
+		dsct->old_subtree_control = dsct->subtree_control;
+		dsct->old_subtree_ss_mask = dsct->subtree_ss_mask;
+	}
+}
+
+/**
+ * cgroup_propagate_control - refresh control masks of a subtree
+ * @cgrp: root of the target subtree
+ *
+ * For @cgrp and its subtree, ensure ->subtree_ss_mask matches
+ * ->subtree_control and propagate controller availability through the
+ * subtree so that descendants don't have unavailable controllers enabled.
+ */
+static void cgroup_propagate_control(struct cgroup *cgrp)
+{
+	struct cgroup *dsct;
+	struct cgroup_subsys_state *d_css;
+
+	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
+		dsct->subtree_control &= cgroup_control(dsct);
+		dsct->subtree_ss_mask = cgroup_calc_subtree_ss_mask(dsct,
+							dsct->subtree_control);
+	}
+}
+
+/**
+ * cgroup_restore_control - restore control masks of a subtree
+ * @cgrp: root of the target subtree
+ *
+ * Restore ->subtree_control and ->subtree_ss_mask from the respective old_
+ * prefixed fields for @cgrp's subtree including @cgrp itself.
+ */
+static void cgroup_restore_control(struct cgroup *cgrp)
+{
+	struct cgroup *dsct;
+	struct cgroup_subsys_state *d_css;
+
+	cgroup_for_each_live_descendant_post(dsct, d_css, cgrp) {
+		dsct->subtree_control = dsct->old_subtree_control;
+		dsct->subtree_ss_mask = dsct->old_subtree_ss_mask;
+	}
+}
+
+/**
  * cgroup_apply_control_enable - enable or show csses according to control
  * @cgrp: root of the target subtree
  *
@@ -3118,7 +3174,6 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 					    loff_t off)
 {
 	u16 enable = 0, disable = 0;
-	u16 css_enable, css_disable, old_sc, new_sc, old_ss, new_ss;
 	struct cgroup *cgrp, *child;
 	struct cgroup_subsys *ss;
 	char *tok;
@@ -3202,25 +3257,14 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 		return restart_syscall();
 	}
 
-	/*
-	 * Update subsys masks and calculate what needs to be done.  More
-	 * subsystems than specified may need to be enabled or disabled
-	 * depending on subsystem dependencies.
-	 */
-	old_sc = cgrp->subtree_control;
-	old_ss = cgrp->subtree_ss_mask;
-	new_sc = (old_sc | enable) & ~disable;
-	new_ss = cgroup_calc_subtree_ss_mask(cgrp, new_sc);
+	/* save and update control masks and prepare csses */
+	cgroup_save_control(cgrp);
 
-	css_enable = ~old_ss & new_ss;
-	css_disable = old_ss & ~new_ss;
-	enable |= css_enable;
-	disable |= css_disable;
+	cgrp->subtree_control |= enable;
+	cgrp->subtree_control &= ~disable;
 
-	cgrp->subtree_control = new_sc;
-	cgrp->subtree_ss_mask = new_ss;
+	cgroup_propagate_control(cgrp);
 
-	/* prepare csses */
 	ret = cgroup_apply_control_enable(cgrp);
 	if (ret)
 		goto err_undo_css;
@@ -3245,9 +3289,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 
 err_undo_css:
 	/* restore masks and shoot down new csses */
-	cgrp->subtree_control = old_sc;
-	cgrp->subtree_ss_mask = old_ss;
-
+	cgroup_restore_control(cgrp);
 	cgroup_apply_control_disable(cgrp);
 
 	goto out_unlock;
-- 
2.5.0

