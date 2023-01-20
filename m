From: Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 14/15] blk-cgroup: pass a gendisk to blkg_lookup
Date: Fri, 20 Jan 2023 12:07:17 +0100
Message-ID: <Y8p15fQrizOumbaU@suselix>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-15-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674212839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SvZ0mFZBcYklFj+YczxypbOCFd0ux28n2ufdTKkBrws=;
        b=QiCbZV0t6/eNQRXJS9CYOEqbFmjsVNnr5ndrJ/aY3IqzC5O+VhKeukWo+b/4/1munUQ3zr
        n2Imhl1YQhA9Zc+i607zKTSSXcalZrdvDswfOtlf7kMcyVxoDWzI9CjTkHFtkbkPv4At3x
        NOjGgXIZEwBTzf4DZ2ZU5lq7eDBTx38=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674212839;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SvZ0mFZBcYklFj+YczxypbOCFd0ux28n2ufdTKkBrws=;
        b=Ino5oYfxpGTO0Bwmyg24QHfT7rTpmrOOt0FAsEqWZwkVa58cgZCP6aQEVOgJXnX0yYZwkN
        1smrugADSHN5oLCg==
Content-Disposition: inline
In-Reply-To: <20230117081257.3089859-15-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 17, 2023 at 09:12:56AM +0100, Christoph Hellwig wrote:
> Pass a gendisk to blkg_lookup and use that to find the match as part
> of phasing out usage of the request_queue in the blk-cgroup code.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  block/blk-cgroup.c | 16 ++++++++--------
>  block/blk-cgroup.h | 20 ++++++++++----------
>  2 files changed, 18 insertions(+), 18 deletions(-)

Looks good to me. Feel free to add
Reviewed-by: Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>

> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 601b156897dea4..a041b3ddab6e33 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -320,7 +320,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
>  
>  	/* link parent */
>  	if (blkcg_parent(blkcg)) {
> -		blkg->parent = blkg_lookup(blkcg_parent(blkcg), disk->queue);
> +		blkg->parent = blkg_lookup(blkcg_parent(blkcg), disk);
>  		if (WARN_ON_ONCE(!blkg->parent)) {
>  			ret = -ENODEV;
>  			goto err_put_css;
> @@ -389,12 +389,12 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
>  
>  	WARN_ON_ONCE(!rcu_read_lock_held());
>  
> -	blkg = blkg_lookup(blkcg, q);
> +	blkg = blkg_lookup(blkcg, disk);
>  	if (blkg)
>  		return blkg;
>  
>  	spin_lock_irqsave(&q->queue_lock, flags);
> -	blkg = blkg_lookup(blkcg, q);
> +	blkg = blkg_lookup(blkcg, disk);
>  	if (blkg) {
>  		if (blkcg != &blkcg_root &&
>  		    blkg != rcu_dereference(blkcg->blkg_hint))
> @@ -413,7 +413,7 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
>  		struct blkcg_gq *ret_blkg = q->root_blkg;
>  
>  		while (parent) {
> -			blkg = blkg_lookup(parent, q);
> +			blkg = blkg_lookup(parent, disk);
>  			if (blkg) {
>  				/* remember closest blkg */
>  				ret_blkg = blkg;
> @@ -692,7 +692,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
>  		goto fail_unlock;
>  	}
>  
> -	blkg = blkg_lookup(blkcg, q);
> +	blkg = blkg_lookup(blkcg, disk);
>  	if (blkg)
>  		goto success;
>  
> @@ -706,7 +706,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
>  		struct blkcg_gq *new_blkg;
>  
>  		parent = blkcg_parent(blkcg);
> -		while (parent && !blkg_lookup(parent, q)) {
> +		while (parent && !blkg_lookup(parent, disk)) {
>  			pos = parent;
>  			parent = blkcg_parent(parent);
>  		}
> @@ -736,7 +736,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
>  			goto fail_preloaded;
>  		}
>  
> -		blkg = blkg_lookup(pos, q);
> +		blkg = blkg_lookup(pos, disk);
>  		if (blkg) {
>  			blkg_free(new_blkg);
>  		} else {
> @@ -1804,7 +1804,7 @@ void blkcg_maybe_throttle_current(void)
>  	blkcg = css_to_blkcg(blkcg_css());
>  	if (!blkcg)
>  		goto out;
> -	blkg = blkg_lookup(blkcg, disk->queue);
> +	blkg = blkg_lookup(blkcg, disk);
>  	if (!blkg)
>  		goto out;
>  	if (!blkg_tryget(blkg))
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index 9a2cd3c71a94a2..3e7508907f33d8 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -230,30 +230,30 @@ static inline bool bio_issue_as_root_blkg(struct bio *bio)
>  }
>  
>  /**
> - * blkg_lookup - lookup blkg for the specified blkcg - q pair
> + * blkg_lookup - lookup blkg for the specified blkcg - disk pair
>   * @blkcg: blkcg of interest
> - * @q: request_queue of interest
> + * @disk: gendisk of interest
>   *
> - * Lookup blkg for the @blkcg - @q pair.
> + * Lookup blkg for the @blkcg - @disk pair.
>  
>   * Must be called in a RCU critical section.
>   */
>  static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg,
> -					   struct request_queue *q)
> +					   struct gendisk *disk)
>  {
>  	struct blkcg_gq *blkg;
>  
>  	WARN_ON_ONCE(!rcu_read_lock_held());
>  
>  	if (blkcg == &blkcg_root)
> -		return q->root_blkg;
> +		return disk->queue->root_blkg;
>  
>  	blkg = rcu_dereference(blkcg->blkg_hint);
> -	if (blkg && blkg->disk->queue == q)
> +	if (blkg && blkg->disk == disk)
>  		return blkg;
>  
> -	blkg = radix_tree_lookup(&blkcg->blkg_tree, q->id);
> -	if (blkg && blkg->disk->queue != q)
> +	blkg = radix_tree_lookup(&blkcg->blkg_tree, disk->queue->id);
> +	if (blkg && blkg->disk != disk)
>  		blkg = NULL;
>  	return blkg;
>  }
> @@ -353,7 +353,7 @@ static inline void blkg_put(struct blkcg_gq *blkg)
>  #define blkg_for_each_descendant_pre(d_blkg, pos_css, p_blkg)		\
>  	css_for_each_descendant_pre((pos_css), &(p_blkg)->blkcg->css)	\
>  		if (((d_blkg) = blkg_lookup(css_to_blkcg(pos_css),	\
> -					    (p_blkg)->disk->queue)))
> +					    (p_blkg)->disk)))
>  
>  /**
>   * blkg_for_each_descendant_post - post-order walk of a blkg's descendants
> @@ -368,7 +368,7 @@ static inline void blkg_put(struct blkcg_gq *blkg)
>  #define blkg_for_each_descendant_post(d_blkg, pos_css, p_blkg)		\
>  	css_for_each_descendant_post((pos_css), &(p_blkg)->blkcg->css)	\
>  		if (((d_blkg) = blkg_lookup(css_to_blkcg(pos_css),	\
> -					    (p_blkg)->disk->queue)))
> +					    (p_blkg)->disk)))
>  
>  bool __blkcg_punt_bio_submit(struct bio *bio);
>  
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
