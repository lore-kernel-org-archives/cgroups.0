From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 3/5] writeback: bdi_writeback iteration must not skip
 dying ones
Date: Fri, 2 Oct 2015 16:12:12 +0200
Message-ID: <20151002141212.GA17746@quack.suse.cz>
References: <1443545274-18787-1-git-send-email-tj@kernel.org>
 <1443545274-18787-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443545274-18787-4-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue 29-09-15 12:47:52, Tejun Heo wrote:
> bdi_for_each_wb() is used in several places to wake up or issue
> writeback work items to all wb's (bdi_writeback's) on a given bdi.
> The iteration is performed by walking bdi->cgwb_tree; however, the
> tree only indexes wb's which are currently active.
> 
> For example, when a memcg gets associated with a different blkcg, the
> old wb is removed from the tree so that the new one can be indexed.
> The old wb starts dying from then on but will linger till all its
> inodes are drained.  As these dying wb's may still host dirty inodes,
> writeback operations which affect all wb's must include them.
> bdi_for_each_wb() skipping dying wb's led to sync(2) missing and
> failing to sync the inodes belonging to those wb's.
> 
> This patch adds a RCU protected @bdi->wb_list which lists all wb's
> beloinging to that bdi.  wb's are added on creation and removed on
> release rather than on the start of destruction.  bdi_for_each_wb()
> usages are replaced with list_for_each[_continue]_rcu() iterations
> over @bdi->wb_list and bdi_for_each_wb() and its helpers are removed.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-and-tested-by: Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Fixes: ebe41ab0c79d ("writeback: implement bdi_for_each_wb()")
> Link: http://lkml.kernel.org/g/1443012552.19983.209.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> ---
>  fs/fs-writeback.c                | 28 ++++++++++++------
>  include/linux/backing-dev-defs.h |  3 ++
>  include/linux/backing-dev.h      | 63 ----------------------------------------
>  mm/backing-dev.c                 | 17 ++++++++++-
>  mm/page-writeback.c              |  3 +-
>  5 files changed, 39 insertions(+), 75 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index d0da306..afa4848 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -778,19 +778,24 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
>  				  struct wb_writeback_work *base_work,
>  				  bool skip_if_busy)
>  {
> -	int next_memcg_id = 0;
> -	struct bdi_writeback *wb;
> -	struct wb_iter iter;
> +	struct bdi_writeback *last_wb = NULL;
> +	struct bdi_writeback *wb = list_entry_rcu(&bdi->wb_list,
> +						struct bdi_writeback, bdi_node);
>  
>  	might_sleep();
>  restart:
>  	rcu_read_lock();
> -	bdi_for_each_wb(wb, bdi, &iter, next_memcg_id) {
> +	list_for_each_entry_continue_rcu(wb, &bdi->wb_list, bdi_node) {
>  		DEFINE_WB_COMPLETION_ONSTACK(fallback_work_done);
>  		struct wb_writeback_work fallback_work;
>  		struct wb_writeback_work *work;
>  		long nr_pages;
>  
> +		if (last_wb) {
> +			wb_put(last_wb);
> +			last_wb = NULL;
> +		}

But you seem to forget to drop last_wb reference in case this was the last
wb in the list, don't you?

> +
>  		/* SYNC_ALL writes out I_DIRTY_TIME too */
>  		if (!wb_has_dirty_io(wb) &&
>  		    (base_work->sync_mode == WB_SYNC_NONE ||
> @@ -819,7 +824,14 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
>  
>  		wb_queue_work(wb, work);
>  
> -		next_memcg_id = wb->memcg_css->id + 1;
> +		/*
> +		 * Pin @wb so that it stays on @bdi->wb_list.  This allows
> +		 * continuing iteration from @wb after dropping and
> +		 * regrabbing rcu read lock.
> +		 */
> +		wb_get(wb);
> +		last_wb = wb;
> +
>  		rcu_read_unlock();
>  		wb_wait_for_completion(bdi, &fallback_work_done);
>  		goto restart;
...
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 2df8ddc..c48070b 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -686,6 +691,9 @@ static void cgwb_bdi_destroy(struct backing_dev_info *bdi)
>  	radix_tree_for_each_slot(slot, &bdi->cgwb_tree, &iter, 0)
>  		cgwb_kill(*slot);
>  
> +	/* wb may get released after @bdi is freed, sever list head */
> +	list_del(&bdi->wb_list);
> +

But we wait for bdi->usage_cnt to drop to 0 which means there's no wb,
don't we? What am I missing?

> @@ -764,15 +772,22 @@ static void cgwb_bdi_destroy(struct backing_dev_info *bdi) { }
>  
>  int bdi_init(struct backing_dev_info *bdi)
>  {
> +	int ret;
> +
>  	bdi->dev = NULL;
>  
>  	bdi->min_ratio = 0;
>  	bdi->max_ratio = 100;
>  	bdi->max_prop_frac = FPROP_FRAC_BASE;
>  	INIT_LIST_HEAD(&bdi->bdi_list);
> +	INIT_LIST_HEAD(&bdi->wb_list);
>  	init_waitqueue_head(&bdi->wb_waitq);
>  
> -	return cgwb_bdi_init(bdi);
> +	ret = cgwb_bdi_init(bdi);
> +
> +	list_add_tail_rcu(&bdi->wb.bdi_node, &bdi->wb_list);

Won't this be more logical in cgwb_bdi_init()?

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
