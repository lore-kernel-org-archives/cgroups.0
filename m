From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/3] mm: memcontrol: skip moving non-present pages that
 are mapped elsewhere
Date: Tue, 6 Dec 2022 17:51:46 -0800 (PST)
Message-ID: <124f63e-ade3-78e5-f223-53668db36217@google.com>
References: <20221206171340.139790-1-hannes@cmpxchg.org> <20221206171340.139790-2-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fPu3F6AaPpr0cGTXbZ0IU965/QfP/00jiQD3p12tubc=;
        b=M0JPuZOBA2Srlf0lA9Wk1yOApsWT0kfaoJhDIY1aDNTsWZ2ShTrfzx4aC5chXquuCB
         QeeXpS8GX8E1Gk3vTDfiaWM0MhbeaHHlzPziuslPDptLyiYvkyzuhDvMsXw8QNuEZ1fW
         qhcE6HJtOFGZ3E0hgilE26lnsfq4jrEGh5GjGKCSnLnL8AcUnslDr0wr6UE743XlFpxP
         otVg2XkHDAkiXINLW29jxCNOgzvTpZyFCyk/Rexe7nGsN5Qen2uevSdqPhEPUdVeMz+x
         enqzQHaRSEMuKLKjWk4Fsa75u3GeZ0YdoJBPr/Ng9HEPhbo5GhrYikS8mTRAVowodFbU
         MWZg==
In-Reply-To: <20221206171340.139790-2-hannes@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 6 Dec 2022, Johannes Weiner wrote:

> During charge moving, the pte lock and the page lock cover nearly all
> cases of stabilizing page_mapped(). The only exception is when we're
> looking at a non-present pte and find a page in the page cache or in
> the swapcache: if the page is mapped elsewhere, it can become unmapped
> outside of our control. For this reason, rmap needs lock_page_memcg().
> 
> We don't like cgroup-specific locks in generic MM code - especially in
> performance-critical MM code - and for a legacy feature that's
> unlikely to have many users left - if any.
> 
> So remove the exception. Arguably that's better semantics anyway: the
> page is shared, and another process seems to be the more active user.
> 
> Once we stop moving such pages, rmap doesn't need lock_page_memcg()
> anymore. The next patch will remove it.
> 
> Suggested-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Hugh Dickins <hughd@google.com>

It ended up simpler than I'd expected: nice, thank you.

I was going to say that you'd missed the most important detail from
the commit message (that page lock prevents remapping unmapped pages):
but you've gone into good detail on that in the source comment,
so that's fine.

I almost thought you could remove the folio_memcg() check from
mem_cgroup_move_account() itself: but then it looks as if
get_mctgt_type_thp() does things in a slightly different order,
leaving a window open in which folio memcg could have been changed.
Okay, there's no need to go back and rearrange that.

(I notice that get_mctgt_type_thp() has never been updated
for shmem and file THPs, so will move them iff MOVE_ANON:
but that's irrelevant to your changes, and probably something
we're not at all interested in fixing, now it's deprecated code.)

My tmpfs swapping load has been running for five hours on this
(and the others) so far: going fine.  I hacked in some stats to
verify that it really is moving anon and shmem and file, mapped
and unmapped: yes it is, and the unmapped numbers are big enough
that I'm glad that we chose to include them.

