From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: remove unused macro for_each_e_css()
Date: Sat, 27 May 2023 17:33:53 +0800
Message-ID: <20230527093353.153078-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

for_each_e_css() is unused now. Remove it.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 625d7483951c..413b4f1f1b70 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -689,21 +689,6 @@ EXPORT_SYMBOL_GPL(of_css);
 				lockdep_is_held(&cgroup_mutex)))) { }	\
 		else
 
-/**
- * for_each_e_css - iterate all effective css's of a cgroup
- * @css: the iteration cursor
- * @ssid: the index of the subsystem, CGROUP_SUBSYS_COUNT after reaching the end
- * @cgrp: the target cgroup to iterate css's of
- *
- * Should be called under cgroup_[tree_]mutex.
- */
-#define for_each_e_css(css, ssid, cgrp)					    \
-	for ((ssid) = 0; (ssid) < CGROUP_SUBSYS_COUNT; (ssid)++)	    \
-		if (!((css) = cgroup_e_css_by_mask(cgrp,		    \
-						   cgroup_subsys[(ssid)]))) \
-			;						    \
-		else
-
 /**
  * do_each_subsys_mask - filter for_each_subsys with a bitmask
  * @ss: the iteration cursor
-- 
2.27.0

