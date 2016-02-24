From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 14/16] cgroup: reimplement rebind_subsystems() using cgroup_apply_control() and friends
Date: Wed, 24 Feb 2016 17:02:46 -0500
Message-ID: <1456351368-786-15-git-send-email-tj@kernel.org>
References: <1456351368-786-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gwe4xz26pmOaUqxM+QGKJ770E+IAB8O1AQro9+TPWX8=;
        b=fSULutDvV4Qd1zWk9EIxEDuFbET6nQs3IMnUdiVR0xeVLWl9p9b5eiz9ehYGn4k3qy
         tXhmGs2smKkgRsiZpAB6Y7HLY4OHZavrEaPsTtLfhiEcyxhhYOZFq0LisEeh5zTbEqMc
         TDx6NDCawheyBcaPU1TCApx6t+xw4UDwpmMpkloo3EmFXvqfqOGjhTmT4LJnp6AEX6ip
         8i04JW6u1ZNlbfVhFjtAh82+QIm+JoRCLq88q9rYbeXkhSNkjDtzuCC4krwUrYHX0+Lv
         5Pt7carkqUG1VURc93yqflZtwDF/6QE0yi7UVBQhRb1xCGNgrHXfIdE8FIv3yXY8YS2D
         PvoA==
In-Reply-To: <1456351368-786-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

rebind_subsystem() open codes quite a bit of css and interface file
manipulations.  It tries to be fail-safe but doesn't quite achieve it.
It can be greatly simplified by using the new css management helpers.
This patch reimplements rebind_subsytsems() using
cgroup_apply_control() and friends.

* The half-baked rollback on file creation failure is dropped.  It is
  an extremely cold path, failure isn't critical, and, aside from
  kernel bugs, the only reason it can fail is memory allocation
  failure which pretty much doesn't happen for small allocations.

* As cgroup_apply_control_disable() is now used to clean up root
  cgroup on rebind, make sure that it doesn't end up killing root
  csses.

* All callers of rebind_subsystems() are updated to use
  cgroup_lock_and_drain_offline() as the apply_control functions
  require drained subtree.

* This leaves cgroup_refresh_subtree_ss_mask() without any user.
  Removed.

* css_populate_dir() and css_clear_dir() no longer needs
  @cgrp_override parameter.  Dropped.

* While at it, add WARN_ON() to rebind_subsystem() calls which are
  expected to always succeed just in case.

While the rules visible to userland aren't changed, this
reimplementation not only simplifies rebind_subsystems() but also
allows it to disable and enable csses recursively.  This can be used
to implement more flexible rebinding.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 107 +++++++++++++++-----------------------------------------
 1 file changed, 28 insertions(+), 79 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index efeaa54..01792a5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -221,6 +221,8 @@ static struct cftype cgroup_legacy_base_files[];
 
 static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask);
 static void cgroup_lock_and_drain_offline(struct cgroup *cgrp);
+static int cgroup_apply_control(struct cgroup *cgrp);
+static void cgroup_finalize_control(struct cgroup *cgrp, int ret);
 static void css_task_iter_advance(struct css_task_iter *it);
 static int cgroup_destroy_locked(struct cgroup *cgrp);
 static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
@@ -1159,13 +1161,13 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 	struct cgroup *cgrp = &root->cgrp;
 	struct cgrp_cset_link *link, *tmp_link;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
 
 	BUG_ON(atomic_read(&root->nr_cgrps));
 	BUG_ON(!list_empty(&cgrp->self.children));
 
 	/* Rebind all subsystems back to the default hierarchy */
