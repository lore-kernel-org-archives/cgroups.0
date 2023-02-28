From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cpuset: Remove unused cpuset_node_allowed
Date: Tue, 28 Feb 2023 11:13:33 +0800
Message-ID: <802cb319-37d9-c5a7-46f3-73e729a27239@shopee.com>
References: <20230227080719.20280-1-haifeng.xu@shopee.com>
 <9953284e-05da-56b0-047d-ecf18aa53892@redhat.com>
 <0222742e-3c31-b75d-6027-3b6da2be16be@shopee.com>
 <d6df5140-ed7c-2c12-8e5a-d5c3fbf30a47@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1677554016;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pOmm/Vo67LFh2DeLQEl+PyGHp2QpvdcC8yMg1+l9oPo=;
        b=R1jqaA2eIonxb4RUDB15L7AxwldFeSpdbxSp05n/iPBlv6erUG5rKVF8HpSmd3yCsS
         l+9VL9FZS65HaOxr9D0t8IMxGDUaNU7gYPtc7boarOzEUUHtVwR2iJp4uE0euYThZJHW
         GBp99ckTO6UbgYy2kMGQltmQSAthhenH9IgYF8AjeN4voefOBtBHBQp073UJOib6EaOs
         ap1RxkorRzhb9lM6Cl0YvI+WoVwLn7IyBP2aGaS9ClWMPnkdR4xoQRzWGuU9accbOcug
         bFaBu5XYT8C+Fr49LBDla0PVjKcvZiJG33QTQTAgSUyLRJi0ZJlG2VpXKl3fd6ShNLly
         dTPg==
In-Reply-To: <d6df5140-ed7c-2c12-8e5a-d5c3fbf30a47-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2023/2/28 10:52, Waiman Long wrote:
> On 2/27/23 21:40, Haifeng Xu wrote:
>>
>> On 2023/2/27 22:56, Waiman Long wrote:
>>> On 2/27/23 03:07, Haifeng Xu wrote:
>>>> Commit 002f290627c2 ("cpuset: use static key better and convert to new API")
>>>> has used __cpuset_node_allowed instead of cpuset_node_allowed to check
>>>> whether we can allocate on a memory node. Now this function isn't used by
>>>> anyone, so we can remove it safely.
>>>>
>>>> Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>>    include/linux/cpuset.h | 12 ------------
>>>>    1 file changed, 12 deletions(-)
>>>>
>>>> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
>>>> index d58e0476ee8e..7fad5afe3bba 100644
>>>> --- a/include/linux/cpuset.h
>>>> +++ b/include/linux/cpuset.h
>>>> @@ -82,13 +82,6 @@ int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
>>>>      extern bool __cpuset_node_allowed(int node, gfp_t gfp_mask);
>>>>    -static inline bool cpuset_node_allowed(int node, gfp_t gfp_mask)
>>>> -{
>>>> -    if (cpusets_enabled())
>>>> -        return __cpuset_node_allowed(node, gfp_mask);
>>>> -    return true;
>>>> -}
>>>> -
>>>>    static inline bool __cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
>>>>    {
>>>>        return __cpuset_node_allowed(zone_to_nid(z), gfp_mask);
>>>> @@ -223,11 +216,6 @@ static inline int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
>>>>        return 1;
>>>>    }
>>>>    -static inline bool cpuset_node_allowed(int node, gfp_t gfp_mask)
>>>> -{
>>>> -    return true;
>>>> -}
>>>> -
>>>>    static inline bool __cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
>>>>    {
>>>>        return true;
>>> The kernel convention is to add a "__" prefix to a function name if there is higher level helper without the "__" prefix that uses it. Since cpuset_node_allowed() is no longer used. We should just rename __cpuset_node_allowed() to cpuset_node_allowed() and get rid of the unused helper. A bit more code changes are needed for this, though.
>>>
>>> Cheers,
>>> Longman
>>>
>> Maybe we can still use cpuset_node_allowed in __cpuset_zone_allowed? If so, less code need to be changed.
>>
> mm/page_alloc.c has 2 references to __cpuset_node_allowed() in their comments. These references should also be updated as well. That is why I said a bit more code needs to be touched.
> 
> Cheers,
> Longman
> 

Ok. I mean maybe we could keep cpuset_node_allowed() and use it in __cpuset_zone_allowed(). So we don't need rename __cpuset_node_allowed() or update releated comments.

Thanks.
