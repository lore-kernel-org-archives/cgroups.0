From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH next-akpm] mm/memcg: remove incorrect comments
Date: Fri, 20 Nov 2020 17:35:30 +0800
Message-ID: <1605864930-49405-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Swapcache readahead pages are charged before get used, so it unlikely be
migrated before charged. remove the incorrect comments.

Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> 
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> 
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> 
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> 
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org 
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org 
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org 
---
 mm/memcontrol.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 45465c03a8d7..08c267305725 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6941,7 +6941,6 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
 	if (page_memcg(newpage))
 		return;
 
-	/* Swapcache readahead pages can get replaced before being charged */
 	memcg = page_memcg(oldpage);
 	VM_WARN_ON_ONCE_PAGE(!memcg, oldpage);
 	if (!memcg)
-- 
2.29.GIT

