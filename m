From: Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/6] cgroup: Move constant to the right site of comparison.
Date: Tue, 15 Dec 2015 13:20:45 +0100
Message-ID: <1450182045-27480-6-git-send-email-kuba.kunert@gmail.com>
References: <1450182045-27480-1-git-send-email-kuba.kunert@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=s1BI3eaX5D4/WjGD4v3ivIQHBderSWcbR9nH41+I+kE=;
        b=uv43rcEttqJBkNoWzZOsX/HuJS2JLtjntxJybqOerlhTov+MheqoYXqPKQcmeFE8me
         XayreUgmLV/ilLFR+6sUMSGVD2thmCe1mgTdpQlQc8O4J1OzpjiEQiljz1UDSjrCrxbv
         sJEu8dty6iGUa7KPvUDvYWVUojiuULVyycPS/6KkF6Y/IFSCSn3tBkp8tiqT/KfDx2AK
         qOPgWtOVgxxh7pFGw+Fk6qwU6cntSozPb5bipkmN6EgLF625M/WEKHZ96qIfJ/9XQGDD
         kqaLVnVGwrKcbS0HM65E/c3k3mIS0AvdwmvLEtZVzAURmFgl9iSW3ZaqMrwjQoq/RmGa
         DBSg==
In-Reply-To: <1450182045-27480-1-git-send-email-kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Fix checkpatch.pl warning.

Signed-off-by: Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a6ceb61..1ceb3fe 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5516,7 +5516,7 @@ static const struct file_operations proc_cgroupstats_operations = {
 
 static void **subsys_canfork_priv_p(void *ss_priv[CGROUP_CANFORK_COUNT], int i)
 {
-	if (CGROUP_CANFORK_START <= i && i < CGROUP_CANFORK_END)
+	if (i >= CGROUP_CANFORK_START && i < CGROUP_CANFORK_END)
 		return &ss_priv[i - CGROUP_CANFORK_START];
 	return NULL;
 }
-- 
2.6.2
