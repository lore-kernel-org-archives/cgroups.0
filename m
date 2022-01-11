From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] mm/memcg: use NUMA_NO_NODE to indicate allocation from unspecified node
Date: Tue, 11 Jan 2022 01:02:59 +0000
Message-ID: <20220111010302.8864-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=gtH/Kion5HJLdt7FtzIkiM9uRZTByJ26w7a2rxZ6ieo=;
        b=qXleYNAEtWkveqdPsAnLgtk92hCEN09SWm8MqmPYwTeB5Z+ao26iVyzzy9RpgiBgTZ
         8jgSCWBbSu/+EcMPXaWB69plAmT+RzYF70HFPJGPze/pifY0liTk7l4bhV3LS3emDlSf
         TSlMHLsWyNFeVo9LGCl1fLz4RWow2N3xp3zHu1zCBsuANJQxavuEgZqY+iMsLs6946Mj
         z3bSwhaN4pSAxDE7azvHUiqAZL5/DLG+vb2+FOcmqVotTQlJTJVfyhPUTa8Rz/DUen++
         moKga1Zco3+BsQDcsATFw0hHoOaOsIZu6UTfn9mPV2b+gpLasbfx2DeA/YUKvIwXGmNS
         0BeA==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Instead of use "-1", let's use NUMA_NO_NODE for consistency.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2ed5f2a0879d..11715f7323c0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5054,7 +5054,7 @@ static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 	 *       function.
 	 */
 	if (!node_state(node, N_NORMAL_MEMORY))
-		tmp = -1;
+		tmp = NUMA_NO_NODE;
 	pn = kzalloc_node(sizeof(*pn), GFP_KERNEL, tmp);
 	if (!pn)
 		return 1;
-- 
2.33.1

