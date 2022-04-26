From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next v2 2/5] block, bfq: add fake weight_counter for
 weight-raised queue
Date: Tue, 26 Apr 2022 09:49:04 +0800
Message-ID: <4591d02d-1f14-c928-1c50-6e434dfbb7b2@huawei.com>
References: <20220416093753.3054696-1-yukuai3@huawei.com>
 <20220416093753.3054696-3-yukuai3@huawei.com>
 <20220425094856.qgkhba2klguduxot@quack3.lan>
 <a27b8c79-867f-9253-84db-1d39c964b3ed@huawei.com>
 <20220425161650.xzyijgkb5yzviea3@quack3.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220425161650.xzyijgkb5yzviea3-/1kMjMImKQN+urZeOPWqwQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

在 2022/04/26 0:16, Jan Kara 写道:
> Hello!
> 
> On Mon 25-04-22 21:34:16, yukuai (C) wrote:
>> 在 2022/04/25 17:48, Jan Kara 写道:
>>> On Sat 16-04-22 17:37:50, Yu Kuai wrote:
>>>> Weight-raised queue is not inserted to weights_tree, which makes it
>>>> impossible to track how many queues have pending requests through
>>>> weights_tree insertion and removel. This patch add fake weight_counter
>>>> for weight-raised queue to do that.
>>>>
>>>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>
>>> This is a bit hacky. I was looking into a better place where to hook to
>>> count entities in a bfq_group with requests and I think bfq_add_bfqq_busy()
>>> and bfq_del_bfqq_busy() are ideal for this. It also makes better sense
>>> conceptually than hooking into weights tree handling.
>>
>> bfq_del_bfqq_busy() will be called when all the reqs in the bfqq are
>> dispatched, however there might still some reqs are't completed yet.
>>
>> Here what we want to track is how many bfqqs have pending reqs,
>> specifically if the bfqq have reqs are't complted.
>>
>> Thus I think bfq_del_bfqq_busy() is not the right place to do that.
> 
> Yes, I'm aware there will be a difference. But note that bfqq can stay busy
> with only dispatched requests because the logic in __bfq_bfqq_expire() will
> not call bfq_del_bfqq_busy() if idling is needed for service guarantees. So
> I think using bfq_add/del_bfqq_busy() would work OK.
Hi,

I didn't think of that before. If bfqq stay busy after dispathing all
the requests, there are two other places that bfqq can clear busy:

1) bfq_remove_request(), bfqq has to insert a new req while it's not in
service.

2) bfq_release_process_ref(), user thread is gone / moved, or old bfqq
is gone due to merge / ioprio change.

I wonder, will bfq_del_bfqq_busy() be called immediately when requests
are completed? (It seems not to me...). For example, a user thread
issue a sync io just once, and it keep running without issuing new io,
then when does the bfqq clears the busy state?

Thanks,
Kuai
> 
> 								Honza
> 
