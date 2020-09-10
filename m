From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH] taskstats: fix CGROUPSTATS_CMD_GET for cgroup v2
Date: Thu, 10 Sep 2020 13:52:07 +0800
Message-ID: <20200910055207.87702-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JhBvYsUMnScXaBA5KnUjCNRfXR+H5/aWPwXH05u5u10=;
        b=QMBMTVn1/0teJQBbE4s2cRDJzLUfflgfw51IBIi/7uOamKRUZGLzy1hFu2Z7u+XM9N
         zpdJMVvkwBzsAzd/rURxvizqhGeBQFWtEJstUun0YroG4nts7YlW2RTRItwID69AuHCd
         1MIEw4ZbMQ0aKCLcb1dvFmcnFIheN3J09dUD7R0T9la323uHYDabT+YQFkuPoWeEL3BE
         x9kt9q65YijGcWUT4/iMpmTL5DEIEg3yxZoWlElskWXF8jLtr2fFdR6FywlDtnE/Cnzx
         D6ACBpHxqji1e6VHFWzSldcean1NpnDbgvXEgAh8w6n5GazQjeZWACyR6T5bH57HkDY4
         AmYQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, luodaowen.backend-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

We found cgroupstats_build would return -EINVAL when using netlink
CGROUPSTATS_CMD_GET interface to get stats on cgroup v2. Fix it by
supporting cgroup v2 kernfs directory in cgroupstats_build, and export
cgroup2_fs_type like we did for cgroup_fs_type.

Reported-by: Daowen Luo <luodaowen.backend-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Tested-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 kernel/cgroup/cgroup-internal.h | 1 +
 kernel/cgroup/cgroup-v1.c       | 5 +++--
 kernel/cgroup/cgroup.c          | 3 +--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index bfbeabc17a9d..9ca05fb513c2 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -151,6 +151,7 @@ extern spinlock_t css_set_lock;
 extern struct cgroup_subsys *cgroup_subsys[];
 extern struct list_head cgroup_roots;
 extern struct file_system_type cgroup_fs_type;
+extern struct file_system_type cgroup2_fs_type;
 
 /* iterate across the hierarchies */
 #define for_each_root(root)						\
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 191c329e482a..6d9e9b553276 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -686,13 +686,14 @@ int proc_cgroupstats_show(struct seq_file *m, void *v)
 int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 {
 	struct kernfs_node *kn = kernfs_node_from_dentry(dentry);
+	struct file_system_type *s_type = dentry->d_sb->s_type;
 	struct cgroup *cgrp;
 	struct css_task_iter it;
 	struct task_struct *tsk;
 
 	/* it should be kernfs_node belonging to cgroupfs and is a directory */
-	if (dentry->d_sb->s_type != &cgroup_fs_type || !kn ||
-	    kernfs_type(kn) != KERNFS_DIR)
+	if ((s_type != &cgroup_fs_type && s_type != &cgroup2_fs_type) ||
+	    !kn || kernfs_type(kn) != KERNFS_DIR)
 		return -EINVAL;
 
 	mutex_lock(&cgroup_mutex);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index dd247747ec14..0e23ae3b1e56 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -206,7 +206,6 @@ struct cgroup_namespace init_cgroup_ns = {
 	.root_cset	= &init_css_set,
 };
 
-static struct file_system_type cgroup2_fs_type;
 static struct cftype cgroup_base_files[];
 
 static int cgroup_apply_control(struct cgroup *cgrp);
@@ -2162,7 +2161,7 @@ struct file_system_type cgroup_fs_type = {
 	.fs_flags		= FS_USERNS_MOUNT,
 };
 
-static struct file_system_type cgroup2_fs_type = {
+struct file_system_type cgroup2_fs_type = {
 	.name			= "cgroup2",
 	.init_fs_context	= cgroup_init_fs_context,
 	.parameters		= cgroup2_fs_parameters,
-- 
2.11.0

