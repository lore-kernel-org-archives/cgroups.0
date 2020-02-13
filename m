From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] loop: charge i/o per cgroup
Date: Wed, 12 Feb 2020 19:07:54 -0500
Message-ID: <20200213000754.GD88887@mtj.thefacebook.com>
References: <20200205223348.880610-1-dschatzberg@fb.com>
 <20200205223348.880610-3-dschatzberg@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Xp7j+w+mSRWprEP7jKf4yInMPuuxYmE0Jx4GMGEDPCQ=;
        b=jmvVOhaXi+4hUwokVKiclEzfFZs0kumgKecddVwQJ6W4BYeb4eunfR42QH1BanKgXe
         MWQhbMX2xwNbvy0w6kTd2sh93gkpDWROStsMnfu41dD9mtVfKl5N/rEJCKmqqY4aoAcn
         kpev9dqGLS1dzO5YtQPFJGED458NEkCaq8BEWGqGQcyVhuH/okSHYJfODuu/8aZmP4cG
         C3ZXndp9Fcx2UthovyxMFXfFmE7hwC77Y/SZbgnh3Ul4OJATixPYCRxJfupisKXfC2C1
         oGZSd76/0NwAuj1H3V+4klnwdDUYqolEtgnvSXfBSw3iRwkHKOmYNLCadx1UHUFV8fTN
         Nsbw==
Content-Disposition: inline
In-Reply-To: <20200205223348.880610-3-dschatzberg-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <dschatzberg-b10kYP2dOMg@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

Hello,

