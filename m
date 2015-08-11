From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/8] cgroup: restructure file creation / removal handling
Date: Tue, 11 Aug 2015 13:58:07 -0400
Message-ID: <1439315889-3492-7-git-send-email-tj@kernel.org>
References: <1439315889-3492-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L03/XzCI/9sedA81KjPu/4EPIhXzv7K/8Dqbi1P2PuA=;
        b=ZNd8qYHz8eHM30RdQpYqNPbWirwr+i7JV2aEkLNIbj2zHkvnr1qMUMpGQ5dTwn7LzY
         1INy6f6xZGltWqpe1aUt1qSOju6zHKEXSSO/BfCIMMZKpimk1P8PJuRWDXTVsXGa9Gpd
         tqpMRbEdWbHfAHmZMI44BlBkxnRwQjt8vJvUaFQQmTmecCc5fep4eBP+QlZUfBg6xg81
         asxWGj+ZcTvPaoT9UCyxu1CJGqXOeuICuCU4HT36C4D9En4xNtRnOrCFWw6A44Vq7og9
         2Mh6alM08Lec1gJmyQBbhQDbM7KOfGVz/GOcxo2kmuvEFY5+npPV5cZxgkK+kVLd1Uci
         u03w==
In-Reply-To: <1439315889-3492-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, lizefan@huawei.com
Cc: mhocko@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

The file creation / removal path has always been a bit icky and the
planned notification update requires css during file creation.
Restructure as follows.

* cgroup_addrm_files() now takes both @css and @cgrp and is only
  called directly by other file handling functions.

* cgroup_populate/clear_dir() are replaced with
  css_populate/clear_dir() taking @css and @cgrp_override.
  @cgrp_override is used only when files needs to be created on /
  removed from a cgroup which isn't attached to @css which happens
  during subsystem rebinds.  Subsystem loops are moved to the callers.

* cgroup_add_file() now takes both @css and @cgrp.  @css isn't used
  yet but will be used by the planned notification update.

This patch doens't cause any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 kernel/cgroup.c | 143 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 76 insertions(+), 67 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 67d2ba3..b287522 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -200,7 +200,8 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss,
 		      bool visible);
 static void css_release(struct percpu_ref *ref);
 static void kill_css(struct cgroup_subsys_state *css);
-static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
+static int cgroup_addrm_files(struct cgroup_subsys_state *css,
+			      struct cgroup *cgrp, struct cftype cfts[],
 			      bool is_add);
 
 /* IDR wrappers which synchronize using cgroup_idr_lock */
@@ -1218,53 +1219,57 @@ static void cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 }
 
 /**
- * cgroup_clear_dir - remove subsys files in a cgroup directory
- * @cgrp: target cgroup
- * @subsys_mask: mask of the subsystem ids whose files should be removed
+ * css_clear_dir - remove subsys files in a cgroup directory
+ * @css: taget css
+ * @cgrp_override: specify if target cgroup is different from css->cgroup
  */
-static void cgroup_clear_dir(struct cgroup *cgrp, unsigned long subsys_mask)
+static void css_clear_dir(struct cgroup_subsys_state *css,
+			  struct cgroup *cgrp_override)
 {
-	struct cgroup_subsys *ss;
-	int i;
+	struct cgroup *cgrp = cgrp_override ?: css->cgroup;
+	struct cftype *cfts;
 
-	for_each_subsys(ss, i) {
-		struct cftype *cfts;
-
-		if (!(subsys_mask & (1 << i)))
-			continue;
-		list_for_each_entry(cfts, &ss->cfts, node)
-			cgroup_addrm_files(cgrp, cfts, false);
-	}
+	list_for_each_entry(cfts, &css->ss->cfts, node)
+		cgroup_addrm_files(css, cgrp, cfts, false);
 }
 
 /**
- * cgroup_populate_dir - create subsys files in a cgroup directory
- * @cgrp: target cgroup
- * @subsys_mask: mask of the subsystem ids whose files should be added
+ * css_populate_dir - create subsys files in a cgroup directory
+ * @css: target css
+ * @cgrp_overried: specify if target cgroup is different from css->cgroup
  *
  * On failure, no file is added.
  */
