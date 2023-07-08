From: Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH v2] mm/memcg: minor cleanup for MEM_CGROUP_ID_MAX
Date: Sat, 8 Jul 2023 10:33:04 +0800
Message-ID: <20230708023304.1184111-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com
Cc: muchun.song@linux.dev, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linmiaohe@huawei.com

MEM_CGROUP_ID_MAX is only used when CONFIG_MEMCG is configured. So remove
unneeded !CONFIG_MEMCG variant. Also it's only used in mem_cgroup_alloc(),
so move it from memcontrol.h to memcontrol.c. And further define it as:
  #define MEM_CGROUP_ID_MAX ((1UL << MEM_CGROUP_ID_SHIFT) - 1)
so if someone changes MEM_CGROUP_ID_SHIFT in the future, then
MEM_CGROUP_ID_MAX will be updated accordingly, as suggested by Muchun.

Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 include/linux/memcontrol.h | 2 --
 mm/memcontrol.c            | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 5818af8eca5a..58eb7ca65699 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -61,7 +61,6 @@ struct mem_cgroup_reclaim_cookie {
 #ifdef CONFIG_MEMCG
 
 #define MEM_CGROUP_ID_SHIFT	16
-#define MEM_CGROUP_ID_MAX	USHRT_MAX
 
 struct mem_cgroup_id {
 	int id;
@@ -1158,7 +1157,6 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 #else /* CONFIG_MEMCG */
 
 #define MEM_CGROUP_ID_SHIFT	0
-#define MEM_CGROUP_ID_MAX	0
 
 static inline struct mem_cgroup *folio_memcg(struct folio *folio)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e8ca4bdcb03c..284396ea8a33 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5165,6 +5165,7 @@ static struct cftype mem_cgroup_legacy_files[] = {
  * those references are manageable from userspace.
  */
 
+#define MEM_CGROUP_ID_MAX	((1UL << MEM_CGROUP_ID_SHIFT) - 1)
 static DEFINE_IDR(mem_cgroup_idr);
 
 static void mem_cgroup_id_remove(struct mem_cgroup *memcg)
-- 
2.33.0

