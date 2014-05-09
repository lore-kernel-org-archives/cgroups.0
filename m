From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 9/9] cgroup: use cgroup->self.refcnt for cgroup refcnting
Date: Fri,  9 May 2014 17:13:35 -0400
Message-ID: <1399670015-23463-10-git-send-email-tj@kernel.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SluV4ZpUs0AVUMUNbaPDExbBvZZV9RceNL98lrGguNk=;
        b=rgbulYqpx375Yk4mcGkf2EpzD/Wuv14Ez/6YAAW/FWxgXAgYGQ2X091D0OhkqeFv7L
         Fgc2b6WEFlq3gaNMGlZpFNH+tBK2iSQH7dRIBAuhiJt7Pv/DydUyjWulluqpwDUV6Bk+
         uib2lPYIuZHIvfRKHXSh7+jOcwTMKMfPCDCRuLhC+KKgRcrP0Qn8gJydBf4Lk3V/P3x2
         MXFxGRn9em198EKsrkKJM0g6SsD9JJfuMOPphAklofwo9pGMeLJlcH36T0quoii0Il0d
         glUU/DzsDDMNNTKWNB1rVt+YhDRFR1j6uTzSx1XqfXU2xGalEgHaOhis99j9Nd6rweTj
         R2Eg==
In-Reply-To: <1399670015-23463-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Currently cgroup implements refcnting separately using atomic_t
cgroup->refcnt.  The destruction paths of cgroup and css are rather
complex and bear a lot of similiarities including the use of RCU and
bouncing to a work item.

This patch makes cgroup use the refcnt of self css for refcnting
instead of using its own.  This makes cgroup refcnting use css's
percpu refcnt and share the destruction mechanism.

* css_release_work_fn() and css_free_work_fn() are updated to handle
  both csses and cgroups.  This is a bit messy but should do until we
  can make cgroup->self a full css, which currently can't be done
  thanks to multiple hierarchies.

* cgroup_destroy_locked() now performs
  percpu_ref_kill(&cgrp->self.refcnt) instead of cgroup_put(cgrp).

* Negative refcnt sanity check in cgroup_get() is no longer necessary
  as percpu_ref already handles it.

* Similarly, as a cgroup which hasn't been killed will never be
  released regardless of its refcnt value and percpu_ref has sanity
  check on kill, cgroup_is_dead() sanity check in cgroup_put() is no
  longer necessary.

* As whether a refcnt reached zero or not can only be decided after
  the reference count is killed, cgroup_root->cgrp's refcnting can no
  longer be used to decide whether to kill the root or not.  Let's
  make cgroup_kill_sb() explicitly initiate destruction if the root
  doesn't have any children.  This makes sense anyway as unmounted
  cgroup hierarchy without any children should be destroyed.

While this is a bit messy, this will allow pushing more bookkeeping
towards cgroup->self and thus handling cgroups and csses in more
uniform way.  In the very long term, it should be possible to
introduce a base subsystem and convert the self css to a proper one
making things whole lot simpler and unified.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |   6 --
 kernel/cgroup.c        | 146 +++++++++++++++++++++++++++----------------------
 2 files changed, 80 insertions(+), 72 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 286e39e..76dadd77 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -160,8 +160,6 @@ struct cgroup {
 	 */
 	int populated_cnt;
 
-	atomic_t refcnt;
-
 	/*
 	 * We link our 'sibling' struct into our parent's 'children'.
 	 * Our children link their 'sibling' into our 'children'.
@@ -218,10 +216,6 @@ struct cgroup {
 	struct list_head pidlists;
 	struct mutex pidlist_mutex;
 
-	/* For css percpu_ref killing and RCU-protected deletion */
-	struct rcu_head rcu_head;
-	struct work_struct destroy_work;
-
 	/* used to wait for offlining of csses */
 	wait_queue_head_t offline_waitq;
 };
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5a31e61..64ff413 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -176,10 +176,12 @@ static int need_forkexit_callback __read_mostly;
 static struct cftype cgroup_base_files[];
 
 static void cgroup_put(struct cgroup *cgrp);
+static bool cgroup_has_live_children(struct cgroup *cgrp);
 static int rebind_subsystems(struct cgroup_root *dst_root,
 			     unsigned int ss_mask);
 static int cgroup_destroy_locked(struct cgroup *cgrp);
 static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss);
+static void css_release(struct percpu_ref *ref);
 static void kill_css(struct cgroup_subsys_state *css);
 static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 			      bool is_add);
