From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 23/24] cfq-iosched: collect stats from dead cfqgs
Date: Wed, 2 Jan 2013 11:24:15 -0500
Message-ID: <20130102162415.GA4306@redhat.com>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-24-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1356726946-26037-24-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Fri, Dec 28, 2012 at 12:35:45PM -0800, Tejun Heo wrote:
> To support hierarchical stats, it's necessary to remember stats from
> dead children.  Add cfqg->dead_stats and make a dying cfqg transfer
> its stats to the parent's dead-stats.

Hi Tejun,

Why not directly transfer stats to cfqg->stats. IOW, what's the advantage
of maintaining dead_stats separately.

[..]
> + * Transfer @cfqg's stats to its parent's dead_stats so that the ancestors'
> + * recursive stats can still account for the amount used by this cfqg after
> + * it's gone.
> + */
> +static void cfqg_stats_xfer_dead(struct cfq_group *cfqg)
> +{
> +	struct cfq_group *parent = cfqg_parent(cfqg);
> +
> +	lockdep_assert_held(cfqg_to_blkg(cfqg)->q->queue_lock);
> +
> +	if (unlikely(!parent))
> +		return;
> +
> +	cfqg_stats_merge(&parent->dead_stats, &cfqg->stats);
> +	cfqg_stats_merge(&parent->dead_stats, &cfqg->dead_stats);
> +	cfqg_stats_reset(&cfqg->stats);
> +	cfqg_stats_reset(&cfqg->dead_stats);

Anyway group will be marked offline and later freed. So resetting stats
might not be required.

In fact if we have a realiable way of resetting status then online/offline
infrastructure might not be required? I think per cpu stats will be a
problem though and that's why we probably require logic to online/offline
the group?

Thanks
Vivek
