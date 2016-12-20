From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/8] cgroup: rename functions for consistency
Date: Tue, 20 Dec 2016 16:08:26 -0500
Message-ID: <20161220210827.11176-8-tj@kernel.org>
References: <20161220210827.11176-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7jgBLYUnBeH6Lh+4a5n+eSWquVkfL915yfyhe8SPa20=;
        b=WMI/B0aODLX0IM7R4unC2PK6FboLOUV1l9oHScWSuJ25kBebgnlP1RMGRzER9R5LY6
         /UVfeIGwt9dyAlgjcmQ588c8D0rgjnfUGCjZ+prqUO0LS0vZH+7kGd3v931Kk3U2hQ/h
         XSyjTycZ0WGvfOp6hN/rIV1I4vKgU/or+2Kn5rU4xyy/Gb+vbijSbShKwqe9jJXO8bxT
         sdPex07KJBBQ2YDYvNyyQcNASZKzdhaeJbEmTdInUUHb1lKUTYHGmrob75CpX5ajVsDX
         AFnecpwjVfEPefym1Dt8mjhBW0PKIYR3DaAhIF01iSd1PCiEcwUUNb/J86+APdTLJ3T9
         trQQ==
In-Reply-To: <20161220210827.11176-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Now that v1 functions are separated out, rename some functions for
consistency.

 cgroup_dfl_base_files		-> cgroup_base_files
 cgroup_legacy_base_files	-> cgroup1_base_files
 cgroup_ssid_no_v1()		-> cgroup1_ssid_disabled()
 cgroup_pidlist_destroy_all	-> cgroup1_pidlist_destroy_all()
 cgroup_release_agent()		-> cgroup1_release_agent()
 check_for_release()		-> cgroup1_check_for_release()

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/cgroup-internal.h | 10 +++++-----
 kernel/cgroup/cgroup-v1.c       | 14 +++++++-------
 kernel/cgroup/cgroup.c          | 22 +++++++++++-----------
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 3d431b6..2020d8d 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -108,14 +108,14 @@ int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
 /*
  * cgroup-v1.c
  */
-extern struct cftype cgroup_legacy_base_files[];
+extern struct cftype cgroup1_base_files[];
 extern const struct file_operations proc_cgroupstats_operations;
 extern struct kernfs_syscall_ops cgroup1_kf_syscall_ops;
 
-bool cgroup_ssid_no_v1(int ssid);
-void cgroup_pidlist_destroy_all(struct cgroup *cgrp);
-void cgroup_release_agent(struct work_struct *work);
-void check_for_release(struct cgroup *cgrp);
+bool cgroup1_ssid_disabled(int ssid);
+void cgroup1_pidlist_destroy_all(struct cgroup *cgrp);
+void cgroup1_release_agent(struct work_struct *work);
+void cgroup1_check_for_release(struct cgroup *cgrp);
 struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
 			     void *data, unsigned long magic,
 			     struct cgroup_namespace *ns);
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index ae240c0..37be09e 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -36,7 +36,7 @@ static struct workqueue_struct *cgroup_pidlist_destroy_wq;
  */
 static DEFINE_SPINLOCK(release_agent_path_lock);
 
-bool cgroup_ssid_no_v1(int ssid)
+bool cgroup1_ssid_disabled(int ssid)
 {
 	return cgroup_no_v1_mask & (1 << ssid);
 }
@@ -201,7 +201,7 @@ static void pidlist_free(void *p)
  * Used to destroy all pidlists lingering waiting for destroy timer.  None
  * should be left afterwards.
  */
