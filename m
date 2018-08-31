From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 04/15] blkcg: fix ref count issue with bio_blkcg using
 task_css
Date: Fri, 31 Aug 2018 11:35:39 -0400
Message-ID: <20180831153538.brzgcm3rgmwfy3rg@destiny>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-5-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZAYIrVBiYlNPqy2/vt2bGsfvNmg1V1NAFmw7W+/d1GI=;
        b=Gfc3jmI8FNSwt5eebsoLdCsVXcOazfB1aRSbuyS2ME7bnDbRS6zd5N3gl+Uh3TM9tb
         Dreo/YEuvCkxAn1RfZbsOHLYgMORsYeAy3QXntySEs1/UmbA18WWtoeonB/Ek2WXPnoE
         2QwnbZZQtSH/uSHCerw5npkRAbxVTRftrd+chk8bycCnkJYBX/yCUCFGmWlvLp4ut3ET
         MNtETOjX4hK8spMbyrp9LwTAGHk7WJ9dInRocsiI30ytQRW6Bt7/BF9rh2y0jX/D5pt+
         2dqntrW6Yz8DDNrYPgweM8aSOEQuTJ0vY1289xJxrHU1q6gVgaq9PVI34g8pL7NJ3V+J
         a27g==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-5-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 30, 2018 at 09:53:45PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> The accessor function bio_blkcg either returns the blkcg associated with
> the bio or finds one in the current context. This can cause an issue
> when trying to associate a bio with a blkcg. Particularly, it's the
> third case that is problematic:
> 
> 	return css_to_blkcg(task_css(current, io_cgrp_id));
> 
> As the above may race against task migration and the cgroup exiting, it
> is not always ok to take a reference on the blkcg returned from
> bio_blkcg.
> 
> This patch adds association ahead of calling bio_blkcg rather than
> after. This prevents makes association a required and explicit step
> along the code paths for calling bio_blkcg. blk_get_rl is modified
> as well to get a reference to the blkcg it may use and blk_put_rl
> will always put the reference back. Association is also moved above the
> bio_blkcg call to ensure it will not return NULL in blk-iolatency.
> 
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>
> ---
>  block/bio.c                | 10 +++++--
>  block/blk-iolatency.c      |  2 +-
>  include/linux/blk-cgroup.h | 53 ++++++++++++++++++++++++++++++++------
>  3 files changed, 54 insertions(+), 11 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 4473ccd22987..09a31e4d46bb 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1962,13 +1962,19 @@ int bio_associate_blkcg_from_page(struct bio *bio, struct page *page)
>   *
>   * This function takes an extra reference of @blkcg_css which will be put
>   * when @bio is released.  The caller must own @bio and is responsible for
> - * synchronizing calls to this function.
> + * synchronizing calls to this function.  If @blkcg_css is NULL, a call to
> + * blkcg_get_css finds the current css from the kthread or task.
>   */
>  int bio_associate_blkcg(struct bio *bio, struct cgroup_subsys_state *blkcg_css)
>  {
>  	if (unlikely(bio->bi_css))
>  		return -EBUSY;
> -	css_get(blkcg_css);
> +
> +	if (blkcg_css)
> +		css_get(blkcg_css);
> +	else
> +		blkcg_css = blkcg_get_css();
> +
>  	bio->bi_css = blkcg_css;
>  	return 0;
>  }
> diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
> index 19923f8a029d..62fdd9002c29 100644
> --- a/block/blk-iolatency.c
> +++ b/block/blk-iolatency.c
> @@ -404,8 +404,8 @@ static void blkcg_iolatency_throttle(struct rq_qos *rqos, struct bio *bio,
>  		return;
>  
>  	rcu_read_lock();
> +	bio_associate_blkcg(bio, NULL);
>  	blkcg = bio_blkcg(bio);
> -	bio_associate_blkcg(bio, &blkcg->css);
>  	blkg = blkg_lookup(blkcg, q);
>  	if (unlikely(!blkg)) {
>  		if (!lock)
> diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
> index c7386464ec4c..d3cafb1eda48 100644
> --- a/include/linux/blk-cgroup.h
> +++ b/include/linux/blk-cgroup.h
> @@ -230,22 +230,52 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
>  		   char *input, struct blkg_conf_ctx *ctx);
>  void blkg_conf_finish(struct blkg_conf_ctx *ctx);
>  
> +/**
> + * blkcg_get_css - find and get a reference to the css
> + *
> + * Find the css associated with either the kthread or the current task.
> + */
> +static inline struct cgroup_subsys_state *blkcg_get_css(void)
> +{
> +	struct cgroup_subsys_state *css;
> +
> +	rcu_read_lock();
> +
> +	css = kthread_blkcg();
> +	if (css) {
> +		css_get(css);
> +	} else {
> +		while (true) {
> +			css = task_css(current, io_cgrp_id);
> +			if (likely(css_tryget(css)))
> +				break;
> +			cpu_relax();

Does this work?  I'm ignorant of what cpu_relax() does, but it seems if we're
rcu_read_lock()'ed here we aren't going to queisce so if we fail to get the css
here we just simply aren't going to get it unless we go to sleep right?  An
honest question, because this is all magic to me, I'd like to understand how
this isn't going to infinite loop on us if css_tryget(css) fails.

> +		}
> +	}
> +
> +	rcu_read_unlock();
> +
> +	return css;
> +}
>  
>  static inline struct blkcg *css_to_blkcg(struct cgroup_subsys_state *css)
>  {
>  	return css ? container_of(css, struct blkcg, css) : NULL;
>  }
>  
> +/**
> + * bio_blkcg - grab the blkcg associated with a bio
> + * @bio: target bio
> + *
> + * This returns the blkcg associated with a bio, NULL if not associated.
> + * Callers are expected to either handle NULL or know association has been
> + * done prior to calling this.
> + */
>  static inline struct blkcg *bio_blkcg(struct bio *bio)
>  {
> -	struct cgroup_subsys_state *css;
> -
>  	if (bio && bio->bi_css)
>  		return css_to_blkcg(bio->bi_css);
> -	css = kthread_blkcg();
> -	if (css)
> -		return css_to_blkcg(css);
> -	return css_to_blkcg(task_css(current, io_cgrp_id));
> +	return NULL;
>  }
>  

So this is fine per se, but I know recently I was doing a bio_blkcg(NULL) to get
whatever the blkcg was for the current task.  I threw that work away so I'm not
worried about me, but have you made sure nobody else is doing something similar?

>  static inline bool blk_cgroup_congested(void)
> @@ -519,6 +549,11 @@ static inline struct request_list *blk_get_rl(struct request_queue *q,
>  	rcu_read_lock();
>  
>  	blkcg = bio_blkcg(bio);
> +	if (blkcg) {
> +		css_get(&blkcg->css);
> +	} else {
> +		blkcg = css_to_blkcg(blkcg_get_css());
> +	}

Kill these extra braces please.  Thanks,

Josef
