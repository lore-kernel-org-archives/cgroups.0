From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.4-fixes] cgroup: fix cftype->file_offset handling
Date: Thu, 5 Nov 2015 00:12:24 -0500
Message-ID: <20151105051224.GA4914@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=5hjRP2MK08SzNBj7Vx+uWwxCx+LbMFDTV5wmCcDlY+U=;
        b=UeFmicc4V9XilE8243fjp5ii/qKtLCsDH4ERTe5mPnCiNVNF1p2k4pcp0J4aKnl8cM
         rf6oc7OyMVgIq1KZezUPC4kvmlDtSVVKABj+7d+9IgtX5X1tPSe/5yZ0CnXZJUbtU9df
         ygvXqYLjbe3dMahzytsjtqJfLzlOS/KcoXM3+KkOxkl3BBW54KCDfbIPRiCztXlYhuT9
         6gNd/1hEfj46Zpa36Fe+Gcp8FKdSl2/nrz3rNS8OHHqVV9ruqTbHBW4n7AuuiVb9sVV8
         qFLrL/6rXBsL0SbfHh7csZJbtly5E704pu+sAxgJu4WoqPwf/kgXF7MK+Vvr4yXOvE1o
         CL+g==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Sedgwick <jsedgwick-b10kYP2dOMg@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

