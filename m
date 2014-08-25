From: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] cgroup: Enable controllers for default hierarchy by default.
Date: Mon, 25 Aug 2014 19:27:32 +0800
Message-ID: <1408966052-2076-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

When we create a cgroup in unified hierarchy, we have to enable
controllers in cgrp_dfl_root.subtree_control manually. From
my practice, I did not find the benefit we disable controllers
in cgrp_dfl_root by default.

As I am a newbie to cgroup, please correct me if I am wrong.

Thanx.

Signed-off-by: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 kernel/cgroup.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7dc8788..70996ee 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1267,12 +1267,9 @@ static int rebind_subsystems(struct cgroup_root *dst_root, unsigned int ss_mask)
 		src_root->cgrp.subtree_control &= ~(1 << ssid);
 		cgroup_refresh_child_subsys_mask(&src_root->cgrp);
 
-		/* default hierarchy doesn't enable controllers by default */
 		dst_root->subsys_mask |= 1 << ssid;
-		if (dst_root != &cgrp_dfl_root) {
-			dst_root->cgrp.subtree_control |= 1 << ssid;
-			cgroup_refresh_child_subsys_mask(&dst_root->cgrp);
-		}
+		dst_root->cgrp.subtree_control |= 1 << ssid;
+		cgroup_refresh_child_subsys_mask(&dst_root->cgrp);
 
 		if (ss->bind)
 			ss->bind(css);
@@ -4990,6 +4987,8 @@ int __init cgroup_init(void)
 		}
 	}
 
+	cgrp_dfl_root.cgrp.subtree_control = cgrp_dfl_root.subsys_mask;
+
 	cgroup_kobj = kobject_create_and_add("cgroup", fs_kobj);
 	if (!cgroup_kobj)
 		return -ENOMEM;
-- 
1.8.4.2
