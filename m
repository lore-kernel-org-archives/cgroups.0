From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH -next v4 1/5] block, bfq: remove set but not used variable
 in __bfq_entity_update_weight_prio
Date: Tue, 1 Nov 2022 20:11:23 -0600
Message-ID: <ee543096-ae21-99d3-f3a5-483deab03a5f@kernel.dk>
References: <20221102022542.3621219-1-yukuai1@huaweicloud.com>
 <20221102022542.3621219-2-yukuai1@huaweicloud.com>
 <7f7e59cb-e0b8-0db5-7c46-11aea963bcfa@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SbmauVFQEmSan6s50E+MhbGNKyCBU02VL+TZxUeQNvc=;
        b=M+6ltjJ5juYg7+NGiSDbW3SJhCoF8ZcirhbqZgwnqfhdeVdnq1FE+jcF+gAUmbEzgT
         rSuyovaIt3fTj8NcAmCIK5xfoVJayD2gnhiSf16hf8Li+Yc1NjQLumbPCWcHZYqO+XdF
         70JydiNX8/oytfjKZu1L1vVAXNsT1GblP7RBnsquWb6JEJ2uSh8myzViPJp7DhRZy3ZV
         TxmKZNGoWjnhXzLaCiXtsslVCxYantmR2eF/MVu4y7AiwLx5cqdBlg9dpCvwYUybOBn9
         +6mkJWhTbD5eIIJ/sFblBn1EfXpJ5DdDvKWFIydo7dKhU1Jw5licT8E5O8COV9cSsU9Z
         OGZw==
Content-Language: en-US
In-Reply-To: <7f7e59cb-e0b8-0db5-7c46-11aea963bcfa@kernel.dk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai1@huaweicloud.com>, jack@suse.cz, paolo.valente@linaro.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On 11/1/22 8:09 PM, Jens Axboe wrote:
> On 11/1/22 8:25 PM, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> After the patch "block, bfq: cleanup bfq_weights_tree add/remove apis"),
>> the local variable 'bfqd' is not used anymore, thus remove it.
> 
> Please add a Fixes tag.

Looks like the rest were good to go, so I added it myself.

-- 
Jens Axboe


