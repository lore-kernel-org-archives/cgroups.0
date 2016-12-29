From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/3] cgroup: call subsys->*attach() only for subsystems which are actually affected by migration
Date: Thu, 29 Dec 2016 17:11:15 -0500
Message-ID: <20161229221115.31995-4-tj@kernel.org>
References: <20161229221115.31995-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hf8Y1bncR7e2yGcwZ4waiJwplH6zAQFWUCecjddZ4U8=;
        b=BoDzAldlgOX9MGJnHDDoIyNjIZoPftOYAsF+1jn4tu0RL77c8Z50YKKqIHz4loQSsu
         H7K3eY13bPkO8c1Z/IdvNGXpLO/YdnZz35mO7KhqwW8gD8Z19q4doBu4lU0Xrcq2pqhB
         HQtIEK6c1AQKP87mo9tCOGFcMoJeqwAss2u3y9OEayfh/aCRxpATjQxD7h9+Qf5YmUc8
         ar5Je5kCOXsuKwJZDwjRAwwssRcBs5tAevH8Kw9C6l6+hIoRCBiOhDPebbc304fHuj20
         BmdiVONi0oMQ6IBgaZOFkCj4v5LU663rzE+Hb0psTAkK69OxUADIT5p6QUha/6lJJ1ja
         OhNg==
In-Reply-To: <20161229221115.31995-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Currently, subsys->*attach() callbacks are called for all subsystems
which are attached to the hierarchy on which the migration is taking
place.

With cgroup_migrate_prepare_dst() filtering out identity migrations,
v1 hierarchies can avoid spurious ->*attach() callback invocations
where the source and destination csses are identical; however, this
isn't enough on v2 as only a subset of the attached controllers can be
affected on controller enable/disable.

While spurious ->*attach() invocations aren't critically broken,
they're unnecessary overhead and can lead to temporary overcharges on
certain controllers.  Fix it by tracking which subsystems are affected
by a migration and invoking ->*attach() callbacks only on those
subsystems.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/cgroup-internal.h |  5 ++++-
 kernel/cgroup/cgroup-v1.c       |  2 +-
 kernel/cgroup/cgroup.c          | 25 ++++++++++++++-----------
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 5f8c8ac..9203bfb 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -62,6 +62,9 @@ struct cgroup_mgctx {
 
 	/* tasks and csets to migrate */
 	struct cgroup_taskset	tset;
+
+	/* subsystems affected by migration */
+	u16			ss_mask;
 };
 
 #define CGROUP_TASKSET_INIT(tset)						\
