From: YANG LI <abaci-bugfix-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH] mm: fix: Uninitialized variable ret.
Date: Wed, 30 Dec 2020 14:59:11 +0800
Message-ID: <1609311551-97108-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, YANG LI <abaci-bugfix-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

The ret is being used but it isn't being initialized,
need to assign a value to it, like 0.

Signed-off-by: YANG LI <abaci-bugfix-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Reported-by: Abaci <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 605f671..15ba17d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3366,7 +3366,7 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 {
 	bool enlarge = false;
 	bool drained = false;
-	int ret;
+	int ret = 0;
 	bool limits_invariant;
 	struct page_counter *counter = memsw ? &memcg->memsw : &memcg->memory;
 
-- 
1.8.3.1

