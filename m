From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 4/5] blk-iocost: fix sleeping in atomic context
 warnning
Date: Tue, 22 Nov 2022 17:14:29 -0700
Message-ID: <1f52ccb1-c357-a2a0-ef9d-48d7e2eb51f8@kernel.dk>
References: <20221104023938.2346986-1-yukuai1@huaweicloud.com>
 <20221104023938.2346986-5-yukuai1@huaweicloud.com>
 <Y3K8MSFWw8eTnxtm@slm.duckdns.org>
 <3da991c6-21e4-8ed8-ba75-ccb92059f0ae@huaweicloud.com>
 <Y306xJV6aNXd94kb@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qSXez7TMqEXPVH18DMil2V+wMo2ZAq8fU8n9Svrm0YU=;
        b=ttIttDPZTykCFPR3yUs+dkffd67+C/A5MJ4fjN6FD+7T43G1YL8Nk6mcVeB9JjVkXw
         gi32sFfDUwtdO5dpXDeb6QBf2ncMZm9XF8fJGMkN+1ZgADqJ8mjuxQeYoQ13AG+PRwID
         h0N+LcbcG84cYpzmSdiSPiimEhxTrl/3izqU9Oki/3QOcg9DwKHTId350Q05Xu/5q03W
         +RzHliDUY0k/H2L7qOGzhs5f+mLdOuKqxRlwV1RAfI1afEZ1ol4mDSxmGEnUF4zV6lYS
         C9LS/8OzmHlDuxle0r1MBda7KUlW6NkHgcdYImd+cbzJWGzZbf5s5Z6jIbhuljCi95bI
         Xc9Q==
Content-Language: en-US
In-Reply-To: <Y306xJV6aNXd94kb@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, josef@toxicpanda.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

On 11/22/22 2:10 PM, Tejun Heo wrote:
> On Thu, Nov 17, 2022 at 07:28:50PM +0800, Yu Kuai wrote:
>> Hi, Tejun!
>>
>> 在 2022/11/15 6:07, Tejun Heo 写道:
>>
>>>
>>> Any chance I can persuade you into updating match_NUMBER() helpers to not
>>> use match_strdup()? They can easily disable irq/preemption and use percpu
>>> buffers and we won't need most of this patchset.
>>
>> Does the following patch match your proposal?
>>
>> diff --git a/lib/parser.c b/lib/parser.c
>> index bcb23484100e..ded652471919 100644
>> --- a/lib/parser.c
>> +++ b/lib/parser.c
>> @@ -11,6 +11,24 @@
>>  #include <linux/slab.h>
>>  #include <linux/string.h>
>>
>> +#define U64_MAX_SIZE 20
>> +
>> +static DEFINE_PER_CPU(char, buffer[U64_MAX_SIZE]);
>> +
>> +static char *get_buffer(void)
>> +{
>> +       preempt_disable();
>> +       local_irq_disable();
>> +
>> +       return this_cpu_ptr(buffer);
>> +}
>> +
>> +static void put_buffer(void)
>> +{
>> +       local_irq_enable();
>> +       preempt_enable();
>> +}
>> +
>>
>> Then match_strdup() and kfree() in match_NUMBER() can be replaced with
>> get_buffer() and put_buffer().
> 
> Sorry about the late reply. Yeah, something like this.

Doesn't local_irq_disable() imply preemption disable as well?

-- 
Jens Axboe


