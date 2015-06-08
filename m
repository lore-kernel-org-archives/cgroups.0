From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 8/8] cfq-iosched: charge async IOs to the appropriate
 blkcg's instead of the root
Date: Mon, 8 Jun 2015 18:29:04 -0400
Message-ID: <20150608222904.GB20918@redhat.com>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
 <1433753973-23684-9-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433753973-23684-9-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon, Jun 08, 2015 at 05:59:33PM +0900, Tejun Heo wrote:
> Up until now, all async IOs were queued to async queues which are
> shared across the whole request_queue, which means that blkcg resource
> control is completely void on async IOs including all writeback IOs.
> It was done this way because writeback didn't support writeback and
> there was no way of telling which writeback IO belonged to which
> cgroup; however, writeback recently became cgroup aware and writeback
> bio's are sent down properly tagged with the blkcg's to charge them
> against.
> 
> This patch makes async cfq_queues per-cfq_cgroup instead of
> per-cfq_data so that each async IO is charged to the blkcg that it was
> tagged for instead of unconditionally attributing it to root.
> 
> * cfq_data->async_cfqq and ->async_idle_cfqq are moved to cfq_group
>   and alloc / destroy paths are updated accordingly.
> 
> * cfq_link_cfqq_cfqg() no longer overrides @cfqg to root for async
>   queues.
> 
> * check_blkcg_changed() now also invalidates async queues as they no
>   longer stay the same across cgroups.
> 
> After this patch, cfq's proportional IO control through blkio.weight
> works correctly when cgroup writeback is in use.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  block/cfq-iosched.c | 85 ++++++++++++++++++++++++++---------------------------
>  1 file changed, 42 insertions(+), 43 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 393befb..fded8d7 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -291,6 +291,11 @@ struct cfq_group {
>  	struct cfq_ttime ttime;
>  	struct cfqg_stats stats;	/* stats for this cfqg */
>  	struct cfqg_stats dead_stats;	/* stats pushed from dead children */
> +
> +	/* async queue for each priority case */
> +	struct cfq_queue *async_cfqq[2][IOPRIO_BE_NR];
> +	struct cfq_queue *async_idle_cfqq;
> +
>  };
>  
>  struct cfq_io_cq {
> @@ -356,12 +361,6 @@ struct cfq_data {
>  	struct cfq_queue *active_queue;
>  	struct cfq_io_cq *active_cic;
>  
> -	/*
> -	 * async queue for each priority case
> -	 */
> -	struct cfq_queue *async_cfqq[2][IOPRIO_BE_NR];
> -	struct cfq_queue *async_idle_cfqq;
> -
>  	sector_t last_position;
>  
>  	/*
> @@ -387,6 +386,7 @@ struct cfq_data {
>  };
>  
>  static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
> +static void cfq_put_queue(struct cfq_queue *cfqq);
>  
>  static struct cfq_rb_root *st_for(struct cfq_group *cfqg,
>  					    enum wl_class_t class,
> @@ -1556,13 +1556,26 @@ static void cfq_pd_init(struct blkcg_gq *blkg)
>  
>  static void cfq_pd_offline(struct blkcg_gq *blkg)
>  {
> +	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
> +	int i;
> +
> +	for (i = 0; i < IOPRIO_BE_NR; i++) {
> +		if (cfqg->async_cfqq[0][i])
> +			cfq_put_queue(cfqg->async_cfqq[0][i]);
> +		if (cfqg->async_cfqq[1][i])
> +			cfq_put_queue(cfqg->async_cfqq[1][i]);
> +	}
> +
> +	if (cfqg->async_idle_cfqq)
> +		cfq_put_queue(cfqg->async_idle_cfqq);
> +
>  	/*
>  	 * @blkg is going offline and will be ignored by
>  	 * blkg_[rw]stat_recursive_sum().  Transfer stats to the parent so
>  	 * that they don't get lost.  If IOs complete after this point, the
>  	 * stats for them will be lost.  Oh well...
>  	 */
> -	cfqg_stats_xfer_dead(blkg_to_cfqg(blkg));
> +	cfqg_stats_xfer_dead(cfqg);
>  }
>  
>  /* offset delta from cfqg->stats to cfqg->dead_stats */
> @@ -1625,10 +1638,6 @@ static struct cfq_group *cfq_lookup_create_cfqg(struct cfq_data *cfqd,
>  
>  static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
>  {
> -	/* Currently, all async queues are mapped to root group */
> -	if (!cfq_cfqq_sync(cfqq))
> -		cfqg = cfqq->cfqd->root_group;
> -
>  	cfqq->cfqg = cfqg;
>  	/* cfqq reference on cfqg */
>  	cfqg_get(cfqg);
> @@ -3541,7 +3550,7 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  static void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio)
>  {
>  	struct cfq_data *cfqd = cic_to_cfqd(cic);
> -	struct cfq_queue *sync_cfqq;
> +	struct cfq_queue *cfqq;
>  	uint64_t serial_nr;
>  
>  	rcu_read_lock();

> @@ -3555,15 +3564,22 @@ static void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio)
>  	if (unlikely(!cfqd) || likely(cic->blkcg_serial_nr == serial_nr))
>  		return;
>  
> -	sync_cfqq = cic_to_cfqq(cic, 1);
> -	if (sync_cfqq) {
> -		/*
> -		 * Drop reference to sync queue. A new sync queue will be
> -		 * assigned in new group upon arrival of a fresh request.
> -		 */
> -		cfq_log_cfqq(cfqd, sync_cfqq, "changed cgroup");
> -		cic_set_cfqq(cic, NULL, 1);
> -		cfq_put_queue(sync_cfqq);
> +	/*
> +	 * Drop reference to queues.  New queues will be assigned in new
> +	 * group upon arrival of fresh requests.
> +	 */
> +	cfqq = cic_to_cfqq(cic, false);
> +	if (cfqq) {
> +		cfq_log_cfqq(cfqd, cfqq, "changed cgroup");
> +		cic_set_cfqq(cic, NULL, false);
> +		cfq_put_queue(cfqq);
> +	}
> +
> +	cfqq = cic_to_cfqq(cic, true);
> +	if (cfqq) {
> +		cfq_log_cfqq(cfqd, cfqq, "changed cgroup");
> +		cic_set_cfqq(cic, NULL, true);
> +		cfq_put_queue(cfqq);
>  	}

Hi Tejun,

I am getting confused between cgroup and iocontext interaction, hence
some basic questions.

So a bio can carry either both iocontext and cgroup information. If
iocontext or cgroup information is present, it is used during rq
and cfqq allocation otherwise submitter's iocontext and cgroup is
used.

bio_associate_current() will associate an iocontext as well as cgroup
of submitter to bio. Now bio can be offloaded to helper threads for
submission and still be accounted in right cgroup and right iocontext.
As of now only blk throttling layer makes use of it. 

But above is not true for buffered writes, we will not associate io
context. Instead only cgroup information will be sent down and io
context of submitter will be used. 

So any thread which is forced to submit buffered write for some other
cgroup, will have its sync queue also reset (Because CFQ will think
that cgroup of submitter has changed). Not sure how often it will happen,
but if it happens frequenty, this might show up in profiles. I had
mentioned this in the past and IIUC you said we will have to carry
writeback information all the way into lower layers. May be that's
an optimzation for later. So nothing new here, just trying to understand
the current situation.

Also I am wondring if this cgroup and io context information is carried
through dm layer or not. I guess it might be a separate discussion. It
has come for discussion internally in the past. So this might be a good
time to get attention of dm developers on these upcoming changes. (CC dm-devel).

Thanks
Vivek
