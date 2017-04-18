From: "Huang\, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -mm -v8 1/3] mm, THP, swap: Delay splitting THP during swap out
Date: Tue, 18 Apr 2017 08:33:16 +0800
Message-ID: <87efwqtv03.fsf@yhuang-dev.intel.com>
References: <20170406053515.4842-1-ying.huang@intel.com>
        <20170406053515.4842-2-ying.huang@intel.com>
        <20170414145856.GA9812@cmpxchg.org>
        <87k26mzcz3.fsf@yhuang-dev.intel.com>
        <20170417182410.GA26500@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170417182410.GA26500-druUgvl0LCNAfugRpC6u6w@public.gmane.org> (Johannes Weiner's message
        of "Mon, 17 Apr 2017 14:24:10 -0400")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ebru Akagunduz <ebru.akagunduz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> writes:

> On Sat, Apr 15, 2017 at 09:17:04AM +0800, Huang, Ying wrote:
>> Hi, Johannes,
>> 
>> Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> writes:
>> 
>> > Hi Huang,
>> >
>> > I reviewed this patch based on the feedback I already provided, but
>> > eventually gave up and rewrote it. Please take review feedback more
>> > seriously in the future.
>> 
>> Thanks a lot for your help!  I do respect all your review and effort.
>> The -v8 patch doesn't take all your comments, just because I thought we
>> have not reach consensus for some points and I want to use -v8 patch to
>> discuss them.
>> 
>> One concern I have before is whether to split THP firstly when swap
>> space or memcg swap is used up.  Now I think your solution is
>> acceptable. And if we receive any regression report for that in the
>> future, it's not very hard to deal with.
>
> If you look at get_scan_count(), we'll stop scanning anonymous pages
> altogether when swap space runs out. So it might happen to a few THP,
> but it shouldn't be a big deal.

Yes.  It only influences a few THP.

> And yes, in that case I'd really rather wait for any real problems to
> materialize before we complicate things.
>
>> > Attached below is the reworked patch. Most changes are to the layering
>> > (page functions, cluster functions, range functions) so that we don't
>> > make the lowest swap range code require a notion of huge pages, or
>> > make the memcg page functions take size information that can be
>> > gathered from the page itself. I turned the config symbol into a
>> > generic THP_SWAP that can later be extended when we add 2MB IO. The
>> > rest is function naming, #ifdef removal etc.
>> 
>> For some #ifdef in swapfile.c, it is to avoid unnecessary code size
>> increase for !CONFIG_TRANSPARENT_HUGEPAGE or platform with THP swap
>> optimization disabled.  Is it an issue?
>
> It saves some code size, but it looks like the biggest cost comes from
> bloating PageSwapCache(). This is mm/builtin.o with !CONFIG_THP:
>
> add/remove: 1/0 grow/shrink: 34/5 up/down: 920/-311 (609)
> function                                     old     new   delta
> __free_cluster                                 -     106    +106
> get_swap_pages                               465     555     +90
> migrate_page_move_mapping                   1404    1479     +75
> shrink_page_list                            3573    3632     +59
> __delete_from_swap_cache                     235     293     +58
> __test_set_page_writeback                    626     678     +52
> __swap_writepage                             766     812     +46
> try_to_unuse                                1763    1795     +32
> madvise_free_pte_range                       882     912     +30
> __set_page_dirty_nobuffers                   245     268     +23
> migrate_page_copy                            565     587     +22
> swap_slot_free_notify                        133     151     +18
> shmem_replace_page                           616     633     +17
> try_to_free_swap                             135     151     +16
> test_clear_page_writeback                    512     528     +16
> swap_set_page_dirty                          109     125     +16
> swap_readpage                                384     400     +16
> shmem_unuse                                 1535    1551     +16
> reuse_swap_page                              340     356     +16
> page_mapping                                 144     160     +16
> migrate_huge_page_move_mapping               483     499     +16
> free_swap_and_cache                          409     425     +16
> free_pages_and_swap_cache                    161     177     +16
> free_page_and_swap_cache                     145     161     +16
> do_swap_page                                1216    1232     +16
> __remove_mapping                             408     424     +16
> __page_file_mapping                           82      98     +16
> __page_file_index                             70      85     +15
> try_to_unmap_one                            1324    1337     +13
> shmem_getpage_gfp.isra                      2358    2371     +13
> add_to_swap_cache                             47      60     +13
> inc_cluster_info_page                        204     210      +6
> get_swap_page                                411     415      +4
> shmem_writepage                              922     925      +3
> sys_swapon                                  4210    4211      +1
> swapcache_free_entries                       786     768     -18
> __add_to_swap_cache                          445     406     -39
> delete_from_swap_cache                       149     104     -45
> scan_swap_map_slots                         1953    1889     -64
> swap_do_scheduled_discard                    713     568    -145
> Total: Before=454535, After=455144, chg +0.13%
>
> If I make the compound_head() in there conditional, this patch
> actually ends up shrinking the code due to the refactoring of the
> cluster functions:
>
> add/remove: 1/0 grow/shrink: 10/5 up/down: 302/-327 (-25)
> function                                     old     new   delta
> __free_cluster                                 -     106    +106
> get_swap_pages                               465     555     +90
> __delete_from_swap_cache                     235     277     +42
> shmem_replace_page                           616     633     +17
> migrate_page_move_mapping                   1404    1418     +14
> add_to_swap_cache                             47      60     +13
> migrate_page_copy                            565     571      +6
> inc_cluster_info_page                        204     210      +6
> get_swap_page                                411     415      +4
> shmem_writepage                              922     925      +3
> sys_swapon                                  4210    4211      +1
> swapcache_free_entries                       786     768     -18
> delete_from_swap_cache                       149     104     -45
> __add_to_swap_cache                          445     390     -55
> scan_swap_map_slots                         1953    1889     -64
> swap_do_scheduled_discard                    713     568    -145
> Total: Before=454535, After=454510, chg -0.01%

