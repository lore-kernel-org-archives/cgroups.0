From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: cleanup racy sum avoidance code
Date: Tue, 27 Jul 2021 18:22:43 -0700
Message-ID: <20210728012243.3369123-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=KmGPLe7yWyGg+5xBmJJBJmFQBI3nGe2qI3u2htSZRc8=;
        b=nuhUlmTMHBefTVNrgYI+UtWHFhAeUZ55sBhNa0QX9fumm4mflb1V6DbSoHCRW6t06r
         onMeMgc+EcsYHFi0X4PcAOFTt1Ca4GWOMdzhbbiOrGVTrb0+gtM9N1DnIZxhXv8HlftC
         DJSqiUVC7neopxxFodop5YR1Gled3AwZiXE7gKa9y/fs3sAr5ZECb/Puda3R9v+/bkI+
         nb00mP95Ua0jnx3xuMqkU9/WGjDryEYGUuk5L5v/oC3oUWmi5Da3evvFfquWnPH15h+y
         PKiZUtUG5Qb4p9eZ7PCfY2pcvyOh2brxBgAENIFwi2xJrsLT1ESfcW03z9V4K8U/cP8u
         YJPw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

We used to have per-cpu memcg and lruvec stats and the readers have to
traverse and sum the stats from each cpu. This summing was racy and may
expose transient negative values. So, an explicit check was added to
avoid such scenarios. Now these stats are moved to rstat infrastructure
and are no more per-cpu, so we can remove the fixup for transient
negative values.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7028d8e4a3d7..5f2a39a43d47 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -991,30 +991,19 @@ static inline void mod_memcg_state(struct mem_cgroup *memcg,
 
 static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
 {
-	long x = READ_ONCE(memcg->vmstats.state[idx]);
-#ifdef CONFIG_SMP
-	if (x < 0)
-		x = 0;
-#endif
-	return x;
+	return READ_ONCE(memcg->vmstats.state[idx]);
 }
 
 static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
 					      enum node_stat_item idx)
 {
 	struct mem_cgroup_per_node *pn;
-	long x;
 
 	if (mem_cgroup_disabled())
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	x = READ_ONCE(pn->lruvec_stats.state[idx]);
-#ifdef CONFIG_SMP
-	if (x < 0)
-		x = 0;
-#endif
-	return x;
+	return READ_ONCE(pn->lruvec_stats.state[idx]);
 }
 
 static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
-- 
2.32.0.432.gabb21c7263-goog

