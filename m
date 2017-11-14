From: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/7] blkcg: refactor blkcg_gq lookup and creation in
 blkcg_bio_issue_check()
Date: Tue, 14 Nov 2017 15:18:25 -0800
Message-ID: <20171114231825.3iq7sz4wbmphww5i@kernel.org>
References: <20171112222613.3613362-1-tj@kernel.org>
 <20171112222613.3613362-5-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171112222613.3613362-5-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On Sun, Nov 12, 2017 at 02:26:10PM -0800, Tejun Heo wrote:
> blkcg_bio_issue_check() open codes blkcg_gq lookup and creation using
> blkg_lookup() and blkg_lookup_create().  Refactor the code so that
> 
> * blkg_lookup_create() is renamed to blkcg_lookup_create_locked().
> 
> * blkg_lookup_create() is now a new function which encapsulates the
>   RCU protected lookup and queue_locked protected creation.
> 
> * blkg_lookup_create() is guaranteed to return a non-NULL blkcg_gq.
>   The NULL checks are removed from the users.
> 
> This is pure refactoring and doesn't introduce any functional changes.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Reviewed-by: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  block/blk-cgroup.c         |  6 +++---
>  block/blk-throttle.c       |  2 +-
>  include/linux/blk-cgroup.h | 32 +++++++++++++++++++++-----------
>  3 files changed, 25 insertions(+), 15 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 60a4486..490b0a6 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -290,7 +290,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
>  }
>  
>  /**
> - * blkg_lookup_create - lookup blkg, try to create one if not there
> + * blkg_lookup_create_locked - lookup blkg, try to create one if not there
>   * @blkcg: blkcg of interest
>   * @q: request_queue of interest
>   *
> @@ -303,8 +303,8 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
>   * value on error.  If @q is dead, returns ERR_PTR(-EINVAL).  If @q is not
>   * dead and bypassing, returns ERR_PTR(-EBUSY).
>   */
> -struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
> -				    struct request_queue *q)
> +struct blkcg_gq *blkg_lookup_create_locked(struct blkcg *blkcg,
> +					   struct request_queue *q)
>  {
>  	struct blkcg_gq *blkg;
>  
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 8631763..1e6916b 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -2123,7 +2123,7 @@ bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg,
>  		    struct bio *bio)
>  {
>  	struct throtl_qnode *qn = NULL;
> -	struct throtl_grp *tg = blkg_to_tg(blkg ?: q->root_blkg);
> +	struct throtl_grp *tg = blkg_to_tg(blkg);
>  	struct throtl_service_queue *sq;
>  	bool rw = bio_data_dir(bio);
>  	bool throttled = false;
> diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
> index b5721d32..1de5158 100644
> --- a/include/linux/blk-cgroup.h
> +++ b/include/linux/blk-cgroup.h
> @@ -172,8 +172,8 @@ extern struct cgroup_subsys_state * const blkcg_root_css;
>  
>  struct blkcg_gq *blkg_lookup_slowpath(struct blkcg *blkcg,
>  				      struct request_queue *q, bool update_hint);
> -struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
> -				    struct request_queue *q);
> +struct blkcg_gq *blkg_lookup_create_locked(struct blkcg *blkcg,
> +					   struct request_queue *q);
>  int blkcg_init_queue(struct request_queue *q);
>  void blkcg_drain_queue(struct request_queue *q);
>  void blkcg_exit_queue(struct request_queue *q);
> @@ -680,6 +680,24 @@ static inline bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg
>  				  struct bio *bio) { return false; }
>  #endif
>  
> +static inline struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
> +						  struct request_queue *q)
> +{
> +	struct blkcg_gq *blkg;
> +
> +	blkg = blkg_lookup(blkcg, q);
> +	if (likely(blkg))
> +		return blkg;
> +
> +	spin_lock_irq(q->queue_lock);
> +	blkg = blkg_lookup_create_locked(blkcg, q);
> +	spin_unlock_irq(q->queue_lock);
> +	if (likely(!IS_ERR(blkg)))
> +		return blkg;
> +	else
> +		return q->root_blkg;
> +}
> +
>  static inline bool blkcg_bio_issue_check(struct request_queue *q,
>  					 struct bio *bio)
>  {
> @@ -693,19 +711,11 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
>  	/* associate blkcg if bio hasn't attached one */
>  	bio_associate_blkcg(bio, &blkcg->css);
>  
> -	blkg = blkg_lookup(blkcg, q);
> -	if (unlikely(!blkg)) {
> -		spin_lock_irq(q->queue_lock);
> -		blkg = blkg_lookup_create(blkcg, q);
> -		if (IS_ERR(blkg))
> -			blkg = NULL;
> -		spin_unlock_irq(q->queue_lock);
> -	}
> +	blkg = blkg_lookup_create(blkcg, q);
>  
>  	throtl = blk_throtl_bio(q, blkg, bio);
>  
>  	if (!throtl) {
> -		blkg = blkg ?: q->root_blkg;
>  		blkg_rwstat_add(&blkg->stat_bytes, bio->bi_opf,
>  				bio->bi_iter.bi_size);
>  		blkg_rwstat_add(&blkg->stat_ios, bio->bi_opf, 1);
> -- 
> 2.9.5
> 
