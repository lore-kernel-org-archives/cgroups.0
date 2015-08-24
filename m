From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Mon, 24 Aug 2015 21:18:21 +0200
Message-ID: <1440443901.2891.72.camel@gmail.com>
References: <20150804090711.GL25159@twins.programming.kicks-ass.net>
	 <20150804151017.GD17598@mtj.duckdns.org>
	 <20150805091036.GT25159@twins.programming.kicks-ass.net>
	 <20150805143132.GK17598@mtj.duckdns.org>
	 <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
	 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
	 <20150818203117.GC15739@mtj.duckdns.org>
	 <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
	 <20150822182916.GE20768@mtj.duckdns.org> <55DB3C76.5010009@gmail.com>
	 <20150824170427.GA27262@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=2hqVAugQHoZv14aawwtbQivTQn8qkN4QQuvlm9AFbPA=;
        b=PPsWaUzj3kSsMftuJygpR4y7D7Wbw9CYDrX5LjyIyqhvLsn0qpsDD5VBs5fpBZ6E5C
         uMT2Wf7Bnl5/XzLGrRv9l3sLIbmsHXDdk3QeNXrRGuq3la6gzSOfTwewLVk8CQkm4oBz
         Y/s8Maq9TDvMqQ4Kj08O8Q7I6FPneEJ47kAH+KsBD2mcrdvw3HPInYNx/YmAehXvO7BS
         /mQsxwRGT9e1dqzoEsfba4YRlCM5ZX9UNuctUS9R8Ng3hr0fwqL+8KLPYliAgNBzv8FE
         WAKCOANxJQgfO572GNH5D6m/ziC4EcSXLxpSq5E6L+DpVT9NyeDb2RzsIj5sIi2Q3K0H
         a67Q==
In-Reply-To: <20150824170427.GA27262-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, 2015-08-24 at 13:04 -0400, Tejun Heo wrote:
> Hello, Austin.
> 
> On Mon, Aug 24, 2015 at 11:47:02AM -0400, Austin S Hemmelgarn wrote:
> > >Just to learn more, what sort of hypervisor support threads are we
> > >talking about?  They would have to consume considerable amount of cpu
> > >cycles for problems like this to be relevant and be dynamic in numbers
> > >in a way which letting them competing against vcpus makes sense.  Do
> > >IO helpers meet these criteria?
> > >
> > Depending on the configuration, yes they can.  VirtualBox has some rather
> > CPU intensive threads that aren't vCPU threads (their emulated APIC thread
> > immediately comes to mind), and so does QEMU depending on the emulated
> 
> And the number of those threads fluctuate widely and dynamically?
> 
> > hardware configuration (it gets more noticeable when the disk images are
> > stored on a SAN and served through iSCSI, NBD, FCoE, or ATAoE, which is
> > pretty typical usage for large virtualization deployments).  I've seen cases
> > first hand where the vCPU's can make no reasonable progress because they are
> > constantly getting crowded out by other threads.

Hm. Serious CPU starvation would seem to require quite a few hungry
threads, but even a few IO threads with kick butt hardware under them
could easily tilt fairness heavily in favor of VPUs generating IO.

> That alone doesn't require hierarchical resource distribution tho.
> Setting nice levels reasonably is likely to alleviate most of the
> problem.

Unless the CPU controller is in use.

	-Mike
