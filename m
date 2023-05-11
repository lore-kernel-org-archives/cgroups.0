From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH -next 1/6] blk-wbt: fix that wbt can't be disabled by
 default
Date: Thu, 11 May 2023 17:19:19 +0200
Message-ID: <20230511151919.GA7880@lst.de>
References: <20230511014509.679482-1-yukuai1@huaweicloud.com> <20230511014509.679482-2-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230511014509.679482-2-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-jcswGhMUV9g@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Thu, May 11, 2023 at 09:45:04AM +0800, Yu Kuai wrote:
> @@ -730,8 +730,9 @@ void wbt_enable_default(struct gendisk *disk)
>  {
>  	struct request_queue *q = disk->queue;
>  	struct rq_qos *rqos;
> -	bool disable_flag = q->elevator &&
> -		    test_bit(ELEVATOR_FLAG_DISABLE_WBT, &q->elevator->flags);
> +	bool disable_flag = (q->elevator &&
> +		    test_bit(ELEVATOR_FLAG_DISABLE_WBT, &q->elevator->flags)) ||
> +		    !IS_ENABLED(CONFIG_BLK_WBT_MQ);

Not really new in your patch, but I find the logic here very confusing.
First the disable_flag really should be enable instead, as that's how
it's actually checked, and then spelling out the conditions a bit more
would really help readability.  E.g.

	bool enabled = IS_ENABLED(CONFIG_BLK_WBT_MQ);

	if (q->elevator &&
	    test_bit(ELEVATOR_FLAG_DISABLE_WBT, &q->elevator->flags))
		enable = false;

