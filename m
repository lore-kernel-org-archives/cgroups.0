From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 5/6] mm: memcontrol: push down mem_cgroup_nr_lru_pages()
Date: Thu, 28 Feb 2019 11:30:19 -0500
Message-ID: <20190228163020.24100-6-hannes@cmpxchg.org>
References: <20190228163020.24100-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xYRD3i2lO0S8FmpT0yhEIbRdeHMhHjlJuWkUHWcpJsw=;
        b=qZBcQtunj0HpdKLEyd50kzMF5u4hwQOvpkuAEd9NtT3C1jIdB7SHj5Wu9SVJiJwk3c
         efLEI5hR9LP5jqeXRHv91q1Cfi7QKY7YBX/nYdAjWaCkhg0/6IEOPiQBjKAq0bfilI3N
         6+YUWT4QM7QuO2aTXzGCOAO03Gu8MEqoAFGi1AsO2Gy+6MSFPDuRjpmStKdiUf3gl9WQ
         rYJWUi4TxMM1rVZuaDh8gqG2aQjHBJ/peVLRMFwX1ONsJbyvqNoiueg8XQ0q6ZlZTrDO
         AmmgTrAeqcwX3nf/JCr/thMhQEdk6+oBM8aZcyfJ5f8xItULOYhkQICIPL/RS7FEkfXS
         5ByA==
In-Reply-To: <20190228163020.24100-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

mem_cgroup_nr_lru_pages() is just a convenience wrapper around
memcg_page_state() that takes bitmasks of lru indexes and aggregates
the counts for those.

Replace callsites where the bitmask is simple enough with direct
memcg_page_state() call(s).

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ad6214b3d20b..76f599fbbbe8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1361,7 +1361,7 @@ void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
 
 		for (i = 0; i < NR_LRU_LISTS; i++)
 			pr_cont(" %s:%luKB", mem_cgroup_lru_names[i],
-				K(mem_cgroup_nr_lru_pages(iter, BIT(i))));
+				K(memcg_page_state(iter, NR_LRU_BASE + i)));
 
 		pr_cont("\n");
 	}
@@ -3016,8 +3016,8 @@ static void accumulate_vmstats(struct mem_cgroup *memcg,
 				? acc->vmevents_array[i] : i);
 
 		for (i = 0; i < NR_LRU_LISTS; i++)
-			acc->lru_pages[i] +=
-				mem_cgroup_nr_lru_pages(mi, BIT(i));
+			acc->lru_pages[i] += memcg_page_state(mi,
+							      NR_LRU_BASE + i);
 	}
 }
 
@@ -3447,7 +3447,8 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 
 	for (i = 0; i < NR_LRU_LISTS; i++)
 		seq_printf(m, "%s %lu\n", mem_cgroup_lru_names[i],
-			   mem_cgroup_nr_lru_pages(memcg, BIT(i)) * PAGE_SIZE);
+			   memcg_page_state(memcg, NR_LRU_BASE + i) *
+			   PAGE_SIZE);
 
 	/* Hierarchical information */
 	memory = memsw = PAGE_COUNTER_MAX;
@@ -3937,8 +3938,8 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
 
 	/* this should eventually include NR_UNSTABLE_NFS */
 	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
-	*pfilepages = mem_cgroup_nr_lru_pages(memcg, (1 << LRU_INACTIVE_FILE) |
-						     (1 << LRU_ACTIVE_FILE));
+	*pfilepages = memcg_page_state(memcg, NR_INACTIVE_FILE) +
+		memcg_page_state(memcg, NR_ACTIVE_FILE);
 	*pheadroom = PAGE_COUNTER_MAX;
 
 	while ((parent = parent_mem_cgroup(memcg))) {
-- 
2.20.1

