From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH for 3.2.34] memcg: do not trigger OOM from
 add_to_page_cache_locked
Date: Tue, 5 Feb 2013 17:09:34 +0100
Message-ID: <20130205160934.GB22804@dhcp22.suse.cz>
References: <20121218152223.6912832C@pobox.sk>
 <20121218152004.GA25208@dhcp22.suse.cz>
 <20121224142526.020165D3@pobox.sk>
 <20121228162209.GA1455@dhcp22.suse.cz>
 <20121230020947.AA002F34@pobox.sk>
 <20121230110815.GA12940@dhcp22.suse.cz>
 <20130125160723.FAE73567@pobox.sk>
 <20130125163130.GF4721@dhcp22.suse.cz>
 <20130205134937.GA22804@dhcp22.suse.cz>
 <20130205154947.CD6411E2@pobox.sk>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20130205154947.CD6411E2@pobox.sk>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups mailinglist <cgroups@vger.kernel.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>

On Tue 05-02-13 15:49:47, azurIt wrote:
[...]
> Just to be sure - am i supposed to apply this two patches?
> http://watchdog.sk/lkml/patches/

5-memcg-fix-1.patch is not complete. It doesn't contain the folloup I
mentioned in a follow up email. Here is the full patch:
---
From f2bf8437d5b9bb38a95a432bf39f32c584955171 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 26 Nov 2012 11:47:57 +0100
Subject: [PATCH] memcg: do not trigger OOM from add_to_page_cache_locked

memcg oom killer might deadlock if the process which falls down to
mem_cgroup_handle_oom holds a lock which prevents other task to
terminate because it is blocked on the very same lock.
This can happen when a write system call needs to allocate a page but
the allocation hits the memcg hard limit and there is nothing to reclaim
(e.g. there is no swap or swap limit is hit as well and all cache pages
have been reclaimed already) and the process selected by memcg OOM
killer is blocked on i_mutex on the same inode (e.g. truncate it).

Process A
[<ffffffff811109b8>] do_truncate+0x58/0xa0		# takes i_mutex
[<ffffffff81121c90>] do_last+0x250/0xa30
[<ffffffff81122547>] path_openat+0xd7/0x440
[<ffffffff811229c9>] do_filp_open+0x49/0xa0
[<ffffffff8110f7d6>] do_sys_open+0x106/0x240
[<ffffffff8110f950>] sys_open+0x20/0x30
[<ffffffff815b5926>] system_call_fastpath+0x18/0x1d
[<ffffffffffffffff>] 0xffffffffffffffff

Process B
[<ffffffff8110a9c1>] mem_cgroup_handle_oom+0x241/0x3b0
[<ffffffff8110b5ab>] T.1146+0x5ab/0x5c0
[<ffffffff8110c22e>] mem_cgroup_cache_charge+0xbe/0xe0
[<ffffffff810ca28c>] add_to_page_cache_locked+0x4c/0x140
[<ffffffff810ca3a2>] add_to_page_cache_lru+0x22/0x50
[<ffffffff810ca45b>] grab_cache_page_write_begin+0x8b/0xe0
[<ffffffff81193a18>] ext3_write_begin+0x88/0x270
[<ffffffff810c8fc6>] generic_file_buffered_write+0x116/0x290
[<ffffffff810cb3cc>] __generic_file_aio_write+0x27c/0x480
[<ffffffff810cb646>] generic_file_aio_write+0x76/0xf0           # takes ->i_mutex
[<ffffffff8111156a>] do_sync_write+0xea/0x130
[<ffffffff81112183>] vfs_write+0xf3/0x1f0
[<ffffffff81112381>] sys_write+0x51/0x90
[<ffffffff815b5926>] system_call_fastpath+0x18/0x1d
[<ffffffffffffffff>] 0xffffffffffffffff

This is not a hard deadlock though because administrator can still
intervene and increase the limit on the group which helps the writer to
finish the allocation and release the lock.

This patch heals the problem by forbidding OOM from page cache charges
(namely add_ro_page_cache_locked). mem_cgroup_cache_charge_no_oom helper
function is defined which adds GFP_MEMCG_NO_OOM to the gfp mask which
then tells mem_cgroup_charge_common that OOM is not allowed for the
charge. No OOM from this path, except for fixing the bug, also make some
sense as we really do not want to cause an OOM because of a page cache
usage.
As a possibly visible result add_to_page_cache_lru might fail more often
with ENOMEM but this is to be expected if the limit is set and it is
preferable than OOM killer IMO.

