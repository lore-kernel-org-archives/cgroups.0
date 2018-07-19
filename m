From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Thu, 19 Jul 2018 10:04:54 -0400
Message-ID: <1107494a-9667-df58-dcac-9366e969dc3a@redhat.com>
References: <1529825440-9574-1-git-send-email-longman@redhat.com>
 <1529825440-9574-8-git-send-email-longman@redhat.com>
 <20180702165322.GI533219@devbig577.frc2.facebook.com>
 <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
 <20180703155823.GS533219@devbig577.frc2.facebook.com>
 <20180719135224.GE2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180719135224.GE2494@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 07/19/2018 09:52 AM, Peter Zijlstra wrote:
> On Tue, Jul 03, 2018 at 08:58:23AM -0700, Tejun Heo wrote:
>> Hello, Waiman.
>>
>> On Tue, Jul 03, 2018 at 08:41:31AM +0800, Waiman Long wrote:
>>>> So, effective changing when enabling partition on a child feels wrong
>>>> to me.  It's supposed to contain what's actually allowed to the cgroup
>>>> from its parent and that shouldn't change regardless of how those
>>>> resources are used.  It's still given to the cgroup from its parent.
>>> Another way to work around this issue is to expose the reserved_cpus in
>>> the parent for holding CPUs that can taken by a chid partition. That
>>> will require adding one more cpuset file for those cgroups that are
>>> partition roots.
>> Yeah, that should work.
>>
>>> I don't mind restricting that to the first level children for now. That
>>> does restrict where we can put the container root if we want a separate
>>> partition for a container. Let's hear if others have any objection about
>>> that.
>> As currently implemented, partioning locks away the cpus which should
>> be a system level decision, not container level, so it makes sense to
>> me that it is only available to system root.
> I'm terribly confused, what?!
>
> Why would a container not be allowed to create partitions for its
> various RT workloads?

As far as I understand, Tejun has some concern about the way that
partitioning works is inconsistent with how other resources are being
managed by cgroup v2 controllers. I adds an incremental patch to
temporarily disable the creation of partition below the first level
children to buy us time so that we can reach a compromise later on what
to do. We can always add features, but taking away features after they
are made available will be hard.

I am fine either way. It is up to you and Tejun to figure out what
should be made available to the users.

Cheers,
Longman


