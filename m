From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 1/3] mm: memcontrol: do not kill uncharge batching in
 free_pages_and_swap_cache
Date: Wed, 24 Sep 2014 17:03:22 -0400
Message-ID: <20140924210322.GA11017@cmpxchg.org>
References: <1411571338-8178-1-git-send-email-hannes@cmpxchg.org>
 <1411571338-8178-2-git-send-email-hannes@cmpxchg.org>
 <20140924124234.3fdb59d6cdf7e9c4d6260adb@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140924124234.3fdb59d6cdf7e9c4d6260adb@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Thelen <gthelen@google.com>, Vladimir Davydov <vdavydov@parallels.com>, Dave Hansen <dave@sr71.net>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:42:34PM -0700, Andrew Morton wrote:
> On Wed, 24 Sep 2014 11:08:56 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> > +}
> > +/*
> > + * Batched page_cache_release(). Frees and uncharges all given pages
> > + * for which the reference count drops to 0.
> > + */
> > +void release_pages(struct page **pages, int nr, bool cold)
> > +{
> > +	LIST_HEAD(pages_to_free);
> >  
> > +	while (nr) {
> > +		int batch = min(nr, PAGEVEC_SIZE);
> > +
> > +		release_lru_pages(pages, batch, &pages_to_free);
> > +		pages += batch;
> > +		nr -= batch;
> > +	}
> 
> The use of PAGEVEC_SIZE here is pretty misleading - there are no
> pagevecs in sight.  SWAP_CLUSTER_MAX would be more appropriate.
> 
> 
> 
> afaict the only reason for this loop is to limit the hold duration for
> lru_lock.  And it does a suboptimal job of that because it treats all
> lru_locks as one: if release_lru_pages() were to hold zoneA's lru_lock
> for 8 pages and then were to drop that and hold zoneB's lru_lock for 8
> pages, the logic would then force release_lru_pages() to drop the lock
> and return to release_pages() even though it doesn't need to.
> 
> So I'm thinking it would be better to move the lock-busting logic into
> release_lru_pages() itself.  With a suitable comment, natch ;) Only
> bust the lock in the case where we really did hold a particular lru_lock
> for 16 consecutive pages.  Then s/release_lru_pages/release_pages/ and
> zap the old release_pages().

Yeah, that's better.

> Obviously it's not very important - presumably the common case is that
> the LRU contains lengthy sequences of pages from the same zone.  Maybe.

Even then, the end result is more concise and busts the lock where
it's actually taken, making the whole thing a bit more obvious:

---
From 367f3dcf25141ff6c30400c00ec09cc3c5486f94 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 5 Sep 2014 11:16:17 +0200
Subject: [patch] mm: memcontrol: do not kill uncharge batching in
 free_pages_and_swap_cache

free_pages_and_swap_cache limits release_pages to PAGEVEC_SIZE chunks.
This is not a big deal for the normal release path but it completely
kills memcg uncharge batching which reduces res_counter spin_lock
contention. Dave has noticed this with his page fault scalability test
case on a large machine when the lock was basically dominating on all
CPUs:
    80.18%    80.18%  [kernel]               [k] _raw_spin_lock
                  |
                  --- _raw_spin_lock
                     |
                     |--66.59%-- res_counter_uncharge_until
                     |          res_counter_uncharge
                     |          uncharge_batch
                     |          uncharge_list
                     |          mem_cgroup_uncharge_list
                     |          release_pages
                     |          free_pages_and_swap_cache
                     |          tlb_flush_mmu_free
                     |          |
                     |          |--90.12%-- unmap_single_vma
                     |          |          unmap_vmas
                     |          |          unmap_region
                     |          |          do_munmap
                     |          |          vm_munmap
                     |          |          sys_munmap
                     |          |          system_call_fastpath
                     |          |          __GI___munmap
                     |          |
                     |           --9.88%-- tlb_flush_mmu
                     |                     tlb_finish_mmu
                     |                     unmap_region
                     |                     do_munmap
                     |                     vm_munmap
                     |                     sys_munmap
                     |                     system_call_fastpath
                     |                     __GI___munmap

