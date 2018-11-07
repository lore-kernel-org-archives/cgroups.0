From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v14 10/12] cpuset: Add documentation about the new
 "cpuset.sched.partition" flag
Date: Wed, 7 Nov 2018 17:58:58 -0500
Message-ID: <7f71f746-582b-42d0-11f1-e690ab4d94b0@redhat.com>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
 <1539635377-22335-11-git-send-email-longman@redhat.com>
 <20181106115045.GO22431@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181106115045.GO22431@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

On 11/06/2018 06:50 AM, Peter Zijlstra wrote:
> On Mon, Oct 15, 2018 at 04:29:35PM -0400, Waiman Long wrote:
>> The cgroup-v2.rst file is updated to document the purpose of the new
>> "cpuset.sched.partition" flag and how its usage.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>  Documentation/admin-guide/cgroup-v2.rst | 66 +++++++++++++++++++++++++
>>  1 file changed, 66 insertions(+)
>>
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>> index 533e85cb851b..178cda473a26 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -1686,6 +1686,72 @@ Cpuset Interface Files
>>  
>>  	Its value will be affected by memory nodes hotplug events.
>>  
>> +  cpuset.sched.partition
>> +	A read-write single value file which exists on non-root
>> +	cpuset-enabled cgroups.  It accepts either "0" (off) or "1"
>> +	(on) when written to.  
>> +     This flag is set and owned by the
>> +	parent cgroup.
> What does that mean? The parent cgroup doesn't 'set' anything at all.
> The user will.
>
>> +
>> +	If set, it indicates that the current cgroup is the root of a
>> +	new partition or scheduling domain that comprises itself and
>> +	all its descendants except those that are separate partition
>> +	roots themselves and their descendants.  The root cgroup is
>> +	always a partition root.
>> +
>> +	There are constraints on where this flag can be set.  It can
>> +	only be set in a cgroup if all the following conditions are true.
>> +
>> +	1) The "cpuset.cpus" is not empty and the list of CPUs are
>> +	   exclusive, i.e. they are not shared by any of its siblings.
>> +	2) The parent cgroup is a partition root.
>> +	3) The "cpuset.cpus" is also a proper subset of the parent's
>> +	   "cpuset.cpus.effective".
>> +	4) There is no child cgroups with cpuset enabled.  This is for
>> +	   eliminating corner cases that have to be handled if such a
>> +	   condition is allowed.
>> +
>> +	Setting this flag will take the CPUs away from the effective
>> +	CPUs of the parent cgroup.  Once it is set, this flag cannot
>> +	be cleared if there are any child cgroups with cpuset enabled.
>> +
>> +	A parent partition cannot distribute all its CPUs to its
>> +	child partitions.  There must be at least one cpu left in the
>> +	parent partition.
>> +
>> +	Once becoming a partition root, changes to "cpuset.cpus" is
>> +	generally allowed as long as the first condition above is true,
>> +	the change will not take away all the CPUs from the parent
>> +	partition and the new "cpuset.cpus" value is a superset of its
>> +	children's "cpuset.cpus" values.
>> +	Sometimes, external factors like changes to ancestors'
>> +	"cpuset.cpus" or cpu hotplug can cause the state of the partition
>> +	root to change.  On read, the "cpuset.sched.partition" file
>> +	can show the following values.
> Are those the only conditions under which that -1 can happen? Parent
> taking away CPUs it previously granted and hotplug?

Yes, if none of the cpus are available. It will become invalid. It still
remains a partition (a partial one) if at least one cpu is allocated to
that partition.

>> +
>> +	"0"  Not a partition root
>> +	"1"  Partition root
>> +	"-1" Erroneous partition root
>> +
>> +	It is a partition root if the first 2 partition root conditions
>> +	above are true and at least one CPU from "cpuset.cpus" is
>> +	granted by the parent cgroup.
>> +
>> +	A partition root can become an erroneous partition root if none
>> +	of CPUs requested in "cpuset.cpus" can be granted by the parent
>> +	cgroup or the parent cgroup is no longer a partition root.
>> +	In this case, it is not a real partition even though the
>> +	restriction of the first partition root condition above will
>> +	still apply.  All the tasks in the cgroup will be migrated to
>> +	the nearest ancestor partition.
> Effectively or actual? Actual migrating tasks out of the cgroup is
> irreversible.

I am not talking about actual migration to a different cgroup. I am
talking moving to a different partition. When a partition become
invalid, it will inherent the partition parent's effective cpumask.

>> +	An erroneous partition root can be transitioned back to a real
>> +	partition root if at least one of the requested CPUs can now be
>> +	granted by its parent.	In this case, the tasks will be migrated
>> +	back to the newly created partition.  Clearing the partition
>> +	flag of an erroneous partition root is always allowed even if
>> +	child cpusets are present.
> So you need to clarify the above point (I think it is effectively),
> because otherwise you don't know which tasks to put back.

I will clarify that.

Thanks,
Longman

