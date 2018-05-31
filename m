From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v9 3/7] cpuset: Add cpuset.sched.load_balance flag to v2
Date: Thu, 31 May 2018 09:36:20 -0400
Message-ID: <f7eef1f4-9012-e3e1-3e00-d42f5e1fb36b@redhat.com>
References: <1527601294-3444-1-git-send-email-longman@redhat.com>
 <1527601294-3444-4-git-send-email-longman@redhat.com>
 <20180531105416.GI12180@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180531105416.GI12180@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 05/31/2018 06:54 AM, Peter Zijlstra wrote:
> On Tue, May 29, 2018 at 09:41:30AM -0400, Waiman Long wrote:
>
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
> That is not entirely accurate I'm afraid (unless the patch makes it so,
> I've yet to check). When you disable load-balancing on a cgroup you'll
> get whatever balancing is left for the partition you happen to end up
> in.
>
> Take for instance workqueue thingies, they use kthread_bind_mask()
> (IIRC) and thus end up with PF_NO_SETAFFINITY so cpusets (or any other
> cgroups really) do not have effect on them (long standing complaint).
>
> So take for instance the unbound numa enabled workqueue threads, those
> will land in whatever partition and get balanced there.

Thanks for the clarification. The patch doesn't make any changes in the
scheduler. I was trying to say what the flag does. I will update the
documentation about this nuisance.

Cheers,
Longman

