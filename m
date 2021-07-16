From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-throtl: optimize IOPS throttle for large IO scenarios
Date: Fri, 16 Jul 2021 06:09:07 -1000
Message-ID: <YPGvIzZUI+QxP1js@mtj.duckdns.org>
References: <1626416569-30907-1-git-send-email-brookxu.cn@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DZ7+7XgWM6hQZ0UFtx/++E9LOP3fUxSddmlsFwD/FAU=;
        b=LcFKQKWZBfnq7ztPttKD1EbLu0EBOsYfhH+Xea8T15YwjWbDADhRGBr18+d6n61OVu
         z7n5JLWPOGWy5CNStdZkiMoKjYfnMG2YTd2JNbg2iWu4a2ZBc2YIsiIuGy6jdls+3s9W
         302dsxPjS2wQQXj29r8Jgv95+YcOpGD0QfErsc8+ssZlMky0D3o0sKhgWdYQB4xi9T04
         wJZs7qxVFBwT2kRkPtKJFfEMKyf7wnmeQbdmaDUEAY5bOUJ0qAvGf9vvFfxzT61EVjQ4
         6g/XIQGoDJ9V/v3YONni7BR71ImbpC4eEBzddwe3PxiP215sH627dkBSOAP/6V8ER7zz
         5xHg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1626416569-30907-1-git-send-email-brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Jul 16, 2021 at 02:22:49PM +0800, brookxu wrote:
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index a11b3b5..86ff943 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -348,6 +348,8 @@ void __blk_queue_split(struct bio **bio, unsigned int *nr_segs)
>  		trace_block_split(split, (*bio)->bi_iter.bi_sector);
>  		submit_bio_noacct(*bio);
>  		*bio = split;
> +
> +		blk_throtl_recharge_bio(*bio);

I don't think we're holding the queue lock here.

>  	}
>  }
>  
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index b1b22d8..1967438 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -2176,6 +2176,40 @@ static inline void throtl_update_latency_buckets(struct throtl_data *td)
>  }
>  #endif
>  
> +void blk_throtl_recharge_bio(struct bio *bio)
> +{
> +	bool rw = bio_data_dir(bio);
> +	struct blkcg_gq *blkg = bio->bi_blkg;
> +	struct throtl_grp *tg = blkg_to_tg(blkg);
> +	u32 iops_limit = tg_iops_limit(tg, rw);
> +
> +	if (iops_limit == UINT_MAX)
> +		return;
> +
> +	/*
> +	 * If previous slice expired, start a new one otherwise renew/extend
> +	 * existing slice to make sure it is at least throtl_slice interval
> +	 * long since now. New slice is started only for empty throttle group.
> +	 * If there is queued bio, that means there should be an active
> +	 * slice and it should be extended instead.
> +	 */
> +	if (throtl_slice_used(tg, rw) && !(tg->service_queue.nr_queued[rw]))
> +		throtl_start_new_slice(tg, rw);
> +	else {
> +		if (time_before(tg->slice_end[rw],
> +		    jiffies + tg->td->throtl_slice))
> +			throtl_extend_slice(tg, rw,
> +				jiffies + tg->td->throtl_slice);
> +	}
> +
> +	/* Recharge the bio to the group, as some BIOs will be further split
> +	 * after passing through the throttle, causing the actual IOPS to
> +	 * be greater than the expected value.
> +	 */
> +	tg->last_io_disp[rw]++;
> +	tg->io_disp[rw]++;
> +}

But blk-throtl expects queue lock to be held.

How about doing something simpler? Just estimate how many bios a given bio
is gonna be and charge it outright? The calculation will be duplicated
between the split path but that seems like the path of least resistance
here.

Thanks.

-- 
tejun
