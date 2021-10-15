From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v2 -next] blk-cgroup: synchoronize blkg creation against
 policy deactivation
Date: Fri, 15 Oct 2021 09:48:28 +0800
Message-ID: <6fc9eaa8-c367-f458-4ed9-94af60b55ca0@huawei.com>
References: <20211013124456.3186005-1-yukuai3@huawei.com>
 <YWi27oAU0v5v86eN@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <YWi27oAU0v5v86eN@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, paolo.valente@linaro.org, fchecconi@gmail.com, avanzini.arianna@gmail.com, mkoutny@suse.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On 2021/10/15 7:02, Tejun Heo wrote:
> On Wed, Oct 13, 2021 at 08:44:56PM +0800, Yu Kuai wrote:
>> @@ -1401,6 +1406,7 @@ void blkcg_deactivate_policy(struct request_queue *q,
>>   	if (queue_is_mq(q))
>>   		blk_mq_freeze_queue(q);
>>   
>> +	mutex_lock(&q->blkg_lock);
>>   	spin_lock_irq(&q->queue_lock);
> 
> Given that deactivation drains q_usage_counter through
> blk_mq_freeze_queue(), can't the blkg_conf_prep() just pin the usage count?
> 

In fact, the caller of blkcg_deactivate_policy() aready freeze the
queue, either from blk_cleanup_queue() or from elevator_switch().

Grab q_usage_counter in blk_conf_prep() can prevent concurrent with
blkcg_deactivate_policy(), I'm afraid will it be too much since it
will also be synchoronized with all the other freeze/unfreeze queues?

Thanks,
Kuai
