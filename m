From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] cgroup: don't destroy the default root
Date: Tue, 3 Jun 2014 12:04:38 +0800
Message-ID: <538D4956.5050205@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

The default root is allocated and initialized at boot, so we
shouldn't destroy the default root when it's umounted, otherwise
it will lead to disaster.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a5f75ac..f73fe48 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1027,12 +1027,14 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
 static void cgroup_get(struct cgroup *cgrp)
 {
 	WARN_ON_ONCE(cgroup_is_dead(cgrp));
-	css_get(&cgrp->self);
+	if (!(cgrp->self.flags & CSS_NO_REF))
+		css_get(&cgrp->self);
 }
 
 static void cgroup_put(struct cgroup *cgrp)
 {
-	css_put(&cgrp->self);
+	if (!(cgrp->self.flags & CSS_NO_REF))
+		css_put(&cgrp->self);
 }
 
 /**
@@ -1781,10 +1783,12 @@ static void cgroup_kill_sb(struct super_block *sb)
 	 * This prevents new mounts by disabling percpu_ref_tryget_live().
 	 * cgroup_mount() may wait for @root's release.
 	 */
-	if (css_has_online_children(&root->cgrp.self))
+	if (css_has_online_children(&root->cgrp.self)) {
 		cgroup_put(&root->cgrp);
-	else
-		percpu_ref_kill(&root->cgrp.self.refcnt);
+	} else {
+		if (root != &cgrp_dfl_root)
+			percpu_ref_kill(&root->cgrp.self.refcnt);
+	}
 
 	kernfs_kill_sb(sb);
 }
-- 
1.8.0.2
