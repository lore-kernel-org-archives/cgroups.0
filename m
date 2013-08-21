From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 04/11] cpuset: update cs->real_{cpus,mems}_allowed when
	config changes
Date: Wed, 21 Aug 2013 09:39:06 -0400
Message-ID: <20130821133906.GD19286@mtj.dyndns.org>
References: <52148F52.0@huawei.com>
 <52148F84.9050309@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=sbEgi8RQPs4GChkwcGIjOBeomXav9LMUT2A9+sbFHh0=;
	b=npR7sfqN/tt6OH/PKOH0HLu6D9LoLugNq/5g1MCwIOMC7Vf+pqjjWlW+oR9HHUBFBd
	DBnzcljAYbte9vCrwcurV4ILjVmK3AxaE3rhtTF4WiSbAaVTIvaN0D67QvIdcMTNqkHn
	rVYx3oZXfAfUc9BHoUI3ZSOtnypPSgniIxAH6y5exANF8zlkJsHGE1i9wlgzof6eJcJp
	v3sfnlcE/EbN3iJvmcorD4XWs8LzEqAcy/iIDwRpBzbWU3hMYGAoo8CGjRT1uxvY1H2u
	V22CZM8OobOPq8uWF9++Civx8anftyWwaJSxZ5nnJchC5LB1Ho9yTk6heODgNkpY8T31
	PYpA==
Content-Disposition: inline
In-Reply-To: <52148F84.9050309-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Aug 21, 2013 at 05:59:32PM +0800, Li Zefan wrote:
...
> +	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
> +		struct cpuset *parent = parent_cs(cs);
> +		struct cpumask *new_cpus = trialcs->real_cpus_allowed;
> +
> +		cpumask_and(new_cpus, cp->cpus_allowed,
> +			    parent->real_cpus_allowed);
> +
> +		/*
> +		 * Skip the whole subtree if the cpumask is not changed, unless
> +		 * it's empty, and in this case we need to update tasks to take
> +		 * on an ancestor's cpumask.

Something like the following would be clearer?

"Skip the whole subtree if the cpumask remains the same and isn't
empty.  If empty, we need..."

> @@ -931,7 +941,6 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
>  {
>  	struct ptr_heap heap;
>  	int retval;
> -	int is_load_balanced;
>  
>  	/* top_cpuset.cpus_allowed tracks cpu_online_mask; it's read-only */
>  	if (cs == &top_cpuset)
> @@ -966,17 +975,15 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
>  	if (retval)
>  		return retval;
>  
> -	is_load_balanced = is_sched_load_balance(trialcs);
> -
>  	mutex_lock(&callback_mutex);
>  	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
>  	mutex_unlock(&callback_mutex);
>  
> -	update_tasks_cpumask_hier(cs, true, &heap);
> +	update_cpumasks_hier(cs, trialcs, &heap);
>  
>  	heap_free(&heap);
>  
> -	if (is_load_balanced)
> +	if (is_sched_load_balance(cs))
>  		rebuild_sched_domains_locked();

Hmmm... Maybe the above change needs some explanation in the patch
description?

Ooh and @update_root params are gone.  Maybe nice to note that in the
description too?

Thanks.

-- 
tejun
