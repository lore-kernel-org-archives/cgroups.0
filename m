From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v12 9/9] cpuset: Support forced turning off of partition
 flag
Date: Mon, 27 Aug 2018 13:50:18 -0400
Message-ID: <0daf1f43-2292-0281-3ab8-aef20d0475dc@redhat.com>
References: <1535380884-31308-1-git-send-email-longman@redhat.com>
 <1535380884-31308-10-git-send-email-longman@redhat.com>
 <20180827164004.GE3978217@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180827164004.GE3978217@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 08/27/2018 12:40 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Mon, Aug 27, 2018 at 10:41:24AM -0400, Waiman Long wrote:
>> Cpuset allows arbitrary modification of cpu list in "cpuset.cpus"
>> even if the requested CPUs won't be granted in "cpuset.cpus.effective"
>> as restricted by its parent. However, the validate_change() function
>> will inhibit removal of CPUs that have been used in child cpusets.
>>
>> Being a partition root, however, limits the kind of cpu list
>> modification that is allowed. Adding CPUs is not allowed if the new
>> CPUs are not in the parent's effective cpu list that can be put into
>> "cpuset.cpus.reserved". In addition, a child partition cannot exhaust
>> all the parent's effective CPUs.
>>
>> Because of the implicit cpu exclusive nature of the partition root,
>> cpu changes that break that cpu exclusivity will not be allowed. Other
>> changes that break the conditions of being a partition root is generally
>> allowed. However, the partition flag of the cpuset as well those of
>> the descendant partitions will be forcefully turned off.
> First of all, thanks a lot for your persistence.  I'm not necessarily
> against the flag being forced off but wonder whether the same
> config/effective approach can be used as in .cpus and .mems.  Can you
> elaborate a bit on the choice here?
>
> Thank you.

My current code has explicitly assumed the following relationship for
partition root.

    cpus_allowed = effective_cpus + reserved_cpus

Also effective_cpus cannot be empty. Specifically, cpus_allowed has to
be equal to effective_cpus before a cpuset can be made a partition root.

Any changes that break the above conditions will turn off the partition
flag forcefully. The only exception is cpu offlining where cpus_allowed
> effective_cpus + reserved_cpus can happen.

One reason for doing so is because reserved_cpus is hidden. So the main
way to infer that is to do cpus_allowed - effective_cpus.

It is probably doable to make cpus_allowed >= effective_cpus +
reserved_cpus in general, but we may need to expose reserved_cpus as a
read-only file, for instance. There may also be other complications that
we will need to take care of if this is supported. My current preference
is to not doing that unless there is compelling reason to do so.

Cheers,
Longman



