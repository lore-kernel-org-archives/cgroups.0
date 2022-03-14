From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [Patch v3] mm/memcg: mz already removed from rb_tree if not NULL
Date: Mon, 14 Mar 2022 23:30:30 +0000
Message-ID: <20220314233030.12334-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=qHm6ns4crCOcaBTwUjMbD9FaBOK99gvm+HsOLXP9V1E=;
        b=GycEiFI15k/dqMhfJjR5ur8JChRl8fpPp3zxafdxMdTo8IE65VlLRln1bxzKQR0yRV
         IRUl8aJyCZ3Yalh2hP95Elt0JT3mj52pUKnBGcN5oL6JSHPXLWbKhYqoWGuLCd2LRoap
         VLZAJtKHGOZiZs1Vu3S7xYbcWe9a7d5iUA2qSwP5fGI8cEm2ZizJqD6ht5727y8diLKr
         5HvdYqgHcxB96axrmWl2/eedK4zl0501ed8ynA2oOd+6CWeik/01RXhGSNc5ObvPt3Ly
         87qSVVzFtjzq1XS4o6flLzE5r77BwZjPIO1k/GEEiNsMmstlAsvfVe1NseGCgp7Sy4xL
         OnDA==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

When mz is not NULL, it means mz can either come from
mem_cgroup_largest_soft_limit_node or __mem_cgroup_largest_soft_limit_nod.
And both of them has removed this node by __mem_cgroup_remove_exceeded().

Not necessary to call __mem_cgroup_remove_exceeded() again.

[fmhocko-IBi9RG/b67k@public.gmane.org: refine changelog]
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index dc225ca512f6..e803ff02aae2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3460,7 +3460,6 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 		nr_reclaimed += reclaimed;
 		*total_scanned += nr_scanned;
 		spin_lock_irq(&mctz->lock);
-		__mem_cgroup_remove_exceeded(mz, mctz);
 
 		/*
 		 * If we failed to reclaim anything from this memory cgroup
-- 
2.33.1

