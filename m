From: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: fix attach task fail when subtree_control configured
Date: Fri, 8 Apr 2022 18:23:14 +0800
Message-ID: <1649413394-17501-1-git-send-email-zhaoyang.huang@unisoc.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org

From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>

It is found that task attach to a vacant cgroup will fail when its
subtree_control has been configured. Fix it by judging if there is no chrildren
existed.

Signed-off-by: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 919194d..f00583b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2561,6 +2561,9 @@ static int cgroup_migrate_execute(struct cgroup_mgctx *mgctx)
  */
 int cgroup_migrate_vet_dst(struct cgroup *dst_cgrp)
 {
+	struct cgroup_subsys_state *css = &dst_cgrp->self;
+	struct list_head *children = &css->children;
+
 	/* v1 doesn't have any restriction */
 	if (!cgroup_on_dfl(dst_cgrp))
 		return 0;
@@ -2581,7 +2584,7 @@ int cgroup_migrate_vet_dst(struct cgroup *dst_cgrp)
 		return 0;
 
 	/* apply no-internal-process constraint */
-	if (dst_cgrp->subtree_control)
+	if (dst_cgrp->subtree_control && !list_empty(children))
 		return -EBUSY;
 
 	return 0;
-- 
1.9.1

