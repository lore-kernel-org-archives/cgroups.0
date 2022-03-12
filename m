From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [Patch v2 3/3] mm/memcg: add next_mz back to soft limit tree if not reclaimed yet
Date: Sat, 12 Mar 2022 07:16:23 +0000
Message-ID: <20220312071623.19050-3-richard.weiyang@gmail.com>
References: <20220312071623.19050-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6eF3CkGTMOIQmVHUtkEwTATvUD+GDDg0zGlDrlu3cRs=;
        b=LJ8fzFe6HkpMjK3dAG/kkCB3VwjmJ5YokqYQBqn6mRELFnmoDR4ND2YGflHHQEY3cw
         cHN2GmvSaxTqzUyKiaZ6G8mHq8RfzREKBl/YpsSReGoKIicDRHevo1QbIm1z64ki9ydZ
         pRhNKC3UotSGcN2JnVtD+VJ7gz7fnGndetV6M4+7G3pGlRMVUfOdoBLqqjJonINME7Lz
         X1wG7JfWG67Nm3dD3p8y7Vmt+mZiOjMmF9XwDF/9Z2bTX6XZJ88FXOTMfvYNrcmzXyuH
         UKAMGTiXg31ZO88PFlisMM/+EvoJVtJ60F3IWXVXj7eWcyg3PQBPDPcLj8gastjMjOZT
         hXMA==
In-Reply-To: <20220312071623.19050-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

When memory reclaim failed for a maximum number of attempts and we bail
out of the reclaim loop, we forgot to put the target mem_cgroup chosen
for next reclaim back to the soft limit tree. This prevented pages in
the mem_cgroup from being reclaimed in the future even though the
mem_cgroup exceeded its soft limit.

Let's say there are two mem_cgroup and both of them exceed the soft
limit, while the first one is more active then the second. Since we add
a mem_cgroup to soft limit tree every 1024 event, the second one just
get a rare chance to be put on soft limit tree even it exceeds the
limit.

As time goes on, the first mem_cgroup was kept close to its soft limit
due to reclaim activities, while the memory usage of the second
mem_cgroup keeps growing over the soft limit for a long time due to its
relatively rare occurrence.

This patch adds next_mz back to prevent this sceanrio.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 344a7e891bc5..e803ff02aae2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3493,8 +3493,13 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 			loop > MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS))
 			break;
 	} while (!nr_reclaimed);
-	if (next_mz)
+	if (next_mz) {
+		spin_lock_irq(&mctz->lock);
+		excess = soft_limit_excess(next_mz->memcg);
+		__mem_cgroup_insert_exceeded(next_mz, mctz, excess);
+		spin_unlock_irq(&mctz->lock);
 		css_put(&next_mz->memcg->css);
+	}
 	return nr_reclaimed;
 }
 
-- 
2.33.1

