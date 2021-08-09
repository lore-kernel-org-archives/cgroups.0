From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] block: move the bdi from the request_queue to the
 gendisk
Date: Mon, 9 Aug 2021 17:47:28 +0200
Message-ID: <20210809154728.GH30319@quack2.suse.cz>
References: <20210809141744.1203023-1-hch@lst.de>
 <20210809141744.1203023-5-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1628524049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qmshEYCepuicqe7nGBsgApKga31dwcT/zEh+RqblNMs=;
        b=agM0VX0VPGuoPOIl/2H+VcE1o5AGK3BCM4UnBUI6MYNqlkRAI/3H4VoB5qA84W3kjSlTfD
        Z9ggSkT9XnFWSO25m6csQs3+JNzxpFQnZJeOuJ1+mk1sBUpUe2/ceH/SsQh8Hr5QZ8dKFK
        jN+xSHRj4A3B7EHDhGEf6s7R+YbGGrA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1628524049;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qmshEYCepuicqe7nGBsgApKga31dwcT/zEh+RqblNMs=;
        b=XLUJqXiPPDvzdKKUd1LQ7osqEEWYNMxwNToii1Ge7QTyGP+5QXUiWk9L9Qv6u3Ke1QAWD4
        0w33iFAws9hdA+DA==
Content-Disposition: inline
In-Reply-To: <20210809141744.1203023-5-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Mon 09-08-21 16:17:43, Christoph Hellwig wrote:
> The backing device information only makes sense for file system I/O,
> and thus belongs into the gendisk and not the lower level request_queue
> structure.  Move it there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks mostly good. I'm just unsure whether some queue_to_disk() calls are
safe.

> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 2c4ac51e54eb..d2725f94491d 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -525,7 +525,7 @@ void blk_mq_free_request(struct request *rq)
>  		__blk_mq_dec_active_requests(hctx);
>  
>  	if (unlikely(laptop_mode && !blk_rq_is_passthrough(rq)))
> -		laptop_io_completion(q->backing_dev_info);
> +		laptop_io_completion(queue_to_disk(q)->bdi);
> 

E.g. cannot this get called for a queue that is without a disk?

> diff --git a/block/blk-wbt.c b/block/blk-wbt.c
> index 3ed71b8da887..31086afaad9c 100644
> --- a/block/blk-wbt.c
> +++ b/block/blk-wbt.c
> @@ -97,7 +97,7 @@ static void wb_timestamp(struct rq_wb *rwb, unsigned long *var)
>   */
>  static bool wb_recent_wait(struct rq_wb *rwb)
>  {
> -	struct bdi_writeback *wb = &rwb->rqos.q->backing_dev_info->wb;
> +	struct bdi_writeback *wb = &queue_to_disk(rwb->rqos.q)->bdi->wb;
>  
>  	return time_before(jiffies, wb->dirty_sleep + HZ);
>  }
> @@ -234,7 +234,7 @@ enum {
>  
>  static int latency_exceeded(struct rq_wb *rwb, struct blk_rq_stat *stat)
>  {
> -	struct backing_dev_info *bdi = rwb->rqos.q->backing_dev_info;
> +	struct backing_dev_info *bdi = queue_to_disk(rwb->rqos.q)->bdi;
>  	struct rq_depth *rqd = &rwb->rq_depth;
>  	u64 thislat;
>  
> @@ -287,7 +287,7 @@ static int latency_exceeded(struct rq_wb *rwb, struct blk_rq_stat *stat)
>  
>  static void rwb_trace_step(struct rq_wb *rwb, const char *msg)
>  {
> -	struct backing_dev_info *bdi = rwb->rqos.q->backing_dev_info;
> +	struct backing_dev_info *bdi = queue_to_disk(rwb->rqos.q)->bdi;
>  	struct rq_depth *rqd = &rwb->rq_depth;
>  
>  	trace_wbt_step(bdi, msg, rqd->scale_step, rwb->cur_win_nsec,
> @@ -359,8 +359,8 @@ static void wb_timer_fn(struct blk_stat_callback *cb)
>  
>  	status = latency_exceeded(rwb, cb->stat);
>  
> -	trace_wbt_timer(rwb->rqos.q->backing_dev_info, status, rqd->scale_step,
> -			inflight);
> +	trace_wbt_timer(queue_to_disk(rwb->rqos.q)->bdi, status,
> +			rqd->scale_step, inflight);
>  
>  	/*
>  	 * If we exceeded the latency target, step down. If we did not,

Or all these calls - is wbt guaranteed to only be setup for a queue with
disk?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
