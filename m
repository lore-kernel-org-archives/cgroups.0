From: Greg Thelen <gthelen@google.com>
Subject: Re: [patch] mm: memcontrol: support transparent huge pages under pressure
Date: Tue, 23 Sep 2014 17:07:57 -0700
Message-ID: <xr9338bhkhha.fsf@gthelen.mtv.corp.google.com>
References: <1411132840-16025-1-git-send-email-hannes@cmpxchg.org> <xr934mvykgiv.fsf@gthelen.mtv.corp.google.com> <20140923111657.GA13593@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=references:from:to:cc:subject:date:in-reply-to:message-id
         :mime-version:content-type;
        bh=eKM9364VLlNpQkoGFKLLbaCGutl90YISuSAs5f8pDwQ=;
        b=lGuxx7ULOxJAv5/mGGB/tJmngqzf2D8yiOWRyyG0BEswkcOiJMdMfSGSvwyTm2bXJu
         sGmk6FQ2Rxnr7iCLSU1Oiuxge9VO1FB5ytvOJgoxCgJSOEqt7IhaKyut4e48GOjJdeRA
         e6GnYBXAluxBQbNUkoSQPo3+t3+bHMMG51Od2lIsWDtcOwvHxjuWXVP8Usmx0nwTdy/8
         oSOhFNRgHDABlKfpC2mveSnhRYA1hwABpmUWo22mLkjs5OoiSR/ZqHOssFzcaiJGrADv
         36DWLDDu5ysrWzQWPXHqXjQ3wfn2jNYIPrXvqNjXIA5o8PqDPDOoCnQSQ5Lu4071PeVC
         c2xg==
In-reply-to: <20140923111657.GA13593@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave@sr71.net>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org


On Tue, Sep 23 2014, Johannes Weiner wrote:

> On Mon, Sep 22, 2014 at 10:52:50PM -0700, Greg Thelen wrote:
>> 
>> On Fri, Sep 19 2014, Johannes Weiner wrote:
>> 
>> > In a memcg with even just moderate cache pressure, success rates for
>> > transparent huge page allocations drop to zero, wasting a lot of
>> > effort that the allocator puts into assembling these pages.
>> >
>> > The reason for this is that the memcg reclaim code was never designed
>> > for higher-order charges.  It reclaims in small batches until there is
>> > room for at least one page.  Huge pages charges only succeed when
>> > these batches add up over a series of huge faults, which is unlikely
>> > under any significant load involving order-0 allocations in the group.
>> >
>> > Remove that loop on the memcg side in favor of passing the actual
>> > reclaim goal to direct reclaim, which is already set up and optimized
>> > to meet higher-order goals efficiently.
>> >
>> > This brings memcg's THP policy in line with the system policy: if the
>> > allocator painstakingly assembles a hugepage, memcg will at least make
>> > an honest effort to charge it.  As a result, transparent hugepage
>> > allocation rates amid cache activity are drastically improved:
>> >
>> >                                       vanilla                 patched
>> > pgalloc                 4717530.80 (  +0.00%)   4451376.40 (  -5.64%)
>> > pgfault                  491370.60 (  +0.00%)    225477.40 ( -54.11%)
>> > pgmajfault                    2.00 (  +0.00%)         1.80 (  -6.67%)
>> > thp_fault_alloc               0.00 (  +0.00%)       531.60 (+100.00%)
>> > thp_fault_fallback          749.00 (  +0.00%)       217.40 ( -70.88%)
>> >
>> > [ Note: this may in turn increase memory consumption from internal
>> >   fragmentation, which is an inherent risk of transparent hugepages.
>> >   Some setups may have to adjust the memcg limits accordingly to
>> >   accomodate this - or, if the machine is already packed to capacity,
>> >   disable the transparent huge page feature. ]
>> 
>> We're using an earlier version of this patch, so I approve of the
>> general direction.  But I have some feedback.
>> 
>> The memsw aspect of this change seems somewhat separate.  Can it be
>> split into a different patch?
>> 
>> The memsw aspect of this patch seems to change behavior.  Is this
>> intended?  If so, a mention of it in the commit log would assuage the
>> reader.  I'll explain...  Assume a machine with swap enabled and
>> res.limit==memsw.limit, thus memsw_is_minimum is true.  My understanding
>> is that memsw.usage represents sum(ram_usage, swap_usage).  So when
>> memsw_is_minimum=true, then both swap_usage=0 and
>> memsw.usage==res.usage.  In this condition, if res usage is at limit
>> then there's no point in swapping because memsw.usage is already
>> maximal.  Prior to this patch I think the kernel did the right thing,
>> but not afterwards.
>> 
>> Before this patch:
>>   if res.usage == res.limit, try_charge() indirectly calls
>>   try_to_free_mem_cgroup_pages(noswap=true)
>> 
>> After this patch:
>>   if res.usage == res.limit, try_charge() calls
>>   try_to_free_mem_cgroup_pages(may_swap=true)
>> 
>> Notice the inverted swap-is-allowed value.
>
> For some reason I had myself convinced that this is dead code due to a
> change in callsites a long time ago, but you are right that currently
> try_charge() relies on it, thanks for pointing it out.
>
> However, memsw is always equal to or bigger than the memory limit - so
> instead of keeping a separate state variable to track when memory
> failure implies memsw failure, couldn't we just charge memsw first?
>
> How about the following?  But yeah, I'd split this into a separate
> patch now.

Looks good to me.  Thanks.

Acked-by: Greg Thelen <gthelen@google.com>

> ---
>  mm/memcontrol.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e2def11f1ec1..7c9a8971d0f4 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2497,16 +2497,17 @@ retry:
>  		goto done;
>  
>  	size = batch * PAGE_SIZE;
> -	if (!res_counter_charge(&memcg->res, size, &fail_res)) {
> -		if (!do_swap_account)
> +	if (!do_swap_account ||
> +	    !res_counter_charge(&memcg->memsw, size, &fail_res)) {
> +		if (!res_counter_charge(&memcg->res, size, &fail_res))
>  			goto done_restock;
> -		if (!res_counter_charge(&memcg->memsw, size, &fail_res))
> -			goto done_restock;
> -		res_counter_uncharge(&memcg->res, size);
> +		if (do_swap_account)
> +			res_counter_uncharge(&memcg->memsw, size);
> +		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
> +	} else {
>  		mem_over_limit = mem_cgroup_from_res_counter(fail_res, memsw);
>  		may_swap = false;
> -	} else
> -		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
> +	}
>  
>  	if (batch > nr_pages) {
>  		batch = nr_pages;

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
