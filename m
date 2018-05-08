From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v7 3/5] cpuset: Add a root-only cpus.isolated v2 control
 file
Date: Mon, 7 May 2018 20:30:02 -0400
Message-ID: <04f33505-1256-461e-917c-175869d6dd24@redhat.com>
References: <1524145624-23655-1-git-send-email-longman@redhat.com>
 <1524145624-23655-4-git-send-email-longman@redhat.com>
 <20180502140835.GK12180@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502140835.GK12180@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>

On 05/02/2018 10:08 AM, Peter Zijlstra wrote:
> On Thu, Apr 19, 2018 at 09:47:02AM -0400, Waiman Long wrote:
>> diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
>> index c970bd7..8d89dc2 100644
>> --- a/Documentation/cgroup-v2.txt
>> +++ b/Documentation/cgroup-v2.txt
>> @@ -1484,6 +1484,31 @@ Cpuset Interface Files
>>  	a subset of "cpuset.cpus".  Its value will be affected by CPU
>>  	hotplug events.
>>  
>> +  cpuset.cpus.isolated
>> +	A read-write multiple values file which exists on root cgroup
>> +	only.
>> +
>> +	It lists the CPUs that have been withdrawn from the root cgroup
>> +	for load balancing.  These CPUs can still be allocated to child
>> +	cpusets with load balancing enabled, if necessary.
>> +
>> +	If a child cpuset contains only an exclusive set of CPUs that are
>> +	a subset of the isolated CPUs and with load balancing enabled,
>> +	these CPUs will be load balanced on a separate root domain from
>> +	the one in the root cgroup.
>> +
>> +	Just putting the CPUs into "cpuset.cpus.isolated" will be
>> +	enough to disable load balancing on those CPUs as long as they
>> +	do not appear in a child cpuset with load balancing enabled.
>> +	Fine-grained control of cpu isolation can also be done by
>> +	putting these isolated CPUs into child cpusets with load
>> +	balancing disabled.
>> +
>> +	The "cpuset.cpus.isolated" should be set up before child
>> +	cpusets are created.  Once child cpusets are present, changes
>> +	to "cpuset.cpus.isolated" will not be allowed if the CPUs that
>> +	change their states are in any of the child cpusets.
>> +
> So I see why you did this, but it is _really_ ugly and breaks the
> container invariant.
>
> Ideally we'd make the root group less special, not more special.

Yes, I am planning to make the root cgroup less special by putting a new
isolation flag into all the non-root cgroup.

The container invariant thing, however, is a bit hard to do. Do we
really need a container root to behave exactly like the real root? I
guess we can make that happen if we really want to, but it will
certainly make the code more complex. So it is a trade-off about what is
worth to do and what is not.

Cheers,
Longman

