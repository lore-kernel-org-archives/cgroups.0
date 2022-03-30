From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [Patch v2 3/3] mm/memcg: move generation assignment and comparison together
Date: Wed, 30 Mar 2022 23:47:19 +0000
Message-ID: <20220330234719.18340-4-richard.weiyang@gmail.com>
References: <20220330234719.18340-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VUJcnVdgNFYpQDTJEWf7H0xzus0K/Xa4FeMP7a1KnEQ=;
        b=ncvvGkdIFWyKuP25ghEWF3nSN6sW8+Q7qWkT1iDxucHp0v6lYGY/ZDllouL2Y/nAUz
         EfKl+Yna/ir+zTvabWIpqqPHbltci3rU6r0a/FfdvzTVkf/skKhGJIz18w5ccDRwnvyU
         PkCYTjGdCQqDJx0pTYz+iL5ZB/pY+zf4Ib1Q5D9f2xj+T1Sb9GR92JTnrsXPdu6ybLJ6
         QOKZxMy/CHs6nqkCPMHlp3Gr0FNX3f+TDadXhTC+jZM0QMdlg192xUdoD+jezjIDkBoz
         zEQ86AmCcX1LTF0ikiCsHDhKBWGD/mK/GxpycZ7iTVU31o0EMsfFH4hiQomO1nQr+xKL
         CUIw==
In-Reply-To: <20220330234719.18340-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

For each round-trip, we assign generation on first invocation and
compare it on subsequent invocations.

Let's move them together to make it more self-explaining. Also this
reduce a check on prev.

[hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org: better comment to explain reclaim model]

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

---
v2: a better comment from Johannes
---
 mm/memcontrol.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5d433b79ba47..2cd8bfdec379 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1013,7 +1013,13 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 		mz = root->nodeinfo[reclaim->pgdat->node_id];
 		iter = &mz->iter;
 
-		if (prev && reclaim->generation != iter->generation)
+		/*
+		 * On start, join the current reclaim iteration cycle.
+		 * Exit when a concurrent walker completes it.
+		 */
+		if (!prev)
+			reclaim->generation = iter->generation;
+		else if (reclaim->generation != iter->generation)
 			goto out_unlock;
 
 		while (1) {
@@ -1075,8 +1081,6 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 
 		if (!memcg)
 			iter->generation++;
-		else if (!prev)
-			reclaim->generation = iter->generation;
 	}
 
 out_unlock:
-- 
2.33.1

