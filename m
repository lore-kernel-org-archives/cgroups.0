From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH][V2] mm: memcontrol: fix the margin computation in
 mem_cgroup_margin
Date: Wed, 25 May 2016 17:51:22 +0200
Message-ID: <20160525155122.GK20132@dhcp22.suse.cz>
References: <1464068266-27736-1-git-send-email-roy.qing.li@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464068266-27736-1-git-send-email-roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org

On Tue 24-05-16 13:37:46, roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> The margin may be set to the difference value between memory limit and
> memory count firstly. which maybe returned wrongly if memsw.count excess
> memsw.limit, because try_charge forces charging __GFP_NOFAIL allocations,
> which may result in memsw.limit excess. If we are below memory.limit
> and there's nothing to reclaim to reduce memsw.usage, might end up
> looping in try_charge forever.

This is quite hard for me to grasp. What would you say about the
following:
"
mem_cgroup_margin might return memory.limit - memory_count when
the memsw.limit is in excess. This
doesn't happen usually because we do not allow excess on hard limits and
memory.limit <= memsw.limit but __GFP_NOFAIL charges can force the charge
and cause the excess when no memory is really swapable (swap is full or
no anonymous memory is left).
"

> 
> Signed-off-by: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Acked-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 00981d2..12aaadd 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1090,6 +1090,8 @@ static unsigned long mem_cgroup_margin(struct mem_cgroup *memcg)
>  		limit = READ_ONCE(memcg->memsw.limit);
>  		if (count <= limit)
>  			margin = min(margin, limit - count);
> +		else
> +			margin = 0;
>  	}
>  
>  	return margin;
> -- 
> 2.1.4

-- 
Michal Hocko
SUSE Labs