-static int cgroup_populate_dir(struct cgroup *cgrp, unsigned long subsys_mask)
+static int css_populate_dir(struct cgroup_subsys_state *css,
+			    struct cgroup *cgrp_override)
 {
-	struct cgroup_subsys *ss;
-	int i, ret = 0;
+	struct cgroup *cgrp = cgrp_override ?: css->cgroup;
+	struct cftype *cfts, *failed_cfts;
+	int ret;
 
-	/* process cftsets of each subsystem */
-	for_each_subsys(ss, i) {
-		struct cftype *cfts;
+	if (!css->ss) {
+		if (cgroup_on_dfl(cgrp))
+			cfts = cgroup_dfl_base_files;
+		else
+			cfts = cgroup_legacy_base_files;
 
-		if (!(subsys_mask & (1 << i)))
-			continue;
+		return cgroup_addrm_files(&cgrp->self, cgrp, cfts, true);
+	}
 
-		list_for_each_entry(cfts, &ss->cfts, node) {
-			ret = cgroup_addrm_files(cgrp, cfts, true);
-			if (ret < 0)
-				goto err;
+	list_for_each_entry(cfts, &css->ss->cfts, node) {
+		ret = cgroup_addrm_files(css, cgrp, cfts, true);
+		if (ret < 0) {
+			failed_cfts = cfts;
+			goto err;
 		}
 	}
 	return 0;
 err:
-	cgroup_clear_dir(cgrp, subsys_mask);
+	list_for_each_entry(cfts, &css->ss->cfts, node) {
+		if (cfts == failed_cfts)
+			break;
+		cgroup_addrm_files(css, cgrp, cfts, false);
+	}
 	return ret;
 }
 
@@ -1293,10 +1298,13 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 	if (dst_root == &cgrp_dfl_root)
 		tmp_ss_mask &= ~cgrp_dfl_root_inhibit_ss_mask;
 
-	ret = cgroup_populate_dir(dcgrp, tmp_ss_mask);
-	if (ret) {
-		if (dst_root != &cgrp_dfl_root)
-			return ret;
+	for_each_subsys_which(ss, ssid, &tmp_ss_mask) {
+		struct cgroup *scgrp = &ss->root->cgrp;
+		int tssid;
+
+		ret = css_populate_dir(cgroup_css(scgrp, ss), dcgrp);
+		if (!ret)
+			continue;
 
 		/*
 		 * Rebinding back to the default root is not allowed to
@@ -1304,20 +1312,27 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 		 * be rare.  Moving subsystems back and forth even more so.
 		 * Just warn about it and continue.
 		 */
-		if (cgrp_dfl_root_visible) {
-			pr_warn("failed to create files (%d) while rebinding 0x%lx to default root\n",
-				ret, ss_mask);
-			pr_warn("you may retry by moving them to a different hierarchy and unbinding\n");
+		if (dst_root == &cgrp_dfl_root) {
+			if (cgrp_dfl_root_visible) {
+				pr_warn("failed to create files (%d) while rebinding 0x%lx to default root\n",
+					ret, ss_mask);
+				pr_warn("you may retry by moving them to a different hierarchy and unbinding\n");
+			}
+			continue;
 		}
+
+		for_each_subsys_which(ss, tssid, &tmp_ss_mask) {
+			if (tssid == ssid)
+				break;
+			css_clear_dir(cgroup_css(scgrp, ss), dcgrp);
+		}
+		return ret;
 	}
 
 	/*
 	 * Nothing can fail from this point on.  Remove files for the
 	 * removed subsystems and rebind each subsystem.
 	 */
-	for_each_subsys_which(ss, ssid, &ss_mask)
-		cgroup_clear_dir(&ss->root->cgrp, 1 << ssid);
-
 	for_each_subsys_which(ss, ssid, &ss_mask) {
 		struct cgroup_root *src_root = ss->root;
 		struct cgroup *scgrp = &src_root->cgrp;
@@ -1326,6 +1341,8 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 
 		WARN_ON(!css || cgroup_css(dcgrp, ss));
 
+		css_clear_dir(css, NULL);
+
 		RCU_INIT_POINTER(scgrp->subsys[ssid], NULL);
 		rcu_assign_pointer(dcgrp->subsys[ssid], css);
 		ss->root = dst_root;
@@ -1691,7 +1708,6 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned long ss_mask)
 {
 	LIST_HEAD(tmp_links);
 	struct cgroup *root_cgrp = &root->cgrp;
-	struct cftype *base_files;
 	struct css_set *cset;
 	int i, ret;
 
@@ -1730,12 +1746,7 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned long ss_mask)
 	}
 	root_cgrp->kn = root->kf_root->kn;
 
-	if (root == &cgrp_dfl_root)
-		base_files = cgroup_dfl_base_files;
-	else
-		base_files = cgroup_legacy_base_files;
-
-	ret = cgroup_addrm_files(root_cgrp, base_files, true);
+	ret = css_populate_dir(&root_cgrp->self, NULL);
 	if (ret)
 		goto destroy_root;
 
@@ -2884,7 +2895,8 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 				ret = create_css(child, ss,
 					cgrp->subtree_control & (1 << ssid));
 			else
-				ret = cgroup_populate_dir(child, 1 << ssid);
+				ret = css_populate_dir(cgroup_css(child, ss),
+						       NULL);
 			if (ret)
 				goto err_undo_css;
 		}
@@ -2917,7 +2929,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 			if (css_disable & (1 << ssid)) {
 				kill_css(css);
 			} else {
-				cgroup_clear_dir(child, 1 << ssid);
+				css_clear_dir(css, NULL);
 				if (ss->css_reset)
 					ss->css_reset(css);
 			}
@@ -2965,7 +2977,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 			if (css_enable & (1 << ssid))
 				kill_css(css);
 			else
-				cgroup_clear_dir(child, 1 << ssid);
+				css_clear_dir(css, NULL);
 		}
 	}
 	goto out_unlock;
