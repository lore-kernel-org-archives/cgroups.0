From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH v2 -mm 1/2] memcg: remove unused mem_cgroup->oom_wakeups
Date: Wed, 3 Jun 2015 22:31:48 +0200
Message-ID: <20150603203148.GA5386@dhcp22.suse.cz>
References: <20150603023824.GA7579@mtj.duckdns.org>
 <20150603151953.GF20091@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=M+q1IJ8C3DzcNJ+nlPm+bJXqw4yrKubG8LvfEEunQ6g=;
        b=oqVyG83R5K+KN47lpe9BxuTlJe/A09xdLgyIfU1KAWlsbYdiws5BCeKczQaHnpWtor
         Kybt15udVANn9Fw3wlI90QQj2MQ9IgDPObjKR62zdOhs4rfKSK/aWerHgD+t32zW7xnr
         ewIvC1d8+3fSfJZ6HeaDpcAJFhAj+uFDEV6PRxnA634irm2SLxfc6LfOimeb+xdIbd/r
         L1gXQu+qbM75nQB7i8OrjW6V3YTmqtAuwnZSyF8ipf5Wr2m/zVQwzihH5crC+k33aFnr
         tmS9qnEJfeSyqapJTrYdOLxS2Qqi6Vv+5ADLa8/Nju7pGdpZC6VnGHIoWiUplbISd72p
         XC+w==
Content-Disposition: inline
In-Reply-To: <20150603151953.GF20091@mtj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>

On Thu 04-06-15 00:19:53, Tejun Heo wrote:
> Since 4942642080ea ("mm: memcg: handle non-error OOM situations more
> gracefully"), nobody uses mem_cgroup->oom_wakeups.  Remove it.
> 
> While at it, also fold memcg_wakeup_oom() into memcg_oom_recover()
> which is its only user.  This cleanup was suggested by Michal.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Michal Hocko <mhocko@suse.cz>

Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!

> ---
> Patch updated.  I dropped the comment as it's kinda obvious from the
> context and the use of __wake_up().
> 
> Thanks.
> 
>  mm/memcontrol.c |   10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -287,7 +287,6 @@ struct mem_cgroup {
>  
>  	bool		oom_lock;
>  	atomic_t	under_oom;
> -	atomic_t	oom_wakeups;
>  
>  	int	swappiness;
>  	/* OOM-Killer disable */
> @@ -1850,17 +1849,10 @@ static int memcg_oom_wake_function(wait_
>  	return autoremove_wake_function(wait, mode, sync, arg);
>  }
>  
> -static void memcg_wakeup_oom(struct mem_cgroup *memcg)
> -{
> -	atomic_inc(&memcg->oom_wakeups);
> -	/* for filtering, pass "memcg" as argument. */
> -	__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
> -}
> -
>  static void memcg_oom_recover(struct mem_cgroup *memcg)
>  {
>  	if (memcg && atomic_read(&memcg->under_oom))
> -		memcg_wakeup_oom(memcg);
> +		__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
>  }
>  
>  static void mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
