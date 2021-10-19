From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 -next 1/2] blk-cgroup: don't call
 blk_mq_freeze_queue() in blkcg_deactivate_policy()
Date: Tue, 19 Oct 2021 07:00:49 -1000
Message-ID: <YW75wUcf9CcmqdD5@slm.duckdns.org>
References: <20211019024132.432458-1-yukuai3@huawei.com>
 <20211019024132.432458-2-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5oDh6wY5mxgjBgRFmj6OpdKqeAcazi57fngXpPsPLWE=;
        b=lRts9Q2QN5BocnpFjJPqpBK3Fxaxv4kEBoF/rHLBeWaGIYwAxlKsPIhkQCB7sNAmRj
         UERoxRYtgRGMzur8k2GM5Y/uFfigfGYqd1hcqOryGHOglz1dxWtZNVUYhgx0tD+hilKq
         V8/oWKqn3J2sTUprRMG/t7pLpLgbMEIoyy/+Yyr6FKU3FUd/0I1Urd0FLCulQCkhKyz8
         4TLlu7kFoFyRAEOHLSuV4dkq9oUAiIfZuvxmu4RCbRc28MpW7etPuuxUZLeetNOmIejx
         9MpRHH231nr3EYgiUBiOpX+2Z1SpFRYcJy86zemrDgVuzLz5/JQWebAYxJqNe4SaNEB/
         rBww==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20211019024132.432458-2-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: axboe@kernel.dk, paolo.valente@linaro.org, avanzini.arianna@gmail.com, fchecconi@gmail.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

Hello,

On Tue, Oct 19, 2021 at 10:41:31AM +0800, Yu Kuai wrote:
> blkcg_deactivate_policy() can be called from either
> blk_cleanup_queue() for all policies or elevator_switch() for bfq
> policy. Thus there is no need to freeze queue in
> blkcg_deactivate_policy() since the caller freeze the queue aready.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

I would just keep the calls. The operation requires the q to be frozen and
there isn't a good way to annotate that the caller must be holding a usage
count, so it's useful even just as documentation.

Thanks.

-- 
tejun
