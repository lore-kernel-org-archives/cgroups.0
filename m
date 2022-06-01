From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 2/2] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Wed, 1 Jun 2022 11:26:31 -1000
Message-ID: <YpfZh6JZZMzUQIAt@slm.duckdns.org>
References: <20220601211824.89626-1-longman@redhat.com>
 <20220601211824.89626-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DeE+qfoJQxYST9JQ5L5VBWKSrvnnbYr6lQAJ2d+3gZo=;
        b=bZarlHf+0nmOJr5LAhMr+3x25ZSPmU3TgSFxbodDq9aYvF4AHoOy0lk0jPg3j85osx
         0PJOgkJ1BCkoi7zh+7YLyA5mLake7Yk4EeLweEbtOpB1OHDle2WqTLbT8/zUOD3gZeUy
         f5yt1hN5H/BiJ09myqiKjYvsl4rwoqVXERyi4txJMErXYjD2KVQFwCKgula3rU/0CE8I
         kVtUBkNARN2ag5FAM4lGtGnV3PjOZqF2Ss8FL0NZEa812VDE9YKGoJyv9d+of4InPpt8
         PRtBVqiysI+YOgr9NB2ijkZD/9WpVO0FulqYolM0DXzLUccydmTGKNfqCysBMkUMLnJF
         DTkg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220601211824.89626-3-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

On Wed, Jun 01, 2022 at 05:18:24PM -0400, Waiman Long wrote:
> @@ -59,6 +59,57 @@ static struct workqueue_struct *blkcg_punt_bio_wq;
>  
>  #define BLKG_DESTROY_BATCH_SIZE  64
>  
> +/*
> + * lnode.next of the last entry in a lockless list is NULL. To make it
> + * always non-NULL for lnode's, a sentinel node has to be put at the
> + * end of the lockless list. So all the percpu lhead's are initialized
> + * to point to that sentinel node.
> + */

Can you please add why we want all entries to have non-NULL next?

> +static inline bool blkcg_llist_empty(struct llist_head *lhead)
> +{
> +	return lhead->first == &llist_last;
> +}
> +
> +static inline void init_blkcg_llists(struct blkcg *blkcg)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		per_cpu_ptr(blkcg->lhead, cpu)->first = &llist_last;
> +}
> +
> +static inline struct llist_node *
> +fetch_delete_blkcg_llist(struct llist_head *lhead)
> +{
> +	return xchg(&lhead->first, &llist_last);
> +}
> +
> +static inline struct llist_node *
> +fetch_delete_lnode_next(struct llist_node *lnode)
> +{
> +	struct llist_node *next = READ_ONCE(lnode->next);
> +	struct blkcg_gq *blkg = llist_entry(lnode, struct blkg_iostat_set,
> +					    lnode)->blkg;
> +
> +	WRITE_ONCE(lnode->next, NULL);
> +	percpu_ref_put(&blkg->refcnt);
> +	return next;
> +}

It's not a strong opinion but I'm not too fond of using inlines to mark
trivial functions. The compiler should be able to make these decisions,
right?

Other than the above two bikesheddings,

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
