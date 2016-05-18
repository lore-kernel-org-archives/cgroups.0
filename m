From: roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] mm: memcontrol: fix the return in mem_cgroup_margin
Date: Wed, 18 May 2016 15:24:15 +0800
Message-ID: <1463556255-31892-1-git-send-email-roy.qing.li@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org

From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

when memory+swap is over limit, return 0

Signed-off-by: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fe787f5..e9211c2 100644
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
