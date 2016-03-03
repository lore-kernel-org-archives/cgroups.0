From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] cgroup: use css_set->mg_dst_cgrp for the migration target cgroup
Date: Thu,  3 Mar 2016 12:20:02 -0500
Message-ID: <1457025602-4193-5-git-send-email-tj@kernel.org>
References: <1457025602-4193-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HUiT10Sjbr8rwIptdnWzyWP+IGdx5DLWgz3bI4PSi+8=;
        b=oqLHwuyDssBdAP6oiEUWFiF1HyhkSzKui0ESQN8NnTCZ/wmMCkR5/pPOJjWfklE3Qb
         +yP5onjW8qPsNuKivaJksXfc+O2oQAFshvraMjyHYJnY7CnwcyFCe+68r14Vs4gDvLzw
         8mP7Reo2LvCuUtLYm+mn2vu9UmScJ7NLuOKNRbIcsw/6BK7ZYyoMlzs6IUE8/AGRIN8y
         kkAcQQSFEZlxvEnFTpmGyceWDSt8va2tnE0ZOq6NElebX8bhyAWSFMtkG2yG/bG9fAC6
         Gv0EbGkbgL0qkLP0E63ZBLTSBodjIKhtI6iCHkcW4zjugrMEX7TDnxTsVQvFMyMl152q
         toRg==
In-Reply-To: <1457025602-4193-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Migration can be multi-target on the default hierarchy when a
controller is enabled - processes belonging to each child cgroup have
to be moved to the child cgroup itself to refresh css association.

This isn't a problem for cgroup_migrate_add_src() as each source
css_set still maps to single source and target cgroups; however,
cgroup_migrate_prepare_dst() is called once after all source css_sets
are added and thus might not have a single destination cgroup.  This
is currently worked around by specifying NULL for @dst_cgrp and using
the source's default cgroup as destination as the only multi-target
migration in use is self-targetting.  While this works, it's subtle
and clunky.

