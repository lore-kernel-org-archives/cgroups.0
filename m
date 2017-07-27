From: Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH] mm: memcontrol: Use int for event/state parameter in several functions
Date: Thu, 27 Jul 2017 14:10:04 -0700
Message-ID: <20170727211004.34435-1-mka@chromium.org>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Doug Anderson <dianders@chromium.org>, Matthias Kaehlcke <mka@chromium.org>

Several functions use an enum type as parameter for an event/state,
but are called in some locations with an argument of a different enum
type. Adjust the interface of these functions to reality by changing the
parameter to int.

This fixes a ton of enum-conversion warnings that are generated when
building the kernel with clang.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
 include/linux/memcontrol.h | 20 ++++++++++++--------
 mm/memcontrol.c            |  4 +++-
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 3914e3dd6168..80edbc04361e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -487,8 +487,9 @@ extern int do_swap_account;
 void lock_page_memcg(struct page *page);
 void unlock_page_memcg(struct page *page);
 
+/* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline unsigned long memcg_page_state(struct mem_cgroup *memcg,
-					     enum memcg_stat_item idx)
+					     int idx)
 {
 	long val = 0;
 	int cpu;
@@ -502,15 +503,17 @@ static inline unsigned long memcg_page_state(struct mem_cgroup *memcg,
 	return val;
 }
 
+/* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline void __mod_memcg_state(struct mem_cgroup *memcg,
-				     enum memcg_stat_item idx, int val)
+				     int idx, int val)
 {
 	if (!mem_cgroup_disabled())
 		__this_cpu_add(memcg->stat->count[idx], val);
 }
 
+/* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline void mod_memcg_state(struct mem_cgroup *memcg,
-				   enum memcg_stat_item idx, int val)
+				   int idx, int val)
 {
 	if (!mem_cgroup_disabled())
 		this_cpu_add(memcg->stat->count[idx], val);
@@ -631,8 +634,9 @@ static inline void count_memcg_events(struct mem_cgroup *memcg,
 		this_cpu_add(memcg->stat->events[idx], count);
 }
 
+/* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline void count_memcg_page_event(struct page *page,
-					  enum memcg_stat_item idx)
+					  int idx)
 {
 	if (page->mem_cgroup)
 		count_memcg_events(page->mem_cgroup, idx, 1);
@@ -840,19 +844,19 @@ static inline bool mem_cgroup_oom_synchronize(bool wait)
 }
 
 static inline unsigned long memcg_page_state(struct mem_cgroup *memcg,
-					     enum memcg_stat_item idx)
+					     int idx)
 {
 	return 0;
 }
 
 static inline void __mod_memcg_state(struct mem_cgroup *memcg,
-				     enum memcg_stat_item idx,
+				     int idx,
 				     int nr)
 {
 }
 
 static inline void mod_memcg_state(struct mem_cgroup *memcg,
-				   enum memcg_stat_item idx,
+				   int idx,
 				   int nr)
 {
 }
@@ -918,7 +922,7 @@ static inline void count_memcg_events(struct mem_cgroup *memcg,
 }
 
 static inline void count_memcg_page_event(struct page *page,
-					  enum memcg_stat_item idx)
+					  int idx)
 {
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3df3c04d73ab..460130d2a796 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -550,10 +550,12 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
  * value, and reading all cpu value can be performance bottleneck in some
  * common workload, threshold and synchronization as vmstat[] should be
  * implemented.
+ *
+ * The parameter idx can be of type enum memcg_event_item or vm_event_item.
  */
 
 static unsigned long memcg_sum_events(struct mem_cgroup *memcg,
-				      enum memcg_event_item event)
+				      int event)
 {
 	unsigned long val = 0;
 	int cpu;
-- 
2.14.0.rc0.400.g1c36432dff-goog

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
