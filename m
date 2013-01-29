From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 6/6] memcg: init/free swap cgroup strucutres upon
 create/free child memcg
Date: Tue, 29 Jan 2013 16:11:50 +0100
Message-ID: <20130129151150.GH29574@dhcp22.suse.cz>
References: <510658E3.1020306@oracle.com>
 <510658FC.50009@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <510658FC.50009-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 28-01-13 18:54:52, Jeff Liu wrote:
> Initialize swap_cgroup strucutres when creating a non-root memcg,
> swap_cgroup_init() will be called for multiple times but only does
> buffer allocation per the first non-root memcg.
> 
> Free swap_cgroup structures correspondingly on the last non-root memcg
> removal.
> 
> Signed-off-by: Jie Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> CC: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> CC: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

OK, looks good to me. Except for the outdated tree you are based on.
You should hook into mem_cgroup_css_online for the creation path.

Please fold this into the previous patch. It won't make it harder to
review and we will have all users of init/free in one patch.

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> ---
>  mm/memcontrol.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index afe5e86..031d242 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5998,6 +5998,7 @@ static void free_work(struct work_struct *work)
>  
>  	memcg = container_of(work, struct mem_cgroup, work_freeing);
>  	__mem_cgroup_free(memcg);
> +	swap_cgroup_free();
>  }
>  
>  static void free_rcu(struct rcu_head *rcu_head)
> @@ -6116,6 +6117,8 @@ mem_cgroup_css_alloc(struct cgroup *cont)
>  			INIT_WORK(&stock->work, drain_local_stock);
>  		}
>  	} else {
> +		if (swap_cgroup_init())
> +			goto free_out;
>  		parent = mem_cgroup_from_cont(cont->parent);
>  		memcg->use_hierarchy = parent->use_hierarchy;
>  		memcg->oom_kill_disable = parent->oom_kill_disable;
> -- 
> 1.7.9.5

-- 
Michal Hocko
SUSE Labs
