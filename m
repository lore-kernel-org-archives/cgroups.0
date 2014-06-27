From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/3] cgroup: fix mount failure in a corner case
Date: Fri, 27 Jun 2014 15:10:08 +0800
Message-ID: <53AD18D0.3090100@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

  # cat test.sh
  #! /bin/bash

  mount -t cgroup -o cpu xxx /cgroup
  umount /cgroup

  mount -t cgroup -o cpu,cpuacct xxx /cgroup
  umount /cgroup
  # ./test.sh
  mount: xxx already mounted or /mnt busy
  mount: according to mtab, xxx is already mounted on /mnt

It's because the cgroupfs_root of the first mount was under destruction
asynchronously.

Fix this by delaying and then retrying mount for this case.

v2:
- use percpu_ref_tryget_live() rather that introducing
  percpu_ref_alive(). (Tejun)
- adjust comment.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1c65f24..ae2b382 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1648,10 +1648,12 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 			 int flags, const char *unused_dev_name,
 			 void *data)
 {
+	struct cgroup_subsys *ss;
 	struct cgroup_root *root;
 	struct cgroup_sb_opts opts;
 	struct dentry *dentry;
 	int ret;
+	int i, j = -1;
 	bool new_sb;
 
 	/*
@@ -1677,6 +1679,23 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		goto out_unlock;
 	}
 
+	/*
+	 * Destruction of cgroup root is asynchronous, so we may fail to
+	 * mount a cgroupfs if it immediately follows a umount. Let's wait
+	 * a little bit and retry.
+	 */
+	for_each_subsys(ss, i) {
+		if (!(opts.subsys_mask & (1 << i)))
+			continue;
+		if (!percpu_ref_tryget_live(&ss->root->cgrp.self.refcnt)) {
+			mutex_unlock(&cgroup_mutex);
+			msleep(10);
+			ret = restart_syscall
