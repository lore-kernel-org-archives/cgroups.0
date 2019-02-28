From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 6/6] mm: memcontrol: quarantine the mem_cgroup_[node_]nr_lru_pages() API
Date: Thu, 28 Feb 2019 11:30:20 -0500
Message-ID: <20190228163020.24100-7-hannes@cmpxchg.org>
References: <20190228163020.24100-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z2sRN7pljcgc3IEs1HOIZy7cq4U6Vg2axPUdXHMU2lE=;
        b=DEAtdOPWiEo0uOoF/kNQdPF0USk1MRsY3/VKt8/mJQFicjBli6ttNVH8RkvHkOg7wY
         ByBYfX+mPzOz9P8Dn43tEMTeRXyvR12moI751Uv096CLMEY6EjSZA+WEDf1fNGD8fukR
         hI3+VbOhIJVPNA3hgzNYNYZIqwq8/bYnBQQFyYaygDjHRN0w9ne2jfjL/rrEuW2UgLZx
         ePVPYNWL+E839Gw74yrULf1nuqJO6jmJUWceXhvNVkSQYCxL+N+qwhDGHo4wc3vE1NnZ
         uvoFdHHWn7bP1Lkywedfry5vLXo9gAO6JiqCgHzo8jp3u2/gXV2IhksYFvEo+pcToDvJ
         XK6g==
In-Reply-To: <20190228163020.24100-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Only memcg_numa_stat_show() uses those wrappers and the lru bitmasks,
group them together.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/mmzone.h |  5 ----
 mm/memcontrol.c        | 67 +++++++++++++++++++++++-------------------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 2fd4247262e9..4f92d32c26a7 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -305,11 +305,6 @@ struct lruvec {
 #endif
 };
 
-/* Mask used at gathering information at once (see memcontrol.c) */
-#define LRU_ALL_FILE (BIT(LRU_INACTIVE_FILE) | BIT(LRU_ACTIVE_FILE))
-#define LRU_ALL_ANON (BIT(LRU_INACTIVE_ANON) | BIT(LRU_ACTIVE_ANON))
-#define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
-
 /* Isolate unmapped file */
 #define ISOLATE_UNMAPPED	((__force isolate_mode_t)0x2)
 /* Isolate for asynchronous migration */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 76f599fbbbe8..84243831b738 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -725,37 +725,6 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 	__this_cpu_add(memcg->vmstats_percpu->nr_page_events, nr_pages);
 }
 
-static unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
-					   int nid, unsigned int lru_mask)
-{
-	struct lruvec *lruvec = mem_cgroup_lruvec(NODE_DATA(nid), memcg);
-	unsigned long nr = 0;
-	enum lru_list lru;
-
-	VM_BUG_ON((unsigned)nid >= nr_node_ids);
-
-	for_each_lru(lru) {
-		if (!(BIT(lru) & lru_mask))
-			continue;
-		nr += lruvec_page_state(lruvec, NR_LRU_BASE + lru);
-	}
-	return nr;
-}
-
-static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
-			unsigned int lru_mask)
-{
-	unsigned long nr = 0;
-	enum lru_list lru;
-
-	for_each_lru(lru) {
-		if (!(BIT(lru) & lru_mask))
-			continue;
-		nr += memcg_page_state(memcg, NR_LRU_BASE + lru);
-	}
-	return nr;
-}
-
 static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
 				       enum mem_cgroup_events_target target)
 {
@@ -3357,6 +3326,42 @@ static int mem_cgroup_move_charge_write(struct cgroup_subsys_state *css,
 #endif
 
 #ifdef CONFIG_NUMA
+
+#define LRU_ALL_FILE (BIT(LRU_INACTIVE_FILE) | BIT(LRU_ACTIVE_FILE))
+#define LRU_ALL_ANON (BIT(LRU_INACTIVE_ANON) | BIT(LRU_ACTIVE_ANON))
+#define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
+
+static unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
+					   int nid, unsigned int lru_mask)
+{
+	struct lruvec *lruvec = mem_cgroup_lruvec(NODE_DATA(nid), memcg);
+	unsigned long nr = 0;
+	enum lru_list lru;
+
+	VM_BUG_ON((unsigned)nid >= nr_node_ids);
+
+	for_each_lru(lru) {
+		if (!(BIT(lru) & lru_mask))
+			continue;
+		nr += lruvec_page_state(lruvec, NR_LRU_BASE + lru);
+	}
+	return nr;
+}
+
+static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
+					     unsigned int lru_mask)
+{
+	unsigned long nr = 0;
+	enum lru_list lru;
+
+	for_each_lru(lru) {
+		if (!(BIT(lru) & lru_mask))
+			continue;
+		nr += memcg_page_state(memcg, NR_LRU_BASE + lru);
+	}
+	return nr;
+}
+
 static int memcg_numa_stat_show(struct seq_file *m, void *v)
 {
 	struct numa_stat {
-- 
2.20.1

