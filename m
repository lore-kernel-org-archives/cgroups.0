From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] cgroup: clean up sane_behavior handling
Date: Wed,  2 Jul 2014 19:45:47 -0400
Message-ID: <1404344747-7957-5-git-send-email-tj@kernel.org>
References: <1404344747-7957-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Q6ID/k5hFvPhKV8JH6+88wH8KnMzBMF/kCFL8RrvxRU=;
        b=QRLeVjHMqNcZg90ZcaFFIEoWwqO9sNaARJVf7I7AAbRubonalPKeWS4S3dHVYpvWbu
         Sqf00wlsyIAjJT0l7CtEfGgd/6OenNilt36soXpep1nMPOes3Brio1ZRy/BDkJe0KAeB
         VPPugSzI5apsRSClF5vqO+m919f0gv7M52rAlM6LIVAn2io5huT0th53X5JYyadtolE4
         UhusSMFY16FuAEP+AYzAWSemx2sb6RKTd4K4hPqlrdtoB1Vr+EWSNetqrMVP94EwJyoW
         DFVPrlyO8dJFJdXfa9CB+rkFREnOwleuQFgLisLiWvfss91Xv3xDOmij4fn36ZoIYK3q
         s2yA==
In-Reply-To: <1404344747-7957-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

After the previous patch to remove sane_behavior support from
non-default hierarchies, CGRP_ROOT_SANE_BEHAVIOR is used only to
indicate the default hierarchy while parsing mount options.  This
patch makes the following cleanups around it.

* Don't show it in the mount option.  Eventually the default hierarchy
  will be assigned a different filesystem type.

* As sane_behavior is no longer effective on non-default hierarchies
  and the default hierarchy doesn't accept any mount options,
  parse_cgroupfs_options() can consider sane_behavior mount option as
  indicating the default hierarchy and fail if any other options are
  specified with it.  While at it, remove one of the double blank
  lines in the function.

* cgroup_mount() can now simply test CGRP_ROOT_SANE_BEHAVIOR to tell
  whether to mount the default hierarchy or not.

* As CGROUP_ROOT_SANE_BEHAVIOR's only role now is indicating whether
  to select the default hierarchy or not during mount, it doesn't need
  to be set in the default hierarchy itself.  cgroup_init_early()
  updated accordingly.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 66 +++++++++++++++++++++++----------------------------------
 1 file changed, 27 insertions(+), 39 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2d7057e..1c56924 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1233,8 +1233,6 @@ static int cgroup_show_options(struct seq_file *seq,
 	for_each_subsys(ss, ssid)
 		if (root->subsys_mask & (1 << ssid))
 			seq_printf(seq, ",%s", ss->name);
-	if (root->flags & CGRP_ROOT_SANE_BEHAVIOR)
-		seq_puts(seq, ",sane_behavior");
 	if (root->flags & CGRP_ROOT_NOPREFIX)
 		seq_puts(seq, ",noprefix");
 	if (root->flags & CGRP_ROOT_XATTR)
@@ -1268,6 +1266,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 	bool all_ss = false, one_ss = false;
 	unsigned int mask = -1U;
 	struct cgroup_subsys *ss;
+	int nr_opts = 0;
 	int i;
 
 #ifdef CONFIG_CPUSETS
@@ -1277,6 +1276,8 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 	memset(opts, 0, sizeof(*opts));
 
 	while ((token = strsep(&o, ",")) != NULL) {
+		nr_opts++;
+
 		if (!*token)
 			return -EINVAL;
 		if (!strcmp(token, "none")) {
@@ -1361,37 +1362,33 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 			return -ENOENT;
 	}
 
-	/* Consistency checks */
-
 	if (opts->flags & CGRP_ROOT_SANE_BEHAVIOR) {
 		pr_warn("sane_behavior: this is still under development and its behaviors will change, proceed at your own risk\n");
-
-		if ((opts->flags & (CGRP_ROOT_NOPREFIX | CGRP_ROOT_XATTR)) ||
-		    opts->cpuset_clone_children || opts->release_agent ||
-		    opts->name) {
-			pr_err("sane_behavior: noprefix, xattr, clone_children, release_agent and name are not allowed\n");
+		if (nr_opts != 1) {
+			pr_err("sane_behavior: no other mount options allowed\n");
 			return -EINVAL;
 		}
-	} else {
-		/*
-		 * If the 'all' option was specified select all the
-		 * subsystems, otherwise if 'none', 'name=' and a subsystem
-		 * name options were not specified, let's default to 'all'
-		 */
-		if (all_ss || (!one_ss && !opts->none && !opts->name))
-			for_each_subsys(ss, i)
-				if (!ss->disabled)
-					opts->subsys_mask |= (1 << i);
-
-		/*
-		 * We either have to specify by name or by subsystems. (So
-		 * all empty hierarchies must have a name).
-		 */
-		if (!opts->subsys_mask && !opts->name)
-			return -EINVAL;
+		return 0;
 	}
 
 	/*
+	 * If the 'all' option was specified select all the subsystems,
+	 * otherwise if 'none', 'name=' and a subsystem name options were
+	 * not specified, let's default to 'all'
+	 */
+	if (all_ss || (!one_ss && !opts->none && !opts->name))
+		for_each_subsys(ss, i)
+			if (!ss->disabled)
+				opts->subsys_mask |= (1 << i);
+
+	/*
+	 * We either have to specify by name or by subsystems. (So all
+	 * empty hierarchies must have a name).
+	 */
+	if (!opts->subsys_mask && !opts->name)
+		return -EINVAL;
+
+	/*
 	 * Option noprefix was introduced just for backward compatibility
 	 * with the old cpuset, so we allow noprefix only if mounting just
 	 * the cpuset subsystem.
@@ -1399,7 +1396,6 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 	if ((opts->flags & CGRP_ROOT_NOPREFIX) && (opts->subsys_mask & mask))
 		return -EINVAL;
 
-
 	/* Can't specify "none" and some subsystems */
 	if (opts->subsys_mask && opts->none)
 		return -EINVAL;
@@ -1668,7 +1664,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		goto out_unlock;
 
 	/* look for a matching existing root */
-	if (!opts.subsys_mask && !opts.none && !opts.name) {
+	if (opts.flags & CGRP_ROOT_SANE_BEHAVIOR) {
 		cgrp_dfl_root_visible = true;
 		root = &cgrp_dfl_root;
 		cgroup_get(&root->cgrp);
@@ -1705,15 +1701,8 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 			goto out_unlock;
 		}
 
-		if (root->flags ^ opts.flags) {
-			if ((root->flags | opts.flags) & CGRP_ROOT_SANE_BEHAVIOR) {
-				pr_err("sane_behavior: new mount options should match the existing superblock\n");
-				ret = -EINVAL;
-				goto out_unlock;
-			} else {
-				pr_warn("new mount options do not match the existing superblock, will be ignored\n");
-			}
-		}
+		if (root->flags ^ opts.flags)
+			pr_warn("new mount options do not match the existing superblock, will be ignored\n");
 
 		/*
 		 * A root's lifetime is governed by its root cgroup.
@@ -4692,8 +4681,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
  */
 int __init cgroup_init_early(void)
 {
-	static struct cgroup_sb_opts __initdata opts =
-		{ .flags = CGRP_ROOT_SANE_BEHAVIOR };
+	static struct cgroup_sb_opts __initdata opts;
 	struct cgroup_subsys *ss;
 	int i;
 
-- 
1.9.3
