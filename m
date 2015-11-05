From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 4/4] memcg: always enable kmemcg on the default hierarchy
Date: Thu, 5 Nov 2015 18:30:27 +0100
Message-ID: <20151105173027.GE15111@dhcp22.suse.cz>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1440775530-18630-5-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-mm@kvack.org, vdavydov@parallels.com, kernel-team@fb.com

Just for the reference. This has been discussed as a part of other email
thread discussed here:
http://lkml.kernel.org/r/20151027122647.GG9891%40dhcp22.suse.cz

I am _really_ sorry for hijacking that one - I didn't intend to do
so but my remark ended up in a full discussion. If I knew it would go
that way I wouldn't even mention it.

On Fri 28-08-15 11:25:30, Tejun Heo wrote:
> On the default hierarchy, all memory consumption will be accounted
> together and controlled by the same set of limits.  Always enable
> kmemcg on the default hierarchy.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  mm/memcontrol.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c94b686..8a5dd01 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4362,6 +4362,13 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  	if (ret)
>  		return ret;
>  
> +	/* kmem is always accounted together on the default hierarchy */
> +	if (cgroup_on_dfl(css->cgroup)) {
> +		ret = memcg_activate_kmem(memcg, PAGE_COUNTER_MAX);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	/*
>  	 * Make sure the memcg is initialized: mem_cgroup_iter()
>  	 * orders reading memcg->initialized against its callers
> -- 
> 2.4.3

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
