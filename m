From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg, kmem: clean up reference count handling on
 the error path
Date: Wed, 3 Apr 2013 11:48:53 +0200
Message-ID: <20130403094853.GG16471@dhcp22.suse.cz>
References: <20130403085056.GD14384@dhcp22.suse.cz>
 <1364979234-16427-1-git-send-email-mhocko@suse.cz>
 <1364979234-16427-2-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1364979234-16427-2-git-send-email-mhocko-AlSwsSmVLrQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 03-04-13 10:53:54, Michal Hocko wrote:
> mem_cgroup_css_online calls mem_cgroup_put if memcg_init_kmem
> fails. This is not correct because only memcg_propagate_kmem takes an
> additional reference while mem_cgroup_sockets_init is allowed to fail as
> well (although no current implementation fails) but it doesn't take any
> reference. This all suggests that it should be memcg_propagate_kmem that
> should clean up after itself so this patch moves mem_cgroup_put over
> there.
> Unfortunately this is not that easy (as pointed out by Li Zefan) because
> memcg_kmem_mark_dead marks the group dead (KMEM_ACCOUNTED_DEAD) if it
> is marked active (KMEM_ACCOUNTED_ACTIVE) which is the case even if
> memcg_propagate_kmem fails so the additional reference is dropped in
> that case in kmem_cgroup_destroy which means that the reference would be
> dropped two times.
> 
> The easiest way then would be to simply remove mem_cgrroup_put from
> mem_cgroup_css_online and rely on kmem_cgroup_destroy doing the right
> thing.

Forgot to mention that this one could be marked for stable for 3.8

> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> ---
>  mm/memcontrol.c |    8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6de6d70..65b2850 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6417,14 +6417,6 @@ mem_cgroup_css_online(struct cgroup *cont)
>  
>  	error = memcg_init_kmem(memcg, &mem_cgroup_subsys);
>  	mutex_unlock(&memcg_create_mutex);
> -	if (error) {
> -		/*
> -		 * We call put now because our (and parent's) refcnts
> -		 * are already in place. mem_cgroup_put() will internally
> -		 * call __mem_cgroup_free, so return directly
> -		 */
> -		mem_cgroup_put(memcg);
> -	}
>  	return error;
>  }
>  
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Michal Hocko
SUSE Labs
