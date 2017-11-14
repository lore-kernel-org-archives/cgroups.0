From: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/7] blkcg: associate a request with its blkcg_gq
 instead of request_list
Date: Tue, 14 Nov 2017 15:17:43 -0800
Message-ID: <20171114231743.2eprnbfmgesqc42c@kernel.org>
References: <20171112222613.3613362-1-tj@kernel.org>
 <20171112222613.3613362-4-tj@kernel.org>
 <20171113201523.GM983427@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171113201523.GM983427-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On Mon, Nov 13, 2017 at 12:15:23PM -0800, Tejun Heo wrote:
> From c856a199ec70e4022e997609f1b17b9106408777 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Mon, 13 Nov 2017 12:11:57 -0800
> 
> On the legacy request_queue, each blkcg_gq has a dedicated
> request_list that requests for the cgroup are allocated from.  Each
> request points to the originating request_list and cgroup membership
> can be determined by examining which cgroup the associated
> request_list belongs to.
> 
> This doesn't work for blk-mq which doesn't use request_list.  Let's
> associate each request with the blkcg_gq directly.  Except for minor
> wrapper changes, this doesn't affect the legacy request_queue and will
> allow blk-mq to track each request's cgroup association.
> 
> v2: Build fix for !CONFIG_BLK_CGROUP.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  block/blk-mq.c             | 2 +-
>  include/linux/blk-cgroup.h | 7 +++++--
>  include/linux/blkdev.h     | 2 +-
>  3 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 98a1860..af958c4 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -306,7 +306,7 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
>  	rq->part = NULL;
>  	rq->start_time = jiffies;
>  #ifdef CONFIG_BLK_CGROUP
> -	rq->rl = NULL;
> +	rq->blkg = NULL;
>  	set_start_time_ns(rq);
>  	rq->io_start_time_ns = 0;
>  #endif
> diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
> index c0d4736..47db75a 100644
> --- a/include/linux/blk-cgroup.h
> +++ b/include/linux/blk-cgroup.h
> @@ -463,7 +463,7 @@ static inline void blk_put_rl(struct request_list *rl)
>   */
>  static inline void blk_rq_set_rl(struct request *rq, struct request_list *rl)
>  {
> -	rq->rl = rl;
> +	rq->blkg = rl->blkg;
>  }

After patch 5, we don't really need the blk_put_rl, blk_get_rl, blk_rq_set_rl
functions. I'd like to delete them and only keep blk_rq_rl. The name
blk_rq_set_rl is confusing too.

Thanks,
Shaohua
>  /**
> @@ -474,7 +474,10 @@ static inline void blk_rq_set_rl(struct request *rq, struct request_list *rl)
>   */
>  static inline struct request_list *blk_rq_rl(struct request *rq)
>  {
> -	return rq->rl;
> +	if (!rq->blkg->parent)
> +		return &rq->q->root_rl;
> +	else
> +		return &rq->blkg->rl;
>  }
>  
>  struct request_list *__blk_queue_next_rl(struct request_list *rl,
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 8da6637..6ec1067 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -206,7 +206,7 @@ struct request {
>  	unsigned long start_time;
>  	struct blk_issue_stat issue_stat;
>  #ifdef CONFIG_BLK_CGROUP
> -	struct request_list *rl;		/* rl this rq is alloced from */
> +	struct blkcg_gq *blkg;			/* blkg of this rq */
>  	unsigned long long start_time_ns;
>  	unsigned long long io_start_time_ns;    /* when passed to hardware */
>  #endif
> -- 
> 2.9.5
> 
