From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next 10/11] block, bfq: decrease
 'num_groups_with_pending_reqs' earlier
Date: Fri, 15 Apr 2022 09:10:06 +0800
Message-ID: <ef7bad8c-b8dd-f625-330c-9a22e303844b@huawei.com>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
 <20220305091205.4188398-11-yukuai3@huawei.com>
 <20220413112816.fwobg4cp6ttpnpk6@quack3.lan>
 <f3ed507a-7c85-cd69-3ad5-3e9c0e75c372@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f3ed507a-7c85-cd69-3ad5-3e9c0e75c372-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

在 2022/04/13 19:40, yukuai (C) 写道:
> 在 2022/04/13 19:28, Jan Kara 写道:
>> On Sat 05-03-22 17:12:04, Yu Kuai wrote:
>>> Currently 'num_groups_with_pending_reqs' won't be decreased when
>>> the group doesn't have any pending requests, while some child group
>>> still have pending requests. The decrement is delayed to when all the
>>> child groups doesn't have any pending requests.
>>>
>>> For example:
>>> 1) t1 issue sync io on root group, t2 and t3 issue sync io on the same
>>> child group. num_groups_with_pending_reqs is 2 now.
>>> 2) t1 stopped, num_groups_with_pending_reqs is still 2. io from t2 and
>>> t3 still can't be handled concurrently.
>>>
>>> Fix the problem by decreasing 'num_groups_with_pending_reqs'
>>> immediately upon the weights_tree removal of last bfqq of the group.
>>>
>>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> So I'd find the logic easier to follow if you completely removed
>> entity->in_groups_with_pending_reqs and did updates of
>> bfqd->num_groups_with_pending_reqs like:
>>
>>     if (!bfqg->num_entities_with_pending_reqs++)
>>         bfqd->num_groups_with_pending_reqs++;
>>
> Hi,
> 
> Indeed, this is an excellent idle, and much better than the way I did.
> 
> Thanks,
> Kuai
> 
>> and similarly on the remove side. And there would we literally two places
>> (addition & removal from weight tree) that would need to touch these
>> counters. Pretty obvious and all can be done in patch 9.
>>
>>                                 Honza
Hi, Jan

I think with this change, we can count root_group while activating bfqqs
that are under root_group, thus there is no need to modify
for_each_entity(or fake bfq_sched_data) any more.

The special case is that weight racing bfqqs are not inserted into
weights tree, and I think this can be handled by adding a fake
bfq_weight_counter for such bfqqs.

What do you think ?

Kuai
