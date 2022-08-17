From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Revert "memcg: cleanup racy sum avoidance code"
Date: Wed, 17 Aug 2022 17:21:39 +0000
Message-ID: <20220817172139.3141101-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=dSzSreqSgeWTr7IT3H9o9mfUnYWShCnFurU/IX78wck=;
        b=dTD3RFmREPolvh67EVgPCaiqfPyrzjLIQk3j7COquerAm7hUK1GISZwu7LhnAsS8rx
         9pHHdZosMxN0Q3SK3B5q37DPVuCJNtYYzBL6nVkLxz21xZhJitWg0GXoCxrcnTgN8Jwc
         Cr5luIxno/kD6ed4ki0W2eh7XGjQc8VFXxqH3HJvH6A2OuDxGL/lXQ3owGk29+tpha+2
         ZvsP4zzvlWLcA3uxDoxEtMWgbPdjTjufGW0fS4h0583eJL0YVXB6neXzbAJP86uUXlIq
         9xzV/+A/HP2bIMAMWJIsATEziLl0Gk+d/FJLCiZColNnBniWGGmvtH2DhvD94kXfi14T
         PTyw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This reverts commit 96e51ccf1af33e82f429a0d6baebba29c6448d0f.

Recently we started running the kernel with rstat infrastructure on
production traffic and begin to see negative memcg stats values.
Particularly the 'sock' stat is the one which we observed having
negative value.

$ grep "sock " /mnt/memory/job/memory.stat
sock 253952
total_sock 18446744073708724224

Re-run after couple of seconds

$ grep "sock " /mnt/memory/job/memory.stat
sock 253952
total_sock 53248

For now we are only seeing this issue on large machines (256 CPUs) and
only with 'sock' stat. I think the networking stack increase the stat on
one cpu and decrease it on another cpu much more often. So, this
negative sock is due to rstat flusher flushing the stats on the CPU that
has seen the decrement of sock but missed the CPU that has increments. A
typical race condition.

For easy stable backport, revert is the most simple solution. For long
term solution, I am thinking of two directions. First is just reduce the
race window by optimizing the rstat flusher. Second is if the reader
sees a negative stat value, force flush and restart the stat collection.
Basically retry but limited.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 5.15
---
 include/linux/memcontrol.h | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 4d31ce55b1c0..6257867fbf95 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -987,19 +987,30 @@ static inline void mod_memcg_page_state(struct page *page,
 
 static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
 {
-	return READ_ONCE(memcg->vmstats.state[idx]);
+	long x = READ_ONCE(memcg->vmstats.state[idx]);
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
 }
 
 static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
 					      enum node_stat_item idx)
 {
 	struct mem_cgroup_per_node *pn;
+	long x;
 
 	if (mem_cgroup_disabled())
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	return READ_ONCE(pn->lruvec_stats.state[idx]);
+	x = READ_ONCE(pn->lruvec_stats.state[idx]);
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
 }
 
 static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
-- 
2.37.1.595.g718a3a8f04-goog

