From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/4] cgroup: make cgroup[_taskset]_migrate() take cgroup_root instead of cgroup
Date: Thu,  3 Mar 2016 12:20:01 -0500
Message-ID: <1457025602-4193-4-git-send-email-tj@kernel.org>
References: <1457025602-4193-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0ddAKg5BZZzb0SBXrVmB063piplK8mA3JDFR4FMSHvA=;
        b=AwDH1yZT3UxanoGc9sJ/Ds80OxlO7xNFQ3FCJ0aNSDO3V1zTQ7ZeP2iTbP5RKNsQX/
         /xSQatTG+GBLlsj0fzAzpoblvTg/pmJByjGjnA7+6VjDzwZvo8vrkQgJeoUW39YOnyT9
         VP3BPgfH84WgF0ClTO5zbB43YU8pc/eGZqiZx3m/o7xCo4fw6TKzPo2J8s6WeAD9hWbA
         qIbAJppB91MmVfl18WYOtg0dspWUV8QRLG80y3ZcUjG7Y1zznrntA33Mcq9j9LFvuGDs
         P6HZnSMfhKUXjBuosyTmMeMZHM4Y8aTGZJ5iTTJA1Ps4phnOurP+RWlyp0YgeXr/Zcjq
         NAtg==
In-Reply-To: <1457025602-4193-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On the default hierarchy, a migration can be multi-source and/or
multi-destination.  cgroup_taskest_migrate() used to incorrectly
assume single destination cgroup but the bug has been fixed by
1f7dd3e5a6e4 ("cgroup: fix handling of multi-destination migration
from subtree_control enabling").

Since the commit, @dst_cgrp to cgroup[_taskset]_migrate() is only used
to determine which subsystems are affected or which cgroup_root the
migration is taking place in.  As such, @dst_cgrp is misleading.  This
patch replaces @dst_cgrp with @root.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 70 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8a02076..5dd7613 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2355,38 +2355,38 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset,
 }
 
 /**
- * cgroup_taskset_migrate - migrate a taskset to a cgroup
+ * cgroup_taskset_migrate - migrate a taskset
  * @tset: taget taskset
- * @dst_cgrp: destination cgroup
+ * @root: cgroup root the migration is taking place on
  *
- * Migrate tasks in @tset to @dst_cgrp.  This function fails iff one of the
- * ->can_attach callbacks fails and guarantees that either all or none of
- * the tasks in @tset are migrated.  @tset is consumed regardless of
- * success.
+ * Migrate tasks in @tset as setup by migration preparation functions.
+ * This function fails iff one of the ->can_attach callbacks fails and
+ * guarantees that either all or none of the tasks in @tset are migrated.
+ * @tset is consumed regardless of success.
  */
 static int cgroup_taskset_migrate(struct cgroup_taskset *tset,
-				  struct cgroup *dst_cgrp)
+				  struct cgroup_root *root)
 {
-	struct cgroup_subsys_state *css, *failed_css = NULL;
+	struct cgroup_subsys *ss;
 	struct task_struct *task, *tmp_task;
 	struct css_set *cset, *tmp_cset;
-	int i, ret;
+	int ssid, failed_ssid, ret;
 
 	/* methods shouldn't be called if no task is actually migrating */
 	if (list_empty(&tset->src_csets))
 		return 0;
 
 	/* check that we can legitimately attach to the cgroup */
-	for_each_e_css(css, i, dst_cgrp) {
-		if (css->ss->can_attach) {
-			tset->ssid = i;
-			ret = css->ss->can_attach(tset);
+	do_each_subsys_mask(ss, ssid, root->subsys_mask) {
+		if (ss->can_attach) {
+			tset->ssid = ssid;
+			ret = ss->can_attach(tset);
 			if (ret) {
-				failed_css = css;
+				failed_ssid = ssid;
 				goto out_cancel_attach;
 			}
 		}
-	}
+	} while_each_subsys_mask();
 
 	/*
 	 * Now that we're guaranteed success, proceed to move all tasks to
@@ -2413,25 +2413,25 @@ static int cgroup_taskset_migrate(struct cgroup_taskset *tset,
 	 */
 	tset->csets = &tset->dst_csets;
 
-	for_each_e_css(css, i, dst_cgrp) {
-		if (css->ss->attach) {
-			tset->ssid = i;
-			css->ss->attach(tset);
+	do_each_subsys_mask(ss, ssid, root->subsys_mask) {
+		if (ss->attach) {
+			tset->ssid = ssid;
+			ss->attach(tset);
 		}
-	}
+	} while_each_subsys_mask();
 
 	ret = 0;
 	goto out_release_tset;
 
 out_cancel_attach:
-	for_each_e_css(css, i, dst_cgrp) {
-		if (css == failed_css)
+	do_each_subsys_mask(ss, ssid, root->subsys_mask) {
+		if (ssid == failed_ssid)
 			break;
-		if (css->ss->cancel_attach) {
-			tset->ssid = i;
-			css->ss->cancel_attach(tset);
+		if (ss->cancel_attach) {
+			tset->ssid = ssid;
+			ss->cancel_attach(tset);
 		}
-	}
+	} while_each_subsys_mask();
 out_release_tset:
 	spin_lock_bh(&css_set_lock);
 	list_splice_init(&tset->dst_csets, &tset->src_csets);
@@ -2586,11 +2586,11 @@ static int cgroup_migrate_prepare_dst(struct cgroup *dst_cgrp,
  * cgroup_migrate - migrate a process or task to a cgroup
  * @leader: the leader of the process or the task to migrate
  * @threadgroup: whether @leader points to the whole process or a single task
- * @cgrp: the destination cgroup
+ * @root: cgroup root migration is taking place on
  *
- * Migrate a process or task denoted by @leader to @cgrp.  If migrating a
- * process, the caller must be holding cgroup_threadgroup_rwsem.  The
- * caller is also responsible for invoking cgroup_migrate_add_src() and
+ * Migrate a process or task denoted by @leader.  If migrating a process,
+ * the caller must be holding cgroup_threadgroup_rwsem.  The caller is also
+ * responsible for invoking cgroup_migrate_add_src() and
  * cgroup_migrate_prepare_dst() on the targets before invoking this
  * function and following up with cgroup_migrate_finish().
  *
@@ -2601,7 +2601,7 @@ static int cgroup_migrate_prepare_dst(struct cgroup *dst_cgrp,
  * actually starting migrating.
  */
 static int cgroup_migrate(struct task_struct *leader, bool threadgroup,
-			  struct cgroup *cgrp)
+			  struct cgroup_root *root)
 {
 	struct cgroup_taskset tset = CGROUP_TASKSET_INIT(tset);
 	struct task_struct *task;
@@ -2622,7 +2622,7 @@ static int cgroup_migrate(struct task_struct *leader, bool threadgroup,
 	rcu_read_unlock();
 	spin_unlock_bh(&css_set_lock);
 
-	return cgroup_taskset_migrate(&tset, cgrp);
+	return cgroup_taskset_migrate(&tset, root);
 }
 
 /**
@@ -2659,7 +2659,7 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 	/* prepare dst csets and commit */
 	ret = cgroup_migrate_prepare_dst(dst_cgrp, &preloaded_csets);
 	if (!ret)
-		ret = cgroup_migrate(leader, threadgroup, dst_cgrp);
+		ret = cgroup_migrate(leader, threadgroup, dst_cgrp->root);
 
 	cgroup_migrate_finish(&preloaded_csets);
 	return ret;
@@ -2934,7 +2934,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	}
 	spin_unlock_bh(&css_set_lock);
 
-	ret = cgroup_taskset_migrate(&tset, cgrp);
+	ret = cgroup_taskset_migrate(&tset, cgrp->root);
 out_finish:
 	cgroup_migrate_finish(&preloaded_csets);
 	percpu_up_write(&cgroup_threadgroup_rwsem);
@@ -4172,7 +4172,7 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 		css_task_iter_end(&it);
 
 		if (task) {
-			ret = cgroup_migrate(task, false, to);
+			ret = cgroup_migrate(task, false, to->root);
 			put_task_struct(task);
 		}
 	} while (task && !ret);
-- 
2.5.0
