From: Xiubo Li <lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] cgroup: add opts release function to simplify the code
Date: Fri, 11 Mar 2016 15:07:15 +0800
Message-ID: <1457680035-26772-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Xiubo Li <lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>

The old code is a bit confusing for the readers by thinking why
these two members of opts should be released?

The resources allocated by whom has the possiblity to release it,
But this will make the opts parse function more complex. So add
opts release function to simplify the code, and at the same time
to make the code more easy to read and be understood.

Signed-off-by: Xiubo Li <lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>
---
 kernel/cgroup.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 155c884..5db5dad 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1761,6 +1761,12 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 	return 0;
 }
 
+static inline void release_cgroupfs_options(struct cgroup_sb_opts *opts)
+{
+	kfree(opts->release_agent);
+	kfree(opts->name);
+}
+
 static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 {
 	int ret = 0;
@@ -1814,9 +1820,8 @@ static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 		spin_unlock(&release_agent_path_lock);
 	}
  out_unlock:
-	kfree(opts.release_agent);
-	kfree(opts.name);
 	mutex_unlock(&cgroup_mutex);
+	release_cgroupfs_options(&opts);
 	return ret;
 }
 
@@ -2070,7 +2075,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 			mutex_unlock(&cgroup_mutex);
 			msleep(10);
 			ret = restart_syscall();
-			goto out_free;
+			goto out_release;
 		}
 		cgroup_put(&ss->root->cgrp);
 	}
@@ -2127,7 +2132,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 				deactivate_super(pinned_sb);
 			msleep(10);
 			ret = restart_syscall();
-			goto out_free;
+			goto out_release;
 		}
 
 		ret = 0;
@@ -2168,9 +2173,8 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 
 out_unlock:
 	mutex_unlock(&cgroup_mutex);
-out_free:
-	kfree(opts.release_agent);
-	kfree(opts.name);
+out_release:
+	release_cgroupfs_options(&opts);
 
 	if (ret) {
 		put_cgroup_ns(ns);
-- 
1.8.3.1


