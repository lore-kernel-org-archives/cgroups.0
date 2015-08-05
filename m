From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.3 3/3] cgroup: replace __DEVEL__sane_behavior
 with cgroup2 fs type
Date: Wed, 5 Aug 2015 13:21:08 -0400
Message-ID: <20150805172108.GQ17598@mtj.duckdns.org>
References: <20150805172012.GO17598@mtj.duckdns.org>
 <20150805172043.GP17598@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=HTuvele38XgYBfbR2OmC+RyjzOK3zHQW4cdpzPaOcu8=;
        b=lQ/3LIacSIqdM5yQ24SqUl4eE4Va7CFpZI0B+0JcsT/ujNmCsig80OmsSw6AvP6qvk
         DTJOVL8JLpUAiVTHTQ9drRpG+ybwYx7hjLHTGwzPZ4G98NzAq4P+dgRxu6D0Y/+6JgM0
         PhPNHHbPRMXQdF4Vb1Zuefs51BTdC6qzLLhARaqBI6OEsSXIwa/T9X62pae3SUY3o6ZE
         PgJOxorJi2v5Iu54RMGMcbD2DW5/O6vmJ7f8V+Rd5ByHWuAQyQ4ZH/9wFZKk524IfeJR
         hGqCEon9RJiRQaDkg7JIIjN+fhO5uxhYTcv8MXBPxyvL024EKDFAfaX4Dx5jHSxQoaru
         9myQ==
Content-Disposition: inline
In-Reply-To: <20150805172043.GP17598-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

With major controllers - cpu, memory and io - shaping up for the
unified hierarchy, cgroup2 is about ready to be, gradually, released
into the wild.  Replace __DEVEL__sane_behavior flag which was used to
select the unified hierarchy with a separate filesystem type "cgroup2"
so that unified hierarchy can be mounted as follows.

  mount -t cgroup2 none $MOUNT_POINT

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 Documentation/cgroups/unified-hierarchy.txt |    6 +--
 include/linux/cgroup-defs.h                 |    1 
 kernel/cgroup.c                             |   43 +++++++++++++---------------
 3 files changed, 22 insertions(+), 28 deletions(-)

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
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -66,7 +66,6 @@ enum {
 
 /* cgroup_root->flags */
 enum {
-	CGRP_ROOT_SANE_BEHAVIOR	= (1 << 0), /* __DEVEL__sane_behavior specified */
 	CGRP_ROOT_NOPREFIX	= (1 << 1), /* mounted subsystems have no named prefix */
 	CGRP_ROOT_XATTR		= (1 << 2), /* supports extended attributes */
 };
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -183,6 +183,7 @@ static unsigned long have_exit_callback
 /* Ditto for the can_fork callback. */
 static unsigned long have_canfork_callback __read_mostly;
 
+static struct file_system_type cgroup2_fs_type;
 static struct cftype cgroup_dfl_base_files[];
 static struct cftype cgroup_legacy_base_files[];
 
@@ -1391,10 +1392,6 @@ static int parse_cgroupfs_options(char *
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
@@ -1461,15 +1458,6 @@ static int parse_cgroupfs_options(char *
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
@@ -1765,6 +1753,17 @@ static struct dentry *cgroup_mount(struc
 	if (!use_task_css_set_links)
 		cgroup_enable_task_cg_lists();
 
+	if (fs_type == &cgroup2_fs_type) {
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
@@ -1772,15 +1771,6 @@ static struct dentry *cgroup_mount(struc
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
@@ -1891,7 +1881,7 @@ out_free:
 
 	if (ret)
 		return ERR_PTR(ret);
-
+out_mount:
 	dentry = kernfs_mount(fs_type, flags, root->kf_root,
 				CGROUP_SUPER_MAGIC, &new_sb);
 	if (IS_ERR(dentry) || !new_sb)
@@ -1936,6 +1926,12 @@ static struct file_system_type cgroup_fs
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
@@ -5056,6 +5052,7 @@ int __init cgroup_init(void)
 
 	WARN_ON(sysfs_create_mount_point(fs_kobj, "cgroup"));
 	WARN_ON(register_filesystem(&cgroup_fs_type));
+	WARN_ON(register_filesystem(&cgroup2_fs_type));
 	WARN_ON(!proc_create("cgroups", 0, NULL, &proc_cgroupstats_operations));
 
 	return 0;
