From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Patch v2 1/3] mm/memcg: mz already removed from rb_tree in
 mem_cgroup_largest_soft_limit_node()
Date: Mon, 14 Mar 2022 10:51:51 +0100
Message-ID: <Yi8QN+5oeUWWJQNv@dhcp22.suse.cz>
References: <20220312071623.19050-1-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647251511; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5NF6lNWwnFNh+7tS3faEIi4Qi8RnFVdFjDG/PzNtPM8=;
        b=bhZzDU7v8Wwu25jZoPgqNLGtwJacNFQr0K/jLRcYshdulVjtwHjNRf1zztlxnOmzoc07mJ
        W7vzaoVfXusWzd9iIBZ0J/Jl+L4G/3VfGPgdIGp+fT6zLiZ+Aj7HzzdBBUU9+rXzDfh536
        bWd6IahUctKWu9y+eoqGtn8hVAAhLJU=
Content-Disposition: inline
In-Reply-To: <20220312071623.19050-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sat 12-03-22 07:16:21, Wei Yang wrote:
> When mz is not NULL, mem_cgroup_largest_soft_limit_node() has removed
> it from rb_tree.
> 
> Not necessary to call __mem_cgroup_remove_exceeded() again.

Yes, the call seems to be unnecessary with the current code. mz can
either come from mem_cgroup_largest_soft_limit_node or
__mem_cgroup_largest_soft_limit_node both rely on the latter so the mz
is always off the tree indeed.
 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

After the changelog is completed you can add
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

In general, though, I am not a super fan of changes like these. The code
works as expected, the call for __mem_cgroup_remove_exceeded will not
really add much of an overhead and at least we can see that mz is always
removed before it is re-added back. In a hot path I would care much more
of course but this is effectivelly a dead code as the soft limit itself
is mostly a relict of past.

Please keep this in mind when you want to make further changes to this
area. The review is not free of cost and I am not sure spending time on
this area is worthwhile unless there is a real usecase in mind.

Thanks!

> ---
>  mm/memcontrol.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f898320b678a..d70bf5cf04eb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3458,7 +3458,6 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
>  		nr_reclaimed += reclaimed;
>  		*total_scanned += nr_scanned;
>  		spin_lock_irq(&mctz->lock);
> -		__mem_cgroup_remove_exceeded(mz, mctz);
>  
>  		/*
>  		 * If we failed to reclaim anything from this memory cgroup
> -- 
> 2.33.1

-- 
Michal Hocko
SUSE Labs
