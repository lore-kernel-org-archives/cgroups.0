From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH -next v4 1/5] block, bfq: remove set but not used variable
 in __bfq_entity_update_weight_prio
Date: Wed, 2 Nov 2022 10:18:12 +0800
Message-ID: <61725ff6-6da3-3d3c-4261-7f05c57ab9da@huaweicloud.com>
References: <20221102022542.3621219-1-yukuai1@huaweicloud.com>
 <20221102022542.3621219-2-yukuai1@huaweicloud.com>
 <7f7e59cb-e0b8-0db5-7c46-11aea963bcfa@kernel.dk>
 <ee543096-ae21-99d3-f3a5-483deab03a5f@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <ee543096-ae21-99d3-f3a5-483deab03a5f@kernel.dk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jens Axboe <axboe@kernel.dk>, Yu Kuai <yukuai1@huaweicloud.com>, jack@suse.cz, paolo.valente@linaro.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi,

在 2022/11/02 10:11, Jens Axboe 写道:
> On 11/1/22 8:09 PM, Jens Axboe wrote:
>> On 11/1/22 8:25 PM, Yu Kuai wrote:
>>> From: Yu Kuai <yukuai3@huawei.com>
>>>
>>> After the patch "block, bfq: cleanup bfq_weights_tree add/remove apis"),
>>> the local variable 'bfqd' is not used anymore, thus remove it.
>>
>> Please add a Fixes tag.
> 
> Looks like the rest were good to go, so I added it myself.

Thanks for helping out. I'm not sure which commit id to use since the
fixed patch is not in linux-next yet, does the commit id stay the same
when the patch applied from for-6.2 to next ?

Thanks,
Kuai
> 

