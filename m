From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg: fast hierarchy-aware child test fix
Date: Wed, 13 Feb 2013 19:42:21 +0900
Message-ID: <511B6E0D.3030703@jp.fujitsu.com>
References: <1360569889-843-1-git-send-email-glommer@parallels.com> <1360569889-843-2-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360569889-843-2-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

(2013/02/11 17:04), Glauber Costa wrote:
> ---
>   mm/memcontrol.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 25ac5f4..28252c9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5883,8 +5883,7 @@ static int mem_cgroup_oom_control_write(struct cgroup *cgrp,
>   
>   	mutex_lock(&memcg_create_mutex);
>   	/* oom-kill-disable is a flag for subhierarchy. */
> -	if ((parent->use_hierarchy) ||
> -	    (memcg->use_hierarchy && !list_empty(&cgrp->children))) {
> +	if ((parent->use_hierarchy) || memcg_has_children(memcg)) {
>   		cgroup_unlock();
>   		return -EINVAL;
>   	}
> 

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
