From: roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH][V2] mm: memcontrol: fix the margin computation in mem_cgroup_margin
Date: Tue, 24 May 2016 13:37:46 +0800
Message-ID: <1464068266-27736-1-git-send-email-roy.qing.li@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org

From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The margin may be set to the difference value between memory limit and
memory count firstly. which maybe returned wrongly if memsw.count excess
memsw.limit, because try_charge forces charging __GFP_NOFAIL allocations,
which may result in memsw.limit excess. If we are below memory.limit
and there's nothing to reclaim to reduce memsw.usage, might end up
looping in try_charge forever.

Signed-off-by: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Acked-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
---
 mm/memcontrol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 00981d2..12aaadd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1090,6 +1090,8 @@ static unsigned long mem_cgroup_margin(struct mem_cgroup *memcg)
 		limit = READ_ONCE(memcg->memsw.limit);
 		if (count <= limit)
 			margin = min(margin, limit - count);
+		else
+			margin = 0;
 	}
 
 	return margin;
-- 
2.1.4
