From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: use cached local variable parent in for loop
Date: Sat, 15 Jul 2023 11:08:29 +0800
Message-ID: <20230715030829.2343109-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Use local variable parent to initialize iter tcgrp in for loop so the size
of cgroup.o can be reduced by 64 bytes. No functional change intended.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 6225d5829459..033f38fb5cef 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5894,7 +5894,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 		parent->nr_threaded_children--;
 
 	spin_lock_irq(&css_set_lock);
-	for (tcgrp = cgroup_parent(cgrp); tcgrp; tcgrp = cgroup_parent(tcgrp)) {
+	for (tcgrp = parent; tcgrp; tcgrp = cgroup_parent(tcgrp)) {
 		tcgrp->nr_descendants--;
 		tcgrp->nr_dying_descendants++;
 		/*
-- 
2.33.0

