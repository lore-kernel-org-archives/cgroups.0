From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] Revert "cgroup: fix cgroup_path() vs rename() race"
Date: Sun, 17 Feb 2013 12:03:16 +0800
Message-ID: <51205684.5040407@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

This reverts commit 299772fab304ab3a36b22b5d28ed81f9408972e7

Sasha reported this:

[  313.262599] ======================================================
[  313.271340] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
[  313.277542] 3.8.0-rc6-next-20130208-sasha-00028-ge4e162d #278 Tainted: G       W
[  313.277542] ------------------------------------------------------
[  313.277542] kworker/u:3/4490 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[  313.277542]  (rename_lock){+.+...}, at: [<ffffffff812a11f9>] dentry_path_raw+0x29/0x70
[  313.277542]
[  313.277542] and this task is already holding:
[  313.277542]  (&(&q->__queue_lock)->rlock){-.-...}, at: [<ffffffff819e78f3>] put_io_context_active+0x63/0x100
[  313.277542] which would create a new lock dependency:
[  313.277542]  (&(&q->__queue_lock)->rlock){-.-...} -> (rename_lock){+.+...}
[  313.277542]
[  313.277542] but this new dependency connects a HARDIRQ-irq-safe lock:
[  313.277542]  (&(&q->__queue_lock)->rlock){-.-...}

dentry_path_raw() grabs rename_lock and dentry->d_lock without disabling
irqs, which means cgroup_path() can't be called if the caller has already
held a spinlock with irq disabled.

Reported-by: Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 776ff75..5d4c92e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1792,10 +1792,26 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 		return 0;
 	}
 
-	start = dentry_path_raw(dentry, buf, buflen);
-	if (IS_ERR(start))
-		return PTR_ERR(start);
+	start = buf + buflen - 1;
 
+	*start = '\0';
+	for (;;) {
+		int len = dentry->d_name.len;
+
+		if ((start -= len) < buf)
+			return -ENAMETOOLONG;
+		memcpy(start, dentry->d_name.name, len);
+		cgrp = cgrp->parent;
+		if (!cgrp)
+			break;
+
+		dentry = cgrp->dentry;
+		if (!cgrp->parent)
+			continue;
+		if (--start < buf)
+			return -ENAMETOOLONG;
+		*start = '/';
+	}
 	memmove(buf, start, buf + buflen - start);
 	return 0;
 }
-- 
1.8.0.2
