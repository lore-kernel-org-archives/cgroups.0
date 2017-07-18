From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: Show control files in cgroup2 root after mount
Date: Tue, 18 Jul 2017 15:32:16 -0400
Message-ID: <1500406336-29512-1-git-send-email-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 19762C04D2A4
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

It was found that when a cgroup2 filesystem was mounted, control
files other than the base cgroup.* ones were not shown in the root
directory.  They were shown only after some controllers were activated
in the root's cgroup.subtree_control file.

This was caused by a lack of the kernfs_activate() call which was fixed
by this patch.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 89a23c6..fb1893b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2024,8 +2024,10 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 
 		dentry = cgroup_do_mount(&cgroup2_fs_type, flags, &cgrp_dfl_root,
 					 CGROUP2_SUPER_MAGIC, ns);
-		if (!IS_ERR(dentry))
+		if (!IS_ERR(dentry)) {
 			apply_cgroup_root_flags(root_flags);
+			kernfs_activate(cgrp_dfl_root.cgrp.kn);
+		}
 	} else {
 		dentry = cgroup1_mount(&cgroup_fs_type, flags, data,
 				       CGROUP_SUPER_MAGIC, ns);
-- 
1.8.3.1
