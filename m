From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/14] cgroup: convert cgroup_has_live_children() into css_has_online_children()
Date: Fri,  9 May 2014 17:31:29 -0400
Message-ID: <1399671091-23867-13-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XiB7v+gWsuU2KTwbNV+zcdcZteMufPhVkodwjiA3bkI=;
        b=YkR6OZRZ/4UIXxyDBE1KcM7ejVGqdfzpzXXVPHpugP39SN8debuYgybUsZ8d5ex699
         1Eadfa7p/Dz2zKv89KWN/omYlfkiqIPNYGRRyA748UbTKUzS+ZY1HA9PiIB5qZxDUsG9
         WhhS3CXrdMtvVKLPJljcNscOo8ZnL9APlj/wChl58K8AL1C07D5htVUb9JgmH3yJQiOB
         9vdOcS3pEeX53iSDJKqJRzttrpAZoEQjtzUqDMxBxpYqu2bizJXnlCYlU1rcTnN5j02A
         uaWhc6B8XZ/WyvJBTN2IJ5KBP7wucBlrzol1tGYI58AHoImIhwv4tUCYXo3xhWsTYrbp
         oh9A==
In-Reply-To: <1399671091-23867-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, Tejun Heo <tj@kernel.org>

Now that cgroup liveliness and css onliness are the same state,
convert cgroup_has_live_children() into css_has_online_children() so
that it can be used for actual csses too.  The function now uses
css_for_each_child() for iteration and is published.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  2 ++
 kernel/cgroup.c        | 32 ++++++++++++++++++++------------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 2cf2063..c8eb66e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -868,6 +868,8 @@ css_next_descendant_post(struct cgroup_subsys_state *pos,
 	for ((pos) = css_next_descendant_post(NULL, (css)); (pos);	\
 	     (pos) = css_next_descendant_post((pos), (css)))
 
+bool css_has_online_children(struct cgroup_subsys_state *css);
+
 /* A css_task_iter should be treated as an opaque object */
 struct css_task_iter {
 	struct cgroup_subsys		*ss;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a0cfe36..0b16631 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -175,7 +175,6 @@ static int need_forkexit_callback __read_mostly;
 static struct cftype cgroup_base_files[];
 
 static void cgroup_put(struct cgroup *cgrp);
-static bool cgroup_has_live_children(struct cgroup *cgrp);
 static int rebind_subsystems(struct cgroup_root *dst_root,
 			     unsigned int ss_mask);
 static int cgroup_destroy_locked(struct cgroup *cgrp);
@@ -1768,7 +1767,7 @@ static void cgroup_kill_sb(struct super_block *sb)
 	 * This prevents new mounts by disabling percpu_ref_tryget_live().
 	 * cgroup_mount() may wait for @root's release.
 	 */
-	if (cgroup_has_live_children(&root->cgrp))
+	if (css_has_online_children(&root->cgrp.self))
 		cgroup_put(&root->cgrp);
 	else
 		percpu_ref_kill(&root->cgrp.self.refcnt);
@@ -3290,19 +3289,28 @@ css_next_descendant_post(struct cgroup_subsys_state *pos,
 	return pos->parent;
 }
 
-static bool cgroup_has_live_children(struct cgroup *cgrp)
+/**
+ * css_has_online_children - does a css have online children
+ * @css: the target css
+ *
+ * Returns %true if @css has any online children; otherwise, %false.  This
+ * function can be called from any context but the caller is responsible
+ * for synchronizing against on/offlining as necessary.
+ */
+bool css_has_online_children(struct cgroup_subsys_state *css)
 {
-	struct cgroup *child;
+	struct cgroup_subsys_state *child;
+	bool ret = false;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(child, &cgrp->self.children, self.sibling) {
-		if (!cgroup_is_dead(child)) {
-			rcu_read_unlock();
-			return true;
+	css_for_each_child(child, css) {
+		if (css->flags & CSS_ONLINE) {
+			ret = true;
+			break;
 		}
 	}
 	rcu_read_unlock();
-	return false;
+	return ret;
 }
 
 /**
@@ -4534,7 +4542,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 * ->self.children as dead children linger on it while being
 	 * drained; otherwise, "rmdir parent/child parent" may fail.
 	 */
-	if (cgroup_has_live_children(cgrp))
+	if (css_has_online_children(&cgrp->self))
 		return -EBUSY;
 
 	/*
@@ -5006,8 +5014,8 @@ void cgroup_exit(struct task_struct *tsk)
 
 static void check_for_release(struct cgroup *cgrp)
 {
-	if (cgroup_is_releasable(cgrp) &&
-	    list_empty(&cgrp->cset_links) && !cgroup_has_live_children(cgrp)) {
+	if (cgroup_is_releasable(cgrp) && list_empty(&cgrp->cset_links) &&
+	    !css_has_online_children(&cgrp->self)) {
 		/*
 		 * Control Group is currently removeable. If it's not
 		 * already queued for a userspace notification, queue
-- 
1.9.0
