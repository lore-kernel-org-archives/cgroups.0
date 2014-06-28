From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] cgroup: make interface files visible iff enabled on cgroup->subtree_control
Date: Fri, 27 Jun 2014 21:03:09 -0400
Message-ID: <1403917392-32555-4-git-send-email-tj@kernel.org>
References: <1403917392-32555-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p9koqBtRg1CtvTRNx0wUoxRo4m6GQkBOpK7efdh6zBM=;
        b=aNSubJkyYH8Db0LgSGdHfqsjYN3MP6Qnd0uDRi5raVKOyWlm+Wp2zkddlWPOvACido
         B+w/qIKE10Ckz9yMEy1V8g/2PJRZwqyrKbO29HMYkVwUn8HK0WOtXlscU//QmIu3LmGK
         qROnp/G+YQj/1S/DNG10FdbZbzm1y1rSCEQG2Fgh+lerjSfAC2uAVfVnCVV+uj/jnDSQ
         zHM9W9AYgTb6lBAD4p/3UmWdK2eqXtwSLqww04NWKMaPUf/X1WasOZA8fAO50y0CpTDC
         TB/bw3ZjBqBRP39KZdT52H6FJqgKu5iZ10YF3ieIbJmMA9PyGRU8ZC4Y6+fEAYL6eBvE
         V9Lg==
In-Reply-To: <1403917392-32555-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, mhocko@suse.cz, vgoyal@redhat.com, axboe@kernel.dk, Tejun Heo <tj@kernel.org>

cgroup is implementing support for subsystem dependency which would
require a way to enable a subsystem even when it's not directly
configured through "cgroup.subtree_control".

The preceding patch distinguished cgroup->subtree_control and
->child_subsys_mask where the former is the subsystems explicitly
configured by the userland and the latter is all enabled subsystems
currently is equal to the former but will include subsystems
implicitly enabled through dependency.

Subsystems which are enabled due to dependency shouldn't be visible to
userland.  This patch updates cgroup_subtree_control_write() and
create_css() such that interface files are not created for implicitly
enabled subsytems.

* @visible paramter is added to create_css().  Interface files are
  created only when true.

* If an already implicitly enabled subsystem is turned on through
  "cgroup.subtree_control", the existing css should be used.  css
  draining is skipped.

* cgroup_subtree_control_write() computes the new target
  cgroup->child_subsys_mask and create/kill or show/hide csses
  accordingly.

As the two subsystem masks are still kept identical, this patch
doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  2 ++
 kernel/cgroup.c        | 78 +++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 66 insertions(+), 14 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 8d52c8e..5287f93 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -208,6 +208,8 @@ struct cgroup {
 	 * ->subtree_control is the one configured through
 	 * "cgroup.subtree_control" while ->child_subsys_mask is the
 	 * effective one which may have more subsystems enabled.
+	 * Controller knobs are made available iff it's enabled in
+	 * ->subtree_control.
 	 */
 	unsigned int subtree_control;
 	unsigned int child_subsys_mask;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 14a9d88..331fa296 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -186,7 +186,8 @@ static void cgroup_put(struct cgroup *cgrp);
 static int rebind_subsystems(struct cgroup_root *dst_root,
 			     unsigned int ss_mask);
 static int cgroup_destroy_locked(struct cgroup *cgrp);
-static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss);
+static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss,
+		      bool visible);
 static void css_release(struct percpu_ref *ref);
 static void kill_css(struct cgroup_subsys_state *css);
 static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
@@ -2577,6 +2578,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 					    loff_t off)
 {
 	unsigned int enable = 0, disable = 0;
+	unsigned int css_enable, css_disable, old_ctrl, new_ctrl;
 	struct cgroup *cgrp, *child;
 	struct cgroup_subsys *ss;
 	char *tok;
@@ -2630,6 +2632,13 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 			}
 
 			/*
+			 * @ss is already enabled through dependency and
+			 * we'll just make it visible.  Skip draining.
+			 */
+			if (cgrp->child_subsys_mask & (1 << ssid))
+				continue;
+
+			/*
 			 * Because css offlining is asynchronous, userland
 			 * might try to re-enable the same controller while
 			 * the previous instance is still around.  In such
@@ -2681,17 +2690,39 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 		goto out_unlock;
 	}
 
+	/*
+	 * Update subsys masks and calculate what needs to be done.  More
+	 * subsystems than specified may need to be enabled or disabled
+	 * depending on subsystem dependencies.
+	 */
 	cgrp->subtree_control |= enable;
 	cgrp->subtree_control &= ~disable;
