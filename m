From: Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH] mm/memcg: update obsolete comment above parent_mem_cgroup()
Date: Tue, 1 Aug 2023 20:43:59 +0800
Message-ID: <20230801124359.2266860-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linmiaohe@huawei.com

Since commit bef8620cd8e0 ("mm: memcg: deprecate the non-hierarchical
mode"), use_hierarchy is already deprecated. And it's further removed
via commit 9d9d341df4d5 ("cgroup: remove obsoleted broken_hierarchy
and warned_broken_hierarchy"). Update corresponding comment.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 include/linux/memcontrol.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 3bd00f224224..11810a2cfd2d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -863,8 +863,7 @@ static inline struct mem_cgroup *lruvec_memcg(struct lruvec *lruvec)
  * parent_mem_cgroup - find the accounting parent of a memcg
  * @memcg: memcg whose parent to find
  *
- * Returns the parent memcg, or NULL if this is the root or the memory
- * controller is in legacy no-hierarchy mode.
+ * Returns the parent memcg, or NULL if this is the root.
  */
 static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
 {
-- 
2.33.0

