From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH -next v2 2/5] block, bfq: add fake weight_counter for
 weight-raised queue
Date: Tue, 26 Apr 2022 19:27:24 +0800
Message-ID: <6a829b09-4546-990a-52b6-bbd398f864bb@huawei.com>
References: <20220416093753.3054696-1-yukuai3@huawei.com>
 <20220416093753.3054696-3-yukuai3@huawei.com>
 <20220425094856.qgkhba2klguduxot@quack3.lan>
 <a27b8c79-867f-9253-84db-1d39c964b3ed@huawei.com>
 <20220425161650.xzyijgkb5yzviea3@quack3.lan>
 <4591d02d-1f14-c928-1c50-6e434dfbb7b2@huawei.com>
 <20220426074023.5y4gwvjsjzem3vgp@quack3.lan>
 <77b4c06c-f813-bcac-ea26-107e52f46d0a@huawei.com>
 <20220426091556.qzryd552gzo6dikf@quack3.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220426091556.qzryd552gzo6dikf@quack3.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jan Kara <jack@suse.cz>
Cc: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

在 2022/04/26 17:15, Jan Kara 写道:
> On Tue 26-04-22 16:27:46, yukuai (C) wrote:
>> 在 2022/04/26 15:40, Jan Kara 写道:
>>> On Tue 26-04-22 09:49:04, yukuai (C) wrote:
>>>> 在 2022/04/26 0:16, Jan Kara 写道:
>>>>> Hello!
>>>>>
>>>>> On Mon 25-04-22 21:34:16, yukuai (C) wrote:
>>>>>> 在 2022/04/25 17:48, Jan Kara 写道:
>>>>>>> On Sat 16-04-22 17:37:50, Yu Kuai wrote:
>>>>>>>> Weight-raised queue is not inserted to weights_tree, which makes it
>>>>>>>> impossible to track how many queues have pending requests through
>>>>>>>> weights_tree insertion and removel. This patch add fake weight_counter
>>>>>>>> for weight-raised queue to do that.
>>>>>>>>
>>>>>>>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>>>>>>>
>>>>>>> This is a bit hacky. I was looking into a better place where to hook to
>>>>>>> count entities in a bfq_group with requests and I think bfq_add_bfqq_busy()
>>>>>>> and bfq_del_bfqq_busy() are ideal for this. It also makes better sense
>>>>>>> conceptually than hooking into weights tree handling.
>>>>>>
>>>>>> bfq_del_bfqq_busy() will be called when all the reqs in the bfqq are
>>>>>> dispatched, however there might still some reqs are't completed yet.
>>>>>>
>>>>>> Here what we want to track is how many bfqqs have pending reqs,
>>>>>> specifically if the bfqq have reqs are't complted.
>>>>>>
>>>>>> Thus I think bfq_del_bfqq_busy() is not the right place to do that.
>>>>>
>>>>> Yes, I'm aware there will be a difference. But note that bfqq can stay busy
>>>>> with only dispatched requests because the logic in __bfq_bfqq_expire() will
>>>>> not call bfq_del_bfqq_busy() if idling is needed for service guarantees. So
>>>>> I think using bfq_add/del_bfqq_busy() would work OK.
>>>> Hi,
>>>>
>>>> I didn't think of that before. If bfqq stay busy after dispathing all
>>>> the requests, there are two other places that bfqq can clear busy:
>>>>
>>>> 1) bfq_remove_request(), bfqq has to insert a new req while it's not in
>>>> service.
>>>
>>> Yes and the request then would have to be dispatched or merged. Which
>>> generally means another bfqq from the same bfqg is currently active and
>>> thus this should have no impact on service guarantees we are interested in.
>>>
>>>> 2) bfq_release_process_ref(), user thread is gone / moved, or old bfqq
>>>> is gone due to merge / ioprio change.
>>>
>>> Yes, here there's no new IO for the bfqq so no point in maintaining any
>>> service guarantees to it.
>>>
>>>> I wonder, will bfq_del_bfqq_busy() be called immediately when requests
>>>> are completed? (It seems not to me...). For example, a user thread
>>>> issue a sync io just once, and it keep running without issuing new io,
>>>> then when does the bfqq clears the busy state?
>>>
>>> No, when bfqq is kept busy, it will get scheduled as in-service queue in
>>> the future. Then what happens depends on whether it will get more requests
>>> or not. But generally its busy state will get cleared once it is expired
>>> for other reason than preemption.
>>
>> Thanks for your explanation.
>>
>> I think in normal case using bfq_add/del_bfqq_busy() if fine.
>>
>> There is one last situation that I'm worried: If some disk are very
>> slow that the dispatched reqs are not completed when the bfqq is
>> rescheduled as in-service queue, and thus busy state can be cleared
>> while reqs are not completed.
>>
>> Using bfq_del_bfqq_busy() will change behaviour in this specail case,
>> do you think service guarantees will be broken?
> 
> Well, I don't think so. Because slow disks don't tend to do a lot of
> internal scheduling (or have deep IO queues for that matter). Also note
> that generally bfq_select_queue() will not even expire a queue (despite it
> not having any requests to dispatch) when we should not dispatch other
> requests to maintain service guarantees. So I think service guarantees will
> be generally preserved. Obviously I could be wrong, we we will not know
> until we try it :).

Thanks a lot for your explanation, I'll do some tests. And i'll send a
new version if tests look good.
