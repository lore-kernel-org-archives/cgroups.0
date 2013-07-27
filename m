From: Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cpuset: correct the disoder comment of two functions
Date: Sat, 27 Jul 2013 11:56:53 +0800
Message-ID: <51F34505.9010505@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

correct the disoder comment between cpuset_css_offline() and
cpuset_css_free() functions.

Signed-off-by: Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 2ddd9b9..703bfd5 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2020,6 +2020,12 @@ out_unlock:
 	return 0;
 }
 
+/*
+ * If the cpuset being removed has its flag 'sched_load_balance'
+ * enabled, then simulate turning sched_load_balance off, which
+ * will call rebuild_sched_domains_locked().
+ */
+
 static void cpuset_css_offline(struct cgroup *cgrp)
 {
 	struct cpuset *cs = cgroup_cs(cgrp);
@@ -2035,12 +2041,6 @@ static void cpuset_css_offline(struct cgroup *cgrp)
 	mutex_unlock(&cpuset_mutex);
 }
 
-/*
- * If the cpuset being removed has its flag 'sched_load_balance'
- * enabled, then simulate turning sched_load_balance off, which
- * will call rebuild_sched_domains_locked().
- */
-
 static void cpuset_css_free(struct cgroup *cgrp)
 {
 	struct cpuset *cs = cgroup_cs(cgrp);
-- 
1.8.2.2
