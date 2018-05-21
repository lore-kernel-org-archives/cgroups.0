From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v8 1/6] cpuset: Enable cpuset controller in default
 hierarchy
Date: Mon, 21 May 2018 09:55:51 -0400
Message-ID: <fbc71cfc-6801-0fda-b0c6-2a70f7c9fe25@redhat.com>
References: <1526590545-3350-1-git-send-email-longman@redhat.com>
 <1526590545-3350-2-git-send-email-longman@redhat.com>
 <20180521115528.GR30654@e110439-lin>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180521115528.GR30654@e110439-lin>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>

On 05/21/2018 07:55 AM, Patrick Bellasi wrote:
> Hi Waiman!
>
> I've started looking at the possibility to move Android to use cgroups
> v2 and the availability of the cpuset controller makes this even more
> promising.
>
> I'll try to give a run to this series on Android, meanwhile I have
> some (hopefully not too much dummy) questions below.
>
> On 17-May 16:55, Waiman Long wrote:
>> Given the fact that thread mode had been merged into 4.14, it is now
>> time to enable cpuset to be used in the default hierarchy (cgroup v2)
>> as it is clearly threaded.
>>
>> The cpuset controller had experienced feature creep since its
>> introduction more than a decade ago. Besides the core cpus and mems
>> control files to limit cpus and memory nodes, there are a bunch of
>> additional features that can be controlled from the userspace. Some of
>> the features are of doubtful usefulness and may not be actively used.
>>
>> This patch enables cpuset controller in the default hierarchy with
>> a minimal set of features, namely just the cpus and mems and their
>> effective_* counterparts.  We can certainly add more features to the
>> default hierarchy in the future if there is a real user need for them
>> later on.
>>
>> Alternatively, with the unified hiearachy, it may make more sense
>> to move some of those additional cpuset features, if desired, to
>> memory controller or may be to the cpu controller instead of staying
>> with cpuset.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>  Documentation/cgroup-v2.txt | 90 ++++++++++++++++++++++++++++++++++++++++++---
>>  kernel/cgroup/cpuset.c      | 48 ++++++++++++++++++++++--
>>  2 files changed, 130 insertions(+), 8 deletions(-)
>>
>> diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
>> index 74cdeae..cf7bac6 100644
>> --- a/Documentation/cgroup-v2.txt
>> +++ b/Documentation/cgroup-v2.txt
>> @@ -53,11 +53,13 @@ v1 is available under Documentation/cgroup-v1/.
>>         5-3-2. Writeback
>>       5-4. PID
>>         5-4-1. PID Interface Files
>> -     5-5. Device
>> -     5-6. RDMA
>> -       5-6-1. RDMA Interface Files
>> -     5-7. Misc
>> -       5-7-1. perf_event
>> +     5-5. Cpuset
>> +       5.5-1. Cpuset Interface Files
>> +     5-6. Device
>> +     5-7. RDMA
>> +       5-7-1. RDMA Interface Files
>> +     5-8. Misc
>> +       5-8-1. perf_event
>>       5-N. Non-normative information
>>         5-N-1. CPU controller root cgroup process behaviour
>>         5-N-2. IO controller root cgroup process behaviour
>> @@ -1435,6 +1437,84 @@ through fork() or clone(). These will return -EAGAIN if the creation
>>  of a new process would cause a cgroup policy to be violated.
>>  
>>  
>> +Cpuset
>> +------
>> +
>> +The "cpuset" controller provides a mechanism for constraining
>> +the CPU and memory node placement of tasks to only the resources
>> +specified in the cpuset interface files in a task's current cgroup.
>> +This is especially valuable on large NUMA systems where placing jobs
>> +on properly sized subsets of the systems with careful processor and
>> +memory placement to reduce cross-node memory access and contention
>> +can improve overall system performance.
> Another quite important use-case for cpuset is Android, where they are
> actively used to do both power-saving as well as performance tunings.
> For example, depending on the status of an application, its threads
> can be allowed to run on all available CPUS (e.g. foreground apps) or
> be restricted only on few energy efficient CPUs (e.g. backgroud apps).
>
> Since here we are at "rewriting" cpusets for v2, I think it's important
> to keep this mobile world scenario into consideration.
>
> For example, in this context, we are looking at the possibility to
> update/tune cpuset.cpus with a relatively high rate, i.e. tens of
> times per second. Not sure that's the same update rate usually
> required for the large NUMA systems you cite above.  However, in this
> case it's quite important to have really small overheads for these
> operations.

