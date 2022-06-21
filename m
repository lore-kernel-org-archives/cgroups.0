From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v6 06/11] mm: thp: make split queue lock safe when LRU pages are reparented
Date: Tue, 21 Jun 2022 20:56:53 +0800
Message-ID: <20220621125658.64935-7-songmuchun@bytedance.com>
References: <20220621125658.64935-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nIZConLAu+BQmuX/Tvb9zBVZtwEjqQiDdIX8payO2zo=;
        b=Zk51NSDrVMZPvZN3TRE8By5zbzxn4KfxBk7mAPZIGImd6sXrZQTiixROziyC4GK7i2
         tjX3Uc/E0v4rj4SK78xIySUmqwcFv2/QqpusGj+so6BOEcPZY8a1BVGjEQEYoGh7bkkl
         OE/0bXu3mXp+aWvIm0cGBgL12WKiQodj2ZzTuAk2u3eLaReU+cqH1yGlGUUfgMhXcIsa
         pMZ2j0weSC5IJyI7Bg2HlgmEVFzD4vXJM29uR5XzcRBOtii439vkQTRNzX2HOBB+Ru/L
         ngbXnl0WALO2G1k49DSGVvpkOu3AFIwpwC5BwKEXviwXxw5OpAxEnvkkS7Z0wzEZO0oN
         dG0Q==
In-Reply-To: <20220621125658.64935-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Similar to the lruvec lock, we use the same approach to make the split
queue lock safe when LRU pages are reparented.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
---
 include/linux/memcontrol.h |  10 ++++
 mm/huge_memory.c           | 116 +++++++++++++++++++++++++++++++++++----------
 2 files changed, 100 insertions(+), 26 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ff3106eca6f3..026b62b206b1 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1691,6 +1691,11 @@ int alloc_shrinker_info(struct mem_cgroup *memcg);
 void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
 void reparent_shrinker_deferred(struct mem_cgroup *memcg);
+
+static inline int shrinker_id(struct shrinker *shrinker)
+{
+	return shrinker->id;
+}
 #else
 #define mem_cgroup_sockets_enabled 0
 static inline void mem_cgroup_sk_alloc(struct sock *sk) { };
@@ -1704,6 +1709,11 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
 				    int nid, int shrinker_id)
 {
 }
+
+static inline int shrinker_id(struct shrinker *shrinker)
+{
+	return -1;
+}
 #endif
 
 #ifdef CONFIG_MEMCG_KMEM
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 66d9ed8a1289..11ec92783b37 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -558,25 +558,90 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
 }
 
 #ifdef CONFIG_MEMCG
-static inline struct deferred_split *get_deferred_split_queue(struct page *page)
+static inline struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
+		struct deferred_split *queue)
 {
-	struct mem_cgroup *memcg = page_memcg(compound_head(page));
-	struct pglist_data *pgdat = NODE_DATA(page_to_nid(page));
+	if (mem_cgroup_disabled())
+		return NULL;
+	if (&NODE_DATA(folio_nid(folio))->deferred_split_queue == queue)
+		return NULL;
+	return container_of(queue, struct mem_cgroup, deferred_split_queue);
+}
 
-	if (memcg)
-		return &memcg->deferred_split_queue;
-	else
-		return &pgdat->deferred_split_queue;
+static inline struct deferred_split *folio_memcg_split_queue(struct folio *folio)
+{
+	struct mem_cgroup *memcg = folio_memcg(folio);
+
+	return memcg ? &memcg->deferred_split_queue : NULL;
 }
 #else
-static inline struct deferred_split *get_deferred_split_queue(struct page *page)
+static inline struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
+		struct deferred_split *queue)
 {
-	struct pglist_data *pgdat = NODE_DATA(page_to_nid(page));
+	return NULL;
+}
 
-	return &pgdat->deferred_split_queue;
+static inline struct deferred_split *folio_memcg_split_queue(struct folio *folio)
+{
+	return NULL;
 }
 #endif
 
