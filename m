From: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH stable 4.9] mm: memcontrol: fix NULL pointer crash in test_clear_page_writeback()
Date: Tue,  9 Feb 2021 12:26:15 -0800
Message-ID: <20210209202616.2257512-1-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2BWQkMPpxa9x04z6Kv/kh2y8uZYYBnvMqfwKV/uPs1Q=;
        b=cFA8RWjoqk7kkQ02pGbF4qLdtij5PbiMSKE4eM5V9hsvjyi0brdSTqJGBf+lNQ92UE
         BFEDL7Vhe36DdcsaMeawpTtN+1P1Qa9xck72PSmKv8MOMglClobCgYrnSDxSZw5mNxae
         pq+JkZvPjOf0nb7k67wVRO9Ib6I95pKAMsnGFWEewqcVU70eaaRD+aDNT5HVlhFBA4+X
         s0wb8jrnHXOKPemrFzOXCFJtfdM3eZrBgIwOl/Cr8DDKNxDkZFTgrmyjVaNg/SUwxFw8
         KPsTcvEsAW3WOm+XTi6fwJYzIN1IPl00dXcjnledRIxbPWT35+97pUmQYMDI/9fvrvJI
         rJwQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bradley Bolen <bradleybolen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Prakash Gupta <guptap-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE
        CONTROLLER MEMCG" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE
        CONTROLLER MEMCG" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

commit 739f79fc9db1b38f96b5a5109b247a650fbebf6d upstream

Jaegeuk and Brad report a NULL pointer crash when writeback ending tries
to update the memcg stats:

    BUG: unable to handle kernel NULL pointer dereference at 00000000000003b0
    IP: test_clear_page_writeback+0x12e/0x2c0
    [...]
    RIP: 0010:test_clear_page_writeback+0x12e/0x2c0
    Call Trace:
     <IRQ>
     end_page_writeback+0x47/0x70
     f2fs_write_end_io+0x76/0x180 [f2fs]
     bio_endio+0x9f/0x120
     blk_update_request+0xa8/0x2f0
     scsi_end_request+0x39/0x1d0
     scsi_io_completion+0x211/0x690
     scsi_finish_command+0xd9/0x120
     scsi_softirq_done+0x127/0x150
     __blk_mq_complete_request_remote+0x13/0x20
     flush_smp_call_function_queue+0x56/0x110
     generic_smp_call_function_single_interrupt+0x13/0x30
     smp_call_function_single_interrupt+0x27/0x40
     call_function_single_interrupt+0x89/0x90
    RIP: 0010:native_safe_halt+0x6/0x10

    (gdb) l *(test_clear_page_writeback+0x12e)
    0xffffffff811bae3e is in test_clear_page_writeback (./include/linux/memcontrol.h:619).
    614		mod_node_page_state(page_pgdat(page), idx, val);
    615		if (mem_cgroup_disabled() || !page->mem_cgroup)
    616			return;
    617		mod_memcg_state(page->mem_cgroup, idx, val);
    618		pn = page->mem_cgroup->nodeinfo[page_to_nid(page)];
    619		this_cpu_add(pn->lruvec_stat->count[idx], val);
    620	}
    621
    622	unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
    623							gfp_t gfp_mask,

The issue is that writeback doesn't hold a page reference and the page
might get freed after PG_writeback is cleared (and the mapping is
unlocked) in test_clear_page_writeback().  The stat functions looking up
the page's node or zone are safe, as those attributes are static across
allocation and free cycles.  But page->mem_cgroup is not, and it will
get cleared if we race with truncation or migration.

It appears this race window has been around for a while, but less likely
to trigger when the memcg stats were updated first thing after
PG_writeback is cleared.  Recent changes reshuffled this code to update
the global node stats before the memcg ones, though, stretching the race
window out to an extent where people can reproduce the problem.

Update test_clear_page_writeback() to look up and pin page->mem_cgroup
before clearing PG_writeback, then not use that pointer afterward.  It
is a partial revert of 62cccb8c8e7a ("mm: simplify lock_page_memcg()")
but leaves the pageref-holding callsites that aren't affected alone.