The cgroup interface isn't designed for high update throughput. Changing
cpuset.cpus will require searching for the all the tasks in the cpuset
and change its cpu mask. That isn't a fast operation, but it shouldn't
be too bad either depending on how many tasks are in the cpuset.

I would not suggest doing rapid changes to cpuset.cpus as a mean to tune
the behavior of a task. So what exactly is the tuning you are thinking
about? Is it moving a task from the a high-power cpu to a low power one
or vice versa? If so, it is probably better to move the task from one
cpuset of high-power cpus to another cpuset of low-power cpus.

>> +
>> +The "cpuset" controller is hierarchical.  That means the controller
>> +cannot use CPUs or memory nodes not allowed in its parent.
>> +
>> +
>> +Cpuset Interface Files
>> +~~~~~~~~~~~~~~~~~~~~~~
>> +
>> +  cpuset.cpus
>> +	A read-write multiple values file which exists on non-root
>> +	cpuset-enabled cgroups.
>> +
>> +	It lists the CPUs allowed to be used by tasks within this
>> +	cgroup.  The CPU numbers are comma-separated numbers or
>> +	ranges.  For example:
>> +
>> +	  # cat cpuset.cpus
>> +	  0-4,6,8-10
>> +
>> +	An empty value indicates that the cgroup is using the same
>> +	setting as the nearest cgroup ancestor with a non-empty
>> +	"cpuset.cpus" or all the available CPUs if none is found.
> Does that means that we can move tasks into a newly created group for
> which we have not yet configured this value?
> AFAIK, that's a different behavior wrt v1... and I like it better.
>

For v2, if you haven't set up the cpuset.cpus, it defaults to the
effective cpu list of its parent.

>> +
>> +	The value of "cpuset.cpus" stays constant until the next update
>> +	and won't be affected by any CPU hotplug events.
> This also sounds interesting, does it means that we use the
> cpuset.cpus mask to restrict online CPUs, whatever they are?

cpuset.cpus holds the cpu list written by the users.
cpuset.cpus.effective is the actual cpu mask that is being used. The
effective cpu mask is always a subset of cpuset.cpus. They differ if not
all the CPUs in cpuset.cpus are online.
> I'll have a better look at the code, but my understanding of v1 is
> that we spent a lot of effort to keep task cpu-affinity masks aligned
> with the cpuset in which they live, and we do something similar at each
> HP event, which ultimately generates a lot of overheads in systems
> where: you have many HP events and/or cpuset.cpus change quite
> frequently.
>
> I hope to find some better behavior in this series.
>

The behavior of CPU offline event should be similar in v2. Any HP event
will cause the system to reset the cpu masks of task affected by the
event. The online event, however, will be a bit different between v1 and
v2. For v1, the online event won't restore the CPU back to those cpusets
that had the onlined CPU previously. For v2, the v2, the online CPU will
be restored back to those cpusets. So there is less work from the
management layer, but overhead is still there in the kernel of doing the
restore.

>> +
>> +  cpuset.cpus.effective
>> +	A read-only multiple values file which exists on non-root
>> +	cpuset-enabled cgroups.
>> +
>> +	It lists the onlined CPUs that are actually allowed to be
>> +	used by tasks within the current cgroup.  If "cpuset.cpus"
>> +	is empty, it shows all the CPUs from the parent cgroup that
>> +	will be available to be used by this cgroup.  Otherwise, it is
>> +	a subset of "cpuset.cpus".  Its value will be affected by CPU
>> +	hotplug events.
> This looks similar to v1, isn't it?

For v1, cpuset.cpus.effective is the same as cpuset.cpus unless you turn
on the v2 mode when mounting the v1 cpuset. For v2, they differ. Please
see the explanation above.

