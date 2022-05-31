From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next v7 2/3] block, bfq: refactor the counting of
 'num_groups_with_pending_reqs'
Date: Tue, 31 May 2022 21:28:53 +0800
Message-ID: <60c462fd-752a-1c52-f1a8-ad6b51146bc4@huawei.com>
References: <20220528095020.186970-1-yukuai3@huawei.com>
 <20220528095020.186970-3-yukuai3@huawei.com>
 <0D9355CE-F85B-4B1A-AEC3-F63DFC4B3A54@linaro.org>
 <b9a4ea60-28e5-b7aa-0154-ad7481eafbd3@huawei.com>
 <efe01dd1-0f99-dadf-956d-b0e80e1e602c@huawei.com>
 <1803FD7E-9FB1-4A1E-BD6D-D6657006589A@unimore.it>
 <a0d8452c-e421-45d3-b012-5355207fc0e1@huawei.com>
 <81214347-3806-4F54-B60F-3E5A1A5EC84D@unimore.it>
 <756631ee-6a85-303c-aca1-d60aaf477d0d@huawei.com>
 <20220531100101.pdnrpkxbapur5gsk@quack3.lan>
 <CB1A8F13-76DB-4469-A5CA-D0AD17975E38@unimore.it>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CB1A8F13-76DB-4469-A5CA-D0AD17975E38-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Paolo Valente <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

