From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next v10 3/4] block, bfq: refactor the counting of
 'num_groups_with_pending_reqs'
Date: Fri, 5 Aug 2022 19:20:20 +0800
Message-ID: <57689e84-e47d-29e2-327e-b8f172329681@huaweicloud.com>
References: <20220610021701.2347602-1-yukuai3@huawei.com>
 <20220610021701.2347602-4-yukuai3@huawei.com>
 <27F2DF19-7CC6-42C5-8CEB-43583EB4AE46@linaro.org>
 <abdbb5db-e280-62f8-0670-536fcb8ec4d9@huaweicloud.com>
 <C2CF100A-9A7C-4300-9A70-1295BC939C66@unimore.it>
 <9b2d667f-6636-9347-08a1-8bd0aa2346f2@huaweicloud.com>
 <2f94f241-445f-1beb-c4a8-73f6efce5af2@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2f94f241-445f-1beb-c4a8-73f6efce5af2-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, Paolo VALENTE <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>


在 2022/07/27 20:11, Yu Kuai 写道:
> Hi, Paolo
> 
> Are you still interested in this patchset?

Friendly ping...
> 
> 在 2022/07/20 19:38, Yu Kuai 写道:
>> Hi
>>
>> 在 2022/07/20 19:24, Paolo VALENTE 写道:
>>>
>>>
>>>> Il giorno 12 lug 2022, alle ore 15:30, Yu Kuai 
>>>> <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org <mailto:yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>> ha scritto:
>>>>
>>>> Hi!
>>>>
>>>> I'm copying my reply with new mail address, because Paolo seems
>>>> didn't receive my reply.
>>>>
>>>> 在 2022/06/23 23:32, Paolo Valente 写道:
>>>>> Sorry for the delay.
>>>>>> Il giorno 10 giu 2022, alle ore 04:17, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org 
>>>>>> <mailto:yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>> ha scritto:
>>>>>>
>>>>>> Currently, bfq can't handle sync io concurrently as long as they
>>>>>> are not issued from root group. This is because
>>>>>> 'bfqd->num_groups_with_pending_reqs > 0' is always true in
>>>>>> bfq_asymmetric_scenario().
>>>>>>
>>>>>> The way that bfqg is counted into 'num_groups_with_pending_reqs':
>>>>>>
>>>>>> Before this patch:
>>>>>> 1) root group will never be counted.
>>>>>> 2) Count if bfqg or it's child bfqgs have pending requests.
>>>>>> 3) Don't count if bfqg and it's child bfqgs complete all the 
>>>>>> requests.
>>>>>>
>>>>>> After this patch:
>>>>>> 1) root group is counted.
>>>>>> 2) Count if bfqg have pending requests.
>>>>>> 3) Don't count if bfqg complete all the requests.
>>>>>>
>>>>>> With this change, the occasion that only one group is activated 
>>>>>> can be
>>>>>> detected, and next patch will support concurrent sync io in the
>>>>>> occasion.
>>>>>>
>>>>>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org 
>>>>>> <mailto:yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>>
>>>>>> Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org <mailto:jack-AlSwsSmVLrQ@public.gmane.org>>
>>>>>> ---
>>>>>> block/bfq-iosched.c | 42 ------------------------------------------
>>>>>> block/bfq-iosched.h | 18 +++++++++---------
>>>>>> block/bfq-wf2q.c    | 19 ++++---------------
>>>>>> 3 files changed, 13 insertions(+), 66 deletions(-)
>>>>>>
>>>>>> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
>>>>>> index 0ec21018daba..03b04892440c 100644
>>>>>> --- a/block/bfq-iosched.c
>>>>>> +++ b/block/bfq-iosched.c
>>>>>> @@ -970,48 +970,6 @@ void __bfq_weights_tree_remove(struct 
>>>>>> bfq_data *bfqd,
>>>>>> void bfq_weights_tree_remove(struct bfq_data *bfqd,
>>>>>>     struct bfq_queue *bfqq)
>>>>>> {
>>>>>> -struct bfq_entity *entity = bfqq->entity.parent;
>>>>>> -
>>>>>> -for_each_entity(entity) {
>>>>>> -struct bfq_sched_data *sd = entity->my_sched_data;
>>>>>> -
>>>>>> -if (sd->next_in_service || sd->in_service_entity) {
>>>>>> -/*
>>>>>> -* entity is still active, because either
>>>>>> -* next_in_service or in_service_entity is not
>>>>>> -* NULL (see the comments on the definition of
>>>>>> -* next_in_service for details on why
>>>>>> -* in_service_entity must be checked too).
>>>>>> -*
>>>>>> -* As a consequence, its parent entities are
>>>>>> -* active as well, and thus this loop must
>>>>>> -* stop here.
>>>>>> -*/
>>>>>> -break;
>>>>>> -}
>>>>>> -
>>>>>> -/*
>>>>>> -* The decrement of num_groups_with_pending_reqs is
>>>>>> -* not performed immediately upon the deactivation of
>>>>>> -* entity, but it is delayed to when it also happens
>>>>>> -* that the first leaf descendant bfqq of entity gets
>>>>>> -* all its pending requests completed. The following
>>>>>> -* instructions perform this delayed decrement, if
>>>>>> -* needed. See the comments on
>>>>>> -* num_groups_with_pending_reqs for details.
>>>>>> -*/
>>>>>> -if (entity->in_groups_with_pending_reqs) {
>>>>>> -entity->in_groups_with_pending_reqs = false;
>>>>>> -bfqd->num_groups_with_pending_reqs--;
>>>>>> -}
>>>>>> -}
>>>>> With this part removed, I'm missing how you handle the following
>>>>> sequence of events:
>>>>> 1.  a queue Q becomes non busy but still has dispatched requests, so
>>>>> it must not be removed from the counter of queues with pending reqs
>>>>> yet
>>>>> 2.  the last request of Q is completed with Q being still idle (non
>>>>> busy).  At this point Q must be removed from the counter.  It seems to
>>>>> me that this case is not handled any longer
>>>> Hi, Paolo
>>>>
>>>> 1) At first, patch 1 support to track if bfqq has pending requests, 
>>>> it's
>>>> done by setting the flag 'entity->in_groups_with_pending_reqs' when the
>>>> first request is inserted to bfqq, and it's cleared when the last
>>>> request is completed(based on weights_tree insertion and removal).
>>>>
>>>
>>> In patch 1 I don't see the flag cleared for the request-completion 
>>> event :(
>>>
>>> The piece of code involved is this:
>>>
>>> static void bfq_completed_request(struct bfq_queue *bfqq, struct 
>>> bfq_data *bfqd)
>>> {
>>> u64 now_ns;
>>> u32 delta_us;
>>>
>>> bfq_update_hw_tag(bfqd);
>>>
>>> bfqd->rq_in_driver[bfqq->actuator_idx]--;
>>> bfqd->tot_rq_in_driver--;
>>> bfqq->dispatched--;
>>>
>>> if (!bfqq->dispatched && !bfq_bfqq_busy(bfqq)) {
>>> /*
>>> * Set budget_timeout (which we overload to store the
>>> * time at which the queue remains with no backlog and
>>> * no outstanding request; used by the weight-raising
>>> * mechanism).
>>> */
>>> bfqq->budget_timeout = jiffies;
>>>
>>> bfq_weights_tree_remove(bfqd, bfqq);
>>> }
>>> ...
>>>
>>> Am I missing something?
>>
>> I add a new api bfq_del_bfqq_in_groups_with_pending_reqs() in patch 1
>> to clear the flag, and it's called both from bfq_del_bfqq_busy() and
>> bfq_completed_request(). I think you may miss the later:
>>
>> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
>> index 0d46cb728bbf..0ec21018daba 100644
>> --- a/block/bfq-iosched.c
>> +++ b/block/bfq-iosched.c
>> @@ -6263,6 +6263,7 @@ static void bfq_completed_request(struct 
>> bfq_queue *bfqq, struct bfq_data *bfqd)
>>           */
>>          bfqq->budget_timeout = jiffies;
>>
>> +        bfq_del_bfqq_in_groups_with_pending_reqs(bfqq);
>>          bfq_weights_tree_remove(bfqd, bfqq);
>>      }
>>
>> Thanks,
>> Kuai
>>>
>>> Thanks,
>>> Paolo
> 
> .
> 

