From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 5/6] cgroup: remove synchronize_rcu() from cgroup_diput()
Date: Thu, 17 Jan 2013 16:04:42 +0800
Message-ID: <50F7B09A.7040600@huawei.com>
References: <50F7B040.2020906@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50F7B040.2020906@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Free cgroup via call_rcu(). The actual work is done through workqueue.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h |  1 +
 kernel/cgroup.c        | 73 ++++++++++++++++++++++++++++++--------------------
 2 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 8118a31..900af59 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -203,6 +203,7 @@ struct cgroup {
 
 	/* For RCU-protected deletion */
 	struct rcu_head rcu_head;
+	struct work_struct free_work;
 
 	/* List of events which userspace want to receive */
 	struct list_head event_list;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d7fefeb..83ac78b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -852,12 +852,52 @@ static struct inode *cgroup_new_inode(umode_t mode, struct super_block *sb)
 	return inode;
 }
 
+static void cgroup_free_fn(struct work_struct *work)
+{
+	struct cgroup *cgrp = container_of(work, struct cgroup, free_work);
+	struct cgroup_subsys *ss;
+
+	mutex_lock(&cgroup_mutex);
+	/*
+	 * Release the subsystem state objects.
+	 */
+	for_each_subsys(cgrp->root, ss)
+		ss->css_free(cgrp);
+
+	cgrp->root->number_of_cgroups--;
+	mutex_unlock(&cgroup_mutex);
+
+	/*
+	 * Drop the active superblock reference that we took when we
+	 * created the cgroup
+	 */
+	deactivate_super(cgrp->root->sb);
+
+	/*
+	 * if we're getting rid of the cgroup, refcount should ensure
+	 * that there are no pidlists left.
+	 */
+	BUG_ON(!list_empty(&cgrp->pidlists));
+
+	simple_xattrs_free(&cgrp->xattrs);
+
+	ida_simple_remove(&cgrp->root->cgroup_ida, cgrp->id);
+	kfree(cgrp);
+}
+
+static void cgroup_free_rcu(struct rcu_head *head)
+{
+	struct cgroup *cgrp = container_of(head, struct cgroup, rcu_head);
+
+	schedule_work(&cgrp->free_work);
+}
+
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 {
 	/* is dentry a directory ? if so, kfree() associated cgroup */
 	if (S_ISDIR(inode->i_mode)) {
 		struct cgroup *cgrp = dentry->d_fsdata;
-		struct cgroup_subsys *ss;
+
 		BUG_ON(!(cgroup_is_removed(cgrp)));
 		/* It's possible for external users to be holding css
 		 * reference counts on a cgroup; css_put() needs to
@@ -865,34 +905,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		 * the reference count in order to know if it needs to
 		 * queue the cgroup to be handled by the release
 		 * agent */
-		synchronize_rcu();
-
-		mutex_lock(&cgroup_mutex);
-		/*
-		 * Release the subsystem state objects.
-		 */
-		for_each_subsys(cgrp->root, ss)
-			ss->css_free(cgrp);
-
-		cgrp->root->number_of_cgroups--;
-		mutex_unlock(&cgroup_mutex);
-
-		/*
-		 * Drop the active superblock reference that we took when we
-		 * created the cgroup
-		 */
-		deactivate_super(cgrp->root->sb);
-
-		/*
-		 * if we're getting rid of the cgroup, refcount should ensure
-		 * that there are no pidlists left.
-		 */
-		BUG_ON(!list_empty(&cgrp->pidlists));
-
-		simple_xattrs_free(&cgrp->xattrs);
-
-		ida_simple_remove(&cgrp->root->cgroup_ida, cgrp->id);
-		kfree(cgrp);
+		call_rcu(&cgrp->rcu_head, cgroup_free_rcu);
 	} else {
 		struct cfent *cfe = __d_cfe(dentry);
 		struct cgroup *cgrp = dentry->d_parent->d_fsdata;
@@ -4163,6 +4176,8 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	if (test_bit(CGRP_CPUSET_CLONE_CHILDREN, &parent->flags))
 		set_bit(CGRP_CPUSET_CLONE_CHILDREN, &cgrp->flags);
 
+	INIT_WORK(&cgrp->free_work, cgroup_free_fn);
+
 	for_each_subsys(root, ss) {
 		struct cgroup_subsys_state *css;
 
-- 
1.8.0.2