Link: http://lkml.kernel.org/r/20170809183825.GA26387-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Fixes: 62cccb8c8e7a ("mm: simplify lock_page_memcg()")
Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Reported-by: Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Tested-by: Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Bradley Bolen <bradleybolen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Tested-by: Brad Bolen <bradleybolen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>	[4.6+]
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Signed-off-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
[guptap-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org: Resolved merge conflicts]
Signed-off-by: Prakash Gupta <guptap-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Signed-off-by: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
This patch is present in a downstream Android tree:

https://source.mcwhirter.io/craige/bluecross/commit/d4a742865c6b69ef931694745ef54965d7c9966c

and I happened to have stumbled across the same problem too.

Johannes can you review it for correctness with respect to the 4.9
kernel? Thanks!

 include/linux/memcontrol.h | 33 ++++++++++++++++++++++++-----
 mm/memcontrol.c            | 43 +++++++++++++++++++++++++++-----------
 mm/page-writeback.c        | 14 ++++++++++---
 3 files changed, 70 insertions(+), 20 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8b35bdbdc214..fd77f8303ab9 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -490,9 +490,21 @@ bool mem_cgroup_oom_synchronize(bool wait);
 extern int do_swap_account;
 #endif
 
-void lock_page_memcg(struct page *page);
+struct mem_cgroup *lock_page_memcg(struct page *page);
+void __unlock_page_memcg(struct mem_cgroup *memcg);
 void unlock_page_memcg(struct page *page);
 
+static inline void __mem_cgroup_update_page_stat(struct page *page,
+						 struct mem_cgroup *memcg,
+						 enum mem_cgroup_stat_index idx,
+						 int val)
+{
+	VM_BUG_ON(!(rcu_read_lock_held() || PageLocked(page)));
+
+	if (memcg && memcg->stat)
+		this_cpu_add(memcg->stat->count[idx], val);
+}
+
 /**
  * mem_cgroup_update_page_stat - update page state statistics
  * @page: the page
@@ -508,13 +520,12 @@ void unlock_page_memcg(struct page *page);
  *     mem_cgroup_update_page_stat(page, state, -1);
  *   unlock_page(page) or unlock_page_memcg(page)
  */
