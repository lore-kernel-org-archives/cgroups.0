From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH rebase] mm: fix vm-scalability regression in cgroup-aware
 workingset code
Date: Fri, 24 Jun 2016 13:51:01 -0400
Message-ID: <20160624175101.GA3024@cmpxchg.org>
References: <20160622182019.24064-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160622182019.24064-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Ye Xiaolong <xiaolong.ye-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

This is a rebased version on top of mmots sans the nodelru stuff.

---

23047a96d7cf ("mm: workingset: per-cgroup cache thrash detection")
added a page->mem_cgroup lookup to the cache eviction, refault, and
activation paths, as well as locking to the activation path, and the
vm-scalability tests showed a regression of -23%. While the test in
question is an artificial worst-case scenario that doesn't occur in
real workloads - reading two sparse files in parallel at full CPU
speed just to hammer the LRU paths - there is still some optimizations
that can be done in those paths.

Inline the lookup functions to eliminate calls. Also, page->mem_cgroup
doesn't need to be stabilized when counting an activation; we merely
need to hold the RCU lock to prevent the memcg from being freed.

This cuts down on overhead quite a bit:

23047a96d7cfcfca 063f6715e77a7be5770d6081fe
---------------- --------------------------
         %stddev     %change         %stddev
             \          |                \
  21621405 +- 0%     +11.3%   24069657 +- 2%  vm-scalability.throughput

Reported-by: Ye Xiaolong <xiaolong.ye-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 include/linux/memcontrol.h | 44 +++++++++++++++++++++++++++++++++++++++++++-
 include/linux/mm.h         |  8 ++++++++
 mm/memcontrol.c            | 42 ------------------------------------------
 mm/workingset.c            | 10 ++++++----
 4 files changed, 57 insertions(+), 47 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 71aff733a497..104efa6874db 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -29,6 +29,7 @@
 #include <linux/mmzone.h>
 #include <linux/writeback.h>
 #include <linux/page-flags.h>
+#include <linux/mm.h>
 
 struct mem_cgroup;
 struct page;
@@ -314,7 +315,48 @@ void mem_cgroup_uncharge_list(struct list_head *page_list);
 
 void mem_cgroup_migrate(struct page *oldpage, struct page *newpage);
 
-struct lruvec *mem_cgroup_zone_lruvec(struct zone *, struct mem_cgroup *);
+static inline struct mem_cgroup_per_zone *
+mem_cgroup_zone_zoneinfo(struct mem_cgroup *memcg, struct zone *zone)
+{
+	int nid = zone_to_nid(zone);
+	int zid = zone_idx(zone);
+
+	return &memcg->nodeinfo[nid]->zoneinfo[zid];
+}
+
+/**
+ * mem_cgroup_zone_lruvec - get the lru list vector for a zone and memcg
+ * @zone: zone of the wanted lruvec
+ * @memcg: memcg of the wanted lruvec
+ *
+ * Returns the lru list vector holding pages for the given @zone and
+ * @mem.  This can be the global zone lruvec, if the memory controller
+ * is disabled.
+ */
+static inline struct lruvec *mem_cgroup_zone_lruvec(struct zone *zone,
+						    struct mem_cgroup *memcg)
+{
+	struct mem_cgroup_per_zone *mz;
+	struct lruvec *lruvec;
+
+	if (mem_cgroup_disabled()) {
+		lruvec = &zone->lruvec;
+		goto out;
+	}
+
+	mz = mem_cgroup_zone_zoneinfo(memcg, zone);
+	lruvec = &mz->lruvec;
+out:
+	/*
+	 * Since a node can be onlined after the mem_cgroup was created,
+	 * we have to be prepared to initialize lruvec->zone here;
+	 * and if offlined then reonlined, we need to reinitialize it.
+	 */
+	if (unlikely(lruvec->zone != zone))
+		lruvec->zone = zone;
+	return lruvec;
+}
+
 struct lruvec *mem_cgroup_page_lruvec(struct page *, struct zone *);
 
 bool task_in_mem_cgroup(struct task_struct *task, struct mem_cgroup *memcg);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c606fe4f9a7f..b21e5f30378e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -973,11 +973,19 @@ static inline struct mem_cgroup *page_memcg(struct page *page)
 {
 	return page->mem_cgroup;
 }
