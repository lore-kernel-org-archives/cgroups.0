From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 05/18] mm: memcontrol: convert page cache to a new mem_cgroup_charge() API
Date: Mon, 20 Apr 2020 18:11:13 -0400
Message-ID: <20200420221126.341272-6-hannes@cmpxchg.org>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NQlXjGd8cWwHx163k4HH7Ic3eFVRzUnuA2WhWG1OsgA=;
        b=lnHPkR6UiNAHp/TiGxb8u8qVeySABveLUC7D5Yf0mwbtb1W1LpSN9Mfb3CA8w1LxxV
         TbQ3t/Ydz6A4s58B6r2ovay4prewKRJxWXxBVBpJdHQD6/UEsDT69x7Pw52MS+9iF4+L
         mmw0Ta4tnDNvy5x+rlvhZA60pWcXQKI7p+X/rlyUSRC4DVOXFhNA8SnMRu/WZiaVvgYz
         KoGDJ6TSHrpPVTIw2Al9FgQUegfIoGXE8K+YVx3FzUin6WjzOkWh37YGil9CgJVjzKnv
         oQuHe+e4KarIvFr/a8/U5tuHNw6TGjwlxfdxZkaBl2b4Dm2jRdEH2DHVTlc/FgqD/Z1Q
         q5PA==
In-Reply-To: <20200420221126.341272-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

The try/commit/cancel protocol that memcg uses dates back to when
pages used to be uncharged upon removal from the page cache, and thus
couldn't be committed before the insertion had succeeded. Nowadays,
pages are uncharged when they are physically freed; it doesn't matter
whether the insertion was successful or not. For the page cache, the
transaction dance has become unnecessary.

Introduce a mem_cgroup_charge() function that simply charges a newly
allocated page to a cgroup and sets up page->mem_cgroup in one single
step. If the insertion fails, the caller doesn't have to do anything
but free/put the page.

Then switch the page cache over to this new API.

Subsequent patches will also convert anon pages, but it needs a bit
more prep work. Right now, memcg depends on page->mapping being
already set up at the time of charging, so that it can maintain its
own MEMCG_CACHE and MEMCG_RSS counters. For anon, page->mapping is set
under the same pte lock under which the page is publishd, so a single
charge point that can block doesn't work there just yet.

The following prep patches will replace the private memcg counters
with the generic vmstat counters, thus removing the page->mapping
dependency, then complete the transition to the new single-point
charge API and delete the old transactional scheme.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 include/linux/memcontrol.h | 10 ++++
 mm/filemap.c               | 24 ++++------
 mm/memcontrol.c            | 27 +++++++++++
 mm/shmem.c                 | 97 +++++++++++++++++---------------------
 4 files changed, 89 insertions(+), 69 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c7875a48c8c1..5e8b0e38f145 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -367,6 +367,10 @@ int mem_cgroup_try_charge_delay(struct page *page, struct mm_struct *mm,
 void mem_cgroup_commit_charge(struct page *page, struct mem_cgroup *memcg,
 			      bool lrucare);
 void mem_cgroup_cancel_charge(struct page *page, struct mem_cgroup *memcg);
+
+int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask,
+		      bool lrucare);
+
 void mem_cgroup_uncharge(struct page *page);
 void mem_cgroup_uncharge_list(struct list_head *page_list);
 
@@ -872,6 +876,12 @@ static inline void mem_cgroup_cancel_charge(struct page *page,
 {
 }
 
+static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
+				    gfp_t gfp_mask, bool lrucare)
+{
+	return 0;
+}
+
 static inline void mem_cgroup_uncharge(struct page *page)
 {
 }