@@ -1008,62 +1010,15 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
 	return mode;
 }
 
-static void cgroup_free_fn(struct work_struct *work)
-{
-	struct cgroup *cgrp = container_of(work, struct cgroup, destroy_work);
-
-	atomic_dec(&cgrp->root->nr_cgrps);
-	cgroup_pidlist_destroy_all(cgrp);
-
-	if (cgrp->parent) {
-		/*
-		 * We get a ref to the parent, and put the ref when this
-		 * cgroup is being freed, so it's guaranteed that the
-		 * parent won't be destroyed before its children.
-		 */
-		cgroup_put(cgrp->parent);
-		kernfs_put(cgrp->kn);
-		kfree(cgrp);
-	} else {
-		/*
-		 * This is root cgroup's refcnt reaching zero, which
-		 * indicates that the root should be released.
-		 */
-		cgroup_destroy_root(cgrp->root);
-	}
-}
-
-static void cgroup_free_rcu(struct rcu_head *head)
-{
-	struct cgroup *cgrp = container_of(head, struct cgroup, rcu_head);
-
-	INIT_WORK(&cgrp->destroy_work, cgroup_free_fn);
-	queue_work(cgroup_destroy_wq, &cgrp->destroy_work);
-}
-
 static void cgroup_get(struct cgroup *cgrp)
 {
 	WARN_ON_ONCE(cgroup_is_dead(cgrp));
-	WARN_ON_ONCE(atomic_read(&cgrp->refcnt) <= 0);
-	atomic_inc(&cgrp->refcnt);
+	css_get(&cgrp->self);
 }
 
 static void cgroup_put(struct cgroup *cgrp)
 {
-	if (!atomic_dec_and_test(&cgrp->refcnt))
-		return;
-	if (WARN_ON_ONCE(cgrp->parent && !cgroup_is_dead(cgrp)))
-		return;
-
-	/* delete this cgroup from parent->children */
-	mutex_lock(&cgroup_mutex);
-	list_del_rcu(&cgrp->sibling);
-	mutex_unlock(&cgroup_mutex);
-
-	cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
-	cgrp->id = -1;
-
-	call_rcu(&cgrp->rcu_head, cgroup_free_rcu);
+	css_put(&cgrp->self);
 }
 
 /**
@@ -1548,7 +1503,6 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	struct cgroup_subsys *ss;
 	int ssid;
 
-	atomic_set(&cgrp->refcnt, 1);
 	INIT_LIST_HEAD(&cgrp->sibling);
 	INIT_LIST_HEAD(&cgrp->children);
 	INIT_LIST_HEAD(&cgrp->cset_links);
@@ -1597,6 +1551,10 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned int ss_mask)
 		goto out;
 	root_cgrp->id = ret;
 
+	ret = percpu_ref_init(&root_cgrp->self.refcnt, css_release);
+	if (ret)
+		goto out;
+
 	/*
 	 * We're accessing css_set_count without locking css_set_rwsem here,
 	 * but that's OK - it can only be increased by someone holding
@@ -1605,11 +1563,11 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned int ss_mask)
 	 */
 	ret = allocate_cgrp_cset_links(css_set_count, &tmp_links);
 	if (ret)
-		goto out;
+		goto cancel_ref;
 
 	ret = cgroup_init_root_id(root);
 	if (ret)
-		goto out;
+		goto cancel_ref;
 
 	root->kf_root = kernfs_create_root(&cgroup_kf_syscall_ops,
 					   KERNFS_ROOT_CREATE_DEACTIVATED,
@@ -1657,6 +1615,8 @@ destroy_root:
 	root->kf_root = NULL;
 exit_root_id:
 	cgroup_exit_root_id(root);
+cancel_ref:
+	percpu_ref_cancel_init(&root_cgrp->self.refcnt);
 out:
 	free_cgrp_cset_links(&tmp_links);
 	return ret;
@@ -1735,13 +1695,14 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		}
 
 		/*
-		 * A root's lifetime is governed by its root cgroup.  Zero
-		 * ref indicate that the root is being destroyed.  Wait for
-		 * destruction to complete so that the subsystems are free.
-		 * We can use wait_queue for the wait but this path is
-		 * super cold.  Let's just sleep for a bit and retry.
+		 * A root's lifetime is governed by its root cgroup.
+		 * tryget_live failure indicate that the root is being
+		 * destroyed.  Wait for destruction to complete so that the
+		 * subsystems are free.  We can use wait_queue for the wait
+		 * but this path is super cold.  Let's just sleep for a bit
+		 * and retry.
 		 */
