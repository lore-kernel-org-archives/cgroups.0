From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v8 1/6] cpuset: Enable cpuset controller in default
 hierarchy
Date: Mon, 21 May 2018 12:10:47 -0400
Message-ID: <80841a12-6f82-91ae-8925-3092398efe32@redhat.com>
References: <1526590545-3350-1-git-send-email-longman@redhat.com>
 <1526590545-3350-2-git-send-email-longman@redhat.com>
 <20180521115528.GR30654@e110439-lin>
 <fbc71cfc-6801-0fda-b0c6-2a70f7c9fe25@redhat.com>
 <20180521150924.GS30654@e110439-lin>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180521150924.GS30654@e110439-lin>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>

On 05/21/2018 11:09 AM, Patrick Bellasi wrote:
> On 21-May 09:55, Waiman Long wrote:
>
>> Changing cpuset.cpus will require searching for the all the tasks in
>> the cpuset and change its cpu mask.
> ... I'm wondering if that has to be the case. In principle there can
> be a different solution which is: update on demand. In the wakeup
> path, once we know a task really need a CPU and we want to find one
> for it, at that point we can align the cpuset mask with the task's
> one. Sort of using the cpuset mask as a clamp on top of the task's
> affinity mask.
>
> The main downside of such an approach could be the overheads in the
> wakeup path... but, still... that should be measured.
> The advantage is that we do not spend time changing attributes of
> tassk which, potentially, could be sleeping for a long time.

We already have a linked list of tasks in a cgroup. So it isn't too hard
to find them. Doing update on demand will require adding a bunch of code
to the wakeup path. So unless there is a good reason to do it, I don't
it as necessary at this point.

>
>> That isn't a fast operation, but it shouldn't be too bad either
>> depending on how many tasks are in the cpuset.
> Indeed, althought it still seems a bit odd and overkilling updating
> task affinity for tasks which are not currently RUNNABLE. Isn't it?
>
>> I would not suggest doing rapid changes to cpuset.cpus as a mean to tune
>> the behavior of a task. So what exactly is the tuning you are thinking
>> about? Is it moving a task from the a high-power cpu to a low power one
>> or vice versa?
> That's defenitively a possible use case. In Android for example we
> usually assign more resources to TOP_APP tasks (those belonging to the
> application you are currently using) while we restrict the resoures
> one we switch an app to be in BACKGROUND.

Switching an app from foreground to background and vice versa shouldn't
happen that frequently. Maybe once every few seconds, at most. I am just
wondering what use cases will require changing cpuset attributes in tens
per second.

> More in general, if you think about a generic Run-Time Resource
> Management framework, which assign resources to the tasks of multiple
> applications and want to have a fine grained control.
>
>> If so, it is probably better to move the task from one cpuset of
>> high-power cpus to another cpuset of low-power cpus.
> This is what Android does not but also what we want to possible
> change, for two main reasons:
>
> 1. it does not fit with the "number one guideline" for proper
>    CGroups usage, which is "Organize Once and Control":
>       https://elixir.bootlin.com/linux/latest/source/Documentation/cgroup-v2.txt#L518
>    where it says that:
>       migrating processes across cgroups frequently as a means to
>       apply different resource restrictions is discouraged.
>
>    Despite this giudeline, it turns out that in v1 at least, it seems
>    to be faster to move tasks across cpusets then tuning cpuset
>    attributes... also when all the tasks are sleeping.

It is probably similar in v2 as the core logic are almost the same.

> 2. it does not allow to get advantages for accounting controllers such
>    as the memory controller where, by moving tasks around, we cannot
>    properly account and control the amount of memory a task can use.

For v1, memory controller and cpuset controller can be in different
hierarchy. For v2, we have a unified hierarchy. However, we don't need
to enable all the controllers in different levels of the hierarchy. For
example,

    A (memory, cpuset) -- B1 (cpuset)
                \-- B2 (cpuset)

Cgroup A has memory and cpuset controllers enabled. The child cgroups B1
and B2 only have cpuset enabled. You can move tasks between B1 and B2
and they will be subjected to the same memory limitation as imposed by
the memory controller in A. So there are way to work around that.

> Thsu, for these reasons and also to possibly migrate to the unified
> hierarchy schema proposed by CGroups v2... we would like a
> low-overhead mechanism for setting/tuning cpuset at run-time with
> whatever frequency you like.

We may be able to improve the performance of changing cpuset attribute
somewhat, but I don't believe there will be much improvement here.

