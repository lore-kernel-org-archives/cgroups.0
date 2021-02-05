From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 3/8] mm: memcontrol: privatize memcg_page_state query functions
Date: Fri,  5 Feb 2021 13:28:01 -0500
Message-ID: <20210205182806.17220-4-hannes@cmpxchg.org>
References: <20210205182806.17220-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cyRE6cACCpenz5S22wUDNGiEebDEXlsVuxUU66sedEg=;
        b=icEoG5fvED4gxDkodWySfEiJNdvHYTrXwyvRJR/NMlNgXGomJfFsLQ0X1Z7EzQefwS
         rfW+aNcKIIETp0qQ7BgaL+bHxz9JDwG8D0DQ7OfBTQMxsMX1PKR5GEDlskiULC37oHzk
         snxN/HmpVBXYD1Azekn8O3eQqv9R8NTKfz3zGLkjSAnFLNp0F5ChuS6QLvZs+NwzrOXa
         MTt6ZuHZmnFc/5tqEtOoAJV4yDeMqaNNC3TDVMuNTyayv8+BojubGAjU9FECgFSvq0Rv
         itLqqfmn0+w1v9I4LLhobur8A2NlT6lqld3Lz3oem56U7oDrlQVEEyGhxQWCkJGnDPAB
         gMwQ==
In-Reply-To: <20210205182806.17220-1-hannes@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

There are no users outside of the memory controller itself. The rest
of the kernel cares either about node or lruvec stats.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
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

