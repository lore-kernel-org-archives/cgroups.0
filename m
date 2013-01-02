From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 21/24] blkcg: make blkcg_print_blkgs() grab q locks
 instead of blkcg lock
Date: Wed, 2 Jan 2013 14:27:00 -0500
Message-ID: <20130102192700.GA9552@redhat.com>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-22-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1356726946-26037-22-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Fri, Dec 28, 2012 at 12:35:43PM -0800, Tejun Heo wrote:
> Instead of holding blkcg->lock while walking ->blkg_list and executing
> prfill(), RCU walk ->blkg_list and hold the blkg's queue lock while
> executing prfill().  This makes prfill() implementations easier as
> stats are mostly protected by queue lock.
> 
> This will be used to implement hierarchical stats.
> 

Hi Tejun,

I think dropping blkcg->lock might be a problem. Using RCU we have made
sure that blkg and q are around. But what about blkg->q.backing_dev_info.dev.

We can follow bdi->dev pointer in blkg_dev_name(). I am not sure if we
ever clear it from q or not when device goes away.

Thanks
Vivek

> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  block/blk-cgroup.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index a1a4b97..22f75d1 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -504,8 +504,9 @@ static const char *blkg_dev_name(struct blkcg_gq *blkg)
>   *
>   * This function invokes @prfill on each blkg of @blkcg if pd for the
>   * policy specified by @pol exists.  @prfill is invoked with @sf, the
> - * policy data and @data.  If @show_total is %true, the sum of the return
> - * values from @prfill is printed with "Total" label at the end.
> + * policy data and @data and the matching queue lock held.  If @show_total
> + * is %true, the sum of the return values from @prfill is printed with
> + * "Total" label at the end.
>   *
>   * This is to be used to construct print functions for
>   * cftype->read_seq_string method.
> @@ -520,11 +521,14 @@ void blkcg_print_blkgs(struct seq_file *sf, struct blkcg *blkcg,
>  	struct hlist_node *n;
>  	u64 total = 0;
>  
> -	spin_lock_irq(&blkcg->lock);
> -	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node)
> +	rcu_read_lock();
> +	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {
> +		spin_lock_irq(blkg->q->queue_lock);
>  		if (blkcg_policy_enabled(blkg->q, pol))
>  			total += prfill(sf, blkg->pd[pol->plid], data);
> -	spin_unlock_irq(&blkcg->lock);
> +		spin_unlock_irq(blkg->q->queue_lock);
> +	}
> +	rcu_read_unlock();
>  
>  	if (show_total)
>  		seq_printf(sf, "Total %llu\n", (unsigned long long)total);
> -- 
> 1.8.0.2
