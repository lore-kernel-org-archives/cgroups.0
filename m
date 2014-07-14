From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/6] cgroup: split cgroup_base_files[] into cgroup_{dfl|legacy}_base_files[]
Date: Mon, 14 Jul 2014 11:44:03 -0400
Message-ID: <1405352648-4279-2-git-send-email-tj@kernel.org>
References: <1405352648-4279-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JFFrL76WmI1B4U2NPf0TTv7LHvXB1gYBaBJR2SK7idk=;
        b=UgzwY7YDJju2vMTUaI3fXXt8eUeaRoIN02gUrTSeXQEHzPZl8A+wZ6+er87eCFI3t8
         hbv2y+87x2n+Hzdg/s5XXM2yLLFu/vEWp4Nft1mMAxF4g/j8e78j6s1I6vXVZqii1sxE
         6Wp5rVn8pDMmeI1kTM/aWK11vM+ZixDrJLo57KX7ylg5e/4A70WiPwRex93Eh8llPevM
         MeDim2xerCHgx7NzBP9lYLDHP2poelxXlimE8GhFDbTiKPl9kVm7G08tqEa8ASFWj+qf
         RxiBWyD5I35FA9MH5vXP+vmSr+igB+dEW0foQW35iRg8A+yjJZg7QAw0/+JzSKvPppXe
         wXVw==
In-Reply-To: <1405352648-4279-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jet Chen <jet.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Currently cgroup_base_files[] contains the cgroup core interface files
for both legacy and default hierarchies with each file tagged with
CFTYPE_INSANE and CFTYPE_ONLY_ON_DFL.  This is difficult to read.

Let's separate it out to two separate tables, cgroup_dfl_base_files[]
and cgroup_legacy_base_files[], and use the appropriate one in
cgroup_mkdir() depending on the hierarchy type.  This makes tagging
each file unnecessary.

This patch doesn't introduce any behavior changes.

v2: cgroup_dfl_base_files[] was missing the termination entry
    triggering WARN in cgroup_init_cftypes() for 0day kernel testing
    robot.  Fixed.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jet Chen <jet.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup.c | 76 ++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 48 insertions(+), 28 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 28f7d47..7e5fee5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -180,7 +180,8 @@ static u64 css_serial_nr_next = 1;
  */
 static int need_forkexit_callback __read_mostly;
 
-static struct cftype cgroup_base_files[];
+static struct cftype cgroup_dfl_base_files[];
+static struct cftype cgroup_legacy_base_files[];
 
 static void cgroup_put(struct cgroup *cgrp);
 static int rebind_subsystems(struct cgroup_root *dst_root,
@@ -1614,6 +1615,7 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned int ss_mask)
 {
 	LIST_HEAD(tmp_links);
 	struct cgroup *root_cgrp = &root->cgrp;
+	struct cftype *base_files;
 	struct css_set *cset;
 	int i, ret;
 
@@ -1651,7 +1653,12 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned int ss_mask)
 	}
 	root_cgrp->kn = root->kf_root->kn;
 
-	ret = cgroup_addrm_files(root_cgrp, cgroup_base_files, true);
+	if (root == &cgrp_dfl_root)
+		base_files = cgroup_dfl_base_files;
+	else
+		base_files = cgroup_legacy_base_files;
+
+	ret = cgroup_addrm_files(root_cgrp, base_files, true);
 	if (ret)
 		goto destroy_root;
 
@@ -4095,7 +4102,8 @@ static int cgroup_clone_children_write(struct cgroup_subsys_state *css,
 	return 0;
 }
 
