From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: 3.6-rc5 cgroups blkio throttle + md regression
Date: Wed, 19 Sep 2012 15:42:31 -0400
Message-ID: <20120919194231.GF31860@redhat.com>
References: <CAOzFzEhf2LfT0BCNPAgPgxZ3=pj2KvJ4Z6kP7XF8nnxag1dfvg@mail.gmail.com>
 <CAOzFzEiC4313K4H9393ffzNyBo398BPYSxTk7ZEmuH4GfW5qtw@mail.gmail.com>
 <CAOzFzEhWk_7oQFOyW6Ri_9Cvsshj2s3pa=Oo-p8uL6r340MoTw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOzFzEhWk_7oQFOyW6Ri_9Cvsshj2s3pa=Oo-p8uL6r340MoTw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Thu, Sep 20, 2012 at 04:20:42AM +1000, Joseph Glanville wrote:
> Hi,
> 
> I booted the machine under bare metal to continue bisecting.
> Thankfully this allowed me to locate the commit that causes the
> problem.
> 

I tested it and I am also noticing the hang. I can see this hang on
dm devices also.

I suspect this issue is related to bio based drivers. We exit the
bypass mode in blk_init_allocated_queue() and that will be called
only for request based drivers. So for bio based drivers may be 
we never exit the bypass mode and this issue is somehow side
affect of that.

Thanks
Vivek

> git bisect reports this as the offending commit:
> commit b82d4b197c782ced82a8b7b76664125d2d3c156c
> Author: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date:   Fri Apr 13 13:11:31 2012 -0700
> 
>     blkcg: make request_queue bypassing on allocation
> 
>     With the previous change to guarantee bypass visiblity for RCU read
>     lock regions, entering bypass mode involves non-trivial overhead and
>     future changes are scheduled to make use of bypass mode during init
>     path.  Combined it may end up adding noticeable delay during boot.
> 
>     This patch makes request_queue start its life in bypass mode, which is
>     ended on queue init completion at the end of
>     blk_init_allocated_queue(), and updates blk_queue_bypass_start() such
>     that draining and RCU synchronization are performed only when the
>     queue actually enters bypass mode.
> 
>     This avoids unnecessarily switching in and out of bypass mode during
>     init avoiding the overhead and any nasty surprises which may step from
>     leaving bypass mode on half-initialized queues.
> 
>     The boot time overhead was pointed out by Vivek.
> 
>     Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>     Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     Signed-off-by: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index f2db628..3b02ba3 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -421,14 +421,18 @@ void blk_drain_queue(struct request_queue *q,
> bool drain_all)
>   */
>  void blk_queue_bypass_start(struct request_queue *q)
>  {
> +	bool drain;
> +
>  	spin_lock_irq(q->queue_lock);
> -	q->bypass_depth++;
> +	drain = !q->bypass_depth++;
>  	queue_flag_set(QUEUE_FLAG_BYPASS, q);
>  	spin_unlock_irq(q->queue_lock);
> 
> -	blk_drain_queue(q, false);
> -	/* ensure blk_queue_bypass() is %true inside RCU read lock */
> -	synchronize_rcu();
> +	if (drain) {
> +		blk_drain_queue(q, false);
> +		/* ensure blk_queue_bypass() is %true inside RCU read lock */
> +		synchronize_rcu();
> +	}
>  }
>  EXPORT_SYMBOL_GPL(blk_queue_bypass_start);
> 
> @@ -577,6 +581,15 @@ struct request_queue *blk_alloc_queue_node(gfp_t
> gfp_mask, int node_id)
>  	 */
>  	q->queue_lock = &q->__queue_lock;
> 
> +	/*
> +	 * A queue starts its life with bypass turned on to avoid
> +	 * unnecessary bypass on/off overhead and nasty surprises during
> +	 * init.  The initial bypass will be finished at the end of
> +	 * blk_init_allocated_queue().
> +	 */
> +	q->bypass_depth = 1;
> +	__set_bit(QUEUE_FLAG_BYPASS, &q->queue_flags);
> +
>  	if (blkcg_init_queue(q))
>  		goto fail_id;
> 
> @@ -672,15 +685,15 @@ blk_init_allocated_queue(struct request_queue
> *q, request_fn_proc *rfn,
> 
>  	q->sg_reserved_size = INT_MAX;
> 
> -	/*
> -	 * all done
> -	 */
> -	if (!elevator_init(q, NULL)) {
> -		blk_queue_congestion_threshold(q);
> -		return q;
> -	}
> +	/* init elevator */
> +	if (elevator_init(q, NULL))
> +		return NULL;
> 
> -	return NULL;
> +	blk_queue_congestion_threshold(q);
> +
> +	/* all done, end the initial bypass */
> +	blk_queue_bypass_end(q);
> +	return q;
>  }
>  EXPORT_SYMBOL(blk_init_allocated_queue);
> 
> 
> Reverting this commit fixes the regression. :)
> 
> Joseph.
> 
> -- 
> CTO | Orion Virtualisation Solutions | www.orionvm.com.au
> Phone: 1300 56 99 52 | Mobile: 0428 754 846
