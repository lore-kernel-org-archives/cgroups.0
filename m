From: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v5 08/31] list: add a new LRU list type
Date: Thu, 9 May 2013 14:37:42 +0100
Message-ID: <20130509133742.GW11497@suse.de>
References: <1368079608-5611-1-git-send-email-glommer@openvz.org>
 <1368079608-5611-9-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1368079608-5611-9-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, May 09, 2013 at 10:06:25AM +0400, Glauber Costa wrote:
> From: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Several subsystems use the same construct for LRU lists - a list
> head, a spin lock and and item count. They also use exactly the same
> code for adding and removing items from the LRU. Create a generic
> type for these LRU lists.
> 
> This is the beginning of generic, node aware LRUs for shrinkers to
> work with.
> 
> [ glommer: enum defined constants for lru. Suggested by gthelen,
>   don't relock over retry ]
> Signed-off-by: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> Reviewed-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > <SNIP>
> >
> +
> +unsigned long
> +list_lru_walk(
> +	struct list_lru *lru,
> +	list_lru_walk_cb isolate,
> +	void		*cb_arg,
> +	long		nr_to_walk)
> +{
> +	struct list_head *item, *n;
> +	unsigned long removed = 0;
> +
> +	spin_lock(&lru->lock);
> +restart:
> +	list_for_each_safe(item, n, &lru->list) {
> +		enum lru_status ret;
> +
> +		if (nr_to_walk-- < 0)
> +			break;
> +
> +		ret = isolate(item, &lru->lock, cb_arg);
> +		switch (ret) {
> +		case LRU_REMOVED:
> +			lru->nr_items--;
> +			removed++;
> +			break;
> +		case LRU_ROTATE:
> +			list_move_tail(item, &lru->list);
> +			break;
> +		case LRU_SKIP:
> +			break;
> +		case LRU_RETRY:
> +			goto restart;
> +		default:
> +			BUG();
> +		}
> +	}

What happened your suggestion to only retry once for each object to
avoid any possibility of infinite looping or stalling for prolonged
periods of time waiting on XFS to do something?

-- 
Mel Gorman
SUSE Labs
