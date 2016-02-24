From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/16] cgroup: introduce cgroup_control() and cgroup_ss_mask()
Date: Wed, 24 Feb 2016 17:02:37 -0500
Message-ID: <1456351368-786-6-git-send-email-tj@kernel.org>
References: <1456351368-786-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3UaUaP6j0MVPoSs5uUf4npaYfJsP5asvlyf4wG8GA74=;
        b=veGY8q4Y2cowVRd/1sAj/Vn/C9h3QQgNGSK4c2o4Yxe0k7WVRtBUCNCDeONkjLZxcD
         JGcQ0G4vyT3vAb/KGx6dDqYDWlDZJTklQppZwR/sdpfCN4zU2Zr/B9OVGZtkDH18sJ13
         waYRIt+FBt/VN3y664MDjV+MZHvbcZ48CLBMKXyX/YJAHdoiz7ljwZB0fSamqK4FtpJm
         N2LiQJL0qdaVPHgElouW+WSKw3vdXaSev8Q0A3Lt8WBkcHadhrLk+/PJDgRGodl2ERfn
         Mo6KZXUI6R1imwYVzwi/5bhrM2VL1/1fHcipen5b8DZRs0CkXCTCq/ChZwCjq8lfiCWF
         jAjg==
In-Reply-To: <1456351368-786-1-git-send-email-tj@kernel.org>
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

* cgroup_calc_subtree_ss_mask() and cgroup_subtree_control_write() no
  longer need to distinguish root and non-root cases.

* With cgroup_control(), cgroup_controllers_show() can now handle both
  root and non-root cases.  cgroup_root_controllers_show() is removed.

v2: cgroup_control() updated to yield the correct result on v1
    hierarchies too.  cgroup_subtree_control_write() converted.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 72 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 37 insertions(+), 35 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 070c078..ada8452 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -346,6 +346,32 @@ static struct cgroup *cgroup_parent(struct cgroup *cgrp)
 	return NULL;
 }
 
+/* subsystems visibly enabled on a cgroup */
+static u16 cgroup_control(struct cgroup *cgrp)
+{
+	struct cgroup *parent = cgroup_parent(cgrp);
+	u16 root_ss_mask = cgrp->root->subsys_mask;
+
+	if (parent)
+		return parent->subtree_control;
+
+	if (cgroup_on_dfl(cgrp))
+		root_ss_mask &= ~cgrp_dfl_inhibit_ss_mask;
+
+	return root_ss_mask;
+}
+
+/* subsystems enabled on a cgroup */
+static u16 cgroup_ss_mask(struct cgroup *cgrp)
+{
+	struct cgroup *parent = cgroup_parent(cgrp);
+
+	if (parent)
+		return parent->subtree_ss_mask;
+
+	return cgrp->root->subsys_mask;
+}
+
 /**
  * cgroup_css - obtain a cgroup's css for the specified subsystem
  * @cgrp: the cgroup of interest
@@ -385,16 +411,15 @@ static struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
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
@@ -1275,7 +1300,6 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
  */
 static u16 cgroup_calc_subtree_ss_mask(struct cgroup *cgrp, u16 subtree_control)
 {
-	struct cgroup *parent = cgroup_parent(cgrp);
 	u16 cur_ss_mask = subtree_control;
 	struct cgroup_subsys *ss;
 	int ssid;
@@ -1297,10 +1321,7 @@ static u16 cgroup_calc_subtree_ss_mask(struct cgroup *cgrp, u16 subtree_control)
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
@@ -2863,22 +2884,12 @@ static void cgroup_print_ss_mask(struct seq_file *seq, u16 ss_mask)
 		seq_putc(seq, '\n');
 }
 
-/* show controllers which are currently attached to the default hierarchy */
-static int cgroup_root_controllers_show(struct seq_file *seq, void *v)
-{
-	struct cgroup *cgrp = seq_css(seq)->cgroup;
-
-	cgroup_print_ss_mask(seq, cgrp->root->subsys_mask &
-			     ~cgrp_dfl_inhibit_ss_mask);
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
 
@@ -3004,10 +3015,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 				continue;
 			}
 
-			/* unavailable or not enabled on the parent? */
-			if (!(cgrp_dfl_root.subsys_mask & (1 << ssid)) ||
-			    (cgroup_parent(cgrp) &&
-			     !(cgroup_parent(cgrp)->subtree_control & (1 << ssid)))) {
+			if (!(cgroup_control(cgrp) & (1 << ssid))) {
 				ret = -ENOENT;
 				goto out_unlock;
 			}
@@ -4565,12 +4573,6 @@ static struct cftype cgroup_dfl_base_files[] = {
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
@@ -4941,7 +4943,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 	cgroup_idr_replace(&root->cgroup_idr, cgrp, cgrp->id);
 
 	/* create the csses */
-	do_each_subsys_mask(ss, ssid, parent->subtree_ss_mask) {
+	do_each_subsys_mask(ss, ssid, cgroup_ss_mask(cgrp)) {
 		struct cgroup_subsys_state *css;
 
 		css = css_create(cgrp, ss);
@@ -4956,7 +4958,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 	 * subtree_control from the parent.  Each is configured manually.
 	 */
 	if (!cgroup_on_dfl(cgrp)) {
-		cgrp->subtree_control = parent->subtree_control;
+		cgrp->subtree_control = cgroup_control(cgrp);
 		cgroup_refresh_subtree_ss_mask(cgrp);
 	}
 
@@ -5016,7 +5018,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	if (ret)
 		goto out_destroy;
 
-	do_each_subsys_mask(ss, ssid, parent->subtree_control) {
+	do_each_subsys_mask(ss, ssid, cgroup_control(cgrp)) {
 		ret = css_populate_dir(cgroup_css(cgrp, ss), NULL);
 		if (ret)
 			goto out_destroy;
-- 
2.5.0

