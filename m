From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 12/16] cgroup: combine cgroup_mutex locking and offline css draining
Date: Wed, 24 Feb 2016 17:02:44 -0500
Message-ID: <1456351368-786-13-git-send-email-tj@kernel.org>
References: <1456351368-786-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ffMQ6Ti7PVLi35IvEOFjKjHkRDY8GgTfEXNwF/t6fwI=;
        b=fbt8jhJ0o15GOBp2Heeb0gNd6LvZk0w1wZbu/dJ8hJWBMkmlVtjEBjFUg7NI62SR2W
         5mwc43kwvZuc/I5Za3iWX8/e5d4c9uKh6274bvuxGDuiVULNPeIJcnpJ30PPF3WMEmPT
         7MH17gVNBE0hFLBQObypf/+2qf31bJZfmuLjSbVBCDdG84Pv6giZDVTS0p4FX5T2aX/0
         S92RfDi2f7ywLpvpt4UOek1+2DMYFjNc9y8bgjjXmvx2JaA7diRN2zLjZKEQYGhRTBQw
         QA3ZIZeU0EWsUj+g5zzO/xeqPoa2jTC0q9px4Ib7STJsJuZlSLyUMYSphzIZ72QCyAGr
         VWlA==
In-Reply-To: <1456351368-786-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

cgroup_drain_offline() is used to wait for csses being offlined to
uninstall itself from cgroup->subsys[] array so that new csses can be
installed.  The function's only user, cgroup_subtree_control_write(),
calls it after performing some checks and restarts the whole process
via restart_syscall() if draining has to release cgroup_mutex to wait.

This can be simplified by draining before other synchronized
operations so that there's nothing to restart.  This patch converts
cgroup_drain_offline() to cgroup_lock_and_drain_offline() which
performs both locking and draining and updates cgroup_kn_lock_live()
use it instead of cgroup_mutex() if requested.  This combined locking
and draining operations are easier to use and less error-prone.

While at it, add WARNs in control_apply functions which triggers if
the subtree isn't properly drained.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 55 +++++++++++++++++++++++++++----------------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index baa0e05..b1c6fe2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -220,6 +220,7 @@ static struct cftype cgroup_dfl_base_files[];
 static struct cftype cgroup_legacy_base_files[];
 
 static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask);
+static void cgroup_lock_and_drain_offline(struct cgroup *cgrp);
 static void css_task_iter_advance(struct css_task_iter *it);
 static int cgroup_destroy_locked(struct cgroup *cgrp);
 static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
@@ -1390,19 +1391,22 @@ static void cgroup_kn_unlock(struct kernfs_node *kn)
 /**
  * cgroup_kn_lock_live - locking helper for cgroup kernfs methods
  * @kn: the kernfs_node being serviced
+ * @drain_offline: perform offline draining on the cgroup
  *
  * This helper is to be used by a cgroup kernfs method currently servicing
  * @kn.  It breaks the active protection, performs cgroup locking and
  * verifies that the associated cgroup is alive.  Returns the cgroup if
  * alive; otherwise, %NULL.  A successful return should be undone by a
- * matching cgroup_kn_unlock() invocation.
+ * matching cgroup_kn_unlock() invocation.  If @drain_offline is %true, the
+ * cgroup is drained of offlining csses before return.
  *
  * Any cgroup kernfs method implementation which requires locking the
  * associated cgroup should use this helper.  It avoids nesting cgroup
  * locking under kernfs active protection and allows all kernfs operations
  * including self-removal.
  */
