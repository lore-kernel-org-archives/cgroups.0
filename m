From: chenxiang <chenxiang66-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Subject: [PATCH] cgroup: Fix a comment in function cgroup_wq_init()
Date: Fri, 18 Sep 2020 16:54:52 +0800
Message-ID: <1600419292-191248-1-git-send-email-chenxiang66@hisilicon.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Xiang Chen <chenxiang66-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>

From: Xiang Chen <chenxiang66-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>

Use function workqueue_init() instead of init_workqueues() which
is not used in kernel.

Signed-off-by: Xiang Chen <chenxiang66-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index dd24774..c34b03d 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5784,7 +5784,7 @@ static int __init cgroup_wq_init(void)
 	 * Use 1 for @max_active.
 	 *
 	 * We would prefer to do this in cgroup_init() above, but that
-	 * is called before init_workqueues(): so leave this until after.
+	 * is called before workqueue_init(): so leave this until after.
 	 */
 	cgroup_destroy_wq = alloc_workqueue("cgroup_destroy", 0, 1);
 	BUG_ON(!cgroup_destroy_wq);
-- 
2.8.1

