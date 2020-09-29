From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] mm: memcontrol: remove obsolete comment of
 mem_cgroup_unmark_under_oom()
Date: Tue, 29 Sep 2020 16:29:20 +0200
Message-ID: <20200929142920.GD2277@dhcp22.suse.cz>
References: <20200917105900.4337-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601389762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AOGpyRKknUfTNLR63O/6b4t5RPaVPdINK6veOs+VSIU=;
        b=fqC5w0mGYUGWdzEzTR395xKj2x9qh6HvVHd4oGBOJ7uGMaPOeUX/r4shODLo/RhKO9zanx
        yZWgL9C8xkuQqNwg59h9utu8LiJ+6AoTqUVvuRE7tZPAbNjJfXLN3026zDdebCn2/OoXfi
        81PaOfxjt3EM0dwPGfJp0DnqMVPPe3U=
Content-Disposition: inline
In-Reply-To: <20200917105900.4337-1-linmiaohe@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu 17-09-20 06:59:00, Miaohe Lin wrote:
> Since commit 79dfdaccd1d5 ("memcg: make oom_lock 0 and 1 based rather than
> counter"), the mem_cgroup_unmark_under_oom() is added and the comment of
> the mem_cgroup_oom_unlock() is moved here. But this comment make no sense
> here because mem_cgroup_oom_lock() does not operate on under_oom field.

OK, so I've looked into this more deeply and I finally remember why we
have this comment here. The point is that under_oom shouldn't underflow
and that we have to explicitly check for > 0 because a new child memcg
could have been added between mem_cgroup_mark_under_oom and
mem_cgroup_unmark_under_oom.

So the comment makes sense although it is not as helpful as it could be.
I think that changing it to the following will be more usefule

	/*
	 * Be careful about under_oom underflows becase a child memcg
	 * could have neem added after mem_cgroup_mark_under_oom
	 */
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  mm/memcontrol.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index cd5f83de9a6f..e44f5afaf78b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1848,10 +1848,6 @@ static void mem_cgroup_unmark_under_oom(struct mem_cgroup *memcg)
>  {
>  	struct mem_cgroup *iter;
>  
> -	/*
> -	 * When a new child is created while the hierarchy is under oom,
> -	 * mem_cgroup_oom_lock() may not be called. Watch for underflow.
> -	 */
>  	spin_lock(&memcg_oom_lock);
>  	for_each_mem_cgroup_tree(iter, memcg)
>  		if (iter->under_oom > 0)
> -- 
> 2.19.1

-- 
Michal Hocko
SUSE Labs
