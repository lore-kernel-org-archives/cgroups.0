From: Andreas Herrmann <aherrmann@suse.de>
Subject: Re: [PATCH 10/15] blk-rq-qos: constify rq_qos_ops
Date: Fri, 20 Jan 2023 11:01:37 +0100
Message-ID: <Y8pmgdjIEHYeukV6@suselix>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-11-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674208899; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rOggy0j58InUB8SiXSRc2Eo+dgWqbqflLrWfKx5LZJY=;
        b=z7EXQqcR1C05HASuYqotDx9UQ7BVradQ/+fcg2HBDhuMcsOUc8lk9x9qsP7oiJJSnPPQG3
        yAzZI+BNWVxpb0apueuto2YZjb30rEo2PAdn2b8x79kG/pmcnoe14+1p2TWq26lqWrinLW
        x1iJ3Qk1bH6KFkORJFXiAahK80ma+Mc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674208899;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rOggy0j58InUB8SiXSRc2Eo+dgWqbqflLrWfKx5LZJY=;
        b=BZzjkRuk46QPaVCDrumpziKLw0oXQvyRpsma1GO9qj0WL2xGUjx9uCSaZkPdkSHasauk4S
        vodgGxUqaBvH7yBg==
Content-Disposition: inline
In-Reply-To: <20230117081257.3089859-11-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org

On Tue, Jan 17, 2023 at 09:12:52AM +0100, Christoph Hellwig wrote:
> These op vectors are constant, so mark them const.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-iocost.c    | 2 +-
>  block/blk-iolatency.c | 2 +-
>  block/blk-rq-qos.c    | 2 +-
>  block/blk-rq-qos.h    | 4 ++--
>  block/blk-wbt.c       | 2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)

Looks good to me. Feel free to add
Reviewed-by: Andreas Herrmann <aherrmann@suse.de>

> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index 9b5c0d23c9ce8b..73f09e3556d7e4 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -2825,7 +2825,7 @@ static void ioc_rqos_exit(struct rq_qos *rqos)
>  	kfree(ioc);
>  }
>  
> -static struct rq_qos_ops ioc_rqos_ops = {
> +static const struct rq_qos_ops ioc_rqos_ops = {
>  	.throttle = ioc_rqos_throttle,
>  	.merge = ioc_rqos_merge,
>  	.done_bio = ioc_rqos_done_bio,
> diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
> index 1c394bd77aa0b4..f6aeb3d3fdae59 100644
> --- a/block/blk-iolatency.c
> +++ b/block/blk-iolatency.c
> @@ -650,7 +650,7 @@ static void blkcg_iolatency_exit(struct rq_qos *rqos)
>  	kfree(blkiolat);
>  }
>  
> -static struct rq_qos_ops blkcg_iolatency_ops = {
> +static const struct rq_qos_ops blkcg_iolatency_ops = {
>  	.throttle = blkcg_iolatency_throttle,
>  	.done_bio = blkcg_iolatency_done_bio,
>  	.exit = blkcg_iolatency_exit,
> diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
> index 14bee1bd761362..8e83734cfe8dbc 100644
> --- a/block/blk-rq-qos.c
> +++ b/block/blk-rq-qos.c
> @@ -296,7 +296,7 @@ void rq_qos_exit(struct request_queue *q)
>  }
>  
>  int rq_qos_add(struct rq_qos *rqos, struct gendisk *disk, enum rq_qos_id id,
> -		struct rq_qos_ops *ops)
> +		const struct rq_qos_ops *ops)
>  {
>  	struct request_queue *q = disk->queue;
>  
> diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
> index 22552785aa31ed..2b7b668479f71a 100644
> --- a/block/blk-rq-qos.h
> +++ b/block/blk-rq-qos.h
> @@ -25,7 +25,7 @@ struct rq_wait {
>  };
>  
>  struct rq_qos {
> -	struct rq_qos_ops *ops;
> +	const struct rq_qos_ops *ops;
>  	struct request_queue *q;
>  	enum rq_qos_id id;
>  	struct rq_qos *next;
> @@ -86,7 +86,7 @@ static inline void rq_wait_init(struct rq_wait *rq_wait)
>  }
>  
>  int rq_qos_add(struct rq_qos *rqos, struct gendisk *disk, enum rq_qos_id id,
> -		struct rq_qos_ops *ops);
> +		const struct rq_qos_ops *ops);
>  void rq_qos_del(struct rq_qos *rqos);
>  
>  typedef bool (acquire_inflight_cb_t)(struct rq_wait *rqw, void *private_data);
> diff --git a/block/blk-wbt.c b/block/blk-wbt.c
> index 97149a4f10e600..1c4469f9962de8 100644
> --- a/block/blk-wbt.c
> +++ b/block/blk-wbt.c
> @@ -821,7 +821,7 @@ static const struct blk_mq_debugfs_attr wbt_debugfs_attrs[] = {
>  };
>  #endif
>  
> -static struct rq_qos_ops wbt_rqos_ops = {
> +static const struct rq_qos_ops wbt_rqos_ops = {
>  	.throttle = wbt_wait,
>  	.issue = wbt_issue,
>  	.track = wbt_track,
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