-		if (!atomic_inc_not_zero(&root->cgrp.refcnt)) {
+		if (!percpu_ref_tryget_live(&root->cgrp.self.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
 			msleep(10);
 			return ERR_PTR(restart_syscall());
@@ -1793,7 +1754,16 @@ static void cgroup_kill_sb(struct super_block *sb)
 	struct kernfs_root *kf_root = kernfs_root_from_sb(sb);
 	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
 
-	cgroup_put(&root->cgrp);
+	/*
+	 * If @root doesn't have any mounts or children, start killing it.
+	 * This prevents new mounts by disabling percpu_ref_tryget_live().
+	 * cgroup_mount() may wait for @root's release.
+	 */
+	if (cgroup_has_live_children(&root->cgrp))
+		cgroup_put(&root->cgrp);
+	else
+		percpu_ref_kill(&root->cgrp.self.refcnt);
+
 	kernfs_kill_sb(sb);
 }
 
@@ -4109,11 +4079,37 @@ static void css_free_work_fn(struct work_struct *work)
 		container_of(work, struct cgroup_subsys_state, destroy_work);
 	struct cgroup *cgrp = css->cgroup;
 
-	if (css->parent)
-		css_put(css->parent);
+	if (css->ss) {
+		/* css free path */
+		if (css->parent)
+			css_put(css->parent);
 
-	css->ss->css_free(css);
-	cgroup_put(cgrp);
+		css->ss->css_free(css);
+		cgroup_put(cgrp);
+	} else {
+		/* cgroup free path */
+		atomic_dec(&cgrp->root->nr_cgrps);
+		cgroup_pidlist_destroy_all(cgrp);
+
+		if (cgrp->parent) {
+			/*
+			 * We get a ref to the parent, and put the ref when
+			 * this cgroup is being freed, so it's guaranteed
+			 * that the parent won't be destroyed before its
+			 * children.
+			 */
+			cgroup_put(cgrp->parent);
+			kernfs_put(cgrp->kn);
+			kfree(cgrp);
+		} else {
+			/*
+			 * This is root cgroup's refcnt reaching zero,
+			 * which indicates that the root should be
+			 * released.
+			 */
+			cgroup_destroy_root(cgrp->root);
+		}
+	}
 }
 
 static void css_free_rcu_fn(struct rcu_head *rcu_head)
@@ -4130,8 +4126,20 @@ static void css_release_work_fn(struct work_struct *work)
 	struct cgroup_subsys_state *css =
 		container_of(work, struct cgroup_subsys_state, destroy_work);
 	struct cgroup_subsys *ss = css->ss;
+	struct cgroup *cgrp = css->cgroup;
 
-	cgroup_idr_remove(&ss->css_idr, css->id);
+	if (ss) {
+		/* css release path */
+		cgroup_idr_remove(&ss->css_idr, css->id);
+	} else {
+		/* cgroup release path */
+		mutex_lock(&cgroup_mutex);
+		list_del_rcu(&cgrp->sibling);
+		mutex_unlock(&cgroup_mutex);
+
+		cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
+		cgrp->id = -1;
+	}
 
 	call_rcu(&css->rcu_head, css_free_rcu_fn);
 }
@@ -4284,6 +4292,10 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 		goto out_unlock;
 	}
 
+	ret = percpu_ref_init(&cgrp->self.refcnt, css_release);
+	if (ret)
+		goto out_free_cgrp;
+
 	/*
 	 * Temporarily set the pointer to NULL, so idr_find() won't return
 	 * a half-baked cgroup.
@@ -4291,7 +4303,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	cgrp->id = cgroup_idr_alloc(&root->cgroup_idr, NULL, 2, 0, GFP_NOWAIT);
 	if (cgrp->id < 0) {
 		ret = -ENOMEM;
-		goto out_free_cgrp;
+		goto out_cancel_ref;
 	}
 
 	init_cgroup_housekeeping(cgrp);
@@ -4364,6 +4376,8 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 
 out_free_id:
 	cgroup_idr_remove(&root->cgroup_idr, cgrp->id);
+out_cancel_ref:
+	percpu_ref_cancel_init(&cgrp->self.refcnt);
 out_free_cgrp:
 	kfree(cgrp);
 out_unlock:
@@ -4520,7 +4534,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	check_for_release(cgrp->parent);
 
 	/* put the base reference */
-	cgroup_put(cgrp);
+	percpu_ref_kill(&cgrp->self.refcnt);
 
 	return 0;
 };
-- 
1.9.0
