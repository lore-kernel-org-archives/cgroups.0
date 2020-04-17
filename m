From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v8 03/10] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Fri, 17 Apr 2020 22:39:59 +0800
Message-ID: <2403add7-d468-7615-22c5-3fafb1264d54@linux.alibaba.com>
References: <1579143909-156105-1-git-send-email-alex.shi@linux.alibaba.com>
 <1579143909-156105-4-git-send-email-alex.shi@linux.alibaba.com>
 <20200116215222.GA64230@cmpxchg.org>
 <cdcdb710-1d78-6fac-48d7-35519ddcdc6a@linux.alibaba.com>
 <20200413180725.GA99267@cmpxchg.org>
 <8e7bf170-2bb5-f862-c12b-809f7f7d96cb@linux.alibaba.com>
 <20200414163114.GA136578@cmpxchg.org>
 <54af0662-cbb4-88c7-7eae-f969684025dd@linux.alibaba.com>
 <0bed9f1a-400d-d9a9-aeb4-de1dd9ccbb45@linux.alibaba.com>
 <20200416152830.GA195132@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200416152830.GA195132-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Qian Cai <cai-J5quhbR+WMc@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aneesh Ku



在 2020/4/16 下午11:28, Johannes Weiner 写道:
> Hi Alex,
> 
> On Thu, Apr 16, 2020 at 04:01:20PM +0800, Alex Shi wrote:
>>
>>
>> 在 2020/4/15 下午9:42, Alex Shi 写道:
>>> Hi Johannes,
>>>
>>> Thanks a lot for point out!
>>>
>>> Charging in __read_swap_cache_async would ask for 3 layers function arguments
>>> pass, that would be a bit ugly. Compare to this, could we move out the
>>> lru_cache add after commit_charge, like ksm copied pages?
>>>
>>> That give a bit extra non lru list time, but the page just only be used only
>>> after add_anon_rmap setting. Could it cause troubles?
>>
>> Hi Johannes & Andrew,
>>
>> Doing lru_cache_add_anon during swapin_readahead can give a very short timing 
>> for possible page reclaiming for these few pages.
>>
>> If we delay these few pages lru adding till after the vm_fault target page 
>> get memcg charging(mem_cgroup_commit_charge) and activate, we could skip the 
>> mem_cgroup_try_charge/commit_charge/cancel_charge process in __read_swap_cache_async().
>> But the cost is maximum SWAP_RA_ORDER_CEILING number pages on each cpu miss
>> page reclaiming in a short time. On the other hand, save the target vm_fault
>> page from reclaiming before activate it during that time.
> 
> The readahead pages surrounding the faulting page might never get
> accessed and pile up to large amounts. Users can also trigger
> non-faulting readahead with MADV_WILLNEED.
> 
> So unfortunately, I don't see a way to keep these pages off the
> LRU. They do need to be reclaimable, or they become a DoS vector.
> 
> I'm currently preparing a small patch series to make swap ownership
> tracking an integral part of memcg and change the swapin charging
> sequence, then you don't have to worry about it. This will also
> unblock Joonsoo's "workingset protection/detection on the anonymous
> LRU list" patch series, since he is blocked on the same problem - he
> needs the correct LRU available at swapin time to process refaults
> correctly. Both of your patch series are already pretty large, they
> shouldn't need to also deal with that.
> 

That sounds great!
BTW, the swapin target page will add into inactive_anon list and then activate
after chaged. that left a minum time slot for this page to be reclaimed.
May better activate it early?

Also I have 2 clean up patches, which may or may not useful for you. will send
it to you. :)

Thanks
Alex
