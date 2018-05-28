From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v8 3/6] cpuset: Add cpuset.sched.load_balance flag to v2
Date: Mon, 28 May 2018 14:31:48 -0400
Message-ID: <5487d08f-322c-15d3-06e2-f3d3408141d6@redhat.com>
References: <1526590545-3350-1-git-send-email-longman@redhat.com>
 <1526590545-3350-4-git-send-email-longman@redhat.com>
 <20180524154341.GJ12198@hirez.programming.kicks-ass.net>
 <9f547771-54e8-118e-80f7-48f99c7b0a12@redhat.com>
 <20180528124508.GE3452@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180528124508.GE3452@worktop.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>

On 05/28/2018 08:45 AM, Peter Zijlstra wrote:
> On Thu, May 24, 2018 at 02:55:25PM -0400, Waiman Long wrote:
>> On 05/24/2018 11:43 AM, Peter Zijlstra wrote:
>>> I'm confused... why exactly do we have both domain and load_balance ?
>> The domain is for partitioning the CPUs only. It doesn't change the load
>> balancing state. So the load_balance flag is still need to turn on and
>> off load balancing.
> OK, so we have to two boolean flags, giving 4 possible states. Lets just
> go through them one by on:
>
> A) domain:0 load_balance:0 -- we have no exclusive domain, but have
>    load-balancing disabled across them. AFAICT this should be an invalid
>    state.
>
> B) domain:0 load_balance:1 -- we have no exclusive domain, but have
>    load-balancing enabled. AFAICT this is the default state and is a
>    no-op.
>
> C) domain:1 load_balance:0 -- we have an exclusive domain, and have
>    load-balancing disabled across it. This is, AFAICT, identical to
>    having a bunch of sub/sibling groups each with a single CPU domain.
>
> D) domain:1 load_balance:1 -- we have an exclusive domain, and have
>    load-balancing enabled. This is a partition.
>
> Now, I think I've overlooked the fact that load_balance==1 only really
> means something when the parent's load_balance==0, but I'm not sure that
> really changes anything.
>
> So, afaict, the above only have two useful states: B and D. Which again
> raises the question, why two knobs? What useful configurations does it
> allow?

I am working on the v9 patch, and below is the current draft of the
documentation. Hopefully that will clarify some of the concepts that we
are discussing here.

  cpuset.sched.domain_root
        A read-write single value file which exists on non-root
        cpuset-enabled cgroups.  It is a binary value flag that accepts
        either "0" (off) or "1" (on).  This flag is set by the parent
        and is not delegatable.

        If set, it indicates that the current cgroup is the root of a
        new scheduling domain or partition that comprises itself and
        all its descendants except those that are scheduling domain
        roots themselves and their descendants.  The root cgroup is
        always a scheduling domain root.

        There are constraints on where this flag can be set.  It can
        only be set in a cgroup if all the following conditions are true.

        1) The "cpuset.cpus" is not empty and the list of CPUs are
           exclusive, i.e. they are not shared by any of its siblings.
        2) The parent cgroup is also a scheduling domain root.
        3) There is no child cgroups with cpuset enabled.  This is
           for eliminating corner cases that have to be handled if such
           a condition is allowed.

        Setting this flag will take the CPUs away from the effective
        CPUs of the parent cgroup.  Once it is set, this flag cannot
        be cleared if there are any child cgroups with cpuset enabled.
        Further changes made to "cpuset.cpus" is allowed as long as
        the first condition above is still true.

        A parent scheduling domain root cgroup cannot distribute all
        its CPUs to its child scheduling domain root cgroups unless
        its load balancing flag is turned off.

  cpuset.sched.load_balance
        A read-write single value file which exists on non-root
        cpuset-enabled cgroups.  It is a binary value flag that accepts
        either "0" (off) or "1" (on).  This flag is set by the parent
        and is not delegatable.  It is on by default in the root cgroup.

        When it is on, tasks within this cpuset will be load-balanced
        by the kernel scheduler.  Tasks will be moved from CPUs with
        high load to other CPUs within the same cpuset with less load
        periodically.

        When it is off, there will be no load balancing among CPUs on
        this cgroup.  Tasks will stay in the CPUs they are running on
        and will not be moved to other CPUs.

        The load balancing state of a cgroup can only be changed on a
        scheduling domain root cgroup with no cpuset-enabled children.
        All cgroups within a scheduling domain or partition must have
        the same load balancing state.  As descendant cgroups of a
        scheduling domain root are created, they inherit the same load
        balancing state of their root.

The main purpose of using a new domain_root flag is to enable user to
create new partitions without the trick of disabling load_balance in the
parent and enabling it in the child. Now, we can create as many
partitions as we want without ever turning off load balancing in any of
the cpusets. I find it to be more straight forward and easier to
understand than using the load_balance trick.

Of course, turning off load balancing is still useful in some use cases,
so it is supported. To simplify thing, it is mandated that all the
cpusets within a partition must have the same load balancing state. This
is to ensure that we can't use the load_balance trick to create
additional partition underneath it. The domain_root flag is the only way
to create partition.

A) domain_root: 0, load_balance: 0 -- a non-domain root cpuset within a
no load balancing partition.

B) domain_root: 0, load_balance: 1 -- a non-domain root cpuset within a
load balancing partition.

C) domain_root: 1, load_balance: 0 -- a domain root cpuset of a no load
balancing partition.

D) domain_root: 1, load_balance: 1 -- a domain root cpuset of a load
balancing partition.

Hope this help.

Cheers,
Longman



