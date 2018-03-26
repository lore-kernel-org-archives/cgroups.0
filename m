From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v6 2/2] cpuset: Add cpuset.sched_load_balance to v2
Date: Mon, 26 Mar 2018 16:28:49 -0400
Message-ID: <bf79b45e-7716-65af-03ca-7112dc367371@redhat.com>
References: <1521649309-26690-1-git-send-email-longman@redhat.com>
 <1521649309-26690-3-git-send-email-longman@redhat.com>
 <20180322084120.GE7231@localhost.localdomain>
 <e754e128-0a93-800e-e71b-2c8dc316ba8a@redhat.com>
 <20180323075952.GA4763@localhost.localdomain>
 <a8860a42-31b5-4620-7b23-b7515ee11d7d@redhat.com>
 <20180326124711.GE5942@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180326124711.GE5942@localhost.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On 03/26/2018 08:47 AM, Juri Lelli wrote:
> On 23/03/18 14:44, Waiman Long wrote:
>> On 03/23/2018 03:59 AM, Juri Lelli wrote:
> [...]
>
>>> OK, thanks for confirming. Can you tell again however why do you think
>>> we need to remove sched_load_balance from root level? Won't we end up
>>> having tasks put on isolated sets?
>> The root cgroup is special that it owns all the resources in the system.
>> We generally don't want restriction be put on the root cgroup. A child
>> cgroup has to be created to have constraints put on it. In fact, most of
>> the controller files don't show up in the v2 cgroup root at all.
>>
>> An isolated cgroup has to be put under root, e.g.
>>
>>       Root
>>      /    \
>> isolated  balanced
>>
>>> Also, I guess children groups with more than one CPU will need to be
>>> able to load balance across their CPUs, no matter what their parent
>>> group does?
>> The purpose of an isolated cpuset is to have a dedicated set of CPUs to
>> be used by a certain application that makes its own scheduling decision
>> by placing tasks explicitly on specific CPUs. It just doesn't make sense
>> to have a CPU in an isolated cpuset to participated in load balancing in
>> another cpuset. If one want load balancing in a child cpuset, the parent
>> cpuset should have load balancing turned on as well.
> Isolated with CPUs overlapping some other cpuset makes little sense, I
> agree. What I have in mind however is an isolated set of CPUs that don't
> overlap with any other cpuset (as your balanced set above). In this case
> I think it makes sense to let the sys admin decide if "automatic" load
> balancing has to be performed (by the scheduler) or no load balacing at
> all has to take place?
>
> Further extending your example:
>
>              Root [0-3]
> 	     /        \
>         group1 [0-1] group2[2-3]
>
> Why should we prevent load balancing to be disabled at root level (so
> that for example tasks still residing in root group are not freely
> migrated around, potentially disturbing both sub-groups)?
>
> Then one can decide that group1 is a "userspace managed" group (no load
> balancing takes place) and group2 is balanced by the scheduler.
>
> And this is not DEADLINE specific, IMHO.
>
>> As I look into the code, it seems like root domain is probably somewhat
>> associated with cpu_exclusive only. Whether sched_load_balance is set
>> doesn't really matter.  I will need to look further on the conditions
>> where a new root domain is created.
> I checked again myself (sched domains code is always a maze :) and I
> believe that sched_load_balance flag indeed controls domains (sched and
> root) creation and configuration . Changing the flag triggers potential
> rebuild and separed sched/root domains are generated if subgroups have
> non overlapping cpumasks.  cpu_exclusive only enforces this latter
> condition.

Right, I ran some tests and figured out that to have root_domain in the
child cgroup level, we do need to disable load balancing at the root
cgroup level and enabling it in child cgroups that are mutually disjoint
in their cpu lists. The cpu_exclusive flag isn't really needed.

I am not against doing that at the root cgroup, but it is kind of weird
in term of semantics. If we disable load balancing in the root cgroup,
but enabling it at child cgroups, what does that mean to the processes
that are still in the root cgroup?

The sched_load_balance flag isn't something that is passed to the
scheduler. It only only affects the CPU topology of the system. So I
suspect that a process in the root cgroup will be load balanced among
the CPUs in the one of the child cgroups. That doesn't look right unless
we enforce that no process can be in the root cgroup in this case.

Real cpu isolation will then require that we disable load balancing at
root, and enable load balancing in child cgroups that only contain CPUs
outside of the isolated CPU list. Again, it is still possible that some
tasks in the root cgroup, if present, may be using some of the isolated
CPUs.

Maybe we can have a different root level flag, say,
sched_partition_domain that is equivalent to !sched_load_balnace.
However, I am still not sure if we should enforce that no task should be
in the root cgroup when the flag is set.

Tejun and Peter, what are your thoughts on this?

Cheers,
Longman

 

