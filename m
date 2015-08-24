From: Paul Turner <pjt@google.com>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified hierarchy
Date: Mon, 24 Aug 2015 14:58:23 -0700
Message-ID: <CAPM31RKCO-yxtVf+iUs8FOqk6uGSyixEXtx9zSzxQ1uOGtkDqQ@mail.gmail.com>
References: <20150804090711.GL25159@twins.programming.kicks-ass.net>
 <20150804151017.GD17598@mtj.duckdns.org> <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org> <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org> <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org> <CAPM31RKPUzuiwVs3rs=4M1Kt=+c9WX8o84r-iO4semfznvYmHw@mail.gmail.com>
 <20150824213600.GK28944@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=hwUHJiZpsS0n82uSQRZ4vwyvsDbTlxL2p3DmgNFrLhE=;
        b=hGskVz6G7GGxKz5w8Bq2TykuouekzxHzLn4EAJcCRq+Z2Bi8DJs+VOMfiFQ5FIuKzc
         5rLwndtAV1XC///gdfVtKu/Z/FS8n8nINxjzGj0AFtoGies/Oj/G0YFQWsEw1ibZkMvs
         94f4MatC87Nkpguuimpx1VwFwibjvOOAK1aXYLlD8t4HjE4q5FqWSpsnpv8IAT8cdasA
         39YWzpegsh1WG7+V04UWedKhZ2ZPf5AmxuwNIMEolKcfSYvc1O25pkMZhQOJ7uu/LgUt
         2c3Nr18QYTBGdVvdXAaVDPaadPWbpCrOnhqO8N1bGF+pn2L2c1UIVtC6B2kyiZmXvSPz
         QKWA==
In-Reply-To: <20150824213600.GK28944@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, lizefan@huawei.com, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

On Mon, Aug 24, 2015 at 2:36 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Paul.
>
> On Mon, Aug 24, 2015 at 01:52:01PM -0700, Paul Turner wrote:
>> We typically share our machines between many jobs, these jobs can have
>> cores that are "private" (and not shared with other jobs) and cores
>> that are "shared" (general purpose cores accessible to all jobs on the
>> same machine).
>>
>> The pool of cpus in the "shared" pool is dynamic as jobs entering and
>> leaving the machine take or release their associated "private" cores.
>>
>> By creating the appropriate sub-containers within the cpuset group we
>> allow jobs to pin specific threads to run on their (typically) private
>> cores.  This also allows the management daemons additional flexibility
>> as it's possible to update which cores we place as private, without
>> synchronization with the application.  Note that sched_setaffinity()
>> is a non-starter here.
>
> Why isn't it?  Because the programs themselves might try to override
> it?

The major reasons are:

1) Isolation.  Doing everything with sched_setaffinity means that
programs can use arbitrary resources if they desire.
  1a) These restrictions need to also apply to threads created by
library code.  Which may be 3rd party.
2) Interaction between cpusets and sched_setaffinity.  For necessary
reasons, a cpuset update always overwrites all extant
sched_setaffinity values. ...And we need some cpusets for (1)....And
we need periodic updates for access to shared cores.
3) Virtualization of CPU ids.  (Multiple applications all binding to
core 1 is a bad thing.)

>
>> Let me try to restate:
>>   I think that we can specify the usage is specifically niche that it
>> will *typically* be used by higher level management daemons which
>
> I really don't think that's the case.
>

Can you provide examples of non-exceptional usage in this fashion?

>> prefer a more technical and specific interface.  This does not
>> preclude use by threads, it just makes it less convenient; I think
>> that we should be optimizing for flexibility over ease-of-use for a
>> very small number of cases here.
>
> It's more like there are two niche sets of use cases.  If a
> programmable interface or cgroups has to be picked as an exclusive
> alternative, it's pretty clear that programmable interface is the way
> to go.

I strongly disagree here:
  The *major obvious use* is partitioning of a system, which must act
on groups of processes.  Cgroups is the only interface we have which
satisfies this today.

>
>> > It's not contained in the process at all.  What if an external entity
>> > decides to migrate the process into another cgroup inbetween?
>> >
>>
>> If we have 'atomic' moves and a way to access our sub-containers from
>> the process in a consistent fashion (e.g. relative paths) then this is
>> not an issue.
>
> But it gets so twisted.  Relative paths aren't enough.  It actually
> has to proxy accesses to already open files.  At that point, why would
> we even keep it as a file-system based interface?

Well no, this can just be reversed and we can have the relative paths
be the actual files which the hierarchy points back at.

Ultimately, they could potentially not even be exposed in the regular
hierarchy.  At this point we could not expose anything that does not
support sub-process splits within processes' hierarchy and we're at a
more reasonable state of affairs.

There is real value in being able to duplicate interface between
process and sub-process level control.

>
>> I am not endorsing the world we are in today, only describing how it
>> can be somewhat sanely managed.  Some of these lessons could be
>> formalized in imagining the world of tomorrow.  E.g. the sub-process
>> mounts could appear within some (non-movable) alternate file-system
>> path.
>
> Ditto.  Wouldn't it be better to implement something which resemables
> conventional programming interface rather than contorting the
> filesystem semantics?
>

Maybe?  This is a trade-off, some of which is built on the assumptions
we're now debating.

There is also value, cost-wise, in iterative improvement of what we
have today rather than trying to nuke it from orbit.  I do not know
which of these is the right choice, it likely depends strongly on
where we end up for sub-process interfaces.  If we do support those
I'm not sure it makes sense for them to have an entirely different API
from process-level coordination, at which point the file-system
overload is a trade-off rather than a cost.

>> >> The harder answer is:  How do we handle non-fungible resources such as
>> >> CPU assignments within a hierarchy?  This is a big part of why I make
>> >> arguments for certain partitions being management-software only above.
>> >> This is imperfect, but better then where we stand today.
>> >
>> > I'm not following.  Why is that different?
>>
>> This is generally any time a change in the external-to-application's
>> cgroup-parent requires changes in the sub-hierarchy.  This is most
>> visible with a resource such as a cpu which is uniquely identified,
>> but similarly applies to any limits.
>
> So, except for cpuset, this doesn't matter for controllers.  All
> limits are hierarchical and that's it.

Well no, it still matters because I might want to lower the limit
below what children have set.

> For cpuset, it's tricky
> because a nested cgroup might end up with no intersecting execution
> resource.  The kernel can't have threads which don't have any
> execution resources and the solution has been assuming the resources
> from higher-ups till there's some.  Application control has always
> behaved the same way.  If the configured affinity becomes empty, the
> scheduler ignored it.

Actually no, any configuration change that would result in this state
is rejected.

It's not possible to configure an empty cpuset once tasks are in it,
or attach tasks to an empty set.
It's also not possible to create this state using setaffinity, these
restrictions are always over-ridden by updates, even if they do not
need to be.

>
>> > The transition can already be gradual.  Why would you add yet another
>> > transition step?
>>
>> Because what's being proposed today does not offer any replacement for
>> the sub-process control that we depend on today?  Why would we embark
>> on merging the new interface before these details are sufficiently
>> resolved?
>
> Because the details on this particular issue can be hashed out in the
> future?  There's nothing permanently blocking any direction that we
> might choose in the future and what's working today will keep working.
> Why block the whole thing which can be useful for the majority of use
> cases for this particular corner case?
>

Because I do not think sub-process hierarchies are the corner case
that you're making them out to be for these controllers and that has
real implications for the ultimate direction of this interface.

Also.  If we are making disruptive changes here, I would want to
discuss merging cpu, cpuset, and cpuacct.  What this merge looks like
depends on the above.
