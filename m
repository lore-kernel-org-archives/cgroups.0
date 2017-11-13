From: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/7] blk-throtl: don't throttle the same IO multiple times
Date: Sun, 12 Nov 2017 20:07:16 -0800
Message-ID: <20171113040716.kaheegc4qub42n6z@kernel.org>
References: <20171112222613.3613362-1-tj@kernel.org>
 <20171112222613.3613362-8-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171112222613.3613362-8-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On Sun, Nov 12, 2017 at 02:26:13PM -0800, Tejun Heo wrote:
> BIO_THROTTLED is used to mark already throttled bios so that a bio
> doesn't get throttled multiple times.  The flag gets set when the bio
> starts getting dispatched from blk-throtl and cleared when it leaves
> blk-throtl.
> 
> Unfortunately, this doesn't work when the request_queue decides to
> split or requeue the bio and ends up throttling the same IO multiple
> times.  This condition gets easily triggered and often leads to
> multiple times lower bandwidth limit being enforced than configured.
> 
> Fix it by always setting BIO_THROTTLED for bios recursing to the same
> request_queue and clearing only when a bio leaves the current level.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  block/blk-core.c           | 10 +++++++---
>  block/blk-throttle.c       |  8 --------
>  include/linux/blk-cgroup.h | 20 ++++++++++++++++++++
>  3 files changed, 27 insertions(+), 11 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index ad23b96..f0e3157 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2216,11 +2216,15 @@ blk_qc_t generic_make_request(struct bio *bio)
>  			 */
>  			bio_list_init(&lower);
>  			bio_list_init(&same);
> -			while ((bio = bio_list_pop(&bio_list_on_stack[0])) != NULL)
> -				if (q == bio->bi_disk->queue)
> +			while ((bio = bio_list_pop(&bio_list_on_stack[0])) != NULL) {
> +				if (q == bio->bi_disk->queue) {
> +					blkcg_bio_repeat_q_level(bio);
>  					bio_list_add(&same, bio);
> -				else
> +				} else {
> +					blkcg_bio_leave_q_level(bio);
>  					bio_list_add(&lower, bio);
> +				}
> +			}

Hi Tejun,

Thanks for looking into this while I was absence. I don't understand how this
works. Assume a bio will be splitted into 2 small bios. In
generic_make_request, we charge the whole bio. 'q->make_request_fn' will
dispatch the first small bio, and call generic_make_request for the second
small bio. Then generic_make_request charge the second small bio and we add the
second small bio to current->bio_list[0] (please check the order). In above
code the patch changed, we pop the second small bio and set BIO_THROTTLED for
it. But this is already too late, because generic_make_request already charged
the second small bio.

Did you look at my original patch
(https://marc.info/?l=linux-block&m=150791825327628&w=2), anything wrong?

Thanks,
Shaohua

>  			/* now assemble so we handle the lowest level first */
>  			bio_list_merge(&bio_list_on_stack[0], &lower);
>  			bio_list_merge(&bio_list_on_stack[0], &same);
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 1e6916b..76579b2 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -2223,14 +2223,6 @@ bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg,
>  out_unlock:
>  	spin_unlock_irq(q->queue_lock);
>  out:
> -	/*
> -	 * As multiple blk-throtls may stack in the same issue path, we
> -	 * don't want bios to leave with the flag set.  Clear the flag if
> -	 * being issued.
> -	 */
> -	if (!throttled)
> -		bio_clear_flag(bio, BIO_THROTTLED);
> -
>  #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
>  	if (throttled || !td->track_bio_latency)
>  		bio->bi_issue_stat.stat |= SKIP_LATENCY;
> diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
> index f2f9691..bed0416 100644
> --- a/include/linux/blk-cgroup.h
> +++ b/include/linux/blk-cgroup.h
> @@ -675,9 +675,29 @@ static inline void blkg_rwstat_add_aux(struct blkg_rwstat *to,
>  #ifdef CONFIG_BLK_DEV_THROTTLING
>  extern bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg,
>  			   struct bio *bio);
> +
> +static inline void blkcg_bio_repeat_q_level(struct bio *bio)
> +{
> +	/*
> +	 * @bio is queued while processing a previous bio which was already
> +	 * throttled.  Don't throttle it again.
> +	 */
> +	bio_set_flag(bio, BIO_THROTTLED);
> +}
> +
> +static inline void blkcg_bio_leave_q_level(struct bio *bio)
> +{
> +	/*
> +	 * @bio may get throttled at multiple q levels, clear THROTTLED
> +	 * when leaving the current one.
> +	 */
> +	bio_clear_flag(bio, BIO_THROTTLED);
> +}
>  #else
>  static inline bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg,
>  				  struct bio *bio) { return false; }
> +static inline void blkcg_bio_repeat_q_level(struct bio *bio) { }
> +static inline void biocg_bio_leave_q_level(struct bio *bio) { }
>  #endif
>  
>  static inline struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
> -- 
> 2.9.5
> 
