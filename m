From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 02/13] blkcg: update blkg_lookup_create() to do locking
Date: Tue, 27 Nov 2018 15:56:07 -0500
Message-ID: <20181127205606.762oz6kaoe2kfexv@macbook-pro-91.dhcp.thefacebook.com>
References: <20181126211946.77067-1-dennis@kernel.org>
 <20181126211946.77067-3-dennis@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=f8EayIIQWTFx0c37zWInHhP6HleJro5a8LupDFmxjB0=;
        b=pKeDYJBv2gbVoklzE6z8yMA0To5dT4sn5karSi/DmNZkxtnq/VlAL+HJM1Y4QcIgPM
         YzQtrxD9JPj2PPdNeKvZUdIUq3goWlacexWDbhzpbf0gSxUGGx5ciW2h4jdUe4ecGAhR
         Eb9FBYjvV8hBiS4Q8UiiWq36Q9qXbOm0S5b5isV3OUIxvsWeW2ov52gM0+w3jQ9iIz8Q
         RAiXt4Nurnhn0fwHs3M8Mc9ZOCe+7xzWV1fVjYDs3fdg/OqUph3Wdys8NFy1rdm0J0uo
         syo+wmDtlJzukrs7iAGUjyHpUwunL/F0+BueBXMgz0SC1VmIxBbVE8wdu5ao+07hPj0e
         Vh0w==
Content-Disposition: inline
In-Reply-To: <20181126211946.77067-3-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 26, 2018 at 04:19:35PM -0500, Dennis Zhou wrote:
> To know when to create a blkg, the general pattern is to do a
> blkg_lookup() and if that fails, lock and do the lookup again, and if
> that fails finally create. It doesn't make much sense for everyone who
> wants to do creation to write this themselves.
> 
> This changes blkg_lookup_create() to do locking and implement this
> pattern. The old blkg_lookup_create() is renamed to
> __blkg_lookup_create().  If a call site wants to do its own error
> handling or already owns the queue lock, they can use
> __blkg_lookup_create(). This will be used in upcoming patches.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
>  block/blk-cgroup.c         | 30 +++++++++++++++++++++++++++---
>  block/blk-iolatency.c      |  2 +-
>  include/linux/blk-cgroup.h |  4 +++-
>  3 files changed, 31 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 63d226a084cd..b1ec98eeeae0 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -249,7 +249,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
>  }
>  
>  /**
> - * blkg_lookup_create - lookup blkg, try to create one if not there
> + * __blkg_lookup_create - lookup blkg, try to create one if not there
>   * @blkcg: blkcg of interest
>   * @q: request_queue of interest
>   *
> @@ -262,8 +262,8 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
>   * value on error.  If @q is dead, returns ERR_PTR(-EINVAL).  If @q is not
>   * dead and bypassing, returns ERR_PTR(-EBUSY).
>   */
> -struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
> -				    struct request_queue *q)
> +struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
> +				      struct request_queue *q)
>  {
>  	struct blkcg_gq *blkg;
>  
> @@ -293,6 +293,30 @@ struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
>  	}
>  }
>  
> +/**
> + * blkg_lookup_create - find or create a blkg
> + * @blkcg: target block cgroup
> + * @q: target request_queue
> + *
> + * This looks up or creates the blkg representing the unique pair
> + * of the blkcg and the request_queue.
> + */
> +struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
> +				    struct request_queue *q)
> +{
> +	struct blkcg_gq *blkg = blkg_lookup(blkcg, q);
> +
> +	if (unlikely(!blkg)) {
> +		spin_lock_irq(&q->queue_lock);
> +
> +		blkg = __blkg_lookup_create(blkcg, q);
> +
> +		spin_unlock_irq(&q->queue_lock);

No extra spaces here please, otherwise you can add

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
