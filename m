From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 3/7] mm: memcontrol: privatize memcg_page_state query functions
Date: Tue,  2 Feb 2021 13:47:42 -0500
Message-ID: <20210202184746.119084-4-hannes@cmpxchg.org>
References: <20210202184746.119084-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mpanv+/+JrDOLKkhynshAPXe4Ve6rW0I2YibAc13/NE=;
        b=O6ja58PYqYoZvn6p3Ba4+2qoDJfPZb1STqRFQNHtToIEjSyj1BXxH6ycynJzuxomPV
         9fl+x9JgJmfXvhv62NMyzN1ZD+/Buddm65nbmPOqK3iXg+jJ9NqA/wCMtFsY9aGRAVJi
         KTZk3QQsuUAQgka169LtM2V9I023EzNu1Kt4m8OB0Cw52000aJ3vTLT60nM1lA1DioZb
         ILdfgkvKbzGlqMLCcQWafrt71/KPfYqXBK0uxS0VzOmRtaPEq5CUAujti4DcSP8AABo1
         p/I6pOucyVi/HFirs7ugdp8cwARsiQm+CcFgrfIHN5K2WXtPHEzwkxqpZMIPDGP+ZRxj
         Yjdw==
In-Reply-To: <20210202184746.119084-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

There are no users outside of the memory controller itself. The rest
of the kernel cares either about node or lruvec stats.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 include/linux/memcontrol.h | 44 --------------------------------------
 mm/memcontrol.c            | 32 +++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 44 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c7f387a6233e..20ecdfae3289 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -867,39 +867,6 @@ struct mem_cgroup *lock_page_memcg(struct page *page);
 void __unlock_page_memcg(struct mem_cgroup *memcg);
 void unlock_page_memcg(struct page *page);
 
-/*
- * idx can be of type enum memcg_stat_item or node_stat_item.
- * Keep in sync with memcg_exact_page_state().
- */
-static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
-{
-	long x = atomic_long_read(&memcg->vmstats[idx]);
-#ifdef CONFIG_SMP
-	if (x < 0)
-		x = 0;
-#endif
-	return x;
-}
-
-/*
- * idx can be of type enum memcg_stat_item or node_stat_item.
- * Keep in sync with memcg_exact_page_state().
- */
-static inline unsigned long memcg_page_state_local(struct mem_cgroup *memcg,
-						   int idx)
-{
-	long x = 0;
-	int cpu;
-
-	for_each_possible_cpu(cpu)
-		x += per_cpu(memcg->vmstats_local->stat[idx], cpu);
-#ifdef CONFIG_SMP
-	if (x < 0)
-		x = 0;
-#endif
-	return x;
-}
-
 void __mod_memcg_state(struct mem_cgroup *memcg, int idx, int val);
 
 /* idx can be of type enum memcg_stat_item or node_stat_item */
@@ -1337,17 +1304,6 @@ static inline void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
 {
 }
 
-static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
-{
-	return 0;
-}
-
-static inline unsigned long memcg_page_state_local(struct mem_cgroup *memcg,
-						   int idx)
-{
-	return 0;
-}
-
 static inline void __mod_memcg_state(struct mem_cgroup *memcg,
 				     int idx,
 				     int nr)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7e05a4ebf80f..2f97cb4cef6d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -789,6 +789,38 @@ void __mod_memcg_state(struct mem_cgroup *memcg, int idx, int val)
 	__this_cpu_write(memcg->vmstats_percpu->stat[idx], x);
 }
 
+/*
+ * idx can be of type enum memcg_stat_item or node_stat_item.
+ * Keep in sync with memcg_exact_page_state().
+ */
+static unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
+{
+	long x = atomic_long_read(&memcg->vmstats[idx]);
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
+}
+
+/*
+ * idx can be of type enum memcg_stat_item or node_stat_item.
+ * Keep in sync with memcg_exact_page_state().
+ */
+static unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
+{
+	long x = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		x += per_cpu(memcg->vmstats_local->stat[idx], cpu);
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
+}
+
 static struct mem_cgroup_per_node *
 parent_nodeinfo(struct mem_cgroup_per_node *pn, int nid)
 {
-- 
2.30.0

