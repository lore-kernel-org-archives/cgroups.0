From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v8 4/6] cpuset: Make generate_sched_domains() recognize
 isolated_cpus
Date: Fri, 25 May 2018 11:31:47 +0100
Message-ID: <20180525103147.GC30654@e110439-lin>
References: <1526590545-3350-1-git-send-email-longman@redhat.com>
 <1526590545-3350-5-git-send-email-longman@redhat.com>
 <20180523173453.GY30654@e110439-lin>
 <bf4cb72b-9ff3-eb8b-ca2c-f6c4fee5c123@redhat.com>
 <20180524090430.GZ30654@e110439-lin>
 <20180524103938.GB3948@localhost.localdomain>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180524103938.GB3948@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

Hi Juri,
following are some notes I took while trying to understand what's going on...
could be useful to understand if I have a correct view of all the different
components and how they come together.

At the end there are also a couple of possible updates and a question on your
proposal.

Cheers Patrick

On 24-May 12:39, Juri Lelli wrote:
> On 24/05/18 10:04, Patrick Bellasi wrote:
> 
> [...]
> 
> > From 84bb8137ce79f74849d97e30871cf67d06d8d682 Mon Sep 17 00:00:00 2001
> > From: Patrick Bellasi <patrick.bellasi@arm.com>
> > Date: Wed, 23 May 2018 16:33:06 +0100
> > Subject: [PATCH 1/1] cgroup/cpuset: disable sched domain rebuild when not
> >  required
> > 
> > The generate_sched_domains() already addresses the "special case for 99%
> > of systems" which require a single full sched domain at the root,
> > spanning all the CPUs. However, the current support is based on an
> > expensive sequence of operations which destroy and recreate the exact
> > same scheduling domain configuration.
> > 
> > If we notice that:
> > 
> >  1) CPUs in "cpuset.isolcpus" are excluded from load balancing by the
> >     isolcpus= kernel boot option, and will never be load balanced
> >     regardless of the value of "cpuset.sched_load_balance" in any
> >     cpuset.
> > 
> >  2) the root cpuset has load_balance enabled by default at boot and
> >     it's the only parameter which userspace can change at run-time.
> > 
> > we know that, by default, every system comes up with a complete and
> > properly configured set of scheduling domains covering all the CPUs.
> > 
> > Thus, on every system, unless the user explicitly disables load balance
> > for the top_cpuset, the scheduling domains already configured at boot
> > time by the scheduler/topology code and updated in consequence of
> > hotplug events, are already properly configured for cpuset too.
> > 
> > This configuration is the default one for 99% of the systems,
> > and it's also the one used by most of the Android devices which never
> > disable load balance from the top_cpuset.
> > 
> > Thus, while load balance is enabled for the top_cpuset,
> > destroying/rebuilding the scheduling domains at every cpuset.cpus
> > reconfiguration is a useless operation which will always produce the
> > same result.
> > 
> > Let's anticipate the "special" optimization within:
> > 
> >    rebuild_sched_domains_locked()
> > 
> > thus completely skipping the expensive:
> > 
> >    generate_sched_domains()
> >    partition_sched_domains()
> > 
> > for all the cases we know that the scheduling domains already defined
> > will not be affected by whatsoever value of cpuset.cpus.
> 
> [...]
> 
> > +	/* Special case for the 99% of systems with one, full, sched domain */
> > +	if (!top_cpuset.isolation_count &&
> > +	    is_sched_load_balance(&top_cpuset))
> > +		goto out;
> > +
> 
> Mmm, looks like we still need to destroy e recreate if there is a
> new_topology (see arch_update_cpu_topology() in partition_sched_
> domains).

Right, so the problem seems to be that we "need" to call
arch_update_cpu_topology() and we do that by calling
partition_sched_domains() which was initially introduced by:

   029190c515f1 ("cpuset sched_load_balance flag")

back in 2007, where it's also quite well explained the reasons behind
the sched_load_balance flag and the idea to have "partitioned" SDs.

I also (hopefully) understood that there are at least two actors involved:

 - A) arch code
   which creates SDs and SGs, usually to group CPUs depending on the
   memory hierarchy, to support different time granularity of load
   balancing operations

   Special case here are HP and hibernation which, by on-/off-lining
   CPUs they directly affect the SDs/SGs definitions.

 - B) cpusets
   which expose to userspace the possibility to define,
   _if possible_, a finer granularity set of SGs to further restrict the
   scope of load balancing operations

Since B is a "possible finer granularity" refinement of A, then we
trigger A's reconfigurations based on B's constraints.

That's why, for example, in consequence of an HP online event,
we have:

   --- core.c -------------------
    HP[sched:active]
     | sched_cpu_activate()
       | cpuset_cpu_active()
   --- cpuset.c -----------------
         | cpuset_update_active_cpus()
           | schedule_work(&cpuset_hotplug_work)
            \.. System Kworker \
                | cpuset_hotplug_workfn()
                  if (cpus_updated || force_rebuild)
                    | rebuild_sched_domains()
                      | rebuild_sched_domains_locked()
                        | generate_sched_domains()
   --- topology.c ---------------
                        | partition_sched_domains()
                          | arch_update_cpu_topology()


IOW, we need to pass via cpusets to rebuild the SDs whenever we
there are HP events or we "need" to do an arch_update_cpu_topology()
via the arch topology driver (drivers/base/arch_topology.c).

This last bit is also interesting, whenever we detect arch topology
information that required an SD rebuild, we need to force a
partition_sched_domains(). But, for that, in:

   commit 50e76632339d ("sched/cpuset/pm: Fix cpuset vs. suspend-resume bugs")

we just introduced the support for the "force_rebuild" flag to be set.

Thus, potentially we can just extend the check I've proposed to consider the
force rebuild flag, to be something like:

---8<---
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 8f586e8bdc98..1f051fafaa3a 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -874,11 +874,19 @@ static void rebuild_sched_domains_locked(void)
           !cpumask_subset(top_cpuset.effective_cpus, cpu_active_mask))
                goto out;
 
+       /* Special case for the 99% of systems with one, full, sched domain */
+       if (!force_rebuild &&
+           !top_cpuset.isolation_count &&
+           is_sched_load_balance(&top_cpuset))
+               goto out;
+       force_rebuild = false;
+
        /* Generate domain masks and attrs */
        ndoms = generate_sched_domains(&doms, &attr);
 
        /* Have scheduler rebuild the domains */
        partition_sched_domains(ndoms, doms, attr);
 out:
        put_online_cpus();
---8<---


Which would still allow to use something like:

   cpuset_force_rebuild()
   rebuild_sched_domains()

to actually rebuild SD in consequence of arch topology changes.

> 
> Maybe we could move the check you are proposing in update_cpumasks_
> hier() ?

Yes, that's another option... although there we are outside of
get_online_cpus(). Could be a problem?

However, in general, I would say that all around:

   rebuild_sched_domains
   rebuild_sched_domains_locked
   update_cpumask
   update_cpumasks_hier

a nice refactoring would be really deserved :)

-- 
#include <best/regards.h>

Patrick Bellasi
