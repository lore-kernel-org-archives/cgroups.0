From: Lukas Bulwahn <lukas.bulwahn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] mm: memcg: remove obsolete memcg_has_children()
Date: Mon, 16 Nov 2020 06:50:43 +0100
Message-ID: <20201116055043.20886-1-lukas.bulwahn@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bMCt60rqT+zbnmmu8mIiXqNzcowO0BqJlZFilJ3Doeo=;
        b=l2N6UPXztssB0BIvdQTVtoH2uBhHn7UeL7GZOqiJHymxU/o40kBJboG/xwwJ0dZ+cw
         n1KO2j8bOsgqGfSu/Gks3g2zXimC/L45Zq1Vtw6IBhErbes7kYBG5Z4+iwogQJxm56yX
         8eJtxaKvCz6uHpp/6j8Ow/A7n9mAFktsHac1tWj8Ihzt3aglcMo9yjTlUknFm5aaH2nW
         P3zfAIHUMuCP7T4vWeYCZL/dh4UbYvnzwzQrRAg97uqoMX4cfjg4Y+Rvz/Mx5rPpLvon
         KKdJ0tN6fWaK8sA144XP8eVvWUUAA4FY8HKz+VyprSzyZ8VqEozquOocB26xYFvnFQj+
         OvVA==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tom Rix <trix-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Nathan Chancellor <natechancellor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nick Desaulniers <ndesaulniers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, clang-built-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lukas Bulwahn <lukas.bulwahn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Commit 2ef1bf118c40 ("mm: memcg: deprecate the non-hierarchical mode")
removed the only use of memcg_has_children() in
mem_cgroup_hierarchy_write() as part of the feature deprecation.

Hence, since then, make CC=clang W=1 warns:

  mm/memcontrol.c:3421:20:
    warning: unused function 'memcg_has_children' [-Wunused-function]

Simply remove this obsolete unused function.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
applies cleanly on next-20201113, not on current master

Roman, please ack.

Andrew, please pick this minor non-urgent patch into your -next tree.

 mm/memcontrol.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f95ddb3e9898..d49d7c507284 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3415,19 +3415,6 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 	return nr_reclaimed;
 }
 
-/*
- * Test whether @memcg has children, dead or alive.
- */
-static inline bool memcg_has_children(struct mem_cgroup *memcg)
-{
-	bool ret;
-
-	rcu_read_lock();
-	ret = css_next_child(NULL, &memcg->css);
-	rcu_read_unlock();
-	return ret;
-}
-
 /*
  * Reclaims as many pages from the given memcg as possible.
  *
-- 
2.17.1

