From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Mon, 24 Aug 2015 13:04:27 -0400
Message-ID: <20150824170427.GA27262@mtj.duckdns.org>
References: <20150804090711.GL25159@twins.programming.kicks-ass.net>
 <20150804151017.GD17598@mtj.duckdns.org>
 <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org>
 <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org>
 <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org>
 <55DB3C76.5010009@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ZFymaT8PPZmsEYEMQzvlxDEqEai9XcrNXS2FDfISqZE=;
        b=whoqUNIuK+Z61prmtrV41gxpEiPbEwsO1lvYxykfDxcW9qq7X1fFzhVJP5jZplCa08
         64khVbZ+TRPBmrtaFRNSvCUC550tLbN5mdmXk6zfdegQDcg0F2qxc6eaYYFb/aw/4tpQ
         NqKv20N1gtzY1s8wApK59FPHKKTBeroZWKD6OEN6q0eXbj514Q71RcTMXDTZdeC5XfRW
         KKlPo9QVPIkJ1SPTyg8mxCXjk12HYM/SjcAD3BuD0BDuKayZvGIZTr0YTvn0P2HkVofC
         2Ac8Vje+gHbPevhTmbiW1JcniE/I20dD1ock+SWUUXtZ9LxGZhfWc2C/SbqTWfz/V2rN
         bx0g==
Content-Disposition: inline
In-Reply-To: <55DB3C76.5010009@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, lizefan@huawei.com, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

Hello, Austin.

On Mon, Aug 24, 2015 at 11:47:02AM -0400, Austin S Hemmelgarn wrote:
> >Just to learn more, what sort of hypervisor support threads are we
> >talking about?  They would have to consume considerable amount of cpu
> >cycles for problems like this to be relevant and be dynamic in numbers
> >in a way which letting them competing against vcpus makes sense.  Do
> >IO helpers meet these criteria?
> >
> Depending on the configuration, yes they can.  VirtualBox has some rather
> CPU intensive threads that aren't vCPU threads (their emulated APIC thread
> immediately comes to mind), and so does QEMU depending on the emulated

And the number of those threads fluctuate widely and dynamically?

> hardware configuration (it gets more noticeable when the disk images are
> stored on a SAN and served through iSCSI, NBD, FCoE, or ATAoE, which is
> pretty typical usage for large virtualization deployments).  I've seen cases
> first hand where the vCPU's can make no reasonable progress because they are
> constantly getting crowded out by other threads.

That alone doesn't require hierarchical resource distribution tho.
Setting nice levels reasonably is likely to alleviate most of the
problem.

> The use of the term 'hypervisor support threads' for this is probably not
> the best way of describing the contention, as it's almost always a full
> system virtualization issue, and the contending threads are usually storage
> back-end access threads.
> 
> I would argue that there are better ways to deal properly with this (Isolate
> the non vCPU threads on separate physical CPU's from the hardware emulation
> threads), but such methods require large systems to be practical at any
> scale, and many people don't have the budget for such large systems, and
> this way of doing things is much more flexible for small scale use cases
> (for example, someone running one or two VM's on a laptop under QEMU or
> VirtualBox).

I don't know.  "Someone running one or two VM's on a laptop under
QEMU" doesn't really sound like the use case which absolutely requires
hierarchical cpu cycle distribution.

Thanks.

-- 
tejun
