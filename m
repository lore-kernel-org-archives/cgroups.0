From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v8 1/6] cpuset: Enable cpuset controller in default
 hierarchy
Date: Mon, 21 May 2018 16:09:24 +0100
Message-ID: <20180521150924.GS30654@e110439-lin>
References: <1526590545-3350-1-git-send-email-longman@redhat.com>
 <1526590545-3350-2-git-send-email-longman@redhat.com>
 <20180521115528.GR30654@e110439-lin>
 <fbc71cfc-6801-0fda-b0c6-2a70f7c9fe25@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fbc71cfc-6801-0fda-b0c6-2a70f7c9fe25@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>

On 21-May 09:55, Waiman Long wrote:
> On 05/21/2018 07:55 AM, Patrick Bellasi wrote:
> > Hi Waiman!

[...]

> >> +Cpuset
> >> +------
> >> +
> >> +The "cpuset" controller provides a mechanism for constraining
> >> +the CPU and memory node placement of tasks to only the resources
> >> +specified in the cpuset interface files in a task's current cgroup.
> >> +This is especially valuable on large NUMA systems where placing jobs
> >> +on properly sized subsets of the systems with careful processor and
> >> +memory placement to reduce cross-node memory access and contention
> >> +can improve overall system performance.
> > Another quite important use-case for cpuset is Android, where they are
> > actively used to do both power-saving as well as performance tunings.
> > For example, depending on the status of an application, its threads
> > can be allowed to run on all available CPUS (e.g. foreground apps) or
> > be restricted only on few energy efficient CPUs (e.g. backgroud apps).
> >
> > Since here we are at "rewriting" cpusets for v2, I think it's important
> > to keep this mobile world scenario into consideration.
> >
> > For example, in this context, we are looking at the possibility to
> > update/tune cpuset.cpus with a relatively high rate, i.e. tens of
> > times per second. Not sure that's the same update rate usually
> > required for the large NUMA systems you cite above.  However, in this
> > case it's quite important to have really small overheads for these
> > operations.
> 
> The cgroup interface isn't designed for high update throughput.

Indeed, I had the same impression...

> Changing cpuset.cpus will require searching for the all the tasks in
> the cpuset and change its cpu mask.

... I'm wondering if that has to be the case. In principle there can
be a different solution which is: update on demand. In the wakeup
path, once we know a task really need a CPU and we want to find one
for it, at that point we can align the cpuset mask with the task's
one. Sort of using the cpuset mask as a clamp on top of the task's
affinity mask.

The main downside of such an approach could be the overheads in the
wakeup path... but, still... that should be measured.
The advantage is that we do not spend time changing attributes of
tassk which, potentially, could be sleeping for a long time.


> That isn't a fast operation, but it shouldn't be too bad either
> depending on how many tasks are in the cpuset.

Indeed, althought it still seems a bit odd and overkilling updating
task affinity for tasks which are not currently RUNNABLE. Isn't it?

> I would not suggest doing rapid changes to cpuset.cpus as a mean to tune
> the behavior of a task. So what exactly is the tuning you are thinking
> about? Is it moving a task from the a high-power cpu to a low power one
> or vice versa?

That's defenitively a possible use case. In Android for example we
usually assign more resources to TOP_APP tasks (those belonging to the
application you are currently using) while we restrict the resoures
one we switch an app to be in BACKGROUND.

More in general, if you think about a generic Run-Time Resource
Management framework, which assign resources to the tasks of multiple
applications and want to have a fine grained control.

> If so, it is probably better to move the task from one cpuset of
> high-power cpus to another cpuset of low-power cpus.

This is what Android does not but also what we want to possible
change, for two main reasons:

1. it does not fit with the "number one guideline" for proper
   CGroups usage, which is "Organize Once and Control":
      https://elixir.bootlin.com/linux/latest/source/Documentation/cgroup-v2.txt#L518
   where it says that:
      migrating processes across cgroups frequently as a means to
      apply different resource restrictions is discouraged.

   Despite this giudeline, it turns out that in v1 at least, it seems
   to be faster to move tasks across cpusets then tuning cpuset
   attributes... also when all the tasks are sleeping.


2. it does not allow to get advantages for accounting controllers such
   as the memory controller where, by moving tasks around, we cannot
   properly account and control the amount of memory a task can use.

Thsu, for these reasons and also to possibly migrate to the unified
hierarchy schema proposed by CGroups v2... we would like a
low-overhead mechanism for setting/tuning cpuset at run-time with
whatever frequency you like.

