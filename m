From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next v2 3/4] blk-throttle: use
 calculate_io/bytes_allowed() for throtl_trim_slice()
Date: Tue, 29 Aug 2023 12:20:06 -1000
Message-ID: <ZO5vFujDLng0kg_x@slm.duckdns.org>
References: <20230816012708.1193747-1-yukuai1@huaweicloud.com>
 <20230816012708.1193747-4-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693347608; x=1693952408; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kFuNpAVo+v+BaNd7xetve7hcqsQN8Vv/yJKgXgf5i4U=;
        b=K2O1r+ZclVj+dWaqFq/Qzm8fiu08xZa7R6nbxHsFQ9meQmlwgepdkpBZrUCluyvDi4
         PzQDsPreTH0A9FniexFSDI7aJ/uVC0TMd6VWXBueyfDimpfs87CEk4+iO3YloGut03OH
         1aGLvCwH0Atm2a6ADCz1PB11Qvg/Nk3hDtKi1stSp9ewIVNbDoA4bLnD27Bcvn3DoGty
         hzMdWNG/AG+V6UxwTzalZVKnUFwnmn7Cge1Q7BmZDS1aVohX3AhRqiy2HKBks6axar9o
         fJ7UrL11J5Lwn/umvFydB1jRNyXQRd4oCB5R5uBSwc9AsxFn6vwVwt658xw9p3lWnyTq
         OhDg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230816012708.1193747-4-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, yukuai3@huawei.com, mkoutny@suse.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com

On Wed, Aug 16, 2023 at 09:27:07AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> There are no functional changes, just make the code cleaner.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
