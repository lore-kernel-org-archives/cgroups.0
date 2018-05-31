From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v9 3/7] cpuset: Add cpuset.sched.load_balance flag to v2
Date: Thu, 31 May 2018 11:36:39 -0400
Message-ID: <ebe7f0c1-b2dc-57ad-e5cb-7edf0fee4626@redhat.com>
References: <1527601294-3444-1-git-send-email-longman@redhat.com>
 <1527601294-3444-4-git-send-email-longman@redhat.com>
 <20180531122638.GJ12180@hirez.programming.kicks-ass.net>
 <42cc1f44-2355-1c0c-b575-49c863303c42@redhat.com>
 <20180531152050.GK12180@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180531152050.GK12180@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Thomas Gleixner <tglx@linutronix.de>

On 05/31/2018 11:20 AM, Peter Zijlstra wrote:
> On Thu, May 31, 2018 at 09:54:27AM -0400, Waiman Long wrote:
>> On 05/31/2018 08:26 AM, Peter Zijlstra wrote:
>>> I still find all that a bit weird.
>>>
>>> So load_balance=0 basically changes a partition into a
>>> 'fully-partitioned partition' with the seemingly random side-effect that
>>> now sub-partitions are allowed to consume all CPUs.
>> Are you suggesting that we should allow sub-partition to consume all the
>> CPUs no matter the load balance state? I can live with that if you think
>> it is more logical.
> I'm on the fence myself; the only thing I'm fairly sure of is that tying
> this particular behaviour to the load-balance knob seems off.

The main reason for doing it this way is that I don't want to have
load-balanced partition with no cpu in it. How about we just don't allow
consume-all at all. Each partition must have at least 1 cpu.

>
>>> The rationale, only given in the Changelog above, seems to be to allow
>>> 'easy' emulation of isolcpus.
>>>
>>> I'm still not convinced this is a useful knob to have. You can do
>>> fully-partitioned by simply creating a lot of 1 cpu parititions.
>> That is certainly true. However, I think there are some additional
>> overhead in the scheduler side in maintaining those 1-cpu partitions. Right?
> cpuset-controller as such doesn't have much overhead scheduler wise,
> cpu-controller OTOH does, and there depth is the predominant factor, so
> many sibling groups should not matter there either.
>
>>> So this one knob does two separate things, both of which seem, to me,
>>> redundant.
>>>
>>> Can we please get better rationale for this?
>> I am fine getting rid of the load_balance flag if this is the consensus.
>> However, we do need to come up with a good migration story for those
>> users that need the isolcpus capability. I think Mike was the one asking
>> for supporting isolcpus. So Mike, what is your take on that.
> So I don't strictly mind having a knob that does the 'fully-partitioned
> partition' thing -- however odd that sounds -- but I feel we should have
> a solid use-case for it.
>
> I also think we should not mix the 'consume all' thing with the
> 'fully-partitioned' thing, as they are otherwise unrelated.

The "consume all" and "fully-partitioned" look the same to me. Are you
talking about allocating all the CPUs in a partition to sub-partitions
so that there is no CPU left in the parent partition?

Cheers,
Longman


