From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: remove lock_page_memcg() from rmap
Date: Wed, 23 Nov 2022 22:03:00 -0800 (PST)
Message-ID: <16dd09c-bb6c-6058-2b3-7559b5aefe9@google.com>
References: <20221123181838.1373440-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FJy6vszDoCp46m3JopX1uY8udZeM6fOcw9P3JKhadjs=;
        b=Jvzn8i+eto9wT02o0N73tnQsoWxjvcrnnCDN3aoRmc4emsUiyBKr3H6Z30JhGymYbs
         AtGemDi/cBgL5d0zDL61lbDsKrqtZoU3ejVPDXCDbMgzQSNsmXeETIHc8vIYYW6gfHJo
         WwmU5DEsQ/oG2uW5eERRdx9E3hCK6Y1AC3M4HRiJcBIXnDBCmHRLRGuVAvPTOXRMf96v
         emKKyJRjUx9QDIltDC8iL9MONtVrzo00/xAEoX+MbGdVDPje5IjmaU+aTeOhqyy9Ko8g
         83eFsLblUIj6MpwruchSm+bgXDu1HEPjM2Wxfqztj34UzGT3N0RuaJk3ZFiOG1506/xd
         ky+w==
In-Reply-To: <20221123181838.1373440-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 23 Nov 2022, Johannes Weiner wrote:

> rmap changes (mapping and unmapping) of a page currently take
> lock_page_memcg() to serialize 1) update of the mapcount and the
> cgroup mapped counter with 2) cgroup moving the page and updating the
> old cgroup and the new cgroup counters based on page_mapped().
> 
> Before b2052564e66d ("mm: memcontrol: continue cache reclaim from
> offlined groups"), we used to reassign all pages that could be found
> on a cgroup's LRU list on deletion - something that rmap didn't
> naturally serialize against. Since that commit, however, the only
> pages that get moved are those mapped into page tables of a task
> that's being migrated. In that case, the pte lock is always held (and
> we know the page is mapped), which keeps rmap changes at bay already.
> 
> The additional lock_page_memcg() by rmap is redundant. Remove it.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Thank you, I love it: but with sorrow and shame, NAK to this version.

I was gearing up to rush in the crash fix at the bottom, when testing
showed that the new VM_WARN_ON_ONCE(!folio_mapped(folio)) actually hits.

So I've asked Stephen to drop this mm-unstable commit from -next for
tonight, while we think about what more is needed.

I was disbelieving when I saw the warning, couldn't understand at all.
But a look at get_mctgt_type() shatters my illusion: it's doesn't just
return a page for pte_present(ptent), it goes off looking up swap
cache and page cache; plus I've no idea whether an MC_TARGET_DEVICE
page would appear as folio_mapped() or not.

Does that mean that we just have to reinstate the folio_mapped() checks
in mm/memcontrol.c i.e. revert all mm/memcontrol.c changes from the
commit?  Or does it invalidate the whole project to remove
lock_page_memcg() from mm/rmap.c?

