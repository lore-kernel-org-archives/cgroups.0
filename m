From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified hierarchy
Date: Mon, 24 Aug 2015 13:54:08 -0700
Message-ID: <CAPM31RJi07qs42YsH=4JQSbZ+J-zCLv8e7yELb3tF_qAZmLqRA@mail.gmail.com>
References: <20150804090711.GL25159@twins.programming.kicks-ass.net>
 <20150804151017.GD17598@mtj.duckdns.org> <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org> <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org> <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org> <55DB3C76.5010009@gmail.com> <20150824170427.GA27262@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=zB+TIFinCFTpm0dE+eE9rJkjwX5rZjJnxYLmvdoc0xM=;
        b=YYKX1Dw0cm0waOePqC76GLa6bgEuP5Qxc3k1AwCV7SmrTqo6w+xC1tg78F7yGh4Qpx
         aMvNQW2g9APxZouXwfO7iHVn1D6RJCQLTBKaBJrWrdVDrXLAF474kLv2QsK/XWIdJYcW
         GDd40UK4s3m2oNq0xGggtgLQwaMP+CG+P7S8/7CtFShi7HHNKdVdQl3+8rctPVCahUP1
         feJs5Y2lH5HglRHBayttuEAzbXG62gZBsjdWuF37lJu7tnQ3u4YZdMPEhfaMJfTXazID
         LdK75UpzUjKzl16pvKMZTQEHJ8+CArhBmeZQSgsD9FB+XElJDkkrZos+fhuXz8tn0Tc5
         +vRw==
In-Reply-To: <20150824170427.GA27262-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, Aug 24, 2015 at 10:04 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Austin.
>
> On Mon, Aug 24, 2015 at 11:47:02AM -0400, Austin S Hemmelgarn wrote:
>> >Just to learn more, what sort of hypervisor support threads are we
>> >talking about?  They would have to consume considerable amount of cpu
>> >cycles for problems like this to be relevant and be dynamic in numbers
>> >in a way which letting them competing against vcpus makes sense.  Do
>> >IO helpers meet these criteria?
>> >
>> Depending on the configuration, yes they can.  VirtualBox has some rather
>> CPU intensive threads that aren't vCPU threads (their emulated APIC thread
>> immediately comes to mind), and so does QEMU depending on the emulated
>
> And the number of those threads fluctuate widely and dynamically?
>
>> hardware configuration (it gets more noticeable when the disk images are
>> stored on a SAN and served through iSCSI, NBD, FCoE, or ATAoE, which is
>> pretty typical usage for large virtualization deployments).  I've seen cases
>> first hand where the vCPU's can make no reasonable progress because they are
>> constantly getting crowded out by other threads.
>
> That alone doesn't require hierarchical resource distribution tho.
> Setting nice levels reasonably is likely to alleviate most of the
> problem.

Nice is not sufficient here.  There could be arbitrarily many threads
within the hypervisor that are not actually hosting guest CPU threads.
The only way to have this competition occur at a reasonably fixed
ratio is a sub-hierarchy.

>
>> The use of the term 'hypervisor support threads' for this is probably not
>> the best way of describing the contention, as it's almost always a full
>> system virtualization issue, and the contending threads are usually storage
>> back-end access threads.
>>
>> I would argue that there are better ways to deal properly with this (Isolate
>> the non vCPU threads on separate physical CPU's from the hardware emulation
>> threads), but such methods require large systems to be practical at any
>> scale, and many people don't have the budget for such large systems, and
>> this way of doing things is much more flexible for small scale use cases
>> (for example, someone running one or two VM's on a laptop under QEMU or
>> VirtualBox).
>
> I don't know.  "Someone running one or two VM's on a laptop under
> QEMU" doesn't really sound like the use case which absolutely requires
> hierarchical cpu cycle distribution.
>

We run more than 'one or two' VMs using this configuration.  :)
