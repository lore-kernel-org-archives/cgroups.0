From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/8] cgroup: generalize obtaining the handles of and notifying cgroup files
Date: Tue, 11 Aug 2015 13:58:08 -0400
Message-ID: <1439315889-3492-8-git-send-email-tj@kernel.org>
References: <1439315889-3492-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Mik9aFN62qlZuKrjeDC7qlPqDcpcnfjFpwRMvgZ7Ubk=;
        b=0RmbztZlBT7/kW5d+1j+UnAYQwCihnPqUFzl7g+dp6fsjmwGiK053gi1R1QAd6sg5Z
         HUqJH6WuVoj8hF5yQWY9RfnCX5LrSV4hiJ36S5tXKO6KH/KBhQ2zLcVIf0IJDW2ypxaU
         yLPey/Og0C2JPA5s+CSVlS7kb+FhajIEupRu5ADyFguCWVHnqr+xWk1mh4RSCpv5wXet
         eU76aRTLv5O5wNCykT8YGIHQNZnuoFcpcKdxKBh48Yt0IbPgfS3zdkHPOs/jrH1am05O
         NiSd/4Yf65jcBGErUAdD2u+Kin8RHmoHvsRL3lNpaR467j4BDE7jkF8m0hEQvI31T9+Z
         S7BA==
In-Reply-To: <1439315889-3492-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, lizefan@huawei.com
Cc: mhocko@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

cgroup core handles creations and removals of cgroup interface files
as described by cftypes.  There are cases where the handle for a given
file instance is necessary, for example, to generate a file modified
event.  Currently, this is handled by explicitly matching the callback
method pointer and storing the file handle manually in
cgroup_add_file().  While this simple approach works for cgroup core
files, it can't for controller interface files.

This patch generalizes cgroup interface file handle handling.  struct
cgroup_file is defined and each cftype can optionally tell cgroup core
to store the file handle by setting ->file_offset.  A file handle
remains accessible as long as the containing css is accessible.

Both "cgroup.procs" and "cgroup.events" are converted to use the new
generic mechanism instead of hooking directly into cgroup_add_file().
Also, cgroup_file_notify() which takes a struct cgroup_file and
generates a file modified event on it is added and replaces explicit
kernfs_notify() invocations.

This generalizes cgroup file handle handling and allows controllers to
generate file modified notifications.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/cgroup-defs.h | 26 ++++++++++++++++++++++++--
 include/linux/cgroup.h      | 13 +++++++++++++
 kernel/cgroup.c             | 26 +++++++++++++++++++-------
 3 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 93f48ca..cc5898a 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -84,6 +84,17 @@ enum {
 };
 
 /*
+ * cgroup_file is the handle for a file instance created in a cgroup which
+ * is used, for example, to generate file changed notifications.  This can
+ * be obtained by setting cftype->file_offset.
+ */
+struct cgroup_file {
+	/* do not access any fields from outside cgroup core */
+	struct list_head node;			/* anchored at css->files */
+	struct kernfs_node *kn;
+};
+
+/*
  * Per-subsystem/per-cgroup state maintained by the system.  This is the
  * fundamental structural building block that controllers deal with.
  *
@@ -123,6 +134,9 @@ struct cgroup_subsys_state {
 	 */
 	u64 serial_nr;
 
+	/* all cgroup_files associated with this css */
+	struct list_head files;
+
 	/* percpu_ref killing and RCU release */
 	struct rcu_head rcu_head;
 	struct work_struct destroy_work;
@@ -226,8 +240,8 @@ struct cgroup {
 	int populated_cnt;
 
 	struct kernfs_node *kn;		/* cgroup kernfs entry */
-	struct kernfs_node *procs_kn;	/* kn for "cgroup.procs" */
-	struct kernfs_node *events_kn;	/* kn for "cgroup.events" */
+	struct cgroup_file procs_file;	/* handle for "cgroup.procs" */
+	struct cgroup_file events_file;	/* handle for "cgroup.events" */
 
 	/*
 	 * The bitmask of subsystems enabled on the child cgroups.
@@ -336,6 +350,14 @@ struct cftype {
 	unsigned int flags;
 
 	/*
+	 * If non-zero, should contain the offset from the start of css to
+	 * a struct cgroup_file field.  cgroup will record the handle of
+	 * the created file into it.  The recorded handle can be used as
+	 * long as the containing css remains accessible.
+	 */
+	unsigned int file_offset;
+
+	/*
 	 * Fields used for internal bookkeeping.  Initialized automatically
 	 * during registration.
 	 */
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index eb7ca55..00ddf3c 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -527,6 +527,19 @@ static inline void pr_cont_cgroup_path(struct cgroup *cgrp)
 	pr_cont_kernfs_path(cgrp->kn);
 }
 
