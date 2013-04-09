From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 3/8] memcg: convert to use cgroup_is_ancestor()
Date: Tue, 9 Apr 2013 08:49:34 +0200
Message-ID: <20130409064934.GA30386@dhcp22.suse.cz>
References: <51627DA9.7020507@huawei.com>
 <51627DFA.9050007@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51627DFA.9050007-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon 08-04-13 16:21:14, Li Zefan wrote:
> This is a preparation to kill css_id.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5aa6e91..14f1375 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1383,7 +1383,7 @@ bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
>  		return true;
>  	if (!root_memcg->use_hierarchy || !memcg)
>  		return false;
> -	return css_is_ancestor(&memcg->css, &root_memcg->css);
> +	return cgroup_is_ancestor(memcg->css.cgroup, root_memcg->css.cgroup);
>  }
>  
>  static bool mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
> -- 
> 1.8.0.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
