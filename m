From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] blk-cgroup: Flush stats before releasing blkcg_gq
Date: Thu, 25 May 2023 12:06:07 -0400
Message-ID: <64f20e27-0927-334d-5414-9bb81d639cec@redhat.com>
References: <20230525043518.831721-1-ming.lei@redhat.com>
 <20230525160105.1968749-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685030770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RW6xkry1d3qd4VTgcj2aqPeVU0gvUy7A96cvhS/wbuM=;
        b=Z1LSv3xA79iKW1lB/F4cUzhyw3sVFclajgyYHMuyldBp3v59IZ3KhGmfGURPIHod6mMs0/
        Hry20vcPygtvSSFnA+mxDCMQTHuY8PURiRQsd4f4RPDaW3Mb0NqdHls/tNapzTHQIyMHaU
        AMqfNedrjASFVY5VXPQSo0lE2ipj3rI=
Content-Language: en-US
In-Reply-To: <20230525160105.1968749-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Yosry Ahmed <yosryahmed@google.com>, Jay Shin <jaeshin@redhat.com>, stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

On 5/25/23 12:01, Waiman Long wrote:
> As noted by Michal, the blkg_iostat_set's in the lockless list hold
> reference to blkg's to protect against their removal. Those blkg's
> hold reference to blkcg. When a cgroup is being destroyed,
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
> To prevent this potential memory leak:
>
> - flush blkcg per-cpu stats list in __blkg_release(), when no new stat
>    can be added to avoid use-after-free of the percpu blkg_iostat_set in
>    futue cgroup_rstat_flush*() calls.
>
> - add a cgroup_rstat_flush_acquire() helper and call it to acquire
>    cgroup_rstat_lock to block concurrent execution of other
>    cgroup_rstat_flush*() calls
>
> - don't grab bio->bi_blkg reference when adding the stats into blkcg's
>    per-cpu stat list since all stats are guaranteed to be consumed before
>    releasing blkg instance, and grabbing blkg reference for stats was
>    the most fragile part of original patch
>
> Based on Waiman's patch:
>
> https://lore.kernel.org/linux-block/20221215033132.230023-3-longman@redhat.com/
>
> Fixes: 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()")
> Cc: stable@vger.kernel.org
> Reported-by: Jay Shin <jaeshin@redhat.com>
> Cc: Waiman Long <longman@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: mkoutny@suse.com
> Cc: Yosry Ahmed <yosryahmed@google.com>
> Co-developed-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>   block/blk-cgroup.c     | 57 +++++++++++++++++++++++++++++++-----------
>   include/linux/cgroup.h |  1 +
>   kernel/cgroup/rstat.c  | 15 ++++++++++-
>   3 files changed, 57 insertions(+), 16 deletions(-)

This is my counter-proposal to Ming's v3 patch. The major difference is 
that I used the existing cgroup_rstat_lock instead of adding a new 
internal lock. This minimizes performance impact to existing 
cgroup_rstat_flush*() call while achieving the same objective. I am fine 
with Ming current v3 patch if we decide to go that way.

Thanks,
Longman

