From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] cgroup: set visible flag only after we've mounted the
 default root
Date: Tue, 3 Jun 2014 12:05:59 +0800
Message-ID: <538D49A7.2010403@huawei.com>
References: <538D4956.5050205@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <538D4956.5050205-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

This fixes the failure path, so we won't set the visible flag though
the mount is failed.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index dabc486..0b6b44e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1671,7 +1671,6 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 
 	/* look for a matching existing root */
 	if (!opts.subsys_mask && !opts.none && !opts.name) {
-		cgrp_dfl_root_visible = true;
 		root = &cgrp_dfl_root;
 		cgroup_get(&root->cgrp);
 		ret = 0;
@@ -1770,6 +1769,9 @@ out_free:
 	dentry = kernfs_mount(fs_type, flags, root->kf_root, &new_sb);
 	if (IS_ERR(dentry) || !new_sb)
 		cgroup_put(&root->cgrp);
+	else if (root == &cgrp_dfl_root)
+		cgrp_dfl_root_visible = true;
+
 	return dentry;
 }
 
-- 
1.8.0.2
