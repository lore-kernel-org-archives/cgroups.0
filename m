From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] mm: memcontrol: do not kill uncharge batching in
 free_pages_and_swap_cache
Date: Wed, 24 Sep 2014 12:42:34 -0700
Message-ID: <20140924124234.3fdb59d6cdf7e9c4d6260adb@linux-foundation.org>
References: <1411571338-8178-1-git-send-email-hannes@cmpxchg.org>
	<1411571338-8178-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1411571338-8178-2-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>, Vladimir Davydov <vdavydov@parallels.com>, Dave Hansen <dave@sr71.net>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014 11:08:56 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> From: Michal Hocko <mhocko@suse.cz>
> 
> free_pages_and_swap_cache limits release_pages to PAGEVEC_SIZE chunks.
> This is not a big deal for the normal release path but it completely
> kills memcg uncharge batching which reduces res_counter spin_lock
> contention. Dave has noticed this with his page fault scalability test
> case on a large machine when the lock was basically dominating on all
> CPUs:
> 
> ...
>
> In his case the load was running in the root memcg and that part
> has been handled by reverting 05b843012335 ("mm: memcontrol: use
> root_mem_cgroup res_counter") because this is a clear regression,
> but the problem remains inside dedicated memcgs.
> 
> There is no reason to limit release_pages to PAGEVEC_SIZE batches other
> than lru_lock held times. This logic, however, can be moved inside the
> function. mem_cgroup_uncharge_list and free_hot_cold_page_list do not
> hold any lock for the whole pages_to_free list so it is safe to call
> them in a single run.
> 
> Page reference count and LRU handling is moved to release_lru_pages and
> that is run in PAGEVEC_SIZE batches.

Looks OK.

> --- a/mm/swap.c
> +++ b/mm/swap.c
>
> ...
>
> +}
> +/*
> + * Batched page_cache_release(). Frees and uncharges all given pages
> + * for which the reference count drops to 0.
> + */
> +void release_pages(struct page **pages, int nr, bool cold)
> +{
> +	LIST_HEAD(pages_to_free);
>  
> +	while (nr) {
> +		int batch = min(nr, PAGEVEC_SIZE);
> +
> +		release_lru_pages(pages, batch, &pages_to_free);
> +		pages += batch;
> +		nr -= batch;
> +	}

The use of PAGEVEC_SIZE here is pretty misleading - there are no
pagevecs in sight.  SWAP_CLUSTER_MAX would be more appropriate.



afaict the only reason for this loop is to limit the hold duration for
lru_lock.  And it does a suboptimal job of that because it treats all
lru_locks as one: if release_lru_pages() were to hold zoneA's lru_lock
for 8 pages and then were to drop that and hold zoneB's lru_lock for 8
pages, the logic would then force release_lru_pages() to drop the lock
and return to release_pages() even though it doesn't need to.

So I'm thinking it would be better to move the lock-busting logic into
release_lru_pages() itself.  With a suitable comment, natch ;) Only
bust the lock in the case where we really did hold a particular lru_lock
for 16 consecutive pages.  Then s/release_lru_pages/release_pages/ and
zap the old release_pages().

Obviously it's not very important - presumably the common case is that
the LRU contains lengthy sequences of pages from the same zone.  Maybe.


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
