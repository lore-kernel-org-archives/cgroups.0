From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v4 2/2] block: cancel all throttled bios in del_gendisk()
Date: Fri, 3 Dec 2021 15:50:01 +0800
Message-ID: <95825098-a532-a0e4-9ed0-0b5f2a0e5f04@huawei.com>
References: <20211202130440.1943847-1-yukuai3@huawei.com>
 <20211202130440.1943847-3-yukuai3@huawei.com>
 <20211202144818.GB16798@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20211202144818.GB16798@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: hch@infradead.org, tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

在 2021/12/02 22:48, Michal Koutný 写道:
> Hello Kuai.
> 
> On Thu, Dec 02, 2021 at 09:04:40PM +0800, Yu Kuai <yukuai3@huawei.com> wrote:
>> For example, if user thread is throttled with low bps while it's
>> issuing large io, and the device is deleted. The user thread will
>> wait for a long time for io to return.
> 
> Do I understand correctly the "long time" here is
> outstanding_IO_size/throttled_bandwidth? Or are you getting at some

Hi, Michal

Yes, this is exactly what I mean.
> other cause/longer time?
> 
>> +void blk_throtl_cancel_bios(struct request_queue *q)
>> +{
>> +	struct throtl_data *td = q->td;
>> +	struct bio_list bio_list_on_stack;
>> +	struct blkcg_gq *blkg;
>> +	struct cgroup_subsys_state *pos_css;
>> +	struct bio *bio;
>> +	int rw;
>> +
>> +	bio_list_init(&bio_list_on_stack);
>> +
>> +	/*
>> +	 * hold queue_lock to prevent concurrent with dispatching
>> +	 * throttled bios by timer.
>> +	 */
>> +	spin_lock_irq(&q->queue_lock);
> 
> You've replaced the rcu_read_lock() with the queue lock but...
> 
>> +
>> +	/*
>> +	 * Drain each tg while doing post-order walk on the blkg tree, so
>> +	 * that all bios are propagated to td->service_queue.  It'd be
>> +	 * better to walk service_queue tree directly but blkg walk is
>> +	 * easier.
>> +	 */
>> +	blkg_for_each_descendant_post(blkg, pos_css, td->queue->root_blkg)
>> +		tg_drain_bios(&blkg_to_tg(blkg)->service_queue);
> 
> ...you also need the rcu_read_lock() here since you may encounter a
> (descendant) blkcg that's removed concurrently.

blkg_destroy() is protected by the queue_lock，so I think queue_lock can
protect such concurrent scenario.

Thanks,
Kuai
> 
> (I may miss some consequences of doing this under the queue_lock so if
> the concurrent removal is ruled out, please make a comment about it.)
> 
> 
> Regards,
> Michal
> 
