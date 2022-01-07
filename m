From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v5 0/2] cancel all throttled bios in del_gendisk()
Date: Fri, 7 Jan 2022 09:08:15 +0800
Message-ID: <29a780c6-ad65-ece8-4fbc-acd766b681f8@huawei.com>
References: <20211210083143.3181535-1-yukuai3@huawei.com>
 <ca8d39fc-48d3-cfd9-3fa4-a329bb37b91b@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <ca8d39fc-48d3-cfd9-3fa4-a329bb37b91b@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: tj@kernel.org, mkoutny@suse.com, hch@infradead.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

在 2021/12/18 17:09, yukuai (C) 写道:
> 在 2021/12/10 16:31, Yu Kuai 写道:
>> If del_gendisk() is done when some io are still throttled, such io
>> will not be handled until the throttle is done, which is not
>> necessary.
>>
>> Changes in v2:
>>   - move WARN_ON_ONCE() from throtl_rb_first() to it's caller
>>   - merge some patches into one.
>>
>> Changes in v3:
>>   - some code optimization in patch 1
>>   - hold queue lock to cancel bios in patch 2
>>
>> Changes in v4:
>>   - delete rcu_read_lock() and rcu_read_unlock() in patch 2
>>
>> Changes in v5:
>>   - add comment about rcu lock
> Friendly ping...

Friendly ping ...

>>
>> Yu Kuai (2):
>>    blk-throtl: move WARN_ON_ONCE() from throtl_rb_first() to it's caller
>>    block: cancel all throttled bios in del_gendisk()
>>
>>   block/blk-throttle.c | 75 ++++++++++++++++++++++++++++++++++++++++++--
>>   block/blk-throttle.h |  2 ++
>>   block/genhd.c        |  2 ++
>>   3 files changed, 76 insertions(+), 3 deletions(-)
>>
