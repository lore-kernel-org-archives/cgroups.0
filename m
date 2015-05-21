From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 3/7] memcg: immigrate charges only when a threadgroup
 leader is moved
Date: Thu, 21 May 2015 16:12:26 +0200
Message-ID: <20150521141225.GB14475@dhcp22.suse.cz>
References: <1431978595-12176-1-git-send-email-tj@kernel.org>
 <1431978595-12176-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1431978595-12176-4-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon 18-05-15 15:49:51, Tejun Heo wrote:
> If move_charge flag is set, memcg tries to move memory charges to the
> destnation css.  The current implementation migrates memory whenever
> any thread of a process is migrated making the behavior somewhat
> arbitrary.  Let's tie memory operations to the threadgroup leader so
> that memory is migrated only when the leader is migrated.
> 
> While this is a behavior change, given the inherent fuziness, this
> change is not too likely to be noticed and allows us to clearly define
> who owns the memory (always the leader) and helps the planned atomic
> multi-process migration.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

OK, I guess the discussion with Oleg confirmed that the patch is not
really needed because mm_struct->owner check implies thread group
leader. This should be sufficient for your purpose Tejun, right?

> ---
>  mm/memcontrol.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b1b834d..74fcea3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5014,6 +5014,9 @@ static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
>  		return 0;
>  
>  	p = cgroup_taskset_first(tset);
> +	if (!thread_group_leader(p))
> +		return 0;
> +
>  	from = mem_cgroup_from_task(p);
>  
>  	VM_BUG_ON(from == memcg);
> -- 
> 2.4.0
> 

-- 
Michal Hocko
SUSE Labs
