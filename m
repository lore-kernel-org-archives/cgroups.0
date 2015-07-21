From: Nikolay Borisov <n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Subject: Re: Access rules for current->memcg
Date: Tue, 21 Jul 2015 13:32:23 +0300
Message-ID: <55AE1FB7.8050107@siteground.com>
References: <20150716145902.GA10758@dhcp22.suse.cz> <55A7C9B4.3010907@siteground.com> <20150716152239.GA22529@dhcp22.suse.cz> <CAJFSNy6sLX82+3ZW_COr__pDTd9aSGgL1bjryMKKcVPhEN0F9g@mail.gmail.com> <20150717071339.GA24787@dhcp22.suse.cz> <55A8ABC9.7090701@siteground.com> <20150720111707.GE1211@dhcp22.suse.cz> <55ACD9F8.2040802@siteground.com> <20150721074834.GF11967@dhcp22.suse.cz> <55AE0C18.5000304@siteground.com> <20150721094832.GI11967@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150721094832.GI11967-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 07/21/2015 12:48 PM, Michal Hocko wrote:
> On Tue 21-07-15 12:08:40, Nikolay Borisov wrote:
>>
>>
>> On 07/21/2015 10:48 AM, Michal Hocko wrote:
>>> On Mon 20-07-15 14:22:32, Nikolay Borisov wrote:
>>>>
>>>>
>>>> On 07/20/2015 02:17 PM, Michal Hocko wrote:
>>>>> On Fri 17-07-15 10:16:25, Nikolay Borisov wrote:
>>>>>>
>>>>>>
>>>>>> On 07/17/2015 10:13 AM, Michal Hocko wrote:
>>>>>>> On Fri 17-07-15 00:21:51, Nikolay Borisov wrote:
>>>>> [...]
>>>>>>>> In my particular use case I have to query the memcg's various counters to expose
>>>>>>>> them to the user in a different way than via the cgroup files
>>>>>>>> (memory.limit_in_bytes etc).
>>>>>>>
>>>>>>> Why is the regular interface not sufficient?
>>>>>>
>>>>>> In my particular case I'm interested in playing with the contents of
>>>>>> /proc/meminfo, so that processes running inside a cgroup only see the
>>>>>> the system as defined by the memcg restrictions
>>>>>
>>>>> I assume that this is an attempt to containerize /proc/meminfo. I am not
>>>>> sure this is a great idea. There are counters which do not have memcg
>>>>> specific counterpart or such a counterpart would be missleading (e.g.
>>>>> slab, swap statistics).
>>>>
>>>> Why would swap be misleading?
>>>
>>> Because the swap space is inherently a shared resource.
>>>
>>>> What about memsw.limit_in_bytes - memory.limit_in_bytes for the total swap
>>>
>>> No this is not how the swap extension works. memsw counter covers
>>> usage+swap. You can have up to memsw.limit_in_bytes swapped out. So
>>
>> I think you are wrong with that assumption. According to the
>> documentation here:
>> https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Resource_Management_Guide/sec-memory.html
>> (the box titled "Setting the memory.memsw.limit_in_bytes and
>> memory.limit_in_bytes parameters") it seems that the space that could be
>> swapped is actually memsw.limit_in_bytes  - memory.limit_in_bytes.
>>
>> The way I understand is you will only start swapping after the limit in
>> memory.limit_in_bytes has been exhausted and you will be able to swap
>> only until memsw.limit_in_bytes is exhausted (but since
>> memory.usage_in_bytes is already calculated in, which would equal to
>> memory.limit_in_bytes in a memory pressure situation) you effectively
>> have memsw.limit_in_bytes - memory.limit_in_bytes, no?
> 
> No. Your memory might get swapped out even before you hit the hard
> limit if there is an external memory pressure. This would be either
> a global memory pressure or a hard limit triggered up in the hierarchy.
> 
> Take the most trivial situation when memsw and hard limits are equal. You
> would have a 0 swap space which is not the case obviously.
> 
> Please have a look at Documentation/cgroups/memory.txt and '2.4 Swap
> Extension (CONFIG_MEMCG_SWAP)' for more information.
> 
>>> you would have to do min(memsw.limit_in_bytes, TotalSwap) but even then
>>> it wouldn't tell you much because that would be the case for other
>>> memory cgroups as well. I would be quite hard to distribute the
>>> TotalSwap for all the cgroups.
>>>
>>>> and calculating the swap usage
>>>> based on memory.memsw.max_usage_in_bytes - memory.usage_in_bytes ?
>>>
>>> This doesn't make much sense to me. Swap usage per memcg is exported by
>>> memory.stat file. But this is not what you want to export. meminfo
>>> exports SwapFree which would tell you how much memory could be swapped
>>> out before the anonymous memory is not reclaimable anymore. This is
>>> impossible to find out in general - especially when the system is
>>> allowed to be overcommit.
>>
>> I looked more carefully into the code and saw that the page_counters
>> (which back memory/memsw.limit/usage_in_bytes) are charged during the
>> try_charge whereas the per-cpu statistics (which back the info in
>> memory.stats) are updated after committing the charge. I assume in the
>> case where charges are not canceled the data in memory.stats and
>> memory.memsw.max_usage_in_bytes - memory.usage_in_bytes should be identical?
> 
> I am not sure what you mean here. max_usage_in_bytes is a historical
> value which was the maximum charge used at some point in time.
> usage_in_bytes is always the _current_ value of the charge counter.
> max_usage_in_bytes-usage_in_bytes doesn't tell you much really.
> 

I have misunderstood me I have never, ever referred to max_usage. What I
meant was that the information that memory.stat file provides is
acquired by reading the memcg->stat->count[counter] and those values are
updated when mem_cgroup_commit_charge() is invoked. And
mem_cgroup_commit_charge is invoked AFTER mem_cgroup_try_charge, which
updates the charge counters. So my point was that whether I read the
swap value (for example) from the memory.stats file or whether I
manually do the maths with subtraction  as previously shown the 2 values
should match.

Essentially whether information should be queried form the charge
counter or from the mem_cgroup_stat_cpu struct. Does that make sense?
