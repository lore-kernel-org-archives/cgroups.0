From: Andreas Herrmann <aherrmann@suse.de>
Subject: Re: [PATCH 08/15] blk-wbt: open code wbt_queue_depth_changed in
 wbt_update_limits
Date: Fri, 20 Jan 2023 10:21:46 +0100
Message-ID: <Y8pdKiV4s7rvOMF5@suselix>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-9-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674206509; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8DUEI+/9ZHTe402IQZx5GdLdzfOs7lN387guOhnS35U=;
        b=p7xCq1QgziS2jPdK++PkEz4kRl/t9CrdMkOHbbd9RGQQoMpgS5HRSB/EVpRMqWtMhXHJ1G
        6LDGAZzdbuMfgeGFQ5smgRQFHlgv25vogecUsHNbkve2lgFampGT0HaDHXkxSDzFujHCEl
        5B+iCOf04G6T5EuURqAcEaEBfPp8/cw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674206509;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8DUEI+/9ZHTe402IQZx5GdLdzfOs7lN387guOhnS35U=;
        b=d2pV8G7fXa3UCM2L70v/X5fOXSEGlLyMSH8fql5FitqtWs59qZ07x9qHeOG6xCA1JzGfJX
        vmFJYMlRf9kWvlCQ==
Content-Disposition: inline
In-Reply-To: <20230117081257.3089859-9-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org

On Tue, Jan 17, 2023 at 09:12:50AM +0100, Christoph Hellwig wrote:
> No real need to all the method here, so open code to it to prepare
> for some paramter passing changes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-wbt.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Looks good to me. Feel free to add
Reviewed-by: Andreas Herrmann <aherrmann@suse.de>

> diff --git a/block/blk-wbt.c b/block/blk-wbt.c
> index 542271fa99e8f7..473ae72befaf1a 100644
> --- a/block/blk-wbt.c
> +++ b/block/blk-wbt.c
> @@ -863,9 +863,9 @@ int wbt_init(struct gendisk *disk)
>  	rwb->enable_state = WBT_STATE_ON_DEFAULT;
>  	rwb->wc = test_bit(QUEUE_FLAG_WC, &q->queue_flags);
>  	rwb->rq_depth.default_depth = RWB_DEF_DEPTH;
> +	rwb->rq_depth.queue_depth = blk_queue_depth(q);
>  	rwb->min_lat_nsec = wbt_default_latency_nsec(q);
> -
> -	wbt_queue_depth_changed(&rwb->rqos);
> +	wbt_update_limits(rwb);
>  
>  	/*
>  	 * Assign rwb and add the stats callback.
> -- 
> 2.39.0
> 

-- 
Regards,
Andreas

SUSE Software Solutions Germany GmbH
Frankenstrasse 146, 90461 Nürnberg, Germany
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Martje Boudien Moerman
(HRB 36809, AG Nürnberg)
