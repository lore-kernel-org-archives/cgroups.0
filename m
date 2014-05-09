From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/14] cgroup: remove cgroup->parent
Date: Fri,  9 May 2014 17:31:22 -0400
Message-ID: <1399671091-23867-6-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ToBdejULjCAqsM6BKunW0HFzSVUDJDHjZP/+DMLUjcw=;
        b=BetBuYedpiQvoGgrEciMELessfvHlfTN/HtuXO26nLinLPa9g1yMbLWTsgNndnpHCV
         uuTyuwQ9MabDYdaJw5KsSo90Mj/5nl61LVpTsm0G7XZweZ+VJdvdrFBBzpdPePxaWlpE
         v2qJY2O/pKsDNuSh4FmTjoTtwEd5kdNS5lsnQpHyzaAniaL5db5kBINGbGGW3p1h3lx7
         D5XTRBA5uSym6I+aaeRFT4l7U8CEKeo9yLpW0Eu2I2NcvaKVPyXAu5JJCDCJq/yUJL09
         yWKKSeceBLdID8VCzUTiNUwk7yZhDDOvITd2NJzshpvWMvyd9Yp5ehmLs1dDOBrZgUvt
         MNAQ==
In-Reply-To: <1399671091-23867-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, Tejun Heo <tj@kernel.org>

cgroup->parent is redundant as cgroup->self.parent can also be used to
determine the parent cgroup and we're moving towards using
cgroup_subsys_states as the fundamental structural blocks.  This patch
introduces cgroup_parent() which follows cgroup->self.parent and
removes cgroup->parent.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  1 -
 kernel/cgroup.c        | 52 +++++++++++++++++++++++++++++---------------------
 2 files changed, 30 insertions(+), 23 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 88c4d03..5fda088 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -173,7 +173,6 @@ struct cgroup {
 	struct list_head sibling;	/* my parent's children */
 	struct list_head children;	/* my children */
 
-	struct cgroup *parent;		/* my parent */
 	struct kernfs_node *kn;		/* cgroup kernfs entry */
 	struct kernfs_node *populated_kn; /* kn for "cgroup.subtree_populated" */
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index dab8f35..d61c716 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -218,6 +218,15 @@ static void cgroup_idr_remove(struct idr *idr, int id)
 	spin_unlock_bh(&cgroup_idr_lock);
 }
 
+static struct cgroup *cgroup_parent(struct cgroup *cgrp)
+{
+	struct cgroup_subsys_state *parent_css = cgrp->self.parent;
+
+	if (parent_css)
+		return container_of(parent_css, struct cgroup, self);
+	return NULL;
+}
+
 /**
  * cgroup_css - obtain a cgroup's css for the specified subsystem
  * @cgrp: the cgroup of interest
@@ -260,9 +269,9 @@ static struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
 	if (!(cgrp->root->subsys_mask & (1 << ss->id)))
 		return NULL;
 
-	while (cgrp->parent &&
-	       !(cgrp->parent->child_subsys_mask & (1 << ss->id)))
-		cgrp = cgrp->parent;
+	while (cgroup_parent(cgrp) &&
+	       !(cgroup_parent(cgrp)->child_subsys_mask & (1 << ss->id)))
+		cgrp = cgroup_parent(cgrp);
 
 	return cgroup_css(cgrp, ss);
 }
@@ -307,7 +316,7 @@ bool cgroup_is_descendant(struct cgroup *cgrp, struct cgroup *ancestor)
 	while (cgrp) {
 		if (cgrp == ancestor)
 			return true;
-		cgrp = cgrp->parent;
+		cgrp = cgroup_parent(cgrp);
 	}
 	return false;
 }
@@ -454,7 +463,7 @@ static void cgroup_update_populated(struct cgroup *cgrp, bool populated)
 
 		if (cgrp->populated_kn)
 			kernfs_notify(cgrp->populated_kn);
-		cgrp = cgrp->parent;
+		cgrp = cgroup_parent(cgrp);
 	} while (cgrp);
 }
 
@@ -2017,7 +2026,7 @@ static int cgroup_migrate_prepare_dst(struct cgroup *dst_cgrp,
 	 * Except for the root, child_subsys_mask must be zero for a cgroup
 	 * with tasks so that child cgroups don't compete against tasks.
 	 */
-	if (dst_cgrp && cgroup_on_dfl(dst_cgrp) && dst_cgrp->parent &&
+	if (dst_cgrp && cgroup_on_dfl(dst_cgrp) && cgroup_parent(dst_cgrp) &&
 	    dst_cgrp->child_subsys_mask)
 		return -EBUSY;
 
@@ -2426,7 +2435,7 @@ static int cgroup_controllers_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
 
-	cgroup_print_ss_mask(seq, cgrp->parent->child_subsys_mask);
+	cgroup_print_ss_mask(seq, cgroup_parent(cgrp)->child_subsys_mask);
 	return 0;
 }
 