> ---
>  mm/memcontrol.c | 52 ++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 38 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 48c44229cf47..b696354c1b21 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5681,7 +5681,7 @@ static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
>   * @from: mem_cgroup which the page is moved from.
>   * @to:	mem_cgroup which the page is moved to. @from != @to.
>   *
> - * The caller must make sure the page is not on LRU (isolate_page() is useful.)
> + * The page must be locked and not on the LRU.
>   *
>   * This function doesn't do "charge" to new cgroup and doesn't do "uncharge"
>   * from old cgroup.
> @@ -5698,20 +5698,13 @@ static int mem_cgroup_move_account(struct page *page,
>  	int nid, ret;
>  
>  	VM_BUG_ON(from == to);
> +	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>  	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
>  	VM_BUG_ON(compound && !folio_test_large(folio));
>  
> -	/*
> -	 * Prevent mem_cgroup_migrate() from looking at
> -	 * page's memory cgroup of its source page while we change it.
> -	 */
> -	ret = -EBUSY;
> -	if (!folio_trylock(folio))
> -		goto out;
> -
>  	ret = -EINVAL;
>  	if (folio_memcg(folio) != from)
> -		goto out_unlock;
> +		goto out;
>  
>  	pgdat = folio_pgdat(folio);
>  	from_vec = mem_cgroup_lruvec(from, pgdat);
> @@ -5798,8 +5791,6 @@ static int mem_cgroup_move_account(struct page *page,
>  	mem_cgroup_charge_statistics(from, -nr_pages);
>  	memcg_check_events(from, nid);
>  	local_irq_enable();
> -out_unlock:
> -	folio_unlock(folio);
>  out:
>  	return ret;
>  }
> @@ -5848,6 +5839,29 @@ static enum mc_target_type get_mctgt_type(struct vm_area_struct *vma,
>  	else if (is_swap_pte(ptent))
>  		page = mc_handle_swap_pte(vma, ptent, &ent);
>  
> +	if (target && page) {
> +		if (!trylock_page(page)) {
> +			put_page(page);
> +			return ret;
> +		}
> +		/*
> +		 * page_mapped() must be stable during the move. This
> +		 * pte is locked, so if it's present, the page cannot
> +		 * become unmapped. If it isn't, we have only partial
> +		 * control over the mapped state: the page lock will
> +		 * prevent new faults against pagecache and swapcache,
> +		 * so an unmapped page cannot become mapped. However,
> +		 * if the page is already mapped elsewhere, it can
> +		 * unmap, and there is nothing we can do about it.
> +		 * Alas, skip moving the page in this case.
> +		 */
> +		if (!pte_present(ptent) && page_mapped(page)) {
> +			unlock_page(page);
> +			put_page(page);
> +			return ret;
> +		}
> +	}
> +
>  	if (!page && !ent.val)
>  		return ret;
>  	if (page) {
> @@ -5864,8 +5878,11 @@ static enum mc_target_type get_mctgt_type(struct vm_area_struct *vma,
>  			if (target)
>  				target->page = page;
>  		}
> -		if (!ret || !target)
> +		if (!ret || !target) {
> +			if (target)
> +				unlock_page(page);
>  			put_page(page);
> +		}
>  	}
>  	/*
>  	 * There is a swap entry and a page doesn't exist or isn't charged.
> @@ -5905,6 +5922,10 @@ static enum mc_target_type get_mctgt_type_thp(struct vm_area_struct *vma,
>  		ret = MC_TARGET_PAGE;
>  		if (target) {
>  			get_page(page);
> +			if (!trylock_page(page)) {
> +				put_page(page);
> +				return MC_TARGET_NONE;
> +			}
>  			target->page = page;
>  		}
>  	}
> @@ -6143,6 +6164,7 @@ static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
>  				}
>  				putback_lru_page(page);
>  			}
> +			unlock_page(page);
>  			put_page(page);
>  		} else if (target_type == MC_TARGET_DEVICE) {
>  			page = target.page;
> @@ -6151,6 +6173,7 @@ static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
>  				mc.precharge -= HPAGE_PMD_NR;
>  				mc.moved_charge += HPAGE_PMD_NR;
>  			}
> +			unlock_page(page);
>  			put_page(page);
>  		}
>  		spin_unlock(ptl);
> @@ -6193,7 +6216,8 @@ static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
>  			}
>  			if (!device)
>  				putback_lru_page(page);
> -put:			/* get_mctgt_type() gets the page */
> +put:			/* get_mctgt_type() gets & locks the page */
> +			unlock_page(page);
>  			put_page(page);
>  			break;
>  		case MC_TARGET_SWAP:
> -- 
> 2.38.1
> 
> 
> 
