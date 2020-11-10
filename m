From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] cpuset: fix race between hotplug work and later CPU
 offline
Date: Tue, 10 Nov 2020 17:45:04 +0100
Message-ID: <20201110164504.GL2594@hirez.programming.kicks-ass.net>
References: <20201029181845.415517-1-daniel.m.jordan@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wSUXj/HwHT6/+9AmnFi8RjjWjheGWux8iIWwad4+zjY=; b=XIKTLcyU4w3uQlTIYf4/WSgBVh
        JYv3iqGelfPzoZWQAduXxX7aK0YtgqamRVhDVaMndbWBHG8CvU3YD3yzrae5L5ngvQj0HPkiYkeYN
        /A5NTgIc3ijEr3zbMicfAUDCK3BUN6a7tsXxfBKPblycRX+MV6mxDuBln/uzaKsQkdBYsQsROfY3s
        y2Sdet/Bvwzk8o8UYp0KnalZ61TcYNa9o1Jr7aeGwwyIkQLW04ceIiBNP2iWwJEhAlW/oKc7XUBE9
        oibcGxF7XcVauPl2wtI2FfijmUqnQGcPUCAUFzlo+50xLTGZ+pUaaG/4Cr4EOuXiedKWUwB30Xfa+
        F3TR6PIQ==;
Content-Disposition: inline
In-Reply-To: <20201029181845.415517-1-daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Oct 29, 2020 at 02:18:45PM -0400, Daniel Jordan wrote:
> One of our machines keeled over trying to rebuild the scheduler domains.
> Mainline produces the same splat:
> 
>   BUG: unable to handle page fault for address: 0000607f820054db
>   CPU: 2 PID: 149 Comm: kworker/1:1 Not tainted 5.10.0-rc1-master+ #6
>   Workqueue: events cpuset_hotplug_workfn
>   RIP: build_sched_domains
>   Call Trace:
>    partition_sched_domains_locked
>    rebuild_sched_domains_locked
>    cpuset_hotplug_workfn
> 
> It happens with cgroup2 and exclusive cpusets only.  This reproducer
> triggers it on an 8-cpu vm and works most effectively with no
> preexisting child cgroups:
> 
>   cd $UNIFIED_ROOT
>   mkdir cg1
>   echo 4-7 > cg1/cpuset.cpus
>   echo root > cg1/cpuset.cpus.partition
> 
>   # with smt/control reading 'on',
>   echo off > /sys/devices/system/cpu/smt/control
> 
> RIP maps to
> 
>   sd->shared = *per_cpu_ptr(sdd->sds, sd_id);
> 
> from sd_init().  sd_id is calculated earlier in the same function:
> 
>   cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
>   sd_id = cpumask_first(sched_domain_span(sd));
> 
> tl->mask(cpu), which reads cpu_sibling_map on x86, returns an empty mask
> and so cpumask_first() returns >= nr_cpu_ids, which leads to the bogus
> value from per_cpu_ptr() above.
> 
> The problem is a race between cpuset_hotplug_workfn() and a later
> offline of CPU N.  cpuset_hotplug_workfn() updates the effective masks
> when N is still online, the offline clears N from cpu_sibling_map, and
> then the worker uses the stale effective masks that still have N to
> generate the scheduling domains, leading the worker to read
> N's empty cpu_sibling_map in sd_init().
> 
> rebuild_sched_domains_locked() prevented the race during the cgroup2
> cpuset series up until the Fixes commit changed its check.  Make the
> check more robust so that it can detect an offline CPU in any exclusive
> cpuset's effective mask, not just the top one.

*groan*, what a mess...

> Fixes: 0ccea8feb980 ("cpuset: Make generate_sched_domains() work with partition")
> Signed-off-by: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
> 
> I think the right thing to do long-term is make the hotplug work
> synchronous, fixing the lockdep splats of past attempts, and then take
> these checks out of rebuild_sched_domains_locked, but this fixes the
> immediate issue and is small enough for stable.  Open to suggestions.
> 
> Prateek, are you planning on picking up your patches again?

Yeah, that might help, but those deadlocks were nasty iirc :/

>  kernel/cgroup/cpuset.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 57b5b5d0a5fd..ac3124010b2a 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -983,8 +983,10 @@ partition_and_rebuild_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
>   */
>  static void rebuild_sched_domains_locked(void)
>  {
> +	struct cgroup_subsys_state *pos_css;
>  	struct sched_domain_attr *attr;
>  	cpumask_var_t *doms;
> +	struct cpuset *cs;
>  	int ndoms;
>  
>  	lockdep_assert_cpus_held();
> @@ -999,9 +1001,21 @@ static void rebuild_sched_domains_locked(void)
>  	    !cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
>  		return;

So you argued above that effective_cpus was stale, I suppose the above
one works because its an equality test instead of a subset? Does that
wants a comment?

> -	if (top_cpuset.nr_subparts_cpus &&
> -	   !cpumask_subset(top_cpuset.effective_cpus, cpu_active_mask))
> -		return;
> +	if (top_cpuset.nr_subparts_cpus) {
> +		rcu_read_lock();
> +		cpuset_for_each_descendant_pre(cs, pos_css, &top_cpuset) {
> +			if (!is_partition_root(cs)) {
> +				pos_css = css_rightmost_descendant(pos_css);
> +				continue;
> +			}
> +			if (!cpumask_subset(cs->effective_cpus,
> +					    cpu_active_mask)) {
> +				rcu_read_unlock();
> +				return;
> +			}
> +		}
> +		rcu_read_unlock();
> +	}
>  
>  	/* Generate domain masks and attrs */
>  	ndoms = generate_sched_domains(&doms, &attr);
