From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v9 3/7] cpuset: Add cpuset.sched.load_balance flag to v2
Date: Thu, 21 Jun 2018 15:40:55 +0800
Message-ID: <560427ef-a592-9389-3334-45c8e44d43e8@redhat.com>
References: <1527601294-3444-1-git-send-email-longman@redhat.com>
 <1527601294-3444-4-git-send-email-longman@redhat.com>
 <20180531122638.GJ12180@hirez.programming.kicks-ass.net>
 <42cc1f44-2355-1c0c-b575-49c863303c42@redhat.com>
 <20180531152050.GK12180@hirez.programming.kicks-ass.net>
 <ebe7f0c1-b2dc-57ad-e5cb-7edf0fee4626@redhat.com>
 <20180531160857.GM12180@hirez.programming.kicks-ass.net>
 <54c607c3-e742-4da9-c89a-4ed54146e3bd@redhat.com>
 <20180620144613.GP2476@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620144613.GP2476@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Frederic Weisbecker <fweisbec@gmail.com>

On 06/20/2018 10:46 PM, Peter Zijlstra wrote:
> On Thu, May 31, 2018 at 12:42:20PM -0400, Waiman Long wrote:
>> Thinking about isolcpus emulation, I now realize that it is more than
>> just disabling load balancing. it also disables some kernel threads like
>> kworker from running so that an userspace application can monopolize as
>> much of a cpu as possible. Disabling kernel threads from running isn't
>> that hard if it is only done once at boot time. it is trickier if we
>> have to do it at run time.
> Don't think it is all that difficult, we just need a notifier for when
> that housekeeping thing changes and ensure that everybody who uses it
> re-evaluates crap.

Yes, it is certainly doable. I can work on that on my free time once the
first cpuset v2 patch is done. There is enough complexity in the current
patchset and I don't want to add stuff that is not a part of the core
cpuset functionality at this point. We can also add new feature in the
future, but once it is in, it is hard to change it.

>> Without good isolcpus emulation, disabling load balance kind of loses
>> its usefulness. So I am going to take out the load_balance flag for now
>> unless I hear objection otherwise.
> I'm not seeing the direct link between the load_balance flag and
> isolcpus emulation in the proposed stuff.
>
> We can tie the housekeeping mask to whatever CPUs remain in the root
> cgroup, couple that to that notifier and it should all just work I
> think.

The group of cpus in isolcpus are outside the reach of the scheduler and
so is equivalent to turning off load balancing in that sense. Of course,
there may also be other stuff that need to be considered in order to
have a proper emulation of isolcpus.

Cheers,
Longman


