From: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IPC: account for kmem usage on mqueue and msg
Date: Tue, 18 Oct 2016 11:54:35 -0400
Message-ID: <1476806075-1210-1-git-send-email-arozansk@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Stefan Schimanski <sttts-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

When kmem accounting switched from account by default to only account if
flagged by __GFP_ACCOUNT, IPC mqueue and messages was left out.

Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Stefan Schimanski <sttts-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reported-by: Stefan Schimanski <sttts-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 ipc/msgutil.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index a521999..bf74eaa 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -53,7 +53,7 @@ static struct msg_msg *alloc_msg(size_t len)
 	size_t alen;
 
 	alen = min(len, DATALEN_MSG);
-	msg = kmalloc(sizeof(*msg) + alen, GFP_KERNEL);
+	msg = kmalloc(sizeof(*msg) + alen, GFP_KERNEL_ACCOUNT);
 	if (msg == NULL)
 		return NULL;
 
@@ -65,7 +65,7 @@ static struct msg_msg *alloc_msg(size_t len)
 	while (len > 0) {
 		struct msg_msgseg *seg;
 		alen = min(len, DATALEN_SEG);
-		seg = kmalloc(sizeof(*seg) + alen, GFP_KERNEL);
+		seg = kmalloc(sizeof(*seg) + alen, GFP_KERNEL_ACCOUNT);
 		if (seg == NULL)
 			goto out_err;
 		*pseg = seg;
-- 
1.8.3.1
