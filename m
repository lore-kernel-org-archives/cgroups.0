From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH -mm -v10 1/3] mm, THP, swap: Delay splitting THP during
 swap out
Date: Tue, 2 May 2017 08:53:32 +0900
Message-ID: <20170501235332.GA4411@bbox>
References: <20170425125658.28684-1-ying.huang@intel.com>
 <20170425125658.28684-2-ying.huang@intel.com>
 <20170427053141.GA1925@bbox>
 <87mvb21fz1.fsf@yhuang-dev.intel.com>
 <20170428084044.GB19510@bbox>
 <20170501104430.GA16306@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170501104430.GA16306@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huang, Ying" <ying.huang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>, Ebru Akagunduz <ebru.akagunduz@gmail.com>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Shaohua Li <shli@kernel.org>, Rik van Riel <riel@redhat.com>, cgroups@vger.kernel.org

Hi Johannes,

The patch I sent has two clean-up.

First part was as follows:

From 5400dceb3a7739d4e7ff340fc0831e0e1830ec0b Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Fri, 28 Apr 2017 15:04:14 +0900
Subject: [PATCH 1/2] swap: make swapcache_free aware of page size

Now, get_swap_page takes struct page and allocates swap space according
to page size(ie, normal or THP) so it would be more clear to take
struct page in swapcache_free which is a counter function of
get_swap_page without needing if-else statement of caller side.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/swap.h |  4 ++--
 mm/shmem.c           |  2 +-
 mm/swap_state.c      | 13 +++----------
 mm/swapfile.c        | 12 ++++++++++--
 mm/vmscan.c          |  2 +-
 5 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index b60fea3748f8..16c8d2392ddd 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -400,7 +400,7 @@ extern void swap_shmem_alloc(swp_entry_t);
 extern int swap_duplicate(swp_entry_t);
 extern int swapcache_prepare(swp_entry_t);
 extern void swap_free(swp_entry_t);
-extern void swapcache_free(swp_entry_t);
+extern void swapcache_free(struct page *page, swp_entry_t);
 extern void swapcache_free_entries(swp_entry_t *entries, int n);
 extern int free_swap_and_cache(swp_entry_t);
 extern int swap_type_of(dev_t, sector_t, struct block_device **);
@@ -459,7 +459,7 @@ static inline void swap_free(swp_entry_t swp)
 {
 }
 
-static inline void swapcache_free(swp_entry_t swp)
+static inline void swapcache_free(struct page *page, swp_entry_t swp)
 {
 }
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 29948d7da172..ab1802664e97 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1326,7 +1326,7 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 
 	mutex_unlock(&shmem_swaplist_mutex);
 free_swap:
-	swapcache_free(swap);
+	swapcache_free(page, swap);
 redirty:
 	set_page_dirty(page);
 	if (wbc->for_reclaim)
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 16ff89d058f4..4af44fd4142e 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -231,10 +231,7 @@ int add_to_swap(struct page *page, struct list_head *list)
 	return 1;
 
 fail_free:
-	if (PageTransHuge(page))
-		swapcache_free_cluster(entry);
-	else
-		swapcache_free(entry);
+	swapcache_free(page, entry);
 fail:
 	if (PageTransHuge(page) && !split_huge_page_to_list(page, list))
 		goto retry;
@@ -259,11 +256,7 @@ void delete_from_swap_cache(struct page *page)
 	__delete_from_swap_cache(page);
 	spin_unlock_irq(&address_space->tree_lock);
 
-	if (PageTransHuge(page))
-		swapcache_free_cluster(entry);
-	else
-		swapcache_free(entry);
-
+	swapcache_free(page, entry);
 	page_ref_sub(page, hpage_nr_pages(page));
 }
 
@@ -415,7 +408,7 @@ struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
 		 * clear SWAP_HAS_CACHE flag.
 		 */
-		swapcache_free(entry);
+		swapcache_free(new_page, entry);
 	} while (err != -ENOMEM);
 
 	if (new_page)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 596306272059..9496cc3e955a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1144,7 +1144,7 @@ void swap_free(swp_entry_t entry)
 /*
  * Called after dropping swapcache to decrease refcnt to swap entries.
  */
-void swapcache_free(swp_entry_t entry)
+void __swapcache_free(swp_entry_t entry)
 {
 	struct swap_info_struct *p;
 
@@ -1156,7 +1156,7 @@ void swapcache_free(swp_entry_t entry)
 }
 
 #ifdef CONFIG_THP_SWAP
-void swapcache_free_cluster(swp_entry_t entry)
+void __swapcache_free_cluster(swp_entry_t entry)
 {
 	unsigned long offset = swp_offset(entry);
 	unsigned long idx = offset / SWAPFILE_CLUSTER;
@@ -1182,6 +1182,14 @@ void swapcache_free_cluster(swp_entry_t entry)
 }
 #endif /* CONFIG_THP_SWAP */
 
