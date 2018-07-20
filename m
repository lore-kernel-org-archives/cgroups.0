From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Fri, 20 Jul 2018 13:09:23 -0400
Message-ID: <8c655adc-6d9e-b767-1024-5d6941c995a9@redhat.com>
References: <20180719135224.GE2494@hirez.programming.kicks-ass.net>
 <1107494a-9667-df58-dcac-9366e969dc3a@redhat.com>
 <20180719153045.GT72677@devbig577.frc2.facebook.com>
 <de6f931d-613a-3e6a-2a4d-0e49b3bfe2e5@redhat.com>
 <20180719165201.GU72677@devbig577.frc2.facebook.com>
 <20180720113121.GJ2476@hirez.programming.kicks-ass.net>
 <20180720114549.GY72677@devbig577.frc2.facebook.com>
 <20180720154454.GR2494@hirez.programming.kicks-ass.net>
 <20180720155613.GB1934745@devbig577.frc2.facebook.com>
 <4857a9db-ebf5-24f8-c42d-d795f5c75854@redhat.com>
 <20180720163712.GU2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720163712.GU2494@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 07/20/2018 12:37 PM, Peter Zijlstra wrote:
> On Fri, Jul 20, 2018 at 12:19:29PM -0400, Waiman Long wrote:
>> I am not against the idea of making it hierarchical eventually. I am
>> just hoping to get thing going by merging the patchset in its current
>> form and then we can make it hierarchical in a followup patch.
> Where's the rush? Why can't we do this right in one go?

For me, the rush comes from RHEL8 as it is a goal to have a fully
functioning cgroup v2 in that release.

I also believe that most of the use cases of partition can be satisfied
with partitions at the first level children. Getting hierarchical
partition right may drag on for half a year, maybe, giving our history
with cpu v2 controller. No matter what we do to enable hierarchical
partition in the future, the current model of using a partition flag is
intuitive enough that it won't be changed at least for the first level
children.

Cheers,
Longman


