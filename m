From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 06/14] cgroup: move cgroup->sibling and ->children into cgroup_subsys_state
Date: Fri,  9 May 2014 17:31:23 -0400
Message-ID: <1399671091-23867-7-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ikg6Ri3BpC3qdV8KcZkeu9Z47vXRBGko2Es946HzrOU=;
        b=KSKMKh8ncxxmvNXl3dCnMTvZaFw+6HXLlnkvfqkmnpj27o3XQZF8CRkDn8Bzz6JCuv
         WmnI4OQu4KQJr3R7qNR0iDY5UfMsUKxclt64rHbRQlEy9m4c4OM24Q0kQkbhGC5rYyRw
         hliNKYZkFnwap8n6VwDupM6dSGOobIviN9skLmYRyExAEIHcf2KpxnOASrj/8JeRTKLP
         oKbAPCtt+xlxy+GijxH03wOpADV9swd7LIg2uXTYw+F1/HW+G7Sm1hRTpxJk8ckGo+hU
         TsS/h55hveh2TB+YwxLeZ0VdBFvXlH3SzxBmeI4r7INVkEoD7ITExQdVkCAz+bc140sd
         a0iw==
In-Reply-To: <1399671091-23867-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

We're moving towards using cgroup_subsys_states as the fundamental
structural blocks.  Let's move cgroup->sibling and ->children into
cgroup_subsys_state.  This is pure move without functional change and
only cgroup->self's fields are actually used.  Other csses will make
use of the fields later.

While at it, update init_and_link_css() so that it zeroes the whole
css before initializing it and remove explicit zeroing of ->flags.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup.h | 11 ++++-------
 kernel/cgroup.c        | 38 ++++++++++++++++++++------------------
 2 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5fda088..db8d8c2 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -68,6 +68,10 @@ struct cgroup_subsys_state {
 	/* PI: the parent css */
 	struct cgroup_subsys_state *parent;
 
+	/* siblings list anchored at the parent's ->children */
+	struct list_head sibling;
+	struct list_head children;
+
 	/*
 	 * PI: Subsys-unique ID.  0 is unused and root is always 1.  The
 	 * matching css can be looked up using css_from_id().
@@ -166,13 +170,6 @@ struct cgroup {
 	 */
 	int populated_cnt;
 
-	/*
-	 * We link our 'sibling' struct into our parent's 'children'.
-	 * Our children link their 'sibling' into our 'children'.
-	 */
-	struct list_head sibling;	/* my parent's children */
-	struct list_head children;	/* my children */
-
 	struct kernfs_node *kn;		/* cgroup kernfs entry */
 	struct kernfs_node *populated_kn; /* kn for "cgroup.subtree_populated" */
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d61c716..3d6c0aa 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -378,7 +378,7 @@ static int notify_on_release(const struct cgroup *cgrp)
 
 /* iterate over child cgrps, lock should be held throughout iteration */
 #define cgroup_for_each_live_child(child, cgrp)				\
-	list_for_each_entry((child), &(cgrp)->children, sibling)	\
+	list_for_each_entry((child), &(cgrp)->self.children, self.sibling) \
 		if (({ lockdep_assert_held(&cgroup_mutex);		\
 		       cgroup_is_dead(child); }))			\
 			;						\
@@ -870,7 +870,7 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 	mutex_lock(&cgroup_mutex);
 
 	BUG_ON(atomic_read(&root->nr_cgrps));
-	BUG_ON(!list_empty(&cgrp->children));
+	BUG_ON(!list_empty(&cgrp->self.children));
 
 	/* Rebind all subsystems back to the default hierarchy */
 	rebind_subsystems(&cgrp_dfl_root, root->subsys_mask);
@@ -1432,7 +1432,7 @@ static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 	}
 
 	/* remounting is not allowed for populated hierarchies */
-	if (!list_empty(&root->cgrp.children)) {
+	if (!list_empty(&root->cgrp.self.children)) {
 		ret = -EBUSY;
 		goto out_unlock;
 	}
@@ -1512,8 +1512,8 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	struct cgroup_subsys *ss;
 	int ssid;
 
-	INIT_LIST_HEAD(&cgrp->sibling);
-	INIT_LIST_HEAD(&cgrp->children);
+	INIT_LIST_HEAD(&cgrp->self.sibling);
+	INIT_LIST_HEAD(&cgrp->self.children);
 	INIT_LIST_HEAD(&cgrp->cset_links);
 	INIT_LIST_HEAD(&cgrp->release_list);
 	INIT_LIST_HEAD(&cgrp->pidlists);
@@ -1612,7 +1612,7 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned int ss_mask)
 		link_css_set(&tmp_links, cset, root_cgrp);
 	up_write(&css_set_rwsem);
 
