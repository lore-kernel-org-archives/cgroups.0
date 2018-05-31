From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v9 3/7] cpuset: Add cpuset.sched.load_balance flag to v2
Date: Thu, 31 May 2018 09:54:27 -0400
Message-ID: <42cc1f44-2355-1c0c-b575-49c863303c42@redhat.com>
References: <1527601294-3444-1-git-send-email-longman@redhat.com>
 <1527601294-3444-4-git-send-email-longman@redhat.com>
 <20180531122638.GJ12180@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180531122638.GJ12180@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Thomas Gleixner <tglx@linutronix.de>

On 05/31/2018 08:26 AM, Peter Zijlstra wrote:
> On Tue, May 29, 2018 at 09:41:30AM -0400, Waiman Long wrote:
>> The sched.load_balance flag is needed to enable CPU isolation similar to
>> what can be done with the "isolcpus" kernel boot parameter. Its value
>> can only be changed in a scheduling domain with no child cpusets. On
>> a non-scheduling domain cpuset, the value of sched.load_balance is
>> inherited from its parent. This is to make sure that all the cpusets
>> within the same scheduling domain or partition has the same load
>> balancing state.
>>
>> This flag is set by the parent and is not delegatable.
>> +  cpuset.sched.domain_root
>> +	A read-write single value file which exists on non-root
>> +	cpuset-enabled cgroups.  It is a binary value flag that accepts
>> +	either "0" (off) or "1" (on).  This flag is set by the parent
>> +	and is not delegatable.
>> +
>> +	If set, it indicates that the current cgroup is the root of a
>> +	new scheduling domain or partition that comprises itself and
>> +	all its descendants except those that are scheduling domain
>> +	roots themselves and their descendants.  The root cgroup is
>> +	always a scheduling domain root.
>> +
>> +	There are constraints on where this flag can be set.  It can
>> +	only be set in a cgroup if all the following conditions are true.
>> +
>> +	1) The "cpuset.cpus" is not empty and the list of CPUs are
>> +	   exclusive, i.e. they are not shared by any of its siblings.
>> +	2) The parent cgroup is also a scheduling domain root.
>> +	3) There is no child cgroups with cpuset enabled.  This is
>> +	   for eliminating corner cases that have to be handled if such
>> +	   a condition is allowed.
>> +
>> +	Setting this flag will take the CPUs away from the effective
>> +	CPUs of the parent cgroup.  Once it is set, this flag cannot
>> +	be cleared if there are any child cgroups with cpuset enabled.
>> +	Further changes made to "cpuset.cpus" is allowed as long as
>> +	the first condition above is still true.
>> +
>> +	A parent scheduling domain root cgroup cannot distribute all
>> +	its CPUs to its child scheduling domain root cgroups unless
>> +	its load balancing flag is turned off.
>> +
>> +  cpuset.sched.load_balance
>> +	A read-write single value file which exists on non-root
>> +	cpuset-enabled cgroups.  It is a binary value flag that accepts
>> +	either "0" (off) or "1" (on).  This flag is set by the parent
>> +	and is not delegatable.  It is on by default in the root cgroup.
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
>> +	The load balancing state of a cgroup can only be changed on a
>> +	scheduling domain root cgroup with no cpuset-enabled children.
>> +	All cgroups within a scheduling domain or partition must have
>> +	the same load balancing state.	As descendant cgroups of a
>> +	scheduling domain root are created, they inherit the same load
>> +	balancing state of their root.
> I still find all that a bit weird.
>
> So load_balance=0 basically changes a partition into a
> 'fully-partitioned partition' with the seemingly random side-effect that
> now sub-partitions are allowed to consume all CPUs.

Are you suggesting that we should allow sub-partition to consume all the
CPUs no matter the load balance state? I can live with that if you think
it is more logical.

> The rationale, only given in the Changelog above, seems to be to allow
> 'easy' emulation of isolcpus.
>
> I'm still not convinced this is a useful knob to have. You can do
> fully-partitioned by simply creating a lot of 1 cpu parititions.

That is certainly true. However, I think there are some additional
overhead in the scheduler side in maintaining those 1-cpu partitions. Right?

> So this one knob does two separate things, both of which seem, to me,
> redundant.
>
> Can we please get better rationale for this?

I am fine getting rid of the load_balance flag if this is the consensus.
However, we do need to come up with a good migration story for those
users that need the isolcpus capability. I think Mike was the one asking
for supporting isolcpus. So Mike, what is your take on that.

Cheers,
Longman


