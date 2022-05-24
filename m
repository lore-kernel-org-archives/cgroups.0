From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v4 03/11] mm: memcontrol: make lruvec lock safe when LRU pages are reparented
Date: Tue, 24 May 2022 14:05:43 +0800
Message-ID: <20220524060551.80037-4-songmuchun@bytedance.com>
References: <20220524060551.80037-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ps+xkks9BA0IHbJ7e2Vp4q031wMw8KJxnkj0GJ9dypU=;
        b=tifRAsabe/xz0iekv4yC+Zh0Vn2uMaOfgndI2cnHadPnG1WYTFhrpunDnj5seDRE/W
         KgsNtldScqY9J5t7REermRIAZWnR+n5sVNHU8MCs5Jo0rXscKfdhZwMOaMfD/AHmhtx8
         4SpEvEVw9VKd7rcOFcmrDrG4teOq+leHY0+fuLbOFSJ74c4x9O/JtXynpf11F25m638x
         IS++bfkZ5xRuuCpHynZrX3rrE+PpLWvxyIkJX3LYUw1+QBP/QQFqwloPiiDQqyKvoBB5
         uk+bO+IFJoRgl9tDxy2r75yhWUUm8+olsPngbOGfrNRsu3de95nV1s4PmqgHAHBF5TtG
         L13Q==
In-Reply-To: <20220524060551.80037-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

The diagram below shows how to make the folio lruvec lock safe when LRU
pages are reparented.

folio_lruvec_lock(folio)
    retry:
	lruvec = folio_lruvec(folio);

        // The folio is reparented at this time.
        spin_lock(&lruvec->lru_lock);

        if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio)))
            // Acquired the wrong lruvec lock and need to retry.
            // Because this folio is on the parent memcg lruvec list.
            goto retry;

        // If we reach here, it means that folio_memcg(folio) is stable.

memcg_reparent_objcgs(memcg)
    // lruvec belongs to memcg and lruvec_parent belongs to parent memcg.
    spin_lock(&lruvec->lru_lock);
    spin_lock(&lruvec_parent->lru_lock);

    // Move all the pages from the lruvec list to the parent lruvec list.

    spin_unlock(&lruvec_parent->lru_lock);
    spin_unlock(&lruvec->lru_lock);

After we acquire the lruvec lock, we need to check whether the folio is
reparented. If so, we need to reacquire the new lruvec lock. On the
routine of the LRU pages reparenting, we will also acquire the lruvec
lock (will be implemented in the later patch). So folio_memcg() cannot
be changed when we hold the lruvec lock.

Since lruvec_memcg(lruvec) is always equal to folio_memcg(folio) after
we hold the lruvec lock, lruvec_memcg_debug() check is pointless. So
remove it.

This is a preparation for reparenting the LRU pages.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 include/linux/memcontrol.h | 18 +++-----------
 mm/compaction.c            | 10 +++++++-
 mm/memcontrol.c            | 62 +++++++++++++++++++++++++++++-----------------
 mm/swap.c                  |  4 +++
 4 files changed, 55 insertions(+), 39 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ff1c1dd7e762..4042e4d21fe2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -752,7 +752,9 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
  * folio_lruvec - return lruvec for isolating/putting an LRU folio
  * @folio: Pointer to the folio.
  *
- * This function relies on folio->mem_cgroup being stable.
+ * The lruvec can be changed to its parent lruvec when the page reparented.
+ * The caller need to recheck if it cares about this changes (just like
+ * folio_lruvec_lock() does).
  */
 static inline struct lruvec *folio_lruvec(struct folio *folio)
 {
@@ -771,15 +773,6 @@ struct lruvec *folio_lruvec_lock_irq(struct folio *folio);
 struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
 						unsigned long *flags);
 
-#ifdef CONFIG_DEBUG_VM
-void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio);
-#else
-static inline
-void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio)
-{
-}
-#endif
-
 static inline
 struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css){
 	return css ? container_of(css, struct mem_cgroup, css) : NULL;
@@ -1240,11 +1233,6 @@ static inline struct lruvec *folio_lruvec(struct folio *folio)
 	return &pgdat->__lruvec;
 }
 
