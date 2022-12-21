From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH -next 0/4] blk-cgroup: synchronize del_gendisk() with
 configuring cgroup policy
Date: Wed, 21 Dec 2022 10:48:19 +0800
Message-ID: <ebfd3d01-9fd1-3453-6cf5-05e8540359c7@huaweicloud.com>
References: <20221217030908.1261787-1-yukuai1@huaweicloud.com>
 <Y6DP3aOSad8+D1yY@slm.duckdns.org>
 <e01daffe-a3e3-8bf2-40ee-192a9e70d911@huaweicloud.com>
 <Y6HcWiJbaWjN3jlt@slm.duckdns.org>
 <c2fecf04-6e9e-25a1-f14c-47862837cc54@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <c2fecf04-6e9e-25a1-f14c-47862837cc54@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Yu Kuai <yukuai1@huaweicloud.com>, Tejun Heo <tj@kernel.org>
Cc: hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi,

在 2022/12/21 9:10, Yu Kuai 写道:
> Hi,
> 
> 在 2022/12/21 0:01, Tejun Heo 写道:
>> Hello,
>>
>> On Tue, Dec 20, 2022 at 05:19:12PM +0800, Yu Kuai wrote:
>>> Yes, that sounds good. BTW, queue_lock is also used to protect
>>> pd_alloc_fn/pd_init_fn，and we found that blkcg_activate_policy() is
>>> problematic:
>>>
>>> blkcg_activate_policy
>>>   spin_lock_irq(&q->queue_lock);
>>>   list_for_each_entry_reverse(blkg, &q->blkg_list
>>>    pd_alloc_fn(GFP_NOWAIT | __GFP_NOWARN,...) -> failed
>>>
>>>    spin_unlock_irq(&q->queue_lock);
>>>    // release queue_lock here is problematic, this will cause
>>> pd_offline_fn called without pd_init_fn.
>>>    pd_alloc_fn(__GFP_NOWARN,...)
>>
>> So, if a blkg is destroyed while a policy is being activated, right?
> Yes, remove cgroup can race with this, for bfq null pointer deference
> will be triggered in bfq_pd_offline().

BTW, We just found that pd_online_fn() is missed in
blkcg_activate_policy()... Currently this is not a problem because only
bl-throttle implement it, and blk-throttle is activated while creating
blkg.

Thanks,
Kuai
> 
>>
>>> If we are using a mutex to protect rq_qos ops, it seems the right thing
>>> to do do also using the mutex to protect blkcg_policy ops, and this
>>> problem can be fixed because mutex can be held to alloc memroy with
>>> GFP_KERNEL. What do you think?
>>
>> One worry is that switching to mutex can be more headache due to destroy
>> path synchronization. Another approach would be using a per-blkg flag to
>> track whether a blkg has been initialized.
> I think perhaps you mean per blkg_policy_data flag? per blkg flag should
> not work in this case.
> 
> Thanks,
> Kuai
>>
>> Thanks.
>>
> 
> .
> 