Too disappointed to think about it more tonight :-(
Hugh


> ---
>  mm/memcontrol.c | 35 ++++++++++++++++++++---------------
>  mm/rmap.c       | 12 ------------
>  2 files changed, 20 insertions(+), 27 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 23750cec0036..52b86ca7a78e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5676,7 +5676,10 @@ static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
>   * @from: mem_cgroup which the page is moved from.
>   * @to:	mem_cgroup which the page is moved to. @from != @to.
>   *
> - * The caller must make sure the page is not on LRU (isolate_page() is useful.)
> + * This function acquires folio_lock() and folio_lock_memcg(). The
> + * caller must exclude all other possible ways of accessing
> + * page->memcg, such as LRU isolation (to lock out isolation) and
> + * having the page mapped and pte-locked (to lock out rmap).
>   *
>   * This function doesn't do "charge" to new cgroup and doesn't do "uncharge"
>   * from old cgroup.
> @@ -5696,6 +5699,13 @@ static int mem_cgroup_move_account(struct page *page,
>  	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
>  	VM_BUG_ON(compound && !folio_test_large(folio));
>  
> +	/*
> +	 * We're only moving pages mapped into the moving process's
> +	 * page tables. The caller's pte lock prevents rmap from
> +	 * removing the NR_x_MAPPED state while we transfer it.
> +	 */
> +	VM_WARN_ON_ONCE(!folio_mapped(folio));
> +
>  	/*
>  	 * Prevent mem_cgroup_migrate() from looking at
>  	 * page's memory cgroup of its source page while we change it.
> @@ -5715,30 +5725,25 @@ static int mem_cgroup_move_account(struct page *page,
>  	folio_memcg_lock(folio);
>  
>  	if (folio_test_anon(folio)) {
> -		if (folio_mapped(folio)) {
> -			__mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
> -			__mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
> -			if (folio_test_transhuge(folio)) {
> -				__mod_lruvec_state(from_vec, NR_ANON_THPS,
> -						   -nr_pages);
> -				__mod_lruvec_state(to_vec, NR_ANON_THPS,
> -						   nr_pages);
> -			}
> +		__mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
> +		__mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
> +
> +		if (folio_test_transhuge(folio)) {
> +			__mod_lruvec_state(from_vec, NR_ANON_THPS, -nr_pages);
> +			__mod_lruvec_state(to_vec, NR_ANON_THPS, nr_pages);
>  		}
>  	} else {
>  		__mod_lruvec_state(from_vec, NR_FILE_PAGES, -nr_pages);
>  		__mod_lruvec_state(to_vec, NR_FILE_PAGES, nr_pages);
>  
> +		__mod_lruvec_state(from_vec, NR_FILE_MAPPED, -nr_pages);
> +		__mod_lruvec_state(to_vec, NR_FILE_MAPPED, nr_pages);
> +
>  		if (folio_test_swapbacked(folio)) {
>  			__mod_lruvec_state(from_vec, NR_SHMEM, -nr_pages);
>  			__mod_lruvec_state(to_vec, NR_SHMEM, nr_pages);
>  		}
>  
> -		if (folio_mapped(folio)) {
> -			__mod_lruvec_state(from_vec, NR_FILE_MAPPED, -nr_pages);
> -			__mod_lruvec_state(to_vec, NR_FILE_MAPPED, nr_pages);
> -		}
> -
>  		if (folio_test_dirty(folio)) {
>  			struct address_space *mapping = folio_mapping(folio);
>  
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 459dc1c44d8a..11a4894158db 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1222,9 +1222,6 @@ void page_add_anon_rmap(struct page *page,
>  	bool compound = flags & RMAP_COMPOUND;
>  	bool first = true;
>  
> -	if (unlikely(PageKsm(page)))
> -		lock_page_memcg(page);
> -
>  	/* Is page being mapped by PTE? Is this its first map to be added? */
>  	if (likely(!compound)) {
>  		first = atomic_inc_and_test(&page->_mapcount);
> @@ -1254,9 +1251,6 @@ void page_add_anon_rmap(struct page *page,
>  	if (nr)
>  		__mod_lruvec_page_state(page, NR_ANON_MAPPED, nr);
>  
> -	if (unlikely(PageKsm(page)))
> -		unlock_page_memcg(page);
> -
>  	/* address might be in next vma when migration races vma_adjust */
>  	else if (first)
>  		__page_set_anon_rmap(page, vma, address,
> @@ -1321,7 +1315,6 @@ void page_add_file_rmap(struct page *page,
>  	bool first;
>  
>  	VM_BUG_ON_PAGE(compound && !PageTransHuge(page), page);
> -	lock_page_memcg(page);
>  
>  	/* Is page being mapped by PTE? Is this its first map to be added? */
>  	if (likely(!compound)) {
> @@ -1349,7 +1342,6 @@ void page_add_file_rmap(struct page *page,
>  			NR_SHMEM_PMDMAPPED : NR_FILE_PMDMAPPED, nr_pmdmapped);
>  	if (nr)
>  		__mod_lruvec_page_state(page, NR_FILE_MAPPED, nr);
> -	unlock_page_memcg(page);
>  
>  	mlock_vma_page(page, vma, compound);
>  }
> @@ -1378,8 +1370,6 @@ void page_remove_rmap(struct page *page,
>  		return;
>  	}
>  
> -	lock_page_memcg(page);
> -
>  	/* Is page being unmapped by PTE? Is this its last map to be removed? */
>  	if (likely(!compound)) {
>  		last = atomic_add_negative(-1, &page->_mapcount);
> @@ -1427,8 +1417,6 @@ void page_remove_rmap(struct page *page,
>  	 * and remember that it's only reliable while mapped.
>  	 */
>  
> -	unlock_page_memcg(page);
> -
>  	munlock_vma_page(page, vma, compound);
>  }
>  
> -- 
> 2.38.1

[PATCH] mm: remove lock_page_memcg() from rmap - fix

Blame me for the hidden "else", which now does the wrong thing, leaving
page's anon_vma unset, then VM_BUG_ON before do_swap_page's set_pte_at.

Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/rmap.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 11a4894158db..5a8d27fdc644 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1251,13 +1251,14 @@ void page_add_anon_rmap(struct page *page,
 	if (nr)
 		__mod_lruvec_page_state(page, NR_ANON_MAPPED, nr);
 
-	/* address might be in next vma when migration races vma_adjust */
-	else if (first)
-		__page_set_anon_rmap(page, vma, address,
-				     !!(flags & RMAP_EXCLUSIVE));
-	else
-		__page_check_anon_rmap(page, vma, address);
-
+	if (!PageKsm(page)) {
+		/* address may be in next vma if migration races vma_adjust */
+		if (first)
+			__page_set_anon_rmap(page, vma, address,
+					     !!(flags & RMAP_EXCLUSIVE));
+		else
+			__page_check_anon_rmap(page, vma, address);
+	}
 	mlock_vma_page(page, vma, compound);
 }
 
-- 
2.35.3
