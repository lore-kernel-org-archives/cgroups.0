From: Xiubo Li <lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v2] cgroup: fix written mistake in warning message
Date: Fri, 26 Feb 2016 13:07:38 +0800
Message-ID: <1456463258-6617-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Xiubo Li <lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>

There is written mistake about the print format name:id <--> %d:%s,
which the name is 'char *' type and id is 'int' type. Change "name:id"
to "id:name" instead to be consistent with "cgroup_subsys %d:%s".

Signed-off-by: Xiubo Li <lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>
---

Changed in v2:

- change "name:id" to "id:name" instead to be consistent with "cgroup_subsys %d:%s".


 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index cc40463..a81b4be 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5324,7 +5324,7 @@ int __init cgroup_init_early(void)
 
 	for_each_subsys(ss, i) {
 		WARN(!ss->css_alloc || !ss->css_free || ss->name || ss->id,
-		     "invalid cgroup_subsys %d:%s css_alloc=%p css_free=%p name:id=%d:%s\n",
+		     "invalid cgroup_subsys %d:%s css_alloc=%p css_free=%p id:name=%d:%s\n",
 		     i, cgroup_subsys_name[i], ss->css_alloc, ss->css_free,
 		     ss->id, ss->name);
 		WARN(strlen(cgroup_subsys_name[i]) > MAX_CGROUP_TYPE_NAMELEN,
-- 
1.8.3.1


