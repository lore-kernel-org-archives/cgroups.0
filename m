From: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/7] blkcg: account requests instead of bios for request
 based request_queues
Date: Tue, 14 Nov 2017 15:23:55 -0800
Message-ID: <20171114232355.vjxlzfbqbqj5ihq4@kernel.org>
References: <20171112222613.3613362-1-tj@kernel.org>
 <20171112222613.3613362-7-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171112222613.3613362-7-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On Sun, Nov 12, 2017 at 02:26:12PM -0800, Tejun Heo wrote:
> blkcg accounting is currently bio based, which is silly for request
> based request_queues.  This is silly as the number of bios doesn't
> have much to do with the actual number of IOs issued to the underlying
> device (can be significantly higher or lower) and may change depending
> on the implementation details on how the bios are issued (e.g. from
> the recent split-bios-while-issuing change).
> 
> request based request_queues have QUEUE_FLAG_IO_STAT set by default
> which controls the gendisk accounting.  Do cgroup accounting for those
> request_queues together with gendisk accounting on request completion.
> 
> This makes cgroup accounting consistent with gendisk accounting and
> what's happening on the system.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  block/blk-core.c           |  3 +++
>  include/linux/blk-cgroup.h | 18 +++++++++++++++++-
>  2 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 048be4a..ad23b96 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2429,6 +2429,7 @@ void blk_account_io_completion(struct request *req, unsigned int bytes)
>  		cpu = part_stat_lock();
>  		part = req->part;
>  		part_stat_add(cpu, part, sectors[rw], bytes >> 9);
> +		blkcg_account_io_completion(req, bytes);
>  		part_stat_unlock();
>  	}
>  }
> @@ -2454,6 +2455,8 @@ void blk_account_io_done(struct request *req)
>  		part_round_stats(req->q, cpu, part);
>  		part_dec_in_flight(req->q, part, rw);
>  
> +		blkcg_account_io_done(req);
> +
>  		hd_struct_put(part);
>  		part_stat_unlock();
>  	}
> diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
> index 96eed0f..f2f9691 100644
> --- a/include/linux/blk-cgroup.h
> +++ b/include/linux/blk-cgroup.h
> @@ -715,7 +715,8 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
>  
>  	throtl = blk_throtl_bio(q, blkg, bio);
>  
> -	if (!throtl) {
> +	/* if @q does io stat, blkcg stats are updated together with them */
> +	if (!blk_queue_io_stat(q) && !throtl) {

Reviewed-by: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

One nitpick, can we use q->request_fn to determine request based queue? I think
that is more reliable and usual way for this.

Thanks,
Shaohua
>  		blkg_rwstat_add(&blkg->stat_bytes, bio->bi_opf,
>  				bio->bi_iter.bi_size);
>  		blkg_rwstat_add(&blkg->stat_ios, bio->bi_opf, 1);
> @@ -764,6 +765,17 @@ static inline void blk_rq_disassociate_blkg(struct request *rq)
>  	rq->blkg = NULL;
>  }
>  
> +static inline void blkcg_account_io_completion(struct request *rq,
> +					       unsigned int bytes)
> +{
> +	blkg_rwstat_add(&rq->blkg->stat_bytes, rq_data_dir(rq), bytes);
> +}
> +
> +static inline void blkcg_account_io_done(struct request *rq)
> +{
> +	blkg_rwstat_add(&rq->blkg->stat_ios, rq_data_dir(rq), 1);
> +}
> +
>  #else	/* CONFIG_BLK_CGROUP */
>  
>  struct blkcg {
> @@ -823,6 +835,10 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
>  static inline void blk_rq_associate_blkg(struct request *rq, struct blkcg *blkcg) { }
>  static inline void blk_rq_disassociate_blkg(struct request *rq) { }
>  
> +static inline void blkcg_account_io_completion(struct request *rq,
> +					       unsigned int bytes) { }
> +static inline void blkcg_account_io_done(struct request *rq) { }
> +
>  #define blk_queue_for_each_rl(rl, q)	\
>  	for ((rl) = &(q)->root_rl; (rl); (rl) = NULL)
>  
> -- 
> 2.9.5
> 
