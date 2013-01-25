From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: fix cgroup_path() vs rename() race
Date: Fri, 25 Jan 2013 15:09:59 +0800
Message-ID: <51022FC7.5020607@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

rename() will change dentry->d_name. The result of this race can
be worse than seeing partially rewritten name, but we might access
a stale pointer because rename() will re-allocate memory to hold
a longer name.

Use dentry_path_raw(), and this vfs API will take care of lockings.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5d4c92e..776ff75 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1792,26 +1792,10 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 		return 0;
 	}
 
-	start = buf + buflen - 1;
+	start = dentry_path_raw(dentry, buf, buflen);
+	if (IS_ERR(start))
+		return PTR_ERR(start);
 
-	*start = '\0';
-	for (;;) {
-		int len = dentry->d_name.len;
-
-		if ((start -= len) < buf)
-			return -ENAMETOOLONG;
-		memcpy(start, dentry->d_name.name, len);
-		cgrp = cgrp->parent;
-		if (!cgrp)
-			break;
-
-		dentry = cgrp->dentry;
-		if (!cgrp->parent)
-			continue;
-		if (--start < buf)
-			return -ENAMETOOLONG;
-		*start = '/';
-	}
 	memmove(buf, start, buf + buflen - start);
 	return 0;
 }
-- 
1.8.0.2