@@ -172,7 +175,7 @@ void cgroup_migrate_add_src(struct css_set *src_cset, struct cgroup *dst_cgrp,
 			    struct cgroup_mgctx *mgctx);
 int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx);
 int cgroup_migrate(struct task_struct *leader, bool threadgroup,
-		   struct cgroup_mgctx *mgctx, struct cgroup_root *root);
+		   struct cgroup_mgctx *mgctx);
 
 int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 		       bool threadgroup);
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 7a965f4..fc34bcf 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -125,7 +125,7 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 		css_task_iter_end(&it);
 
 		if (task) {
-			ret = cgroup_migrate(task, false, &mgctx, to->root);
+			ret = cgroup_migrate(task, false, &mgctx);
 			if (!ret)
 				trace_cgroup_transfer_tasks(to, task, false);
 			put_task_struct(task);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f90554d..69ad5b3 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2019,15 +2019,13 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset,
 /**
  * cgroup_taskset_migrate - migrate a taskset
  * @mgctx: migration context
- * @root: cgroup root the migration is taking place on
  *
  * Migrate tasks in @mgctx as setup by migration preparation functions.
  * This function fails iff one of the ->can_attach callbacks fails and
  * guarantees that either all or none of the tasks in @mgctx are migrated.
  * @mgctx is consumed regardless of success.
  */
-static int cgroup_migrate_execute(struct cgroup_mgctx *mgctx,
-				  struct cgroup_root *root)
+static int cgroup_migrate_execute(struct cgroup_mgctx *mgctx)
 {
 	struct cgroup_taskset *tset = &mgctx->tset;
 	struct cgroup_subsys *ss;
@@ -2040,7 +2038,7 @@ static int cgroup_migrate_execute(struct cgroup_mgctx *mgctx,
 		return 0;
 
 	/* check that we can legitimately attach to the cgroup */
-	do_each_subsys_mask(ss, ssid, root->subsys_mask) {
+	do_each_subsys_mask(ss, ssid, mgctx->ss_mask) {
 		if (ss->can_attach) {
 			tset->ssid = ssid;
 			ret = ss->can_attach(tset);
@@ -2076,7 +2074,7 @@ static int cgroup_migrate_execute(struct cgroup_mgctx *mgctx,
 	 */
 	tset->csets = &tset->dst_csets;
 
-	do_each_subsys_mask(ss, ssid, root->subsys_mask) {
+	do_each_subsys_mask(ss, ssid, mgctx->ss_mask) {
 		if (ss->attach) {
 			tset->ssid = ssid;
 			ss->attach(tset);
@@ -2087,7 +2085,7 @@ static int cgroup_migrate_execute(struct cgroup_mgctx *mgctx,
 	goto out_release_tset;
 
 out_cancel_attach:
-	do_each_subsys_mask(ss, ssid, root->subsys_mask) {
+	do_each_subsys_mask(ss, ssid, mgctx->ss_mask) {
 		if (ssid == failed_ssid)
 			break;
 		if (ss->cancel_attach) {
@@ -2223,6 +2221,8 @@ int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx)
 	list_for_each_entry_safe(src_cset, tmp_cset, &mgctx->preloaded_src_csets,
 				 mg_preload_node) {
 		struct css_set *dst_cset;
+		struct cgroup_subsys *ss;
+		int ssid;
 
 		dst_cset = find_css_set(src_cset, src_cset->mg_dst_cgrp);
 		if (!dst_cset)
@@ -2251,6 +2251,10 @@ int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx)
 				      &mgctx->preloaded_dst_csets);
 		else
 			put_css_set(dst_cset);
+
+		for_each_subsys(ss, ssid)
+			if (src_cset->subsys[ssid] != dst_cset->subsys[ssid])
+				mgctx->ss_mask |= 1 << ssid;
 	}
 
 	return 0;
@@ -2263,7 +2267,6 @@ int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx)
  * cgroup_migrate - migrate a process or task to a cgroup
  * @leader: the leader of the process or the task to migrate
  * @threadgroup: whether @leader points to the whole process or a single task
- * @root: cgroup root migration is taking place on
  * @mgctx: migration context
  *
  * Migrate a process or task denoted by @leader.  If migrating a process,
@@ -2279,7 +2282,7 @@ int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx)
  * actually starting migrating.
  */
 int cgroup_migrate(struct task_struct *leader, bool threadgroup,
-		   struct cgroup_mgctx *mgctx, struct cgroup_root *root)
+		   struct cgroup_mgctx *mgctx)
 {
 	struct task_struct *task;
 
@@ -2299,7 +2302,7 @@ int cgroup_migrate(struct task_struct *leader, bool threadgroup,
 	rcu_read_unlock();
 	spin_unlock_irq(&css_set_lock);
 
-	return cgroup_migrate_execute(mgctx, root);
+	return cgroup_migrate_execute(mgctx);
 }
 
 /**
@@ -2335,7 +2338,7 @@ int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 	/* prepare dst csets and commit */
 	ret = cgroup_migrate_prepare_dst(&mgctx);
 	if (!ret)
-		ret = cgroup_migrate(leader, threadgroup, &mgctx, dst_cgrp->root);
+		ret = cgroup_migrate(leader, threadgroup, &mgctx);
 
 	cgroup_migrate_finish(&mgctx);
 
@@ -2539,7 +2542,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	}
 	spin_unlock_irq(&css_set_lock);
 
-	ret = cgroup_migrate_execute(&mgctx, cgrp->root);
+	ret = cgroup_migrate_execute(&mgctx);
 out_finish:
 	cgroup_migrate_finish(&mgctx);
 	percpu_up_write(&cgroup_threadgroup_rwsem);
-- 
2.9.3

