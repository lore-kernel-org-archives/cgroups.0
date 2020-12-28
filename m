From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cpuset: Remove stale URLs in the MAINTAINERS entry
Date: Mon, 28 Dec 2020 11:17:54 +0800
Message-ID: <42668f2c-5ea1-da38-918e-ac4c86e3f03d@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wahl <steve.wahl-ZPxbGqLxI0U@public.gmane.org>

Those URLs are no longer accessable.

Reported-by: Steve Wahl <steve.wahl-ZPxbGqLxI0U@public.gmane.org>
Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ae9b1dd748c4..2fe8eb54639e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4477,8 +4477,6 @@ CONTROL GROUP - CPUSET
 M:	Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
 L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Maintained
-W:	http://www.bullopensource.org/cpuset/
-W:	http://oss.sgi.com/projects/cpusets/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 F:	Documentation/admin-guide/cgroup-v1/cpusets.rst
 F:	include/linux/cpuset.h
-- 
2.22.0

