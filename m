From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 3/3] memcg: atomic update of memcg pointer and other
 bits.
Date: Fri, 23 Mar 2012 10:03:13 +0900
Message-ID: <4F6BCBD1.1030602@jp.fujitsu.com>
References: <4F66E6A5.10804@jp.fujitsu.com> <4F66E85E.6030000@jp.fujitsu.com> <20120322133820.GE18665@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120322133820.GE18665@tiehlicka.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, suleiman@google.com, n-horiguchi@ah.jp.nec.com, khlebnikov@openvz.org, Tejun Heo <tj@kernel.org>

(2012/03/22 22:38), Michal Hocko wrote:

> On Mon 19-03-12 17:03:42, KAMEZAWA Hiroyuki wrote:
> [...]
>> @@ -1237,8 +1237,6 @@ mem_cgroup_get_reclaim_stat_from_page(struct page *page)
>>  	pc = lookup_page_cgroup(page);
>>  	if (!PageCgroupUsed(pc))
>>  		return NULL;
>> -	/* Ensure pc's mem_cgroup is visible after reading PCG_USED. */
>> -	smp_rmb();
>>  	mz = page_cgroup_zoneinfo(pc_to_mem_cgroup(pc), page);
>>  	return &mz->reclaim_stat;
>>  }
>> @@ -2491,16 +2489,7 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
>>  		}
>>  	}
>>  
>> -	pc_set_mem_cgroup(pc, memcg);
>> -	/*
>> -	 * We access a page_cgroup asynchronously without lock_page_cgroup().
>> -	 * Especially when a page_cgroup is taken from a page, pc's mem_cgroup
>> -	 * is accessed after testing USED bit. To make pc's mem_cgroup visible
>> -	 * before USED bit, we need memory barrier here.
>> -	 * See mem_cgroup_add_lru_list(), etc.
>> - 	 */
>> -	smp_wmb();
>> -	SetPageCgroupUsed(pc);
>> +	pc_set_mem_cgroup(pc, memcg, BIT(PCG_USED) | BIT(PCG_LOCK));
> 
> This is not nice. Maybe we need two variants (pc_set_mem_cgroup[_flags])?
> 


Sure. I'll add that.


>>  	if (lrucare) {
>>  		if (was_on_lru) {
>> @@ -2529,7 +2518,6 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
>>  
>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>  
>> -#define PCGF_NOCOPY_AT_SPLIT ((1 << PCG_LOCK) | (1 << PCG_MIGRATION))
>>  /*
>>   * Because tail pages are not marked as "used", set it. We're under
>>   * zone->lru_lock, 'splitting on pmd' and compound_lock.
>> @@ -2547,9 +2535,7 @@ void mem_cgroup_split_huge_fixup(struct page *head)
>>  		return;
>>  	for (i = 1; i < HPAGE_PMD_NR; i++) {
>>  		pc = head_pc + i;
>> -		pc_set_mem_cgroup(pc, memcg);
>> -		smp_wmb();/* see __commit_charge() */
>> -		pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
>> +		pc_set_mem_cgroup(pc, memcg, BIT(PCG_USED));
> 
> Maybe it would be cleaner to remove PCGF_NOCOPY_AT_SPLIT in a separate patch with 
> VM_BUG_ON(!head_pc->flags & BIT(PCG_USED))?
> 


Hm, ok. I'll divide this patch.

>>  	}
>>  }
>>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>> @@ -2616,7 +2602,7 @@ static int mem_cgroup_move_account(struct page *page,
>>  		__mem_cgroup_cancel_charge(from, nr_pages);
>>  
>>  	/* caller should have done css_get */
>> -	pc_set_mem_cgroup(pc, to);
>> +	pc_set_mem_cgroup(pc, to, BIT(PCG_USED) | BIT(PCG_LOCK));
> 
> Same here.
> 


pc_set_mem_cgroup_flags() ?

Thanks,
-Kame

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
