From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next 10/11] block, bfq: decrease
 'num_groups_with_pending_reqs' earlier
Date: Tue, 19 Apr 2022 19:37:11 +0800
Message-ID: <d088c184-b67f-1afb-5f1c-0e166c665c50@huawei.com>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
 <20220305091205.4188398-11-yukuai3@huawei.com>
 <20220413112816.fwobg4cp6ttpnpk6@quack3.lan>
 <f3ed507a-7c85-cd69-3ad5-3e9c0e75c372@huawei.com>
 <ef7bad8c-b8dd-f625-330c-9a22e303844b@huawei.com>
 <20220419094955.ucjxadnhdyonfjdo@quack3.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220419094955.ucjxadnhdyonfjdo-/1kMjMImKQN+urZeOPWqwQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

在 2022/04/19 17:49, Jan Kara 写道:
> On Fri 15-04-22 09:10:06, yukuai (C) wrote:
>> 在 2022/04/13 19:40, yukuai (C) 写道:
>>> 在 2022/04/13 19:28, Jan Kara 写道:
>>>> On Sat 05-03-22 17:12:04, Yu Kuai wrote:
>>>>> Currently 'num_groups_with_pending_reqs' won't be decreased when
>>>>> the group doesn't have any pending requests, while some child group
>>>>> still have pending requests. The decrement is delayed to when all the
>>>>> child groups doesn't have any pending requests.
>>>>>
>>>>> For example:
>>>>> 1) t1 issue sync io on root group, t2 and t3 issue sync io on the same
>>>>> child group. num_groups_with_pending_reqs is 2 now.
>>>>> 2) t1 stopped, num_groups_with_pending_reqs is still 2. io from t2 and
>>>>> t3 still can't be handled concurrently.
>>>>>
>>>>> Fix the problem by decreasing 'num_groups_with_pending_reqs'
>>>>> immediately upon the weights_tree removal of last bfqq of the group.
>>>>>
>>>>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>>
>>>> So I'd find the logic easier to follow if you completely removed
>>>> entity->in_groups_with_pending_reqs and did updates of
>>>> bfqd->num_groups_with_pending_reqs like:
>>>>
>>>>      if (!bfqg->num_entities_with_pending_reqs++)
>>>>          bfqd->num_groups_with_pending_reqs++;
>>>>
>>> Hi,
>>>
>>> Indeed, this is an excellent idle, and much better than the way I did.
>>>
>>> Thanks,
>>> Kuai
>>>
>>>> and similarly on the remove side. And there would we literally two places
>>>> (addition & removal from weight tree) that would need to touch these
>>>> counters. Pretty obvious and all can be done in patch 9.
>>
>> I think with this change, we can count root_group while activating bfqqs
>> that are under root_group, thus there is no need to modify
>> for_each_entity(or fake bfq_sched_data) any more.
> 
> Sure, if you can make this work, it would be easier :)
> 
>> The special case is that weight racing bfqqs are not inserted into
>> weights tree, and I think this can be handled by adding a fake
>> bfq_weight_counter for such bfqqs.
> 
> Do you mean "weight raised bfqqs"? Yes, you are right they would need
> special treatment - maybe bfq_weights_tree_add() is not the best function
> to use for this and we should rather use insertion / removal from the
> service tree for maintaining num_entities_with_pending_reqs counter?
> I can even see we already have bfqg->active_entities so maybe we could just
> somehow tweak that accounting and use it for our purposes?

The problem to use 'active_entities' is that bfqq can be deactivated
while it still has pending requests.

Anyway, I posted a new version aready, which still use weights_tree
insertion / removal to count pending bfqqs. I'll be great if you can
take a look:

https://patchwork.kernel.org/project/linux-block/cover/20220416093753.3054696-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/

BTW, I was worried that you can't receive the emails because I got
warnings that mails can't deliver to you:

Your message could not be delivered for more than 6 hour(s).
It will be retried until it is 1 day(s) old.

For further assistance, please send mail to postmaster.

If you do so, please include this problem report. You can
delete your own text from the attached returned message.

                    The mail system

<jack-j1pC+zEt+uWoYr4blSSd5g@public.gmane.org> (expanded from <jack-AlSwsSmVLrQ@public.gmane.org>): host
     mail2.suse.de[149.44.160.157] said: 452 4.3.1 Insufficient system 
storage

Thanks,
Kuai
> 
> 								Honza
> 
