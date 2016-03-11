From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: reclaim and OOM kill when shrinking
 memory.max below usage
Date: Fri, 11 Mar 2016 09:18:25 +0100
Message-ID: <20160311081825.GC27701@dhcp22.suse.cz>
References: <1457643015-8828-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457643015-8828-2-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu 10-03-16 15:50:14, Johannes Weiner wrote:
> Setting the original memory.limit_in_bytes hardlimit is subject to a
> race condition when the desired value is below the current usage. The
> code tries a few times to first reclaim and then see if the usage has
> dropped to where we would like it to be, but there is no locking, and
> the workload is free to continue making new charges up to the old
> limit. Thus, attempting to shrink a workload relies on pure luck and
> hope that the workload happens to cooperate.

OK this would be indeed a problem when you want to stop a runaway load.

> To fix this in the cgroup2 memory.max knob, do it the other way round:
> set the limit first, then try enforcement. And if reclaim is not able
> to succeed, trigger OOM kills in the group. Keep going until the new
> limit is met, we run out of OOM victims and there's only unreclaimable
> memory left, or the task writing to memory.max is killed. This allows
> users to shrink groups reliably, and the behavior is consistent with
> what happens when new charges are attempted in excess of memory.max.

Here as well. I think this should go into 4.5 final or later to stable
so that we do not have different behavior of the knob.
 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

One nit below

[...]
> @@ -5037,9 +5040,36 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
>  	if (err)
>  		return err;
>  
> -	err = mem_cgroup_resize_limit(memcg, max);
> -	if (err)
> -		return err;
> +	xchg(&memcg->memory.limit, max);
> +
> +	for (;;) {
> +		unsigned long nr_pages = page_counter_read(&memcg->memory);
> +
> +		if (nr_pages <= max)
> +			break;
> +
> +		if (signal_pending(current)) {

Didn't you want fatal_signal_pending here? At least the changelog
suggests that.

> +			err = -EINTR;
> +			break;
> +		}
-- 
Michal Hocko
SUSE Labs
