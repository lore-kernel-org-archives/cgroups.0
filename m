From: "Huang\, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -mm -v9 1/3] mm, THP, swap: Delay splitting THP during swap out
Date: Thu, 20 Apr 2017 08:43:12 +0800
Message-ID: <87inlzrjrz.fsf@yhuang-dev.intel.com>
References: <20170419070625.19776-1-ying.huang@intel.com>
        <20170419070625.19776-2-ying.huang@intel.com>
        <20170419155252.GA3376@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170419155252.GA3376-druUgvl0LCNAfugRpC6u6w@public.gmane.org> (Johannes Weiner's message of
        "Wed, 19 Apr 2017 11:52:52 -0400")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ebru Akagunduz <ebru.akagunduz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi, Johannes,

Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> writes:

> On Wed, Apr 19, 2017 at 03:06:23PM +0800, Huang, Ying wrote:
>> @@ -206,17 +212,34 @@ int add_to_swap(struct page *page, struct list_head *list)
>>  	 */
>>  	err = add_to_swap_cache(page, entry,
>>  			__GFP_HIGH|__GFP_NOMEMALLOC|__GFP_NOWARN);
>> -
>> -	if (!err) {
>> -		return 1;
>> -	} else {	/* -ENOMEM radix-tree allocation failure */
>> +	/* -ENOMEM radix-tree allocation failure */
>> +	if (err)
>>  		/*
>>  		 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
>>  		 * clear SWAP_HAS_CACHE flag.
>>  		 */
>> -		swapcache_free(entry);
>> -		return 0;
>> +		goto fail_free;
>> +
>> +	if (unlikely(PageTransHuge(page))) {
>> +		err = split_huge_page_to_list(page, list);
>> +		if (err) {
>> +			delete_from_swap_cache(page);
>> +			return 0;
>> +		}
>>  	}
>> +
>> +	return 1;
>> +
>> +fail_free:
>> +	if (unlikely(PageTransHuge(page)))
>> +		swapcache_free_cluster(entry);
>> +	else
>> +		swapcache_free(entry);
>> +fail:
>> +	if (unlikely(PageTransHuge(page)) &&
>> +	    !split_huge_page_to_list(page, list))
>> +		goto retry;
>
> May I ask why you added the unlikelies there? Can you generally say
> THPs are unlikely in this path? Is the swap-out path so hot that
> branch layout is critical? I doubt either is true.

I just found there are unlikely() encloses PageTransHuge() in the
original add_to_swap(), so I just follow the original style.  But I
don't think they make much sense too.  Will remove them in the next
version.

> Also please mention changes like these in the changelog next time.

Sorry and will do that in the future.

Best Regards,
Huang, Ying
