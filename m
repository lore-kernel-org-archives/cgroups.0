From: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: fix stale mem_cgroup_force_empty() comment
Date: Fri,  6 May 2016 14:23:30 -0700
Message-ID: <1462569810-54496-1-git-send-email-gthelen@google.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=5F48NB8zT8s6PjWcZTwNuNVpEcIXgRUVfllkkS5ZBIA=;
        b=oWYHf4bMktM4EOByGAc+a7xebhaV42oqqbhennHz1TM15MUHNVgc6VOEzssGRdR72p
         dUxnKItUQJroecfsKbCeMkmknB+2VYt9H7378UgJwUloskMTmty+wnkyuIy0uHMxAwCU
         jp5BhhB+qvbZrfjlUYQ3OCSYctNgPCf61xRZhy81/g8PDLagsYpsnS05bbfC9euhiufV
         3u9H0+Xo6YNWd40XuPLeJ6TJPnig0yomzZQQK1QJYTaF/42Iu6iVKDnYj+/b0UQHFKOD
         n13oPxN8e2BXmMmBZMjzUGALvZn4u7apMkmeOKV94Z6eUrb7emXZhFSLgPaRGZjGIL+R
         LKUA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

commit f61c42a7d911 ("memcg: remove tasks/children test from
mem_cgroup_force_empty()") removed memory reparenting from the function.

Fix the function's comment.

Signed-off-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fe787f5c41bd..19fd76168a05 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2636,8 +2636,7 @@ static inline bool memcg_has_children(struct mem_cgroup *memcg)
 }
 
 /*
- * Reclaims as many pages from the given memcg as possible and moves
- * the rest to the parent.
+ * Reclaims as many pages from the given memcg as possible.
  *
  * Caller is responsible for holding css reference for memcg.
  */
-- 
2.8.0.rc3.226.g39d4020