diff --git a/mm/filemap.c b/mm/filemap.c
index 5b31af9d5b1b..5bdbda965177 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -832,7 +832,6 @@ static int __add_to_page_cache_locked(struct page *page,
 {
 	XA_STATE(xas, &mapping->i_pages, offset);
 	int huge = PageHuge(page);
-	struct mem_cgroup *memcg;
 	int error;
 	void *old;
 
@@ -840,17 +839,16 @@ static int __add_to_page_cache_locked(struct page *page,
 	VM_BUG_ON_PAGE(PageSwapBacked(page), page);
 	mapping_set_update(&xas, mapping);
 
-	if (!huge) {
-		error = mem_cgroup_try_charge(page, current->mm,
-					      gfp_mask, &memcg);
-		if (error)
-			return error;
-	}
-
 	get_page(page);
 	page->mapping = mapping;
 	page->index = offset;
 
+	if (!huge) {
+		error = mem_cgroup_charge(page, current->mm, gfp_mask, false);
+		if (error)
+			goto error;
+	}
+
 	do {
 		xas_lock_irq(&xas);
 		old = xas_load(&xas);
@@ -874,20 +872,18 @@ static int __add_to_page_cache_locked(struct page *page,
 		xas_unlock_irq(&xas);
 	} while (xas_nomem(&xas, gfp_mask & GFP_RECLAIM_MASK));
 
-	if (xas_error(&xas))
+	if (xas_error(&xas)) {
+		error = xas_error(&xas);
 		goto error;
+	}
 
-	if (!huge)
-		mem_cgroup_commit_charge(page, memcg, false);
 	trace_mm_filemap_add_to_page_cache(page);
 	return 0;
 error:
 	page->mapping = NULL;
 	/* Leave page->index set: truncation relies upon it */
-	if (!huge)
-		mem_cgroup_cancel_charge(page, memcg);
 	put_page(page);
-	return xas_error(&xas);
+	return error;
 }
 ALLOW_ERROR_INJECTION(__add_to_page_cache_locked, ERRNO);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 711d6dd5cbb1..b38c0a672d26 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6577,6 +6577,33 @@ void mem_cgroup_cancel_charge(struct page *page, struct mem_cgroup *memcg)
 	cancel_charge(memcg, nr_pages);
 }
 
+/**
+ * mem_cgroup_charge - charge a newly allocated page to a cgroup
+ * @page: page to charge
+ * @mm: mm context of the victim
+ * @gfp_mask: reclaim mode
+ * @lrucare: page might be on the LRU already
+ *
+ * Try to charge @page to the memcg that @mm belongs to, reclaiming
+ * pages according to @gfp_mask if necessary.
+ *
+ * Returns 0 on success. Otherwise, an error code is returned.
+ */
+int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask,
+		      bool lrucare)
+{
+	struct mem_cgroup *memcg;
+	int ret;
+
+	VM_BUG_ON_PAGE(!page->mapping, page);
+
+	ret = mem_cgroup_try_charge(page, mm, gfp_mask, &memcg);
+	if (ret)
+		return ret;
+	mem_cgroup_commit_charge(page, memcg, lrucare);
+	return 0;
+}
+
 struct uncharge_gather {
 	struct mem_cgroup *memcg;
 	unsigned long pgpgout;
diff --git a/mm/shmem.c b/mm/shmem.c
index 52c66801321e..2384f6c7ef71 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -605,11 +605,13 @@ static inline bool is_huge_enabled(struct shmem_sb_info *sbinfo)
  */
 static int shmem_add_to_page_cache(struct page *page,
 				   struct address_space *mapping,
-				   pgoff_t index, void *expected, gfp_t gfp)
+				   pgoff_t index, void *expected, gfp_t gfp,
+				   struct mm_struct *charge_mm)
 {
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, compound_order(page));
 	unsigned long i = 0;
 	unsigned long nr = compound_nr(page);
+	int error;
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	VM_BUG_ON_PAGE(index != round_down(index, nr), page);
@@ -621,6 +623,16 @@ static int shmem_add_to_page_cache(struct page *page,
 	page->mapping = mapping;
 	page->index = index;
 
+	error = mem_cgroup_charge(page, charge_mm, gfp, PageSwapCache(page));
+	if (error) {
+		if (!PageSwapCache(page) && PageTransHuge(page)) {
+			count_vm_event(THP_FILE_FALLBACK);
+			count_vm_event(THP_FILE_FALLBACK_CHARGE);
+		}
+		goto error;
+	}
+	cgroup_throttle_swaprate(page, gfp);
+
 	do {
 		void *entry;
 		xas_lock_irq(&xas);
@@ -648,12 +660,15 @@ static int shmem_add_to_page_cache(struct page *page,
 	} while (xas_nomem(&xas, gfp));
 
 	if (xas_error(&xas)) {
-		page->mapping = NULL;
-		page_ref_sub(page, nr);
-		return xas_error(&xas);
+		error = xas_error(&xas);
+		goto error;
 	}
 
 	return 0;
+error:
+	page->mapping = NULL;
+	page_ref_sub(page, nr);
+	return error;
 }
 
 /*
@@ -1619,7 +1634,6 @@ static int shmem_swapin_page(struct inode *inode, pgoff_t index,
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct mm_struct *charge_mm = vma ? vma->vm_mm : current->mm;
-	struct mem_cgroup *memcg;
 	struct page *page;
 	swp_entry_t swap;
 	int error;
@@ -1664,29 +1678,22 @@ static int shmem_swapin_page(struct inode *inode, pgoff_t index,
 			goto failed;
 	}
 
-	error = mem_cgroup_try_charge_delay(page, charge_mm, gfp, &memcg);
-	if (!error) {
-		error = shmem_add_to_page_cache(page, mapping, index,
-						swp_to_radix_entry(swap), gfp);
-		/*
-		 * We already confirmed swap under page lock, and make
-		 * no memory allocation here, so usually no possibility
-		 * of error; but free_swap_and_cache() only trylocks a
-		 * page, so it is just possible that the entry has been
-		 * truncated or holepunched since swap was confirmed.
-		 * shmem_undo_range() will have done some of the
-		 * unaccounting, now delete_from_swap_cache() will do
-		 * the rest.
-		 */
-		if (error) {
-			mem_cgroup_cancel_charge(page, memcg);
-			delete_from_swap_cache(page);
-		}
-	}
-	if (error)
+	error = shmem_add_to_page_cache(page, mapping, index,
+					swp_to_radix_entry(swap), gfp,
+					charge_mm);
+	/*
+	 * We already confirmed swap under page lock, and make no
+	 * memory allocation here, so usually no possibility of error;
+	 * but free_swap_and_cache() only trylocks a page, so it is
+	 * just possible that the entry has been truncated or
+	 * holepunched since swap was confirmed.  shmem_undo_range()
+	 * will have done some of the unaccounting, now
+	 * delete_from_swap_cache() will do the rest.
+	 */
+	if (error) {
+		delete_from_swap_cache(page);
 		goto failed;
-
-	mem_cgroup_commit_charge(page, memcg, true);
+	}
 
 	spin_lock_irq(&info->lock);
 	info->swapped--;
@@ -1733,7 +1740,6 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo;
 	struct mm_struct *charge_mm;
-	struct mem_cgroup *memcg;
 	struct page *page;
 	enum sgp_type sgp_huge = sgp;
 	pgoff_t hindex = index;
@@ -1858,21 +1864,11 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 	if (sgp == SGP_WRITE)
 		__SetPageReferenced(page);
 
-	error = mem_cgroup_try_charge_delay(page, charge_mm, gfp, &memcg);
-	if (error) {
-		if (PageTransHuge(page)) {
-			count_vm_event(THP_FILE_FALLBACK);
-			count_vm_event(THP_FILE_FALLBACK_CHARGE);
-		}
-		goto unacct;
-	}
 	error = shmem_add_to_page_cache(page, mapping, hindex,
-					NULL, gfp & GFP_RECLAIM_MASK);
-	if (error) {
-		mem_cgroup_cancel_charge(page, memcg);
+					NULL, gfp & GFP_RECLAIM_MASK,
+					charge_mm);
+	if (error)
 		goto unacct;
-	}
-	mem_cgroup_commit_charge(page, memcg, false);
 	lru_cache_add_anon(page);
 
 	spin_lock_irq(&info->lock);
