From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 2/6] mm: memcontrol: replace zone summing with lruvec_page_state()
Date: Thu, 28 Feb 2019 11:30:16 -0500
Message-ID: <20190228163020.24100-3-hannes@cmpxchg.org>
References: <20190228163020.24100-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NxReYuZN9DV/fcdnYYWinsazWkVL2jKBNqgEJlRIVkI=;
        b=ZAGBYz8GP7xIIzJFVPTadJPGGMIowtbAf7+EPG3yvgRIeRyXKmFnQnaswl/xN6iA1h
         Stype2OdeKY7ecFjCOIUKdyiqmYipTgueLOOP9OfEcLkTklZQs71jTxnDHOs/Afca+Ff
         dh99RRH2hehKyyfIpmHBwk1bsz20KaPjXYYkmNhguy18yadeh7dnamP67D/VmkLw2nUb
         ktqdqI4pYdDPvQjETyKp9zSCQqE+VSyjVVX6OecZlKOlxHzVlzveix/BhPrzCNSZJyS+
         CdTvtK4NOJvO4/kPQ5/PxHPZu0t7yQiJLF5gQi2Q3xs2G+vSxFcKWfWRHeCrCn8bRNfR
         8bZA==
In-Reply-To: <20190228163020.24100-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Instead of adding up the zone counters, use lruvec_page_state() to get
the node state directly. This is a bit cheaper and more stream-lined.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/memcontrol.h | 18 ------------------
 mm/memcontrol.c            |  2 +-
 mm/vmscan.c                |  2 +-
 3 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 534267947664..5050d281f67d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -517,19 +517,6 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
 					   int nid, unsigned int lru_mask);
 
-static inline
-unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
-{
-	struct mem_cgroup_per_node *mz;
-	unsigned long nr_pages = 0;
-	int zid;
-
-	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	for (zid = 0; zid < MAX_NR_ZONES; zid++)
-		nr_pages += mz->lru_zone_size[zid][lru];
-	return nr_pages;
-}
-
 static inline
 unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
@@ -985,11 +972,6 @@ static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 	return true;
 }
 
-static inline unsigned long
-mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
-{
-	return 0;
-}
 static inline
 unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5fc2e1a7d4d2..d85a41cfee60 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -737,7 +737,7 @@ unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
 	for_each_lru(lru) {
 		if (!(BIT(lru) & lru_mask))
 			continue;
-		nr += mem_cgroup_get_lru_size(lruvec, lru);
+		nr += lruvec_page_state(lruvec, NR_LRU_BASE + lru);
 	}
 	return nr;
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ac4806f0f332..cdf8d92e6b89 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -346,7 +346,7 @@ unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone
 	int zid;
 
 	if (!mem_cgroup_disabled())
-		lru_size = mem_cgroup_get_lru_size(lruvec, lru);
+		lru_size = lruvec_page_state(lruvec, NR_LRU_BASE + lru);
 	else
 		lru_size = node_page_state(lruvec_pgdat(lruvec), NR_LRU_BASE + lru);
 
-- 
2.20.1

