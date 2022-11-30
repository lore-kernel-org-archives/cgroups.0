From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next v2 2/9] blk-iocost: improve hanlder of match_u64()
Date: Wed, 30 Nov 2022 10:32:19 -1000
Message-ID: <Y4e90zFnhhq764lP@slm.duckdns.org>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-3-linan122@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s+f73qQSWaZWQn5PMXIm5ddroitzO0fXj2VGSW5dgd4=;
        b=BGROMH3G14bf8t+5QZBF8EIw7DJlp2M69BITlayk5RGIWu5mNUNjLIwEntSuAXgoGO
         P87aZf2H9okTAtAvyUGhhYTXP1R1c0HvcGtF6oOmpH/AsjC2ZnLAUM+ZDFG50EtBaeM5
         KGLxpgoe1IdmVLAWtMdASGG8Y3NNnio4jdbNm5Jbz8nofwg0orveW/0yTrYkaCQgsF+J
         kmWIYEdlCmYOvqZCmsZDw8NVEZcFR7/wa0FmfXM7HlJWFPXVTu95gDNR/uE6f8xdr5YO
         d7vb4ikzLzG+TKHr2tWloyVj9jbP7mTm2qutSQ17RdzICHvycDY59fIM+h5QlDG8du51
         19ag==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221130132156.2836184-3-linan122@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Nan <linan122@huawei.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Wed, Nov 30, 2022 at 09:21:49PM +0800, Li Nan wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> 1) There are one place that return value of match_u64() is not checked.
> 2) If match_u64() failed, return value is set to -EINVAL despite that
>    there are other possible errnos.

Ditto. Does this matter?

-- 
tejun
