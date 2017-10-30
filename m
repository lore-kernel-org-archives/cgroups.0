From: Chao Yu <yuchao0-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] MAINTAINERS: relocate cpuset.c
Date: Mon, 30 Oct 2017 17:02:32 +0800
Message-ID: <20171030090232.34986-1-yuchao0@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Chao Yu <yuchao0-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Commit 201af4c0fab0 ("cgroup: move cgroup files under kernel/cgroup/")
have renamed kernel/cpuset.c to kernel/cgroup/cpuset.c, but forgot to
update entry of cpuset module in MAINTAINERS, fix it.

Signed-off-by: Chao Yu <yuchao0-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0630482e701b..e68fca4fa93c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3604,7 +3604,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 S:	Maintained
 F:	Documentation/cgroup-v1/cpusets.txt
 F:	include/linux/cpuset.h
-F:	kernel/cpuset.c
+F:	kernel/cgroup/cpuset.c
 
 CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)
 M:	Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
-- 
2.13.1.388.g69e6b9b4f4a9
