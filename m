From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH -next v3 0/5] blk-wbt: minor fix and cleanup
Date: Mon, 26 Jun 2023 10:46:14 +0800
Message-ID: <00cc4aa8-b725-e7ac-dec9-ccd03dd2fe21@huaweicloud.com>
References: <20230527010644.647900-1-yukuai1@huaweicloud.com>
 <e33b856f-1874-030f-1b45-3b036e9b17b6@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <e33b856f-1874-030f-1b45-3b036e9b17b6@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi, Jens

在 2023/06/08 10:36, Yu Kuai 写道:
> Hi, Jens
> 
> Can you apply this patchset?

The only fix from this patchset is applied separately, so this patchset
is just simple cleanups now, can you please consider this for the next
merge window?

Thanks,
Kuai
> 
> Thanks,
> Kuai
> 
> 在 2023/05/27 9:06, Yu Kuai 写道:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Changes in v3:
>>   - patch 1 from v2 is sent separately, and it's removd from this series.
>>   - add review tag for all the patches.
>>
>> Changes in v2:
>>   - make the code more readable for patch 1
>>   - add a new attr_group that is only visible for rq based device
>>   - explain in detail for patch 4
>>   - add review tag for patch 2,3,5
>>
>> Yu Kuai (5):
>>    blk-wbt: don't create wbt sysfs entry if CONFIG_BLK_WBT is disabled
>>    blk-wbt: remove dead code to handle wbt enable/disable with io
>>      inflight
>>    blk-wbt: cleanup rwb_enabled() and wbt_disabled()
>>    blk-iocost: move wbt_enable/disable_default() out of spinlock
>>    blk-sysfs: add a new attr_group for blk_mq
>>
>>   block/blk-iocost.c |   7 +-
>>   block/blk-sysfs.c  | 181 ++++++++++++++++++++++++++-------------------
>>   block/blk-wbt.c    |  21 +-----
>>   block/blk-wbt.h    |  19 -----
>>   4 files changed, 110 insertions(+), 118 deletions(-)
>>
> 
> .
> 

