From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] mm: fix vm-scalability regression in cgroup-aware workingset code
Date: Wed, 22 Jun 2016 14:20:19 -0400
Message-ID: <20160622182019.24064-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Xiaolong <xiaolong.ye@intel.com>, Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@virtuozzo.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

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
  21621405 =C2=B1  0%     +11.3%   24069657 =C2=B1  2%  vm-scalability.th=
roughput

Reported-by: Ye Xiaolong <xiaolong.ye@intel.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/memcontrol.h | 39 ++++++++++++++++++++++++++++++++++++++-
 include/linux/mm.h         |  8 ++++++++
 mm/memcontrol.c            | 39 ---------------------------------------
 mm/workingset.c            | 10 ++++++----
 4 files changed, 52 insertions(+), 44 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a221663687d5..16609ab1a032 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -310,7 +310,44 @@ void mem_cgroup_uncharge_list(struct list_head *page=
_list);
=20
 void mem_cgroup_migrate(struct page *oldpage, struct page *newpage);
=20
-struct lruvec *mem_cgroup_lruvec(struct pglist_data *, struct mem_cgroup=
 *);
+static inline struct mem_cgroup_per_node *
+mem_cgroup_nodeinfo(struct mem_cgroup *memcg, int nid)
+{
+	return memcg->nodeinfo[nid];
+}
+
+/**
+ * mem_cgroup_lruvec - get the lru list vector for a memcg node
+ * @node: node of the wanted lruvec
+ * @memcg: memcg of the wanted lruvec
+ *
+ * Returns the lru list vector holding pages for a given @node and @memc=
g.
+ * This can be the node lruvec, if the memory controller is disabled.
+ */
+static inline struct lruvec *mem_cgroup_lruvec(struct pglist_data *pgdat=
,
+					       struct mem_cgroup *memcg)
+{
+	struct mem_cgroup_per_node *mz;
+	struct lruvec *lruvec;
+
+	if (mem_cgroup_disabled()) {
+		lruvec =3D node_lruvec(pgdat);
+		goto out;
+	}
+
+	mz =3D mem_cgroup_nodeinfo(memcg, pgdat->node_id);
+	lruvec =3D &mz->lruvec;
+out:
+	/*
+	 * Since a node can be onlined after the mem_cgroup was created,
+	 * we have to be prepared to initialize lruvec->zone here;
+	 * and if offlined then reonlined, we need to reinitialize it.
+	 */
+	if (unlikely(lruvec->pgdat !=3D pgdat))
+		lruvec->pgdat =3D pgdat;
+	return lruvec;
+}
+
 struct lruvec *mem_cgroup_page_lruvec(struct page *, struct pglist_data =
*);
=20
 bool task_in_mem_cgroup(struct task_struct *task, struct mem_cgroup *mem=
cg);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 14de8810d02e..0f7a4d89b52a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -978,11 +978,19 @@ static inline struct mem_cgroup *page_memcg(struct =
page *page)
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
=20
 /*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2b6574a13d0e..603e9b030e46 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -319,12 +319,6 @@ EXPORT_SYMBOL(memcg_kmem_enabled_key);
=20
 #endif /* !CONFIG_SLOB */
=20
-static struct mem_cgroup_per_node *
-mem_cgroup_nodeinfo(struct mem_cgroup *memcg, int nid)
-{
-	return memcg->nodeinfo[nid];
-}
-
 /**
  * mem_cgroup_css_from_page - css of the memcg associated with a page
  * @page: page of interest
@@ -927,39 +921,6 @@ static void invalidate_reclaim_iterators(struct mem_=
cgroup *dead_memcg)
 	     iter =3D mem_cgroup_iter(NULL, iter, NULL))
=20
 /**
- * mem_cgroup_lruvec - get the lru list vector for a node or a memcg zon=
e
- * @node: node of the wanted lruvec
- * @memcg: memcg of the wanted lruvec
- *
- * Returns the lru list vector holding pages for a given @node or a give=
n
- * @memcg and @zone. This can be the node lruvec, if the memory controll=
er
- * is disabled.
- */
-struct lruvec *mem_cgroup_lruvec(struct pglist_data *pgdat,
-				 struct mem_cgroup *memcg)
-{
-	struct mem_cgroup_per_node *mz;
-	struct lruvec *lruvec;
-
-	if (mem_cgroup_disabled()) {
-		lruvec =3D node_lruvec(pgdat);
-		goto out;
-	}
-
-	mz =3D mem_cgroup_nodeinfo(memcg, pgdat->node_id);
-	lruvec =3D &mz->lruvec;
-out:
-	/*
-	 * Since a node can be onlined after the mem_cgroup was created,
-	 * we have to be prepared to initialize lruvec->zone here;
-	 * and if offlined then reonlined, we need to reinitialize it.
-	 */
-	if (unlikely(lruvec->pgdat !=3D pgdat))
-		lruvec->pgdat =3D pgdat;
-	return lruvec;
-}
-
-/**
  * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU p=
age
  * @page: the page
  * @zone: zone of the page
diff --git a/mm/workingset.c b/mm/workingset.c
index 236493eaf480..d4c864066fde 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -302,9 +302,10 @@ bool workingset_refault(void *shadow)
  */
 void workingset_activation(struct page *page)
 {
+	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
=20
-	lock_page_memcg(page);
+	rcu_read_lock();
 	/*
 	 * Filter non-memcg pages here, e.g. unmap can call
 	 * mark_page_accessed() on VDSO pages.
@@ -312,12 +313,13 @@ void workingset_activation(struct page *page)
 	 * XXX: See workingset_refault() - this should return
 	 * root_mem_cgroup even for !CONFIG_MEMCG.
 	 */
-	if (!mem_cgroup_disabled() && !page_memcg(page))
+	memcg =3D page_memcg_rcu(page);
+	if (!mem_cgroup_disabled() && !memcg)
 		goto out;
-	lruvec =3D mem_cgroup_lruvec(page_pgdat(page), page_memcg(page));
+	lruvec =3D mem_cgroup_lruvec(page_pgdat(page), memcg);
 	atomic_long_inc(&lruvec->inactive_age);
 out:
-	unlock_page_memcg(page);
+	rcu_read_unlock();
 }
=20
 /*
--=20
2.8.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
