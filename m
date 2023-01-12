From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH v2 1/2] blk-iocost: add refcounting for iocg
Date: Thu, 12 Jan 2023 14:18:15 +0800
Message-ID: <4aeef320-c6c8-d9b4-8826-d58f00ea6264@huaweicloud.com>
References: <Y7XzUee5Bq+DoIC1@slm.duckdns.org>
 <c63ee2ad-23d5-3be0-c731-28494398b391@huaweicloud.com>
 <Y7cX0SJ0y6+EIY5Q@slm.duckdns.org>
 <7dcdaef3-65c1-8175-fea7-53076f39697f@huaweicloud.com>
 <Y7iCId3pnEnLqY8G@slm.duckdns.org>
 <875eb43e-202d-5b81-0bff-ef0434358d99@huaweicloud.com>
 <Y7xbpidpq7+DqJan@slm.duckdns.org>
 <a71f997f-6cae-d57b-85dd-2fd499d238f6@huaweicloud.com>
 <Y72wF/b0/xNRmP7f@slm.duckdns.org>
 <53b30ac8-d608-ba0b-8b1b-7fe5cfed6d61@huaweicloud.com>
 <Y77s0f741mFfGlTO@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <Y77s0f741mFfGlTO@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi,

在 2023/01/12 1:07, Tejun Heo 写道:
> Hello,
> 
> On Wed, Jan 11, 2023 at 09:36:25AM +0800, Yu Kuai wrote:
>> I'm not sure, of course this can fix the problem, but two spinlock
>> 'blkcg->lock' and 'q->queue_lock' are used to protect blkg_destroy()
>> currently, add a mutex（disk level?) requires a refactor, which seems
>> complex to me.
> 
> The fact that the two paths can race each other already seems buggy. e.g.
> What prevents them from running pd_free on the same pd twice? So, it needs

I think the root cause is that blkg is tracked from two different list,
blkcg->blkg_list from cgroup level and q->blkg_list from disk level. And
pd_free_fn is also called from both blkg_destroy() and deactivate policy
for a disk.

I just thought about another solution:

remove the blkcg_deactivate_policy() from rq_qos_exit() from deleting
the device, and delay the policy cleanup and free to blkg_destroy_all().
Then the policies(other than bfq) can only call pd_free_fn() from
blkg_destroy(), and it's easy to guarantee the order. For bfq, it can
stay the same since bfq has refcounting itself.

Then for the problem that ioc can be freed in pd_free_fn(), we can fix
it by freeing ioc in ioc_pd_free() for root blkg instead of
rq_qos_exit().

What do you think?

Thanks,
Kuai
> to be fixed anyway and the intention always has been that these callbacks
> are called in the correct traversal order.
> 
> Thanks.
> 

