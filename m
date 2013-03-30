From: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroups: Documentation/kernel-parameters.txt.
Date: Sat, 30 Mar 2013 10:26:14 +0300
Message-ID: <1364628374-4554-1-git-send-email-wkevils@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer;
        bh=1hCyiwkKh38FGzNCrhhuPm6soVH+AH4zsg2fXPPKl2c=;
        b=DnB4wTz2A22Xxvzky6CVsu/kjaqNzcmB5Nxs24H+6FUHAsfPc3qrYZzgfhrHXILX7M
         09WtVjE9IISpvm4H++W8QDzqiqNWLnLS1UM0200np4zxMJnUqkIj5+iCOriYjUbccG/X
         RGcRI927I/pf8NYkYnXEqmmXFElFswByvq+8OUjkUbwUkVztF9p3devzJb53HkgIMala
         PryUsCZ8uyqOg8S2eUn0FIxkrfOldlKlTfTcj3FfDMZk8tT/ZIS7TX7JP+GFjEpB4w4Y
         DnZKdSWRqByvcyOcwqaP2Sc0uWCEMTm0OgKI39M0id4gqvNdZRpU7BebKKxt50xe60oV
         uVIQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This patch removes the line "{Currently supported controllers - "memory"}"
from Documentation/kernel-parameters.txt, as all controllers are supported.

Signed-off-by: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/kernel-parameters.txt | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..a671c6f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -451,7 +451,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	cgroup_disable= [KNL] Disable a particular controller
 			Format: {name of the controller(s) to disable}
-				{Currently supported controllers - "memory"}
 
 	checkreqprot	[SELINUX] Set initial checkreqprot flag value.
 			Format: { "0" | "1" }
-- 
1.8.1.4
