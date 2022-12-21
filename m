From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next 0/4] blk-cgroup: synchronize del_gendisk() with
 configuring cgroup policy
Date: Wed, 21 Dec 2022 09:10:33 +0800
Message-ID: <c2fecf04-6e9e-25a1-f14c-47862837cc54@huaweicloud.com>
References: <20221217030908.1261787-1-yukuai1@huaweicloud.com>
 <Y6DP3aOSad8+D1yY@slm.duckdns.org>
 <e01daffe-a3e3-8bf2-40ee-192a9e70d911@huaweicloud.com>
 <Y6HcWiJbaWjN3jlt@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y6HcWiJbaWjN3jlt-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

在 2022/12/21 0:01, Tejun Heo 写道:
> Hello,
> 
> On Tue, Dec 20, 2022 at 05:19:12PM +0800, Yu Kuai wrote:
>> Yes, that sounds good. BTW, queue_lock is also used to protect
>> pd_alloc_fn/pd_init_fn，and we found that blkcg_activate_policy() is
>> problematic:
>>
>> blkcg_activate_policy
>>   spin_lock_irq(&q->queue_lock);
>>   list_for_each_entry_reverse(blkg, &q->blkg_list
>>    pd_alloc_fn(GFP_NOWAIT | __GFP_NOWARN,...) -> failed
>>
>>    spin_unlock_irq(&q->queue_lock);
>>    // release queue_lock here is problematic, this will cause
>> pd_offline_fn called without pd_init_fn.
>>    pd_alloc_fn(__GFP_NOWARN,...)
> 
> So, if a blkg is destroyed while a policy is being activated, right?
Yes, remove cgroup can race with this, for bfq null pointer deference
will be triggered in bfq_pd_offline().

> 
>> If we are using a mutex to protect rq_qos ops, it seems the right thing
>> to do do also using the mutex to protect blkcg_policy ops, and this
>> problem can be fixed because mutex can be held to alloc memroy with
>> GFP_KERNEL. What do you think?
> 
> One worry is that switching to mutex can be more headache due to destroy
> path synchronization. Another approach would be using a per-blkg flag to
> track whether a blkg has been initialized.
I think perhaps you mean per blkg_policy_data flag? per blkg flag should
not work in this case.

Thanks,
Kuai
> 
> Thanks.
> 

