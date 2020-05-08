From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 16/19] mm: memcontrol: charge swapin pages on instantiation
Date: Fri,  8 May 2020 14:31:03 -0400
Message-ID: <20200508183105.225460-17-hannes@cmpxchg.org>
References: <20200508183105.225460-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gEsuCl/jh1GeHgdn0FOVKPNUgKGHCcGpgaHvUQUBVHw=;
        b=jwIJEbNfT/2CL0tzS3TiYOLlNBsdiZqhcBkAT2z2pYTVuCdkSo46gg7XewMb8yiQuP
         ftQK5gtM/sZXuE/XcL94iRwGO6nHM7F6M9Oqj/Qu+IlSEdC1Wgr+lamK77D9m9bHorqy
         ilsPqXGtEuyPwsR/OOW6etaQb2mig9DfovoTHQ0sQS5pAmCmSavQGPgD2n+EFpuUQIWX
         n6YOeAdC41DRw4RXJxu/IXoSdZxob4X+9yMGTh0wXK3Op0zFcsqequmYpSN85dur9nVf
         Z9KATcJmLKDj1ShIVtLXDNVNpSB2gsC6HDM+xGwTomo6F8J2rwI2H57oFUKlt/j8xqZE
         lUfw==
In-Reply-To: <20200508183105.225460-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Right now, users that are otherwise memory controlled can easily
escape their containment and allocate significant amounts of memory
that they're not being charged for. That's because swap readahead
pages are not being charged until somebody actually faults them into
their page table. This can be exploited with MADV_WILLNEED, which
triggers arbitrary readahead allocations without charging the pages.

There are additional problems with the delayed charging of swap pages:

1. To implement refault/workingset detection for anonymous pages, we
   need to have a target LRU available at swapin time, but the LRU is
   not determinable until the page has been charged.

2. To implement per-cgroup LRU locking, we need page->mem_cgroup to be
   stable when the page is isolated from the LRU; otherwise, the locks
   change under us. But swapcache gets charged after it's already on
   the LRU, and even if we cannot isolate it ourselves (since charging
   is not exactly optional).

The previous patch ensured we always maintain cgroup ownership records
for swap pages. This patch moves the swapcache charging point from the
fault handler to swapin time to fix all of the above problems.

v2: simplify swapin error checking (Joonsoo)

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Reviewed-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 mm/memory.c     | 15 ++++++---
 mm/shmem.c      | 14 ++++----
 mm/swap_state.c | 89 ++++++++++++++++++++++++++-----------------------
 mm/swapfile.c   |  6 ----
 4 files changed, 67 insertions(+), 57 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 832ee914cbcf..93900b121b6e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3125,9 +3125,20 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma,
 							vmf->address);
 			if (page) {
+				int err;
+
 				__SetPageLocked(page);
 				__SetPageSwapBacked(page);
 				set_page_private(page, entry.val);
+
+				/* Tell memcg to use swap ownership records */
+				SetPageSwapCache(page);
+				err = mem_cgroup_charge(page, vma->vm_mm,
+							GFP_KERNEL, false);
+				ClearPageSwapCache(page);
+				if (err)
+					goto out_page;
+
 				lru_cache_add_anon(page);
 				swap_readpage(page, true);
 			}
@@ -3189,10 +3200,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		goto out_page;
 	}
 
-	if (mem_cgroup_charge(page, vma->vm_mm, GFP_KERNEL, true)) {
-		ret = VM_FAULT_OOM;
-		goto out_page;
-	}
 	cgroup_throttle_swaprate(page, GFP_KERNEL);
 
 	/*
diff --git a/mm/shmem.c b/mm/shmem.c
index d0306a36f42c..98547dc4642d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -623,13 +623,15 @@ static int shmem_add_to_page_cache(struct page *page,
 	page->mapping = mapping;
 	page->index = index;
 
-	error = mem_cgroup_charge(page, charge_mm, gfp, PageSwapCache(page));
-	if (error) {
-		if (!PageSwapCache(page) && PageTransHuge(page)) {
-			count_vm_event(THP_FILE_FALLBACK);
-			count_vm_event(THP_FILE_FALLBACK_CHARGE);
+	if (!PageSwapCache(page)) {
+		error = mem_cgroup_charge(page, charge_mm, gfp, false);
+		if (error) {
+			if (PageTransHuge(page)) {
+				count_vm_event(THP_FILE_FALLBACK);
+				count_vm_event(THP_FILE_FALLBACK_CHARGE);
+			}
+			goto error;
 		}
-		goto error;
 	}
 	cgroup_throttle_swaprate(page, gfp);
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 558e224138d1..4052c011391d 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -360,12 +360,13 @@ struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 			struct vm_area_struct *vma, unsigned long addr,
 			bool *new_page_allocated)
 {
-	struct page *found_page = NULL, *new_page = NULL;
 	struct swap_info_struct *si;
-	int err;
+	struct page *page;
+
 	*new_page_allocated = false;
 
-	do {
+	for (;;) {
+		int err;
 		/*
 		 * First check the swap cache.  Since this is normally
 		 * called after lookup_swap_cache() failed, re-calling
@@ -373,12 +374,12 @@ struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		 */
 		si = get_swap_device(entry);
 		if (!si)