On Wed, Feb 05, 2020 at 02:33:48PM -0800, Dan Schatzberg wrote:
> -static int loop_kthread_worker_fn(void *worker_ptr)
> -{
> -	current->flags |= PF_LESS_THROTTLE | PF_MEMALLOC_NOIO;
> -	return kthread_worker_fn(worker_ptr);
> +	flush_workqueue(lo->workqueue);
> +	destroy_workqueue(lo->workqueue);

destroy_workqueue() implies draining, so the explicit flush isn't
necessary.

>  static int loop_prepare_queue(struct loop_device *lo)
>  {
> +	lo->workqueue = alloc_workqueue("loop%d",
> +					WQ_FREEZABLE | WQ_MEM_RECLAIM |
> +					WQ_HIGHPRI,
> +					lo->lo_number);
> +	if (IS_ERR(lo->workqueue))
>  		return -ENOMEM;

Given that these can be pretty cpu intensive and a single work item
can be saturated by multiple cpus keepings queueing bios, it probably
would be better to use an unbound workqueue (WQ_UNBOUND) and let the
scheduler figure out.

> +struct loop_worker {
> +	struct rb_node rb_node;
> +	struct work_struct work;
> +	struct list_head cmd_list;
> +	struct loop_device *lo;
> +	int css_id;
> +};
> +
> +static void loop_workfn(struct work_struct *work);
> +static void loop_rootcg_workfn(struct work_struct *work);
> +
> +static void loop_queue_on_rootcg_locked(struct loop_device *lo,
> +					struct loop_cmd *cmd)
> +{

lockdep_assert_held() here?

> +	list_add_tail(&cmd->list_entry, &lo->rootcg_cmd_list);
> +	if (list_is_first(&cmd->list_entry, &lo->rootcg_cmd_list))
> +		queue_work(lo->workqueue, &lo->rootcg_work);

I'd just call queue_work() without the preceding check. Trying to
requeue an active work item is pretty cheap.

> +}
> +
> +static void loop_queue_work(struct loop_device *lo, struct loop_cmd *cmd)
> +{
> +	struct rb_node **node = &(lo->worker_tree.rb_node), *parent = NULL;
                                 ^
                                 This isn't necessary, right?

> +	struct loop_worker *cur_worker, *worker = NULL;
> +	int css_id = 0;
> +
> +	if (cmd->blk_css)

We usually use blkcg_css as the name.

> +		css_id = cmd->blk_css->id;
> +
> +	spin_lock_irq(&lo->lo_lock);
> +
> +	if (!css_id) {
> +		loop_queue_on_rootcg_locked(lo, cmd);
> +		goto out;
> +	}
> +	node = &(lo->worker_tree.rb_node);
> +
> +	while (*node) {
> +		parent = *node;
> +		cur_worker = container_of(*node, struct loop_worker, rb_node);
> +		if (cur_worker->css_id == css_id) {
> +			worker = cur_worker;
> +			break;
> +		} else if (cur_worker->css_id < 0) {
> +			node = &((*node)->rb_left);
                                 ^
                                I'd keep only the inner parentheses.

> +		} else {
> +			node = &((*node)->rb_right);
> +		}
> +	}
> +	if (worker) {
> +		list_add_tail(&cmd->list_entry, &worker->cmd_list);

Maybe goto and unindent else block?

> +	} else {
> +		worker = kmalloc(sizeof(struct loop_worker), GFP_NOIO);

I think the gpf flag combo you wanna use is GFP_NOWAIT | __GFP_NOWARN
- we don't wanna enter direct reclaim from here or generate warnings.
Also, I personally tend to use kzalloc() for small stuff by default as
it doesn't really cost anything while making things easier / safer
later when adding new fields, but up to you.

> +		/*
> +		 * In the event we cannot allocate a worker, just
> +		 * queue on the rootcg worker
> +		 */
> +		if (!worker) {
> +			loop_queue_on_rootcg_locked(lo, cmd);
> +			goto out;
> +		}
> +		worker->css_id = css_id;

Maybe blkcg_css_id would be clearer? Your call for sure tho.

> +		INIT_WORK(&worker->work, loop_workfn);
> +		INIT_LIST_HEAD(&worker->cmd_list);
> +		worker->lo = lo;
> +		rb_link_node(&worker->rb_node, parent, node);
> +		rb_insert_color(&worker->rb_node, &lo->worker_tree);
> +		list_add_tail(&cmd->list_entry, &worker->cmd_list);
> +		queue_work(lo->workqueue, &worker->work);

It might be better to share the above two lines between existing and
new worker paths. I think you're missing queue_work() for the former.

> @@ -1942,6 +2006,9 @@ static void loop_handle_cmd(struct loop_cmd *cmd)
>  	struct request *rq = blk_mq_rq_from_pdu(cmd);
>  	const bool write = op_is_write(req_op(rq));
>  	struct loop_device *lo = rq->q->queuedata;
> +#ifdef CONFIG_MEMCG
> +	struct cgroup_subsys_state *mem_css;

memcg_css is what we've been using; however, I kinda like blk/mem_css.
Maybe we should rename the others. Please feel free to leave as-is.

> @@ -1958,26 +2041,50 @@ static void loop_handle_cmd(struct loop_cmd *cmd)
>  	}
>  }
>  
> +static void loop_process_work(struct loop_worker *worker,
> +			struct list_head *cmd_list, struct loop_device *lo)
>  {
> +	int orig_flags = current->flags;
> +	struct loop_cmd *cmd;
> +
> +	while (1) {
> +		spin_lock_irq(&lo->lo_lock);
> +		if (list_empty(cmd_list)) {

Maybe break here and cleanup at the end of the function?

> +			if (worker)
> +				rb_erase(&worker->rb_node, &lo->worker_tree);
> +			spin_unlock_irq(&lo->lo_lock);
> +			kfree(worker);
> +			current->flags = orig_flags;

I wonder whether we wanna keep them around for a bit. A lot of IO
patterns involve brief think times between accesses and this would be
constantly creating and destroying constantly.

> +			return;
> +		}
>  
> +		cmd = container_of(
> +			cmd_list->next, struct loop_cmd, list_entry);
> +		list_del(cmd_list->next);
> +		spin_unlock_irq(&lo->lo_lock);
> +		current->flags |= PF_LESS_THROTTLE | PF_MEMALLOC_NOIO;

I think we can set this at the head of the function and

> +		loop_handle_cmd(cmd);
> +		current->flags = orig_flags;

restore them before returning.

> @@ -587,6 +587,7 @@ struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgrp,
>  	rcu_read_unlock();
>  	return css;
>  }
> +EXPORT_SYMBOL_GPL(cgroup_get_e_css);

Can you please mention the above in the changelog? Also, it'd be great
to have rationales there too.

Thanks.

-- 
tejun
