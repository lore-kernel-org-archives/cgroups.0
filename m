From: Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v10 3/8] cgroup/cpuset: Allow no-task partition to have
 empty cpuset.cpus.effective
Date: Tue, 3 May 2022 13:54:54 -0400
Message-ID: <20220503175454.GA20433@pauld.bos.csb>
References: <20220503162149.1764245-1-longman@redhat.com>
 <20220503162149.1764245-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651600505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Je4rn7G/LwkMCFWNVtNLjHOUiippvzmAhvZ4OuAGWzI=;
        b=hBWOVUGd6CJk4KapBCVjaQCPfKVN97Fb7/nJliJqilxH0IiF65TB27bFb/hI640JKGE9Hc
        kXxSSWQyzIvXrXLMZkl++j9+SHz+ekCjBfzrawj1r5QgaokNjxZWdf2m3maPCeWQKzQeOV
        49CPQXT8eeMLxxdnxQOr/zN+KFyVVBc=
Content-Disposition: inline
In-Reply-To: <20220503162149.1764245-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

Hi Waiman

On Tue, May 03, 2022 at 12:21:44PM -0400 Waiman Long wrote:
> Currently, a partition root cannot have empty "cpuset.cpus.effective".
> As a result, a parent partition root cannot distribute out all its CPUs
>  to child partitions with no CPUs left. However in most cases, there
> shouldn't be any tasks associated with intermediate nodes of the default
>  hierarchy. So the current rule is too restrictive and can waste valuable
>  CPU resource.
> 
> To address this issue, we are now allowing a partition to have empty
> "cpuset.cpus.effective" as long as it has no task. Therefore, a parent
> partition with no task can now have all its CPUs distributed out to its
> child partitions. The top cpuset always have some house-keeping tasks
> running and so its list of effective cpu can't never be empty.

s/never/ever/

