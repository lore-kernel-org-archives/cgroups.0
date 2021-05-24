From: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH] mm: memcontrol: fix kernel-doc
Date: Mon, 24 May 2021 18:24:22 +0800
Message-ID: <1621851862-34443-1-git-send-email-yang.lee@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Fix function name in mm/memcontrol.c kernel-doc comment
to remove a warning.

mm/memcontrol.c:6546: warning: expecting prototype for
mem_cgroup_protected(). Prototype was for
mem_cgroup_calculate_protection() instead.

Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Signed-off-by: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 64ada9e..030c1dc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6456,7 +6456,7 @@ static unsigned long effective_protection(unsigned long usage,
 }
 
 /**
- * mem_cgroup_protected - check if memory consumption is in the normal range
+ * mem_cgroup_calculate_protection - check if memory consumption is in the normal range
  * @root: the top ancestor of the sub-tree being checked
  * @memcg: the memory cgroup to check
  *
-- 
1.8.3.1

