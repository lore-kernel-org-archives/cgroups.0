From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] memcg: change behavior of moving charges at task move
Date: Fri, 23 Mar 2012 18:00:34 +0900
Message-ID: <4F6C3BB2.6090108@jp.fujitsu.com>
References: <4F69A4C4.4080602@jp.fujitsu.com> <20120322143610.e4df49c9.akpm@linux-foundation.org> <4F6BC166.80407@jp.fujitsu.com> <20120322173000.f078a43f.akpm@linux-foundation.org> <4F6BC94C.80301@jp.fujitsu.com> <20120323085301.GA1739@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120323085301.GA1739-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org" <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

(2012/03/23 17:53), Johannes Weiner wrote:

> On Fri, Mar 23, 2012 at 09:52:28AM +0900, KAMEZAWA Hiroyuki wrote:
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index b2ee6df..ca8b3a1 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -5147,7 +5147,7 @@ static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
>>  		return NULL;
>>  	if (PageAnon(page)) {
>>  		/* we don't move shared anon */
>> -		if (!move_anon() || page_mapcount(page) > 2)
>> +		if (!move_anon())
>>  			return NULL;
>>  	} else if (!move_file())
>>  		/* we ignore mapcount for file pages */
>> @@ -5158,26 +5158,32 @@ static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
>>  	return page;
>>  }
>>  
>> +#ifdef CONFFIG_SWAP
> 
> That will probably disable it for good :)
> 


Thank you for your good eyes.. I feel I can't trust my eyes ;(


==
From d7ed385bad22d352bb28aeb9380591b72ec5bec5 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Date: Wed, 21 Mar 2012 19:03:40 +0900
Subject: [PATCH] memcg: fix/change behavior of shared anon at moving task.

This patch changes memcg's behavior at task_move().

At task_move(), the kernel scans a task's page table and move
the changes for mapped pages from source cgroup to target cgroup.
There has been a bug at handling shared anonymous pages for a long time.

Before patch:
  - The spec says 'shared anonymous pages are not moved.'
  - The implementation was 'shared anonymoys pages may be moved'.
    If page_mapcount <=2, shared anonymous pages's charge were moved.

After patch:
  - The spec says 'all anonymous pages are moved'.
  - The implementation is 'all anonymous pages are moved'.

Considering usage of memcg, this will not affect user's experience.
'shared anonymous' pages only exists between a tree of processes
which don't do exec(). Moving one of process without exec() seems
not sane. For example, libcgroup will not be affected by this change.
(Anyway, no one noticed the implementation for a long time...)

Below is a discussion log:

 - current spec/implementation are complex
 - Now, shared file caches are moved
 - It adds unclear check as page_mapcount(). To do correct check,
   we should check swap users, etc.
 - No one notice this implementation behavior. So, no one get benefit
   from the design.
 - In general, once task is moved to a cgroup for running, it will not
   be moved....
 - Finally, we have control knob as memory.move_charge_at_immigrate.

Here is a patch to allow moving shared pages, completely. This makes
memcg simpler and fix current broken code.

Changelog:
  - fixed CONFFIG_SWAP...
Changelog:
  - fixed comment around find_get_page()
  - changed CONFIG_SWAP handling
  - updated patch description

Suggested-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 Documentation/cgroups/memory.txt |    9 ++++-----
 include/linux/swap.h             |    9 ---------
 mm/memcontrol.c                  |   22 ++++++++++++++--------
 mm/swapfile.c                    |   31 -------------------------------
 4 files changed, 18 insertions(+), 53 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 4c95c00..84d4f00 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -185,12 +185,14 @@ behind this approach is that a cgroup that aggressively uses a shared
 page will eventually get charged for it (once it is uncharged from
 the cgroup that brought it in -- this will happen on memory pressure).
 
+But see section 8.2: when moving a task to another cgroup, its pages may
+be recharged to the new cgroup, if move_charge_at_immigrate has been chosen.
+
 Exception: If CONFIG_CGROUP_CGROUP_MEM_RES_CTLR_SWAP is not used.
 When you do swapoff and make swapped-out pages of shmem(tmpfs) to
 be backed into memory in force, charges for pages are accounted against the
 caller of swapoff rather than the users of shmem.
 
-
 2.4 Swap Extension (CONFIG_CGROUP_MEM_RES_CTLR_SWAP)
 
 Swap Extension allows you to record charge for swap. A swapped-in page is