>>>> +
>>>> +The "cpuset" controller is hierarchical.  That means the controller
>>>> +cannot use CPUs or memory nodes not allowed in its parent.
>>>> +
>>>> +
>>>> +Cpuset Interface Files
>>>> +~~~~~~~~~~~~~~~~~~~~~~
>>>> +
>>>> +  cpuset.cpus
>>>> +	A read-write multiple values file which exists on non-root
>>>> +	cpuset-enabled cgroups.
>>>> +
>>>> +	It lists the CPUs allowed to be used by tasks within this
>>>> +	cgroup.  The CPU numbers are comma-separated numbers or
>>>> +	ranges.  For example:
>>>> +
>>>> +	  # cat cpuset.cpus
>>>> +	  0-4,6,8-10
>>>> +
>>>> +	An empty value indicates that the cgroup is using the same
>>>> +	setting as the nearest cgroup ancestor with a non-empty
>>>> +	"cpuset.cpus" or all the available CPUs if none is found.
>>> Does that means that we can move tasks into a newly created group for
>>> which we have not yet configured this value?
>>> AFAIK, that's a different behavior wrt v1... and I like it better.
>>>
>> For v2, if you haven't set up the cpuset.cpus, it defaults to the
>> effective cpu list of its parent.
> +1
>
>>>> +
>>>> +	The value of "cpuset.cpus" stays constant until the next update
>>>> +	and won't be affected by any CPU hotplug events.
>>> This also sounds interesting, does it means that we use the
>>> cpuset.cpus mask to restrict online CPUs, whatever they are?
>> cpuset.cpus holds the cpu list written by the users.
>> cpuset.cpus.effective is the actual cpu mask that is being used. The
>> effective cpu mask is always a subset of cpuset.cpus. They differ if not
>> all the CPUs in cpuset.cpus are online.
> And that's fine: the effective mask is updated based on HP events.
>
> The main limitations on this side, so far, is that in
> update_tasks_cpumask() we walk all the tasks to set_cpus_allowed_ptr()
> independently for them to be RUNNABLE or not. Isn't that?

That is true.

> Thus, this will ensure to have a valid mask at wakeup time, but
> perhaps it's not such a big overhead to update the same on the wakeup
> path... thus speeding up quite a lot the update_cpumasks_hier()
> especially when you have many SLEEPING tasks on a cpuset.
>
> A first measurement and tracing shows that this update could cost up
> to 4ms on a Pixel2 device where you update the cpus for a cpuset
> containing a single task always sleeping.

The 4ms cost is more than what I would have expected. If you think
delaying the update until wakeup time is the right move, you can create
a patch to do that and we can discuss the merit of doing so in LKML.

>
>>> I'll have a better look at the code, but my understanding of v1 is
>>> that we spent a lot of effort to keep task cpu-affinity masks aligned
>>> with the cpuset in which they live, and we do something similar at each
>>> HP event, which ultimately generates a lot of overheads in systems
>>> where: you have many HP events and/or cpuset.cpus change quite
>>> frequently.
>>>
>>> I hope to find some better behavior in this series.
>>>
>> The behavior of CPU offline event should be similar in v2. Any HP event
>> will cause the system to reset the cpu masks of task affected by the
>> event. The online event, however, will be a bit different between v1 and
>> v2. For v1, the online event won't restore the CPU back to those cpusets
>> that had the onlined CPU previously. For v2, the v2, the online CPU will
>> be restored back to those cpusets. So there is less work from the
>> management layer, but overhead is still there in the kernel of doing the
>> restore.
> On that side, I still have to better look into the v1 and v2
> implementations, but for the util_clamp extension of the cpu
> controller:
>    https://lkml.org/lkml/2018/4/9/601
> I'm proposing a different update schema which it seems can give you
> the benefits or "restoring the mask" after an UP event as well as a
> fast update/tuning path at run-time.
>
> Along the line of the above implementation, it would mean that the
> task affinity mask is constrained/clamped/masked by the TG's affinity
> mask. This should be an operation performed "on-demand" whenever it
> makes sense.
>
> However, to be honest, I never measured the overheads to combine two
> cpu masks and it can very well be something overkilling for the wakeup
> path. I don't think the AND by itself should be an issue, since it's
> already used in the fast wakeup path, e.g.
>
>    select_task_rq_fair()
>       select_idle_sibling()
>          select_idle_core()
>             cpumask_and(cpus, sched_domain_span(sd),
>                         &p->cpus_allowed);
>
> What eventually could be an issue is the race between the scheduler
> looking at the cpuset cpumaks and cgroups changing it... but perhaps
> that's something could be fixed with a proper locking mechanism.
>
> I will try to run some experiments to at least collect some overheads
> numbers.
Collecting more information on where the slowdown is will be helpful.

-Longman