-static struct cftype cgroup_base_files[] = {
+/* cgroup core interface files for the default hierarchy */
+static struct cftype cgroup_dfl_base_files[] = {
 	{
 		.name = "cgroup.procs",
 		.seq_start = cgroup_pidlist_start,
@@ -4107,46 +4115,52 @@ static struct cftype cgroup_base_files[] = {
 		.mode = S_IRUGO | S_IWUSR,
 	},
 	{
-		.name = "cgroup.clone_children",
-		.flags = CFTYPE_INSANE,
-		.read_u64 = cgroup_clone_children_read,
-		.write_u64 = cgroup_clone_children_write,
-	},
-	{
-		.name = "cgroup.sane_behavior",
-		.flags = CFTYPE_INSANE | CFTYPE_ONLY_ON_ROOT,
-		.seq_show = cgroup_sane_behavior_show,
-	},
-	{
 		.name = "cgroup.controllers",
-		.flags = CFTYPE_ONLY_ON_DFL | CFTYPE_ONLY_ON_ROOT,
+		.flags = CFTYPE_ONLY_ON_ROOT,
 		.seq_show = cgroup_root_controllers_show,
 	},
 	{
 		.name = "cgroup.controllers",
-		.flags = CFTYPE_ONLY_ON_DFL | CFTYPE_NOT_ON_ROOT,
+		.flags = CFTYPE_NOT_ON_ROOT,
 		.seq_show = cgroup_controllers_show,
 	},
 	{
 		.name = "cgroup.subtree_control",
-		.flags = CFTYPE_ONLY_ON_DFL,
 		.seq_show = cgroup_subtree_control_show,
 		.write = cgroup_subtree_control_write,
 	},
 	{
 		.name = "cgroup.populated",
-		.flags = CFTYPE_ONLY_ON_DFL | CFTYPE_NOT_ON_ROOT,
+		.flags = CFTYPE_NOT_ON_ROOT,
 		.seq_show = cgroup_populated_show,
 	},
+	{ }	/* terminate */
+};
 
-	/*
-	 * Historical crazy stuff.  These don't have "cgroup."  prefix and
-	 * don't exist if sane_behavior.  If you're depending on these, be
-	 * prepared to be burned.
-	 */
+/* cgroup core interface files for the legacy hierarchies */
+static struct cftype cgroup_legacy_base_files[] = {
+	{
+		.name = "cgroup.procs",
+		.seq_start = cgroup_pidlist_start,
+		.seq_next = cgroup_pidlist_next,
+		.seq_stop = cgroup_pidlist_stop,
+		.seq_show = cgroup_pidlist_show,
+		.private = CGROUP_FILE_PROCS,
+		.write = cgroup_procs_write,
+		.mode = S_IRUGO | S_IWUSR,
+	},
+	{
+		.name = "cgroup.clone_children",
+		.read_u64 = cgroup_clone_children_read,
+		.write_u64 = cgroup_clone_children_write,
+	},
+	{
+		.name = "cgroup.sane_behavior",
+		.flags = CFTYPE_ONLY_ON_ROOT,
+		.seq_show = cgroup_sane_behavior_show,
+	},
 	{
 		.name = "tasks",
-		.flags = CFTYPE_INSANE,		/* use "procs" instead */
 		.seq_start = cgroup_pidlist_start,
 		.seq_next = cgroup_pidlist_next,
 		.seq_stop = cgroup_pidlist_stop,
@@ -4157,13 +4171,12 @@ static struct cftype cgroup_base_files[] = {
 	},
 	{
 		.name = "notify_on_release",
-		.flags = CFTYPE_INSANE,
 		.read_u64 = cgroup_read_notify_on_release,
 		.write_u64 = cgroup_write_notify_on_release,
 	},
 	{
 		.name = "release_agent",
-		.flags = CFTYPE_INSANE | CFTYPE_ONLY_ON_ROOT,
+		.flags = CFTYPE_ONLY_ON_ROOT,
 		.seq_show = cgroup_release_agent_show,
 		.write = cgroup_release_agent_write,
 		.max_write_len = PATH_MAX - 1,
@@ -4444,6 +4457,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	struct cgroup_root *root;
 	struct cgroup_subsys *ss;
 	struct kernfs_node *kn;
+	struct cftype *base_files;
 	int ssid, ret;
 
 	parent = cgroup_kn_lock_live(parent_kn);
@@ -4514,7 +4528,12 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	if (ret)
 		goto out_destroy;
 
-	ret = cgroup_addrm_files(cgrp, cgroup_base_files, true);
+	if (cgroup_on_dfl(cgrp))
+		base_files = cgroup_dfl_base_files;
+	else
+		base_files = cgroup_legacy_base_files;
+
+	ret = cgroup_addrm_files(cgrp, base_files, true);
 	if (ret)
 		goto out_destroy;
 
@@ -4836,7 +4855,8 @@ int __init cgroup_init(void)
 	unsigned long key;
 	int ssid, err;
 
-	BUG_ON(cgroup_init_cftypes(NULL, cgroup_base_files));
+	BUG_ON(cgroup_init_cftypes(NULL, cgroup_dfl_base_files));
+	BUG_ON(cgroup_init_cftypes(NULL, cgroup_legacy_base_files));
 
 	mutex_lock(&cgroup_mutex);
 
-- 
1.9.3
