From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/6] cgroup/cpuset: Clarify the use of invalid
 partition root
Date: Fri, 16 Jul 2021 10:46:19 -1000
Message-ID: <YPHwG61qGDa3h6Wg@mtj.duckdns.org>
References: <20210621184924.27493-1-longman@redhat.com>
 <20210621184924.27493-3-longman@redhat.com>
 <YNcHOe3o//pIiByh@mtj.duckdns.org>
 <6ea1ac38-73e1-3f78-a5d2-a4c23bcd8dd1@redhat.com>
 <YONGk3iw/zrNzwLK@mtj.duckdns.org>
 <c6ae2d9b-ad6e-9bbd-b25c-f52b0ff6fb9b@redhat.com>
 <1bb119a1-d94a-6707-beac-e3ae5c03fae5@redhat.com>
 <8c44b659-3fe4-b14f-fac1-cbd5b23010c3@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CcNFha5vgUcweegT4k/uNLuzQ/cieMwjGwt7INh2sMw=;
        b=V9jl6P3GvbA4iXwjdyXzx+zVSBWTXHMvy4BPlOaIhy+YXU3ZDZmyPD4P1Td8/rqdNS
         rQ59CYIarn3bQoia//d6o/Tkjb4S6+l/svi7EJER6d4bpC1mhOnC5pQGYJSP5yIMgQgT
         Dq5KlNB02W+b7KkfOMpo1CUrvEG9aEJ/AW1k+fI1SarpP1EBhVcTWDFIUtALtgsyaba/
         LfY2bvDAYkkln8F2uMqNk4jgn2bu/ymfRLtJIvgAV7HSIObuOApR9tP23FAbRC7dEDhk
         Irvae0p9FqA59iETjQxdva4lTiXKYDdwtco+YuYTQhvRYJj12/wOjWLcONpGEp1Xmr4o
         SmhQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <8c44b659-3fe4-b14f-fac1-cbd5b23010c3@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <llong@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>

Hello, Waiman.

On Fri, Jul 16, 2021 at 04:08:15PM -0400, Waiman Long wrote:
> > > I agree with you on principle. However, the reason why there are
> > > more restrictions on enabling partition is because I want to avoid
> > > forcing the users to always read back cpuset.partition.type to see
> > > if the operation succeeds instead of just getting an error from the
> > > operation. The former approach is more error prone. If you don't
> > > want changes in existing behavior, I can relax the checking and
> > > allow them to become an invalid partition if an illegal operation
> > > happens.
> > > 
> > > Also there is now another cpuset patch to extend cpu isolation to
> > > cgroup v1 [1]. I think it is better suit to the cgroup v2 partition
> > > scheme, but cgroup v1 is still quite heavily out there.
> > > 
> > > Please let me know what you want me to do and I will send out a v3
> > > version.
> > 
> > Note that the current cpuset partition implementation have implemented
> > some restrictions on when a partition can be enabled. However, I missed
> > some corner cases in the original implementation that allow certain
> > cpuset operations to make a partition invalid. I tried to plug those
> > holes in this patchset. However, if maintaining backward compatibility
> > is more important, I can leave those holes and update the documentation
> > to make sure that people check cpuset.partition.type to confirm if their
> > operation succeeds.
> 
> I just realize that partition root set the CPU_EXCLUSIVE bit. So changes to
> cpuset.cpus that break exclusivity rule is not allowed anyway. This patchset
> is just adding additional checks so that cpuset.cpus changes that break the
> partition root rules will not be allowed. I can remove those additional
> checks for this patchset and allow cpuset.cpus changes that break the
> partition root rules to make it invalid instead. However, I still want
> invalid changes to cpuset.partition.type to be disallowed.

So, I get the instinct to disallow these operations and it'd make sense if
the conditions aren't reachable otherwise. However, I'm afraid what users
eventually get is false sense of security rather than any actual guarantee.

Inconsistencies like this cause actual usability hazards - e.g. imagine a
system config script whic sets up exclusive cpuset and let's say that the
use case is fine with degraded operation when the target cores are offline
(e.g. energy save mode w/ only low power cores online). Let's say this
script runs in late stages during boot and has been reliable. However, at
some point, there are changes in boot sequence and now there's low but
non-trivial chance that the system would already be in low power state when
the script runs. Now the script will fail sporadically and the whole thing
would be pretty awkward to debug.

I'd much prefer to have an explicit interface to confirm the eventual state
and a way to monitor state transitions (without polling). An invalid state
is an inherent part of cpuset configuration. I'd much rather have that
really explicit in the interface even if that means a bit of extra work at
configuration time.

Thanks.

-- 
tejun
