From: Bandan Das <bsd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: Use kvfree in pidlist_free()
Date: Mon, 02 Mar 2015 17:51:10 -0500
Message-ID: <jpgioej3tep.fsf@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


The wrapper already calls the appropriate free
function, use it instead of spinning our own.

Signed-off-by: Bandan Das <bsd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 29a7b2c..c19d66d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3806,10 +3806,7 @@ static void *pidlist_allocate(int count)
 
 static void pidlist_free(void *p)
 {
-	if (is_vmalloc_addr(p))
-		vfree(p);
-	else
-		kfree(p);
+	kvfree(p);
 }
 
 /*
-- 
2.1.0