-	rebind_subsystems(&cgrp_dfl_root, root->subsys_mask);
+	WARN_ON(rebind_subsystems(&cgrp_dfl_root, root->subsys_mask));
 
 	/*
 	 * Release all the links from cset_links to this hierarchy's
@@ -1351,19 +1353,6 @@ static u16 cgroup_calc_subtree_ss_mask(struct cgroup *cgrp, u16 subtree_control)
 }
 
 /**
- * cgroup_refresh_subtree_ss_mask - update subtree_ss_mask
- * @cgrp: the target cgroup
- *
- * Update @cgrp->subtree_ss_mask according to the current
- * @cgrp->subtree_control using cgroup_calc_subtree_ss_mask().
- */
-static void cgroup_refresh_subtree_ss_mask(struct cgroup *cgrp)
-{
-	cgrp->subtree_ss_mask =
-		cgroup_calc_subtree_ss_mask(cgrp, cgrp->subtree_control);
-}
-
-/**
  * cgroup_kn_unlock - unlocking helper for cgroup kernfs methods
  * @kn: the kernfs_node being serviced
  *
@@ -1458,12 +1447,10 @@ static void cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 /**
  * css_clear_dir - remove subsys files in a cgroup directory
  * @css: taget css
- * @cgrp_override: specify if target cgroup is different from css->cgroup
  */
-static void css_clear_dir(struct cgroup_subsys_state *css,
-			  struct cgroup *cgrp_override)
+static void css_clear_dir(struct cgroup_subsys_state *css)
 {
-	struct cgroup *cgrp = cgrp_override ?: css->cgroup;
+	struct cgroup *cgrp = css->cgroup;
 	struct cftype *cfts;
 
 	if (!(css->flags & CSS_VISIBLE))
@@ -1478,14 +1465,12 @@ static void css_clear_dir(struct cgroup_subsys_state *css,
 /**
  * css_populate_dir - create subsys files in a cgroup directory
  * @css: target css
- * @cgrp_overried: specify if target cgroup is different from css->cgroup
  *
  * On failure, no file is added.
  */
-static int css_populate_dir(struct cgroup_subsys_state *css,
-			    struct cgroup *cgrp_override)
+static int css_populate_dir(struct cgroup_subsys_state *css)
 {
-	struct cgroup *cgrp = cgrp_override ?: css->cgroup;
+	struct cgroup *cgrp = css->cgroup;
 	struct cftype *cfts, *failed_cfts;
 	int ret;
 
@@ -1525,7 +1510,6 @@ static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 {
 	struct cgroup *dcgrp = &dst_root->cgrp;
 	struct cgroup_subsys *ss;
-	u16 tmp_ss_mask;
 	int ssid, i, ret;
 
 	lockdep_assert_held(&cgroup_mutex);
@@ -1540,46 +1524,6 @@ static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 			return -EBUSY;
 	} while_each_subsys_mask();
 
-	/* skip creating root files on dfl_root for inhibited subsystems */
-	tmp_ss_mask = ss_mask;
-	if (dst_root == &cgrp_dfl_root)
-		tmp_ss_mask &= ~cgrp_dfl_inhibit_ss_mask;
-
-	do_each_subsys_mask(ss, ssid, tmp_ss_mask) {
-		struct cgroup *scgrp = &ss->root->cgrp;
-		int tssid;
-
-		ret = css_populate_dir(cgroup_css(scgrp, ss), dcgrp);
-		if (!ret)
-			continue;
-
-		/*
-		 * Rebinding back to the default root is not allowed to
-		 * fail.  Using both default and non-default roots should
-		 * be rare.  Moving subsystems back and forth even more so.
-		 * Just warn about it and continue.
-		 */
-		if (dst_root == &cgrp_dfl_root) {
-			if (cgrp_dfl_visible) {
-				pr_warn("failed to create files (%d) while rebinding 0x%x to default root\n",
-					ret, ss_mask);
-				pr_warn("you may retry by moving them to a different hierarchy and unbinding\n");
-			}
-			continue;
-		}
-
-		do_each_subsys_mask(ss, tssid, tmp_ss_mask) {
-			if (tssid == ssid)
-				break;
-			css_clear_dir(cgroup_css(scgrp, ss), dcgrp);
-		} while_each_subsys_mask();
-		return ret;
-	} while_each_subsys_mask();
-
-	/*
-	 * Nothing can fail from this point on.  Remove files for the
-	 * removed subsystems and rebind each subsystem.
-	 */
 	do_each_subsys_mask(ss, ssid, ss_mask) {
 		struct cgroup_root *src_root = ss->root;
 		struct cgroup *scgrp = &src_root->cgrp;
@@ -1588,8 +1532,12 @@ static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 
 		WARN_ON(!css || cgroup_css(dcgrp, ss));
 
-		css_clear_dir(css, NULL);
+		/* disable from the source */
+		src_root->subsys_mask &= ~(1 << ssid);
+		WARN_ON(cgroup_apply_control(scgrp));
+		cgroup_finalize_control(scgrp, 0);
 
+		/* rebind */
 		RCU_INIT_POINTER(scgrp->subsys[ssid], NULL);
 		rcu_assign_pointer(dcgrp->subsys[ssid], css);
 		ss->root = dst_root;
@@ -1601,20 +1549,20 @@ static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 				       &dcgrp->e_csets[ss->id]);
 		spin_unlock_bh(&css_set_lock);
 
-		src_root->subsys_mask &= ~(1 << ssid);
-		scgrp->subtree_control &= ~(1 << ssid);
-		cgroup_refresh_subtree_ss_mask(scgrp);
-
 		/* default hierarchy doesn't enable controllers by default */
 		dst_root->subsys_mask |= 1 << ssid;
 		if (dst_root == &cgrp_dfl_root) {
 			static_branch_enable(cgroup_subsys_on_dfl_key[ssid]);
 		} else {
 			dcgrp->subtree_control |= 1 << ssid;
-			cgroup_refresh_subtree_ss_mask(dcgrp);
 			static_branch_disable(cgroup_subsys_on_dfl_key[ssid]);
 		}
 
+		ret = cgroup_apply_control(dcgrp);
+		if (ret)
+			pr_warn("partial failure to rebind %s controller (err=%d)\n",
+				ss->name, ret);
+
 		if (ss->bind)
 			ss->bind(css);
 	} while_each_subsys_mask();
@@ -1806,7 +1754,7 @@ static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 		return -EINVAL;
 	}
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
 
 	/* See what subsystems are wanted */
 	ret = parse_cgroupfs_options(data, &opts);
@@ -1839,7 +1787,7 @@ static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 	if (ret)
 		goto out_unlock;
 
-	rebind_subsystems(&cgrp_dfl_root, removed_mask);
+	WARN_ON(rebind_subsystems(&cgrp_dfl_root, removed_mask));
 
 	if (opts.release_agent) {
 		spin_lock(&release_agent_path_lock);
@@ -1990,7 +1938,7 @@ static int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 	}
 	root_cgrp->kn = root->kf_root->kn;
 
-	ret = css_populate_dir(&root_cgrp->self, NULL);
+	ret = css_populate_dir(&root_cgrp->self);
 	if (ret)
 		goto destroy_root;
 
@@ -2069,7 +2017,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		goto out_mount;
 	}
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
 
 	/* First find the desired set of subsystems */
 	ret = parse_cgroupfs_options(data, &opts);
