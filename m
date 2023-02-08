From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] blk-iocost: fix sleeping in atomic warning for
 wbt_enable_default()
Date: Wed, 8 Feb 2023 09:06:01 -1000
Message-ID: <Y+PymbdtPVONbQAq@slm.duckdns.org>
References: <20230208034803.2818155-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rRaVZ9/X0IStuyPV6O60UspWE6lsQv03L6mbYwCmPI4=;
        b=BKzuUbCjDPwgJnJ3Jej0RMuyANAxCWK3m/MfztEgheROrMlQXQbl+C0fQhEkSkQqWM
         c+HcZfCGMr21T2mRkK7wW4uDJnEQBxHIPFq0tSGFdthcOzh1UC8pBjM+Od5pI5gMRtVV
         aXY/rHgTTfG4hQRP3m7twkNWPu5U+H/a2z8fp4O/sIsbzWmnyl5E+JvlzmsYNheFsLvZ
         jRXzjQaAKD6mPamQd4kc0HJwzrQr2fbQYrwsKQPbfBu827q+sqPQcZ+64i3pa8BxTRTA
         xDDri/kpY/8FtEBfumEf24xMYUdguB9wz/Ut02XU0lmFnpost9Ebhe1m/+3Bz+zhmNlT
         9kbg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230208034803.2818155-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, Feb 08, 2023 at 11:48:03AM +0800, Yu Kuai wrote:
> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index 7a2dc9dc8e3b..03bfe1dda07c 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -3279,11 +3279,9 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
>  		blk_stat_enable_accounting(disk->queue);
>  		blk_queue_flag_set(QUEUE_FLAG_RQ_ALLOC_TIME, disk->queue);
>  		ioc->enabled = true;
> -		wbt_disable_default(disk);
>  	} else {
>  		blk_queue_flag_clear(QUEUE_FLAG_RQ_ALLOC_TIME, disk->queue);
>  		ioc->enabled = false;
> -		wbt_enable_default(disk);
>  	}
>  
>  	if (user) {
> @@ -3296,6 +3294,10 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
>  	ioc_refresh_params(ioc, true);
>  	spin_unlock_irq(&ioc->lock);
>  
> +	if (enable)
> +		wbt_disable_default(disk);
> +	else
> +		wbt_enable_default(disk);

Wouldn't this allow two competiting config attempts to race each other and
leave wbt in an unexpected state?

	task1				task2

	ioc_qos_write()			ioc_qos_write()
	lock()
	enable
	unlock()
					lock()
					disable
					unlock()
					wbt_enable_default()
	wbt_disable_default()

Thanks.

-- 
tejun
