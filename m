From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] perf/cgroup: Remove perf_put_cgroup()
Date: Fri, 19 Sep 2014 16:53:14 +0800
Message-ID: <541BEEFA.1020800@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Commit 5a17f543ed68 ("cgroup: improve css_from_dir() into css_tryget_from_dir()")
removed perf_tryget_cgroup(), so let's also remove perf_put_cgroup().

Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/events/core.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f9c1ed0..2af1cc5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -392,14 +392,9 @@ perf_cgroup_match(struct perf_event *event)
 				    event->cgrp->css.cgroup);
 }
 
-static inline void perf_put_cgroup(struct perf_event *event)
-{
-	css_put(&event->cgrp->css);
-}
-
 static inline void perf_detach_cgroup(struct perf_event *event)
 {
-	perf_put_cgroup(event);
+	css_put(&event->cgrp->css);
 	event->cgrp = NULL;
 }
 
-- 
1.8.0.2
