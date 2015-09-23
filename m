From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: remove pcp_counter_lock
Date: Wed, 23 Sep 2015 09:45:19 +0200
Message-ID: <20150923074518.GC6283@dhcp22.suse.cz>
References: <1442976106-49685-1-git-send-email-gthelen@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1442976106-49685-1-git-send-email-gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue 22-09-15 19:41:46, Greg Thelen wrote:
> Commit 733a572e66d2 ("memcg: make mem_cgroup_read_{stat|event}() iterate
> possible cpus instead of online") removed the last use of the per memcg
> pcp_counter_lock but forgot to remove the variable.
> 
> Kill the vestigial variable.
> 
> Signed-off-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  include/linux/memcontrol.h | 1 -
>  mm/memcontrol.c            | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index ad800e62cb7a..6452ff4c463f 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -242,7 +242,6 @@ struct mem_cgroup {
>  	 * percpu counter.
>  	 */
>  	struct mem_cgroup_stat_cpu __percpu *stat;
> -	spinlock_t pcp_counter_lock;
>  
>  #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
>  	struct cg_proto tcp_mem;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6ddaeba34e09..da21143550c0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4179,7 +4179,6 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
>  	if (memcg_wb_domain_init(memcg, GFP_KERNEL))
>  		goto out_free_stat;
>  
> -	spin_lock_init(&memcg->pcp_counter_lock);
>  	return memcg;
>  
>  out_free_stat:
> -- 
> 2.6.0.rc0.131.gf624c3d

-- 
Michal Hocko
SUSE Labs
