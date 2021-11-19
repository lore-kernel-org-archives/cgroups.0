From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: fix missing put device in error path from
 blkg_conf_pref()
Date: Fri, 19 Nov 2021 16:09:30 +0800
Message-ID: <26541322-e064-d39f-ed39-b463a3cea092@huawei.com>
References: <20211102020705.2321858-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20211102020705.2321858-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 2021/11/02 10:07, Yu Kuai wrote:
Hi, Jens

friendly ping ...

Thanks,
Kuai
> If blk_queue_enter() failed due to queue is dying, the
> blkdev_put_no_open() is needed because blkcg_conf_open_bdev() succeeded.
> 
> Fixes: 0c9d338c8443 ("blk-cgroup: synchronize blkg creation against policy deactivation")
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>   block/blk-cgroup.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 88b1fce90520..663aabfeba18 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -640,7 +640,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
>   	 */
>   	ret = blk_queue_enter(q, 0);
>   	if (ret)
> -		return ret;
> +		goto fail;
>   
>   	rcu_read_lock();
>   	spin_lock_irq(&q->queue_lock);
> @@ -676,13 +676,13 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
>   		new_blkg = blkg_alloc(pos, q, GFP_KERNEL);
>   		if (unlikely(!new_blkg)) {
>   			ret = -ENOMEM;
> -			goto fail;
> +			goto fail_exit_queue;
>   		}
>   
>   		if (radix_tree_preload(GFP_KERNEL)) {
>   			blkg_free(new_blkg);
>   			ret = -ENOMEM;
> -			goto fail;
> +			goto fail_exit_queue;
>   		}
>   
>   		rcu_read_lock();
> @@ -722,9 +722,10 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
>   fail_unlock:
>   	spin_unlock_irq(&q->queue_lock);
>   	rcu_read_unlock();
> +fail_exit_queue:
> +	blk_queue_exit(q);
>   fail:
>   	blkdev_put_no_open(bdev);
> -	blk_queue_exit(q);
>   	/*
>   	 * If queue was bypassing, we should retry.  Do so after a
>   	 * short msleep().  It isn't strictly necessary but queue
> 
