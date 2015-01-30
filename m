From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH] cpuset, sched: Fix cpuset sched_relax_domain_level
Date: Fri, 30 Jan 2015 12:13:16 +0800
Message-ID: <54CB04DC.3090405@huawei.com>
References: <1422478025.4111.31.camel@j-VirtualBox>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422478025.4111.31.camel@j-VirtualBox>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aswin-VXdhtT5mjnY@public.gmane.org, scott.norton-VXdhtT5mjnY@public.gmane.org, chegu_vinod-VXdhtT5mjnY@public.gmane.org

On 2015/1/29 4:47, Jason Low wrote:
> The cpuset.sched_relax_domain_level can control how far we do
> immediate load balancing on a system. However, it was found on recent
> kernels that echo'ing a value into cpuset.sched_relax_domain_level
> did not reduce any immediate load balancing.
> 
> The reason this occurred was because the update_domain_attr_tree() traversal
> did not update for the "top_cpuset". This resulted in nothing being changed
> when modifying the sched_relax_domain_level parameter.
> 
> This patch was able to address that problem by having update_domain_attr_tree()
> allowing updates for the root (top_cpuset) in the cpuset traversal.
> 
> Signed-off-by: Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>

Thanks for finding this bug!

Please Add:

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.9+
Fixes: fc560a26acce ("cpuset: replace cpuset->stack_list with cpuset_for_each_descendant_pre()")

I'll prepare a different fix for 3.10.y when this patch hits mainline.

> ---
>  kernel/cpuset.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 64b257f..0f58c54 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -541,15 +541,17 @@ update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
>  }
>  
>  static void update_domain_attr_tree(struct sched_domain_attr *dattr,
> -				    struct cpuset *root_cs)
> +				    struct cpuset *root_cs, bool update_root)
>  {
>  	struct cpuset *cp;
>  	struct cgroup_subsys_state *pos_css;
>  
>  	rcu_read_lock();
>  	cpuset_for_each_descendant_pre(cp, pos_css, root_cs) {
> -		if (cp == root_cs)
> -			continue;

I don't think this fix is correct. We should simply remove these two lines,
and no other changes are needed.

> +		if (cp == root_cs) {
> +			if (!update_root)
> +				continue;
> +		}
>  
>  		/* skip the whole subtree if @cp doesn't have any CPU */
>  		if (cpumask_empty(cp->cpus_allowed)) {
> @@ -644,7 +646,7 @@ static int generate_sched_domains(cpumask_var_t **domains,
>  		dattr = kmalloc(sizeof(struct sched_domain_attr), GFP_KERNEL);
>  		if (dattr) {
>  			*dattr = SD_ATTR_INIT;
> -			update_domain_attr_tree(dattr, &top_cpuset);
> +			update_domain_attr_tree(dattr, &top_cpuset, true);
>  		}
>  		cpumask_copy(doms[0], top_cpuset.effective_cpus);
>  
> @@ -752,7 +754,7 @@ restart:
>  			if (apn == b->pn) {
>  				cpumask_or(dp, dp, b->effective_cpus);
>  				if (dattr)
> -					update_domain_attr_tree(dattr + nslot, b);
> +					update_domain_attr_tree(dattr + nslot, b, false);
>  
>  				/* Done with this partition */
>  				b->pn = -1;
> 
