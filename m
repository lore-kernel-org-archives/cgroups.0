From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: =?UTF-8?B?UmU6IOetlOWkjTog562U5aSNOiBbUEFUQ0hdIG1tL21lbWNvbnRyb2wu?=
 =?UTF-8?Q?c:_speed_up_to_force_empty_a_memory_cgroup?=
Date: Wed, 21 Mar 2018 01:08:02 +0300
Message-ID: <56508bd0-e8d7-55fd-5109-c8dacf26b13e@virtuozzo.com>
References: <1521448170-19482-1-git-send-email-lirongqing@baidu.com>
 <20180319085355.GQ23100@dhcp22.suse.cz>
 <2AD939572F25A448A3AE3CAEA61328C23745764B@BC-MAIL-M28.internal.baidu.com>
 <20180319103756.GV23100@dhcp22.suse.cz>
 <2AD939572F25A448A3AE3CAEA61328C2374589DC@BC-MAIL-M28.internal.baidu.com>
 <alpine.DEB.2.20.1803191044310.177918@chino.kir.corp.google.com>
 <20180320083950.GD23100@dhcp22.suse.cz>
 <alpine.DEB.2.20.1803201327060.167205@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=MpvNwWwagnePeXMpWrVY8sMBCtPzlsn34NnYhjp1eCk=;
 b=bTGe/0atQGXTWo2Cy+jyJiEcs9YXe8ODFZin/fOdqVvjNKFOX3LPOTuIkvMqhEwU3B01Hn77hTuzJrOyCgfz8FD+Awuf8uW4WuJcV6RrNyPhWv0Mm4DwLFq6NYt9VmFv620xHRjTEXWo5CSmLjX0WHp15YcY5LHD1Z05X3UsQDY=
In-Reply-To: <alpine.DEB.2.20.1803201327060.167205@chino.kir.corp.google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@kernel.org>
Cc: "Li,Rongqing" <lirongqing@baidu.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>



On 03/20/2018 11:29 PM, David Rientjes wrote:
> On Tue, 20 Mar 2018, Michal Hocko wrote:
> 
>>>>>> Although SWAP_CLUSTER_MAX is used at the lower level, but the call
>>>>>> stack of try_to_free_mem_cgroup_pages is too long, increase the
>>>>>> nr_to_reclaim can reduce times of calling
>>>>>> function[do_try_to_free_pages, shrink_zones, hrink_node ]
>>>>>>
>>>>>> mem_cgroup_resize_limit
>>>>>> --->try_to_free_mem_cgroup_pages:  .nr_to_reclaim = max(1024,
>>>>>> --->SWAP_CLUSTER_MAX),
>>>>>>    ---> do_try_to_free_pages
>>>>>>      ---> shrink_zones
>>>>>>       --->shrink_node
>>>>>>        ---> shrink_node_memcg
>>>>>>          ---> shrink_list          <-------loop will happen in this place
>>>>> [times=1024/32]
>>>>>>            ---> shrink_page_list
>>>>>
>>>>> Can you actually measure this to be the culprit. Because we should rethink
>>>>> our call path if it is too complicated/deep to perform well.
>>>>> Adding arbitrary batch sizes doesn't sound like a good way to go to me.
>>>>
>>>> Ok, I will try
>>>>
>>>
>>> Looping in mem_cgroup_resize_limit(), which takes memcg_limit_mutex on 
>>> every iteration which contends with lowering limits in other cgroups (on 
>>> our systems, thousands), calling try_to_free_mem_cgroup_pages() with less 
>>> than SWAP_CLUSTER_MAX is lame.
>>
>> Well, if the global lock is a bottleneck in your deployments then we
>> can come up with something more clever. E.g. per hierarchy locking
>> or even drop the lock for the reclaim altogether. If we reclaim in
>> SWAP_CLUSTER_MAX then the potential over-reclaim risk quite low when
>> multiple users are shrinking the same (sub)hierarchy.
>>
> 
> I don't believe this to be a bottleneck if nr_pages is increased in 
> mem_cgroup_resize_limit().
> 
>>> It would probably be best to limit the 
>>> nr_pages to the amount that needs to be reclaimed, though, rather than 
>>> over reclaiming.
>>
>> How do you achieve that? The charging path is not synchornized with the
>> shrinking one at all.
>>
> 
> The point is to get a better guess at how many pages, up to 
> SWAP_CLUSTER_MAX, that need to be reclaimed instead of 1.
> 
>>> If you wanted to be invasive, you could change page_counter_limit() to 
>>> return the count - limit, fix up the callers that look for -EBUSY, and 
>>> then use max(val, SWAP_CLUSTER_MAX) as your nr_pages.
>>
>> I am not sure I understand
>>
> 
> Have page_counter_limit() return the number of pages over limit, i.e. 
> count - limit, since it compares the two anyway.  Fix up existing callers 
> and then clamp that value to SWAP_CLUSTER_MAX in 
> mem_cgroup_resize_limit().  It's a more accurate guess than either 1 or 
> 1024.
> 

JFYI, it's never 1, it's always SWAP_CLUSTER_MAX.
See try_to_free_mem_cgroup_pages():
....	
	struct scan_control sc = {
		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),