@@ -3122,7 +3070,7 @@ static int cgroup_apply_control_enable(struct cgroup *cgrp)
 			}
 
 			if (cgroup_control(dsct) & (1 << ss->id)) {
-				ret = css_populate_dir(css, NULL);
+				ret = css_populate_dir(css);
 				if (ret)
 					return ret;
 			}
@@ -3161,10 +3109,11 @@ static void cgroup_apply_control_disable(struct cgroup *cgrp)
 			if (!css)
 				continue;
 
-			if (!(cgroup_ss_mask(dsct) & (1 << ss->id))) {
+			if (css->parent &&
+			    !(cgroup_ss_mask(dsct) & (1 << ss->id))) {
 				kill_css(css);
 			} else if (!(cgroup_control(dsct) & (1 << ss->id))) {
-				css_clear_dir(css, NULL);
+				css_clear_dir(css);
 				if (ss->css_reset)
 					ss->css_reset(css);
 			}
@@ -5155,7 +5104,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	if (ret)
 		goto out_destroy;
 
-	ret = css_populate_dir(&cgrp->self, NULL);
+	ret = css_populate_dir(&cgrp->self);
 	if (ret)
 		goto out_destroy;
 
@@ -5227,7 +5176,7 @@ static void kill_css(struct cgroup_subsys_state *css)
 	 * This must happen before css is disassociated with its cgroup.
 	 * See seq_css() for details.
 	 */
-	css_clear_dir(css, NULL);
+	css_clear_dir(css);
 
 	/*
 	 * Killing would put the base ref, but we need to keep it alive
-- 
2.5.0