In his case the load was running in the root memcg and that part
has been handled by reverting 05b843012335 ("mm: memcontrol: use
root_mem_cgroup res_counter") because this is a clear regression,
but the problem remains inside dedicated memcgs.

There is no reason to limit release_pages to PAGEVEC_SIZE batches other
than lru_lock held times. This logic, however, can be moved inside the
function. mem_cgroup_uncharge_list and free_hot_cold_page_list do not
hold any lock for the whole pages_to_free list so it is safe to call
them in a single run.

In release_pages, break the lock at least every SWAP_CLUSTER_MAX (32)
pages, then remove the batching from free_pages_and_swap_cache.

Also update the grossly out-of-date release_pages documentation.

Reported-by: Dave Hansen <dave@sr71.net>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/swap.c       | 31 ++++++++++++++++++++-----------
 mm/swap_state.c | 14 ++++----------
 2 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 6b2dc3897cd5..39affa1932ce 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -887,18 +887,14 @@ void lru_add_drain_all(void)
 	mutex_unlock(&lock);
 }
 
-/*
- * Batched page_cache_release().  Decrement the reference count on all the
- * passed pages.  If it fell to zero then remove the page from the LRU and
- * free it.
- *
- * Avoid taking zone->lru_lock if possible, but if it is taken, retain it
- * for the remainder of the operation.
+/**
+ * release_pages - batched page_cache_release()
+ * @pages: array of pages to release
+ * @nr: number of pages
+ * @cold: whether the pages are cache cold
  *
- * The locking in this function is against shrink_inactive_list(): we recheck
- * the page count inside the lock to see whether shrink_inactive_list()
- * grabbed the page via the LRU.  If it did, give up: shrink_inactive_list()
- * will free it.
+ * Decrement the reference count on all the pages in @pages.  If it
+ * fell to zero, remove the page from the LRU and free it.
  */
 void release_pages(struct page **pages, int nr, bool cold)
 {
@@ -907,6 +903,7 @@ void release_pages(struct page **pages, int nr, bool cold)
 	struct zone *zone = NULL;
 	struct lruvec *lruvec;
 	unsigned long uninitialized_var(flags);
+	unsigned int uninitialized_var(lock_batch);
 
 	for (i = 0; i < nr; i++) {
 		struct page *page = pages[i];
@@ -914,6 +911,7 @@ void release_pages(struct page **pages, int nr, bool cold)
 		if (unlikely(PageCompound(page))) {
 			if (zone) {
 				spin_unlock_irqrestore(&zone->lru_lock, flags);
+				lock_batch = 0;
 				zone = NULL;
 			}
 			put_compound_page(page);
@@ -930,6 +928,7 @@ void release_pages(struct page **pages, int nr, bool cold)
 				if (zone)
 					spin_unlock_irqrestore(&zone->lru_lock,
 									flags);
+				lock_batch = 0;
 				zone = pagezone;
 				spin_lock_irqsave(&zone->lru_lock, flags);
 			}
@@ -938,6 +937,16 @@ void release_pages(struct page **pages, int nr, bool cold)
 			VM_BUG_ON_PAGE(!PageLRU(page), page);
 			__ClearPageLRU(page);
 			del_page_from_lru_list(page, lruvec, page_off_lru(page));
+
+			/*
+			 * Make sure the IRQ-safe lock-holding time
+			 * does not get excessive with a continuous
+			 * string of pages from the same zone.
+			 */
+			if (++lock_batch == SWAP_CLUSTER_MAX) {
+				spin_unlock_irqrestore(&zone->lru_lock, flags);
+				zone = NULL;
+			}
 		}
 
 		/* Clear Active bit in case of parallel mark_page_accessed */
diff --git a/mm/swap_state.c b/mm/swap_state.c
index ef1f39139b71..154444918685 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -265,18 +265,12 @@ void free_page_and_swap_cache(struct page *page)
 void free_pages_and_swap_cache(struct page **pages, int nr)
 {
 	struct page **pagep = pages;
+	int i;
 
 	lru_add_drain();
-	while (nr) {
-		int todo = min(nr, PAGEVEC_SIZE);
-		int i;
-
-		for (i = 0; i < todo; i++)
-			free_swap_cache(pagep[i]);
-		release_pages(pagep, todo, false);
-		pagep += todo;
-		nr -= todo;
-	}
+	for (i = 0; i < nr; i++)
+		free_swap_cache(pagep[i]);
+	release_pages(pagep, nr, false);
 }
 
 /*
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
