From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: change behavior of moving charges at task move
Date: Fri, 23 Mar 2012 09:18:46 +0900
Message-ID: <4F6BC166.80407@jp.fujitsu.com>
References: <4F69A4C4.4080602@jp.fujitsu.com> <20120322143610.e4df49c9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120322143610.e4df49c9.akpm@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Hugh Dickins <hughd@google.com>, "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@parallels.com>

(2012/03/23 6:36), Andrew Morton wrote:

> On Wed, 21 Mar 2012 18:52:04 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
>>  static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
>>  			unsigned long addr, pte_t ptent, swp_entry_t *entry)
>>  {
>> -	int usage_count;
>>  	struct page *page = NULL;
>>  	swp_entry_t ent = pte_to_swp_entry(ptent);
>>  
>>  	if (!move_anon() || non_swap_entry(ent))
>>  		return NULL;
>> -	usage_count = mem_cgroup_count_swap_user(ent, &page);
>> -	if (usage_count > 1) { /* we don't move shared anon */
>> -		if (page)
>> -			put_page(page);
>> -		return NULL;
>> -	}
>> +#ifdef CONFIG_SWAP
>> +	/*
>> +	 * Avoid lookup_swap_cache() not to update statistics.
>> +	 */
> 
> I don't understand this comment - what is it trying to tell us?
> 


High Dickins advised me to use find_get_page() rather than lookup_swap_cache()
because lookup_swap_cache() has some statistics with swap.

>> +	page = find_get_page(&swapper_space, ent.val);
> 
> The code won't even compile if CONFIG_SWAP=n?
> 

mm/built-in.o: In function `mc_handle_swap_pte':
/home/kamezawa/Kernel/next/linux/mm/memcontrol.c:5172: undefined reference to `swapper_space'
make: *** [.tmp_vmlinux1] Error 1

Ah...but I think this function (mc_handle_swap_pte) itself should be under CONFIG_SWAP.
I'll post v2.

Thank you for review!
-Kame

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
