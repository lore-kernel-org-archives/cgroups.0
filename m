From: Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH] block: update comment for blkcg_init_queue
Date: Wed, 15 Jun 2022 14:21:09 +0800
Message-ID: <01f643e5-fb5e-66fd-7bf9-937738bf306d@linux.dev>
References: <20220614100556.20899-1-guoqing.jiang@linux.dev>
 <Yql5wrthJvZDwWjq@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655274074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K+BrZJXhMDum/6TJS5sDJvhBvlhj3O3wcmdCRorhGJw=;
        b=q+doxS9i9J+cKS1j+UR1+qnyyCNL/d67EeHR9UaA1PWBpc9S4MAzN5aYWECzG66h0Se49T
        XVxKr98PGSU0mgQp2isWfh4MDdMeCg1yaFAG0bN1aSp8d9Uo/Gbm28C5qH5jMw9xYfN1vD
        /Le4qjIl1j17nYUAoVUpk1aIsD12u2g=
In-Reply-To: <Yql5wrthJvZDwWjq@infradead.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch@infradead.org>
Cc: tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org



On 6/15/22 2:18 PM, Christoph Hellwig wrote:
> On Tue, Jun 14, 2022 at 06:05:56PM +0800, Guoqing Jiang wrote:
>> It was called from __alloc_disk_node since commit 1059699f87eb ("block:
>> move blkcg initialization/destroy into disk allocation/release handler).
>> Let's change the comment accordingly.
> Well, the right things is to simply drop this comment.  I do have
> a large series toucing it and removing it, so maybe we can wait
> until that?

Sure, I am fine with it.

Thanks,
Guoqing