-	BUG_ON(!list_empty(&root_cgrp->children));
+	BUG_ON(!list_empty(&root_cgrp->self.children));
 	BUG_ON(atomic_read(&root->nr_cgrps) != 1);
 
 	kernfs_activate(root_cgrp->kn);
@@ -3127,11 +3127,11 @@ css_next_child(struct cgroup_subsys_state *pos_css,
 	 * cgroup is removed or iteration and removal race.
 	 */
 	if (!pos) {
-		next = list_entry_rcu(cgrp->children.next, struct cgroup, sibling);
+		next = list_entry_rcu(cgrp->self.children.next, struct cgroup, self.sibling);
 	} else if (likely(!cgroup_is_dead(pos))) {
-		next = list_entry_rcu(pos->sibling.next, struct cgroup, sibling);
+		next = list_entry_rcu(pos->self.sibling.next, struct cgroup, self.sibling);
 	} else {
-		list_for_each_entry_rcu(next, &cgrp->children, sibling)
+		list_for_each_entry_rcu(next, &cgrp->self.children, self.sibling)
 			if (next->serial_nr > pos->serial_nr)
 				break;
 	}
@@ -3141,12 +3141,12 @@ css_next_child(struct cgroup_subsys_state *pos_css,
 	 * the next sibling; however, it might have @ss disabled.  If so,
 	 * fast-forward to the next enabled one.
 	 */
-	while (&next->sibling != &cgrp->children) {
+	while (&next->self.sibling != &cgrp->self.children) {
 		struct cgroup_subsys_state *next_css = cgroup_css(next, parent_css->ss);
 
 		if (next_css)
 			return next_css;
-		next = list_entry_rcu(next->sibling.next, struct cgroup, sibling);
+		next = list_entry_rcu(next->self.sibling.next, struct cgroup, self.sibling);
 	}
 	return NULL;
 }
@@ -3282,7 +3282,7 @@ static bool cgroup_has_live_children(struct cgroup *cgrp)
 	struct cgroup *child;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(child, &cgrp->children, sibling) {
+	list_for_each_entry_rcu(child, &cgrp->self.children, self.sibling) {
 		if (!cgroup_is_dead(child)) {
 			rcu_read_unlock();
 			return true;
@@ -4143,7 +4143,7 @@ static void css_release_work_fn(struct work_struct *work)
 	} else {
 		/* cgroup release path */
 		mutex_lock(&cgroup_mutex);
-		list_del_rcu(&cgrp->sibling);
+		list_del_rcu(&cgrp->self.sibling);
 		mutex_unlock(&cgroup_mutex);
 
 		cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
@@ -4167,9 +4167,11 @@ static void init_and_link_css(struct cgroup_subsys_state *css,
 {
 	cgroup_get(cgrp);
 
+	memset(css, 0, sizeof(*css));
 	css->cgroup = cgrp;
 	css->ss = ss;
-	css->flags = 0;
+	INIT_LIST_HEAD(&css->sibling);
+	INIT_LIST_HEAD(&css->children);
 
 	if (cgroup_parent(cgrp)) {
 		css->parent = cgroup_css(cgroup_parent(cgrp), ss);
@@ -4343,7 +4345,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	cgrp->serial_nr = cgroup_serial_nr_next++;
 
 	/* allocation complete, commit to creation */
-	list_add_tail_rcu(&cgrp->sibling, &cgroup_parent(cgrp)->children);
+	list_add_tail_rcu(&cgrp->self.sibling, &cgroup_parent(cgrp)->self.children);
 	atomic_inc(&root->nr_cgrps);
 	cgroup_get(parent);
 
@@ -4506,9 +4508,9 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 		return -EBUSY;
 
 	/*
-	 * Make sure there's no live children.  We can't test ->children
-	 * emptiness as dead children linger on it while being destroyed;
-	 * otherwise, "rmdir parent/child parent" may fail with -EBUSY.
+	 * Make sure there's no live children.  We can't test emptiness of
+	 * ->self.children as dead children linger on it while being
+	 * drained; otherwise, "rmdir parent/child parent" may fail.
 	 */
 	if (cgroup_has_live_children(cgrp))
 		return -EBUSY;
-- 
1.9.0
