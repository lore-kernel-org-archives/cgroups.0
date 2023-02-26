From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blk-iocost: initialize rqos before accessing it
Date: Sun, 26 Feb 2023 06:55:49 -1000
Message-ID: <Y/uPFT7w+XQ9l0XE@slm.duckdns.org>
References: <20230224160714.172884-1-leitao@debian.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dMPivgJa9Oydx7VmSkBWz8cuJBhAofxxDmT7xZiRGT8=;
        b=YGFy8IrwraZ8VPbC+3pXv+6dmojn5DoM1MLgkBS6s4qQtrwOeHXBACjnod1Gw29N8n
         v0qmBVrA6mGM4mhinsGj/aienDuaaszJfR3o6//7RMPlp4k/0Cx8GavKNpa4QpkAJvUs
         EJpqeCzx6XNA/k5AYi1uM9L/NKfIJGhFntEVNRnME+nb/CtSU0lMmm7QQMzH8k4fo6IF
         O7hfZ0jr2PJy5KRTkWe/4S0Y3TVSFp4nWxgj2GeR5QVYZ5dxr4bRKE9ujxpyo5WmL8M1
         EQERtMjV7Y1MsM+NkeQ/bM2dG+dlnCq2o2RnBeitueq55OMtZionUNaaGvE53E6apL7S
         pOAA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230224160714.172884-1-leitao@debian.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Breno Leitao <leitao@debian.org>
Cc: axboe@kernel.dk, josef@toxicpanda.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, aherrmann@suse.de, linux-kernel@vger.kernel.org, hch@lst.de, leit@fb.com

Hello, Breno.

On Fri, Feb 24, 2023 at 08:07:14AM -0800, Breno Leitao wrote:
> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index ff534e9d92dc..6cced8a76e9c 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -2878,11 +2878,6 @@ static int blk_iocost_init(struct gendisk *disk)
>  	atomic64_set(&ioc->cur_period, 0);
>  	atomic_set(&ioc->hweight_gen, 0);
>  
> -	spin_lock_irq(&ioc->lock);
> -	ioc->autop_idx = AUTOP_INVALID;
> -	ioc_refresh_params(ioc, true);
> -	spin_unlock_irq(&ioc->lock);
> -
>  	/*
>  	 * rqos must be added before activation to allow ioc_pd_init() to
>  	 * lookup the ioc from q. This means that the rqos methods may get
> @@ -2893,6 +2888,11 @@ static int blk_iocost_init(struct gendisk *disk)
>  	if (ret)
>  		goto err_free_ioc;
>  
> +	spin_lock_irq(&ioc->lock);
> +	ioc->autop_idx = AUTOP_INVALID;
> +	ioc_refresh_params(ioc, true);
> +	spin_unlock_irq(&ioc->lock);
> +

I'm a bit worried about registering the rqos before ioc_refresh_params() as
that initializes all the internal parameters and letting IOs flow through
without initializing them can lead to subtle issues. Can you please instead
explicitly pass @q into ioc_refresh_params() (and explain why we need it
passed explicitly in the function comment)?

Thanks.

-- 
tejun
