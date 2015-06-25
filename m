From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/7] blk-throttle: remove asynchrnous percpu stats
 allocation mechanism
Date: Thu, 25 Jun 2015 15:10:17 -0400
Message-ID: <20150625191017.GA6919@redhat.com>
References: <1435113853-12053-1-git-send-email-tj@kernel.org>
 <1435113853-12053-6-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1435113853-12053-6-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Jun 23, 2015 at 10:44:11PM -0400, Tejun Heo wrote:
> Because percpu allocator couldn't do non-blocking allocations,
> blk-throttle was forced to implement an ad-hoc asynchronous allocation
> mechanism for its percpu stats for cases where blkg's (blkcg_gq's) are
> allocated from an IO path without sleepable context.
> 
> Now that percpu allocator can handle gfp_mask and blkg_policy_data
> alloc / free are handled by policy methods, the ad-hoc asynchronous
> allocation mechanism can be replaced with direct allocation from
> tg_stats_alloc_fn().  Rit it out.
> 
> This ensures that an active throtl_grp always has valid non-NULL
> ->stats_cpu.  Remove checks on it.

This is a nice cleanup. Allocating stats memory with the help of
a worker thread was twisted.

Thanks
Vivek

> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  block/blk-throttle.c | 112 ++++++++++++---------------------------------------
>  1 file changed, 25 insertions(+), 87 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index f1dd691..3c86976 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -144,9 +144,6 @@ struct throtl_grp {
>  
>  	/* Per cpu stats pointer */
>  	struct tg_stats_cpu __percpu *stats_cpu;
> -
> -	/* List of tgs waiting for per cpu stats memory to be allocated */
> -	struct list_head stats_alloc_node;
>  };
>  
>  struct throtl_data
> @@ -168,13 +165,6 @@ struct throtl_data
>  	struct work_struct dispatch_work;
>  };
>  
> -/* list and work item to allocate percpu group stats */
> -static DEFINE_SPINLOCK(tg_stats_alloc_lock);
> -static LIST_HEAD(tg_stats_alloc_list);
> -
> -static void tg_stats_alloc_fn(struct work_struct *);
> -static DECLARE_DELAYED_WORK(tg_stats_alloc_work, tg_stats_alloc_fn);
> -
>  static void throtl_pending_timer_fn(unsigned long arg);
>  
>  static inline struct throtl_grp *pd_to_tg(struct blkg_policy_data *pd)
> @@ -256,53 +246,6 @@ static struct throtl_data *sq_to_td(struct throtl_service_queue *sq)
>  	}								\
>  } while (0)
>  
> -static void tg_stats_init(struct tg_stats_cpu *tg_stats)
> -{
> -	blkg_rwstat_init(&tg_stats->service_bytes);
> -	blkg_rwstat_init(&tg_stats->serviced);
> -}
> -
> -/*
> - * Worker for allocating per cpu stat for tgs. This is scheduled on the
> - * system_wq once there are some groups on the alloc_list waiting for
> - * allocation.
> - */
> -static void tg_stats_alloc_fn(struct work_struct *work)
> -{
> -	static struct tg_stats_cpu *stats_cpu;	/* this fn is non-reentrant */
> -	struct delayed_work *dwork = to_delayed_work(work);
> -	bool empty = false;
> -
> -alloc_stats:
> -	if (!stats_cpu) {
> -		int cpu;
> -
> -		stats_cpu = alloc_percpu(struct tg_stats_cpu);
> -		if (!stats_cpu) {
> -			/* allocation failed, try again after some time */
> -			schedule_delayed_work(dwork, msecs_to_jiffies(10));
> -			return;
> -		}
> -		for_each_possible_cpu(cpu)
> -			tg_stats_init(per_cpu_ptr(stats_cpu, cpu));
> -	}
> -
> -	spin_lock_irq(&tg_stats_alloc_lock);
> -
> -	if (!list_empty(&tg_stats_alloc_list)) {
> -		struct throtl_grp *tg = list_first_entry(&tg_stats_alloc_list,
> -							 struct throtl_grp,
> -							 stats_alloc_node);
> -		swap(tg->stats_cpu, stats_cpu);
> -		list_del_init(&tg->stats_alloc_node);
> -	}
> -
> -	empty = list_empty(&tg_stats_alloc_list);
> -	spin_unlock_irq(&tg_stats_alloc_lock);
> -	if (!empty)
> -		goto alloc_stats;
> -}
> -
>  static void throtl_qnode_init(struct throtl_qnode *qn, struct throtl_grp *tg)
>  {
>  	INIT_LIST_HEAD(&qn->node);
> @@ -405,7 +348,27 @@ static void throtl_service_queue_exit(struct throtl_service_queue *sq)
>  
>  static struct blkg_policy_data *throtl_pd_alloc(gfp_t gfp, int node)
>  {
> -	return kzalloc_node(sizeof(struct throtl_grp), gfp, node);
> +	struct throtl_grp *tg;
> +	int cpu;
> +
> +	tg = kzalloc_node(sizeof(*tg), gfp, node);
> +	if (!tg)
> +		return NULL;
> +
> +	tg->stats_cpu = alloc_percpu_gfp(struct tg_stats_cpu, gfp);
> +	if (!tg->stats_cpu) {
> +		kfree(tg);
> +		return NULL;
> +	}
> +
> +	for_each_possible_cpu(cpu) {
> +		struct tg_stats_cpu *stats_cpu = per_cpu_ptr(tg->stats_cpu, cpu);
> +
> +		blkg_rwstat_init(&stats_cpu->service_bytes);
> +		blkg_rwstat_init(&stats_cpu->serviced);
> +	}
> +
> +	return &tg->pd;
>  }
>  
>  static void throtl_pd_init(struct blkcg_gq *blkg)
> @@ -413,7 +376,6 @@ static void throtl_pd_init(struct blkcg_gq *blkg)
>  	struct throtl_grp *tg = blkg_to_tg(blkg);
>  	struct throtl_data *td = blkg->q->td;
>  	struct throtl_service_queue *parent_sq;
> -	unsigned long flags;
>  	int rw;
>  
>  	/*
> @@ -448,16 +410,6 @@ static void throtl_pd_init(struct blkcg_gq *blkg)
>  	tg->bps[WRITE] = -1;
>  	tg->iops[READ] = -1;
>  	tg->iops[WRITE] = -1;
> -
> -	/*
> -	 * Ugh... We need to perform per-cpu allocation for tg->stats_cpu
> -	 * but percpu allocator can't be called from IO path.  Queue tg on
> -	 * tg_stats_alloc_list and allocate from work item.
> -	 */
> -	spin_lock_irqsave(&tg_stats_alloc_lock, flags);
> -	list_add(&tg->stats_alloc_node, &tg_stats_alloc_list);
> -	schedule_delayed_work(&tg_stats_alloc_work, 0);
> -	spin_unlock_irqrestore(&tg_stats_alloc_lock, flags);
>  }
>  
>  /*
> @@ -487,20 +439,16 @@ static void throtl_pd_online(struct blkcg_gq *blkg)
>  static void throtl_pd_exit(struct blkcg_gq *blkg)
>  {
>  	struct throtl_grp *tg = blkg_to_tg(blkg);
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&tg_stats_alloc_lock, flags);
> -	list_del_init(&tg->stats_alloc_node);
> -	spin_unlock_irqrestore(&tg_stats_alloc_lock, flags);
> -
> -	free_percpu(tg->stats_cpu);
>  
>  	throtl_service_queue_exit(&tg->service_queue);
>  }
>  
>  static void throtl_pd_free(struct blkg_policy_data *pd)
>  {
> -	kfree(pd);
> +	struct throtl_grp *tg = pd_to_tg(pd);
> +
> +	free_percpu(tg->stats_cpu);
> +	kfree(tg);
>  }
>  
>  static void throtl_pd_reset_stats(struct blkcg_gq *blkg)
> @@ -508,9 +456,6 @@ static void throtl_pd_reset_stats(struct blkcg_gq *blkg)
>  	struct throtl_grp *tg = blkg_to_tg(blkg);
>  	int cpu;
>  
> -	if (tg->stats_cpu == NULL)
> -		return;
> -
>  	for_each_possible_cpu(cpu) {
>  		struct tg_stats_cpu *sc = per_cpu_ptr(tg->stats_cpu, cpu);
>  
> @@ -973,10 +918,6 @@ static void throtl_update_dispatch_stats(struct blkcg_gq *blkg, u64 bytes,
>  	struct tg_stats_cpu *stats_cpu;
>  	unsigned long flags;
>  
> -	/* If per cpu stats are not allocated yet, don't do any accounting. */
> -	if (tg->stats_cpu == NULL)
> -		return;
> -
>  	/*
>  	 * Disabling interrupts to provide mutual exclusion between two
>  	 * writes on same cpu. It probably is not needed for 64bit. Not
> @@ -1302,9 +1243,6 @@ static u64 tg_prfill_cpu_rwstat(struct seq_file *sf,
>  	struct blkg_rwstat rwstat = { }, tmp;
>  	int i, cpu;
>  
> -	if (tg->stats_cpu == NULL)
> -		return 0;
> -
>  	for_each_possible_cpu(cpu) {
>  		struct tg_stats_cpu *sc = per_cpu_ptr(tg->stats_cpu, cpu);
>  
> -- 
> 2.4.3