-void cgroup_pidlist_destroy_all(struct cgroup *cgrp)
+void cgroup1_pidlist_destroy_all(struct cgroup *cgrp)
 {
 	struct cgroup_pidlist *l, *tmp_l;
 
@@ -585,7 +585,7 @@ static int cgroup_clone_children_write(struct cgroup_subsys_state *css,
 }
 
 /* cgroup core interface files for the legacy hierarchies */
-struct cftype cgroup_legacy_base_files[] = {
+struct cftype cgroup1_base_files[] = {
 	{
 		.name = "cgroup.procs",
 		.seq_start = cgroup_pidlist_start,
@@ -729,7 +729,7 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 	return 0;
 }
 
-void check_for_release(struct cgroup *cgrp)
+void cgroup1_check_for_release(struct cgroup *cgrp)
 {
 	if (notify_on_release(cgrp) && !cgroup_is_populated(cgrp) &&
 	    !css_has_online_children(&cgrp->self) && !cgroup_is_dead(cgrp))
@@ -759,7 +759,7 @@ void check_for_release(struct cgroup *cgrp)
  * this routine has no use for the exit status of the release agent
  * task, so no sense holding our caller up for that.
  */
-void cgroup_release_agent(struct work_struct *work)
+void cgroup1_release_agent(struct work_struct *work)
 {
 	struct cgroup *cgrp =
 		container_of(work, struct cgroup, release_agent_work);
@@ -946,7 +946,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 				continue;
 			if (!cgroup_ssid_enabled(i))
 				continue;
-			if (cgroup_ssid_no_v1(i))
+			if (cgroup1_ssid_disabled(i))
 				continue;
 
 			/* Mutually exclusive option 'all' + subsystem name */
@@ -968,7 +968,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 	 */
 	if (all_ss || (!one_ss && !opts->none && !opts->name))
 		for_each_subsys(ss, i)
-			if (cgroup_ssid_enabled(i) && !cgroup_ssid_no_v1(i))
+			if (cgroup_ssid_enabled(i) && !cgroup1_ssid_disabled(i))
 				opts->subsys_mask |= (1 << i);
 
 	/*
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ae25f14..dcfbeb6 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -201,7 +201,7 @@ struct cgroup_namespace init_cgroup_ns = {
 static u16 have_canfork_callback __read_mostly;
 
 static struct file_system_type cgroup2_fs_type;
-static struct cftype cgroup_dfl_base_files[];
+static struct cftype cgroup_base_files[];
 
 static int cgroup_apply_control(struct cgroup *cgrp);
 static void cgroup_finalize_control(struct cgroup *cgrp, int ret);
@@ -611,7 +611,7 @@ static void cgroup_update_populated(struct cgroup *cgrp, bool populated)
 		if (!trigger)
 			break;
 
-		check_for_release(cgrp);
+		cgroup1_check_for_release(cgrp);
 		cgroup_file_notify(&cgrp->events_file);
 
 		cgrp = cgroup_parent(cgrp);
@@ -1442,9 +1442,9 @@ static int css_populate_dir(struct cgroup_subsys_state *css)
 
 	if (!css->ss) {
 		if (cgroup_on_dfl(cgrp))
-			cfts = cgroup_dfl_base_files;
+			cfts = cgroup_base_files;
 		else
-			cfts = cgroup_legacy_base_files;
+			cfts = cgroup1_base_files;
 
 		return cgroup_addrm_files(&cgrp->self, cgrp, cfts, true);
 	}
@@ -1647,7 +1647,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 		INIT_LIST_HEAD(&cgrp->e_csets[ssid]);
 
 	init_waitqueue_head(&cgrp->offline_waitq);
-	INIT_WORK(&cgrp->release_agent_work, cgroup_release_agent);
+	INIT_WORK(&cgrp->release_agent_work, cgroup1_release_agent);
 }
 
 void init_cgroup_root(struct cgroup_root *root, struct cgroup_sb_opts *opts)
@@ -3838,7 +3838,7 @@ static int cgroup_procs_show(struct seq_file *s, void *v)
 }
 
 /* cgroup core interface files for the default hierarchy */
-static struct cftype cgroup_dfl_base_files[] = {
+static struct cftype cgroup_base_files[] = {
 	{
 		.name = "cgroup.procs",
 		.file_offset = offsetof(struct cgroup, procs_file),
@@ -3911,7 +3911,7 @@ static void css_free_work_fn(struct work_struct *work)
 	} else {
 		/* cgroup free path */
 		atomic_dec(&cgrp->root->nr_cgrps);
-		cgroup_pidlist_destroy_all(cgrp);
+		cgroup1_pidlist_destroy_all(cgrp);
 		cancel_work_sync(&cgrp->release_agent_work);
 
 		if (cgroup_parent(cgrp)) {
@@ -4413,7 +4413,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 */
 	kernfs_remove(cgrp->kn);
 
-	check_for_release(cgroup_parent(cgrp));
+	cgroup1_check_for_release(cgroup_parent(cgrp));
 
 	/* put the base reference */
 	percpu_ref_kill(&cgrp->self.refcnt);
@@ -4550,8 +4550,8 @@ int __init cgroup_init(void)
 
 	BUILD_BUG_ON(CGROUP_SUBSYS_COUNT > 16);
 	BUG_ON(percpu_init_rwsem(&cgroup_threadgroup_rwsem));
-	BUG_ON(cgroup_init_cftypes(NULL, cgroup_dfl_base_files));
-	BUG_ON(cgroup_init_cftypes(NULL, cgroup_legacy_base_files));
+	BUG_ON(cgroup_init_cftypes(NULL, cgroup_base_files));
+	BUG_ON(cgroup_init_cftypes(NULL, cgroup1_base_files));
 
 	/*
 	 * The latency of the synchronize_sched() is too high for cgroups,
@@ -4601,7 +4601,7 @@ int __init cgroup_init(void)
 			continue;
 		}
 
-		if (cgroup_ssid_no_v1(ssid))
+		if (cgroup1_ssid_disabled(ssid))
 			printk(KERN_INFO "Disabling %s control group subsystem in v1 mounts\n",
 			       ss->name);
 
-- 
2.9.3

