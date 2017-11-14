From: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/7] blkcg: use percpu_ref for blkcg_gq->refcnt
Date: Tue, 14 Nov 2017 15:12:55 -0800
Message-ID: <20171114231255.xhpye5qhntm5m4l7@kernel.org>
References: <20171112222613.3613362-1-tj@kernel.org>
 <20171112222613.3613362-3-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171112222613.3613362-3-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On Sun, Nov 12, 2017 at 02:26:08PM -0800, Tejun Heo wrote:
> blkcg_gq->refcnt is an atomic_t.  This was due to the following two
> reasons.
> 
> * When blkcg_gq was added, the percpu memory allocator didn't support
>   allocations from !GFP_KERNEL contexts.  Because blkcg_gq's are
>   created from IO issue paths, it couldn't use GFP_KERNEL allocations.
> 
> * A blkcg_gq represents the connection between a cgroup and a
>   request_queue.  Because a in-flight bio already pins both, blkcg_gq
>   didn't usually need explicit pinning, making the use of atomic_t
>   acceptable albeit restrictive and fragile.
> 
> Now that the percpu allocator supports !GFP_KERNEL allocations,
> there's no reason to keep using atomic_t refcnt.  This will allow
> clean separation between bio and request layers helping blkcg support
> in blk-mq.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Reviewed-by: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  block/blk-cgroup.c         | 21 ++++++++++++++++-----
>  include/linux/blk-cgroup.h | 13 ++++---------
>  2 files changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 6482be5..60a4486 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -78,6 +78,7 @@ static void blkg_free(struct blkcg_gq *blkg)
>  
>  	blkg_rwstat_exit(&blkg->stat_ios);
>  	blkg_rwstat_exit(&blkg->stat_bytes);
> +	percpu_ref_exit(&blkg->refcnt);
>  	kfree(blkg);
>  }
>  
> @@ -89,7 +90,7 @@ static void blkg_free(struct blkcg_gq *blkg)
>   * Having a reference to blkg under an rcu allows accesses to only values
>   * local to groups like group stats and group rate limits.
>   */
> -void __blkg_release_rcu(struct rcu_head *rcu_head)
> +static void blkg_release_rcu(struct rcu_head *rcu_head)
>  {
>  	struct blkcg_gq *blkg = container_of(rcu_head, struct blkcg_gq, rcu_head);
>  
> @@ -102,7 +103,13 @@ void __blkg_release_rcu(struct rcu_head *rcu_head)
>  
>  	blkg_free(blkg);
>  }
> -EXPORT_SYMBOL_GPL(__blkg_release_rcu);
> +
> +static void blkg_release(struct percpu_ref *refcnt)
> +{
> +	struct blkcg_gq *blkg = container_of(refcnt, struct blkcg_gq, refcnt);
> +
> +	call_rcu(&blkg->rcu_head, blkg_release_rcu);
> +}
>  
>  /**
>   * blkg_alloc - allocate a blkg
> @@ -123,6 +130,11 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
>  	if (!blkg)
>  		return NULL;
>  
> +	if (percpu_ref_init(&blkg->refcnt, blkg_release, 0, gfp_mask)) {
> +		kfree(blkg);
> +		return NULL;
> +	}
> +
>  	if (blkg_rwstat_init(&blkg->stat_bytes, gfp_mask) ||
>  	    blkg_rwstat_init(&blkg->stat_ios, gfp_mask))
>  		goto err_free;
> @@ -130,7 +142,6 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
>  	blkg->q = q;
>  	INIT_LIST_HEAD(&blkg->q_node);
>  	blkg->blkcg = blkcg;
> -	atomic_set(&blkg->refcnt, 1);
>  
>  	/* root blkg uses @q->root_rl, init rl only for !root blkgs */
>  	if (blkcg != &blkcg_root) {
> @@ -266,7 +277,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
>  		return blkg;
>  
>  	/* @blkg failed fully initialized, use the usual release path */
> -	blkg_put(blkg);
> +	percpu_ref_kill(&blkg->refcnt);
>  	return ERR_PTR(ret);
>  
>  err_put_congested:
> @@ -373,7 +384,7 @@ static void blkg_destroy(struct blkcg_gq *blkg)
>  	 * Put the reference taken at the time of creation so that when all
>  	 * queues are gone, group can be destroyed.
>  	 */
> -	blkg_put(blkg);
> +	percpu_ref_kill(&blkg->refcnt);
>  }
>  
>  /**
> diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
> index 8bbc371..c0d4736 100644
> --- a/include/linux/blk-cgroup.h
> +++ b/include/linux/blk-cgroup.h
> @@ -19,7 +19,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/radix-tree.h>
>  #include <linux/blkdev.h>
> -#include <linux/atomic.h>
> +#include <linux/percpu-refcount.h>
>  
>  /* percpu_counter batch for blkg_[rw]stats, per-cpu drift doesn't matter */
>  #define BLKG_STAT_CPU_BATCH	(INT_MAX / 2)
> @@ -123,7 +123,7 @@ struct blkcg_gq {
>  	struct request_list		rl;
>  
>  	/* reference count */
> -	atomic_t			refcnt;
> +	struct percpu_ref		refcnt;
>  
>  	/* is this blkg online? protected by both blkcg and q locks */
>  	bool				online;
> @@ -355,21 +355,16 @@ static inline int blkg_path(struct blkcg_gq *blkg, char *buf, int buflen)
>   */
>  static inline void blkg_get(struct blkcg_gq *blkg)
>  {
> -	WARN_ON_ONCE(atomic_read(&blkg->refcnt) <= 0);
> -	atomic_inc(&blkg->refcnt);
> +	percpu_ref_get(&blkg->refcnt);
>  }
>  
> -void __blkg_release_rcu(struct rcu_head *rcu);
> -
>  /**
>   * blkg_put - put a blkg reference
>   * @blkg: blkg to put
>   */
>  static inline void blkg_put(struct blkcg_gq *blkg)
>  {
> -	WARN_ON_ONCE(atomic_read(&blkg->refcnt) <= 0);
> -	if (atomic_dec_and_test(&blkg->refcnt))
> -		call_rcu(&blkg->rcu_head, __blkg_release_rcu);
> +	percpu_ref_put(&blkg->refcnt);
>  }
>  
>  /**
> -- 
> 2.9.5
> 
