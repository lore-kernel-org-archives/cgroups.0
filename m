From: Xiubo Li <lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] cgroup: fix one typo in cgroup.c
Date: Tue, 18 Aug 2015 17:34:49 +0800
Message-ID: <1439890489-29124-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Xiubo Li <lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>

There is one typo in kernel/cgroup.c, and they may introduce some
noise when checking new patches.

Signed-off-by: Xiubo Li <lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f89d929..d0cd33e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1043,7 +1043,7 @@ static char *cgroup_file_name(struct cgroup *cgrp, const struct cftype *cft,
  * returns cft->mode if ->mode is not 0
  * returns S_IRUGO|S_IWUSR if it has both a read and a write handler
  * returns S_IRUGO if it has only a read handler
- * returns S_IWUSR if it has only a write hander
+ * returns S_IWUSR if it has only a write handler
  */
 static umode_t cgroup_file_mode(const struct cftype *cft)
 {
-- 
1.9.1