This looks great!  Thanks!

> But PageSwapCache() is somewhat ugly either way. Even with THP_SWAP
> compiled in, it seems like most callsites wouldn't test tailpages?
> Can we get rid of the compound_head() and annotate any callsites
> working on potential tail pages?

I think we can keep the current #ifdef version and make some cleanup in
the next step?

>> > Please review whether this is an acceptable version for you.
>> 
>> Yes.  It is good for me.  I will give it more test on next Monday.
>
> Thanks

I think we will fold the below patch into the original one?

Best Regards,
Huang, Ying

> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index f4acd6c4f808..d33e3280c8ad 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -326,7 +326,9 @@ PAGEFLAG_FALSE(HighMem)
>  #ifdef CONFIG_SWAP
>  static __always_inline int PageSwapCache(struct page *page)
>  {
> +#ifdef CONFIG_THP_SWAP
>  	page = compound_head(page);
> +#endif
>  	return PageSwapBacked(page) && test_bit(PG_swapcache, &page->flags);
>  
>  }
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 34adac6e9457..a4dba6975e7b 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -401,7 +401,6 @@ extern int swap_duplicate(swp_entry_t);
>  extern int swapcache_prepare(swp_entry_t);
>  extern void swap_free(swp_entry_t);
>  extern void swapcache_free(swp_entry_t);
> -extern void swapcache_free_cluster(swp_entry_t);
>  extern void swapcache_free_entries(swp_entry_t *entries, int n);
>  extern int free_swap_and_cache(swp_entry_t);
>  extern int swap_type_of(dev_t, sector_t, struct block_device **);
> @@ -467,10 +466,6 @@ static inline void swapcache_free(swp_entry_t swp)
>  {
>  }
>  
> -static inline void swapcache_free_cluster(swp_entry_t swp)
> -{
> -}
> -
>  static inline struct page *swapin_readahead(swp_entry_t swp, gfp_t gfp_mask,
>  			struct vm_area_struct *vma, unsigned long addr)
>  {
> @@ -592,5 +587,13 @@ static inline bool mem_cgroup_swap_full(struct page *page)
>  }
>  #endif
>  
> +#ifdef CONFIG_THP_SWAP
> +extern void swapcache_free_cluster(swp_entry_t);
> +#else
> +static inline void swapcache_free_cluster(swp_entry_t swp)
> +{
> +}
> +#endif
> +
>  #endif /* __KERNEL__*/
>  #endif /* _LINUX_SWAP_H */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index f597cabcaab7..eeaf145b2a20 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -825,6 +825,7 @@ static int scan_swap_map_slots(struct swap_info_struct *si,
>  	return n_ret;
>  }
>  
> +#ifdef CONFIG_THP_SWAP
>  static int swap_alloc_cluster(struct swap_info_struct *si, swp_entry_t *slot)
>  {
>  	unsigned long idx;
> @@ -862,6 +863,13 @@ static void swap_free_cluster(struct swap_info_struct *si, unsigned long idx)
>  	unlock_cluster(ci);
>  	swap_range_free(si, offset, SWAPFILE_CLUSTER);
>  }
> +#else
> +static int swap_alloc_cluster(struct swap_info_struct *si, swp_entry_t *slot)
> +{
> +	VM_WARN_ON_ONCE(1);
> +	return 0;
> +}
> +#endif /* CONFIG_THP_SWAP */
>  
>  static unsigned long scan_swap_map(struct swap_info_struct *si,
>  				   unsigned char usage)
> @@ -1145,6 +1153,7 @@ void swapcache_free(swp_entry_t entry)
>  	}
>  }
>  
> +#ifdef CONFIG_THP_SWAP
>  void swapcache_free_cluster(swp_entry_t entry)
>  {
>  	unsigned long offset = swp_offset(entry);
> @@ -1170,6 +1179,7 @@ void swapcache_free_cluster(swp_entry_t entry)
>  	swap_free_cluster(si, idx);
>  	spin_unlock(&si->lock);
>  }
> +#endif /* CONFIG_THP_SWAP */
>  
>  void swapcache_free_entries(swp_entry_t *entries, int n)
>  {
