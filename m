From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH -v2 -mm] memcg: do not trigger OOM from
 add_to_page_cache_locked
Date: Wed, 28 Nov 2012 17:48:24 +0100
Message-ID: <20121128164824.GC22201@dhcp22.suse.cz>
References: <20121126013855.AF118F5E@pobox.sk>
 <20121126131837.GC17860@dhcp22.suse.cz>
 <50B403CA.501@jp.fujitsu.com>
 <20121127194813.GP24381@cmpxchg.org>
 <20121127205431.GA2433@dhcp22.suse.cz>
 <20121127205944.GB2433@dhcp22.suse.cz>
 <20121128152631.GT24381@cmpxchg.org>
 <20121128160447.GH12309@dhcp22.suse.cz>
 <20121128163736.GV24381@cmpxchg.org>
 <20121128164640.GB22201@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20121128164640.GB22201@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, azurIt <azurit@pobox.sk>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups mailinglist <cgroups@vger.kernel.org>

On Wed 28-11-12 17:46:40, Michal Hocko wrote:
> On Wed 28-11-12 11:37:36, Johannes Weiner wrote:
> > On Wed, Nov 28, 2012 at 05:04:47PM +0100, Michal Hocko wrote:
> > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > index 095d2b4..5abe441 100644
> > > --- a/include/linux/memcontrol.h
> > > +++ b/include/linux/memcontrol.h
> > > @@ -57,13 +57,14 @@ extern int mem_cgroup_newpage_charge(struct page *page, struct mm_struct *mm,
> > >  				gfp_t gfp_mask);
> > >  /* for swap handling */
> > >  extern int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
> > > -		struct page *page, gfp_t mask, struct mem_cgroup **memcgp);
> > > +		struct page *page, gfp_t mask, struct mem_cgroup **memcgp,
> > > +		bool oom);
> > 
> > Ok, now I feel almost bad for asking, but why the public interface,
> > too?
> 
> Would it work out if I tell it was to double check that your review
> quality is not decreased after that many revisions? :P
> 
> Incremental update and the full patch in the reply
---
From e21bb704947e9a477ec1df9121575c606dbfcb52 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 28 Nov 2012 17:46:32 +0100
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

Reported-by: azurIt <azurit@pobox.sk>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/memcontrol.h |    5 +++--
 mm/filemap.c               |    9 +++++++--
 mm/memcontrol.c            |   20 ++++++++++----------
 mm/shmem.c                 |   17 ++++++++++++++---
 4 files changed, 34 insertions(+), 17 deletions(-)

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
index 02ee2f7..3c9b1c5 100644
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
@@ -3754,7 +3753,8 @@ int mem_cgroup_newpage_charge(struct page *page,
 static int __mem_cgroup_try_charge_swapin(struct mm_struct *mm,
 					  struct page *page,
 					  gfp_t mask,
-					  struct mem_cgroup **memcgp)
+					  struct mem_cgroup **memcgp,
+					  bool oom)
 {
 	struct mem_cgroup *memcg;
 	struct page_cgroup *pc;
@@ -3776,13 +3776,13 @@ static int __mem_cgroup_try_charge_swapin(struct mm_struct *mm,
 	if (!memcg)
 		goto charge_cur_mm;
 	*memcgp = memcg;
-	ret = __mem_cgroup_try_charge(NULL, mask, 1, memcgp, true);
+	ret = __mem_cgroup_try_charge(NULL, mask, 1, memcgp, oom);
 	css_put(&memcg->css);
 	if (ret == -EINTR)
 		ret = 0;
 	return ret;
 charge_cur_mm:
-	ret = __mem_cgroup_try_charge(mm, mask, 1, memcgp, true);
+	ret = __mem_cgroup_try_charge(mm, mask, 1, memcgp, oom);
 	if (ret == -EINTR)
 		ret = 0;
 	return ret;
@@ -3808,7 +3808,7 @@ int mem_cgroup_try_charge_swapin(struct mm_struct *mm, struct page *page,
 			ret = 0;
 		return ret;
 	}
-	return __mem_cgroup_try_charge_swapin(mm, page, gfp_mask, memcgp);
+	return __mem_cgroup_try_charge_swapin(mm, page, gfp_mask, memcgp, true);
 }
 
 void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *memcg)
@@ -3851,7 +3851,7 @@ void mem_cgroup_commit_charge_swapin(struct page *page,
 }
 
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
-				gfp_t gfp_mask)
+				gfp_t gfp_mask, bool oom)
 {
 	struct mem_cgroup *memcg = NULL;
 	enum charge_type type = MEM_CGROUP_CHARGE_TYPE_CACHE;
@@ -3863,10 +3863,10 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 		return 0;
 
 	if (!PageSwapCache(page))
-		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
+		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type, oom);
 	else { /* page is swapcache/shmem */
 		ret = __mem_cgroup_try_charge_swapin(mm, page,
-						     gfp_mask, &memcg);
+						     gfp_mask, &memcg, oom);
 		if (!ret)
 			__mem_cgroup_commit_charge_swapin(page, memcg, type);
 	}
diff --git a/mm/shmem.c b/mm/shmem.c
index 55054a7..3b27db4 100644
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
@@ -1152,8 +1152,17 @@ repeat:
 				goto failed;
 		}
 
+		 /*
+		  * Cannot trigger OOM even if gfp_mask would allow that
+		  * normally because we might be called from a locked
+		  * context (i_mutex held) if this is a write lock or
+		  * fallocate and that could lead to deadlocks if the
+		  * killed process is waiting for the same lock.
+		  */
 		error = mem_cgroup_cache_charge(page, current->mm,
-						gfp & GFP_RECLAIM_MASK);
+						gfp & GFP_RECLAIM_MASK,
+						sgp != SGP_WRITE &&
+						sgp != SGP_FALLOC);
 		if (!error) {
 			error = shmem_add_to_page_cache(page, mapping, index,
 						gfp, swp_to_radix_entry(swap));
@@ -1209,7 +1218,9 @@ repeat:
 		SetPageSwapBacked(page);
 		__set_page_locked(page);
 		error = mem_cgroup_cache_charge(page, current->mm,
-						gfp & GFP_RECLAIM_MASK);
+						gfp & GFP_RECLAIM_MASK,
+						sgp != SGP_WRITE &&
+						sgp != SGP_FALLOC);
 		if (error)
 			goto decused;
 		error = radix_tree_preload(gfp & GFP_RECLAIM_MASK);
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