__GFP_NORETRY is abused for this memcg specific flag because no user
accounted allocation use this flag except for THP which have memcg oom
disabled already.

Reported-by: azurIt <azurit@pobox.sk>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/gfp.h        |    3 +++
 include/linux/memcontrol.h |   13 +++++++++++++
 mm/filemap.c               |    8 +++++++-
 mm/memcontrol.c            |   10 ++++++----
 4 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 3a76faf..806fb54 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -146,6 +146,9 @@ struct vm_area_struct;
 /* 4GB DMA on some platforms */
 #define GFP_DMA32	__GFP_DMA32
 
+/* memcg oom killer is not allowed */
+#define GFP_MEMCG_NO_OOM	__GFP_NORETRY
+
 /* Convert GFP flags to their corresponding migrate type */
 static inline int allocflags_to_migratetype(gfp_t gfp_flags)
 {
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 81572af..bf0e575 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -63,6 +63,13 @@ extern void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *ptr);
 
 extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 					gfp_t gfp_mask);
+
+static inline int mem_cgroup_cache_charge_no_oom(struct page *page,
+					struct mm_struct *mm, gfp_t gfp_mask)
+{
+	return mem_cgroup_cache_charge(page, mm, gfp_mask | GFP_MEMCG_NO_OOM);
+}
+
 extern void mem_cgroup_add_lru_list(struct page *page, enum lru_list lru);
 extern void mem_cgroup_del_lru_list(struct page *page, enum lru_list lru);
 extern void mem_cgroup_rotate_reclaimable_page(struct page *page);
@@ -178,6 +185,12 @@ static inline int mem_cgroup_cache_charge(struct page *page,
 	return 0;
 }
 
+static inline int mem_cgroup_cache_charge_no_oom(struct page *page,
+					struct mm_struct *mm, gfp_t gfp_mask)
+{
+	return 0;
+}
+
 static inline int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
 		struct page *page, gfp_t gfp_mask, struct mem_cgroup **ptr)
 {
diff --git a/mm/filemap.c b/mm/filemap.c
index 556858c..ef182a9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -449,7 +449,13 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(PageSwapBacked(page));
 
-	error = mem_cgroup_cache_charge(page, current->mm,
+	/*
+	 * Cannot trigger OOM even if gfp_mask would allow that normally
+	 * because we might be called from a locked context and that
+	 * could lead to deadlocks if the killed process is waiting for
+	 * the same lock.
+	 */
+	error = mem_cgroup_cache_charge_no_oom(page, current->mm,
 					gfp_mask & GFP_RECLAIM_MASK);
 	if (error)
 		goto out;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1986c65..a68aa08 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2704,7 +2704,7 @@ static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
 	struct mem_cgroup *memcg = NULL;
 	unsigned int nr_pages = 1;
 	struct page_cgroup *pc;
-	bool oom = true;
+	bool oom = !(gfp_mask & GFP_MEMCG_NO_OOM);
 	int ret;
 
 	if (PageTransHuge(page)) {
@@ -2771,6 +2771,7 @@ __mem_cgroup_commit_charge_lrucare(struct page *page, struct mem_cgroup *memcg,
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
+	bool oom = !(gfp_mask & GFP_MEMCG_NO_OOM);
 	struct mem_cgroup *memcg = NULL;
 	int ret;
 
@@ -2783,7 +2784,7 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 		mm = &init_mm;
 
 	if (page_is_file_cache(page)) {
-		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, &memcg, true);
+		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, &memcg, oom);
 		if (ret || !memcg)
 			return ret;
 
@@ -2819,6 +2820,7 @@ int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
 				 struct page *page,
 				 gfp_t mask, struct mem_cgroup **ptr)
 {
+	bool oom = !(mask & GFP_MEMCG_NO_OOM);
 	struct mem_cgroup *memcg;
 	int ret;
 
@@ -2841,13 +2843,13 @@ int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
 	if (!memcg)
 		goto charge_cur_mm;
 	*ptr = memcg;
-	ret = __mem_cgroup_try_charge(NULL, mask, 1, ptr, true);
+	ret = __mem_cgroup_try_charge(NULL, mask, 1, ptr, oom);
 	css_put(&memcg->css);
 	return ret;
 charge_cur_mm:
 	if (unlikely(!mm))
 		mm = &init_mm;
-	return __mem_cgroup_try_charge(mm, mask, 1, ptr, true);
+	return __mem_cgroup_try_charge(mm, mask, 1, ptr, oom);
 }
 
 static void
-- 
1.7.10.4


-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
