From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH -v2 -mm] memcg: do not trigger OOM from
 add_to_page_cache_locked
Date: Tue, 27 Nov 2012 21:54:36 +0100
Message-ID: <20121127205431.GA2433@dhcp22.suse.cz>
References: <20121123074023.GA24698@dhcp22.suse.cz>
 <20121123102137.10D6D653@pobox.sk>
 <20121123100438.GF24698@dhcp22.suse.cz>
 <20121125011047.7477BB5E@pobox.sk>
 <20121125120524.GB10623@dhcp22.suse.cz>
 <20121125135542.GE10623@dhcp22.suse.cz>
 <20121126013855.AF118F5E@pobox.sk>
 <20121126131837.GC17860@dhcp22.suse.cz>
 <50B403CA.501@jp.fujitsu.com>
 <20121127194813.GP24381@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ltxRjhfo0fZuyKsZOc00BEymNAe6W8KyPLkzPLaZXFo=;
        b=Mf3WNNIyWR8HXLjsc4bn+mwaLihxMEpm/ZnaCNxUkfnHUQY5FpUceo4gXwkQH9KpcU
         ZcAiw8zu8lo+QFUICxTlnInQbiIO0DLab7qUnLm/PHq1RtmjlwgKekCOCgs3TnpTEZT/
         gujUjHyH6e0IQlGNkADDM+XL1q0vKdbKzaMbwOUVhHsl/Htv730VAEcja+P9BAOUOzks
         NgTpgDuwt8+jxmNqrG2xPCY5MuAai4GTWIuW/0uuS0EtFLwbZG/JGu3W4X/CHDlRMHKH
         99ezT40YsXmSpP+RM7zvzvTrBhpFeDpZggSG2XA558jEgAshvRGXlOY7QpWaaFGlo3p0
         VKcw==
Content-Disposition: inline
In-Reply-To: <20121127194813.GP24381-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue 27-11-12 14:48:13, Johannes Weiner wrote:
[...]
> > >diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> > >index 10e667f..aac9b21 100644
> > >--- a/include/linux/gfp.h
> > >+++ b/include/linux/gfp.h
> > >@@ -152,6 +152,9 @@ struct vm_area_struct;
> > >  /* 4GB DMA on some platforms */
> > >  #define GFP_DMA32	__GFP_DMA32
> > >
> > >+/* memcg oom killer is not allowed */
> > >+#define GFP_MEMCG_NO_OOM	__GFP_NORETRY
> 
> Could we leave this within memcg, please?  An extra flag to
> mem_cgroup_cache_charge() or the like.  GFP flags are about
> controlling the page allocator, this seems abusive.  We have an oom
> flag down in try_charge, maybe just propagate this up the stack?

OK, what about the patch bellow?
I have dropped Kame's Acked-by because it has been reworked. The patch
is the same in principle.

> > >diff --git a/mm/filemap.c b/mm/filemap.c
> > >index 83efee7..ef14351 100644
> > >--- a/mm/filemap.c
> > >+++ b/mm/filemap.c
> > >@@ -447,7 +447,13 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
> > >  	VM_BUG_ON(!PageLocked(page));
> > >  	VM_BUG_ON(PageSwapBacked(page));
> > >
> > >-	error = mem_cgroup_cache_charge(page, current->mm,
> > >+	/*
> > >+	 * Cannot trigger OOM even if gfp_mask would allow that normally
> > >+	 * because we might be called from a locked context and that
> > >+	 * could lead to deadlocks if the killed process is waiting for
> > >+	 * the same lock.
> > >+	 */
> > >+	error = mem_cgroup_cache_charge_no_oom(page, current->mm,
> > >  					gfp_mask & GFP_RECLAIM_MASK);
> > >  	if (error)
> > >  		goto out;
> 
> Shmem does not use this function but also charges under the i_mutex in
> the write path and fallocate at least.

Right you are
---
From 60cc8a184490d277eb24fca551b114f1e2234ce0 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
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
(namely add_ro_page_cache_locked). mem_cgroup_cache_charge grows oom
argument which is pushed down the call chain.

As a possibly visible result add_to_page_cache_lru might fail more often
with ENOMEM but this is to be expected if the limit is set and it is
preferable than OOM killer IMO.

Changes since v1
- do not abuse gfp_flags and rather use oom parameter directly as per
  Johannes
- handle also shmem write fauls resp. fallocate properly as per Johannes

Reported-by: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>
Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 include/linux/memcontrol.h |    5 +++--
 mm/filemap.c               |    9 +++++++--
 mm/memcontrol.c            |    9 ++++-----
 mm/shmem.c                 |   14 +++++++++++---
 4 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 095d2b4..8f48d5e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -63,7 +63,7 @@ extern void mem_cgroup_commit_charge_swapin(struct page *page,
 extern void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *memcg);
 
 extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
-					gfp_t gfp_mask);
+					gfp_t gfp_mask, bool oom);
 
 struct lruvec *mem_cgroup_zone_lruvec(struct zone *, struct mem_cgroup *);
 struct lruvec *mem_cgroup_page_lruvec(struct page *, struct zone *);
