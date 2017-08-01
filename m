From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] sched: Implement interface for cgroup unified
 hierarchy
Date: Tue, 1 Aug 2017 13:17:45 -0700
Message-ID: <20170801201745.GA2311718@devbig577.frc2.facebook.com>
References: <20170720184808.1433868-1-tj@kernel.org>
 <20170720184808.1433868-3-tj@kernel.org>
 <20170729091707.lobbicnw253wzltu@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2WwxcmTTWSDpk42ovhddN68SpY2KTFhZmgdT8+oEBv0=;
        b=LGfjiMfTsInq0p7RQUbSz5po/c/zUyiX2RnxaD99pCgzWbOfRanaPIsg3nI/GxhV2z
         VEPo0yrQhF+6EGxytI4Sc3Te8dgpVTkofYNPx5JogoetyMxd1tMG7Rh1u4VEc1Zus1qy
         GgHBSvBSmamT43+Ud+4MRDKuyzT29O6I2EyF6pM4zeJnG9NNNXa7jaPV4JAqj9/ZHu0m
         MKggMJFlNT4HOEifM0xZFy/50KB29FINH/hch8uH3qBJVt9RrQRODVQY6kBdJlWzUtub
         DpE5PN654oHGUvjCQ/CfkAUEX7c6AQDnQokkpt/D5TdWeVPX+wW7GGP3NVxywSCfYm0H
         vg2A==
Content-Disposition: inline
In-Reply-To: <20170729091707.lobbicnw253wzltu@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, mingo@redhat.com, longman@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

Hello, Peter.

On Sat, Jul 29, 2017 at 11:17:07AM +0200, Peter Zijlstra wrote:
> > * "cpu.shares" is replaced with "cpu.weight" and operates on the
> >   standard scale defined by CGROUP_WEIGHT_MIN/DFL/MAX (1, 100, 10000).
> >   The weight is scaled to scheduler weight so that 100 maps to 1024
> >   and the ratio relationship is preserved - if weight is W and its
> >   scaled value is S, W / 100 == S / 1024.  While the mapped range is a
> >   bit smaller than the orignal scheduler weight range, the dead zones
> >   on both sides are relatively small and covers wider range than the
> >   nice value mappings.  This file doesn't make sense in the root
> >   cgroup and isn't create on root.
> 
> s/create/&d/

Updated, thanks.

> > * "cpu.rt_runtime_us" and "cpu.rt_period_us" are replaced by
> >   "cpu.rt.max" which contains both runtime and period.
> 
> So we've been looking at overhauling the whole RT stuff. But sadly we've
> not been able to find something that works with all the legacy
> constraints (like RT tasks having arbitrary affinities).
> 
> Lets just hope we can preserve this interface :/

Ah, should have dropped this from the description.  Yeah, we can wait
till the RT side settles down and go for a better matching interface
as necessary.

> > v3: - Added "cpu.weight.nice" to allow using nice values when
> >       configuring the weight.  The feature is requested by PeterZ.
> >     - Merge the patch to enable threaded support on cpu and cpuacct.
> 
> >     - Dropped the bits about getting rid of cpuacct from patch
> >       description as there is a pretty strong case for making cpuacct
> >       an implicit controller so that basic cpu usage stats are always
> >       available.
> 
> What about the whole double accounting thing? Because currently cpuacct
> and cpu do a fair bit of duplication. It would be very good to get rid
> of that.

I'm not that sure at this point.  Here are my current thoughts on
cpuacct.

* It is useful to have basic cpu statistics on cgroup without having
  to enable the cpu controller, especially because enabling cpu
  controller always changes how cpu cycles are distributed and
  currently comes at some performance overhead.

* On cgroup2, there is only one hierarchy.  It'd be great to have
  basic resource accounting enabled by default on all cgroups.  Note
  that we couldn't do that on v1 because there could be any number of
  hierarchies and the cost would increase with the number of
  hierarchies.

* It is bothersome that we're walking up the tree each time for
  cpuacct although being percpu && just walking up the tree makes it
  relatively cheap.  Anyways, I'm thinking about shifting the
  aggregation to the reader side so that the hot path always only
  updates local counters in a way which can scale even when there are
  a lot of (idle) cgroups.  Will follow up on this later.

Thanks.

-- 
tejun
