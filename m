From: Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH] mm/memcg: remove definition of MEM_CGROUP_ID_MAX when !CONFIG_MEMCG
Date: Thu, 6 Jul 2023 19:28:20 +0800
Message-ID: <20230706112820.2393447-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com
Cc: muchun.song@linux.dev, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linmiaohe@huawei.com

MEM_CGROUP_ID_MAX is only used when CONFIG_MEMCG is configured. Remove
unneeded !CONFIG_MEMCG variant.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 include/linux/memcontrol.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 5818af8eca5a..634a282099bf 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1158,7 +1158,6 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 #else /* CONFIG_MEMCG */
 
 #define MEM_CGROUP_ID_SHIFT	0
-#define MEM_CGROUP_ID_MAX	0
 
 static inline struct mem_cgroup *folio_memcg(struct folio *folio)
 {
-- 
2.33.0