+
+	old_ctrl = cgrp->child_subsys_mask;
 	cgroup_refresh_child_subsys_mask(cgrp);
+	new_ctrl = cgrp->child_subsys_mask;
+
+	css_enable = ~old_ctrl & new_ctrl;
+	css_disable = old_ctrl & ~new_ctrl;
+	enable |= css_enable;
+	disable |= css_disable;
 
-	/* create new csses */
+	/*
+	 * Create new csses or make the existing ones visible.  A css is
+	 * created invisible if it's being implicitly enabled through
+	 * dependency.  An invisible css is made visible when the userland
+	 * explicitly enables it.
+	 */
 	for_each_subsys(ss, ssid) {
 		if (!(enable & (1 << ssid)))
 			continue;
 
 		cgroup_for_each_live_child(child, cgrp) {
-			ret = create_css(child, ss);
+			if (css_enable & (1 << ssid))
+				ret = create_css(child, ss,
+					cgrp->subtree_control & (1 << ssid));
+			else
+				ret = cgroup_populate_dir(child, 1 << ssid);
 			if (ret)
 				goto err_undo_css;
 		}
@@ -2706,13 +2737,21 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	if (ret)
 		goto err_undo_css;
 
-	/* all tasks are now migrated away from the old csses, kill them */
+	/*
+	 * All tasks are migrated out of disabled csses.  Kill or hide
+	 * them.  A css is hidden when the userland requests it to be
+	 * disabled while other subsystems are still depending on it.
+	 */
 	for_each_subsys(ss, ssid) {
 		if (!(disable & (1 << ssid)))
 			continue;
 
-		cgroup_for_each_live_child(child, cgrp)
-			kill_css(cgroup_css(child, ss));
+		cgroup_for_each_live_child(child, cgrp) {
+			if (css_disable & (1 << ssid))
+				kill_css(cgroup_css(child, ss));
+			else
+				cgroup_clear_dir(child, 1 << ssid);
+		}
 	}
 
 	kernfs_activate(cgrp->kn);
@@ -2732,8 +2771,14 @@ err_undo_css:
 
 		cgroup_for_each_live_child(child, cgrp) {
 			struct cgroup_subsys_state *css = cgroup_css(child, ss);
-			if (css)
+
+			if (!css)
+				continue;
+
+			if (css_enable & (1 << ssid))
 				kill_css(css);
+			else
+				cgroup_clear_dir(child, 1 << ssid);
 		}
 	}
 	goto out_unlock;
@@ -4282,12 +4327,14 @@ static void offline_css(struct cgroup_subsys_state *css)
  * create_css - create a cgroup_subsys_state
  * @cgrp: the cgroup new css will be associated with
  * @ss: the subsys of new css
+ * @visible: whether to create control knobs for the new css or not
  *
  * Create a new css associated with @cgrp - @ss pair.  On success, the new
- * css is online and installed in @cgrp with all interface files created.
- * Returns 0 on success, -errno on failure.
+ * css is online and installed in @cgrp with all interface files created if
+ * @visible.  Returns 0 on success, -errno on failure.
  */
-static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
+static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss,
+		      bool visible)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
 	struct cgroup_subsys_state *parent_css = cgroup_css(parent, ss);
@@ -4311,9 +4358,11 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 		goto err_free_percpu_ref;
 	css->id = err;
 
-	err = cgroup_populate_dir(cgrp, 1 << ss->id);
-	if (err)
-		goto err_free_id;
+	if (visible) {
+		err = cgroup_populate_dir(cgrp, 1 << ss->id);
+		if (err)
+			goto err_free_id;
+	}
 
 	/* @css is ready to be brought online now, make it visible */
 	list_add_tail_rcu(&css->sibling, &parent_css->children);
@@ -4430,7 +4479,8 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	/* let's create and online css's */
 	for_each_subsys(ss, ssid) {
 		if (parent->child_subsys_mask & (1 << ssid)) {
-			ret = create_css(cgrp, ss);
+			ret = create_css(cgrp, ss,
+					 parent->subtree_control & (1 << ssid));
 			if (ret)
 				goto out_destroy;
 		}
-- 
1.9.3
