From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block, bfq: fix uaf for bfqq in bic_set_bfqq()
Date: Sun, 29 Jan 2023 14:51:38 -0700
Message-ID: <7ae20fa2-d9b4-9e21-4209-81bf4845a3c5@kernel.dk>
References: <20230113094410.2907223-1-yukuai3@huawei.com>
 <4d3f6183-f9d4-b657-0205-fc240bc24c76@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=10Pr4T3evkPPQKg3Z4WSUnPLk+n8TOgwlOyguzNlXvc=;
        b=kQM+1CafTz4AifPNzW97tONzVLTLm+vEF8Iyye32LSIsoi36btod+M6SMhwuSjChID
         zoAjW+MhRE5AHd/9nnVasiSpPfx2pFhRz3w2VPXdeyyOtvIb0S/9kAPn3cO7p/a5Bids
         4i0kl0sV79hfhMzgfrww/yDdoYXYhA93VWWmIWzdY4wLIh8bCkz6sf4Dv0eT/eJBHJVw
         CX1cNIeOco0O1UHvXPSnM9nKEC4GoupqFJ3XcRc641i547oql4Ae23OUNhxjPGAluSYA
         vevkYAgoZjnI4OWp703RysiiS3knD9jAWzR/HP2wCXH/XmwtGDrxBiMBb9lx7oai85kP
         Ny+w==
Content-Language: en-US
In-Reply-To: <4d3f6183-f9d4-b657-0205-fc240bc24c76@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yu Kuai <yukuai1@huaweicloud.com>, jack@suse.cz, tj@kernel.org, josef@toxicpanda.com, paolo.valente@linaro.org, shinichiro.kawasaki@wdc.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

On 1/28/23 6:38 PM, Yu Kuai wrote:
> Hi, Jens
> 
> 在 2023/01/13 17:44, Yu Kuai 写道:
>> After commit 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'"),
>> bic->bfqq will be accessed in bic_set_bfqq(), however, in some context
>> bic->bfqq will be freed first, and bic_set_bfqq() is called with the freed
>> bic->bfqq.
>>
>> Fix the problem by always freeing bfqq after bic_set_bfqq().
>>
> 
> Sorry that I send this patch will wrong email, and you might missed this
> patch.
> 
> Can you apply this patch? This patch can't be applied directly to lower
> version due to Paolo's patchset, I'll send lts patch seperately.

I'm confused... So this patch only applies to the 6.3 branch, yet we
need it in 6.2 as far as I can tell. Why isn't it against block-6.2
then?

-- 
Jens Axboe


