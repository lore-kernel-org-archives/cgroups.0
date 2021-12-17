From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 9/9] block, bfq: decrease
 'num_groups_with_pending_reqs' earlier
Date: Fri, 17 Dec 2021 10:53:13 +0800
Message-ID: <97642e8d-b93c-c229-d13e-76517d5e654f@huawei.com>
References: <20211127101132.486806-1-yukuai3@huawei.com>
 <20211127101132.486806-10-yukuai3@huawei.com>
 <AA66019E-FD14-4821-B53D-0C56EEC38828@linaro.org>
 <4765e7f8-48b7-3bc6-5eb6-1dc0a569233d@huawei.com>
 <B5C2B1F6-4DF9-4657-AFF4-D53DD04A65DC@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B5C2B1F6-4DF9-4657-AFF4-D53DD04A65DC-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

在 2021/12/17 0:34, Paolo Valente 写道:
> 
> 
>> Il giorno 11 dic 2021, alle ore 03:10, yukuai (C) <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> ha scritto:
>>
>> 在 2021/12/10 18:21, Paolo Valente 写道:
>>>> Il giorno 27 nov 2021, alle ore 11:11, Yu Kuai<yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>  ha scritto:
>>>>
>>>> Currently 'num_groups_with_pending_reqs' won't be decreased when
>>>> the group doesn't have any pending requests, while any child group
>>>> have any pending requests. The decrement is delayed to when all the
>>>> child groups doesn't have any pending requests.
>>>>
>>>> For example:
>>>> 1) t1 issue sync io on root group, t2 and t3 issue sync io on the same
>>>> child group. num_groups_with_pending_reqs is 2 now.
>>>> 2) t1 stopped, num_groups_with_pending_reqs is still 2. io from t2 and
>>>> t3 still can't be handled concurrently.
>>>>
>>>> Fix the problem by decreasing 'num_groups_with_pending_reqs'
>>>> immediately upon the deactivation of last entity of the group.
>>>>
>>> I don't understand this patch clearly.
>>> I understand your proposal not to count a group as with pending requests, in case no child process of the group has IO, but only its child groups have pending requests.
>>> So, entities here are only queues for this patch?
>>> If they are only queues, I think it is still incorrect to remove the group from the count of groups with pending IO when all its child queues are deactivated, because there may still be unfinished IO for those queues.
>>
>> Hi, Paolo
>>
>> bfq_weights_tree_remove() will be called when all requests are completed
>> in bfq_queue, thus I recored how many queues have pending requests
>> through weights tree insertion and removal.(Details in patch 7)
>>
>> Thus when calling bfq_weights_tree_remove() for bfqq, I can check if
>> there are no queues have pending requests for parent bfqg:
>>
>> if (!bfqg->num_entities_with_pending_reqs && -> no queues with pending reqs
>>     entity->in_groups_with_pending_reqs) {   -> the group is counted
>>
> 
> Ok, I got confused because you use the term deactivation.  Yet you
> seem to decrement the counter at the right time.  Maybe fix that term,
> in commit messages and comments.

Ok, I'll fix that term, and thanks for taking time reviewing these
patches,
> 
> Thanks,
> Paolo
> 
>> Thanks,
>> Kuai
>>> Am I missing something?
>>> Thanks,
>>> Paolo
> 
> .
> 
