From: Liu Shixin <liushixin2@huawei.com>
Subject: Re: [PATCH v3] mm: vmscan: try to reclaim swapcache pages if no swap
 space
Date: Mon, 28 Aug 2023 15:11:19 +0800
Message-ID: <2992c888-b8c7-d93b-d132-ea90e2c516e3@huawei.com>
References: <20230826034401.640861-1-liushixin2@huawei.com>
 <87il9053zo.fsf@yhuang6-desk2.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87il9053zo.fsf@yhuang6-desk2.ccr.corp.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org



On 2023/8/28 9:51, Huang, Ying wrote:
> Liu Shixin <liushixin2@huawei.com> writes:
>
>> When spaces of swap devices are exhausted, only file pages can be reclaimed.
>> But there are still some swapcache pages in anon lru list. This can lead
>> to a premature out-of-memory.
>>
>> This problem can be fixed by checking number of swapcache pages in
>> can_reclaim_anon_pages().
>>
>> Add a new bit swapcache_only in struct scan_control to skip isolating anon
>> pages that are not in the swap cache when only swap cache can be reclaimed.
> Better to describe how you test the patch and test results.
OK, I will add the infomation.
>
>> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
>> ---
>>  include/linux/swap.h |  6 ++++++
>>  mm/memcontrol.c      |  8 ++++++++
>>  mm/vmscan.c          | 29 +++++++++++++++++++++++++++--
>>  3 files changed, 41 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>> index 456546443f1f..0318e918bfa4 100644
>> --- a/include/linux/swap.h
>> +++ b/include/linux/swap.h
>> @@ -669,6 +669,7 @@ static inline void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_p
>>  }
>>  
>>  extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
>> +extern long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg);
>>  extern bool mem_cgroup_swap_full(struct folio *folio);
>>  #else
>>  static inline void mem_cgroup_swapout(struct folio *folio, swp_entry_t entry)
>> @@ -691,6 +692,11 @@ static inline long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
>>  	return get_nr_swap_pages();
>>  }
>>  
>> +static inline long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg)
>> +{
>> +	return total_swapcache_pages();
>> +}
>> +
>>  static inline bool mem_cgroup_swap_full(struct folio *folio)
>>  {
>>  	return vm_swap_full();
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index e8ca4bdcb03c..c465829db92b 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -7567,6 +7567,14 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
>>  	return nr_swap_pages;
>>  }
>>  
>> +long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg)
>> +{
>> +	if (mem_cgroup_disabled())
>> +		return total_swapcache_pages();
>> +
>> +	return memcg_page_state(memcg, NR_SWAPCACHE);
>> +}
>> +
>>  bool mem_cgroup_swap_full(struct folio *folio)
>>  {
>>  	struct mem_cgroup *memcg;
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 7c33c5b653ef..5cb4adf6642b 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -137,6 +137,9 @@ struct scan_control {
>>  	/* Always discard instead of demoting to lower tier memory */
>>  	unsigned int no_demotion:1;
>>  
>> +	/* Swap space is exhausted, only reclaim swapcache for anon LRU */
>> +	unsigned int swapcache_only:1;
>> +
>>  	/* Allocation order */
>>  	s8 order;
>>  
>> @@ -613,10 +616,20 @@ static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
>>  		 */
>>  		if (get_nr_swap_pages() > 0)
>>  			return true;
>> +		/* Is there any swapcache pages to reclaim? */
>> +		if (total_swapcache_pages() > 0) {
>> +			sc->swapcache_only = 1;
>> +			return true;
>> +		}
>>  	} else {
>>  		/* Is the memcg below its swap limit? */
>>  		if (mem_cgroup_get_nr_swap_pages(memcg) > 0)
>>  			return true;
>> +		/* Is there any swapcache pages in memcg to reclaim? */
>> +		if (mem_cgroup_get_nr_swapcache_pages(memcg) > 0) {
>> +			sc->swapcache_only = 1;
>> +			return true;
>> +		}
>>  	}
>>  
>>  	/*
>> @@ -2280,6 +2293,19 @@ static bool skip_cma(struct folio *folio, struct scan_control *sc)
>>  }
>>  #endif
>>  
>> +static bool skip_isolate(struct folio *folio, struct scan_control *sc,
>> +			 enum lru_list lru)
>> +{
>> +	if (folio_zonenum(folio) > sc->reclaim_idx)
>> +		return true;
>> +	if (skip_cma(folio, sc))
>> +		return true;
>> +	if (unlikely(sc->swapcache_only && !is_file_lru(lru) &&
>> +	    !folio_test_swapcache(folio)))
> Just
>
> 	if (unlikely(sc->swapcache_only && !folio_test_swapcache(folio)))
>
> is enough.
That would results the file pages to be skipped too, but what expected is to skip non-swapcache
pages in anon lru list. So I think the condition !is_file_lru(lru) is required.

Thanks,
>
>> +		return true;
>> +	return false;
>> +}
>> +
>>  /*
>>   * Isolating page from the lruvec to fill in @dst list by nr_to_scan times.
>>   *
>> @@ -2326,8 +2352,7 @@ static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
>>  		nr_pages = folio_nr_pages(folio);
>>  		total_scan += nr_pages;
>>  
>> -		if (folio_zonenum(folio) > sc->reclaim_idx ||
>> -				skip_cma(folio, sc)) {
>> +		if (skip_isolate(folio, sc, lru)) {
>>  			nr_skipped[folio_zonenum(folio)] += nr_pages;
>>  			move_to = &folios_skipped;
>>  			goto move;
> --
> Best Regards,
> Huang, Ying
> .
>

