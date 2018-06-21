From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v10 2/9] cpuset: Add new v2 cpuset.sched.domain_root flag
Date: Thu, 21 Jun 2018 15:58:06 +0800
Message-ID: <b44b0748-9fec-6bb0-7665-435487e5d8b3@redhat.com>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
 <1529295249-5207-3-git-send-email-longman@redhat.com>
 <20180620142735.GM2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620142735.GM2494@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 06/20/2018 10:27 PM, Peter Zijlstra wrote:
> On Mon, Jun 18, 2018 at 12:14:01PM +0800, Waiman Long wrote:
>> +  cpuset.sched.domain_root
> Why are we calling this a domain_root and not a partition?

A partition can consist of several cgroups in a tree structure. That
flag should only be set at the root of a partition. I will change the
name to partition_root if you think this name is acceptable.

>
>> +	A read-write single value file which exists on non-root
>> +	cpuset-enabled cgroups.  It is a binary value flag that accepts
>> +	either "0" (off) or "1" (on).  This flag is set by the parent
>> +	and is not delegatable.
> You still haven't answered:
> , 
>   https://lkml.kernel.org/r/20180531094943.GG12180@hirez.programming.kicks-ass.net
>
> the question stands.

I am sorry to miss your question. Turning on domain_root will affects
the cpu mapping in the parent. That is why it cannot be set by the child
as a child is not supposed to be able to affect the parent.

As for the inconsistency between the real root and the container root,
this is true for almost all the controllers. So it is a generic problem.
One possible solution is to create a kind a pseudo root cgroup for the
container that looks and feels like a real root. But is there really a
need to do that?

Cheers,
Longman