>> +
>> +  cpuset.mems
>> +	A read-write multiple values file which exists on non-root
>> +	cpuset-enabled cgroups.
>> +
>> +	It lists the memory nodes allowed to be used by tasks within
>> +	this cgroup.  The memory node numbers are comma-separated
>> +	numbers or ranges.  For example:
>> +
>> +	  # cat cpuset.mems
>> +	  0-1,3
>> +
>> +	An empty value indicates that the cgroup is using the same
>> +	setting as the nearest cgroup ancestor with a non-empty
>> +	"cpuset.mems" or all the available memory nodes if none
>> +	is found.
>> +
>> +	The value of "cpuset.mems" stays constant until the next update
>> +	and won't be affected by any memory nodes hotplug events.
>> +
>> +  cpuset.mems.effective
>> +	A read-only multiple values file which exists on non-root
>> +	cpuset-enabled cgroups.
>> +
>> +	It lists the onlined memory nodes that are actually allowed to
>> +	be used by tasks within the current cgroup.  If "cpuset.mems"
>> +	is empty, it shows all the memory nodes from the parent cgroup
>> +	that will be available to be used by this cgroup.  Otherwise,
>> +	it is a subset of "cpuset.mems".  Its value will be affected
>> +	by memory nodes hotplug events.
>> +
>> +
>>  Device controller
>>  -----------------
>>  
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index b42037e..419b758 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1823,12 +1823,11 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
>>  	return 0;
>>  }
>>  
>> -
>>  /*
>>   * for the common functions, 'private' gives the type of file
>>   */
>>  
>> -static struct cftype files[] = {
>> +static struct cftype legacy_files[] = {
>>  	{
>>  		.name = "cpus",
>>  		.seq_show = cpuset_common_seq_show,
>> @@ -1931,6 +1930,47 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
>>  };
>>  
>>  /*
>> + * This is currently a minimal set for the default hierarchy. It can be
>> + * expanded later on by migrating more features and control files from v1.
>> + */
>> +static struct cftype dfl_files[] = {
>> +	{
>> +		.name = "cpus",
>> +		.seq_show = cpuset_common_seq_show,
>> +		.write = cpuset_write_resmask,
>> +		.max_write_len = (100U + 6 * NR_CPUS),
>> +		.private = FILE_CPULIST,
>> +		.flags = CFTYPE_NOT_ON_ROOT,
>> +	},
>> +
>> +	{
>> +		.name = "mems",
>> +		.seq_show = cpuset_common_seq_show,
>> +		.write = cpuset_write_resmask,
>> +		.max_write_len = (100U + 6 * MAX_NUMNODES),
>> +		.private = FILE_MEMLIST,
>> +		.flags = CFTYPE_NOT_ON_ROOT,
>> +	},
>> +
>> +	{
>> +		.name = "cpus.effective",
>> +		.seq_show = cpuset_common_seq_show,
>> +		.private = FILE_EFFECTIVE_CPULIST,
>> +		.flags = CFTYPE_NOT_ON_ROOT,
>> +	},
>> +
>> +	{
>> +		.name = "mems.effective",
>> +		.seq_show = cpuset_common_seq_show,
>> +		.private = FILE_EFFECTIVE_MEMLIST,
>> +		.flags = CFTYPE_NOT_ON_ROOT,
>> +	},
>> +
>> +	{ }	/* terminate */
>> +};
>> +
>> +
>> +/*
>>   *	cpuset_css_alloc - allocate a cpuset css
>>   *	cgrp:	control group that the new cpuset will be part of
>>   */
>> @@ -2104,8 +2144,10 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
>>  	.post_attach	= cpuset_post_attach,
>>  	.bind		= cpuset_bind,
>>  	.fork		= cpuset_fork,
>> -	.legacy_cftypes	= files,
>> +	.legacy_cftypes	= legacy_files,
>> +	.dfl_cftypes	= dfl_files,
>>  	.early_init	= true,
>> +	.threaded	= true,
> Which means that by default we can attach tasks instead of only
> processes, right?

Yes, you can control task placement on the thread level, not just process.

Regards,
Longman

