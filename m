From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/8] cgroup: remove cgroup_tree_mutex
Date: Tue,  6 May 2014 16:19:34 -0400
Message-ID: <1399407574-21472-9-git-send-email-tj@kernel.org>
References: <1399407574-21472-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=of+Bvvm3f8Q0EeAqHT8KHL+B2D1pFMh81iVnU+4OOsE=;
        b=qsh2pEVGaLzUnFDZXqWe0M+h368fbkWk9SNUU8Zzx/wWXYB5Jd/Z9t3b83UfUGSRcM
         0VOxh7PAIjffSsGY2UBxGhjIfu0R3g9gjdliwLW3gM7tuwHDkzMQO+1Lfd6l0hJGlt21
         7lJkBA+4ebjztOpwEyVXem7jVM4vNyKxjSSoFFsjWGbhJglyNZSvVwgAOI8kfRJhvlMI
         ipNVa3VkjT8zS31FeH0IPRQLLQ3vGkfWyP8/clgi9XzztI8EfvzQBSRCB6I4EzP8NVeI
         /ayQ8FQ4jOfPglJ623l3t8yK8f216eTa5bNN8c9UAb8ygBiO8kKmthEwQWJQ6m788/fE
         hctg==
In-Reply-To: <1399407574-21472-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

cgroup_tree_mutex was introduced to work around the circular
dependency between cgroup_mutex and kernfs active protection - some
kernfs file and directory operations needed cgroup_mutex putting
cgroup_mutex under active protection but cgroup also needs to be able
to access cgroup hierarchies and cftypes to determine which
kernfs_nodes need to be removed.  cgroup_tree_mutex nested above both
cgroup_mutex and kernfs active protection and used to protect the
hierarchy and cftypes.  While this worked, it added a lot of double
lockings and was generally cumbersome.

kernfs provides a mechanism to opt out of active protection and cgroup
was already using it for removal and subtree_control.  There's no
reason to mix both methods of avoiding circular locking dependency and
the preceding cgroup_kn_lock_live() changes applied it to all relevant
cgroup kernfs operations making it unnecessary to nest cgroup_mutex
under kernfs active protection.  The previous patch reversed the
original lock ordering and put cgroup_mutex above kernfs active
protection.

After these changes, all cgroup_tree_mutex usages are now accompanied
by cgroup_mutex making the former completely redundant.  This patch
removes cgroup_tree_mutex and all its usages.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 64 ++++++++-------------------------------------------------
 1 file changed, 9 insertions(+), 55 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 601a35d..4f218f3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -71,15 +71,6 @@
 					 MAX_CFTYPE_NAME + 2)
 
 /*
- * cgroup_tree_mutex nests above cgroup_mutex and protects cftypes, file
- * creation/removal and hierarchy changing operations including cgroup
- * creation, removal, css association and controller rebinding.  This outer
- * lock is needed mainly to resolve the circular dependency between kernfs
- * active ref and cgroup_mutex.  cgroup_tree_mutex nests above both.
- */
-static DEFINE_MUTEX(cgroup_tree_mutex);
-
-/*
  * cgroup_mutex is the master lock.  Any modification to cgroup or its
  * hierarchy must be performed while holding it.
  *
@@ -111,11 +102,10 @@ static DEFINE_SPINLOCK(cgroup_idr_lock);
  */
 static DEFINE_SPINLOCK(release_agent_path_lock);
 
-#define cgroup_assert_mutexes_or_rcu_locked()				\
+#define cgroup_assert_mutex_or_rcu_locked()				\
 	rcu_lockdep_assert(rcu_read_lock_held() ||			\
-			   lockdep_is_held(&cgroup_tree_mutex) ||	\
 			   lockdep_is_held(&cgroup_mutex),		\
-			   "cgroup_[tree_]mutex or RCU read lock required");
+			   "cgroup_mutex or RCU read lock required");
 
 /*
  * cgroup destruction makes heavy use of work items and there can be a lot
@@ -243,7 +233,6 @@ static struct cgroup_subsys_state *cgroup_css(struct cgroup *cgrp,
 {
 	if (ss)
 		return rcu_dereference_check(cgrp->subsys[ss->id],
-					lockdep_is_held(&cgroup_tree_mutex) ||
 					lockdep_is_held(&cgroup_mutex));
 	else
 		return &cgrp->dummy_css;
@@ -347,7 +336,6 @@ static int notify_on_release(const struct cgroup *cgrp)
 	for ((ssid) = 0; (ssid) < CGROUP_SUBSYS_COUNT; (ssid)++)	\
 		if (!((css) = rcu_dereference_check(			\
 				(cgrp)->subsys[(ssid)],			\
-				lockdep_is_held(&cgroup_tree_mutex) ||	\
 				lockdep_is_held(&cgroup_mutex)))) { }	\
 		else
 
@@ -381,7 +369,7 @@ static int notify_on_release(const struct cgroup *cgrp)
 /* iterate over child cgrps, lock should be held throughout iteration */
 #define cgroup_for_each_live_child(child, cgrp)				\
 	list_for_each_entry((child), &(cgrp)->children, sibling)	\
