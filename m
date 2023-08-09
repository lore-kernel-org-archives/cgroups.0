From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Wed, 9 Aug 2023 10:51:13 +0200
Message-ID: <ZNNTgZVPZipTL/UM@dhcp22.suse.cz>
References: <20230809045810.1659356-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1691571073; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FNFE+i+WwtgcHn5Rj+LGuGTsx7FtrFv3sviTgeepiYo=;
        b=qnZnaGnS4J4MTbOYIfnDmj0JDfOtjkYuNESsya/JKY/fC0CJea40S3ZNfi5BL2ROwQ99Yo
        A+Kqlj/kNqEaQ99nNFSp2J0jViYuoMPjBWN7zmPu6XUws9D0aQ9un1VhrKrqFlaPndu73+
        +ZNVOAqk0JnQiUgLgxo9m+62w5cHj/8=
Content-Disposition: inline
In-Reply-To: <20230809045810.1659356-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 09-08-23 04:58:10, Yosry Ahmed wrote:
> Over time, the memcg code added multiple optimizations to the stats
> flushing path that introduce a tradeoff between accuracy and
> performance. In some contexts (e.g. dirty throttling, refaults, etc), a
> full rstat flush of the stats in the tree can be too expensive. Such
> optimizations include [1]:
> (a) Introducing a periodic background flusher to keep the size of the
> update tree from growing unbounded.
> (b) Allowing only one thread to flush at a time, and other concurrent
> flushers just skip the flush. This avoids a thundering herd problem
> when multiple reclaim/refault threads attempt to flush the stats at
> once.
> (c) Only executing a flush if the magnitude of the stats updates exceeds
> a certain threshold.
> 
> These optimizations were necessary to make flushing feasible in
> performance-critical paths, and they come at the cost of some accuracy
> that we choose to live without. On the other hand, for flushes invoked
> when userspace is reading the stats, the tradeoff is less appealing
> This code path is not performance-critical, and the inaccuracies can
> affect userspace behavior. For example, skipping flushing when there is
> another ongoing flush is essentially a coin flip. We don't know if the
> ongoing flush is done with the subtree of interest or not.

I am not convinced by this much TBH. What kind of precision do you
really need and how much off is what we provide?

More expensive read of stats from userspace is quite easy to notice
and usually reported as a regression. So you should have a convincing
argument that an extra time spent is really worth it. AFAIK there are
many monitoring (top like) tools which simply read those files regularly
just to show numbers and they certainly do not need a high level of
precision.

[...]
> @@ -639,17 +639,24 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
>  	}
>  }
>  
> -static void do_flush_stats(void)
> +static void do_flush_stats(bool full)
>  {
> +	if (!atomic_read(&stats_flush_ongoing) &&
> +	    !atomic_xchg(&stats_flush_ongoing, 1))
> +		goto flush;
> +
>  	/*
> -	 * We always flush the entire tree, so concurrent flushers can just
> -	 * skip. This avoids a thundering herd problem on the rstat global lock
> -	 * from memcg flushers (e.g. reclaim, refault, etc).
> +	 * We always flush the entire tree, so concurrent flushers can choose to
> +	 * skip if accuracy is not critical. Otherwise, wait for the ongoing
> +	 * flush to complete. This avoids a thundering herd problem on the rstat
> +	 * global lock from memcg flushers (e.g. reclaim, refault, etc).
>  	 */
> -	if (atomic_read(&stats_flush_ongoing) ||
> -	    atomic_xchg(&stats_flush_ongoing, 1))
> -		return;
> -
> +	while (full && atomic_read(&stats_flush_ongoing) == 1) {
> +		if (!cond_resched())
> +			cpu_relax();

You are reinveting a mutex with spinning waiter. Why don't you simply
make stats_flush_ongoing a real mutex and make use try_lock for !full
flush and normal lock otherwise?

> +	}
> +	return;
> +flush:
>  	WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
>  
>  	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
[...]
-- 
Michal Hocko
SUSE Labs
