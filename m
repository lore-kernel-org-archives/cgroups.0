From: Xiubo Li <lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] cgroup: fix written mistake in warning message
Date: Fri, 26 Feb 2016 10:42:08 +0800
Message-ID: <1456454528-10269-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Xiubo Li <lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>

There is written mistake about the print format name:id <--> %d:%s,
which the name is 'char *' type and id is 'int' type.

Signed-off-by: Xiubo Li <lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>
---
 kernel/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index cc40463..0f82d16 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5324,9 +5324,9 @@ int __init cgroup_init_early(void)
 
 	for_each_subsys(ss, i) {
 		WARN(!ss->css_alloc || !ss->css_free || ss->name || ss->id,
-		     "invalid cgroup_subsys %d:%s css_alloc=%p css_free=%p name:id=%d:%s\n",
+		     "invalid cgroup_subsys %d:%s css_alloc=%p css_free=%p name:id=%s:%d\n",
 		     i, cgroup_subsys_name[i], ss->css_alloc, ss->css_free,
-		     ss->id, ss->name);
+		     ss->name, ss->id);
 		WARN(strlen(cgroup_subsys_name[i]) > MAX_CGROUP_TYPE_NAMELEN,
 		     "cgroup_subsys_name %s too long\n", cgroup_subsys_name[i]);
 
-- 
1.8.3.1