-static inline
-void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio)
-{
-}
-
 static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
 {
 	return NULL;
diff --git a/mm/compaction.c b/mm/compaction.c
index 817098817302..1692b17db781 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -515,6 +515,8 @@ compact_folio_lruvec_lock_irqsave(struct folio *folio, unsigned long *flags,
 {
 	struct lruvec *lruvec;
 
+	rcu_read_lock();
+retry:
 	lruvec = folio_lruvec(folio);
 
 	/* Track if the lock is contended in async mode */
@@ -527,7 +529,13 @@ compact_folio_lruvec_lock_irqsave(struct folio *folio, unsigned long *flags,
 
 	spin_lock_irqsave(&lruvec->lru_lock, *flags);
 out:
-	lruvec_memcg_debug(lruvec, folio);
+	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
+		spin_unlock_irqrestore(&lruvec->lru_lock, *flags);
+		goto retry;
+	}
+
+	/* See the comments in folio_lruvec_lock(). */
+	rcu_read_unlock();
 
 	return lruvec;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6de0d3e53eb1..b38a77f6696f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1199,23 +1199,6 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 	return ret;
 }
 
-#ifdef CONFIG_DEBUG_VM
-void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio)
-{
-	struct mem_cgroup *memcg;
-
-	if (mem_cgroup_disabled())
-		return;
-
-	memcg = folio_memcg(folio);
-
-	if (!memcg)
-		VM_BUG_ON_FOLIO(lruvec_memcg(lruvec) != root_mem_cgroup, folio);
-	else
-		VM_BUG_ON_FOLIO(lruvec_memcg(lruvec) != memcg, folio);
-}
-#endif
-
 /**
  * folio_lruvec_lock - Lock the lruvec for a folio.
  * @folio: Pointer to the folio.
@@ -1230,10 +1213,23 @@ void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio)
  */
 struct lruvec *folio_lruvec_lock(struct folio *folio)
 {
-	struct lruvec *lruvec = folio_lruvec(folio);
+	struct lruvec *lruvec;
 
+	rcu_read_lock();
+retry:
+	lruvec = folio_lruvec(folio);
 	spin_lock(&lruvec->lru_lock);
-	lruvec_memcg_debug(lruvec, folio);
+
+	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
+		spin_unlock(&lruvec->lru_lock);
+		goto retry;
+	}
+
+	/*
+	 * Preemption is disabled in the internal of spin_lock, which can serve
+	 * as RCU read-side critical sections.
+	 */
+	rcu_read_unlock();
 
 	return lruvec;
 }
@@ -1253,10 +1249,20 @@ struct lruvec *folio_lruvec_lock(struct folio *folio)
  */
 struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
 {
-	struct lruvec *lruvec = folio_lruvec(folio);
+	struct lruvec *lruvec;
 
+	rcu_read_lock();
+retry:
+	lruvec = folio_lruvec(folio);
 	spin_lock_irq(&lruvec->lru_lock);
-	lruvec_memcg_debug(lruvec, folio);
+
+	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
+		spin_unlock_irq(&lruvec->lru_lock);
+		goto retry;
+	}
+
+	/* See the comments in folio_lruvec_lock(). */
+	rcu_read_unlock();
 
 	return lruvec;
 }
@@ -1278,10 +1284,20 @@ struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
 struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
 		unsigned long *flags)
 {
-	struct lruvec *lruvec = folio_lruvec(folio);
+	struct lruvec *lruvec;
 
+	rcu_read_lock();
+retry:
+	lruvec = folio_lruvec(folio);
 	spin_lock_irqsave(&lruvec->lru_lock, *flags);
-	lruvec_memcg_debug(lruvec, folio);
+
+	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
+		spin_unlock_irqrestore(&lruvec->lru_lock, *flags);
+		goto retry;
+	}
+
+	/* See the comments in folio_lruvec_lock(). */
+	rcu_read_unlock();
 
 	return lruvec;
 }
diff --git a/mm/swap.c b/mm/swap.c
index 7e320ec08c6a..9680f2fc48b1 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -303,6 +303,10 @@ void lru_note_cost(struct lruvec *lruvec, bool file, unsigned int nr_pages)
 
 void lru_note_cost_folio(struct folio *folio)
 {
+	/*
+	 * The rcu read lock is held by the caller, so we do not need to
+	 * care about the lruvec returned by folio_lruvec() being released.
+	 */
 	lru_note_cost(folio_lruvec(folio), folio_is_file_lru(folio),
 			folio_nr_pages(folio));
 }
-- 
2.11.0