@@ -2609,8 +2618,8 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 
 			/* unavailable or not enabled on the parent? */
 			if (!(cgrp_dfl_root.subsys_mask & (1 << ssid)) ||
-			    (cgrp->parent &&
-			     !(cgrp->parent->child_subsys_mask & (1 << ssid)))) {
+			    (cgroup_parent(cgrp) &&
+			     !(cgroup_parent(cgrp)->child_subsys_mask & (1 << ssid)))) {
 				ret = -ENOENT;
 				goto out_unlock;
 			}
@@ -2639,7 +2648,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	 * Except for the root, child_subsys_mask must be zero for a cgroup
 	 * with tasks so that child cgroups don't compete against tasks.
 	 */
-	if (enable && cgrp->parent && !list_empty(&cgrp->cset_links)) {
+	if (enable && cgroup_parent(cgrp) && !list_empty(&cgrp->cset_links)) {
 		ret = -EBUSY;
 		goto out_unlock;
 	}
@@ -2897,9 +2906,9 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 			continue;
 		if ((cft->flags & CFTYPE_INSANE) && cgroup_sane_behavior(cgrp))
 			continue;
-		if ((cft->flags & CFTYPE_NOT_ON_ROOT) && !cgrp->parent)
+		if ((cft->flags & CFTYPE_NOT_ON_ROOT) && !cgroup_parent(cgrp))
 			continue;
-		if ((cft->flags & CFTYPE_ONLY_ON_ROOT) && cgrp->parent)
+		if ((cft->flags & CFTYPE_ONLY_ON_ROOT) && cgroup_parent(cgrp))
 			continue;
 
 		if (is_add) {
@@ -4091,14 +4100,14 @@ static void css_free_work_fn(struct work_struct *work)
 		atomic_dec(&cgrp->root->nr_cgrps);
 		cgroup_pidlist_destroy_all(cgrp);
 
-		if (cgrp->parent) {
+		if (cgroup_parent(cgrp)) {
 			/*
 			 * We get a ref to the parent, and put the ref when
 			 * this cgroup is being freed, so it's guaranteed
 			 * that the parent won't be destroyed before its
 			 * children.
 			 */
-			cgroup_put(cgrp->parent);
+			cgroup_put(cgroup_parent(cgrp));
 			kernfs_put(cgrp->kn);
 			kfree(cgrp);
 		} else {
@@ -4162,8 +4171,8 @@ static void init_and_link_css(struct cgroup_subsys_state *css,
 	css->ss = ss;
 	css->flags = 0;
 
-	if (cgrp->parent) {
-		css->parent = cgroup_css(cgrp->parent, ss);
+	if (cgroup_parent(cgrp)) {
+		css->parent = cgroup_css(cgroup_parent(cgrp), ss);
 		css_get(css->parent);
 	}
 
@@ -4217,7 +4226,7 @@ static void offline_css(struct cgroup_subsys_state *css)
  */
 static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 {
-	struct cgroup *parent = cgrp->parent;
+	struct cgroup *parent = cgroup_parent(cgrp);
 	struct cgroup_subsys_state *css;
 	int err;
 
@@ -4250,7 +4259,7 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 		goto err_clear_dir;
 
 	if (ss->broken_hierarchy && !ss->warned_broken_hierarchy &&
-	    parent->parent) {
+	    cgroup_parent(parent)) {
 		pr_warn("%s (%d) created nested cgroup for controller \"%s\" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.\n",
 			current->comm, current->pid, ss->name);
 		if (!strcmp(ss->name, "memory"))
@@ -4308,7 +4317,6 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 
 	init_cgroup_housekeeping(cgrp);
 
-	cgrp->parent = parent;
 	cgrp->self.parent = &parent->self;
 	cgrp->root = root;
 
@@ -4335,7 +4343,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	cgrp->serial_nr = cgroup_serial_nr_next++;
 
 	/* allocation complete, commit to creation */
-	list_add_tail_rcu(&cgrp->sibling, &cgrp->parent->children);
+	list_add_tail_rcu(&cgrp->sibling, &cgroup_parent(cgrp)->children);
 	atomic_inc(&root->nr_cgrps);
 	cgroup_get(parent);
 
@@ -4530,8 +4538,8 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 */
 	kernfs_remove(cgrp->kn);
 
-	set_bit(CGRP_RELEASABLE, &cgrp->parent->flags);
-	check_for_release(cgrp->parent);
+	set_bit(CGRP_RELEASABLE, &cgroup_parent(cgrp)->flags);
+	check_for_release(cgroup_parent(cgrp));
 
 	/* put the base reference */
 	percpu_ref_kill(&cgrp->self.refcnt);
-- 
1.9.0
