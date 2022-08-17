From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -next 1/3] block, bfq: remove unused functions
Date: Wed, 17 Aug 2022 13:55:01 +0200
Message-ID: <20220817115501.bwfpvdgppwd4p55y@quack3>
References: <20220816015631.1323948-1-yukuai1@huaweicloud.com>
 <20220816015631.1323948-2-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660737303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GO5Pl2p51jwCdZ3qSxxX8zQ5xuKpuTPAsF36LK0rcTM=;
        b=itipK7raRMIbg7s8zVjuY/dZ+Cyi833cvu2pTQ6EGXur2Rkn77oLFbYHQUk7E5Y9EXVGjb
        O/XtXYvwvOAZphPy43oC+7NPEW9rjIXP59KIJUra/Kfqga+xk7lVFIMS+WpskLO2r86KYI
        XqVVOWiwFiYGGJ3LjS0Kh+yoUa4shpg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660737303;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GO5Pl2p51jwCdZ3qSxxX8zQ5xuKpuTPAsF36LK0rcTM=;
        b=OCt1Zp3eRLoyfBZNtDxXMQ8dtyiNz/h8rCO7CC5k/3cwXqqJhgglaCwGLvlxewLXk3ruI+
        hEvUtzsrwFye6YCw==
Content-Disposition: inline
In-Reply-To: <20220816015631.1323948-2-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: jack-AlSwsSmVLrQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Tue 16-08-22 09:56:29, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> While doing code coverage testing(CONFIG_BFQ_CGROUP_DEBUG is disabled), we
> found that some functions doesn't have caller, thus remove them.
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  block/bfq-cgroup.c  |  5 -----
>  block/bfq-iosched.h | 13 ++++++++-----
>  2 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index 30b15a9a47c4..144bca006463 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -254,17 +254,12 @@ void bfqg_stats_update_completion(struct bfq_group *bfqg, u64 start_time_ns,
>  
>  #else /* CONFIG_BFQ_CGROUP_DEBUG */
>  
> -void bfqg_stats_update_io_add(struct bfq_group *bfqg, struct bfq_queue *bfqq,
> -			      blk_opf_t opf) { }
>  void bfqg_stats_update_io_remove(struct bfq_group *bfqg, blk_opf_t opf) { }
>  void bfqg_stats_update_io_merged(struct bfq_group *bfqg, blk_opf_t opf) { }
>  void bfqg_stats_update_completion(struct bfq_group *bfqg, u64 start_time_ns,
>  				  u64 io_start_time_ns, blk_opf_t opf) { }
>  void bfqg_stats_update_dequeue(struct bfq_group *bfqg) { }
> -void bfqg_stats_set_start_empty_time(struct bfq_group *bfqg) { }
> -void bfqg_stats_update_idle_time(struct bfq_group *bfqg) { }
>  void bfqg_stats_set_start_idle_time(struct bfq_group *bfqg) { }
> -void bfqg_stats_update_avg_queue_size(struct bfq_group *bfqg) { }
>  
>  #endif /* CONFIG_BFQ_CGROUP_DEBUG */
>  
> diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
> index ad8e513d7e87..f81ab3c8fa3c 100644
> --- a/block/bfq-iosched.h
> +++ b/block/bfq-iosched.h
> @@ -993,20 +993,23 @@ void bfq_put_async_queues(struct bfq_data *bfqd, struct bfq_group *bfqg);
>  /* ---------------- cgroups-support interface ---------------- */
>  
>  void bfqg_stats_update_legacy_io(struct request_queue *q, struct request *rq);
> -void bfqg_stats_update_io_add(struct bfq_group *bfqg, struct bfq_queue *bfqq,
> -			      blk_opf_t opf);
>  void bfqg_stats_update_io_remove(struct bfq_group *bfqg, blk_opf_t opf);
>  void bfqg_stats_update_io_merged(struct bfq_group *bfqg, blk_opf_t opf);
>  void bfqg_stats_update_completion(struct bfq_group *bfqg, u64 start_time_ns,
>  				  u64 io_start_time_ns, blk_opf_t opf);
>  void bfqg_stats_update_dequeue(struct bfq_group *bfqg);
> -void bfqg_stats_set_start_empty_time(struct bfq_group *bfqg);
> -void bfqg_stats_update_idle_time(struct bfq_group *bfqg);
>  void bfqg_stats_set_start_idle_time(struct bfq_group *bfqg);
> -void bfqg_stats_update_avg_queue_size(struct bfq_group *bfqg);
>  void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
>  		   struct bfq_group *bfqg);
>  
> +#ifdef CONFIG_BFQ_CGROUP_DEBUG
> +void bfqg_stats_update_io_add(struct bfq_group *bfqg, struct bfq_queue *bfqq,
> +			      blk_opf_t opf);
> +void bfqg_stats_set_start_empty_time(struct bfq_group *bfqg);
> +void bfqg_stats_update_idle_time(struct bfq_group *bfqg);
> +void bfqg_stats_update_avg_queue_size(struct bfq_group *bfqg);
> +#endif
> +
>  void bfq_init_entity(struct bfq_entity *entity, struct bfq_group *bfqg);
>  void bfq_bic_update_cgroup(struct bfq_io_cq *bic, struct bio *bio);
>  void bfq_end_wr_async(struct bfq_data *bfqd);
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
