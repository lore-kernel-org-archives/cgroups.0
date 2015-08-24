From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Mon, 24 Aug 2015 17:36:00 -0400
Message-ID: <20150824213600.GK28944@mtj.duckdns.org>
References: <20150804090711.GL25159@twins.programming.kicks-ass.net>
 <20150804151017.GD17598@mtj.duckdns.org>
 <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org>
 <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org>
 <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org>
 <CAPM31RKPUzuiwVs3rs=4M1Kt=+c9WX8o84r-iO4semfznvYmHw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=XvcbzPVu/MGoNQ9Bykwpk8dL34FQ2DSWbwvmyKhOyLM=;
        b=QKQ3EYKv5F7e4SeCBYgbxaF5q4oVmAuHIY3WBQg0hOKPQpE8/EEqTAb0dfR/DOnBSC
         TzGs527N9TXmoEMGqdtuhRcbA6ZbwxJMjKuqWe66ONvFltmtPdAuqnLVtn7wp5i0/rp9
         o5XvnDIF+KLJ7q9TWly/9B8e9k0ovqG01nn7YXkqc3GQFhqQ0cF2oa9TFdIRYDS/YMWE
         3ObsKMejR3lAFheHI2Ck3vHITpgBQQCOu2S9iFdbV4WzkN5AOudOV5rAom1CswfOkXQy
         ODKF/YBG7W38kEojXH7JNqtWCiaszDfC/qzRfJ5IAHnbxzr8Ef03maXykhaSFEKcLGO9
         8DaQ==
Content-Disposition: inline
In-Reply-To: <CAPM31RKPUzuiwVs3rs=4M1Kt=+c9WX8o84r-iO4semfznvYmHw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, lizefan@huawei.com, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

Hello, Paul.

On Mon, Aug 24, 2015 at 01:52:01PM -0700, Paul Turner wrote:
> We typically share our machines between many jobs, these jobs can have
> cores that are "private" (and not shared with other jobs) and cores
> that are "shared" (general purpose cores accessible to all jobs on the
> same machine).
> 
> The pool of cpus in the "shared" pool is dynamic as jobs entering and
> leaving the machine take or release their associated "private" cores.
> 
> By creating the appropriate sub-containers within the cpuset group we
> allow jobs to pin specific threads to run on their (typically) private
> cores.  This also allows the management daemons additional flexibility
> as it's possible to update which cores we place as private, without
> synchronization with the application.  Note that sched_setaffinity()
> is a non-starter here.

Why isn't it?  Because the programs themselves might try to override
it?

> Let me try to restate:
>   I think that we can specify the usage is specifically niche that it
> will *typically* be used by higher level management daemons which

I really don't think that's the case.

> prefer a more technical and specific interface.  This does not
> preclude use by threads, it just makes it less convenient; I think
> that we should be optimizing for flexibility over ease-of-use for a
> very small number of cases here.

It's more like there are two niche sets of use cases.  If a
programmable interface or cgroups has to be picked as an exclusive
alternative, it's pretty clear that programmable interface is the way
to go.

> > It's not contained in the process at all.  What if an external entity
> > decides to migrate the process into another cgroup inbetween?
> >
> 
> If we have 'atomic' moves and a way to access our sub-containers from
> the process in a consistent fashion (e.g. relative paths) then this is
> not an issue.

But it gets so twisted.  Relative paths aren't enough.  It actually
has to proxy accesses to already open files.  At that point, why would
we even keep it as a file-system based interface?

> I am not endorsing the world we are in today, only describing how it
> can be somewhat sanely managed.  Some of these lessons could be
> formalized in imagining the world of tomorrow.  E.g. the sub-process
> mounts could appear within some (non-movable) alternate file-system
> path.

Ditto.  Wouldn't it be better to implement something which resemables
conventional programming interface rather than contorting the
filesystem semantics?

> >> The harder answer is:  How do we handle non-fungible resources such as
> >> CPU assignments within a hierarchy?  This is a big part of why I make
> >> arguments for certain partitions being management-software only above.
> >> This is imperfect, but better then where we stand today.
> >
> > I'm not following.  Why is that different?
> 
> This is generally any time a change in the external-to-application's
> cgroup-parent requires changes in the sub-hierarchy.  This is most
> visible with a resource such as a cpu which is uniquely identified,
> but similarly applies to any limits.

So, except for cpuset, this doesn't matter for controllers.  All
limits are hierarchical and that's it.  For cpuset, it's tricky
because a nested cgroup might end up with no intersecting execution
resource.  The kernel can't have threads which don't have any
execution resources and the solution has been assuming the resources
from higher-ups till there's some.  Application control has always
behaved the same way.  If the configured affinity becomes empty, the
scheduler ignored it.

> > The transition can already be gradual.  Why would you add yet another
> > transition step?
> 
> Because what's being proposed today does not offer any replacement for
> the sub-process control that we depend on today?  Why would we embark
> on merging the new interface before these details are sufficiently
> resolved?

Because the details on this particular issue can be hashed out in the
future?  There's nothing permanently blocking any direction that we
might choose in the future and what's working today will keep working.
Why block the whole thing which can be useful for the majority of use
cases for this particular corner case?

Thanks.

-- 
tejun
