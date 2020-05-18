From: Wu Bo <wubo40@huawei.com>
Subject: Re: [PATCH] blkcg: Fix memory leak in blkg_conf_prep()
Date: Mon, 18 May 2020 19:34:27 +0800
Message-ID: <5cfba9c1-675d-d4e8-65bf-746712ae32e5@huawei.com>
References: <4c670a6c-98c3-2b14-7438-09199506d92f@web.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4c670a6c-98c3-2b14-7438-09199506d92f@web.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Markus Elfring <Markus.Elfring@web.de>, cgroups@vger.kernel.org, linux-block@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Feilong Lin <linfeilong@huawei.com>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Zhiqiang Liu <liuzhiqiang26@huawei.com>

On 2020/5/15 23:08, Markus Elfring wrote:
> …
>> new_blkg = blkg_alloc(pos, q, GFP_KERNEL);
> …
> 
> I suggest to omit the source code quotation from the change description.
> 
> 
>> if calling blkg_lookup_check() failed, at the IS_ERR block,
>> the new_blkg should be free before goto lable fail_unlock
>> in blkg_conf_prep() function.
> 
> How do you think about a wording variant like the following?
> 
>    If a call of the function “blkg_lookup_check” failed,
>    release the previously allocated block group before jumping
>    to the target “fail_unlock” in the implementation of
>    the function “blkg_conf_prep”.
> 

Thanks for your suggestion. omit the source code quotation from the 
description is more friendly. I will modify the description in V2 patch.

Thanks,
Wu Bo

> 
> Would you like to add the tag “Fixes” to the commit message?
> 
> Regards,
> Markus
> 


