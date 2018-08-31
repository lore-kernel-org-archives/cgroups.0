From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 07/15] blkcg: consolidate bio_issue_init and blkg
 association
Date: Fri, 31 Aug 2018 11:42:26 -0400
Message-ID: <20180831154225.zoiztxvdvcfaat5r@destiny>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-8-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VZqW7BY8aLS7wLcgy5GIo18cFUx2N5hu+eq68a2A2NQ=;
        b=aR8Nq8odWgtBpMpAG/f2/8e/GFgFDSoIHsxvPezWFPplMfNS0BFsP3GwRLY378ry9Z
         oC6FPEtO9HMpjvkbegNyru1wj0IEborWGbyTmrGavhj9L3B6hrjEz3adFJHuPMqgsV/P
         dYnssti1rHI4NBq94Jlbp96sQv31TbKMlXKhItYbSd+3ZW9U8rqI6Jl0io2pEa159aid
         LCer2MT/F3+bPbZ+qNQ3XeKn4QfG4B3fqMYVAieyDgi50dshksEsGJMBpuOndInE0UkN
         cIwl+RqgM0MupZgY/PeY0Rb4LxNW/Q2wUGq8IrgqtYOJbjXKYmoDnkEV5AwRSwg9bT0+
         iXrQ==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-8-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 30, 2018 at 09:53:48PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> This removes the now duplicate association logic in blk-throttle and
> blk-iolatency. bio_issue_init is moved into blkcg_bio_issue_check and
> into the bio clone variants to allow for the future addition of a
> latency moving average for IOs.
> 
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>
> ---
>  block/bio.c                |  2 ++
>  block/blk-iolatency.c      | 24 +-----------------------
>  block/blk-throttle.c       | 13 +------------
>  block/bounce.c             |  2 ++
>  include/linux/blk-cgroup.h |  2 ++
>  5 files changed, 8 insertions(+), 35 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index e937f9681188..ab41f5b7eb1f 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -610,6 +610,8 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
>  	bio->bi_io_vec = bio_src->bi_io_vec;
>  
>  	bio_clone_blkcg_association(bio, bio_src);
> +
> +	bio_issue_init(&bio->bi_issue, bio_sectors(bio));
>  }
>  EXPORT_SYMBOL(__bio_clone_fast);
>  
> diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
> index 22b2ff0440cc..9d7052bad6f7 100644
> --- a/block/blk-iolatency.c
> +++ b/block/blk-iolatency.c
> @@ -395,34 +395,12 @@ static void blkcg_iolatency_throttle(struct rq_qos *rqos, struct bio *bio,
>  				     spinlock_t *lock)
>  {
>  	struct blk_iolatency *blkiolat = BLKIOLATENCY(rqos);
> -	struct blkcg *blkcg;
> -	struct blkcg_gq *blkg;
> -	struct request_queue *q = rqos->q;
> +	struct blkcg_gq *blkg = bio->bi_blkg;
>  	bool issue_as_root = bio_issue_as_root_blkg(bio);
>  
>  	if (!blk_iolatency_enabled(blkiolat))
>  		return;
>  
> -	rcu_read_lock();
> -	bio_associate_blkcg(bio, NULL);
> -	blkcg = bio_blkcg(bio);
> -	blkg = blkg_lookup(blkcg, q);
> -	if (unlikely(!blkg)) {
> -		if (!lock)
> -			spin_lock_irq(q->queue_lock);
> -		blkg = __blkg_lookup_create(blkcg, q);
> -		if (IS_ERR(blkg))
> -			blkg = NULL;
> -		if (!lock)
> -			spin_unlock_irq(q->queue_lock);
> -	}
> -	if (!blkg)
> -		goto out;
> -
> -	bio_issue_init(&bio->bi_issue, bio_sectors(bio));
> -	bio_associate_blkg(bio, blkg);
> -out:
> -	rcu_read_unlock();

Move this removal to the previous patch, so you keep this patch soley about the
bio_issue_init.  Thanks,

Josef
