From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/12] cgroup: introduce cgroup_control() and cgroup_ss_mask()
Date: Mon, 22 Feb 2016 22:45:39 -0500
Message-ID: <1456199146-14765-6-git-send-email-tj@kernel.org>
References: <1456199146-14765-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BefpeiL+ZQr0TGKtl4MuJvyBpqNK9VBhKLQ7Dd/iEEU=;
        b=cv8hbIV4lkHCbtUK7PyNbReC+kD8YpaF1giRVTj/oFIBd/KMojJuuYIe7Al5wN++xP
         Af6TK38SyRWMBWb4Dtq/MkZK27Vmhf0iluUHKryfa0ojtimXGQLlYMBTyoNcPRCM+gSk
         1+O//P7HHambvGD5wcdP1l0HPZFZW2ZecNEtQi09X96gaAfagG/oO0871M2/1bDAKd3P
         SPQ53QekQT3FfJXB6C28w0HNazca5BoBMnY/oALHMfZjI1yImDqVWFlIAHVtVH15je3T
         4S2YLfPcMKE/10gnSShOr1piMFVuLgDhb0oRNaHOfMmu7tsjt6r5y4029jrWO/ajqYHj
         4HAQ==
In-Reply-To: <1456199146-14765-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

When a controller is enabled and visible on a non-root cgroup is
determined by subtree_control and subtree_ss_mask of the parent
cgroup.  For a root cgroup, by the type of the hierarchy and which
controllers are attached to it.  Deciding the above on each usage is
fragile and unnecessarily complicates the users.

This patch introduces cgroup_control() and cgroup_ss_mask() which
calculate and return the [visibly] enabled subsyste mask for the
specified cgroup and conver the existing usages.

* cgroup_e_css() is restructured for simplicity.

* cgroup_calc_subtree_ss_mask() no longer needs to distinguish root
  and non-root cases.

* With cgroup_control(), cgroup_controllers_show() can now handle both
  root and non-root cases.  cgroup_root_controllers_show() is removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 63 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 16c04d1..0282797 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -346,6 +346,28 @@ static struct cgroup *cgroup_parent(struct cgroup *cgrp)
 	return NULL;
 }
 
+/* subsystems visibly enabled on a cgroup */
+static u16 cgroup_control(struct cgroup *cgrp)
+{
+	struct cgroup *parent = cgroup_parent(cgrp);
+
+	if (!parent)
+		return cgrp->root->subsys_mask & ~cgrp_dfl_root_inhibit_ss_mask;
+
+	return parent->subtree_control;
+}
+
+/* subsystems enabled on a cgroup */
+static u16 cgroup_ss_mask(struct cgroup *cgrp)
+{
+	struct cgroup *parent = cgroup_parent(cgrp);
+
+	if (!parent)
+		return cgrp->root->subsys_mask;
+
+	return parent->subtree_ss_mask;
+}
+
 /**
  * cgroup_css - obtain a cgroup's css for the specified subsystem
  * @cgrp: the cgroup of interest
@@ -385,16 +407,15 @@ static struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
 	if (!ss)
 		return &cgrp->self;
 
-	if (!(cgrp->root->subsys_mask & (1 << ss->id)))
-		return NULL;
-
 	/*
 	 * This function is used while updating css associations and thus
-	 * can't test the csses directly.  Use ->subtree_ss_mask.
+	 * can't test the csses directly.  Test ss_mask.
 	 */
-	while (cgroup_parent(cgrp) &&
-	       !(cgroup_parent(cgrp)->subtree_ss_mask & (1 << ss->id)))
+	while (!(cgroup_ss_mask(cgrp) & (1 << ss->id))) {
 		cgrp = cgroup_parent(cgrp);
+		if (!cgrp)
+			return NULL;
+	}
 
 	return cgroup_css(cgrp, ss);
 }
@@ -1275,7 +1296,6 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
  */
 static u16 cgroup_calc_subtree_ss_mask(struct cgroup *cgrp, u16 subtree_control)
 {
-	struct cgroup *parent = cgroup_parent(cgrp);
 	u16 cur_ss_mask = subtree_control;
 	struct cgroup_subsys *ss;
 	int ssid;
@@ -1297,10 +1317,7 @@ static u16 cgroup_calc_subtree_ss_mask(struct cgroup *cgrp, u16 subtree_control)
 		 * happen only if some depended-upon subsystems were bound
 		 * to non-default hierarchies.
 		 */
-		if (parent)
-			new_ss_mask &= parent->subtree_ss_mask;
-		else
-			new_ss_mask &= cgrp->root->subsys_mask;
+		new_ss_mask &= cgroup_ss_mask(cgrp);
 
 		if (new_ss_mask == cur_ss_mask)
 			break;
@@ -2863,22 +2880,12 @@ static void cgroup_print_ss_mask(struct seq_file *seq, u16 ss_mask)
 		seq_putc(seq, '\n');
 }
 
-/* show controllers which are currently attached to the default hierarchy */
-static int cgroup_root_controllers_show(struct seq_file *seq, void *v)
-{
-	struct cgroup *cgrp = seq_css(seq)->cgroup;
-
-	cgroup_print_ss_mask(seq, cgrp->root->subsys_mask &
-			     ~cgrp_dfl_root_inhibit_ss_mask);
-	return 0;
-}
-
 /* show controllers which are enabled from the parent */
 static int cgroup_controllers_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
 
-	cgroup_print_ss_mask(seq, cgroup_parent(cgrp)->subtree_control);
+	cgroup_print_ss_mask(seq, cgroup_control(cgrp));
 	return 0;
 }
 
@@ -4565,12 +4572,6 @@ static struct cftype cgroup_dfl_base_files[] = {
 	},
 	{
 		.name = "cgroup.controllers",
-		.flags = CFTYPE_ONLY_ON_ROOT,
-		.seq_show = cgroup_root_controllers_show,
-	},
-	{
-		.name = "cgroup.controllers",
-		.flags = CFTYPE_NOT_ON_ROOT,
 		.seq_show = cgroup_controllers_show,
 	},
 	{
@@ -4941,7 +4942,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 	cgroup_idr_replace(&root->cgroup_idr, cgrp, cgrp->id);
 
 	/* create the csses */
-	do_each_subsys_mask(ss, ssid, parent->subtree_ss_mask) {
+	do_each_subsys_mask(ss, ssid, cgroup_ss_mask(cgrp)) {
 		struct cgroup_subsys_state *css;
 
 		css = css_create(cgrp, ss);
@@ -4956,7 +4957,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 	 * subtree_control from the parent.  Each is configured manually.
 	 */
 	if (!cgroup_on_dfl(cgrp)) {
-		cgrp->subtree_control = parent->subtree_control;
+		cgrp->subtree_control = cgroup_control(cgrp);
 		cgroup_refresh_subtree_ss_mask(cgrp);
 	}
 
@@ -5016,7 +5017,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	if (ret)
 		goto out_destroy;
 
-	do_each_subsys_mask(ss, ssid, parent->subtree_control) {
+	do_each_subsys_mask(ss, ssid, cgroup_control(cgrp)) {
 		ret = css_populate_dir(cgroup_css(cgrp, ss), NULL);
 		if (ret)
 			goto out_destroy;
-- 
2.5.0

