From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Wed, 1 Jun 2022 07:48:06 -1000
Message-ID: <YpemVpvaPomwH7mt@slm.duckdns.org>
References: <20220601165324.60892-1-longman@redhat.com>
 <20220601165324.60892-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i0RZ8l73WFDDzM6Aj8EMNY9HnT718p+wPtqJImpAAXg=;
        b=S3qixs5BU1PZ015xxJdsdLuFlKjPKLu5LQhK9EbUs3wNr7hohaemHdXqaFP38FJxhS
         NOdL63FvglE0nVP/ytYaAQ8/SI+xisMk8kKFHjOr3Ms4MaIECDFfFugdb/7zdQw4gIfu
         z4jL2kM1LV6bt8zgoBPQ90Y2K7oI8ROA5R7kA49kP+DzTSQyhU/yk5JoliBZbvJUGjj0
         QXmS7mjQGFEewCudnT6f/JBAKstnLrbMznCYT9p4iZQKD35NI/VAH+GllJr6xxbwAkXh
         fZW4CRltCagOkCaM9d1YSvrCzLQisoFLpHHzeI/j9BQ32TzG4soMEMqy2Gf1po7c/nvH
         RDXQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220601165324.60892-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello,

On Wed, Jun 01, 2022 at 12:53:24PM -0400, Waiman Long wrote:
> +static struct llist_node llist_last;	/* Last sentinel node of llist */

Can you please add comment explaining why we need the special sentinel and
empty helper?

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
> +/*
> + * The retrieved blkg_iostat_set is immediately marked as not in the
> + * lockless list by clearing its node->next pointer. It could be put
> + * back into the list by a parallel update before the iostat's are
> + * finally flushed. So being in the list doesn't always mean it has new
> + * iostat's to be flushed.
> + */

Isn't the above true for any sort of mechanism which tracking pending state?
You gotta clear the pending state before consuming so that you don't miss
the events which happen while data is being consumed.

> +#define blkcg_llist_for_each_entry_safe(pos, node, nxt)			\
> +	for (; (node != &llist_last) &&					\
> +	       (pos = llist_entry(node, struct blkg_iostat_set, lnode),	\
> +		nxt = node->next, node->next = NULL, true);		\
> +		node = nxt)
> +
>  /**
>   * blkcg_css - find the current css
>   *
...
> @@ -852,17 +888,26 @@ static void blkg_iostat_sub(struct blkg_iostat *dst, struct blkg_iostat *src)
>  static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
>  {
>  	struct blkcg *blkcg = css_to_blkcg(css);
> -	struct blkcg_gq *blkg;
> +	struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
> +	struct llist_node *lnode, *lnext;
> +	struct blkg_iostat_set *bisc;
>  
>  	/* Root-level stats are sourced from system-wide IO stats */
>  	if (!cgroup_parent(css->cgroup))
>  		return;
>  
> -	rcu_read_lock();
> +	if (blkcg_llist_empty(lhead))
> +		return;
>  
> -	hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
> +	lnode = fetch_delete_blkcg_llist(lhead);
> +
> +	/*
> +	 * No RCU protection is needed as it is assumed that blkg_iostat_set's
> +	 * in the percpu lockless list won't go away until the flush is done.
> +	 */

Can you please elaborate on why this is safe?

> +	blkcg_llist_for_each_entry_safe(bisc, lnode, lnext) {
> +		struct blkcg_gq *blkg = bisc->blkg;
>  		struct blkcg_gq *parent = blkg->parent;
> -		struct blkg_iostat_set *bisc = per_cpu_ptr(blkg->iostat_cpu, cpu);
>  		struct blkg_iostat cur, delta;
>  		unsigned long flags;
>  		unsigned int seq;

Overall, looks fantastic to me. Thanks a lot for working on it.

-- 
tejun
