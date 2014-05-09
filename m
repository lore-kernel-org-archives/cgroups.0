From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/9] cgroup: rename cgroup->dummy_css to ->self and move it to the top
Date: Fri,  9 May 2014 17:13:28 -0400
Message-ID: <1399670015-23463-3-git-send-email-tj@kernel.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TVOXUeC+nddMvSy3ufls3J0jNQltvk1sbXGOwQJ+Vxw=;
        b=QchkKQ4Fbsd9weXHYkLPtuRgzvTy33qYArAFNDl1vKACfhdJiXqgQAeAmD8mZTUNWc
         JYb3vngXHf4WLJcNix+DAXhMhNE8trtTlKksaB7+yOoP4fEiB9ZPOhi79THti9AcGykW
         FHjrw0zfI3OIt3ezL5UsHsXSV+h+mIgjrYEbmoNN4JVxpQ+Ya9wuB8fS8E+HvwwGumik
         rLzixmuklPvGKwdliTRoZzFqwdUxTCe7v5KBtTkPQO60wvjqkht00qxy3wF3oG3ULvKL
         rwdcO2b+FlMCaQNKbeophpkEKgVkjQJ0WETKGNH/bkJeykhpUgzJtnvpsum5t16xahuz
         5utQ==
In-Reply-To: <1399670015-23463-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

cgroup->dummy_css is used as the placeholder css when performing css
oriended operations on the cgroup.  We're gonna shift more cgroup
management to this css.  Let's rename it to ->self and move it to the
top.

This is pure rename and field relocation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  6 +++---
 kernel/cgroup.c        | 20 ++++++++++----------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index aa7353d..164851e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -143,6 +143,9 @@ enum {
 };
 
 struct cgroup {
+	/* self css with NULL ->ss, points back to this cgroup */
+	struct cgroup_subsys_state self;
+
 	unsigned long flags;		/* "unsigned long" so bitops work */
 
 	/*
@@ -224,9 +227,6 @@ struct cgroup {
 	struct list_head pidlists;
 	struct mutex pidlist_mutex;
 
-	/* dummy css with NULL ->ss, points back to this cgroup */
-	struct cgroup_subsys_state dummy_css;
-
 	/* For css percpu_ref killing and RCU-protected deletion */
 	struct rcu_head rcu_head;
 	struct work_struct destroy_work;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2755f33..b3708a8 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -220,7 +220,7 @@ static void cgroup_idr_remove(struct idr *idr, int id)
 /**
  * cgroup_css - obtain a cgroup's css for the specified subsystem
  * @cgrp: the cgroup of interest
- * @ss: the subsystem of interest (%NULL returns the dummy_css)
+ * @ss: the subsystem of interest (%NULL returns @cgrp->self)
  *
  * Return @cgrp's css (cgroup_subsys_state) associated with @ss.  This
  * function must be called either under cgroup_mutex or rcu_read_lock() and
@@ -235,13 +235,13 @@ static struct cgroup_subsys_state *cgroup_css(struct cgroup *cgrp,
 		return rcu_dereference_check(cgrp->subsys[ss->id],
 					lockdep_is_held(&cgroup_mutex));
 	else
-		return &cgrp->dummy_css;
+		return &cgrp->self;
 }
 
 /**
  * cgroup_e_css - obtain a cgroup's effective css for the specified subsystem
  * @cgrp: the cgroup of interest
- * @ss: the subsystem of interest (%NULL returns the dummy_css)
+ * @ss: the subsystem of interest (%NULL returns @cgrp->self)
  *
  * Similar to cgroup_css() but returns the effctive css, which is defined
  * as the matching css of the nearest ancestor including self which has @ss
@@ -254,7 +254,7 @@ static struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
 	lockdep_assert_held(&cgroup_mutex);
 
 	if (!ss)
-		return &cgrp->dummy_css;
+		return &cgrp->self;
 
 	if (!(cgrp->root->subsys_mask & (1 << ss->id)))
 		return NULL;
@@ -288,7 +288,7 @@ struct cgroup_subsys_state *of_css(struct kernfs_open_file *of)
 	if (cft->ss)
 		return rcu_dereference_raw(cgrp->subsys[cft->ss->id]);
 	else
-		return &cgrp->dummy_css;
+		return &cgrp->self;
 }
 EXPORT_SYMBOL_GPL(of_css);
 
@@ -1551,7 +1551,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	INIT_LIST_HEAD(&cgrp->release_list);
 	INIT_LIST_HEAD(&cgrp->pidlists);
 	mutex_init(&cgrp->pidlist_mutex);
-	cgrp->dummy_css.cgroup = cgrp;
+	cgrp->self.cgroup = cgrp;
 
 	for_each_subsys(ss, ssid)
 		INIT_LIST_HEAD(&cgrp->e_csets[ssid]);
@@ -3453,7 +3453,7 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 	 * ->can_attach() fails.
 	 */
 	do {
-		css_task_iter_start(&from->dummy_css, &it);
+		css_task_iter_start(&from->self, &it);
 		task = css_task_iter_next(&it);
 		if (task)
 			get_task_struct(task);
@@ -3718,7 +3718,7 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 	if (!array)
 		return -ENOMEM;
 	/* now, populate the array */
-	css_task_iter_start(&cgrp->dummy_css, &it);
+	css_task_iter_start(&cgrp->self, &it);
 	while ((tsk = css_task_iter_next(&it))) {
 		if (unlikely(n == length))
 			break;
@@ -3792,7 +3792,7 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 	}
 	rcu_read_unlock();
 
-	css_task_iter_start(&cgrp->dummy_css, &it);
+	css_task_iter_start(&cgrp->self, &it);
 	while ((tsk = css_task_iter_next(&it))) {
 		switch (tsk->state) {
 		case TASK_RUNNING:
@@ -4273,7 +4273,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	init_cgroup_housekeeping(cgrp);
 
 	cgrp->parent = parent;
-	cgrp->dummy_css.parent = &parent->dummy_css;
+	cgrp->self.parent = &parent->self;
 	cgrp->root = root;
 
 	if (notify_on_release(parent))
-- 
1.9.0
