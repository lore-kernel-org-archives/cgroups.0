From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH -next v3 0/3] blk-cgroup: make sure pd_free_fn() is called
 in order
Date: Sun, 29 Jan 2023 14:48:50 -0700
Message-ID: <7f3221eb-d5c1-5018-cdcc-979d436fa386@kernel.dk>
References: <20230119110350.2287325-1-yukuai1@huaweicloud.com>
 <bd1c347b-cbf8-3917-401a-ed85c6ccb956@kernel.dk>
 <0ddce9e4-d027-0bb0-d260-093ccc4c2d4d@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3orRjVyl8TlIILy5P9DmDDw4aLYfFk+iiK2J9hLXKM8=;
        b=K1fLjf+3hEV58xhvHFnsNkPRmfFbB/yPlBUiSkM2CGxnZWzGSqtk3KPkx/ha0qH3ZL
         UKBWyX3E+s/0xU9Zz8QEPIxguy8r0W4uChf90dCI7oDJs7z6Xit2L4Ta5Xze4aK5G7tv
         FOsD3TnzR8xOKdHZEO4CsX2VJFgrAz5On4sCtcTX21R/BUdUqP0BMQ3GZNfUpClv8w4J
         xWlqFlMyL2XxrVsk/HOj/vTQrXWSJwPmqqgCiOqy/yPTe8WtXA5FWBlcar420KcW7b/o
         gdPKdWaDk9ql92NcXajcU66E8LOcwnb3ynt0bPiEOJ7CuBm/IzYAQVKhHDDRheSz+Lav
         ESxg==
Content-Language: en-US
In-Reply-To: <0ddce9e4-d027-0bb0-d260-093ccc4c2d4d@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yu Kuai <yukuai1@huaweicloud.com>, tj@kernel.org, hch@lst.de, josef@toxicpanda.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

On 1/28/23 11:06 PM, Yu Kuai wrote:
> Hi, Jens
> 
> 在 2023/01/20 2:54, Jens Axboe 写道:
>> On 1/19/23 4:03 AM, Yu Kuai wrote:
>>> From: Yu Kuai <yukuai3@huawei.com>
>>>
>>> Changes in v3:
>>>   - add ack tag from Tejun for patch 1,2
>>>   - as suggested by Tejun, update commit message and comments in patch 3
>>>
>>> The problem was found in iocost orignally([1]) that ioc can be freed in
>>> ioc_pd_free(). And later we found that there are more problem in
>>> iocost([2]).
>>>
>>> After some discussion, as suggested by Tejun([3]), we decide to fix the
>>> problem that parent pd can be freed before child pd in cgroup layer
>>> first. And the problem in [1] will be fixed later if this patchset is
>>> applied.
>>
>> Doesn't apply against for-6.3/block (or linux-next or my for-next, for
>> that matter). Can you resend a tested one against for-6.3/block?
>>
> 
> This is weird, I just test latest linux-next, and I can apply this
> patchset on the top of following commit:
> 
> For latest for-6.3/block, this patch 2 can't be applied because
> following commit is not here:
> 
> e3ff8887e7db blk-cgroup: fix missing pd_online_fn() while activating policy
> 
> But this patch is already merged into 6.2-rc5.

Since I have one more conflict, I think we'll just rebase for-6.3/block
when -rc6 is out, and then it should apply cleanly.

-- 
Jens Axboe