-			break;
-		found_page = find_get_page(swap_address_space(entry),
-					   swp_offset(entry));
+			return NULL;
+		page = find_get_page(swap_address_space(entry),
+				     swp_offset(entry));
 		put_swap_device(si);
-		if (found_page)
-			break;
+		if (page)
+			return page;
 
 		/*
 		 * Just skip read ahead for unused swap slot.
@@ -389,21 +390,15 @@ struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		 * else swap_off will be aborted if we return NULL.
 		 */
 		if (!__swp_swapcount(entry) && swap_slot_cache_enabled)
-			break;
-
-		/*
-		 * Get a new page to read into from swap.
-		 */
-		if (!new_page) {
-			new_page = alloc_page_vma(gfp_mask, vma, addr);
-			if (!new_page)
-				break;		/* Out of memory */
-		}
+			return NULL;
 
 		/*
 		 * Swap entry may have been freed since our caller observed it.
 		 */
 		err = swapcache_prepare(entry);
+		if (!err)
+			break;
+
 		if (err == -EEXIST) {
 			/*
 			 * We might race against get_swap_page() and stumble
@@ -412,31 +407,43 @@ struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 			 */
 			cond_resched();
 			continue;
-		} else if (err)		/* swp entry is obsolete ? */
-			break;
-
-		/* May fail (-ENOMEM) if XArray node allocation failed. */
-		__SetPageLocked(new_page);
-		__SetPageSwapBacked(new_page);
-		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
-		if (likely(!err)) {
-			/* Initiate read into locked page */
-			SetPageWorkingset(new_page);
-			lru_cache_add_anon(new_page);
-			*new_page_allocated = true;
-			return new_page;
 		}
-		__ClearPageLocked(new_page);
-		/*
-		 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
-		 * clear SWAP_HAS_CACHE flag.
-		 */
-		put_swap_page(new_page, entry);
-	} while (err != -ENOMEM);
 
-	if (new_page)
-		put_page(new_page);
-	return found_page;
+		return NULL;
+	}
+
+	/*
+	 * The swap entry is ours to swap in. Prepare a new page.
+	 */
+
+	page = alloc_page_vma(gfp_mask, vma, addr);
+	if (!page)
+		goto fail_free;
+
+	__SetPageLocked(page);
+	__SetPageSwapBacked(page);
+
+	/* May fail (-ENOMEM) if XArray node allocation failed. */
+	if (add_to_swap_cache(page, entry, gfp_mask & GFP_KERNEL))
+		goto fail_unlock;
+
+	if (mem_cgroup_charge(page, NULL, gfp_mask & GFP_KERNEL, false))
+		goto fail_delete;
+
+	/* Initiate read into locked page */
+	SetPageWorkingset(page);
+	lru_cache_add_anon(page);
+	*new_page_allocated = true;
+	return page;
+
+fail_delete:
+	delete_from_swap_cache(page);
+fail_unlock:
+	unlock_page(page);
+	put_page(page);
+fail_free:
+	swap_free(entry);
+	return NULL;
 }
 
 /*
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8c9b6767013b..3bc7acc68ba8 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1867,11 +1867,6 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 	if (unlikely(!page))
 		return -ENOMEM;
 
-	if (mem_cgroup_charge(page, vma->vm_mm, GFP_KERNEL, true)) {
-		ret = -ENOMEM;
-		goto out_nolock;
-	}
-
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	if (unlikely(!pte_same_as_swp(*pte, swp_entry_to_pte(entry)))) {
 		ret = 0;
@@ -1897,7 +1892,6 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 	activate_page(page);
 out:
 	pte_unmap_unlock(pte, ptl);
-out_nolock:
 	if (page != swapcache) {
 		unlock_page(page);
 		put_page(page);
-- 
2.26.2