@@ -3117,7 +3129,8 @@ static int cgroup_kn_set_ugid(struct kernfs_node *kn)
 	return kernfs_setattr(kn, &iattr);
 }
 
-static int cgroup_add_file(struct cgroup *cgrp, struct cftype *cft)
+static int cgroup_add_file(struct cgroup_subsys_state *css, struct cgroup *cgrp,
+			   struct cftype *cft)
 {
 	char name[CGROUP_FILE_NAME_MAX];
 	struct kernfs_node *kn;
@@ -3148,14 +3161,16 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cftype *cft)
 
 /**
  * cgroup_addrm_files - add or remove files to a cgroup directory
- * @cgrp: the target cgroup
+ * @css: the target css
+ * @cgrp: the target cgroup (usually css->cgroup)
  * @cfts: array of cftypes to be added
  * @is_add: whether to add or remove
  *
  * Depending on @is_add, add or remove files defined by @cfts on @cgrp.
  * For removals, this function never fails.
  */
-static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
+static int cgroup_addrm_files(struct cgroup_subsys_state *css,
+			      struct cgroup *cgrp, struct cftype cfts[],
 			      bool is_add)
 {
 	struct cftype *cft, *cft_end = NULL;
@@ -3176,7 +3191,7 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 			continue;
 
 		if (is_add) {
-			ret = cgroup_add_file(cgrp, cft);
+			ret = cgroup_add_file(css, cgrp, cft);
 			if (ret) {
 				pr_warn("%s: failed to add %s, err=%d\n",
 					__func__, cft->name, ret);
@@ -3208,7 +3223,7 @@ static int cgroup_apply_cftypes(struct cftype *cfts, bool is_add)
 		if (cgroup_is_dead(cgrp))
 			continue;
 
-		ret = cgroup_addrm_files(cgrp, cfts, is_add);
+		ret = cgroup_addrm_files(css, cgrp, cfts, is_add);
 		if (ret)
 			break;
 	}
@@ -4584,7 +4599,7 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss,
 	css->id = err;
 
 	if (visible) {
-		err = cgroup_populate_dir(cgrp, 1 << ss->id);
+		err = css_populate_dir(css, NULL);
 		if (err)
 			goto err_free_id;
 	}
@@ -4610,7 +4625,7 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss,
 
 err_list_del:
 	list_del_rcu(&css->sibling);
-	cgroup_clear_dir(css->cgroup, 1 << css->ss->id);
+	css_clear_dir(css, NULL);
 err_free_id:
 	cgroup_idr_remove(&ss->css_idr, css->id);
 err_free_percpu_ref:
@@ -4627,7 +4642,6 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	struct cgroup_root *root;
 	struct cgroup_subsys *ss;
 	struct kernfs_node *kn;
-	struct cftype *base_files;
 	int ssid, ret;
 
 	/* Do not accept '\n' to prevent making /proc/<pid>/cgroup unparsable.
@@ -4703,12 +4717,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	if (ret)
 		goto out_destroy;
 
-	if (cgroup_on_dfl(cgrp))
-		base_files = cgroup_dfl_base_files;
-	else
-		base_files = cgroup_legacy_base_files;
-
-	ret = cgroup_addrm_files(cgrp, base_files, true);
+	ret = css_populate_dir(&cgrp->self, NULL);
 	if (ret)
 		goto out_destroy;
 
@@ -4795,7 +4804,7 @@ static void kill_css(struct cgroup_subsys_state *css)
 	 * This must happen before css is disassociated with its cgroup.
 	 * See seq_css() for details.
 	 */
-	cgroup_clear_dir(css->cgroup, 1 << css->ss->id);
+	css_clear_dir(css, NULL);
 
 	/*
 	 * Killing would put the base ref, but we need to keep it alive
-- 
2.4.3
