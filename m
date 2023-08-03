From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: fix obsolete function name in cgroup_destroy_locked()
Date: Thu, 3 Aug 2023 19:57:02 +0800
Message-ID: <20230803115702.741128-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Since commit e76ecaeef65c ("cgroup: use cgroup_kn_lock_live() in other
cgroup kernfs methods"), cgroup_kn_lock_live() is used in cgroup kernfs
methods. Update corresponding comment.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index d620d7ec47e8..f230446598ac 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5871,7 +5871,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	/*
 	 * Mark @cgrp and the associated csets dead.  The former prevents
 	 * further task migration and child creation by disabling
-	 * cgroup_lock_live_group().  The latter makes the csets ignored by
+	 * cgroup_kn_lock_live().  The latter makes the csets ignored by
 	 * the migration path.
 	 */
 	cgrp->self.flags &= ~CSS_ONLINE;
-- 
2.33.0

