From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: remove redundant check in cgroup_ino()
Date: Fri, 19 Sep 2014 16:29:31 +0800
Message-ID: <541BE96B.1090605@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>

After we implemented default unified hierarchy, cgrp->kn can never
be NULL.

Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h | 7 ++-----
 mm/memory-failure.c    | 2 +-
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 77a1d37..818a81f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -532,13 +532,10 @@ static inline bool cgroup_has_tasks(struct cgroup *cgrp)
 	return !list_empty(&cgrp->cset_links);
 }
 
-/* returns ino associated with a cgroup, 0 indicates unmounted root */
+/* returns ino associated with a cgroup */
 static inline ino_t cgroup_ino(struct cgroup *cgrp)
 {
-	if (cgrp->kn)
-		return cgrp->kn->ino;
-	else
-		return 0;
+	return cgrp->kn->ino;
 }
 
 /* cft/css accessors for cftype->write() operation */
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 44c6bd2..8639f6b 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -148,7 +148,7 @@ static int hwpoison_filter_task(struct page *p)
 	ino = cgroup_ino(css->cgroup);
 	css_put(css);
 
-	if (!ino || ino != hwpoison_filter_memcg)
+	if (ino != hwpoison_filter_memcg)
 		return -EINVAL;
 
 	return 0;
-- 
1.8.0.2
