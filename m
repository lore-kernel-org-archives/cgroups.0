From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Thu, 19 Jul 2018 11:52:46 -0400
Message-ID: <de6f931d-613a-3e6a-2a4d-0e49b3bfe2e5@redhat.com>
References: <1529825440-9574-1-git-send-email-longman@redhat.com>
 <1529825440-9574-8-git-send-email-longman@redhat.com>
 <20180702165322.GI533219@devbig577.frc2.facebook.com>
 <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
 <20180703155823.GS533219@devbig577.frc2.facebook.com>
 <20180719135224.GE2494@hirez.programming.kicks-ass.net>
 <1107494a-9667-df58-dcac-9366e969dc3a@redhat.com>
 <20180719153045.GT72677@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180719153045.GT72677@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 07/19/2018 11:30 AM, Tejun Heo wrote:
> Hello,
>
> On Thu, Jul 19, 2018 at 10:04:54AM -0400, Waiman Long wrote:
>>> Why would a container not be allowed to create partitions for its
>>> various RT workloads?
>> As far as I understand, Tejun has some concern about the way that
>> partitioning works is inconsistent with how other resources are being
>> managed by cgroup v2 controllers. I adds an incremental patch to
>> temporarily disable the creation of partition below the first level
>> children to buy us time so that we can reach a compromise later on what
>> to do. We can always add features, but taking away features after they
>> are made available will be hard.
>>
>> I am fine either way. It is up to you and Tejun to figure out what
>> should be made available to the users.
> So, the main thing is that putting a cpu into a partition locks away
> the cpu from its ancestors.  That's a system level operation which
> isn't delegatable.  If we want to allow partitioning in subtrees, the
> parent still be able to take away partitioned cpus too even if that
> means ignoring descendants' configurations, which btw is exactly what
> cpuset does for non-partition configs.
>
> I don't think this would be technically too challenging to implement,
> but unless there are immediate use cases for it, we can start simpler
> & restricted.
>
> Thanks.
>
BTW, the way the partition is currently implemented right now is that a
child cannot be a partition root unless its parent is a partition root
itself. That is to avoid turning on partition to affect ancestors
further up the hierarchy than just the parent. So in the case of a
container, it cannot allocate sub-partitions underneath it unless it is
a partition itself. Will that solve your concern?

Thanks,
Longman


