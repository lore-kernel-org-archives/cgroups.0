From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 03/15] blkcg: use tryget logic when associating a blkg
 with a bio
Date: Fri, 31 Aug 2018 11:30:08 -0400
Message-ID: <20180831153007.nybnuyx43adn76rm@destiny>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-4-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=r4xlJrCOyIDs6oSO9a8eot+HhJ0UKStNZvu7TqaUHHI=;
        b=eUtCchfLR28qwPaFKR1o0VGLHzliYbHEoXgYVmNPog1b8I6I5HpHcSkIiC1JmRF7NN
         /paBfy4M1KgUCcznVTxR7/0yA2vw0H+sp3z9ql4ZvtkejTzpf6CTIrS0sdUHAKZ5+UcO
         l2R++nsfrw672Ef2svHQ4IoLEaGxTzO7VLGdCNsnxk0uU0+iyI11/JZ+o8c4mVpMOHg5
         iRUnG/hgXArTezrHSAZVk5zPPe35b88NxVHNTEgbHPGAQPQzF4cycysMjuvJDbdq0LKF
         sPLkLn0GFDHnYe2jdXeVtYwV4gHZm6xCgpK5/E/1yRbLBFYMgcqUtMyWc/Y8uygNX5+k
         5cQg==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-4-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Jiufei Xue <jiufei.xue@linux.alibaba.com>, Joseph Qi <joseph.qi@linux.alibaba.com>

On Thu, Aug 30, 2018 at 09:53:44PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> There is a very small change a bio gets caught up in a really
> unfortunate race between a task migration, cgroup exiting, and itself
> trying to associate with a blkg. This is due to css offlining being
> performed after the css->refcnt is killed which triggers removal of
> blkgs that reach their blkg->refcnt of 0.
> 
> To avoid this, association with a blkg should use tryget and fallback to
> using the root_blkg.
> 
> Fixes: 08e18eab0c579 ("block: add bi_blkg to the bio for cgroups")
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>
> Cc: Jiufei Xue <jiufei.xue@linux.alibaba.com>
> Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Josef Bacik <josef@toxicpanda.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
>  block/bio.c          | 3 ++-
>  block/blk-throttle.c | 5 +++--
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 04969b392c72..4473ccd22987 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1987,7 +1987,8 @@ int bio_associate_blkg(struct bio *bio, struct blkcg_gq *blkg)
>  {
>  	if (unlikely(bio->bi_blkg))
>  		return -EBUSY;
> -	blkg_get(blkg);
> +	if (!blkg_try_get(blkg))
> +		return -ENODEV;
>  	bio->bi_blkg = blkg;
>  	return 0;
>  }
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index a3eede00d302..c626e1f7cdcd 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -2129,8 +2129,9 @@ static inline void throtl_update_latency_buckets(struct throtl_data *td)
>  static void blk_throtl_assoc_bio(struct throtl_grp *tg, struct bio *bio)
>  {
>  #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
> -	if (bio->bi_css)
> -		bio_associate_blkg(bio, tg_to_blkg(tg));
> +	/* fallback to root_blkg if we fail to get a blkg ref */
> +	if (bio->bi_css && bio_associate_blkg(bio, tg_to_blkg(tg)))
> +		bio_associate_blkg(bio, bio->bi_disk->queue->root_blkg);

Except if we've already assocated a blkg this is just extra, can we do

if (bio->bi_css && (bio_associate_blkg(bio, tg_to_blkg(tg)) == -ENODEV))

to make it clear that we're only attaching it to the root if we failed to attach
a blkg at all?  Thanks,

Josef