-		if (({ lockdep_assert_held(&cgroup_tree_mutex);		\
+		if (({ lockdep_assert_held(&cgroup_mutex);		\
 		       cgroup_is_dead(child); }))			\
 			;						\
 		else
@@ -869,7 +857,6 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 	struct cgroup *cgrp = &root->cgrp;
 	struct cgrp_cset_link *link, *tmp_link;
 
-	mutex_lock(&cgroup_tree_mutex);
 	mutex_lock(&cgroup_mutex);
 
 	BUG_ON(atomic_read(&root->nr_cgrps));
@@ -899,7 +886,6 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 	cgroup_exit_root_id(root);
 
 	mutex_unlock(&cgroup_mutex);
-	mutex_unlock(&cgroup_tree_mutex);
 
 	kernfs_destroy_root(root->kf_root);
 	cgroup_free_root(root);
@@ -1096,7 +1082,6 @@ static void cgroup_kn_unlock(struct kernfs_node *kn)
 		cgrp = kn->parent->priv;
 
 	mutex_unlock(&cgroup_mutex);
-	mutex_unlock(&cgroup_tree_mutex);
 
 	kernfs_unbreak_active_protection(kn);
 	cgroup_put(cgrp);
@@ -1135,7 +1120,6 @@ static struct cgroup *cgroup_kn_lock_live(struct kernfs_node *kn)
 	cgroup_get(cgrp);
 	kernfs_break_active_protection(kn);
 
-	mutex_lock(&cgroup_tree_mutex);
 	mutex_lock(&cgroup_mutex);
 
 	if (!cgroup_is_dead(cgrp))
@@ -1149,7 +1133,6 @@ static void cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 {
 	char name[CGROUP_FILE_NAME_MAX];
 
-	lockdep_assert_held(&cgroup_tree_mutex);
 	lockdep_assert_held(&cgroup_mutex);
 	kernfs_remove_by_name(cgrp->kn, cgroup_file_name(cgrp, cft, name));
 }
@@ -1179,7 +1162,6 @@ static int rebind_subsystems(struct cgroup_root *dst_root, unsigned int ss_mask)
 	struct cgroup_subsys *ss;
 	int ssid, i, ret;
 
-	lockdep_assert_held(&cgroup_tree_mutex);
 	lockdep_assert_held(&cgroup_mutex);
 
 	for_each_subsys(ss, ssid) {
@@ -1457,7 +1439,6 @@ static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 		return -EINVAL;
 	}
 
-	mutex_lock(&cgroup_tree_mutex);
 	mutex_lock(&cgroup_mutex);
 
 	/* See what subsystems are wanted */
@@ -1503,7 +1484,6 @@ static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 	kfree(opts.release_agent);
 	kfree(opts.name);
 	mutex_unlock(&cgroup_mutex);
-	mutex_unlock(&cgroup_tree_mutex);
 	return ret;
 }
 
@@ -1606,7 +1586,6 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned int ss_mask)
 	struct css_set *cset;
 	int i, ret;
 
-	lockdep_assert_held(&cgroup_tree_mutex);
 	lockdep_assert_held(&cgroup_mutex);
 
 	ret = cgroup_idr_alloc(&root->cgroup_idr, root_cgrp, 1, 2, GFP_NOWAIT);
@@ -1696,7 +1675,6 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	if (!use_task_css_set_links)
 		cgroup_enable_task_cg_lists();
 
-	mutex_lock(&cgroup_tree_mutex);
 	mutex_lock(&cgroup_mutex);
 
 	/* First find the desired set of subsystems */
@@ -1761,9 +1739,7 @@ retry:
 		 */
 		if (!atomic_inc_not_zero(&root->cgrp.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
-			mutex_unlock(&cgroup_tree_mutex);
 			msleep(10);
-			mutex_lock(&cgroup_tree_mutex);
 			mutex_lock(&cgroup_mutex);
 			goto retry;
 		}
@@ -1796,7 +1772,6 @@ retry:
 
 out_unlock:
 	mutex_unlock(&cgroup_mutex);
-	mutex_unlock(&cgroup_tree_mutex);
 
 	kfree(opts.release_agent);
 	kfree(opts.name);
@@ -2507,7 +2482,6 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	struct css_set *src_cset;
 	int ret;
 
-	lockdep_assert_held(&cgroup_tree_mutex);
 	lockdep_assert_held(&cgroup_mutex);
 
 	/* look up all csses currently attached to @cgrp's subtree */
@@ -2866,20 +2840,18 @@ static int cgroup_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
 		return -EPERM;
 
 	/*
-	 * We're gonna grab cgroup_tree_mutex which nests outside kernfs
+	 * We're gonna grab cgroup_mutex which nests outside kernfs
 	 * active_ref.  kernfs_rename() doesn't require active_ref
-	 * protection.  Break them before grabbing cgroup_tree_mutex.
+	 * protection.  Break them before grabbing cgroup_mutex.
 	 */
 	kernfs_break_active_protection(new_parent);
 	kernfs_break_active_protection(kn);
 
-	mutex_lock(&cgroup_tree_mutex);
 	mutex_lock(&cgroup_mutex);
 
 	ret = kernfs_rename(kn, new_parent, new_name_str);
 
 	mutex_unlock(&cgroup_mutex);
-	mutex_unlock(&cgroup_tree_mutex);
 
 	kernfs_unbreak_active_protection(kn);
 	kernfs_unbreak_active_protection(new_parent);
@@ -2944,7 +2916,6 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 	struct cftype *cft;
 	int ret;
 
-	lockdep_assert_held(&cgroup_tree_mutex);
 	lockdep_assert_held(&cgroup_mutex);
 
 	for (cft = cfts; cft->name[0] != '\0'; cft++) {
@@ -2980,7 +2951,6 @@ static int cgroup_apply_cftypes(struct cftype *cfts, bool is_add)
 	struct cgroup_subsys_state *css;
 	int ret = 0;
 
-	lockdep_assert_held(&cgroup_tree_mutex);
 	lockdep_assert_held(&cgroup_mutex);
 
 	/* add/rm files for all cgroups created before */
@@ -3049,7 +3019,6 @@ static int cgroup_init_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 
 static int cgroup_rm_cftypes_locked(struct cftype *cfts)
 {
-	lockdep_assert_held(&cgroup_tree_mutex);
 	lockdep_assert_held(&cgroup_mutex);
 
 	if (!cfts || !cfts[0].ss)
@@ -3076,11 +3045,9 @@ int cgroup_rm_cftypes(struct cftype *cfts)
 {
 	int ret;
 
-	mutex_lock(&cgroup_tree_mutex);
 	mutex_lock(&cgroup_mutex);
 	ret = cgroup_rm_cftypes_locked(cfts);
 	mutex_unlock(&cgroup_mutex);
-	mutex_unlock(&cgroup_tree_mutex);
 	return ret;
 }
 
@@ -3109,7 +3076,6 @@ int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 	if (ret)
 		return ret;
 
-	mutex_lock(&cgroup_tree_mutex);
 	mutex_lock(&cgroup_mutex);
 
 	list_add_tail(&cfts->node, &ss->cfts);
@@ -3118,7 +3084,6 @@ int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 		cgroup_rm_cftypes_locked(cfts);
 
 	mutex_unlock(&cgroup_mutex);
-	mutex_unlock(&cgroup_tree_mutex);
 	return ret;
 }
 
@@ -3158,7 +3123,7 @@ css_next_child(struct cgroup_subsys_state *pos_css,
 	struct cgroup *cgrp = parent_css->cgroup;
 	struct cgroup *next;
 
-	cgroup_assert_mutexes_or_rcu_locked();
+	cgroup_assert_mutex_or_rcu_locked();
 
 	/*
 	 * @pos could already have been removed.  Once a cgroup is removed,
@@ -3224,7 +3189,7 @@ css_next_descendant_pre(struct cgroup_subsys_state *pos,
 {
 	struct cgroup_subsys_state *next;
 
-	cgroup_assert_mutexes_or_rcu_locked();
+	cgroup_assert_mutex_or_rcu_locked();
 
 	/* if first iteration, visit @root */
 	if (!pos)
@@ -3264,7 +3229,7 @@ css_rightmost_descendant(struct cgroup_subsys_state *pos)
 {
 	struct cgroup_subsys_state *last, *tmp;
 
-	cgroup_assert_mutexes_or_rcu_locked();
+	cgroup_assert_mutex_or_rcu_locked();
 
 	do {
 		last = pos;
@@ -3311,7 +3276,7 @@ css_next_descendant_post(struct cgroup_subsys_state *pos,
 {
 	struct cgroup_subsys_state *next;
 
-	cgroup_assert_mutexes_or_rcu_locked();
+	cgroup_assert_mutex_or_rcu_locked();
 
 	/* if first iteration, visit leftmost descendant which may be @root */
 	if (!pos)
@@ -4179,7 +4144,6 @@ static int online_css(struct cgroup_subsys_state *css)
 	struct cgroup_subsys *ss = css->ss;
 	int ret = 0;
 
-	lockdep_assert_held(&cgroup_tree_mutex);
 	lockdep_assert_held(&cgroup_mutex);
 
 	if (ss->css_online)
@@ -4197,7 +4161,6 @@ static void offline_css(struct cgroup_subsys_state *css)
 {
 	struct cgroup_subsys *ss = css->ss;
 
-	lockdep_assert_held(&cgroup_tree_mutex);
 	lockdep_assert_held(&cgroup_mutex);
 
 	if (!(css->flags & CSS_ONLINE))
@@ -4400,7 +4363,6 @@ static void css_killed_work_fn(struct work_struct *work)
 		container_of(work, struct cgroup_subsys_state, destroy_work);
 	struct cgroup *cgrp = css->cgroup;
 
-	mutex_lock(&cgroup_tree_mutex);
 	mutex_lock(&cgroup_mutex);
 
 	/*
@@ -4418,7 +4380,6 @@ static void css_killed_work_fn(struct work_struct *work)
 		cgroup_destroy_css_killed(cgrp);
 
 	mutex_unlock(&cgroup_mutex);
-	mutex_unlock(&cgroup_tree_mutex);
 
 	/*
 	 * Put the css refs from kill_css().  Each css holds an extra
@@ -4451,7 +4412,6 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
  */
 static void kill_css(struct cgroup_subsys_state *css)
 {
-	lockdep_assert_held(&cgroup_tree_mutex);
 	lockdep_assert_held(&cgroup_mutex);
 
 	/*
@@ -4511,7 +4471,6 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	bool empty;
 	int ssid;
 
-	lockdep_assert_held(&cgroup_tree_mutex);
 	lockdep_assert_held(&cgroup_mutex);
 
 	/*
@@ -4594,7 +4553,6 @@ static void cgroup_destroy_css_killed(struct cgroup *cgrp)
 {
 	struct cgroup *parent = cgrp->parent;
 
-	lockdep_assert_held(&cgroup_tree_mutex);
 	lockdep_assert_held(&cgroup_mutex);
 
 	/* delete this cgroup from parent->children */
@@ -4648,7 +4606,6 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 
 	printk(KERN_INFO "Initializing cgroup subsys %s\n", ss->name);
 
-	mutex_lock(&cgroup_tree_mutex);
 	mutex_lock(&cgroup_mutex);
 
 	idr_init(&ss->css_idr);
@@ -4686,7 +4643,6 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 	cgrp_dfl_root.subsys_mask |= 1 << ss->id;
 
 	mutex_unlock(&cgroup_mutex);
-	mutex_unlock(&cgroup_tree_mutex);
 }
 
 /**
@@ -4736,7 +4692,6 @@ int __init cgroup_init(void)
 
 	BUG_ON(cgroup_init_cftypes(NULL, cgroup_base_files));
 
-	mutex_lock(&cgroup_tree_mutex);
 	mutex_lock(&cgroup_mutex);
 
 	/* Add init_css_set to the hash table */
@@ -4746,7 +4701,6 @@ int __init cgroup_init(void)
 	BUG_ON(cgroup_setup_root(&cgrp_dfl_root, 0));
 
 	mutex_unlock(&cgroup_mutex);
-	mutex_unlock(&cgroup_tree_mutex);
 
 	for_each_subsys(ss, ssid) {
 		if (ss->early_init) {
-- 
1.9.0