As all taget cgroups are already specified while preparing the source
css_sets, this clunkiness can easily be removed by recording the
target cgroup in each source css_set.  This patch adds
css_set->mg_dst_cgrp which is recorded on cgroup_migrate_src() and
used by cgroup_migrate_prepare_dst().  This also makes migration code
ready for arbitrary multi-target migration.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup-defs.h |  9 +++++----
 kernel/cgroup.c             | 26 +++++++++++++-------------
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index aae8c94..590291d 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -191,12 +191,13 @@ struct css_set {
 
 	/*
 	 * If this cset is acting as the source of migration the following
-	 * two fields are set.  mg_src_cgrp is the source cgroup of the
-	 * on-going migration and mg_dst_cset is the destination cset the
-	 * target tasks on this cset should be migrated to.  Protected by
-	 * cgroup_mutex.
+	 * two fields are set.  mg_src_cgrp and mg_dst_cgrp are
+	 * respectively the source and destination cgroups of the on-going
+	 * migration.  mg_dst_cset is the destination cset the target tasks
+	 * on this cset should be migrated to.  Protected by cgroup_mutex.
 	 */
 	struct cgroup *mg_src_cgrp;
+	struct cgroup *mg_dst_cgrp;
 	struct css_set *mg_dst_cset;
 
 	/*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5dd7613..fbd3e99 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2473,6 +2473,7 @@ static void cgroup_migrate_finish(struct list_head *preloaded_csets)
 	spin_lock_bh(&css_set_lock);
 	list_for_each_entry_safe(cset, tmp_cset, preloaded_csets, mg_preload_node) {
 		cset->mg_src_cgrp = NULL;
+		cset->mg_dst_cgrp = NULL;
 		cset->mg_dst_cset = NULL;
 		list_del_init(&cset->mg_preload_node);
 		put_css_set_locked(cset);
@@ -2511,32 +2512,31 @@ static void cgroup_migrate_add_src(struct css_set *src_cset,
 		return;
 
 	WARN_ON(src_cset->mg_src_cgrp);
+	WARN_ON(src_cset->mg_dst_cgrp);
 	WARN_ON(!list_empty(&src_cset->mg_tasks));
 	WARN_ON(!list_empty(&src_cset->mg_node));
 
 	src_cset->mg_src_cgrp = src_cgrp;
+	src_cset->mg_dst_cgrp = dst_cgrp;
 	get_css_set(src_cset);
 	list_add(&src_cset->mg_preload_node, preloaded_csets);
 }
 
 /**
  * cgroup_migrate_prepare_dst - prepare destination css_sets for migration
- * @dst_cgrp: the destination cgroup (may be %NULL)
  * @preloaded_csets: list of preloaded source css_sets
  *
- * Tasks are about to be moved to @dst_cgrp and all the source css_sets
- * have been preloaded to @preloaded_csets.  This function looks up and
- * pins all destination css_sets, links each to its source, and append them
- * to @preloaded_csets.  If @dst_cgrp is %NULL, the destination of each
- * source css_set is assumed to be its cgroup on the default hierarchy.
+ * Tasks are about to be moved and all the source css_sets have been
+ * preloaded to @preloaded_csets.  This function looks up and pins all
+ * destination css_sets, links each to its source, and append them to
+ * @preloaded_csets.
  *
  * This function must be called after cgroup_migrate_add_src() has been
  * called on each migration source css_set.  After migration is performed
  * using cgroup_migrate(), cgroup_migrate_finish() must be called on
  * @preloaded_csets.
  */
-static int cgroup_migrate_prepare_dst(struct cgroup *dst_cgrp,
-				      struct list_head *preloaded_csets)
+static int cgroup_migrate_prepare_dst(struct list_head *preloaded_csets)
 {
 	LIST_HEAD(csets);
 	struct css_set *src_cset, *tmp_cset;
@@ -2547,8 +2547,7 @@ static int cgroup_migrate_prepare_dst(struct cgroup *dst_cgrp,
 	list_for_each_entry_safe(src_cset, tmp_cset, preloaded_csets, mg_preload_node) {
 		struct css_set *dst_cset;
 
-		dst_cset = find_css_set(src_cset,
-					dst_cgrp ?: src_cset->dfl_cgrp);
+		dst_cset = find_css_set(src_cset, src_cset->mg_dst_cgrp);
 		if (!dst_cset)
 			goto err;
 
@@ -2561,6 +2560,7 @@ static int cgroup_migrate_prepare_dst(struct cgroup *dst_cgrp,
 		 */
 		if (src_cset == dst_cset) {
 			src_cset->mg_src_cgrp = NULL;
+			src_cset->mg_dst_cgrp = NULL;
 			list_del_init(&src_cset->mg_preload_node);
 			put_css_set(src_cset);
 			put_css_set(dst_cset);
@@ -2657,7 +2657,7 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 	spin_unlock_bh(&css_set_lock);
 
 	/* prepare dst csets and commit */
-	ret = cgroup_migrate_prepare_dst(dst_cgrp, &preloaded_csets);
+	ret = cgroup_migrate_prepare_dst(&preloaded_csets);
 	if (!ret)
 		ret = cgroup_migrate(leader, threadgroup, dst_cgrp->root);
 
@@ -2916,7 +2916,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	spin_unlock_bh(&css_set_lock);
 
 	/* NULL dst indicates self on default hierarchy */
-	ret = cgroup_migrate_prepare_dst(NULL, &preloaded_csets);
+	ret = cgroup_migrate_prepare_dst(&preloaded_csets);
 	if (ret)
 		goto out_finish;
 
@@ -4156,7 +4156,7 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 		cgroup_migrate_add_src(link->cset, to, &preloaded_csets);
 	spin_unlock_bh(&css_set_lock);
 
-	ret = cgroup_migrate_prepare_dst(to, &preloaded_csets);
+	ret = cgroup_migrate_prepare_dst(&preloaded_csets);
 	if (ret)
 		goto out_err;
 
-- 
2.5.0