@@ -210,7 +210,8 @@ static inline int mem_cgroup_newpage_charge(struct page *page,
 }
 
 static inline int mem_cgroup_cache_charge(struct page *page,
-					struct mm_struct *mm, gfp_t gfp_mask)
+					struct mm_struct *mm, gfp_t gfp_mask,
+					bool oom)
 {
 	return 0;
 }
diff --git a/mm/filemap.c b/mm/filemap.c
index 83efee7..ef8fbd5 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -447,8 +447,13 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(PageSwapBacked(page));
 
-	error = mem_cgroup_cache_charge(page, current->mm,
-					gfp_mask & GFP_RECLAIM_MASK);
+	/*
+	 * Cannot trigger OOM even if gfp_mask would allow that normally
+	 * because we might be called from a locked context and that
+	 * could lead to deadlocks if the killed process is waiting for
+	 * the same lock.
+	 */
+	error = mem_cgroup_cache_charge(page, current->mm, gfp_mask, false);
 	if (error)
 		goto out;
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 02ee2f7..26690d6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3709,11 +3709,10 @@ out:
  * < 0 if the cgroup is over its limit
  */
 static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
-				gfp_t gfp_mask, enum charge_type ctype)
+				gfp_t gfp_mask, enum charge_type ctype, bool oom)
 {
 	struct mem_cgroup *memcg = NULL;
 	unsigned int nr_pages = 1;
-	bool oom = true;
 	int ret;
 
 	if (PageTransHuge(page)) {
@@ -3742,7 +3741,7 @@ int mem_cgroup_newpage_charge(struct page *page,
 	VM_BUG_ON(page->mapping && !PageAnon(page));
 	VM_BUG_ON(!mm);
 	return mem_cgroup_charge_common(page, mm, gfp_mask,
-					MEM_CGROUP_CHARGE_TYPE_ANON);
+					MEM_CGROUP_CHARGE_TYPE_ANON, true);
 }
 
 /*
@@ -3851,7 +3850,7 @@ void mem_cgroup_commit_charge_swapin(struct page *page,
 }
 
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
-				gfp_t gfp_mask)
+				gfp_t gfp_mask, bool oom)
 {
 	struct mem_cgroup *memcg = NULL;
 	enum charge_type type = MEM_CGROUP_CHARGE_TYPE_CACHE;
@@ -3863,7 +3862,7 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 		return 0;
 
 	if (!PageSwapCache(page))
-		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
+		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type, oom);
 	else { /* page is swapcache/shmem */
 		ret = __mem_cgroup_try_charge_swapin(mm, page,
 						     gfp_mask, &memcg);
diff --git a/mm/shmem.c b/mm/shmem.c
index 55054a7..cef63b5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -760,7 +760,7 @@ int shmem_unuse(swp_entry_t swap, struct page *page)
 	 * the shmem_swaplist_mutex which might hold up shmem_writepage().
 	 * Charged back to the user (not to caller) when swap account is used.
 	 */
-	error = mem_cgroup_cache_charge(page, current->mm, GFP_KERNEL);
+	error = mem_cgroup_cache_charge(page, current->mm, GFP_KERNEL, true);
 	if (error)
 		goto out;
 	/* No radix_tree_preload: swap entry keeps a place for page in tree */
@@ -1152,8 +1152,16 @@ repeat:
 				goto failed;
 		}
 
+		 /*
+                  * Cannot trigger OOM even if gfp_mask would allow that
+                  * normally because we might be called from a locked
+                  * context (i_mutex held) if this is a write lock or
+                  * fallocate and that could lead to deadlocks if the
+                  * killed process is waiting for the same lock.
+		  */
 		error = mem_cgroup_cache_charge(page, current->mm,
-						gfp & GFP_RECLAIM_MASK);
+						gfp & GFP_RECLAIM_MASK,
+						sgp < SGP_WRITE);
 		if (!error) {
 			error = shmem_add_to_page_cache(page, mapping, index,
 						gfp, swp_to_radix_entry(swap));
@@ -1209,7 +1217,7 @@ repeat:
 		SetPageSwapBacked(page);
 		__set_page_locked(page);
 		error = mem_cgroup_cache_charge(page, current->mm,
-						gfp & GFP_RECLAIM_MASK);
+						gfp & GFP_RECLAIM_MASK, true);
 		if (error)
 			goto decused;
 		error = radix_tree_preload(gfp & GFP_RECLAIM_MASK);
-- 
1.7.10.4


-- 
Michal Hocko
SUSE Labs
