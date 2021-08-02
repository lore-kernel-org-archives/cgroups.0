From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] mm, memcg: avoid possible NULL pointer dereferencing
 in mem_cgroup_init()
Date: Mon, 2 Aug 2021 19:18:20 +0800
Message-ID: <59122ae4-52c9-4ff9-104d-872d770dec0c@huawei.com>
References: <20210729125755.16871-1-linmiaohe@huawei.com>
 <20210729125755.16871-5-linmiaohe@huawei.com> <YQNuK+jN7pZLJTvT@carbon.lan>
 <YQOf0TKOXpGRQFHF@dhcp22.suse.cz>
 <f7a22702-cd08-6b15-48c7-68523c38060b@huawei.com>
 <YQeUATTCVMd1D7Ra@dhcp22.suse.cz>
 <47daf062-f510-edb3-6ec7-f8e7615ad8a0@huawei.com>
 <YQfMISKHetFOm1Kx@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YQfMISKHetFOm1Kx-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2021/8/2 18:42, Michal Hocko wrote:
> On Mon 02-08-21 18:00:10, Miaohe Lin wrote:
>> On 2021/8/2 14:43, Michal Hocko wrote:
>>> On Sat 31-07-21 10:05:51, Miaohe Lin wrote:
>>>> On 2021/7/30 14:44, Michal Hocko wrote:
>>>>> On Thu 29-07-21 20:12:43, Roman Gushchin wrote:
>>>>>> On Thu, Jul 29, 2021 at 08:57:54PM +0800, Miaohe Lin wrote:
>>>>>>> rtpn might be NULL in very rare case. We have better to check it before
>>>>>>> dereferencing it. Since memcg can live with NULL rb_tree_per_node in
>>>>>>> soft_limit_tree, warn this case and continue.
>>>>>>>
>>>>>>> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>>>>> ---
>>>>>>>  mm/memcontrol.c | 2 ++
>>>>>>>  1 file changed, 2 insertions(+)
>>>>>>>
>>>>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>>>>> index 5b4592d1e0f2..70a32174e7c4 100644
>>>>>>> --- a/mm/memcontrol.c
>>>>>>> +++ b/mm/memcontrol.c
>>>>>>> @@ -7109,6 +7109,8 @@ static int __init mem_cgroup_init(void)
>>>>>>>  		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
>>>>>>>  				    node_online(node) ? node : NUMA_NO_NODE);
>>>>>>>  
>>>>>>> +		if (WARN_ON_ONCE(!rtpn))
>>>>>>> +			continue;
>>>>>>
>>>>>> I also really doubt that it makes any sense to continue in this case.
>>>>>> If this allocations fails (at the very beginning of the system's life, it's an __init function),
>>>>>> something is terribly wrong and panic'ing on a NULL-pointer dereference sounds like
>>>>>> a perfect choice.
>>>>>
>>>>> Moreover this is 24B allocation during early boot. Kernel will OOM and
>>>>> panic when not being able to find any victim. I do not think we need to
>>>>
>>>> Agree with you. But IMO it may not be a good idea to leave the rtpn without NULL check. We should defend
>>>> it though it could hardly happen. But I'm not insist on this check. I will drop this patch if you insist.
>>>
>>> It is not that I would insist. I just do not see any point in the code
>>> churn. This check is not going to ever trigger and there is nothing you
>>> can do to recover anyway so crashing the kernel is likely the only
>>> choice left.
>>>
>>
>> I hope I get the point now. What you mean is nothing we can do to recover and panic'ing on a
>> NULL-pointer dereference is a perfect choice ? Should we declare that we leave the rtpn without
>> NULL check on purpose like below ?
>>
>> Many thanks.
>>
>> @@ -7109,8 +7109,12 @@ static int __init mem_cgroup_init(void)
>>                 rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
>>                                     node_online(node) ? node : NUMA_NO_NODE);
>>
>> -               if (WARN_ON_ONCE(!rtpn))
>> -                       continue;
>> +               /*
>> +                * If this allocation fails (at the very beginning of the
>> +                * system's life, it's an __init function), something is
>> +                * terribly wrong and panic'ing on a NULL-pointer
>> +                * dereference sounds like a perfect choice.
>> +                */
> 
> I am not really sure this is really worth it. Really we do not really
> want to have similar comments all over the early init code, do we?

Maybe not. Will drop this patch.

Thanks.

> 
>>                 rtpn->rb_root = RB_ROOT;
>>                 rtpn->rb_rightmost = NULL;
>>                 spin_lock_init(&rtpn->lock);
> 