在 2022/05/31 20:57, Paolo Valente 写道:
> 
> 
>> Il giorno 31 mag 2022, alle ore 12:01, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> ha scritto:
>>
>> On Tue 31-05-22 17:33:25, Yu Kuai wrote:
>>> 在 2022/05/31 17:19, Paolo Valente 写道:
>>>>> Il giorno 31 mag 2022, alle ore 11:06, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> ha scritto:
>>>>>
>>>>> 在 2022/05/31 16:36, Paolo VALENTE 写道:
>>>>>>> Il giorno 30 mag 2022, alle ore 10:40, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> ha scritto:
>>>>>>>
>>>>>>> 在 2022/05/30 16:34, Yu Kuai 写道:
>>>>>>>> 在 2022/05/30 16:10, Paolo Valente 写道:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>> Il giorno 28 mag 2022, alle ore 11:50, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> ha scritto:
>>>>>>>>>>
>>>>>>>>>> Currently, bfq can't handle sync io concurrently as long as they
>>>>>>>>>> are not issued from root group. This is because
>>>>>>>>>> 'bfqd->num_groups_with_pending_reqs > 0' is always true in
>>>>>>>>>> bfq_asymmetric_scenario().
>>>>>>>>>>
>>>>>>>>>> The way that bfqg is counted into 'num_groups_with_pending_reqs':
>>>>>>>>>>
>>>>>>>>>> Before this patch:
>>>>>>>>>> 1) root group will never be counted.
>>>>>>>>>> 2) Count if bfqg or it's child bfqgs have pending requests.
>>>>>>>>>> 3) Don't count if bfqg and it's child bfqgs complete all the requests.
>>>>>>>>>>
>>>>>>>>>> After this patch:
>>>>>>>>>> 1) root group is counted.
>>>>>>>>>> 2) Count if bfqg have at least one bfqq that is marked busy.
>>>>>>>>>> 3) Don't count if bfqg doesn't have any busy bfqqs.
>>>>>>>>>
>>>>>>>>> Unfortunately, I see a last problem here. I see a double change:
>>>>>>>>> (1) a bfqg is now counted only as a function of the state of its child
>>>>>>>>>       queues, and not of also its child bfqgs
>>>>>>>>> (2) the state considered for counting a bfqg moves from having pending
>>>>>>>>>       requests to having busy queues
>>>>>>>>>
>>>>>>>>> I'm ok with with (1), which is a good catch (you are lady explained
>>>>>>>>> the idea to me some time ago IIRC).
>>>>>>>>>
>>>>>>>>> Yet I fear that (2) is not ok.  A bfqq can become non busy even if it
>>>>>>>>> still has in-flight I/O, i.e.  I/O being served in the drive.  The
>>>>>>>>> weight of such a bfqq must still be considered in the weights_tree,
>>>>>>>>> and the group containing such a queue must still be counted when
>>>>>>>>> checking whether the scenario is asymmetric.  Otherwise service
>>>>>>>>> guarantees are broken.  The reason is that, if a scenario is deemed as
>>>>>>>>> symmetric because in-flight I/O is not taken into account, then idling
>>>>>>>>> will not be performed to protect some bfqq, and in-flight I/O may
>>>>>>>>> steal bandwidth to that bfqq in an uncontrolled way.
>>>>>>>> Hi, Paolo
>>>>>>>> Thanks for your explanation.
>>>>>>>> My orginal thoughts was using weights_tree insertion/removal, however,
>>>>>>>> Jan convinced me that using bfq_add/del_bfqq_busy() is ok.
>>>>>>>>  From what I see, when bfqq dispatch the last request,
>>>>>>>> bfq_del_bfqq_busy() will not be called from __bfq_bfqq_expire() if
>>>>>>>> idling is needed, and it will delayed to when such bfqq get scheduled as
>>>>>>>> in-service queue again. Which means the weight of such bfqq should still
>>>>>>>> be considered in the weights_tree.
>>>>>>>> I also run some tests on null_blk with "irqmode=2
>>>>>>>> completion_nsec=100000000(100ms) hw_queue_depth=1", and tests show
>>>>>>>> that service guarantees are still preserved on slow device.
>>>>>>>> Do you this is strong enough to cover your concern?
>>>>>> Unfortunately it is not.  Your very argument is what made be believe
>>>>>> that considering busy queues was enough, in the first place.  But, as
>>>>>> I found out, the problem is caused by the queues that do not enjoy
>>>>>> idling.  With your patch (as well as in my initial version) they are
>>>>>> not counted when they remain without requests queued.  And this makes
>>>>>> asymmetric scenarios be considered erroneously as symmetric.  The
>>>>>> consequence is that idling gets switched off when it had to be kept
>>>>>> on, and control on bandwidth is lost for the victim in-service queues.
>>>>>
>>>>> Hi，Paolo
>>>>>
>>>>> Thanks for your explanation, are you thinking that if bfqq doesn't enjoy
>>>>> idling, then such bfqq will clear busy after dispatching the last
>>>>> request?
>>>>>
>>>>> Please kindly correct me if I'm wrong in the following process:
>>>>>
>>>>> If there are more than one bfqg that is activatied, then bfqqs that are
>>>>> not enjoying idle are still left busy after dispatching the last
>>>>> request.
>>>>>
>>>>> details in __bfq_bfqq_expire:
>>>>>
>>>>>         if (RB_EMPTY_ROOT(&bfqq->sort_list) &&
>>>>>         ┊   !(reason == BFQQE_PREEMPTED &&
>>>>>         ┊     idling_needed_for_service_guarantees(bfqd, bfqq))) {
>>>>> -> idling_needed_for_service_guarantees will always return true,
>>>>
>>>> It returns true only is the scenario is symmetric.  Not counting bfqqs
>>>> with in-flight requests makes an asymmetric scenario be considered
>>>> wrongly symmetric.  See function bfq_asymmetric_scenario().
>>>
>>> Hi, Paolo
>>>
>>> Do you mean this gap?
>>>
>>> 1. io1 is issued from bfqq1(from bfqg1)
>>> 2. bfqq1 dispatched this io, it's busy is cleared
>>> 3. *before io1 is completed*, io2 is issued from bfqq2(bfqg2)
>>
>> Yes. So as far as I understand Paolo is concerned about this scenario.
>>
>>> 4. with this patchset, while dispatching io2 from bfqq2, the scenario
>>> should be symmetric while it's considered wrongly asymmetric.
>>
>> But with this patchset, we will consider this scenario symmetric because at
>> any point in time there is only one busy bfqq. Before, we considered this
>> scenario asymmetric because two different bfq groups have bfqq in their
>> weights_tree. So before this patchset
>> idling_needed_for_service_guarantees() returned true, after this patchset
>> the function returns false so we won't idle anymore and Paolo argues that
>> bfqq1 does not get adequate protection from bfqq2 as a result.
>>
>> I agree with Paolo this seems possible. The fix is relatively simple though
>> - instead of changing how weights_tree is used for weight raised queues as
>> you did originally, I'd move the accounting of groups with pending requests
>> to bfq_add/del_bfqq_busy() and bfq_completed_request().
>>
> 
> Why don't we use simply the existing logic? I mean, as for the changes made by this patch, we could simply turn the loop:
> 
> void bfq_weights_tree_remove(struct bfq_data *bfqd,
> 			     struct bfq_queue *bfqq)
> {
> 	...
> 	for_each_entity(entity) {
> 		struct bfq_sched_data *sd = entity->my_sched_data;
> 
> 		...
> 		if (entity->in_groups_with_pending_reqs) {
> 			entity->in_groups_with_pending_reqs = false;
> 			bfqd->num_groups_with_pending_reqs--;
> 		}
> 	}
> 	...
> }
> 
> into a single:
> 
> 	bfqd->num_groups_with_pending_reqs--;
> 
> so that only the parent group is concerned.

It's ok to decrease it here, however, we need another place to increase
it in order to count root group... And bfq_weights_tree_add is not good
because it bypass wr queues.

Thanks,
Kuai
