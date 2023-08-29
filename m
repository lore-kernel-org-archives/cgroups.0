From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next v2 4/4] blk-throttle: consider
 'carryover_ios/bytes' in throtl_trim_slice()
Date: Tue, 29 Aug 2023 12:20:23 -1000
Message-ID: <ZO5vJ2i3qfvtBC7B@slm.duckdns.org>
References: <20230816012708.1193747-1-yukuai1@huaweicloud.com>
 <20230816012708.1193747-5-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693347625; x=1693952425; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4J2rbxAFjfp7sOlwJ88FE+lmdis9M2FRPFOfqh2wKcA=;
        b=KbXbxf6xPoayllgDXklz5FTcjILcyk4nl5NJJLO+rUG8YC+n82O2+8BByDDZ09JMkY
         PuM5d+EVVYDUyn7tI4sri+Y/X89Cs830F2BAK7f0ljWfS/kEPl4pnAQSw/4nnQkzQtd4
         yfzzt2Fxw1ehkpTJRskQVEv8ccCEbqqQuSglP35dlV5Vp/tek9iC5XjegbSEabDfoEoO
         bz2St0mBliPDu0xtkTkt2cmwW7mgCa2ImDe0YKO5b6X2478MjpBiV/h/mwxObSlhc8k8
         hLGY2wajQgUWrPgc2jppHYKya/rJMDbJ781EWNP+EAG6heMSUp2RnCM5OkN4YyEmIb2+
         V6HA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230816012708.1193747-5-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, yukuai3@huawei.com, mkoutny@suse.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com

On Wed, Aug 16, 2023 at 09:27:08AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Currently, 'carryover_ios/bytes' is not handled in throtl_trim_slice(),
> for consequence, 'carryover_ios/bytes' will be used to throttle bio
> multiple times, for example:
> 
> 1) set iops limit to 100, and slice start is 0, slice end is 100ms;
> 2) current time is 0, and 10 ios are dispatched, those io won't be
>    throttled and io_disp is 10;
> 3) still at current time 0, update iops limit to 1000, carryover_ios is
>    updated to (0 - 10) = -10;
> 4) in this slice(0 - 100ms), io_allowed = 100 + (-10) = 90, which means
>    only 90 ios can be dispatched without waiting;
> 5) assume that io is throttled in slice(0 - 100ms), and
>    throtl_trim_slice() update silce to (100ms - 200ms). In this case,
>    'carryover_ios/bytes' is not cleared and still only 90 ios can be
>    dispatched between 100ms - 200ms.
> 
> Fix this problem by updating 'carryover_ios/bytes' in
> throtl_trim_slice().
> 
> Fixes: a880ae93e5b5 ("blk-throttle: fix io hung due to configuration updates")
> Reported-by: zhuxiaohui <zhuxiaohui.400@bytedance.com>
> Link: https://lore.kernel.org/all/20230812072116.42321-1-zhuxiaohui.400@bytedance.com/
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
