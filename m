From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH] mm: correctly charge compressed memory to its memcg
Date: Mon, 14 Nov 2022 14:48:28 -0500
Message-ID: <20221114194828.100822-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=omJyx+p3MZnXmMetOfD+Vb81mPQBWZRFtKehGT/esV0=;
        b=oPRUVWptCQQmFoRVOuC0Bg4LNaPVc12ejrt634brCi0WT/hC+s0sQDVTF10pFjtxTY
         2yzL0yNRUHUd1oX17N/BxcyF/qmvW3QhZXrPtNzOoYFRIF5RqMINMd8PvVISkRHPY2nu
         68op9yrb34dqOW+3Y/FmdRZGxNalulMhlZOhIWvbmehB0CgB/lnmP/jC1uO6+q+bozBP
         R2kGUT3x9G/BALjKomL4YolNC6TRbHvc0sb4+upz0vx0CduE+3gfG/V/K3kVbe2xce5l
         UexYq0kHvri6fpktU2NgA+FKrK4tHRhL88cyTTD/yRn0z7X5yBdQ4jbRxt0ut+v9nLt0
         MaLw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Liguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

From: Li Liguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>

Kswapd will reclaim memory when memory pressure is high, the
annonymous memory will be compressed and stored in the zpool
if zswap is enabled. The memcg_kmem_bypass() in
get_obj_cgroup_from_page() will bypass the kernel thread and
cause the compressed memory not charged to its memory cgroup.

Remove the memcg_kmem_bypass() and properly charge compressed
memory to its corresponding memory cgroup.

Link: https://lore.kernel.org/linux-mm/CALvZod4nnn8BHYqAM4xtcR0Ddo2-Wr8uKm9h_CHWUaXw7g_DCg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
Fixes: f4840ccfca25 ("zswap: memcg accounting")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 5.19+
Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Signed-off-by: Li Liguang <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

This fell through the cracks in summer as it didn't make it to the
right mailing lists. Resending.

I know it's close to 6.1-final, but the fix should be safe to put
in. It's straight-forward and obvious code-wise. We also have large
parts of production running on it without problems.

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2d8549ae1b30..a1a35c12635e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3026,7 +3026,7 @@ struct obj_cgroup *get_obj_cgroup_from_page(struct page *page)
 {
 	struct obj_cgroup *objcg;
 
-	if (!memcg_kmem_enabled() || memcg_kmem_bypass())
+	if (!memcg_kmem_enabled())
 		return NULL;
 
 	if (PageMemcgKmem(page)) {
-- 
2.38.1

