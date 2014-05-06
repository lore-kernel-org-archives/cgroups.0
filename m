From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/8] cgroup: nest kernfs active protection under cgroup_mutex
Date: Tue,  6 May 2014 16:19:33 -0400
Message-ID: <1399407574-21472-8-git-send-email-tj@kernel.org>
References: <1399407574-21472-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jMrjIV6LY/ti5cf8Zq70sbsM2zOsWTYVhtM6OgpJNrA=;
        b=copYsWuED5ClymWFinrkf4ifV4Yx4NK2iEU5CRimWCqYXXo0m92h9yOq6JicGvr9Eg
         5BDbYNdbYWepLiFBw71GUFbbEHHAl1wDHcVuly5fXbbwxwjQm2zo1qX+o21gtIC1+csb
         F5d2HgOl03mpNH00WZG5P/IjJgf9hjo0tUJNF1vODnL/L7vrgh3AthUhBP/UHYLMyYLX
         W9Og+Jhrbk6j8j3IlbmGfbt7FhpfH9tAy57G8tf9lz6k/6t+mOnUMkthQb1/dSiKyKAz
         kBvVKOBkqgtAaVORqWLQ7qdCE2vAmeyPDBr73TPqHoODgy3reqMUuTH20K7SZhUsfqlJ
         6+Mw==
In-Reply-To: <1399407574-21472-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

After the recent cgroup_kn_lock_live() changes, cgroup_mutex is no
longer nested below kernfs active protection.  The two don't have any
relationship now.

This patch nests kernfs active protection under cgroup_mutex.  All
cftype operations now require both cgroup_tree_mutex and cgroup_mutex,
temporary cgroup_mutex releases over kernfs operations are removed,
and cgroup_add/rm_cftypes() grab both mutexes.

This makes cgroup_tree_mutex redundant, which will be removed by the
next patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 281fce5..601a35d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1127,7 +1127,7 @@ static struct cgroup *cgroup_kn_lock_live(struct kernfs_node *kn)
 		cgrp = kn->parent->priv;
 
 	/*
-	 * We're gonna grab cgroup_tree_mutex which nests outside kernfs
+	 * We're gonna grab cgroup_mutex which nests outside kernfs
 	 * active_ref.  cgroup liveliness check alone provides enough
 	 * protection against removal.  Ensure @cgrp stays accessible and
 	 * break the active_ref protection.
@@ -1150,6 +1150,7 @@ static void cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 	char name[CGROUP_FILE_NAME_MAX];
 
 	lockdep_assert_held(&cgroup_tree_mutex);
+	lockdep_assert_held(&cgroup_mutex);
 	kernfs_remove_by_name(cgrp->kn, cgroup_file_name(cgrp, cft, name));
 }
 
@@ -1216,11 +1217,9 @@ static int rebind_subsystems(struct cgroup_root *dst_root, unsigned int ss_mask)
 	 * Nothing can fail from this point on.  Remove files for the
 	 * removed subsystems and rebind each subsystem.
 	 */
-	mutex_unlock(&cgroup_mutex);
 	for_each_subsys(ss, ssid)
 		if (ss_mask & (1 << ssid))
 			cgroup_clear_dir(&ss->root->cgrp, 1 << ssid);
-	mutex_lock(&cgroup_mutex);
 
 	for_each_subsys(ss, ssid) {
 		struct cgroup_root *src_root;
@@ -2946,6 +2945,7 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 	int ret;
 
 	lockdep_assert_held(&cgroup_tree_mutex);
+	lockdep_assert_held(&cgroup_mutex);
 
 	for (cft = cfts; cft->name[0] != '\0'; cft++) {
 		/* does cft->flags tell us to skip this file on @cgrp? */
@@ -2981,6 +2981,7 @@ static int cgroup_apply_cftypes(struct cftype *cfts, bool is_add)
 	int ret = 0;
 
 	lockdep_assert_held(&cgroup_tree_mutex);
+	lockdep_assert_held(&cgroup_mutex);
 
 	/* add/rm files for all cgroups created before */
 	css_for_each_descendant_pre(css, cgroup_css(root, ss)) {
@@ -3049,6 +3050,7 @@ static int cgroup_init_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 static int cgroup_rm_cftypes_locked(struct cftype *cfts)
 {
 	lockdep_assert_held(&cgroup_tree_mutex);
+	lockdep_assert_held(&cgroup_mutex);
 
 	if (!cfts || !cfts[0].ss)
 		return -ENOENT;
@@ -3075,7 +3077,9 @@ int cgroup_rm_cftypes(struct cftype *cfts)
 	int ret;
 
 	mutex_lock(&cgroup_tree_mutex);
+	mutex_lock(&cgroup_mutex);
 	ret = cgroup_rm_cftypes_locked(cfts);
+	mutex_unlock(&cgroup_mutex);
 	mutex_unlock(&cgroup_tree_mutex);
 	return ret;
 }
@@ -3106,12 +3110,14 @@ int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 		return ret;
 
 	mutex_lock(&cgroup_tree_mutex);
+	mutex_lock(&cgroup_mutex);
 
 	list_add_tail(&cfts->node, &ss->cfts);
 	ret = cgroup_apply_cftypes(cfts, true);
 	if (ret)
 		cgroup_rm_cftypes_locked(cfts);
 
+	mutex_unlock(&cgroup_mutex);
 	mutex_unlock(&cgroup_tree_mutex);
 	return ret;
 }
@@ -4446,6 +4452,7 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
 static void kill_css(struct cgroup_subsys_state *css)
 {
 	lockdep_assert_held(&cgroup_tree_mutex);
+	lockdep_assert_held(&cgroup_mutex);
 
 	/*
 	 * This must happen before css is disassociated with its cgroup.
@@ -4545,13 +4552,10 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	/*
 	 * Initiate massacre of all css's.  cgroup_destroy_css_killed()
 	 * will be invoked to perform the rest of destruction once the
-	 * percpu refs of all css's are confirmed to be killed.  This
-	 * involves removing the subsystem's files, drop cgroup_mutex.
+	 * percpu refs of all css's are confirmed to be killed.
 	 */
-	mutex_unlock(&cgroup_mutex);
 	for_each_css(css, ssid, cgrp)
 		kill_css(css);
-	mutex_lock(&cgroup_mutex);
 
 	/* CGRP_DEAD is set, remove from ->release_list for the last time */
 	raw_spin_lock(&release_list_lock);
@@ -4568,10 +4572,11 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	if (!cgrp->nr_css)
 		cgroup_destroy_css_killed(cgrp);
 
-	/* remove @cgrp directory along with the base files */
-	mutex_unlock(&cgroup_mutex);
-	kernfs_remove(cgrp->kn);	/* @cgrp has an extra ref on its kn */
-	mutex_lock(&cgroup_mutex);
+	/*
+	 * Remove @cgrp directory along with the base files.  @cgrp has an
+	 * extra ref on its kn.
+	 */
+	kernfs_remove(cgrp->kn);
 
 	return 0;
 };
-- 
1.9.0
