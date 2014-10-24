From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [patch 2/3] mm: memcontrol: pull the NULL check from
 __mem_cgroup_same_or_subtree()
Date: Fri, 24 Oct 2014 18:49:03 +0400
Message-ID: <20141024144903.GB28055@esperanza>
References: <1414158589-26094-1-git-send-email-hannes@cmpxchg.org>
 <1414158589-26094-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414158589-26094-2-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Oct 24, 2014 at 09:49:48AM -0400, Johannes Weiner wrote:
> The NULL in mm_match_cgroup() comes from a possibly exiting mm->owner.
> It makes a lot more sense to check where it's looked up, rather than
> check for it in __mem_cgroup_same_or_subtree() where it's unexpected.
> 
> No other callsite passes NULL to __mem_cgroup_same_or_subtree().
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

> ---
>  include/linux/memcontrol.h | 5 +++--
>  mm/memcontrol.c            | 2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index ea007615e8f9..e32ab948f589 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -83,11 +83,12 @@ static inline
>  bool mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *memcg)
>  {
>  	struct mem_cgroup *task_memcg;
> -	bool match;
> +	bool match = false;
>  
>  	rcu_read_lock();
>  	task_memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
> -	match = __mem_cgroup_same_or_subtree(memcg, task_memcg);
> +	if (task_memcg)
> +		match = __mem_cgroup_same_or_subtree(memcg, task_memcg);
>  	rcu_read_unlock();
>  	return match;
>  }
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index bdf8520979cf..15b1c5110a8f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1316,7 +1316,7 @@ bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
>  {
>  	if (root_memcg == memcg)
>  		return true;
> -	if (!root_memcg->use_hierarchy || !memcg)
> +	if (!root_memcg->use_hierarchy)
>  		return false;
>  	return cgroup_is_descendant(memcg->css.cgroup, root_memcg->css.cgroup);
>  }
> -- 
> 2.1.2
> 
