From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v4 2/2] blk-cgroup: Flush stats at blkgs destruction path
Date: Thu, 2 Feb 2023 12:15:52 +0800
Message-ID: <Y9s4+Nop1eluWmJ4@T590>
References: <20221215033132.230023-1-longman@redhat.com>
 <20221215033132.230023-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675311371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0Evaq+uKsw2JRl30GbWwAirFdc+12RiKunGeodqBwPs=;
        b=XzrDcsxwOaBz9psXY4Gn3iGyhvus53RuZ2l89NQ5d9kM32nsUcDDOpogr2CJEBA/husQJA
        rfjYRCY5vVU8N3YzlsCuq/PCWXBt/FBD/u4KG8uDTE8TalUfluJ2CBzauDVvBL25dcpzF0
        5Gb8nPT6G0vFbw2td3wjekblhk0KIdA=
Content-Disposition: inline
In-Reply-To: <20221215033132.230023-3-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, ming.lei@redhat.com

On Wed, Dec 14, 2022 at 10:31:32PM -0500, Waiman Long wrote:
> As noted by Michal, the blkg_iostat_set's in the lockless list
> hold reference to blkg's to protect against their removal. Those
> blkg's hold reference to blkcg. When a cgroup is being destroyed,
> cgroup_rstat_flush() is only called at css_release_work_fn() which
> is called when the blkcg reference count reaches 0. This circular
> dependency will prevent blkcg and some blkgs from being freed after
> they are made offline.
> 
> It is less a problem if the cgroup to be destroyed also has other
> controllers like memory that will call cgroup_rstat_flush() which will
> clean up the reference count. If block is the only controller that uses
> rstat, these offline blkcg and blkgs may never be freed leaking more
> and more memory over time.
> 
> To prevent this potential memory leak, a new cgroup_rstat_css_cpu_flush()
> function is added to flush stats for a given css and cpu. This new
> function will be called at blkgs destruction path, blkcg_destroy_blkgs(),
> whenever there are still pending stats to be flushed. This will release
> the references to blkgs allowing them to be freed and indirectly allow
> the freeing of blkcg.
> 
> Fixes: 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()")
> Signed-off-by: Waiman Long <longman@redhat.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> ---
>  block/blk-cgroup.c     | 16 ++++++++++++++++
>  include/linux/cgroup.h |  1 +
>  kernel/cgroup/rstat.c  | 18 ++++++++++++++++++
>  3 files changed, 35 insertions(+)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index ca28306aa1b1..a2a1081d9d1d 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -1084,6 +1084,8 @@ struct list_head *blkcg_get_cgwb_list(struct cgroup_subsys_state *css)
>   */
>  static void blkcg_destroy_blkgs(struct blkcg *blkcg)
>  {
> +	int cpu;
> +
>  	/*
>  	 * blkcg_destroy_blkgs() shouldn't be called with all the blkcg
>  	 * references gone.
> @@ -1093,6 +1095,20 @@ static void blkcg_destroy_blkgs(struct blkcg *blkcg)
>  
>  	might_sleep();
>  
> +	/*
> +	 * Flush all the non-empty percpu lockless lists to release the
> +	 * blkg references held by those lists which, in turn, will
> +	 * allow those blkgs to be freed and release their references to
> +	 * blkcg. Otherwise, they may not be freed at all becase of this
> +	 * circular dependency resulting in memory leak.
> +	 */
> +	for_each_possible_cpu(cpu) {
> +		struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
> +
> +		if (!llist_empty(lhead))
> +			cgroup_rstat_css_cpu_flush(&blkcg->css, cpu);
> +	}

I guess it is possible for new iostat_cpu to be added just after the
llist_empty() check.


Thanks,
Ming