@@ -623,8 +625,7 @@ memory cgroup.
   bit | what type of charges would be moved ?
  -----+------------------------------------------------------------------------
    0  | A charge of an anonymous page(or swap of it) used by the target task.
-      | Those pages and swaps must be used only by the target task. You must
-      | enable Swap Extension(see 2.4) to enable move of swap charges.
+      | You must enable Swap Extension(see 2.4) to enable move of swap charges.
  -----+------------------------------------------------------------------------
    1  | A charge of file pages(normal file, tmpfs file(e.g. ipc shared memory)
       | and swaps of tmpfs file) mmapped by the target task. Unlike the case of
@@ -637,8 +638,6 @@ memory cgroup.
 
 8.3 TODO
 
-- Implement madvise(2) to let users decide the vma to be moved or not to be
-  moved.
 - All of moving charge operations are done under cgroup_mutex. It's not good
   behavior to hold the mutex too long, so we may need some trick.
 
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 6e66c03..70d2c74 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -387,7 +387,6 @@ static inline void deactivate_swap_token(struct mm_struct *mm, bool swap_token)
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 extern void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout);
-extern int mem_cgroup_count_swap_user(swp_entry_t ent, struct page **pagep);
 #else
 static inline void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
@@ -532,14 +531,6 @@ mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
 {
 }
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
-static inline int
-mem_cgroup_count_swap_user(swp_entry_t ent, struct page **pagep)
-{
-	return 0;
-}
-#endif
-
 #endif /* CONFIG_SWAP */
 #endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b2ee6df..962b97a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5147,7 +5147,7 @@ static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
 		return NULL;
 	if (PageAnon(page)) {
 		/* we don't move shared anon */
-		if (!move_anon() || page_mapcount(page) > 2)
+		if (!move_anon())
 			return NULL;
 	} else if (!move_file())
 		/* we ignore mapcount for file pages */
@@ -5158,26 +5158,32 @@ static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
 	return page;
 }
 
+#ifdef CONFIG_SWAP
 static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
 			unsigned long addr, pte_t ptent, swp_entry_t *entry)
 {
-	int usage_count;
 	struct page *page = NULL;
 	swp_entry_t ent = pte_to_swp_entry(ptent);
 
 	if (!move_anon() || non_swap_entry(ent))
 		return NULL;
-	usage_count = mem_cgroup_count_swap_user(ent, &page);
-	if (usage_count > 1) { /* we don't move shared anon */
-		if (page)
-			put_page(page);
-		return NULL;
-	}
+	/*
+	 * Because lookup_swap_cache() updates some statistics counter,
+	 * we call find_get_page() with swapper_space directly.
+	 */
+	page = find_get_page(&swapper_space, ent.val);
 	if (do_swap_account)
 		entry->val = ent.val;
 
 	return page;
 }
+#else
+static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
+			unsigned long addr, pte_t ptent, swp_entry_t *entry)
+{
+	return NULL;
+}
+#endif
 
 static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
 			unsigned long addr, pte_t ptent, swp_entry_t *entry)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index dae42f3..fedeb6b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -717,37 +717,6 @@ int free_swap_and_cache(swp_entry_t entry)
 	return p != NULL;
 }
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
-/**
- * mem_cgroup_count_swap_user - count the user of a swap entry
- * @ent: the swap entry to be checked
- * @pagep: the pointer for the swap cache page of the entry to be stored
- *
- * Returns the number of the user of the swap entry. The number is valid only
- * for swaps of anonymous pages.
- * If the entry is found on swap cache, the page is stored to pagep with
- * refcount of it being incremented.
- */
-int mem_cgroup_count_swap_user(swp_entry_t ent, struct page **pagep)
-{
-	struct page *page;
-	struct swap_info_struct *p;
-	int count = 0;
-
-	page = find_get_page(&swapper_space, ent.val);
-	if (page)
-		count += page_mapcount(page);
-	p = swap_info_get(ent);
-	if (p) {
-		count += swap_count(p->swap_map[swp_offset(ent)]);
-		spin_unlock(&swap_lock);
-	}
-
-	*pagep = page;
-	return count;
-}
-#endif
-
 #ifdef CONFIG_HIBERNATION
 /*
  * Find the swap type that corresponds to given device (if any).
-- 
1.7.4.1

