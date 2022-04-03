From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] mm/memcg: non-hierarchical mode is deprecated
Date: Sun,  3 Apr 2022 02:08:33 +0000
Message-ID: <20220403020833.26164-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=C7M3sxnNh9ju9tb2x0yLZLDmlvAi9UQAlTWRcM/JN90=;
        b=iw1q4VQH1xO+kN+VCt9RffVSCNxDWS53ujTgERnK+15z2eisOdiIC7FaCeeWhxumRi
         Tbx2nAEMNJj7OdLQQYC6hr2oMKRnVDUtVyvRAzYV6gnzpsVSS+xfiTcE/0acVLcxwqy9
         SONTxEpBrvtds2Lxz+Zh8zmGvWmkClCwiOS4QGpAB6ssxp5AdbC09+EeB9Y8kVAL4U25
         Fc3NLRSS4OI6B5++JH22GH3nnm7ZOlx/2n84xGBg8NNey7eG078CslnwvBzweEPzohKf
         LuVCEtvp3zA8lMQKUah3SB68McfJNek0VUc+lxRkfxjKHdntX4e0bjdDXZizwM46EYe9
         2TrQ==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

After commit bef8620cd8e0 ("mm: memcg: deprecate the non-hierarchical
mode"), we won't have a NULL parent except root_mem_cgroup. And this
case is handled when (memcg == root).

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2cd8bfdec379..3ceb9b8592b1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6587,9 +6587,6 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 		return;
 
 	parent = parent_mem_cgroup(memcg);
-	/* No parent means a non-hierarchical mode on v1 memcg */
-	if (!parent)
-		return;
 
 	if (parent == root) {
 		memcg->memory.emin = READ_ONCE(memcg->memory.min);
-- 
2.33.1

