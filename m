From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v7 2/5] cpuset: Add cpuset.sched_load_balance to v2
Date: Wed, 2 May 2018 09:29:54 -0400
Message-ID: <14d7604c-1254-1146-e2b6-23f4cc020b34@redhat.com>
References: <1524145624-23655-1-git-send-email-longman@redhat.com>
 <1524145624-23655-3-git-send-email-longman@redhat.com>
 <20180502102416.GJ12180@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502102416.GJ12180@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>

On 05/02/2018 06:24 AM, Peter Zijlstra wrote:
> On Thu, Apr 19, 2018 at 09:47:01AM -0400, Waiman Long wrote:
>> +  cpuset.sched_load_balance
>> +	A read-write single value file which exists on non-root cgroups.
> Uhhm.. it should very much exist in the root group too. Otherwise you
> cannot disable it there, which is required to allow smaller groups to
> load-balance between themselves.
>
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
> That too is wrong and broken. You explicitly want to turn it on for
> children.
>
> So the idea is that you can have:
>
> 		R
> 	      /   \
>             A       B
>
> With:
>
> 	R cpus=0-3, load_balance=0
> 	A cpus=0-1, load_balance=1
> 	B cpus=2-3, load_balance=1
>
> Which will allow all tasks in A,B (and its children) to load-balance
> across 0-1 or 2-3 resp.
>
> If you don't allow the root group to disable load_balance, it will
> always be the largest group and load-balancing will always happen system
> wide.

If you look at the remaining patches in the series, I was proposing a
different way to support isolcpus and separate sched domains with
turning off load balancing in the root cgroup.

For me, it doesn't feel right to have load balancing disabled in the
root cgroup as we probably cannot move all the tasks away from the root
cgroup anyway. I am going to update the current patchset to incorporate
suggestion from Tejun. It will probably be ready sometime next week.

Cheers,
Longman