+/**
+ * cgroup_file_notify - generate a file modified event for a cgroup_file
+ * @cfile: target cgroup_file
+ *
+ * @cfile must have been obtained by setting cftype->file_offset.
+ */
+static inline void cgroup_file_notify(struct cgroup_file *cfile)
+{
+	/* might not have been created due to one of the CFTYPE selector flags */
+	if (cfile->kn)
+		kernfs_notify(cfile->kn);
+}
+
 #else /* !CONFIG_CGROUPS */
 
 struct cgroup_subsys_state;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b287522..4d0d522 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -520,8 +520,8 @@ static void cgroup_update_populated(struct cgroup *cgrp, bool populated)
 		if (!trigger)
 			break;
 
-		if (cgrp->events_kn)
-			kernfs_notify(cgrp->events_kn);
+		cgroup_file_notify(&cgrp->events_file);
+
 		cgrp = cgroup_parent(cgrp);
 	} while (cgrp);
 }
@@ -1671,6 +1671,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 
 	INIT_LIST_HEAD(&cgrp->self.sibling);
 	INIT_LIST_HEAD(&cgrp->self.children);
+	INIT_LIST_HEAD(&cgrp->self.files);
 	INIT_LIST_HEAD(&cgrp->cset_links);
 	INIT_LIST_HEAD(&cgrp->pidlists);
 	mutex_init(&cgrp->pidlist_mutex);
@@ -2462,7 +2463,7 @@ static int cgroup_procs_write_permission(struct task_struct *task,
 			cgrp = cgroup_parent(cgrp);
 
 		ret = -ENOMEM;
-		inode = kernfs_get_inode(sb, cgrp->procs_kn);
+		inode = kernfs_get_inode(sb, cgrp->procs_file.kn);
 		if (inode) {
 			ret = inode_permission(inode, MAY_WRITE);
 			iput(inode);
@@ -3152,10 +3153,14 @@ static int cgroup_add_file(struct cgroup_subsys_state *css, struct cgroup *cgrp,
 		return ret;
 	}
 
-	if (cft->write == cgroup_procs_write)
-		cgrp->procs_kn = kn;
-	else if (cft->seq_show == cgroup_events_show)
-		cgrp->events_kn = kn;
+	if (cft->file_offset) {
+		struct cgroup_file *cfile = (void *)css + cft->file_offset;
+
+		kernfs_get(kn);
+		cfile->kn = kn;
+		list_add(&cfile->node, &css->files);
+	}
+
 	return 0;
 }
 
@@ -4307,6 +4312,7 @@ static int cgroup_clone_children_write(struct cgroup_subsys_state *css,
 static struct cftype cgroup_dfl_base_files[] = {
 	{
 		.name = "cgroup.procs",
+		.file_offset = offsetof(struct cgroup, procs_file),
 		.seq_start = cgroup_pidlist_start,
 		.seq_next = cgroup_pidlist_next,
 		.seq_stop = cgroup_pidlist_stop,
@@ -4332,6 +4338,7 @@ static struct cftype cgroup_dfl_base_files[] = {
 	{
 		.name = "cgroup.events",
 		.flags = CFTYPE_NOT_ON_ROOT,
+		.file_offset = offsetof(struct cgroup, events_file),
 		.seq_show = cgroup_events_show,
 	},
 	{ }	/* terminate */
@@ -4410,9 +4417,13 @@ static void css_free_work_fn(struct work_struct *work)
 		container_of(work, struct cgroup_subsys_state, destroy_work);
 	struct cgroup_subsys *ss = css->ss;
 	struct cgroup *cgrp = css->cgroup;
+	struct cgroup_file *cfile;
 
 	percpu_ref_exit(&css->refcnt);
 
+	list_for_each_entry(cfile, &css->files, node)
+		kernfs_put(cfile->kn);
+
 	if (ss) {
 		/* css free path */
 		int id = css->id;
@@ -4517,6 +4528,7 @@ static void init_and_link_css(struct cgroup_subsys_state *css,
 	css->ss = ss;
 	INIT_LIST_HEAD(&css->sibling);
 	INIT_LIST_HEAD(&css->children);
+	INIT_LIST_HEAD(&css->files);
 	css->serial_nr = css_serial_nr_next++;
 
 	if (cgroup_parent(cgrp)) {
-- 
2.4.3
