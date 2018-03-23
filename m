From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v6 2/2] cpuset: Add cpuset.sched_load_balance to v2
Date: Fri, 23 Mar 2018 14:44:22 -0400
Message-ID: <a8860a42-31b5-4620-7b23-b7515ee11d7d@redhat.com>
References: <1521649309-26690-1-git-send-email-longman@redhat.com>
 <1521649309-26690-3-git-send-email-longman@redhat.com>
 <20180322084120.GE7231@localhost.localdomain>
 <e754e128-0a93-800e-e71b-2c8dc316ba8a@redhat.com>
 <20180323075952.GA4763@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180323075952.GA4763@localhost.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On 03/23/2018 03:59 AM, Juri Lelli wrote:
> On 22/03/18 17:50, Waiman Long wrote:
>> On 03/22/2018 04:41 AM, Juri Lelli wrote:
>>> On 21/03/18 12:21, Waiman Long wrote:
> [...]
>
>>>> +  cpuset.sched_load_balance
>>>> +	A read-write single value file which exists on non-root cgroups.
>>>> +	The default is "1" (on), and the other possible value is "0"
>>>> +	(off).
>>>> +
>>>> +	When it is on, tasks within this cpuset will be load-balanced
>>>> +	by the kernel scheduler.  Tasks will be moved from CPUs with
>>>> +	high load to other CPUs within the same cpuset with less load
>>>> +	periodically.
>>>> +
>>>> +	When it is off, there will be no load balancing among CPUs on
>>>> +	this cgroup.  Tasks will stay in the CPUs they are running on
>>>> +	and will not be moved to other CPUs.
>>>> +
>>>> +	This flag is hierarchical and is inherited by child cpusets. It
>>>> +	can be turned off only when the CPUs in this cpuset aren't
>>>> +	listed in the cpuset.cpus of other sibling cgroups, and all
>>>> +	the child cpusets, if present, have this flag turned off.
>>>> +
>>>> +	Once it is off, it cannot be turned back on as long as the
>>>> +	parent cgroup still has this flag in the off state.
>>>> +
>>> I'm afraid that this will not work for SCHED_DEADLINE (at least for how
>>> it is implemented today). As you can see in Documentation [1] the only
>>> way a user has to perform partitioned/clustered scheduling is to create
>>> subset of exclusive cpusets and then assign deadline tasks to them. The
>>> other thing to take into account here is that a root_domain is created
>>> for each exclusive set and we use such root_domain to keep information
>>> about admitted bandwidth and speed up load balancing decisions (there is
>>> a max heap tracking deadlines of active tasks on each root_domain).
>>> Now, AFAIR distinct root_domain(s) are created when parent group has
>>> sched_load_balance disabled and cpus_exclusive set (in cgroup v1 that
>>> is). So, what we normally do is create, say, cpus_exclusive groups for
>>> the different clusters and then disable sched_load_balance at root level
>>> (so that each cluster gets its own root_domain). Also,
>>> sched_load_balance is enabled in children groups (as load balancing
>>> inside clusters is what we actually needed :).
>> That looks like an undocumented side effect to me. I would rather see an
>> explicit control file that enable root_domain and break it free from
>> cpu_exclusive && !sched_load_balance, e.g. sched_root_domain(?).
> Mmm, it actually makes some sort of sense to me that as long as parent
> groups can't load balance (because !sched_load_balance) and this group
> can't have CPUs overlapping with some other group (because
> cpu_exclusive) a data structure (root_domain) is created to handle load
> balancing for this isolated subsystem. I agree that it should be better
> documented, though.

Yes, this need to be documented.

>>> IIUC your proposal this will not be permitted with cgroup v2 because
>>> sched_load_balance won't be present at root level and children groups
>>> won't be able to set sched_load_balance back to 1 if that was set to 0
>>> in some parent. Is that true?
>> Yes, that is the current plan.
> OK, thanks for confirming. Can you tell again however why do you think
> we need to remove sched_load_balance from root level? Won't we end up
> having tasks put on isolated sets?

The root cgroup is special that it owns all the resources in the system.
We generally don't want restriction be put on the root cgroup. A child
cgroup has to be created to have constraints put on it. In fact, most of
the controller files don't show up in the v2 cgroup root at all.

An isolated cgroup has to be put under root, e.g.

      Root
     /    \
isolated  balanced

>
> Also, I guess children groups with more than one CPU will need to be
> able to load balance across their CPUs, no matter what their parent
> group does?

The purpose of an isolated cpuset is to have a dedicated set of CPUs to
be used by a certain application that makes its own scheduling decision
by placing tasks explicitly on specific CPUs. It just doesn't make sense
to have a CPU in an isolated cpuset to participated in load balancing in
another cpuset. If one want load balancing in a child cpuset, the parent
cpuset should have load balancing turned on as well.

As I look into the code, it seems like root domain is probably somewhat
associated with cpu_exclusive only. Whether sched_load_balance is set
doesn't really matter.  I will need to look further on the conditions
where a new root domain is created.

BTW, there is always a default root domain for the root. So you don't
really need to do anything special for the root cpuset to make one.

Cheers,
Longman

It just doesn't make sense to have a CPU in both an isolated CPU set