+static struct deferred_split *folio_split_queue(struct folio *folio)
+{
+	struct deferred_split *queue = folio_memcg_split_queue(folio);
+
+	return queue ? : &NODE_DATA(folio_nid(folio))->deferred_split_queue;
+}
+
+static struct deferred_split *folio_split_queue_lock(struct folio *folio)
+{
+	struct deferred_split *queue;
+
+	rcu_read_lock();
+retry:
+	queue = folio_split_queue(folio);
+	spin_lock(&queue->split_queue_lock);
+
+	if (unlikely(folio_split_queue_memcg(folio, queue) != folio_memcg(folio))) {
+		spin_unlock(&queue->split_queue_lock);
+		goto retry;
+	}
+	rcu_read_unlock();
+
+	return queue;
+}
+
+static struct deferred_split *
+folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
+{
+	struct deferred_split *queue;
+
+	rcu_read_lock();
+retry:
+	queue = folio_split_queue(folio);
+	spin_lock_irqsave(&queue->split_queue_lock, *flags);
+
+	if (unlikely(folio_split_queue_memcg(folio, queue) != folio_memcg(folio))) {
+		spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
+		goto retry;
+	}
+	rcu_read_unlock();
+
+	return queue;
+}
+
+static inline void split_queue_unlock(struct deferred_split *queue)
+{
+	spin_unlock(&queue->split_queue_lock);
+}
+
+static inline void split_queue_unlock_irqrestore(struct deferred_split *queue,
+						 unsigned long flags)
+{
+	spin_unlock_irqrestore(&queue->split_queue_lock, flags);
+}
+
 void prep_transhuge_page(struct page *page)
 {
 	/*
@@ -2600,7 +2665,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 {
 	struct folio *folio = page_folio(page);
 	struct page *head = &folio->page;
-	struct deferred_split *ds_queue = get_deferred_split_queue(head);
+	struct deferred_split *ds_queue;
 	XA_STATE(xas, &head->mapping->i_pages, head->index);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
@@ -2692,13 +2757,13 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	}
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
-	spin_lock(&ds_queue->split_queue_lock);
+	ds_queue = folio_split_queue_lock(folio);
 	if (page_ref_freeze(head, 1 + extra_pins)) {
 		if (!list_empty(page_deferred_list(head))) {
 			ds_queue->split_queue_len--;
 			list_del(page_deferred_list(head));
 		}
-		spin_unlock(&ds_queue->split_queue_lock);
+		split_queue_unlock(ds_queue);
 		if (mapping) {
 			int nr = thp_nr_pages(head);
 
@@ -2716,7 +2781,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 		__split_huge_page(page, list, end);
 		ret = 0;
 	} else {
-		spin_unlock(&ds_queue->split_queue_lock);
+		split_queue_unlock(ds_queue);
 fail:
 		if (mapping)
 			xas_unlock(&xas);
@@ -2740,25 +2805,23 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 
 void free_transhuge_page(struct page *page)
 {
-	struct deferred_split *ds_queue = get_deferred_split_queue(page);
+	struct deferred_split *ds_queue;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	ds_queue = folio_split_queue_lock_irqsave(page_folio(page), &flags);
 	if (!list_empty(page_deferred_list(page))) {
 		ds_queue->split_queue_len--;
 		list_del(page_deferred_list(page));
 	}
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+	split_queue_unlock_irqrestore(ds_queue, flags);
 	free_compound_page(page);
 }
 
 void deferred_split_huge_page(struct page *page)
 {
-	struct deferred_split *ds_queue = get_deferred_split_queue(page);
-#ifdef CONFIG_MEMCG
-	struct mem_cgroup *memcg = page_memcg(compound_head(page));
-#endif
+	struct deferred_split *ds_queue;
 	unsigned long flags;
+	struct folio *folio = page_folio(page);
 
 	VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 
@@ -2775,18 +2838,19 @@ void deferred_split_huge_page(struct page *page)
 	if (PageSwapCache(page))
 		return;
 
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
 	if (list_empty(page_deferred_list(page))) {
+		struct mem_cgroup *memcg;
+
+		memcg = folio_split_queue_memcg(folio, ds_queue);
 		count_vm_event(THP_DEFERRED_SPLIT_PAGE);
 		list_add_tail(page_deferred_list(page), &ds_queue->split_queue);
 		ds_queue->split_queue_len++;
-#ifdef CONFIG_MEMCG
 		if (memcg)
 			set_shrinker_bit(memcg, page_to_nid(page),
-					 deferred_split_shrinker.id);
-#endif
+					 shrinker_id(&deferred_split_shrinker));
 	}
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+	split_queue_unlock_irqrestore(ds_queue, flags);
 }
 
 static unsigned long deferred_split_count(struct shrinker *shrink,
-- 
2.11.0

