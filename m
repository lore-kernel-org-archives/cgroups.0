From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Fri, 6 Jul 2018 16:32:25 -0400
Message-ID: <4cf9924e-7b97-187f-a1f5-853a45165abb@redhat.com>
References: <1529825440-9574-1-git-send-email-longman@redhat.com>
 <1529825440-9574-8-git-send-email-longman@redhat.com>
 <20180702165322.GI533219@devbig577.frc2.facebook.com>
 <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
 <20180703155823.GS533219@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180703155823.GS533219@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 07/03/2018 11:58 AM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Tue, Jul 03, 2018 at 08:41:31AM +0800, Waiman Long wrote:
>>> So, effective changing when enabling partition on a child feels wrong
>>> to me.  It's supposed to contain what's actually allowed to the cgroup
>>> from its parent and that shouldn't change regardless of how those
>>> resources are used.  It's still given to the cgroup from its parent.
>> Another way to work around this issue is to expose the reserved_cpus in
>> the parent for holding CPUs that can taken by a chid partition. That
>> will require adding one more cpuset file for those cgroups that are
>> partition roots.
> Yeah, that should work.
>

Thinking about it a bit more, that approach will make creating a
partition a multi-step process:

1) Reserve the CPUs in reserved_cpus.
2) enable sched.partition
3) Write the CPUs list into cpus.

There are also more exception cases that need to be handled. The current
approach, on the other hands, is much simpler and easier to understand
and use.

>> I don't mind restricting that to the first level children for now. That
>> does restrict where we can put the container root if we want a separate
>> partition for a container. Let's hear if others have any objection about
>> that.
> As currently implemented, partioning locks away the cpus which should
> be a system level decision, not container level, so it makes sense to
> me that it is only available to system root.

So my preference is to allow partition only on the first level children
of the root for the time being. I think it should cover most of the use
cases. I will update the patchset to reflect that.

Cheers,
Longman

