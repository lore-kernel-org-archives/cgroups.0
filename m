From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] cgroup: s/cgrp_dfl_root_/cgrp_dfl_/
Date: Thu,  7 Jan 2016 17:29:45 -0500
Message-ID: <1452205790-21331-2-git-send-email-tj@kernel.org>
References: <1452205790-21331-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7mjHmiujgobyeNljEBNYdMPTF+NayfCSEcWKg5hyhmI=;
        b=tSCl58d48Bhnd7zFqVSnc/PmG+ZsJATD4FQWc94YWMxS0hjT6n3aGzGzaKPDPCmfd3
         ylZwrscdphRIfHlGyO4c0quWFtyQZm0pVd8svOkknHVHchFobX7BCtAfLuCnU3IfEZJz
         +nnQ4PG343SjhDAthWVaMrlnPyAX1UmpX0R4gcazv2FRGWWGKyFFGYm6ZHB/2YRrfu7i
         Zerhx5xsNs5xGig53l2uTvH6gFWQrxoXjl/cs3DGm5hUawTrMvlb9rG0GvF6s40Uk3Iu
         glfaiuiBASzEmhpNsMDlxIf4V/tU/8xZNu/pA1HAgN5J/dr/D2ikh5uLTHkE3O0F4dPL
         v7IA==
In-Reply-To: <1452205790-21331-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, a.p.zijlstra@chello.nl, mingo@redhat.com, acme@kernel.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

These var names are unnecessarily unwiedly and another similar
variable will be added.  Let's shorten them.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 122ec55..f542264 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -177,10 +177,10 @@ EXPORT_SYMBOL_GPL(cgrp_dfl_root);
  * The default hierarchy always exists but is hidden until mounted for the
  * first time.  This is for backward compatibility.
  */
-static bool cgrp_dfl_root_visible;
+static bool cgrp_dfl_visible;
 
 /* some controllers are not supported in the default hierarchy */
-static unsigned long cgrp_dfl_root_inhibit_ss_mask;
+static unsigned long cgrp_dfl_inhibit_ss_mask;
 
 /* The list of hierarchy roots */
 
@@ -1473,7 +1473,7 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 	/* skip creating root files on dfl_root for inhibited subsystems */
 	tmp_ss_mask = ss_mask;
 	if (dst_root == &cgrp_dfl_root)
-		tmp_ss_mask &= ~cgrp_dfl_root_inhibit_ss_mask;
+		tmp_ss_mask &= ~cgrp_dfl_inhibit_ss_mask;
 
 	for_each_subsys_which(ss, ssid, &tmp_ss_mask) {
 		struct cgroup *scgrp = &ss->root->cgrp;
@@ -1490,7 +1490,7 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 		 * Just warn about it and continue.
 		 */
 		if (dst_root == &cgrp_dfl_root) {
-			if (cgrp_dfl_root_visible) {
+			if (cgrp_dfl_visible) {
 				pr_warn("failed to create files (%d) while rebinding 0x%lx to default root\n",
 					ret, ss_mask);
 				pr_warn("you may retry by moving them to a different hierarchy and unbinding\n");
@@ -1991,7 +1991,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 			pr_err("cgroup2: unknown option \"%s\"\n", (char *)data);
 			return ERR_PTR(-EINVAL);
 		}
-		cgrp_dfl_root_visible = true;
+		cgrp_dfl_visible = true;
 		root = &cgrp_dfl_root;
 		cgroup_get(&root->cgrp);
 		goto out_mount;
@@ -2842,7 +2842,7 @@ static int cgroup_root_controllers_show(struct seq_file *seq, void *v)
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
 
 	cgroup_print_ss_mask(seq, cgrp->root->subsys_mask &
-			     ~cgrp_dfl_root_inhibit_ss_mask);
+			     ~cgrp_dfl_inhibit_ss_mask);
 	return 0;
 }
 
@@ -2944,7 +2944,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	 */
 	buf = strstrip(buf);
 	while ((tok = strsep(&buf, " "))) {
-		unsigned long tmp_ss_mask = ~cgrp_dfl_root_inhibit_ss_mask;
+		unsigned long tmp_ss_mask = ~cgrp_dfl_inhibit_ss_mask;
 
 		if (tok[0] == '\0')
 			continue;
@@ -5312,7 +5312,7 @@ int __init cgroup_init(void)
 		cgrp_dfl_root.subsys_mask |= 1 << ss->id;
 
 		if (!ss->dfl_cftypes)
-			cgrp_dfl_root_inhibit_ss_mask |= 1 << ss->id;
+			cgrp_dfl_inhibit_ss_mask |= 1 << ss->id;
 
 		if (ss->dfl_cftypes == ss->legacy_cftypes) {
 			WARN_ON(cgroup_add_cftypes(ss, ss->dfl_cftypes));
@@ -5383,7 +5383,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		struct cgroup *cgrp;
 		int ssid, count = 0;
 
-		if (root == &cgrp_dfl_root && !cgrp_dfl_root_visible)
+		if (root == &cgrp_dfl_root && !cgrp_dfl_visible)
 			continue;
 
 		seq_printf(m, "%d:", root->hierarchy_id);
-- 
2.5.0

