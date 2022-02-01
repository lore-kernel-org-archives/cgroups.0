From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] mm/memcg: mem_cgroup_per_node is already set to 0 on allocation
Date: Tue,  1 Feb 2022 00:46:42 +0000
Message-ID: <20220201004643.8391-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=uPVLcxrrpf12Ei4lWc6lSHRXgw8cc0G/gavfe4Q9af4=;
        b=hdpLvN0QxInM8+zBsj9rlh83NVjYyFJoIFuN/De4NAA9EcVJhT7Wqhkcj75YZEeEV2
         th2W52TZaFlmrPuVbf6bmepEh9nDGgI4CSDd+GaLoRrX1GocorJrKLmA9JiVmpB6t8s5
         66kbKsZny0SG2cCxsmhC78eAk8a3CPKbs558vyZgfnz46XL3sxK28SQN2uG3f6XLjnzl
         LNghAm/XyZAZInH39ADFZhe9ctC11i3g7jcQor7TRZxqtGO16EuWNH8wT2AC3cDP3IuA
         0C0BTkQ33c8fKzbuibkJDmgEw1NtwrOcnpFtlrZOFnPEaDzl3jCxB+jJoKQlGI40mEK6
         Gi2g==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

kzalloc_node() would set data to 0, so it's not necessary to set it
again.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Reviewed-by: Mike Rapoport <rppt-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ea8460658550..ce7060907df2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5070,8 +5070,6 @@ static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 	}
 
 	lruvec_init(&pn->lruvec);
-	pn->usage_in_excess = 0;
-	pn->on_tree = false;
 	pn->memcg = memcg;
 
 	memcg->nodeinfo[node] = pn;
-- 
2.33.1

