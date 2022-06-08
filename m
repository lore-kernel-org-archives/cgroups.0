From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v6 3/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Wed, 8 Jun 2022 18:57:32 +0200
Message-ID: <20220608165732.GB19399@blackbody.suse.cz>
References: <20220602192020.166940-1-longman@redhat.com>
 <20220602192020.166940-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654707454; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5e+pVB/HXrwHYJ53O8Bi72Pko0mOIlxl6e8wCUHcuMo=;
        b=c/wlGidIaOiFmaIeIYa34mqPOP9ouH/T1bZS7CcW1LrvYbq7XkMnxGKS8ch9Hr0HkYv0AT
        I0ywnTGlJX3h0iGmKGwGQXfhiYZH/ZW8WKd95v/pEoWRHUtjQ6BXc/4t3+eLj/RkCQ9wGQ
        3hSHHVO6AkTI7bmZN0AUOKk1IGBC4DQ=
Content-Disposition: inline
In-Reply-To: <20220602192020.166940-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello.

On Thu, Jun 02, 2022 at 03:20:20PM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> As it is likely that not all the percpu blkg_iostat_set's has been
> updated since the last flush, those stale blkg_iostat_set's don't need
> to be flushed in this case.

Yes, there's no point to flush stats for idle devices if there can be
many of them. Good idea.

> +static struct llist_node *fetch_delete_blkcg_llist(struct llist_head *lhead)
> +{
> +	return xchg(&lhead->first, &llist_last);
> +}
> +
> +static struct llist_node *fetch_delete_lnode_next(struct llist_node *lnode)
> +{
> +	struct llist_node *next = READ_ONCE(lnode->next);
> +	struct blkcg_gq *blkg = llist_entry(lnode, struct blkg_iostat_set,
> +					    lnode)->blkg;
> +
> +	WRITE_ONCE(lnode->next, NULL);
> +	percpu_ref_put(&blkg->refcnt);
> +	return next;
> +}

Idea/just asking: would it make sense to generalize this into llist.c
(this is basically llist_del_first() + llist_del_all() with a sentinel)?
For the sake of reusability.

> +#define blkcg_llist_for_each_entry_safe(pos, node, nxt)			\
> +	for (; (node != &llist_last) &&					\
> +	       (pos = llist_entry(node, struct blkg_iostat_set, lnode),	\
> +		nxt = fetch_delete_lnode_next(node), true);		\
> +		node = nxt)
> +

It's good hygiene to parenthesize the args.

> @@ -2011,9 +2092,16 @@ void blk_cgroup_bio_start(struct bio *bio)
>  	}
>  	bis->cur.ios[rwd]++;
>  
> +	if (!READ_ONCE(bis->lnode.next)) {
> +		struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
> +
> +		llist_add(&bis->lnode, lhead);
> +		percpu_ref_get(&bis->blkg->refcnt);
> +	}
> +

When a blkg's cgroup is rmdir'd, what happens with the lhead list?
We have cgroup_rstat_exit() in css_free_rwork_fn() that ultimately flushes rstats.
init_and_link_css however adds reference form blkcg->css to cgroup->css.
The blkcg->css would be (transitively) pinned by the lhead list and
hence would prevent the final flush (when refs drop to zero). Seems like
a cyclic dependency.

Luckily, there's also per-subsys flushing in css_release which could be
moved after rmdir (offlining) but before last ref is gone:

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index adb820e98f24..d830e6a8fb3b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5165,11 +5165,6 @@ static void css_release_work_fn(struct work_struct *work)

        if (ss) {
                /* css release path */
-               if (!list_empty(&css->rstat_css_node)) {
-                       cgroup_rstat_flush(cgrp);
-                       list_del_rcu(&css->rstat_css_node);
-               }
-
                cgroup_idr_replace(&ss->css_idr, NULL, css->id);
                if (ss->css_released)
                        ss->css_released(css);
@@ -5279,6 +5274,11 @@ static void offline_css(struct cgroup_subsys_state *css)
        css->flags &= ~CSS_ONLINE;
        RCU_INIT_POINTER(css->cgroup->subsys[ss->id], NULL);

+       if (!list_empty(&css->rstat_css_node)) {
+               cgroup_rstat_flush(css->cgrp);
+               list_del_rcu(&css->rstat_css_node);
+       }
+
        wake_up_all(&css->cgroup->offline_waitq);
 }

(not tested)


>  	u64_stats_update_end_irqrestore(&bis->sync, flags);
>  	if (cgroup_subsys_on_dfl(io_cgrp_subsys))
> -		cgroup_rstat_updated(bio->bi_blkg->blkcg->css.cgroup, cpu);
> +		cgroup_rstat_updated(blkcg->css.cgroup, cpu);

Maybe bundle the lhead list maintenace with cgroup_rstat_updated() under
cgroup_subsys_on_dfl()? The stats can be read on v1 anyway.


Thanks,
Michal
