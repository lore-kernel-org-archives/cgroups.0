From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH v2] mm: page-writeback: simplify memcg handling in
 test_clear_page_writeback()
Date: Wed, 10 Feb 2021 12:44:00 -0500
Message-ID: <YCQbYAWg4nvBFL6h@cmpxchg.org>
References: <20210209214543.112655-1-hannes@cmpxchg.org>
 <alpine.LSU.2.11.2102092058290.7553@eggly.anvils>
 <alpine.LSU.2.11.2102100813050.8131@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kp9VxT0l5e82WMvJl6zKhHzYkWyThl8sjsI4PSbhtao=;
        b=NezJ9F3TumQ53/0CPMMBZdB31STBNhPUEmIpyE4NjCvRpro+HwGZLTRB2C4BpSzpix
         EwSeSW16t65QQQl8cADKiETGXxdLj863Yu3Y7WMpyNBDklUSkk3pBalmy/MJ+DGjZQd2
         1y9Ots+z6plRZIUv6MfmjigLSIYa79h/okguhGm1o5gYEGNHzXFDpxC4YYiMvOWFD0hA
         f8c9mh7eul8RS9GIhSULqREuZRWsfXu6B42QEyAVxXSVgkmeFsQhvAaWzRJXEIDX0MJp
         Sz/qZW/eIMDEIzmpfDRYVWV/F2ZGey5Bjtf/JZudlAjo/adPmfxtKDEbks/v2b2m16bf
         t9nQ==
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2102100813050.8131-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Feb 10, 2021 at 08:22:00AM -0800, Hugh Dickins wrote:
> On Tue, 9 Feb 2021, Hugh Dickins wrote:
> > On Tue, 9 Feb 2021, Johannes Weiner wrote:
> > 
> > > Page writeback doesn't hold a page reference, which allows truncate to
> > > free a page the second PageWriteback is cleared. This used to require
> > > special attention in test_clear_page_writeback(), where we had to be
> > > careful not to rely on the unstable page->memcg binding and look up
> > > all the necessary information before clearing the writeback flag.
> > > 
> > > Since commit 073861ed77b6 ("mm: fix VM_BUG_ON(PageTail) and
> > > BUG_ON(PageWriteback)") test_clear_page_writeback() is called with an
> > > explicit reference on the page, and this dance is no longer needed.
> > > 
> > > Use unlock_page_memcg() and dec_lruvec_page_stat() directly.
> > 
> > s/stat()/state()/
> > 
> > This is a nice cleanup: I hadn't seen that connection at all.
> > 
> > But I think you should take it further:
> > __unlock_page_memcg() can then be static in mm/memcontrol.c,
> > and its declarations deleted from include/linux/memcontrol.h?
> 
> And further: void lock_page_memcg(page), not returning memcg.

You're right on all counts!

> > And further: delete __dec_lruvec_state() and dec_lruvec_state()
> > from include/linux/vmstat.h - unless you feel that every "inc"
> > ought to be matched by a "dec", even when unused.

Hey look, there isn't a user for the __inc, either :) There is one for
inc, but I don't insist on having symmetry there.

> > > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > 
> > Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Thanks for the review and good feedback.

How about this v2?

---

From 5bcc0f468460aa2670c40318bb657e8b08ef96d5 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Date: Tue, 9 Feb 2021 16:22:42 -0500
Subject: [PATCH] mm: page-writeback: simplify memcg handling in
 test_clear_page_writeback()

Page writeback doesn't hold a page reference, which allows truncate to
free a page the second PageWriteback is cleared. This used to require
special attention in test_clear_page_writeback(), where we had to be
careful not to rely on the unstable page->memcg binding and look up
all the necessary information before clearing the writeback flag.

Since commit 073861ed77b6 ("mm: fix VM_BUG_ON(PageTail) and
BUG_ON(PageWriteback)") test_clear_page_writeback() is called with an
explicit reference on the page, and this dance is no longer needed.

Use unlock_page_memcg() and dec_lruvec_page_state() directly.

This removes the last user of the lock_page_memcg() return value,
change it to void. Touch up the comments in there as well. This also
removes the last extern user of __unlock_page_memcg(), make it
static. Further, it removes the last user of dec_lruvec_state(),
delete it, along with a few other unused helpers.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h | 10 ++--------
 include/linux/vmstat.h     | 24 +++---------------------
 mm/memcontrol.c            | 36 +++++++++++-------------------------
 mm/page-writeback.c        |  9 +++------
 4 files changed, 19 insertions(+), 60 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a44b2d51aecc..b17053af3287 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -874,8 +874,7 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 extern bool cgroup_memory_noswap;
 #endif
 
-struct mem_cgroup *lock_page_memcg(struct page *page);
-void __unlock_page_memcg(struct mem_cgroup *memcg);
+void lock_page_memcg(struct page *page);
 void unlock_page_memcg(struct page *page);
 
 void __mod_memcg_state(struct mem_cgroup *memcg, int idx, int val);
@@ -1269,12 +1268,7 @@ mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
 {
 }
 
-static inline struct mem_cgroup *lock_page_memcg(struct page *page)
-{
-	return NULL;
-}
-
-static inline void __unlock_page_memcg(struct mem_cgroup *memcg)
+static inline void lock_page_memcg(struct page *page)
 {
 }
 
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 506d625163a1..3299cd69e4ca 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -512,16 +512,10 @@ static inline void mod_lruvec_page_state(struct page *page,
 
 #endif /* CONFIG_MEMCG */
 
-static inline void __inc_lruvec_state(struct lruvec *lruvec,
-				      enum node_stat_item idx)
-{
-	__mod_lruvec_state(lruvec, idx, 1);
-}
-
-static inline void __dec_lruvec_state(struct lruvec *lruvec,
-				      enum node_stat_item idx)
+static inline void inc_lruvec_state(struct lruvec *lruvec,
+				    enum node_stat_item idx)
 {
-	__mod_lruvec_state(lruvec, idx, -1);
+	mod_lruvec_state(lruvec, idx, 1);
 }
 
 static inline void __inc_lruvec_page_state(struct page *page,
@@ -536,18 +530,6 @@ static inline void __dec_lruvec_page_state(struct page *page,
 	__mod_lruvec_page_state(page, idx, -1);
 }
 
-static inline void inc_lruvec_state(struct lruvec *lruvec,
-				    enum node_stat_item idx)
-{
-	mod_lruvec_state(lruvec, idx, 1);
-}
-
-static inline void dec_lruvec_state(struct lruvec *lruvec,
-				    enum node_stat_item idx)
-{
-	mod_lruvec_state(lruvec, idx, -1);
-}
-
 static inline void inc_lruvec_page_state(struct page *page,
 					 enum node_stat_item idx)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9e455815fb7a..e29d3d64c27e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2124,11 +2124,10 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
  * This function protects unlocked LRU pages from being moved to
  * another cgroup.
  *
- * It ensures lifetime of the returned memcg. Caller is responsible
- * for the lifetime of the page; __unlock_page_memcg() is available
- * when @page might get freed inside the locked section.
+ * It ensures lifetime of the locked memcg. Caller is responsible
+ * for the lifetime of the page.
  */
-struct mem_cgroup *lock_page_memcg(struct page *page)
+void lock_page_memcg(struct page *page)
 {
 	struct page *head = compound_head(page); /* rmap on tail pages */
 	struct mem_cgroup *memcg;
@@ -2138,21 +2137,15 @@ struct mem_cgroup *lock_page_memcg(struct page *page)
 	 * The RCU lock is held throughout the transaction.  The fast
 	 * path can get away without acquiring the memcg->move_lock
 	 * because page moving starts with an RCU grace period.
-	 *
-	 * The RCU lock also protects the memcg from being freed when
-	 * the page state that is going to change is the only thing
-	 * preventing the page itself from being freed. E.g. writeback
-	 * doesn't hold a page reference and relies on PG_writeback to
-	 * keep off truncation, migration and so forth.
          */
 	rcu_read_lock();
 
 	if (mem_cgroup_disabled())
-		return NULL;
+		return;
 again:
 	memcg = page_memcg(head);
 	if (unlikely(!memcg))
-		return NULL;
+		return;
 
 #ifdef CONFIG_PROVE_LOCKING
 	local_irq_save(flags);
@@ -2161,7 +2154,7 @@ struct mem_cgroup *lock_page_memcg(struct page *page)
 #endif
 
 	if (atomic_read(&memcg->moving_account) <= 0)
-		return memcg;
+		return;
 
 	spin_lock_irqsave(&memcg->move_lock, flags);
 	if (memcg != page_memcg(head)) {
@@ -2170,24 +2163,17 @@ struct mem_cgroup *lock_page_memcg(struct page *page)
 	}
 
 	/*
-	 * When charge migration first begins, we can have locked and
-	 * unlocked page stat updates happening concurrently.  Track
-	 * the task who has the lock for unlock_page_memcg().
+	 * When charge migration first begins, we can have multiple
+	 * critical sections holding the fast-path RCU lock and one
+	 * holding the slowpath move_lock. Track the task who has the
+	 * move_lock for unlock_page_memcg().
 	 */
 	memcg->move_lock_task = current;
 	memcg->move_lock_flags = flags;
-
-	return memcg;
 }
 EXPORT_SYMBOL(lock_page_memcg);
 
-/**
- * __unlock_page_memcg - unlock and unpin a memcg
- * @memcg: the memcg
- *
- * Unlock and unpin a memcg returned by lock_page_memcg().
- */
-void __unlock_page_memcg(struct mem_cgroup *memcg)
+static void __unlock_page_memcg(struct mem_cgroup *memcg)
 {
 	if (memcg && memcg->move_lock_task == current) {
 		unsigned long flags = memcg->move_lock_flags;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index eb34d204d4ee..f6c2c3165d4d 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2722,12 +2722,9 @@ EXPORT_SYMBOL(clear_page_dirty_for_io);
 int test_clear_page_writeback(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
-	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
 	int ret;
 
-	memcg = lock_page_memcg(page);
-	lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
+	lock_page_memcg(page);
 	if (mapping && mapping_use_writeback_tags(mapping)) {
 		struct inode *inode = mapping->host;
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
@@ -2755,11 +2752,11 @@ int test_clear_page_writeback(struct page *page)
 		ret = TestClearPageWriteback(page);
 	}
 	if (ret) {
-		dec_lruvec_state(lruvec, NR_WRITEBACK);
+		dec_lruvec_page_state(page, NR_WRITEBACK);
 		dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 		inc_node_page_state(page, NR_WRITTEN);
 	}
-	__unlock_page_memcg(memcg);
+	unlock_page_memcg(page);
 	return ret;
 }
 
-- 
2.30.0

