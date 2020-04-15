From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v8 03/10] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Wed, 15 Apr 2020 21:42:26 +0800
Message-ID: <54af0662-cbb4-88c7-7eae-f969684025dd@linux.alibaba.com>
References: <1579143909-156105-1-git-send-email-alex.shi@linux.alibaba.com>
 <1579143909-156105-4-git-send-email-alex.shi@linux.alibaba.com>
 <20200116215222.GA64230@cmpxchg.org>
 <cdcdb710-1d78-6fac-48d7-35519ddcdc6a@linux.alibaba.com>
 <20200413180725.GA99267@cmpxchg.org>
 <8e7bf170-2bb5-f862-c12b-809f7f7d96cb@linux.alibaba.com>
 <20200414163114.GA136578@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200414163114.GA136578-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Qian Cai <cai-J5quhbR+WMc@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aneesh Ku



在 2020/4/15 上午12:31, Johannes Weiner 写道:
> On Tue, Apr 14, 2020 at 12:52:30PM +0800, Alex Shi wrote:
>> 在 2020/4/14 上午2:07, Johannes Weiner 写道:
>>> Plus, the overhead of tracking is tiny - 512k per G of swap (0.04%).
>>>
>>> Maybe we should just delete MEMCG_SWAP and unconditionally track swap
>>> entry ownership when the memory controller is enabled. I don't see a
>>> good reason not to, and it would simplify the entire swapin path, the
>>> LRU locking, and the page->mem_cgroup stabilization rules.
>>>
>>
>> Sorry for not follow you up, did you mean just remove the MEMCG_SWAP configuration
>> and keep the feature in default memcg? 
> 
> Yes.
> 
>> That does can remove lrucare, but PageLRU lock scheme still fails since
>> we can not isolate the page during commit_charge, is that right?
> 
> No, without lrucare the scheme works. Charges usually do:
> 
> page->mem_cgroup = new;
> SetPageLRU(page);
> 
> And so if you can TestClearPageLRU(), page->mem_cgroup is stable.
> 
> lrucare charging is the exception: it changes page->mem_cgroup AFTER
> PageLRU has already been set, and even when it CANNOT acquire the
> PageLRU lock itself. It violates the rules.
> 
> If we make MEMCG_SWAP mandatory, we always have cgroup records for
> swapped out pages. That means we can charge all swapin pages
> (incl. readahead pages) directly in __read_swap_cache_async(), before
> setting PageLRU on the new pages.
> 
> Then we can delete lrucare.
> 
> And then TestClearPageLRU() guarantees page->mem_cgroup is stable.
> 

Hi Johannes,

Thanks a lot for point out!

Charging in __read_swap_cache_async would ask for 3 layers function arguments
pass, that would be a bit ugly. Compare to this, could we move out the
lru_cache add after commit_charge, like ksm copied pages?

That give a bit extra non lru list time, but the page just only be used only
after add_anon_rmap setting. Could it cause troubles?

I tried to track down the reason of lru_cache_add here, but no explanation
till first git kernel commit.

Thanks
Alex 

