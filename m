From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 0/5] A few cleanup and bugfix patches for blk-iocost
Date: Wed, 30 Nov 2022 18:46:59 -0700
Message-ID: <bd008582-1509-69f3-1812-2b9caa390c05@kernel.dk>
References: <20221018121932.10792-1-shikemeng@huawei.com>
 <93f9093b-abec-db7e-a945-263cd9355c08@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8hDdaQmPxw+eSKXxu3gfMm69MhV0uzkfUNnKEmkBTXE=;
        b=EP1iVAJNfePbfh1XQ73+nj6duWcS7GeX4kDcPDxP4Zm/+vKz4IF61o1LkM32zEI0Zb
         KiOqL32O6LJsNHvJ0j2SjjF5kwdBlhIrCYwE1Kj8DOe3ZFbl7yYWpS0aoBewT2XUSoyc
         aW7E51BsJQV00EOBQKOhqfQ01rbNZJLh6QJ3Ty0FuBKYqGp74uuVxRYUz9g1j/nQBtG7
         xjMERT22SHAsVvI+YnsSbaWBI2/QN87pJcKYsdNPzktxXsAXdJD+L9gTOMnlVGhMuBaq
         bPPZItg0sTNH7G1l0s2LRMK52I4Ft+DIAdQlFp7jobjCEdMmsrZb5kTH0olbnhapauVg
         91MA==
Content-Language: en-US
In-Reply-To: <93f9093b-abec-db7e-a945-263cd9355c08@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kemeng Shi <shikemeng@huaweicloud.com>, tj@kernel.org, josef@toxicpanda.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On 11/30/22 6:45?PM, Kemeng Shi wrote:
> 
> Hi jens,
> on 10/18/2022 8:19 PM, Kemeng Shi wrote:
>> This series contain a few patch to correct comment, correct trace of
>> vtime_rate and so on. More detail can be found in the respective
>> changelogs.
>>
>> ---
>> v2:
>>  Thanks Tejun for review and comment!
>>  Add Acked-by tag from Tejun.
>>  Correct description in patch 3/5 and 4/5.
>>  Drop "blk-iocost: Avoid to call current_hweight_max if iocg->inuse
>> == iocg->active"
>>  Drop "blk-iocost: Remove redundant initialization of struct ioc_gq"
>>  Drop "blk-iocost: Get ioc_now inside weight_updated"
>> ---
>>
>> Kemeng Shi (5):
>>   blk-iocost: Fix typo in comment
>>   blk-iocost: Reset vtime_base_rate in ioc_refresh_params
>>   blk-iocost: Trace vtime_base_rate instead of vtime_rate
>>   blk-iocost: Remove vrate member in struct ioc_now
>>   blk-iocost: Correct comment in blk_iocost_init
>>
>>  block/blk-iocost.c            | 16 +++++++++-------
>>  include/trace/events/iocost.h |  4 ++--
>>  2 files changed, 11 insertions(+), 9 deletions(-)
> Could you apply this patchset?
> By the way, my apply for an cloud variant of email was just passed
> a few days ago. Is this mail still in spam?

This one wasn't, but I've seen the huaweicloud.com emails fail
the same origination checks in the past.

-- 
Jens Axboe