> 
> Once a partition with empty "cpuset.cpus.effective" is formed, no
> new task can be moved into it until "cpuset.cpus.effective" becomes
> non-empty.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup/cpuset.c | 111 +++++++++++++++++++++++++++++++----------
>  1 file changed, 84 insertions(+), 27 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index d156a39d7a08..7d9abd50a1b9 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -412,6 +412,41 @@ static inline bool is_in_v2_mode(void)
>  	      (cpuset_cgrp_subsys.root->flags & CGRP_ROOT_CPUSET_V2_MODE);
>  }
>  
> +/**
> + * partition_is_populated - check if partition has tasks
> + * @cs: partition root to be checked
> + * @excluded_child: a child cpuset to be excluded in task checking
> + * Return: true if there are tasks, false otherwise
> + *
> + * It is assumed that @cs is a valid partition root. @excluded_child should
> + * be non-NULL when this cpuset is going to become a partition itself.
> + */
> +static inline bool partition_is_populated(struct cpuset *cs,
> +					  struct cpuset *excluded_child)
> +{
> +	struct cgroup_subsys_state *css;
> +	struct cpuset *child;
> +
> +	if (cs->css.cgroup->nr_populated_csets)
> +		return true;
> +	if (!excluded_child && !cs->nr_subparts_cpus)
> +		return cgroup_is_populated(cs->css.cgroup);
> +
> +	rcu_read_lock();
> +	cpuset_for_each_child(child, css, cs) {
> +		if (child == excluded_child)
> +			continue;
> +		if (is_partition_valid(child))
> +			continue;
> +		if (cgroup_is_populated(child->css.cgroup)) {
> +			rcu_read_unlock();
> +			return true;
> +		}
> +	}
> +	rcu_read_unlock();
> +	return false;
> +}
> +
>  /*
>   * Return in pmask the portion of a task's cpusets's cpus_allowed that
>   * are online and are capable of running the task.  If none are found,
> @@ -1252,22 +1287,25 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
>  	if ((cmd != partcmd_update) && css_has_online_children(&cs->css))
>  		return -EBUSY;
>  
> -	/*
> -	 * Enabling partition root is not allowed if not all the CPUs
> -	 * can be granted from parent's effective_cpus or at least one
> -	 * CPU will be left after that.
> -	 */
> -	if ((cmd == partcmd_enable) &&
> -	   (!cpumask_subset(cs->cpus_allowed, parent->effective_cpus) ||
> -	     cpumask_equal(cs->cpus_allowed, parent->effective_cpus)))
> -		return -EINVAL;
> -
> -	/*
> -	 * A cpumask update cannot make parent's effective_cpus become empty.
> -	 */
>  	adding = deleting = false;
>  	old_prs = new_prs = cs->partition_root_state;
>  	if (cmd == partcmd_enable) {
> +		/*
> +		 * Enabling partition root is not allowed if not all the CPUs
> +		 * can be granted from parent's effective_cpus.
> +		 */
> +		if (!cpumask_subset(cs->cpus_allowed, parent->effective_cpus))
> +			return -EINVAL;
> +
> +		/*
> +		 * A parent can be left with no CPU as long as there is no
> +		 * task directly associated with the parent partition. For
> +		 * such a parent, no new task can be moved into it.
> +		 */
> +		if (partition_is_populated(parent, cs) &&
> +		    cpumask_equal(cs->cpus_allowed, parent->effective_cpus))
> +			return -EINVAL;
> +

You might consider switching these around to check the cpumasks first.


>  		cpumask_copy(tmp->addmask, cs->cpus_allowed);
>  		adding = true;
>  	} else if (cmd == partcmd_disable) {
> @@ -1289,9 +1327,10 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
>  		adding = cpumask_andnot(tmp->addmask, tmp->addmask,
>  					parent->subparts_cpus);
>  		/*
> -		 * Return error if the new effective_cpus could become empty.
> +		 * Return error if the new effective_cpus could become empty
> +		 * and there are tasks in the parent.
>  		 */
> -		if (adding &&
> +		if (adding && partition_is_populated(parent, cs) &&
>  		    cpumask_equal(parent->effective_cpus, tmp->addmask)) {

Same.



Cheers,
Phil


>  			if (!deleting)
>  				return -EINVAL;
> @@ -1317,8 +1356,8 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
>  		 */
>  		adding = cpumask_and(tmp->addmask, cs->cpus_allowed,
>  				     parent->effective_cpus);
> -		part_error = cpumask_equal(tmp->addmask,
> -					   parent->effective_cpus);
> +		part_error = cpumask_equal(tmp->addmask, parent->effective_cpus) &&
> +			     partition_is_populated(parent, cs);
>  	}
>  
>  	if (cmd == partcmd_update) {
> @@ -1420,9 +1459,15 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
>  
>  		/*
>  		 * If it becomes empty, inherit the effective mask of the
> -		 * parent, which is guaranteed to have some CPUs.
> +		 * parent, which is guaranteed to have some CPUs unless
> +		 * it is a partition root that has explicitly distributed
> +		 * out all its CPUs.
>  		 */
>  		if (is_in_v2_mode() && cpumask_empty(tmp->new_cpus)) {
> +			if (is_partition_valid(cp) &&
> +			    cpumask_equal(cp->cpus_allowed, cp->subparts_cpus))
> +				goto update_parent_subparts;
> +
>  			cpumask_copy(tmp->new_cpus, parent->effective_cpus);
>  			if (!cp->use_parent_ecpus) {
>  				cp->use_parent_ecpus = true;
> @@ -1444,6 +1489,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
>  			continue;
>  		}
>  
> +update_parent_subparts:
>  		/*
>  		 * update_parent_subparts_cpumask() should have been called
>  		 * for cs already in update_cpumask(). We should also call
> @@ -2249,6 +2295,13 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>  	    (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed)))
>  		goto out_unlock;
>  
> +	/*
> +	 * On default hierarchy, task cannot be moved to a cpuset with empty
> +	 * effective cpus.
> +	 */
> +	if (is_in_v2_mode() && cpumask_empty(cs->effective_cpus))
> +		goto out_unlock;
> +
>  	cgroup_taskset_for_each(task, css, tset) {
>  		ret = task_can_attach(task, cs->cpus_allowed);
>  		if (ret)
> @@ -3115,7 +3168,8 @@ hotplug_update_tasks(struct cpuset *cs,
>  		     struct cpumask *new_cpus, nodemask_t *new_mems,
>  		     bool cpus_updated, bool mems_updated)
>  {
> -	if (cpumask_empty(new_cpus))
> +	/* A partition root is allowed to have empty effective cpus */
> +	if (cpumask_empty(new_cpus) && !is_partition_valid(cs))
>  		cpumask_copy(new_cpus, parent_cs(cs)->effective_cpus);
>  	if (nodes_empty(*new_mems))
>  		*new_mems = parent_cs(cs)->effective_mems;
> @@ -3184,10 +3238,11 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>  
>  	/*
>  	 * In the unlikely event that a partition root has empty
> -	 * effective_cpus or its parent becomes invalid, we have to
> -	 * transition it to the invalid state.
> +	 * effective_cpus with tasks or its parent becomes invalid, we
> +	 * have to transition it to the invalid state.
>  	 */
> -	if (is_partition_valid(cs) && (cpumask_empty(&new_cpus) ||
> +	if (is_partition_valid(cs) &&
> +	   ((cpumask_empty(&new_cpus) && partition_is_populated(cs, NULL)) ||
>  	    is_partition_invalid(parent))) {
>  		if (cs->nr_subparts_cpus) {
>  			spin_lock_irq(&callback_lock);
> @@ -3198,13 +3253,15 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>  		}
>  
>  		/*
> -		 * If the effective_cpus is empty because the child
> -		 * partitions take away all the CPUs, we can keep
> -		 * the current partition and let the child partitions
> -		 * fight for available CPUs.
> +		 * Force the partition to become invalid if either one of
> +		 * the following conditions hold:
> +		 * 1) empty effective cpus but not valid empty partition.
> +		 * 2) parent is invalid or doesn't grant any cpus to child
> +		 *    partitions.
>  		 */
>  		if (is_partition_invalid(parent) ||
> -		     cpumask_empty(&new_cpus)) {
> +		    (cpumask_empty(&new_cpus) &&
> +		     partition_is_populated(cs, NULL))) {
>  			int old_prs;
>  
>  			update_parent_subparts_cpumask(cs, partcmd_disable,
> -- 
> 2.27.0
> 


-- 