>
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 0ce64dd73cfe..90c2efc3767f 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -160,13 +160,39 @@ static void blkg_free(struct blkcg_gq *blkg)
>   	schedule_work(&blkg->free_work);
>   }
>   
> +static void __blkcg_rstat_flush(struct llist_node *lnode);
> +
>   static void __blkg_release(struct rcu_head *rcu)
>   {
>   	struct blkcg_gq *blkg = container_of(rcu, struct blkcg_gq, rcu_head);
> +	struct blkcg *blkcg = blkg->blkcg;
> +	int cpu;
>   
>   #ifdef CONFIG_BLK_CGROUP_PUNT_BIO
>   	WARN_ON(!bio_list_empty(&blkg->async_bios));
>   #endif
> +	/*
> +	 * Flush all the non-empty percpu lockless lists before releasing
> +	 * us, given these stat belongs to us.
> +	 *
> +	 * Hold the cgroup_rstat_lock before calling __blkcg_rstat_flush()
> +	 * to block concurrent cgroup_rstat_flush*() calls.
> +	 */
> +	for_each_possible_cpu(cpu) {
> +		struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
> +		struct llist_node *lnode;
> +
> +		if (llist_empty(lhead))
> +			continue;
> +
> +		lnode = llist_del_all(lhead);
> +		if (!lnode)
> +			continue;
> +
> +		cgroup_rstat_flush_acquire();
> +		__blkcg_rstat_flush(lnode);
> +		cgroup_rstat_flush_release();
> +	}
>   
>   	/* release the blkcg and parent blkg refs this blkg has been holding */
>   	css_put(&blkg->blkcg->css);
> @@ -951,23 +977,12 @@ static void blkcg_iostat_update(struct blkcg_gq *blkg, struct blkg_iostat *cur,
>   	u64_stats_update_end_irqrestore(&blkg->iostat.sync, flags);
>   }
>   
> -static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
> +static void __blkcg_rstat_flush(struct llist_node *lnode)
>   {
> -	struct blkcg *blkcg = css_to_blkcg(css);
> -	struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
> -	struct llist_node *lnode;
>   	struct blkg_iostat_set *bisc, *next_bisc;
>   
> -	/* Root-level stats are sourced from system-wide IO stats */
> -	if (!cgroup_parent(css->cgroup))
> -		return;
> -
>   	rcu_read_lock();
>   
> -	lnode = llist_del_all(lhead);
> -	if (!lnode)
> -		goto out;
> -
>   	/*
>   	 * Iterate only the iostat_cpu's queued in the lockless list.
>   	 */
> @@ -991,13 +1006,26 @@ static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
>   		if (parent && parent->parent)
>   			blkcg_iostat_update(parent, &blkg->iostat.cur,
>   					    &blkg->iostat.last);
> -		percpu_ref_put(&blkg->refcnt);
>   	}
>   
> -out:
>   	rcu_read_unlock();
>   }
>   
> +static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
> +{
> +	struct blkcg *blkcg = css_to_blkcg(css);
> +	struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
> +	struct llist_node *lnode;Jay Shin <jaeshin@redhat.com>
> +
> +	/* Root-level stats are sourced from system-wide IO stats */
> +	if (!cgroup_parent(css->cgroup))
> +		return;
> +
> +	lnode = llist_del_all(lhead);
> +	if (lnode)
> +		__blkcg_rstat_flush(lnode);
> +}
> +
>   /*
>    * We source root cgroup stats from the system-wide stats to avoid
>    * tracking the same information twice and incurring overhead when no
> @@ -2075,7 +2103,6 @@ void blk_cgroup_bio_start(struct bio *bio)
>   
>   		llist_add(&bis->lnode, lhead);
>   		WRITE_ONCE(bis->lqueued, true);
> -		percpu_ref_get(&bis->blkg->refcnt);
>   	}
>   
>   	u64_stats_update_end_irqrestore(&bis->sync, flags);
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 885f5395fcd0..88e6647f49df 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -694,6 +694,7 @@ void cgroup_rstat_updated(struct cgroup *cgrp, int cpu);
>   void cgroup_rstat_flush(struct cgroup *cgrp);
>   void cgroup_rstat_flush_atomic(struct cgroup *cgrp);
>   void cgroup_rstat_flush_hold(struct cgroup *cgrp);
> +void cgroup_rstat_flush_acquire(void);
>   void cgroup_rstat_flush_release(void);
>   
>   /*
> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> index 9c4c55228567..b0fd4e27f466 100644
> --- a/kernel/cgroup/rstat.c
> +++ b/kernel/cgroup/rstat.c
> @@ -273,7 +273,20 @@ void cgroup_rstat_flush_hold(struct cgroup *cgrp)
>   }
>   
>   /**
> - * cgroup_rstat_flush_release - release cgroup_rstat_flush_hold()
> + * cgroup_rstat_flush_acquire - acquire cgroup_rstat_lock
> + *
> + * Callers can acquire the internal cgroup_rstat_lock to prevent concurrent
> + * execution of cgroup_rstat_flush*() and the controller callbacks.
> + */
> +void cgroup_rstat_flush_acquire(void)
> +	__acquires(&cgroup_rstat_lock)
> +{
> +	spin_lock_irq(&cgroup_rstat_lock);
> +}
> +
> +/**
> + * cgroup_rstat_flush_release - release cgroup_rstat_flush_hold() or
> + *				cgroup_rstat_flush_acquire()
>    */
>   void cgroup_rstat_flush_release(void)
>   	__releases(&cgroup_rstat_lock)

