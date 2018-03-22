From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v6 2/2] cpuset: Add cpuset.sched_load_balance to v2
Date: Thu, 22 Mar 2018 17:50:48 -0400
Message-ID: <e754e128-0a93-800e-e71b-2c8dc316ba8a@redhat.com>
References: <1521649309-26690-1-git-send-email-longman@redhat.com>
 <1521649309-26690-3-git-send-email-longman@redhat.com>
 <20180322084120.GE7231@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180322084120.GE7231@localhost.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On 03/22/2018 04:41 AM, Juri Lelli wrote:
> Hi Waiman,
>
> On 21/03/18 12:21, Waiman Long wrote:
>> The sched_load_balance flag is needed to enable CPU isolation similar
>> to what can be done with the "isolcpus" kernel boot parameter.
>>
>> The sched_load_balance flag implies an implicit !cpu_exclusive as
>> it doesn't make sense to have an isolated CPU being load-balanced in
>> another cpuset.
>>
>> For v2, this flag is hierarchical and is inherited by child cpusets. It
>> is not allowed to have this flag turn off in a parent cpuset, but on
>> in a child cpuset.
>>
>> This flag is set by the parent and is not delegatable.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>  Documentation/cgroup-v2.txt | 22 ++++++++++++++++++
>>  kernel/cgroup/cpuset.c      | 56 +++++++++++++++++++++++++++++++++++++++------
>>  2 files changed, 71 insertions(+), 7 deletions(-)
>>
>> diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
>> index ed8ec66..c970bd7 100644
>> --- a/Documentation/cgroup-v2.txt
>> +++ b/Documentation/cgroup-v2.txt
>> @@ -1514,6 +1514,28 @@ Cpuset Interface Files
>>  	it is a subset of "cpuset.mems".  Its value will be affected
>>  	by memory nodes hotplug events.
>>  
>> +  cpuset.sched_load_balance
>> +	A read-write single value file which exists on non-root cgroups.
>> +	The default is "1" (on), and the other possible value is "0"
>> +	(off).
>> +
>> +	When it is on, tasks within this cpuset will be load-balanced
>> +	by the kernel scheduler.  Tasks will be moved from CPUs with
>> +	high load to other CPUs within the same cpuset with less load
>> +	periodically.
>> +
>> +	When it is off, there will be no load balancing among CPUs on
>> +	this cgroup.  Tasks will stay in the CPUs they are running on
>> +	and will not be moved to other CPUs.
>> +
>> +	This flag is hierarchical and is inherited by child cpusets. It
>> +	can be turned off only when the CPUs in this cpuset aren't
>> +	listed in the cpuset.cpus of other sibling cgroups, and all
>> +	the child cpusets, if present, have this flag turned off.
>> +
>> +	Once it is off, it cannot be turned back on as long as the
>> +	parent cgroup still has this flag in the off state.
>> +
> I'm afraid that this will not work for SCHED_DEADLINE (at least for how
> it is implemented today). As you can see in Documentation [1] the only
> way a user has to perform partitioned/clustered scheduling is to create
> subset of exclusive cpusets and then assign deadline tasks to them. The
> other thing to take into account here is that a root_domain is created
> for each exclusive set and we use such root_domain to keep information
> about admitted bandwidth and speed up load balancing decisions (there is
> a max heap tracking deadlines of active tasks on each root_domain).
> Now, AFAIR distinct root_domain(s) are created when parent group has
> sched_load_balance disabled and cpus_exclusive set (in cgroup v1 that
> is). So, what we normally do is create, say, cpus_exclusive groups for
> the different clusters and then disable sched_load_balance at root level
> (so that each cluster gets its own root_domain). Also,
> sched_load_balance is enabled in children groups (as load balancing
> inside clusters is what we actually needed :).

That looks like an undocumented side effect to me. I would rather see an
explicit control file that enable root_domain and break it free from
cpu_exclusive && !sched_load_balance, e.g. sched_root_domain(?).

> IIUC your proposal this will not be permitted with cgroup v2 because
> sched_load_balance won't be present at root level and children groups
> won't be able to set sched_load_balance back to 1 if that was set to 0
> in some parent. Is that true?

Yes, that is the current plan.

> Look, the way things work today is most probably not perfect (just to
> say one thing, we need to disable load balancing for all classes at root
> level just because DEADLINE wants to set restricted affinities to his
> tasks :/) and we could probably think on how to change how this all
> work. So, let's first see if IIUC what you are proposing (and its
> implications). :)
>
Cgroup v2 is supposed to allow us to have a fresh start to rethink what
is a more sane way of partitioning resources without worrying about
backward compatibility. So I think it is time to design a new way for
deadline tasks to work with cpuset v2.

Cheers,
Longman



