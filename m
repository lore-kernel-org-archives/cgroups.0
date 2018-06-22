From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v10 2/9] cpuset: Add new v2 cpuset.sched.domain_root flag
Date: Fri, 22 Jun 2018 10:48:41 +0800
Message-ID: <92c4aa24-4d52-dabd-5132-2153eacf44d2@redhat.com>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
 <1529295249-5207-3-git-send-email-longman@redhat.com>
 <20180620142735.GM2494@hirez.programming.kicks-ass.net>
 <b44b0748-9fec-6bb0-7665-435487e5d8b3@redhat.com>
 <20180621092728.GV2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621092728.GV2494@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 06/21/2018 05:27 PM, Peter Zijlstra wrote:
> On Thu, Jun 21, 2018 at 03:58:06PM +0800, Waiman Long wrote:
>> On 06/20/2018 10:27 PM, Peter Zijlstra wrote:
>>> On Mon, Jun 18, 2018 at 12:14:01PM +0800, Waiman Long wrote:
>>>> +  cpuset.sched.domain_root
>>> Why are we calling this a domain_root and not a partition?
>> A partition can consist of several cgroups in a tree structure. That
>> flag should only be set at the root of a partition. I will change the
>> name to partition_root if you think this name is acceptable.
> The flag indicates the 'effective_cpus' things of the current group is a
> partition. The fact that it can have sub-partitions doesn't really
> matter does it.
>
> Just call it 'partition', leave out the whole root stuff, all of cgroup
> is hierarchical and you can have sub-groups we don't go arounOd calling
> everything a root.

OK, will name it "cpuset.sched.partition" in the next version of the
patchset.

Cheers,
Longman


