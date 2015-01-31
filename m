From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cpuset: Fix cpuset sched_relax_domain_level
Date: Sat, 31 Jan 2015 08:31:09 +0800
Message-ID: <54CC224D.80201@huawei.com>
References: <1422644094.3365.7.camel@j-VirtualBox>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422644094.3365.7.camel@j-VirtualBox>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aswin-VXdhtT5mjnY@public.gmane.org, scott.norton-VXdhtT5mjnY@public.gmane.org, chegu_vinod-VXdhtT5mjnY@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2015/1/31 2:54, Jason Low wrote:
> The cpuset.sched_relax_domain_level can control how far we do
> immediate load balancing on a system. However, it was found on recent
> kernels that echo'ing a value into cpuset.sched_relax_domain_level
> did not reduce any immediate load balancing.
> 
> The reason this occurred was because the update_domain_attr_tree() traversal
> did not update for the "top_cpuset". This resulted in nothing being changed
> when modifying the sched_relax_domain_level parameter.
> 
> This patch is able to address that problem by having update_domain_attr_tree()
> allow updates for the root in the cpuset traversal.
> 
> Fixes: fc560a26acce ("cpuset: replace cpuset->stack_list with cpuset_for_each_descendant_pre()")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.9+
> Signed-off-by: Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>

Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

> ---
>  kernel/cpuset.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 64b257f..b589e57 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -548,9 +548,6 @@ static void update_domain_attr_tree(struct sched_domain_attr *dattr,
>  
>  	rcu_read_lock();
>  	cpuset_for_each_descendant_pre(cp, pos_css, root_cs) {
> -		if (cp == root_cs)
> -			continue;
> -
>  		/* skip the whole subtree if @cp doesn't have any CPU */
>  		if (cpumask_empty(cp->cpus_allowed)) {
>  			pos_css = css_rightmost_descendant(pos_css);
> 
