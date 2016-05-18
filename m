From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix the return in mem_cgroup_margin
Date: Wed, 18 May 2016 09:32:53 +0200
Message-ID: <20160518073253.GC21654@dhcp22.suse.cz>
References: <1463556255-31892-1-git-send-email-roy.qing.li@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1463556255-31892-1-git-send-email-roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org

On Wed 18-05-16 15:24:15, roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> when memory+swap is over limit, return 0
> 
> Signed-off-by: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  mm/memcontrol.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index fe787f5..e9211c2 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1090,6 +1090,8 @@ static unsigned long mem_cgroup_margin(struct mem_cgroup *memcg)
>  		limit = READ_ONCE(memcg->memsw.limit);
>  		if (count <= limit)
>  			margin = min(margin, limit - count);
> +		else
> +			margin = 0;

count should always be smaller than memsw.limit (this is a hard limit).
Even if we have some temporary breach then the code should work as
expected because margin is initialized to 0 and memsw.limit >= limit.

Or have you seen any real problem with this code path?

-- 
Michal Hocko
SUSE Labs
