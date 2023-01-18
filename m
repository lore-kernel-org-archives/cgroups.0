From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next v2 3/3] blk-cgroup: synchronize pd_free_fn() from
 blkg_free_workfn() and blkcg_deactivate_policy()
Date: Wed, 18 Jan 2023 07:05:20 -1000
Message-ID: <Y8gm0BVh5d83lVXN@slm.duckdns.org>
References: <20230118123152.1926314-1-yukuai1@huaweicloud.com>
 <20230118123152.1926314-4-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NxdDRugRMl6w2Hk+hXG/ZT8UvsTDOnHjgkdiS6Eozqs=;
        b=mcQGELIQeyEZdbxZ9QQ3xRdRMXlxomQd5A4kxDz83vli8N9Oz8WhYw33KOwkt7MsYl
         8BXVjSzh1nc1MBHLhCkZ0OYk3iwTIZB0TLynjsIdbHz2vk3rT+BX6/BSfhXtePgitmbW
         3x6Xg/dj8QvZtO+N/MjX6tUcHhPYlIcB6D8o/RPFakPQPHMz26aFb/+iAxcyJc5TdbU1
         5eGWtIsBjxvkyTXtbYTy866KlKxe6aIzJ2zZLyUkUQgN5XCwZmVthS5E8nV0Lb9YfqYz
         CGFQE0giXRJ5RAa7jVSulNnZUEV0qGBOBVo7F1NVyv+sEOoJ2l6OrU6EkI/kIQkYbD/n
         nlXw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230118123152.1926314-4-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-jcswGhMUV9g@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hello,

On Wed, Jan 18, 2023 at 08:31:52PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Currently parent pd can be freed before child pd:
> 
> t1: remove cgroup C1
> blkcg_destroy_blkgs
>  blkg_destroy
>   list_del_init(&blkg->q_node)
>   // remove blkg from queue list
>   percpu_ref_kill(&blkg->refcnt)
>    blkg_release
>     call_rcu
> 
> t2: from t1
> __blkg_release
>  blkg_free
>   schedule_work
> 			t4: deactivate policy
> 			blkcg_deactivate_policy
> 			 pd_free_fn
> 			 // parent of C1 is freed first
> t3: from t2
>  blkg_free_workfn
>   pd_free_fn
> 
> If policy(for example, ioc_timer_fn() from iocost) access parent pd from
> child pd after pd_offline_fn(), then UAF can be triggered.
> 
> Fix the problem by delaying 'list_del_init(&blkg->q_node)' from
> blkg_destroy() to blkg_free_workfn(), and use a new disk level mutex to
                                            ^
                                            using

> protect blkg_free_workfn() and blkcg_deactivate_policy).
  ^                                                     ^
  synchronize?                                          ()

> @@ -118,16 +118,26 @@ static void blkg_free_workfn(struct work_struct *work)
>  {
>  	struct blkcg_gq *blkg = container_of(work, struct blkcg_gq,
>  					     free_work);
> +	struct request_queue *q = blkg->q;
>  	int i;
>  
> +	if (q)
> +		mutex_lock(&q->blkcg_mutex);

A comment explaining what the above is synchronizing would be useful.

> +
>  	for (i = 0; i < BLKCG_MAX_POLS; i++)
>  		if (blkg->pd[i])
>  			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
>  
>  	if (blkg->parent)
>  		blkg_put(blkg->parent);
> -	if (blkg->q)
> -		blk_put_queue(blkg->q);
> +
> +	if (q) {
> +		if (!list_empty(&blkg->q_node))

We can drop the above if.

> +			list_del_init(&blkg->q_node);
> +		mutex_unlock(&q->blkcg_mutex);
> +		blk_put_queue(q);
> +	}
> +
>  	free_percpu(blkg->iostat_cpu);
>  	percpu_ref_exit(&blkg->refcnt);
>  	kfree(blkg);
> @@ -462,9 +472,14 @@ static void blkg_destroy(struct blkcg_gq *blkg)
>  	lockdep_assert_held(&blkg->q->queue_lock);
>  	lockdep_assert_held(&blkcg->lock);
>  
> -	/* Something wrong if we are trying to remove same group twice */
> -	WARN_ON_ONCE(list_empty(&blkg->q_node));
> -	WARN_ON_ONCE(hlist_unhashed(&blkg->blkcg_node));
> +	/*
> +	 * blkg is removed from queue list in blkg_free_workfn(), hence this
> +	 * function can be called from blkcg_destroy_blkgs() first, and then
> +	 * before blkg_free_workfn(), this function can be called again in
> +	 * blkg_destroy_all().

How about?

	 * blkg stays on the queue list until blkg_free_workfn(), hence this
	 * function can be called from blkcg_destroy_blkgs() first and again
	 * from blkg_destroy_all() before blkg_free_workfn().

> +	 */
> +	if (hlist_unhashed(&blkg->blkcg_node))
> +		return;
>  
>  	for (i = 0; i < BLKCG_MAX_POLS; i++) {
>  		struct blkcg_policy *pol = blkcg_policy[i];
> @@ -478,8 +493,11 @@ static void blkg_destroy(struct blkcg_gq *blkg)
>  
>  	blkg->online = false;
>  
> +	/*
> +	 * Delay deleting list blkg->q_node to blkg_free_workfn() to synchronize
> +	 * pd_free_fn() from blkg_free_workfn() and blkcg_deactivate_policy().
> +	 */

So, it'd be better to add a more comprehensive comment in blkg_free_workfn()
explaining why we need this synchronization and how it works and then point
to it from here.

Other than comments, it looks great to me. Thanks a lot for your patience
and seeing it through.

-- 
tejun
