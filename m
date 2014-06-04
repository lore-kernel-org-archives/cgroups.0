From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] cgroup: don't destroy the default root
Date: Wed, 4 Jun 2014 16:48:15 +0800
Message-ID: <538EDD4F.9010403@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

The default root is allocated and initialized at boot phase, so we
shouldn't destroy the default root when it's umounted, otherwise
it will lead to disaster.

Just try mount and then umount the default root, and the kernel will
crash immediately.

v2:
- No need to check for CSS_NO_REF in cgroup_get/put(). (Tejun)
- Better call cgroup_put() for the default root in kill_sb(). (Tejun)
- Add a comment.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a5f75ac..3f46165 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1780,8 +1780,11 @@ static void cgroup_kill_sb(struct super_block *sb)
 	 * If @root doesn't have any mounts or children, start killing it.
 	 * This prevents new mounts by disabling percpu_ref_tryget_live().
 	 * cgroup_mount() may wait for @root's release.
+	 *
+	 * And don't kill the default root.
 	 */
-	if (css_has_online_children(&root->cgrp.self))
+	if (css_has_online_children(&root->cgrp.self) ||
+	    root == &cgrp_dfl_root)
 		cgroup_put(&root->cgrp);
 	else
 		percpu_ref_kill(&root->cgrp.self.refcnt);
-- 
1.8.0.2
