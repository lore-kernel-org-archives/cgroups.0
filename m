From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: lost css_put in memcg_expand_shrinker_maps()
Date: Tue, 11 Feb 2020 15:01:47 +0100
Message-ID: <20200211135322.GO10636@dhcp22.suse.cz>
References: <c98414fb-7e1f-da0f-867a-9340ec4bd30b@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c98414fb-7e1f-da0f-867a-9340ec4bd30b-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue 11-02-20 14:20:10, Vasily Averin wrote:
> for_each_mem_cgroup() increases css reference counter for memory cgroup
> and requires to use mem_cgroup_iter_break() if the walk is cancelled.
> 
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Fixes commit 0a4465d34028("mm, memcg: assign memcg-aware shrinkers bitmap to memcg")

Fixes: 0a4465d34028("mm, memcg: assign memcg-aware shrinkers bitmap to memcg")

Is the usual format.
 
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> ---
>  mm/memcontrol.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6c83cf4..e2da615 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -409,8 +409,10 @@ int memcg_expand_shrinker_maps(int new_id)
>  		if (mem_cgroup_is_root(memcg))
>  			continue;
>  		ret = memcg_expand_one_shrinker_map(memcg, size, old_size);
> -		if (ret)
> +		if (ret) {
> +			mem_cgroup_iter_break(NULL, memcg);
>  			goto unlock;
> +		}
>  	}
>  unlock:
>  	if (!ret)
> -- 
> 1.8.3.1

-- 
Michal Hocko
SUSE Labs