-static struct cgroup *cgroup_kn_lock_live(struct kernfs_node *kn)
+static struct cgroup *cgroup_kn_lock_live(struct kernfs_node *kn,
+					  bool drain_offline)
 {
 	struct cgroup *cgrp;
 
@@ -1421,7 +1425,10 @@ static struct cgroup *cgroup_kn_lock_live(struct kernfs_node *kn)
 		return NULL;
 	kernfs_break_active_protection(kn);
 
-	mutex_lock(&cgroup_mutex);
+	if (drain_offline)
+		cgroup_lock_and_drain_offline(cgrp);
+	else
+		mutex_lock(&cgroup_mutex);
 
 	if (!cgroup_is_dead(cgrp))
 		return cgrp;
@@ -2760,7 +2767,7 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	if (kstrtoint(strstrip(buf), 0, &pid) || pid < 0)
 		return -EINVAL;
 
-	cgrp = cgroup_kn_lock_live(of->kn);
+	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
 		return -ENODEV;
 
@@ -2858,7 +2865,7 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
 
 	BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
 
-	cgrp = cgroup_kn_lock_live(of->kn);
+	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
 		return -ENODEV;
 	spin_lock(&release_agent_path_lock);
@@ -2983,27 +2990,23 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 }
 
 /**
- * cgroup_drain_offline - wait for previously offlined csses to go away
+ * cgroup_lock_and_drain_offline - lock cgroup_mutex and drain offlined csses
  * @cgrp: root of the target subtree
  *
  * Because css offlining is asynchronous, userland may try to re-enable a
- * controller while the previous css is still around.  This function drains
- * the previous css instances of @cgrp's subtree.
- *
- * Must be called with cgroup_mutex held.  Returns %false if there were no
- * dying css instances.  Returns %true if there were one or more and this
- * function waited.  On %true return, cgroup_mutex has been dropped and
- * re-acquired inbetween which anything could have happened.  The caller
- * typically would have to start over.
+ * controller while the previous css is still around.  This function grabs
+ * cgroup_mutex and drains the previous css instances of @cgrp's subtree.
  */
-static bool cgroup_drain_offline(struct cgroup *cgrp)
+static void cgroup_lock_and_drain_offline(struct cgroup *cgrp)
+	__acquires(&cgroup_mutex)
 {
 	struct cgroup *dsct;
 	struct cgroup_subsys_state *d_css;
 	struct cgroup_subsys *ss;
 	int ssid;
 
-	lockdep_assert_held(&cgroup_mutex);
+restart:
+	mutex_lock(&cgroup_mutex);
 
 	cgroup_for_each_live_descendant_post(dsct, d_css, cgrp) {
 		for_each_subsys(ss, ssid) {
@@ -3020,14 +3023,11 @@ static bool cgroup_drain_offline(struct cgroup *cgrp)
 			mutex_unlock(&cgroup_mutex);
 			schedule();
 			finish_wait(&dsct->offline_waitq, &wait);
-			mutex_lock(&cgroup_mutex);
 
 			cgroup_put(dsct);
-			return true;
+			goto restart;
 		}
 	}
-
-	return false;
 }
 
 /**
@@ -3110,6 +3110,8 @@ static int cgroup_apply_control_enable(struct cgroup *cgrp)
 		for_each_subsys(ss, ssid) {
 			struct cgroup_subsys_state *css = cgroup_css(dsct, ss);
 
+			WARN_ON_ONCE(css && percpu_ref_is_dying(&css->refcnt));
+
 			if (!(cgroup_ss_mask(dsct) & (1 << ss->id)))
 				continue;
 
@@ -3154,6 +3156,8 @@ static void cgroup_apply_control_disable(struct cgroup *cgrp)
 		for_each_subsys(ss, ssid) {
 			struct cgroup_subsys_state *css = cgroup_css(dsct, ss);
 
+			WARN_ON_ONCE(css && percpu_ref_is_dying(&css->refcnt));
+
 			if (!css)
 				continue;
 
@@ -3263,7 +3267,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 			return -EINVAL;
 	}
 
-	cgrp = cgroup_kn_lock_live(of->kn);
+	cgrp = cgroup_kn_lock_live(of->kn, true);
 	if (!cgrp)
 		return -ENODEV;
 
@@ -3308,11 +3312,6 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 		goto out_unlock;
 	}
 
-	if (cgroup_drain_offline(cgrp)) {
-		cgroup_kn_unlock(of->kn);
-		return restart_syscall();
-	}
-
 	/* save and update control masks and prepare csses */
 	cgroup_save_control(cgrp);
 
@@ -5136,7 +5135,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	if (strchr(name, '\n'))
 		return -EINVAL;
 
-	parent = cgroup_kn_lock_live(parent_kn);
+	parent = cgroup_kn_lock_live(parent_kn, false);
 	if (!parent)
 		return -ENODEV;
 
@@ -5335,7 +5334,7 @@ static int cgroup_rmdir(struct kernfs_node *kn)
 	struct cgroup *cgrp;
 	int ret = 0;
 
-	cgrp = cgroup_kn_lock_live(kn);
+	cgrp = cgroup_kn_lock_live(kn, false);
 	if (!cgrp)
 		return 0;
 
-- 
2.5.0
