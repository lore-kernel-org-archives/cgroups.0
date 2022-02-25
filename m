From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] mm/memcg: move generation assignment and comparison together
Date: Fri, 25 Feb 2022 00:34:37 +0000
Message-ID: <20220225003437.12620-4-richard.weiyang@gmail.com>
References: <20220225003437.12620-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ilQGiGw+cHHnWYdpNd2TsqiqLrmn72vknxopCrZER/Q=;
        b=EXhP+YADKLWYCXD23XUiXLkpefnymxGvQ/D3MVz2Nk0z3XGGwRNe8I8uITmCtQwIFm
         4VBod9Tn78bwab2BZ6kHXnt2BwHZ8uUEHy7OzOAKBSZJ6fc1QETVMyQqbXCcNsyyNHmj
         97dZX0Epb88JPt0lOOpWx5jvJ4XY959jv7wVBuSoVSgpqg8I0ylEXoDrTok1pLCiMh5F
         tXdlQvD1HPzeefQzeA955geaPEZK76a0puWvb624G1Uk60kRkYJM9LXDRiEGmrQ7jnYq
         0HtNtCuP/AO4ipwxFWETbeAfyVM1DbdZnpvq2VBPheijzUBcevHVMOJzgQp4VUcYlosT
         Qe9w==
In-Reply-To: <20220225003437.12620-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 03399146168f..17da93c2f94e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -996,7 +996,14 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 		mz = root->nodeinfo[reclaim->pgdat->node_id];
 		iter = &mz->iter;
 
-		if (prev && reclaim->generation != iter->generation)
+		/*
+		 * On first invocation, assign iter->generation to
+		 * reclaim->generation.
+		 * On subsequent invocations, make sure no one else jump in.
+		 */
+		if (!prev)
+			reclaim->generation = iter->generation;
+		else if (reclaim->generation != iter->generation)
 			goto out_unlock;
 
 		while (1) {
@@ -1056,8 +1063,6 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 
 		if (!memcg)
 			iter->generation++;
-		else if (!prev)
-			reclaim->generation = iter->generation;
 	}
 
 out_unlock:
-- 
2.33.1

