From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v8 4/6] cpuset: Make generate_sched_domains() recognize
 isolated_cpus
Date: Fri, 25 May 2018 14:52:17 +0200
Message-ID: <20180525125217.GC678@localhost.localdomain>
References: <1526590545-3350-1-git-send-email-longman@redhat.com>
 <1526590545-3350-5-git-send-email-longman@redhat.com>
 <20180523173453.GY30654@e110439-lin>
 <bf4cb72b-9ff3-eb8b-ca2c-f6c4fee5c123@redhat.com>
 <20180524090430.GZ30654@e110439-lin>
 <20180524103938.GB3948@localhost.localdomain>
 <20180525103147.GC30654@e110439-lin>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180525103147.GC30654@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On 25/05/18 11:31, Patrick Bellasi wrote:

[...]

> Right, so the problem seems to be that we "need" to call
> arch_update_cpu_topology() and we do that by calling
> partition_sched_domains() which was initially introduced by:
> 
>    029190c515f1 ("cpuset sched_load_balance flag")
> 
> back in 2007, where it's also quite well explained the reasons behind
> the sched_load_balance flag and the idea to have "partitioned" SDs.
> 
> I also (hopefully) understood that there are at least two actors involved:
> 
>  - A) arch code
>    which creates SDs and SGs, usually to group CPUs depending on the
>    memory hierarchy, to support different time granularity of load
>    balancing operations
> 
>    Special case here are HP and hibernation which, by on-/off-lining
>    CPUs they directly affect the SDs/SGs definitions.
> 
>  - B) cpusets
>    which expose to userspace the possibility to define,
>    _if possible_, a finer granularity set of SGs to further restrict the
>    scope of load balancing operations
> 
> Since B is a "possible finer granularity" refinement of A, then we
> trigger A's reconfigurations based on B's constraints.
> 
> That's why, for example, in consequence of an HP online event,
> we have:
> 
>    --- core.c -------------------
>     HP[sched:active]
>      | sched_cpu_activate()
>        | cpuset_cpu_active()
>    --- cpuset.c -----------------
>          | cpuset_update_active_cpus()
>            | schedule_work(&cpuset_hotplug_work)
>             \.. System Kworker \
>                 | cpuset_hotplug_workfn()
>                   if (cpus_updated || force_rebuild)
>                     | rebuild_sched_domains()
>                       | rebuild_sched_domains_locked()
>                         | generate_sched_domains()
>    --- topology.c ---------------
>                         | partition_sched_domains()
>                           | arch_update_cpu_topology()
> 
> 
> IOW, we need to pass via cpusets to rebuild the SDs whenever we
> there are HP events or we "need" to do an arch_update_cpu_topology()
> via the arch topology driver (drivers/base/arch_topology.c).

I don't think the arch topology driver is always involved in this (e.g.,
arch/x86/kernel/itmt::sched_itmt_update_handler()).

Still we need to check if topology changed, as you say.

> This last bit is also interesting, whenever we detect arch topology
> information that required an SD rebuild, we need to force a
> partition_sched_domains(). But, for that, in:
> 
>    commit 50e76632339d ("sched/cpuset/pm: Fix cpuset vs. suspend-resume bugs")
> 
> we just introduced the support for the "force_rebuild" flag to be set.
> 
> Thus, potentially we can just extend the check I've proposed to consider the
> force rebuild flag, to be something like:
> 
> ---8<---
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 8f586e8bdc98..1f051fafaa3a 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -874,11 +874,19 @@ static void rebuild_sched_domains_locked(void)
>            !cpumask_subset(top_cpuset.effective_cpus, cpu_active_mask))
>                 goto out;
>  
> +       /* Special case for the 99% of systems with one, full, sched domain */
> +       if (!force_rebuild &&
> +           !top_cpuset.isolation_count &&
> +           is_sched_load_balance(&top_cpuset))
> +               goto out;
> +       force_rebuild = false;
> +
>         /* Generate domain masks and attrs */
>         ndoms = generate_sched_domains(&doms, &attr);
>  
>         /* Have scheduler rebuild the domains */
>         partition_sched_domains(ndoms, doms, attr);
>  out:
>         put_online_cpus();
> ---8<---
> 
> 
> Which would still allow to use something like:
> 
>    cpuset_force_rebuild()
>    rebuild_sched_domains()
> 
> to actually rebuild SD in consequence of arch topology changes.

That might work.

> 
> > 
> > Maybe we could move the check you are proposing in update_cpumasks_
> > hier() ?
> 
> Yes, that's another option... although there we are outside of
> get_online_cpus(). Could be a problem?

Mmm, using force_rebuild flag seems safer indeed.