6f60eade2433 ("cgroup: generalize obtaining the handles of and
notifying cgroup files") introduced cftype->file_offset so that the
handles for per-css file instances can be recorded.  These handles
then can be used, for example, to generate file modified
notifications.

Unfortunately, it made the wrong assumption that files are created
once for a given css and removed on its destruction.  Due to the
dependencies among subsystems, a css may be hidden from userland and
then later shown again.  This is implemented by removing and
re-creating the affected files, so the associated kernfs_node for a
given cgroup file may change over time.  This incorrect assumption led
to the corruption of css->files lists.

Reimplement cftype->file_offset handling so that cgroup_file->kn is
protected by a lock and updated as files are created and destroyed.
This also makes keeping them on per-cgroup list unnecessary.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: James Sedgwick <jsedgwick-b10kYP2dOMg@public.gmane.org>
Fixes: 6f60eade2433 ("cgroup: generalize obtaining the handles of and notifying cgroup files")
---
 include/linux/cgroup-defs.h |    4 ----
 include/linux/cgroup.h      |   14 +-------------
 kernel/cgroup.c             |   42 ++++++++++++++++++++++++++++++++++--------
 3 files changed, 35 insertions(+), 25 deletions(-)

--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -90,7 +90,6 @@ enum {
  */
 struct cgroup_file {
 	/* do not access any fields from outside cgroup core */
-	struct list_head node;			/* anchored at css->files */
 	struct kernfs_node *kn;
 };
 
@@ -134,9 +133,6 @@ struct cgroup_subsys_state {
 	 */
 	u64 serial_nr;
 
-	/* all cgroup_files associated with this css */
-	struct list_head files;
-
 	/* percpu_ref killing and RCU release */
 	struct rcu_head rcu_head;
 	struct work_struct destroy_work;
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -88,6 +88,7 @@ int cgroup_transfer_tasks(struct cgroup
 int cgroup_add_dfl_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 int cgroup_rm_cftypes(struct cftype *cfts);
+void cgroup_file_notify(struct cgroup_file *cfile);
 
 char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
 int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry);
@@ -516,19 +517,6 @@ static inline void pr_cont_cgroup_path(s
 	pr_cont_kernfs_path(cgrp->kn);
 }
 
-/**
- * cgroup_file_notify - generate a file modified event for a cgroup_file
- * @cfile: target cgroup_file
- *
- * @cfile must have been obtained by setting cftype->file_offset.
- */
-static inline void cgroup_file_notify(struct cgroup_file *cfile)
-{
-	/* might not have been created due to one of the CFTYPE selector flags */
-	if (cfile->kn)
-		kernfs_notify(cfile->kn);
-}
-
 #else /* !CONFIG_CGROUPS */
 
 struct cgroup_subsys_state;
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -98,6 +98,12 @@ static DEFINE_SPINLOCK(css_set_lock);
 static DEFINE_SPINLOCK(cgroup_idr_lock);
 
 /*
+ * Protects cgroup_file->kn for !self csses.  It synchronizes notifications
+ * against file removal/re-creation across css hiding.
+ */
+static DEFINE_SPINLOCK(cgroup_file_kn_lock);
+
+/*
  * Protects cgroup_subsys->release_agent_path.  Modifying it also requires
  * cgroup_mutex.  Reading requires either cgroup_mutex or this spinlock.
  */
@@ -1393,6 +1399,16 @@ static void cgroup_rm_file(struct cgroup
 	char name[CGROUP_FILE_NAME_MAX];
 
 	lockdep_assert_held(&cgroup_mutex);
+
+	if (cft->file_offset) {
+		struct cgroup_subsys_state *css = cgroup_css(cgrp, cft->ss);
+		struct cgroup_file *cfile = (void *)css + cft->file_offset;
+
+		spin_lock_irq(&cgroup_file_kn_lock);
+		cfile->kn = NULL;
+		spin_unlock_irq(&cgroup_file_kn_lock);
+	}
+
 	kernfs_remove_by_name(cgrp->kn, cgroup_file_name(cgrp, cft, name));
 }
 
@@ -1856,7 +1872,6 @@ static void init_cgroup_housekeeping(str
 
 	INIT_LIST_HEAD(&cgrp->self.sibling);
 	INIT_LIST_HEAD(&cgrp->self.children);
-	INIT_LIST_HEAD(&cgrp->self.files);
 	INIT_LIST_HEAD(&cgrp->cset_links);
 	INIT_LIST_HEAD(&cgrp->pidlists);
 	mutex_init(&cgrp->pidlist_mutex);
@@ -3313,9 +3328,9 @@ static int cgroup_add_file(struct cgroup
 	if (cft->file_offset) {
 		struct cgroup_file *cfile = (void *)css + cft->file_offset;
 
-		kernfs_get(kn);
+		spin_lock_irq(&cgroup_file_kn_lock);
 		cfile->kn = kn;
-		list_add(&cfile->node, &css->files);
+		spin_unlock_irq(&cgroup_file_kn_lock);
 	}
 
 	return 0;
@@ -3553,6 +3568,22 @@ int cgroup_add_legacy_cftypes(struct cgr
 }
 
 /**
+ * cgroup_file_notify - generate a file modified event for a cgroup_file
+ * @cfile: target cgroup_file
+ *
+ * @cfile must have been obtained by setting cftype->file_offset.
+ */
+void cgroup_file_notify(struct cgroup_file *cfile)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cgroup_file_kn_lock, flags);
+	if (cfile->kn)
+		kernfs_notify(cfile->kn);
+	spin_unlock_irqrestore(&cgroup_file_kn_lock, flags);
+}
+
+/**
  * cgroup_task_count - count the number of tasks in a cgroup.
  * @cgrp: the cgroup in question
  *
@@ -4613,13 +4644,9 @@ static void css_free_work_fn(struct work
 		container_of(work, struct cgroup_subsys_state, destroy_work);
 	struct cgroup_subsys *ss = css->ss;
 	struct cgroup *cgrp = css->cgroup;
-	struct cgroup_file *cfile;
 
 	percpu_ref_exit(&css->refcnt);
 
-	list_for_each_entry(cfile, &css->files, node)
-		kernfs_put(cfile->kn);
-
 	if (ss) {
 		/* css free path */
 		int id = css->id;
@@ -4724,7 +4751,6 @@ static void init_and_link_css(struct cgr
 	css->ss = ss;
 	INIT_LIST_HEAD(&css->sibling);
 	INIT_LIST_HEAD(&css->children);
-	INIT_LIST_HEAD(&css->files);
 	css->serial_nr = css_serial_nr_next++;
 
 	if (cgroup_parent(cgrp)) {
