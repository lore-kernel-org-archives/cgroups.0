From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.4 1/3] cgroup: replace __DEVEL__sane_behavior
 with cgroup2 fs type
Date: Thu, 22 Oct 2015 10:22:12 +0900
Message-ID: <20151022012212.GA20931@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=pMLU1jHdLQkMu78a+7NwsU7CwDkeQtE5vaYIB3cJIlc=;
        b=V8GjcAVieuClQ6Hpk1wIVOJa7ux3P+1hboubRUaoe0B1tQqZnPIpIe2r2eO3gQkOSD
         /U2miWv8blsrfNF3WDrkUP5d9yuNPbnkogtQQt38VYpDHs8sKk9gGMa37PLTtCeZCgse
         lLSrU+l9he7y7+A9A2nSyAIQ38MxbwznKs70lAZx62FlldCPY3FHMrDimpqqVD3/LWss
         8xb0YiGrpfjohDKnvajG+XW5S5DCBFX9onBRh+GiJzXKO3tWG6AkArTKeovQzcfzqO2y
         xDlnYtqDuhFUCIkYNjxOXbkPXYOvmGn4WaGXoRGMZRh/h0n69sOyo2InyUuP9PwdfdaV
         8j0Q==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

From b1e2fadd2baa70225c14de9fee09063793091c31 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Thu, 22 Oct 2015 09:48:38 +0900

With major controllers - cpu, memory and io - shaping up for the
unified hierarchy, cgroup2 is about ready to be, gradually, released
into the wild.  Replace __DEVEL__sane_behavior flag which was used to
select the unified hierarchy with a separate filesystem type "cgroup2"
so that unified hierarchy can be mounted as follows.

  mount -t cgroup2 none $MOUNT_POINT

The cgroup2 fs has its own magic number - 0x63677270 ("cgrp").

v2: Assign a different magic number to cgroup2 fs.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
Hello,

This patchset removes devel mask from cgroup v2 and adds full
documentation.

While cpu side isn't settled yet, memory and io will be ready for the
4.4 merge window.  I'll keep trying to reach a consensus on cpu for
the 4.4 merge window but given that memory + io on cgroup v2 enables
cgroup writeback which is a major missing feature on v1, I think it
makes sense to push out v2 interface for memory and io for the 4.4
window especially as v1 and v2 can be used together.  Please note that
the discussion around cpu, no matter how it concludes, doesn't affect
anything for cgroup core, memory or io at all.

This patchset is on top of

  cgroup/for-4.4 e4b7037c8613da41fb3f7b029414fe25370f5
+ [1] [PATCH] blkcg: don't create "io.stat" on the root

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2

Thanks.

[1] http://lkml.kernel.org/g/20151022003103.GB10199-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org

 Documentation/cgroups/unified-hierarchy.txt |  6 ++--
 include/linux/cgroup-defs.h                 |  1 -
 include/uapi/linux/magic.h                  |  1 +
 kernel/cgroup.c                             | 47 ++++++++++++++---------------
 4 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/Documentation/cgroups/unified-hierarchy.txt b/Documentation/cgroups/unified-hierarchy.txt
index 0cd27a4..1161ba4 100644
--- a/Documentation/cgroups/unified-hierarchy.txt
+++ b/Documentation/cgroups/unified-hierarchy.txt
@@ -94,11 +94,9 @@ the process.
 
 2-1. Mounting
 
-Currently, unified hierarchy can be mounted with the following mount
-command.  Note that this is still under development and scheduled to
-change soon.
+Unified hierarchy can be mounted with the following mount command.
 
- mount -t cgroup -o __DEVEL__sane_behavior cgroup $MOUNT_POINT
+ mount -t cgroup2 none $MOUNT_POINT
 
 All controllers which support the unified hierarchy and are not bound
 to other hierarchies are automatically bound to unified hierarchy and
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 60d44b2..f43dee6 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -66,7 +66,6 @@ enum {
 
 /* cgroup_root->flags */
 enum {
-	CGRP_ROOT_SANE_BEHAVIOR	= (1 << 0), /* __DEVEL__sane_behavior specified */
 	CGRP_ROOT_NOPREFIX	= (1 << 1), /* mounted subsystems have no named prefix */
 	CGRP_ROOT_XATTR		= (1 << 2), /* supports extended attributes */
 };
diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 7b1425a..1dd008c 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -54,6 +54,7 @@
 
 #define SMB_SUPER_MAGIC		0x517B
 #define CGROUP_SUPER_MAGIC	0x27e0eb
+#define CGROUP2_SUPER_MAGIC	0x63677270
 
 
 #define STACK_END_MAGIC		0x57AC6E9D
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4f4fc53..2528105 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -205,6 +205,7 @@ static unsigned long have_free_callback __read_mostly;
 /* Ditto for the can_fork callback. */
 static unsigned long have_canfork_callback __read_mostly;
 
+static struct file_system_type cgroup2_fs_type;
 static struct cftype cgroup_dfl_base_files[];
 static struct cftype cgroup_legacy_base_files[];
 
@@ -1625,10 +1626,6 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 			all_ss = true;
 			continue;
 		}