> >> +
> >> +The "cpuset" controller is hierarchical.  That means the controller
> >> +cannot use CPUs or memory nodes not allowed in its parent.
> >> +
> >> +
> >> +Cpuset Interface Files
> >> +~~~~~~~~~~~~~~~~~~~~~~
> >> +
> >> +  cpuset.cpus
> >> +	A read-write multiple values file which exists on non-root
> >> +	cpuset-enabled cgroups.
> >> +
> >> +	It lists the CPUs allowed to be used by tasks within this
> >> +	cgroup.  The CPU numbers are comma-separated numbers or
> >> +	ranges.  For example:
> >> +
> >> +	  # cat cpuset.cpus
> >> +	  0-4,6,8-10
> >> +
> >> +	An empty value indicates that the cgroup is using the same
> >> +	setting as the nearest cgroup ancestor with a non-empty
> >> +	"cpuset.cpus" or all the available CPUs if none is found.
> > Does that means that we can move tasks into a newly created group for
> > which we have not yet configured this value?
> > AFAIK, that's a different behavior wrt v1... and I like it better.
> >
> 
> For v2, if you haven't set up the cpuset.cpus, it defaults to the
> effective cpu list of its parent.

+1

> 
> >> +
> >> +	The value of "cpuset.cpus" stays constant until the next update
> >> +	and won't be affected by any CPU hotplug events.
> > This also sounds interesting, does it means that we use the
> > cpuset.cpus mask to restrict online CPUs, whatever they are?
> 
> cpuset.cpus holds the cpu list written by the users.
> cpuset.cpus.effective is the actual cpu mask that is being used. The
> effective cpu mask is always a subset of cpuset.cpus. They differ if not
> all the CPUs in cpuset.cpus are online.

And that's fine: the effective mask is updated based on HP events.

The main limitations on this side, so far, is that in
update_tasks_cpumask() we walk all the tasks to set_cpus_allowed_ptr()
independently for them to be RUNNABLE or not. Isn't that?

Thus, this will ensure to have a valid mask at wakeup time, but
perhaps it's not such a big overhead to update the same on the wakeup
path... thus speeding up quite a lot the update_cpumasks_hier()
especially when you have many SLEEPING tasks on a cpuset.

A first measurement and tracing shows that this update could cost up
to 4ms on a Pixel2 device where you update the cpus for a cpuset
containing a single task always sleeping.

> > I'll have a better look at the code, but my understanding of v1 is
> > that we spent a lot of effort to keep task cpu-affinity masks aligned
> > with the cpuset in which they live, and we do something similar at each
> > HP event, which ultimately generates a lot of overheads in systems
> > where: you have many HP events and/or cpuset.cpus change quite
> > frequently.
> >
> > I hope to find some better behavior in this series.
> >
> 
> The behavior of CPU offline event should be similar in v2. Any HP event
> will cause the system to reset the cpu masks of task affected by the
> event. The online event, however, will be a bit different between v1 and
> v2. For v1, the online event won't restore the CPU back to those cpusets
> that had the onlined CPU previously. For v2, the v2, the online CPU will
> be restored back to those cpusets. So there is less work from the
> management layer, but overhead is still there in the kernel of doing the
> restore.

On that side, I still have to better look into the v1 and v2
implementations, but for the util_clamp extension of the cpu
controller:
   https://lkml.org/lkml/2018/4/9/601
I'm proposing a different update schema which it seems can give you
the benefits or "restoring the mask" after an UP event as well as a
fast update/tuning path at run-time.

Along the line of the above implementation, it would mean that the
task affinity mask is constrained/clamped/masked by the TG's affinity
mask. This should be an operation performed "on-demand" whenever it
makes sense.

However, to be honest, I never measured the overheads to combine two
cpu masks and it can very well be something overkilling for the wakeup
path. I don't think the AND by itself should be an issue, since it's
already used in the fast wakeup path, e.g.

   select_task_rq_fair()
      select_idle_sibling()
         select_idle_core()
            cpumask_and(cpus, sched_domain_span(sd),
                        &p->cpus_allowed);

What eventually could be an issue is the race between the scheduler
looking at the cpuset cpumaks and cgroups changing it... but perhaps
that's something could be fixed with a proper locking mechanism.

I will try to run some experiments to at least collect some overheads
numbers.


[...]

> >> @@ -2104,8 +2144,10 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
> >>  	.post_attach	= cpuset_post_attach,
> >>  	.bind		= cpuset_bind,
> >>  	.fork		= cpuset_fork,
> >> -	.legacy_cftypes	= files,
> >> +	.legacy_cftypes	= legacy_files,
> >> +	.dfl_cftypes	= dfl_files,
> >>  	.early_init	= true,
> >> +	.threaded	= true,
> > Which means that by default we can attach tasks instead of only
> > processes, right?
> 
> Yes, you can control task placement on the thread level, not just process.

+1

-- 
#include <best/regards.h>

Patrick Bellasi
