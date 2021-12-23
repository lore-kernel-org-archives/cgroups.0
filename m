From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 4/4] block, bfq: update pos_root for idle bfq_queue in
 bfq_bfqq_move()
Date: Thu, 23 Dec 2021 09:03:55 +0800
Message-ID: <69bd1c5e-b692-3c8c-e90e-adc4d71eb04d@huawei.com>
References: <20211221032135.878550-1-yukuai3@huawei.com>
 <20211221032135.878550-5-yukuai3@huawei.com>
 <20211221115001.GD24748@quack2.suse.cz>
 <6ca1e924-47fa-b94e-598c-69a9549eb68e@huawei.com>
 <20211222141722.GC685@quack2.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20211222141722.GC685@quack2.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jan Kara <jack@suse.cz>
Cc: tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, fchecconi@gmail.com, avanzini.arianna@gmail.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

在 2021/12/22 22:17, Jan Kara 写道:
> On Wed 22-12-21 11:12:45, yukuai (C) wrote:
>> 在 2021/12/21 19:50, Jan Kara 写道:
>>> On Tue 21-12-21 11:21:35, Yu Kuai wrote:
>>>> During code review, we found that if bfqq is not busy in
>>>> bfq_bfqq_move(), bfq_pos_tree_add_move() won't be called for the bfqq,
>>>> thus bfqq->pos_root still points to the old bfqg. However, the ref
>>>> that bfqq hold for the old bfqg will be released, so it's possible
>>>> that the old bfqg can be freed. This is problematic because the freed
>>>> bfqg can still be accessed by bfqq->pos_root.
>>>>
>>>> Fix the problem by calling bfq_pos_tree_add_move() for idle bfqq
>>>> as well.
>>>>
>>>> Fixes: e21b7a0b9887 ("block, bfq: add full hierarchical scheduling and cgroups support")
>>>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>>>
>>> I'm just wondering, how can it happen that !bfq_bfqq_busy() queue is in
>>> pos_tree? Because bfq_remove_request() takes care to remove bfqq from the
>>> pos_tree...
>>
>> Hi,
>>
>> It's right this is not a problem in common case. The problem seems to
>> relate to queue merging and task migration. Because I once reporduced
>> it with the same reporducer for the problem that offlined bfqg can be
>> inserted into service tree. The uaf is exactly in
>> bfq_remove_request->rb_rease(). However I didn't save the stack...
>>
>> I guess this is because bfq_del_bfqq_busy() is called from
>> bfq_release_process_ref(), and queue merging prevert sunch bfqq to be
>> freed, thus such bfqq is not in service tree, and it's pos_root can
>> point to the old bfqg after bfq_bic_update_cgroup->bfq_bfqq_move.
>>
>> I haven't confirmed this, however, this patch itself only cleared
>> bfqq->pos_root for idle bfqq, there should be no harm.
> 
> Well, I agree this patch does no harm but in my opinion it is just papering
> over the real problem which is that we leave bfqq without any request in
> the pos_tree which can have also other unexpected consequences. I don't
> think your scenario with bfq_release_process_ref() calling
> bfq_del_bfqq_busy() really answers my question because we call
> bfq_del_bfqq_busy() only if RB_EMPTY_ROOT(&bfqq->sort_list) (i.e., bfqq has
> no requests) and when sort_list was becoming empty, bfq_remove_request()
> should have removed bfqq from the pos_tree. So I think proper fix lies
> elsewhere and I would not merge this patch until we better understand what
> is happening in this case.

Hi,

I'll try to reporduce the UAF, and take a look at it.

Thanks,
Kuai
> 
> 								Honza
> 
