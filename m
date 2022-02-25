From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] mm/memcg: set pos to prev unconditionally
Date: Fri, 25 Feb 2022 00:34:36 +0000
Message-ID: <20220225003437.12620-3-richard.weiyang@gmail.com>
References: <20220225003437.12620-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uV4wBUWA2UECsFZTXgl5VjPgFRRqp+MEQd9SNZm1H5k=;
        b=a6Vnlb+DXvatZ1kODfxsl4neHMsRZDeRD7PR3nUDh+j1AyWLtpam8eSKeAKpB7+2tx
         K283KMzgr1d7YmT6BpKMBWNBjK/AbqGXSgoAYFd1XPSC5QzRDch5RhpeI+EvMXFCv/ht
         H67m6Oj03Z7rnpxO2scQmQ5AC/DV8lEKCT4T1Qr1/HenZEtC4hkFTZKMfZDWhpgZ70LM
         T0+ZcMd3F2C/ZFIaJlh5+4tpwfGoFPG12Yh/MWAh4c9HxdVrCLDhyI5qKcBfSlXXPijP
         PzKY2w+OfX5pLMziBPbIevhlkHMHG6QNplCeS1qXYwpH4LR8aZwiKXwG8iGtIdB+JC6a
         0JzQ==
In-Reply-To: <20220225003437.12620-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Current code set pos to prev based on condition (prev && !reclaim),
while we can do this unconditionally.

Since:

  * If !reclaim, pos is the same as prev no matter it is NULL or not.
  * If reclaim, pos would be set properly from iter->position.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9464fe2aa329..03399146168f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -980,7 +980,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 	struct mem_cgroup_reclaim_iter *iter;
 	struct cgroup_subsys_state *css = NULL;
 	struct mem_cgroup *memcg = NULL;
-	struct mem_cgroup *pos = NULL;
+	struct mem_cgroup *pos = prev;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -988,9 +988,6 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 	if (!root)
 		root = root_mem_cgroup;
 
-	if (prev && !reclaim)
-		pos = prev;
-
 	rcu_read_lock();
 
 	if (reclaim) {
-- 
2.33.1

