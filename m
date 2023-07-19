From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: fix obsolete comment above cgroup_create()
Date: Wed, 19 Jul 2023 17:06:40 +0800
Message-ID: <20230719090640.2568600-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Since commit 743210386c03 ("cgroup: use cgrp->kn->id as the cgroup ID"),
cgrp is associated with its kernfs_node. Update corresponding comment.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 40ee81f982ff..44bf9e3ffb8a 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5544,8 +5544,7 @@ static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
 
 /*
  * The returned cgroup is fully initialized including its control mask, but
- * it isn't associated with its kernfs_node and doesn't have the control
- * mask applied.
+ * it doesn't have the control mask applied.
  */
 static struct cgroup *cgroup_create(struct cgroup *parent, const char *name,
 				    umode_t mode)
-- 
2.33.0