+void swapcache_free(struct page *page, swp_entry_t entry)
+{
+	if (!PageTransHuge(page))
+		__swapcache_free(entry);
+	else
+		__swapcache_free_cluster(entry);
+}
+
 static int swp_entry_cmp(const void *ent1, const void *ent2)
 {
 	const swp_entry_t *e1 = ent1, *e2 = ent2;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5ebf468c5429..0f8ca3d1761d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -708,7 +708,7 @@ static int __remove_mapping(struct address_space *mapping, struct page *page,
 		mem_cgroup_swapout(page, swap);
 		__delete_from_swap_cache(page);
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
-		swapcache_free(swap);
+		swapcache_free(page, swap);
 	} else {
 		void (*freepage)(struct page *);
 		void *shadow = NULL;
-- 
2.7.4


On Mon, May 01, 2017 at 12:44:30PM +0200, Johannes Weiner wrote:
> On Fri, Apr 28, 2017 at 05:40:44PM +0900, Minchan Kim wrote:
> > However, get_swap_page is ugly now. The caller should take care of
> > failure and should retry after split. I hope get_swap_page includes
> > split and retry logic in itself without reling on the caller.
> 
> I think this makes the interface terrible. It's an allocation function
> to which you pass a reference object for size - and if the allocation
> doesn't succeed it'll split your reference object to make it fit?
> 
> That's a nasty side effect for this function to have.

It does make sense to me.

With that point of view, retry logic in add_to_swap is awkward to me, too.
The add_to_swap is a kind of allocate function(swap slot and swap cache)
so I think it would be better to move retry logic to vmscan.c.

What do you think about it?

From e228d67e9677f8eeea1e424cab61b67884d534b4 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Tue, 2 May 2017 08:30:41 +0900
Subject: [PATCH 2/2] swap: move anonymous THP split logic to vmscan

The add_to_swap aims to allocate swap_space(ie, swap slot and
swapcache) so if it fails due to lack of space in case of THP,
the caller should split the THP page and retry it with a page.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/swap.h |  4 ++--
 mm/swap_state.c      | 23 ++++++-----------------
 mm/vmscan.c          | 22 +++++++++++++++++++++-
 3 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 16c8d2392ddd..a305d27b12f8 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -359,7 +359,7 @@ extern struct address_space *swapper_spaces[];
 		>> SWAP_ADDRESS_SPACE_SHIFT])
 extern unsigned long total_swapcache_pages(void);
 extern void show_swap_cache_info(void);
-extern int add_to_swap(struct page *, struct list_head *list);
+extern int add_to_swap(struct page *);
 extern int add_to_swap_cache(struct page *, swp_entry_t, gfp_t);
 extern int __add_to_swap_cache(struct page *page, swp_entry_t entry);
 extern void __delete_from_swap_cache(struct page *);
@@ -479,7 +479,7 @@ static inline struct page *lookup_swap_cache(swp_entry_t swp)
 	return NULL;
 }
 
-static inline int add_to_swap(struct page *page, struct list_head *list)
+static inline int add_to_swap(struct page *page)
 {
 	return 0;
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 4af44fd4142e..1b6ef1660b7e 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -184,7 +184,7 @@ void __delete_from_swap_cache(struct page *page)
  * Allocate swap space for the page and add the page to the
  * swap cache.  Caller needs to hold the page lock. 
  */
-int add_to_swap(struct page *page, struct list_head *list)
+int add_to_swap(struct page *page)
 {
 	swp_entry_t entry;
 	int err;
@@ -192,12 +192,12 @@ int add_to_swap(struct page *page, struct list_head *list)
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageUptodate(page), page);
 
-retry:
 	entry = get_swap_page(page);
 	if (!entry.val)
-		goto fail;
+		return 0;
+
 	if (mem_cgroup_try_charge_swap(page, entry))
-		goto fail_free;
+		goto fail;
 
 	/*
 	 * Radix-tree node allocations from PF_MEMALLOC contexts could
@@ -218,23 +218,12 @@ int add_to_swap(struct page *page, struct list_head *list)
 		 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
 		 * clear SWAP_HAS_CACHE flag.
 		 */
-		goto fail_free;
-
-	if (PageTransHuge(page)) {
-		err = split_huge_page_to_list(page, list);
-		if (err) {
-			delete_from_swap_cache(page);
-			return 0;
-		}
-	}
+		goto fail;
 
 	return 1;
 
-fail_free:
-	swapcache_free(page, entry);
 fail:
-	if (PageTransHuge(page) && !split_huge_page_to_list(page, list))
-		goto retry;
+	swapcache_free(page, entry);
 	return 0;
 }
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0f8ca3d1761d..2314aca47d12 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1125,8 +1125,28 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		    !PageSwapCache(page)) {
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
-			if (!add_to_swap(page, page_list))
+swap_retry:
+			/*
+			 * Retry after split if we fail to allocate
+			 * swap space of a THP.
+			 */
+			if (!add_to_swap(page)) {
+				if (!PageTransHuge(page) ||
+				    split_huge_page_to_list(page, page_list))
+					goto activate_locked;
+				goto swap_retry;
+			}
+
+			/*
+			 * Got swap space successfully. But unfortunately,
+			 * we don't support a THP page writeout so split it.
+			 */
+			if (PageTransHuge(page) &&
+				  split_huge_page_to_list(page, page_list)) {
+				delete_from_swap_cache(page);
 				goto activate_locked;
+			}
+
 			may_enter_fs = 1;
 
 			/* Adding to swap updated mapping */
-- 
2.7.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
