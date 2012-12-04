From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 2/4] memcg: prevent changes to move_charge_at_immigrate
 during task attach
Date: Tue, 4 Dec 2012 10:29:41 +0100
Message-ID: <20121204092941.GH31319@dhcp22.suse.cz>
References: <1354282286-32278-1-git-send-email-glommer@parallels.com>
 <1354282286-32278-3-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1354282286-32278-3-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Fri 30-11-12 17:31:24, Glauber Costa wrote:
> Currently, we rely on the cgroup_lock() to prevent changes to
> move_charge_at_immigrate during task migration. We can do something
> similar to what cpuset is doing, and flip a flag to tell us if task
> movement is taking place.
> 
> In theory, we could busy loop waiting for that value to return to 0 - it
> will eventually. But I am judging that returning EAGAIN is not too much
> of a problem, since file writers already should be checking for error
> codes anyway.

I think we should prevent from EAGAIN because this is a behavior change.
Why not just loop with signal_pending test for breaking out and a small
sleep after attach_in_progress > 0 && unlock?

> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> ---
>  mm/memcontrol.c | 64 +++++++++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 51 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index feba87d..d80b6b5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -311,7 +311,13 @@ struct mem_cgroup {
>  	 * Should we move charges of a task when a task is moved into this
>  	 * mem_cgroup ? And what type of charges should we move ?
>  	 */
> -	unsigned long 	move_charge_at_immigrate;
> +	unsigned long	move_charge_at_immigrate;
> +        /*
> +	 * Tasks are being attached to this memcg.  Used mostly to prevent
> +	 * changes to move_charge_at_immigrate
> +	 */
> +        int attach_in_progress;
> +
>  	/*
>  	 * set > 0 if pages under this cgroup are moving to other cgroup.
>  	 */
> @@ -4114,6 +4120,7 @@ static int mem_cgroup_move_charge_write(struct cgroup *cgrp,
>  					struct cftype *cft, u64 val)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
> +	int ret = -EAGAIN;
>  
>  	if (val >= (1 << NR_MOVE_TYPE))
>  		return -EINVAL;
> @@ -4123,10 +4130,13 @@ static int mem_cgroup_move_charge_write(struct cgroup *cgrp,
>  	 * inconsistent.
>  	 */
>  	cgroup_lock();
> +	if (memcg->attach_in_progress)
> +		goto out;
>  	memcg->move_charge_at_immigrate = val;
> +	ret = 0;
> +out:
>  	cgroup_unlock();
> -
> -	return 0;
> +	return ret;
>  }
>  #else
>  static int mem_cgroup_move_charge_write(struct cgroup *cgrp,
> @@ -5443,12 +5453,12 @@ static void mem_cgroup_clear_mc(void)
>  	mem_cgroup_end_move(from);
>  }
>  
> -static int mem_cgroup_can_attach(struct cgroup *cgroup,
> -				 struct cgroup_taskset *tset)
> +
> +static int __mem_cgroup_can_attach(struct mem_cgroup *memcg,
> +				   struct cgroup_taskset *tset)
>  {
>  	struct task_struct *p = cgroup_taskset_first(tset);
>  	int ret = 0;
> -	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgroup);
>  
>  	if (memcg->move_charge_at_immigrate) {
>  		struct mm_struct *mm;
> @@ -5482,8 +5492,8 @@ static int mem_cgroup_can_attach(struct cgroup *cgroup,
>  	return ret;
>  }
>  
> -static void mem_cgroup_cancel_attach(struct cgroup *cgroup,
> -				     struct cgroup_taskset *tset)
> +static void __mem_cgroup_cancel_attach(struct mem_cgroup *memcg,
> +				       struct cgroup_taskset *tset)
>  {
>  	mem_cgroup_clear_mc();
>  }
> @@ -5630,8 +5640,8 @@ retry:
>  	up_read(&mm->mmap_sem);
>  }
>  
> -static void mem_cgroup_move_task(struct cgroup *cont,
> -				 struct cgroup_taskset *tset)
> +static void __mem_cgroup_move_task(struct mem_cgroup *memcg,
> +				   struct cgroup_taskset *tset)
>  {
>  	struct task_struct *p = cgroup_taskset_first(tset);
>  	struct mm_struct *mm = get_task_mm(p);
> @@ -5645,20 +5655,48 @@ static void mem_cgroup_move_task(struct cgroup *cont,
>  		mem_cgroup_clear_mc();
>  }
>  #else	/* !CONFIG_MMU */
> +static int __mem_cgroup_can_attach(struct mem_cgroup *memcg,
> +				   struct cgroup_taskset *tset)
> +{
> +	return 0;
> +}
> +
> +static void __mem_cgroup_cancel_attach(struct mem_cgroup *memcg,
> +				       struct cgroup_taskset *tset)
> +{
> +}
> +
> +static void __mem_cgroup_move_task(struct mem_cgroup *memcg,
> +				   struct cgroup_taskset *tset)
> +{
> +}
> +#endif
>  static int mem_cgroup_can_attach(struct cgroup *cgroup,
>  				 struct cgroup_taskset *tset)
>  {
> -	return 0;
> +	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgroup);
> +
> +	memcg->attach_in_progress++;
> +	return __mem_cgroup_can_attach(memcg, tset);
>  }
> +
>  static void mem_cgroup_cancel_attach(struct cgroup *cgroup,
>  				     struct cgroup_taskset *tset)
>  {
> +	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgroup);
> +
> +	__mem_cgroup_cancel_attach(memcg, tset);
> +	memcg->attach_in_progress--;
>  }
> -static void mem_cgroup_move_task(struct cgroup *cont,
> +
> +static void mem_cgroup_move_task(struct cgroup *cgroup,
>  				 struct cgroup_taskset *tset)
>  {
> +	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgroup);
> +
> +	__mem_cgroup_move_task(memcg, tset);
> +	memcg->attach_in_progress--;
>  }
> -#endif
>  
>  struct cgroup_subsys mem_cgroup_subsys = {
>  	.name = "memory",
> -- 
> 1.7.11.7
> 

-- 
Michal Hocko
SUSE Labs
