From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/5] block: add a queue_has_disk helper
Date: Mon, 9 Aug 2021 17:18:20 +0200
Message-ID: <20210809151820.GG30319@quack2.suse.cz>
References: <20210809141744.1203023-1-hch@lst.de>
 <20210809141744.1203023-4-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1628522301; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+7LQfr+QS70hPlEzdXU5UNfASl0hm6MYjCpn/TJE3Bc=;
        b=R4vTQk1xooDBp9mWzIXzqhwLD4CIHqYAxE00uuxm9oLbJhzDcwNh6qmud4FPuBHxoWpTKs
        /uupXehqAF9P9KZgz9j+mFeb0T4LfBlR3IfbjX03lQLinlhL1epZQVP3/ha2pv01dqhbhx
        Q4tSeteWdiPwWSpi+KBAapfqQhD7tok=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1628522301;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+7LQfr+QS70hPlEzdXU5UNfASl0hm6MYjCpn/TJE3Bc=;
        b=dm/cqvOl95qsMUroycYmEaR6xavGIMxMc49ZUMkfh0XYG2GNLNuYmbuk7HNcvA2Psn69/P
        q05ZLbbK32ovACDg==
Content-Disposition: inline
In-Reply-To: <20210809141744.1203023-4-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Mon 09-08-21 16:17:42, Christoph Hellwig wrote:
> Add a helper to check if a gendisk is associated with a request_queue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/blkdev.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index ac3642c88a4d..96f3d9617cd8 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -664,6 +664,7 @@ extern void blk_clear_pm_only(struct request_queue *q);
>  	dma_map_page_attrs(dev, (bv)->bv_page, (bv)->bv_offset, (bv)->bv_len, \
>  	(dir), (attrs))
>  
> +#define queue_has_disk(q)	((q)->kobj.parent != NULL)
>  #define queue_to_disk(q)	(dev_to_disk(kobj_to_dev((q)->kobj.parent)))
>  
>  static inline bool queue_is_mq(struct request_queue *q)
> -- 
> 2.30.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
