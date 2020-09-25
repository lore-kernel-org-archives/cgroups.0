From: Wei Yang <richard.weiyang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH] cgroup: remove redundant kernfs_activate in cgroup_setup_root()
Date: Fri, 25 Sep 2020 17:11:10 +0800
Message-ID: <20200925091110.17189-1-richard.weiyang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wei Yang <richard.weiyang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

This step is already done in rebind_subsystems().

Not necessary to do it again.

Signed-off-by: Wei Yang <richard.weiyang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index dd247747ec14..809b13588124 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2006,7 +2006,6 @@ int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 	BUG_ON(!list_empty(&root_cgrp->self.children));
 	BUG_ON(atomic_read(&root->nr_cgrps) != 1);
 
-	kernfs_activate(root_cgrp->kn);
 	ret = 0;
 	goto out;
 
-- 
2.20.1 (Apple Git-117)

