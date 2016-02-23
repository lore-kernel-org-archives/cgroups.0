From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/12] cgroup: separate out interface file creation from css creation
Date: Mon, 22 Feb 2016 22:45:35 -0500
Message-ID: <1456199146-14765-2-git-send-email-tj@kernel.org>
References: <1456199146-14765-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=anm6iTORAFPlEVutsO1LtBpRQspyO6TL7wuBpgulmYU=;
        b=EpblB5JtRziqIjrX72+ge8hRRu4worXGSOCKLHh0MogU1GqSs3ggvtwLTwOCj7h5nI
         oWIdRDC33QttFlC9JpiZofRIDRqToRTP3eIM6gewq9XSaFfmKcJXiIObQ+fa586dfgUC
         H5/b5YOVxbt5pMcZaF49/+XK95XTMIVCNWz63xgMDzYKWrQNErfaLs3EwCOsFkUFQZiv
         ogYABsMqcv0GF7+X0/i05ym+YcYMhyXB+lKVfnt2UD2L5LpyZ2vE63T0PhGJqvccUkXT
         RlTHULkxlKci5c6MvR+d+keVRKRzDplcfKZwCvYj/R1XtSc+N2URBuPySZNlbhFZBTns
         r7GQ==
In-Reply-To: <1456199146-14765-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Currently, interface files are created when a css is created depending
on whether @visible is set.  This patch separates out the two into
separate steps to help code refactoring and eventually allow cgroups
which aren't visible through cgroup fs.

Move css_populate_dir() out of create_css() and drop @visible.  While
at it, rename the function to css_create() for consistency.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 72 ++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 43 insertions(+), 29 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7669f68..48ea999 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -222,8 +222,8 @@ static struct cftype cgroup_legacy_base_files[];
 static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask);
 static void css_task_iter_advance(struct css_task_iter *it);
 static int cgroup_destroy_locked(struct cgroup *cgrp);
-static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss,
-		      bool visible);
+static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
+					      struct cgroup_subsys *ss);
 static void css_release(struct percpu_ref *ref);
 static void kill_css(struct cgroup_subsys_state *css);
 static int cgroup_addrm_files(struct cgroup_subsys_state *css,
@@ -3081,14 +3081,26 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	 */
 	do_each_subsys_mask(ss, ssid, enable) {
 		cgroup_for_each_live_child(child, cgrp) {
-			if (css_enable & (1 << ssid))
-				ret = create_css(child, ss,
-					cgrp->subtree_control & (1 << ssid));
-			else
+			if (css_enable & (1 << ssid)) {
+				struct cgroup_subsys_state *css;
+
+				css = css_create(child, ss);
+				if (IS_ERR(css)) {
+					ret = PTR_ERR(css);
+					goto err_undo_css;
+				}
+
+				if (cgrp->subtree_control & (1 << ssid)) {
+					ret = css_populate_dir(css, NULL);
+					if (ret)
+						goto err_undo_css;
+				}
+			} else {
 				ret = css_populate_dir(cgroup_css(child, ss),
 						       NULL);
-			if (ret)
-				goto err_undo_css;
+				if (ret)
+					goto err_undo_css;
+			}
 		}
 	} while_each_subsys_mask();
 
@@ -4716,7 +4728,9 @@ static void css_release_work_fn(struct work_struct *work)
 		 * Those are supported by RCU protecting clearing of
 		 * cgrp->kn->priv backpointer.
 		 */
-		RCU_INIT_POINTER(*(void __rcu __force **)&cgrp->kn->priv, NULL);
+		if (cgrp->kn)
+			RCU_INIT_POINTER(*(void __rcu __force **)&cgrp->kn->priv,
+					 NULL);
 	}
 
 	mutex_unlock(&cgroup_mutex);
@@ -4797,17 +4811,16 @@ static void offline_css(struct cgroup_subsys_state *css)
 }
 
 /**
- * create_css - create a cgroup_subsys_state
+ * css_create - create a cgroup_subsys_state
  * @cgrp: the cgroup new css will be associated with
  * @ss: the subsys of new css
- * @visible: whether to create control knobs for the new css or not
  *
  * Create a new css associated with @cgrp - @ss pair.  On success, the new
- * css is online and installed in @cgrp with all interface files created if
- * @visible.  Returns 0 on success, -errno on failure.
+ * css is online and installed in @cgrp.  This function doesn't create the
+ * interface files.  Returns 0 on success, -errno on failure.
  */
-static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss,
-		      bool visible)
+static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
+					      struct cgroup_subsys *ss)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
 	struct cgroup_subsys_state *parent_css = cgroup_css(parent, ss);
@@ -4818,7 +4831,7 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss,
 
 	css = ss->css_alloc(parent_css);
 	if (IS_ERR(css))
-		return PTR_ERR(css);
+		return css;
 
 	init_and_link_css(css, ss, cgrp);
 
@@ -4831,12 +4844,6 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss,
 		goto err_free_percpu_ref;
 	css->id = err;
 
-	if (visible) {
-		err = css_populate_dir(css, NULL);
-		if (err)
-			goto err_free_id;
-	}
-
 	/* @css is ready to be brought online now, make it visible */
 	list_add_tail_rcu(&css->sibling, &parent_css->children);
 	cgroup_idr_replace(&ss->css_idr, css, css->id);
@@ -4854,18 +4861,16 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss,
 		ss->warned_broken_hierarchy = true;
 	}
 
-	return 0;
+	return css;
 
 err_list_del:
 	list_del_rcu(&css->sibling);
-	css_clear_dir(css, NULL);
-err_free_id:
 	cgroup_idr_remove(&ss->css_idr, css->id);
 err_free_percpu_ref:
 	percpu_ref_exit(&css->refcnt);
 err_free_css:
 	call_rcu(&css->rcu_head, css_free_rcu_fn);
-	return err;
+	return ERR_PTR(err);
 }
 
 static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
@@ -4962,10 +4967,19 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 
 	/* let's create and online css's */
 	do_each_subsys_mask(ss, ssid, parent->subtree_ss_mask) {
-		ret = create_css(cgrp, ss,
-				 parent->subtree_control & (1 << ssid));
-		if (ret)
+		struct cgroup_subsys_state *css;
+
+		css = css_create(cgrp, ss);
+		if (IS_ERR(css)) {
+			ret = PTR_ERR(css);
 			goto out_destroy;
+		}
+
+		if (parent->subtree_control & (1 << ssid)) {
+			ret = css_populate_dir(css, NULL);
+			if (ret)
+				goto out_destroy;
+		}
 	} while_each_subsys_mask();
 
 	/*
-- 
2.5.0