@@ -2307,7 +2303,6 @@ static int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
 	struct address_space *mapping = inode->i_mapping;
 	gfp_t gfp = mapping_gfp_mask(mapping);
 	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
-	struct mem_cgroup *memcg;
 	spinlock_t *ptl;
 	void *page_kaddr;
 	struct page *page;
@@ -2357,16 +2352,10 @@ static int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
 	if (unlikely(offset >= max_off))
 		goto out_release;
 
-	ret = mem_cgroup_try_charge_delay(page, dst_mm, gfp, &memcg);
-	if (ret)
-		goto out_release;
-
 	ret = shmem_add_to_page_cache(page, mapping, pgoff, NULL,
-						gfp & GFP_RECLAIM_MASK);
+				      gfp & GFP_RECLAIM_MASK, dst_mm);
 	if (ret)
-		goto out_release_uncharge;
-
-	mem_cgroup_commit_charge(page, memcg, false);
+		goto out_release;
 
 	_dst_pte = mk_pte(page, dst_vma->vm_page_prot);
 	if (dst_vma->vm_flags & VM_WRITE)
@@ -2387,11 +2376,11 @@ static int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
 	ret = -EFAULT;
 	max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
 	if (unlikely(offset >= max_off))
-		goto out_release_uncharge_unlock;
+		goto out_release_unlock;
 
 	ret = -EEXIST;
 	if (!pte_none(*dst_pte))
-		goto out_release_uncharge_unlock;
+		goto out_release_unlock;
 
 	lru_cache_add_anon(page);
 
@@ -2412,12 +2401,10 @@ static int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
 	ret = 0;
 out:
 	return ret;
-out_release_uncharge_unlock:
+out_release_unlock:
 	pte_unmap_unlock(dst_pte, ptl);
 	ClearPageDirty(page);
 	delete_from_page_cache(page);
-out_release_uncharge:
-	mem_cgroup_cancel_charge(page, memcg);
 out_release:
 	unlock_page(page);
 	put_page(page);
-- 
2.26.0

