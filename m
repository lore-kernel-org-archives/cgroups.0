From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 1/3] cgroup: fix mount failure in a corner case
Date: Mon, 30 Jun 2014 11:49:58 +0800
Message-ID: <53B0DE66.5080100@huawei.com>
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
  mount: xxx already mounted or /cgroup busy
  mount: according to mtab, xxx is already mounted on /cgroup

It's because the cgroupfs_root of the first mount was under destruction
asynchronously.

Fix this by delaying and then retrying mount for this case.

v3:
- put the refcnt immediately after getting it. (Tejun)

v2:
- use percpu_ref_tryget_live() rather that introducing
  percpu_ref_alive(). (Tejun)
- adjust comment.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.15
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1c65f24..d3662ac 100644
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
+	int i;
 	bool new_sb;
 
 	/*
@@ -1677,6 +1679,25 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		goto out_unlock;
 	}
 
+	/*
+	 * Destruction of cgroup root is asynchronous, so we may fail to
+	 * mount a cgroupfs if it immediately follows a umount. Let's wait
+	 * a little bit and retry.
+	 */
+	for_each_subsys(ss, i) {
+		if (!(opts.subsys_mask & (1 << i)) ||
+		    ss->root == &cgrp_dfl_root)
+			continue;
+
+		if (!percpu_ref_tryget_live(&ss->root->cgrp.self.refcnt)) {
+			mutex_unlock(&cgroup_mutex);
+			msleep(10);
+			ret = restart_syscall();
+			goto out_free;
+		}
+		cgroup_put(&ss->root->cgrp);
+	}
+
 	for_each_root(root) {
 		bool name_match = false;
 
-- 
1.8.0.2