-		if (!strcmp(token, "__DEVEL__sane_behavior")) {
-			opts->flags |= CGRP_ROOT_SANE_BEHAVIOR;
-			continue;
-		}
 		if (!strcmp(token, "noprefix")) {
 			opts->flags |= CGRP_ROOT_NOPREFIX;
 			continue;
@@ -1695,15 +1692,6 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 			return -ENOENT;
 	}
 
-	if (opts->flags & CGRP_ROOT_SANE_BEHAVIOR) {
-		pr_warn("sane_behavior: this is still under development and its behaviors will change, proceed at your own risk\n");
-		if (nr_opts != 1) {
-			pr_err("sane_behavior: no other mount options allowed\n");
-			return -EINVAL;
-		}
-		return 0;
-	}
-
 	/*
 	 * If the 'all' option was specified select all the subsystems,
 	 * otherwise if 'none', 'name=' and a subsystem name options were
@@ -1983,6 +1971,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 			 int flags, const char *unused_dev_name,
 			 void *data)
 {
+	bool is_v2 = fs_type == &cgroup2_fs_type;
 	struct super_block *pinned_sb = NULL;
 	struct cgroup_subsys *ss;
 	struct cgroup_root *root;
@@ -1999,6 +1988,17 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	if (!use_task_css_set_links)
 		cgroup_enable_task_cg_lists();
 
+	if (is_v2) {
+		if (data) {
+			pr_err("cgroup2: unknown option \"%s\"\n", (char *)data);
+			return ERR_PTR(-EINVAL);
+		}
+		cgrp_dfl_root_visible = true;
+		root = &cgrp_dfl_root;
+		cgroup_get(&root->cgrp);
+		goto out_mount;
+	}
+
 	mutex_lock(&cgroup_mutex);
 
 	/* First find the desired set of subsystems */
@@ -2006,15 +2006,6 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	if (ret)
 		goto out_unlock;
 
-	/* look for a matching existing root */
-	if (opts.flags & CGRP_ROOT_SANE_BEHAVIOR) {
-		cgrp_dfl_root_visible = true;
-		root = &cgrp_dfl_root;
-		cgroup_get(&root->cgrp);
-		ret = 0;
-		goto out_unlock;
-	}
-
 	/*
 	 * Destruction of cgroup root is asynchronous, so subsystems may
 	 * still be dying after the previous unmount.  Let's drain the
@@ -2125,9 +2116,10 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 
 	if (ret)
 		return ERR_PTR(ret);
-
+out_mount:
 	dentry = kernfs_mount(fs_type, flags, root->kf_root,
-				CGROUP_SUPER_MAGIC, &new_sb);
+			      is_v2 ? CGROUP2_SUPER_MAGIC : CGROUP_SUPER_MAGIC,
+			      &new_sb);
 	if (IS_ERR(dentry) || !new_sb)
 		cgroup_put(&root->cgrp);
 
@@ -2170,6 +2162,12 @@ static struct file_system_type cgroup_fs_type = {
 	.kill_sb = cgroup_kill_sb,
 };
 
+static struct file_system_type cgroup2_fs_type = {
+	.name = "cgroup2",
+	.mount = cgroup_mount,
+	.kill_sb = cgroup_kill_sb,
+};
+
 /**
  * task_cgroup_path - cgroup path of a task in the first cgroup hierarchy
  * @task: target task
@@ -5288,6 +5286,7 @@ int __init cgroup_init(void)
 
 	WARN_ON(sysfs_create_mount_point(fs_kobj, "cgroup"));
 	WARN_ON(register_filesystem(&cgroup_fs_type));
+	WARN_ON(register_filesystem(&cgroup2_fs_type));
 	WARN_ON(!proc_create("cgroups", 0, NULL, &proc_cgroupstats_operations));
 
 	return 0;
-- 
2.5.0
