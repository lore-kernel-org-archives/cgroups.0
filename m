From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: fix the retry path of cgroup_mount()
Date: Thu, 17 Apr 2014 13:53:08 +0800
Message-ID: <534F6C44.2060800@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

If we hit the retry path, we'll call parse_cgroupfs_options() again,
but the string we pass to it has been modified by the previous call
to this function.

This bug can be observed by:

  # mount -t cgroup -o name=foo,cpuset xxx /mnt && umount /mnt && \
    mount -t cgroup -o name=foo,cpuset xxx /mnt
  mount: wrong fs type, bad option, bad superblock on xxx,
         missing codepage or helper program, or other error
  ...

The second mount passed "name=foo,cpuset" to the parser, and then it
hit the retry path and call the parser again, but this time the string
passed to the parser is "name=foo".

To fix this, we avoid calling parse_cgroupfs_options() again in this
case.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 08c4439..9d6be07 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1580,7 +1580,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	 */
 	if (!use_task_css_set_links)
 		cgroup_enable_task_cg_lists();
-retry:
+
 	mutex_lock(&cgroup_tree_mutex);
 	mutex_lock(&cgroup_mutex);
 
@@ -1588,7 +1588,7 @@ retry:
 	ret = parse_cgroupfs_options(data, &opts);
 	if (ret)
 		goto out_unlock;
-
+retry:
 	/* look for a matching existing root */
 	if (!opts.subsys_mask && !opts.none && !opts.name) {
 		cgrp_dfl_root_visible = true;
@@ -1647,9 +1647,9 @@ retry:
 		if (!atomic_inc_not_zero(&root->cgrp.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
 			mutex_unlock(&cgroup_tree_mutex);
-			kfree(opts.release_agent);
-			kfree(opts.name);
 			msleep(10);
+			mutex_lock(&cgroup_tree_mutex);
+			mutex_lock(&cgroup_mutex);
 			goto retry;
 		}
 
-- 
1.8.0.2
