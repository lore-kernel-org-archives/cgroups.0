From: Michael Wang <wangyun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC PATCH] sched: dynamically schedule domain configuration
Date: Tue, 17 Jul 2012 10:46:41 +0800
Message-ID: <5004D211.50200@linux.vnet.ibm.com>
References: <5003DBF7.9090401@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5003DBF7.9090401-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Add the missing cc list.

On 07/16/2012 05:16 PM, Michael Wang wrote:
> From: Michael Wang <wangyun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> This patch is trying to provide a way for user to dynamically change
> the behaviour of load balance by setting flags of schedule domain.
> 
> Currently it's rely on cpu cgroup and only SD_LOAD_BALANCE was
> implemented, usage:
> 
> 1. /sys/fs/cgroup/domain/domain.config_level
> 	the default config_level is 0, which means we currenlty configure
> 	the sibling domain for all cpus, we can use: 
> 		echo 'number' > /sys/fs/cgroup/domain/domain.config_level
> 	to change the level.
> 
> 2. /sys/fs/cgroup/domain/domain.topology
> 	this will help to show the SD_LOAD_BALANCE status of all the cpu's
> 	all domain level, we can use:
> 		cat /sys/fs/cgroup/domain/domain.topology
> 
> 3. /sys/fs/cgroup/domain/domain.SD_LOAD_BALANCE
> 	this will help us to change the bit SD_LOAD_BALANCE in the flag of
> 	schedule domain on level 'config_level', we can use:
> 		echo 1 > /sys/fs/cgroup/domain/domain.SD_LOAD_BALANCE
> 	to enable this bit, and:
> 		echo 0 > /sys/fs/cgroup/domain/domain.SD_LOAD_BALANCE
> 	to disable it.
> 
> It may not works well now(may be even not work at all as I can't see any
> changes on my server even after disabled SD_LOAD_BALANCE on all domains),
> but it is interesting and should be liked by some people who desire a
> way to 'kill' the load balance by their own hands if we can implement it.
> 
> Comments and questions are very welcomed ;-)
> 
> Signed-off-by: Michael Wang <wangyun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  include/linux/cgroup_subsys.h |    1 +
>  kernel/sched/core.c           |  143 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 144 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
> index 0bd390c..25eb842 100644
> --- a/include/linux/cgroup_subsys.h
> +++ b/include/linux/cgroup_subsys.h
> @@ -21,6 +21,7 @@ SUBSYS(debug)
> 
>  #ifdef CONFIG_CGROUP_SCHED
>  SUBSYS(cpu_cgroup)
> +SUBSYS(domain_cgroup)
>  #endif
> 
>  /* */
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 3987b9d..544bf78 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -8423,6 +8423,149 @@ struct cgroup_subsys cpu_cgroup_subsys = {
>  	.early_init	= 1,
>  };
> 
> +static struct cgroup_subsys_state domain_cgroup_css;
> +static struct cgroup_subsys_state *domain_cgroup_create(struct cgroup *cgrp)
> +{
> +	if (!cgrp->parent) {
> +		/* This is early initialization for the top cgroup */
> +		return &domain_cgroup_css;
> +	}
> +
> +	return ERR_PTR(-EPERM);
> +}
> +
> +static void domain_cgroup_destroy(struct cgroup *cgrp)
> +{
> +	return;
> +}
> +
> +static int domain_cgroup_can_attach(struct cgroup *cgrp,
> +				    struct cgroup_taskset *tset)
> +{
> +	return -EINVAL;
> +}
> +
> +static void domain_cgroup_attach(struct cgroup *cgrp,
> +				 struct cgroup_taskset *tset)
> +{
> +	return;
> +}
> +
> +static void domain_cgroup_exit(struct cgroup *cgrp,
> +			       struct cgroup *old_cgrp,
> +			       struct task_struct *task)
> +{
> +	return;
> +}
> +
> +static int domain_config_level;
> +
> +static int domain_cl_write_u64(struct cgroup *cgrp,
> +			       struct cftype *cftype,
> +			       u64 shareval)
> +{
> +	domain_config_level = shareval;
> +	return 0;
> +}
> +
> +static u64 domain_cl_read_u64(struct cgroup *cgrp, struct cftype *cft)
> +{
> +	return (u64)domain_config_level;
> +}
> +
> +static int domain_slb_write_u64(struct cgroup *cgrp,
> +				struct cftype *cftype,
> +				u64 shareval)
> +{
> +	int cpu;
> +	struct sched_domain *sd;
> +	if (shareval != 0 && shareval != 1)
> +		return -EINVAL;
> +
> +	mutex_lock(&sched_domains_mutex);
> +	for_each_cpu(cpu, cpu_active_mask) {
> +		for (sd = cpu_rq(cpu)->sd; sd; sd = sd->parent) {
> +			if (sd->level == domain_config_level) {
> +				if (shareval)
> +					sd->flags |= SD_LOAD_BALANCE;
> +				else
> +					sd->flags &= ~SD_LOAD_BALANCE;
> +			}
> +		}
> +	}
> +	mutex_unlock(&sched_domains_mutex);
> +	return 0;
> +}
> +
> +static u64 domain_slb_read_u64(struct cgroup *cgrp, struct cftype *cft)
> +{
> +	int cpu, ret = 0;
> +	struct sched_domain *sd;
> +	mutex_lock(&sched_domains_mutex);
> +	for_each_cpu(cpu, cpu_active_mask) {
> +		for (sd = cpu_rq(cpu)->sd; sd; sd = sd->parent) {
> +			if (sd->level == domain_config_level) {
> +				if (sd->flags & SD_LOAD_BALANCE)
> +					ret = 1;
> +				goto out;
> +			}
> +		}
> +	}
> +out:
> +	mutex_unlock(&sched_domains_mutex);
> +	return ret;
> +}
> +
> +static int domain_topology_show(struct cgroup *cgrp,
> +				struct cftype *cft,
> +				struct cgroup_map_cb *cb)
> +{
> +	int cpu;
> +	struct sched_domain *sd;
> +	mutex_lock(&sched_domains_mutex);
> +	for_each_cpu(cpu, cpu_active_mask) {
> +		cb->fill(cb, "cpu", cpu);
> +		for (sd = cpu_rq(cpu)->sd; sd; sd = sd->parent) {
> +			cb->fill(cb, "\tlevel", sd->level);
> +			cb->fill(cb, "\t\tSD_LOAD_BALANCE",
> +						sd->flags & SD_LOAD_BALANCE);
> +		}
> +	}
> +	mutex_unlock(&sched_domains_mutex);
> +
> +	return 0;
> +}
> +
> +static struct cftype domain_files[] = {
> +	{
> +		.name = "config_level",
> +		.read_u64 = domain_cl_read_u64,
> +		.write_u64 = domain_cl_write_u64,
> +	},
> +	{
> +		.name = "SD_LOAD_BALANCE",
> +		.read_u64 = domain_slb_read_u64,
> +		.write_u64 = domain_slb_write_u64,
> +	},
> +	{
> +		.name = "topology",
> +		.read_map = domain_topology_show,
> +	},
> +	{ }	/* terminate */
> +};
> +
> +struct cgroup_subsys domain_cgroup_subsys = {
> +	.name		= "domain",
> +	.create		= domain_cgroup_create,
> +	.destroy	= domain_cgroup_destroy,
> +	.can_attach	= domain_cgroup_can_attach,
> +	.attach		= domain_cgroup_attach,
> +	.exit		= domain_cgroup_exit,
> +	.subsys_id	= domain_cgroup_subsys_id,
> +	.base_cftypes	= domain_files,
> +	.early_init	= 1,
> +};
> +
>  #endif	/* CONFIG_CGROUP_SCHED */
> 
>  #ifdef CONFIG_CGROUP_CPUACCT
> 

