From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v10 2/9] cpuset: Add new v2 cpuset.sched.domain_root flag
Date: Fri, 22 Jun 2018 11:00:03 +0800
Message-ID: <1eb82b46-aa97-2ada-5196-5d7fc1cda87d@redhat.com>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
 <1529295249-5207-3-git-send-email-longman@redhat.com>
 <20180620142735.GM2494@hirez.programming.kicks-ass.net>
 <b44b0748-9fec-6bb0-7665-435487e5d8b3@redhat.com>
 <20180621092013.GU2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621092013.GU2494@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 06/21/2018 05:20 PM, Peter Zijlstra wrote:
> On Thu, Jun 21, 2018 at 03:58:06PM +0800, Waiman Long wrote:
>
>> As for the inconsistency between the real root and the container root,
>> this is true for almost all the controllers. So it is a generic problem.
>> One possible solution is to create a kind a pseudo root cgroup for the
>> container that looks and feels like a real root. But is there really a
>> need to do that?
> I don't really know. I thought the idea was to make containers
> indistinguishable from a real system. Now I know we're really rather far
> away from that in reality, and I really have no clue how important all
> that is.

That will certainly be the ideal.

> It all depends on how exactly this works; is it like I assumed, that
> this file is owned by the parent instead of the current directory? And
> that if you namespace this, you have an effective read-only file?

Yes, that is right.

> Then fixing the inconsistency is trivial; simply provide a read-only
> file for the actual root cgroup too.
>
> And if the solution is trivial, I don't see a good reason not to do it.

Do you mean providing a flag like READONLY_AT_ROOT so that it will be
read-only at the real root? That is an cgroup architectural decision
that needs input from Tejun. Anyway, this issue is not specific to this
patchset and I would like to break it out as a separate discussion
independent of this patchset.

Cheers,
Longman


