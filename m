From: alexander.h.duyck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH RFC] mm: Add function for testing if the current lruvec lock
 is valid
Date: Fri, 31 Jul 2020 14:14:16 -0700
Message-ID: <159622999150.2576729.14455020813024958573.stgit@ahduyck-desk1.jf.intel.com>
References: <1595681998-19193-19-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1595681998-19193-19-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org

From: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

When testing for relock we can avoid the need for RCU locking if we simply
compare the page pgdat and memcg pointers versus those that the lruvec is
holding. By doing this we can avoid the extra pointer walks and accesses of
the memory cgroup.

In addition we can avoid the checks entirely if lruvec is currently NULL.

Signed-off-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 include/linux/memcontrol.h |   52 +++++++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 20 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6e670f991b42..7a02f00bf3de 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -405,6 +405,22 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
 
 struct lruvec *mem_cgroup_page_lruvec(struct page *, struct pglist_data *);
 
+static inline bool lruvec_holds_page_lru_lock(struct page *page,
+					      struct lruvec *lruvec)
+{
+	pg_data_t *pgdat = page_pgdat(page);
+	const struct mem_cgroup *memcg;
+	struct mem_cgroup_per_node *mz;
+
+	if (mem_cgroup_disabled())
+		return lruvec == &pgdat->__lruvec;
+
+	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	memcg = page->mem_cgroup ? : root_mem_cgroup;
+
+	return lruvec->pgdat == pgdat && mz->memcg == memcg;
+}
+
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
 struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
@@ -880,6 +896,14 @@ static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page,
 	return &pgdat->__lruvec;
 }
 
+static inline bool lruvec_holds_page_lru_lock(struct page *page,
+					      struct lruvec *lruvec)
+{
+		pg_data_t *pgdat = page_pgdat(page);
+
+		return lruvec == &pgdat->__lruvec;
+}
+
 static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
 {
 	return NULL;
@@ -1317,18 +1341,12 @@ static inline void unlock_page_lruvec_irqrestore(struct lruvec *lruvec,
 static inline struct lruvec *relock_page_lruvec_irq(struct page *page,
 		struct lruvec *locked_lruvec)
 {
-	struct pglist_data *pgdat = page_pgdat(page);
-	bool locked;
+	if (locked_lruvec) {
+		if (lruvec_holds_page_lru_lock(page, locked_lruvec))
+			return locked_lruvec;
 
-	rcu_read_lock();
-	locked = mem_cgroup_page_lruvec(page, pgdat) == locked_lruvec;
-	rcu_read_unlock();
-
-	if (locked)
-		return locked_lruvec;
-
-	if (locked_lruvec)
 		unlock_page_lruvec_irq(locked_lruvec);
+	}
 
 	return lock_page_lruvec_irq(page);
 }
@@ -1337,18 +1355,12 @@ static inline struct lruvec *relock_page_lruvec_irq(struct page *page,
 static inline struct lruvec *relock_page_lruvec_irqsave(struct page *page,
 		struct lruvec *locked_lruvec, unsigned long *flags)
 {
-	struct pglist_data *pgdat = page_pgdat(page);
-	bool locked;
-
-	rcu_read_lock();
-	locked = mem_cgroup_page_lruvec(page, pgdat) == locked_lruvec;
-	rcu_read_unlock();
-
-	if (locked)
-		return locked_lruvec;
+	if (locked_lruvec) {
+		if (lruvec_holds_page_lru_lock(page, locked_lruvec))
+			return locked_lruvec;
 
-	if (locked_lruvec)
 		unlock_page_lruvec_irqrestore(locked_lruvec, *flags);
+	}
 
 	return lock_page_lruvec_irqsave(page, flags);
 }