+
 static inline void mem_cgroup_update_page_stat(struct page *page,
 				 enum mem_cgroup_stat_index idx, int val)
 {
-	VM_BUG_ON(!(rcu_read_lock_held() || PageLocked(page)));
 
-	if (page->mem_cgroup)
-		this_cpu_add(page->mem_cgroup->stat->count[idx], val);
+	__mem_cgroup_update_page_stat(page, page->mem_cgroup, idx, val);
 }
 
 static inline void mem_cgroup_inc_page_stat(struct page *page,
@@ -709,7 +720,12 @@ mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 {
 }
 
-static inline void lock_page_memcg(struct page *page)
+static inline struct mem_cgroup *lock_page_memcg(struct page *page)
+{
+	return NULL;
+}
+
+static inline void __unlock_page_memcg(struct mem_cgroup *memcg)
 {
 }
 
@@ -745,6 +761,13 @@ static inline void mem_cgroup_update_page_stat(struct page *page,
 {
 }
 
+static inline void __mem_cgroup_update_page_stat(struct page *page,
+						 struct mem_cgroup *memcg,
+						 enum mem_cgroup_stat_index idx,
+						 int nr)
+{
+}
+
 static inline void mem_cgroup_inc_page_stat(struct page *page,
 					    enum mem_cgroup_stat_index idx)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d4232744c59f..27b0b4f03fcd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1638,9 +1638,13 @@ bool mem_cgroup_oom_synchronize(bool handle)
  * @page: the page
  *
  * This function protects unlocked LRU pages from being moved to
- * another cgroup and stabilizes their page->mem_cgroup binding.
+ * another cgroup.
+ *
+ * It ensures lifetime of the returned memcg. Caller is responsible
+ * for the lifetime of the page; __unlock_page_memcg() is available
+ * when @page might get freed inside the locked section.
  */
-void lock_page_memcg(struct page *page)
+struct mem_cgroup *lock_page_memcg(struct page *page)
 {
 	struct mem_cgroup *memcg;
 	unsigned long flags;
@@ -1649,18 +1653,24 @@ void lock_page_memcg(struct page *page)
 	 * The RCU lock is held throughout the transaction.  The fast
 	 * path can get away without acquiring the memcg->move_lock
 	 * because page moving starts with an RCU grace period.
-	 */
+	 *
+	 * The RCU lock also protects the memcg from being freed when
+	 * the page state that is going to change is the only thing
+	 * preventing the page itself from being freed. E.g. writeback
+	 * doesn't hold a page reference and relies on PG_writeback to
+	 * keep off truncation, migration and so forth.
+         */
 	rcu_read_lock();
 
 	if (mem_cgroup_disabled())
-		return;
+		return NULL;
 again:
 	memcg = page->mem_cgroup;
 	if (unlikely(!memcg))
-		return;
+		return NULL;
 
 	if (atomic_read(&memcg->moving_account) <= 0)
-		return;
+		return memcg;
 
 	spin_lock_irqsave(&memcg->move_lock, flags);
 	if (memcg != page->mem_cgroup) {
@@ -1676,18 +1686,18 @@ void lock_page_memcg(struct page *page)
 	memcg->move_lock_task = current;
 	memcg->move_lock_flags = flags;
 
-	return;
+	return memcg;
 }
 EXPORT_SYMBOL(lock_page_memcg);
 
 /**
- * unlock_page_memcg - unlock a page->mem_cgroup binding
- * @page: the page
+ * __unlock_page_memcg - unlock and unpin a memcg
+ * @memcg: the memcg
+ *
+ * Unlock and unpin a memcg returned by lock_page_memcg().
  */
-void unlock_page_memcg(struct page *page)
+void __unlock_page_memcg(struct mem_cgroup *memcg)
 {
-	struct mem_cgroup *memcg = page->mem_cgroup;
-
 	if (memcg && memcg->move_lock_task == current) {
 		unsigned long flags = memcg->move_lock_flags;
 
@@ -1699,6 +1709,15 @@ void unlock_page_memcg(struct page *page)
 
 	rcu_read_unlock();
 }
+
+/**
+ * unlock_page_memcg - unlock a page->mem_cgroup binding
+ * @page: the page
+ */
+void unlock_page_memcg(struct page *page)
+{
+	__unlock_page_memcg(page->mem_cgroup);
+}
 EXPORT_SYMBOL(unlock_page_memcg);
 
 /*
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 462c778b9fb5..498c924f2fcd 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2717,9 +2717,10 @@ EXPORT_SYMBOL(clear_page_dirty_for_io);
 int test_clear_page_writeback(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
+	struct mem_cgroup *memcg;
 	int ret;
 
-	lock_page_memcg(page);
+	memcg = lock_page_memcg(page);
 	if (mapping && mapping_use_writeback_tags(mapping)) {
 		struct inode *inode = mapping->host;
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
@@ -2747,13 +2748,20 @@ int test_clear_page_writeback(struct page *page)
 	} else {
 		ret = TestClearPageWriteback(page);
 	}
+	/*
+	 * NOTE: Page might be free now! Writeback doesn't hold a page
+	 * reference on its own, it relies on truncation to wait for
+	 * the clearing of PG_writeback. The below can only access
+	 * page state that is static across allocation cycles.
+	 */
 	if (ret) {
-		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
+		__mem_cgroup_update_page_stat(page, memcg,
+					      MEM_CGROUP_STAT_WRITEBACK, -1);
 		dec_node_page_state(page, NR_WRITEBACK);
 		dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 		inc_node_page_state(page, NR_WRITTEN);
 	}
-	unlock_page_memcg(page);
+	__unlock_page_memcg(memcg);
 	return ret;
 }
 
-- 
2.25.1

