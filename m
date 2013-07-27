From: Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cpuset: get rid of the useless forward declaration of
 cpuset
Date: Sat, 27 Jul 2013 11:56:49 +0800
Message-ID: <51F34501.1090608@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

get rid of the useless forward declaration of the struct cpuset cause the 
below define it.

Signed-off-by: Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index e565778..2ddd9b9 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -70,7 +70,6 @@ int number_of_cpusets __read_mostly;
 
 /* Forward declare cgroup structures */
 struct cgroup_subsys cpuset_subsys;
-struct cpuset;
 
 /* See "Frequency meter" comments, below. */
 
-- 
1.8.2.2