+static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
+{
+	return READ_ONCE(page->mem_cgroup);
+}
 #else
 static inline struct mem_cgroup *page_memcg(struct page *page)
 {
 	return NULL;
 }
+static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
+{
+	return NULL;
+}
 #endif
 
 /*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3e8f9e5e9291..40dfca3ef4bb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -323,15 +323,6 @@ EXPORT_SYMBOL(memcg_kmem_enabled_key);
 
 #endif /* !CONFIG_SLOB */
 
-static struct mem_cgroup_per_zone *
-mem_cgroup_zone_zoneinfo(struct mem_cgroup *memcg, struct zone *zone)
-{
-	int nid = zone_to_nid(zone);
-	int zid = zone_idx(zone);
-
-	return &memcg->nodeinfo[nid]->zoneinfo[zid];
-}
-
 /**
  * mem_cgroup_css_from_page - css of the memcg associated with a page
  * @page: page of interest
@@ -944,39 +935,6 @@ static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
 /**
- * mem_cgroup_zone_lruvec - get the lru list vector for a zone and memcg
- * @zone: zone of the wanted lruvec
- * @memcg: memcg of the wanted lruvec
- *
- * Returns the lru list vector holding pages for the given @zone and
- * @mem.  This can be the global zone lruvec, if the memory controller
- * is disabled.
- */
-struct lruvec *mem_cgroup_zone_lruvec(struct zone *zone,
-				      struct mem_cgroup *memcg)
-{
-	struct mem_cgroup_per_zone *mz;
-	struct lruvec *lruvec;
-
-	if (mem_cgroup_disabled()) {
-		lruvec = &zone->lruvec;
-		goto out;
-	}
-
-	mz = mem_cgroup_zone_zoneinfo(memcg, zone);
-	lruvec = &mz->lruvec;
-out:
-	/*
-	 * Since a node can be onlined after the mem_cgroup was created,
-	 * we have to be prepared to initialize lruvec->zone here;
-	 * and if offlined then reonlined, we need to reinitialize it.
-	 */
-	if (unlikely(lruvec->zone != zone))
-		lruvec->zone = zone;
-	return lruvec;
-}
-
-/**
  * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU page
  * @page: the page
  * @zone: zone of the page
diff --git a/mm/workingset.c b/mm/workingset.c
index 8a75f8d2916a..8252de4566e9 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -305,9 +305,10 @@ bool workingset_refault(void *shadow)
  */
 void workingset_activation(struct page *page)
 {
+	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 
-	lock_page_memcg(page);
+	rcu_read_lock();
 	/*
 	 * Filter non-memcg pages here, e.g. unmap can call
 	 * mark_page_accessed() on VDSO pages.
@@ -315,12 +316,13 @@ void workingset_activation(struct page *page)
 	 * XXX: See workingset_refault() - this should return
 	 * root_mem_cgroup even for !CONFIG_MEMCG.
 	 */
-	if (!mem_cgroup_disabled() && !page_memcg(page))
+	memcg = page_memcg_rcu(page);
+	if (!mem_cgroup_disabled() && !memcg)
 		goto out;
-	lruvec = mem_cgroup_zone_lruvec(page_zone(page), page_memcg(page));
+	lruvec = mem_cgroup_zone_lruvec(page_zone(page), memcg);
 	atomic_long_inc(&lruvec->inactive_age);
 out:
-	unlock_page_memcg(page);
+	rcu_read_unlock();
 }
 
 /*
-- 
2.8.3
