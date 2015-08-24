From: Paul Turner <pjt@google.com>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified hierarchy
Date: Mon, 24 Aug 2015 14:00:54 -0700
Message-ID: <CAPM31R+ckFO5vNG4L5+h-yokFaZQz6kHe5a+pkRCfbL0H+NjXg@mail.gmail.com>
References: <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org> <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org> <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org> <55DB3C76.5010009@gmail.com>
 <20150824170427.GA27262@mtj.duckdns.org> <55DB77F1.5080802@gmail.com> <20150824202509.GF28944@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=3ZjLO6YFemoYPcdhanVl5CibTDNDeWOXOckJ8kbTWYM=;
        b=StFZxvpWNQewLuGiBPtU/bKJ5dibg0L+NA143a21VjozLgKnxsUI4iL7tqVZN/WBEO
         eQsVKGC4oGDBoAb4l6z8COk9PAiYo2lO76acVEbb7Hc9Zq12BdgP9Lo7+MI0Cb5LM6Ar
         W/XgkNqfTFHFWFto8flCqOqLbQdu7lXLqKj/+5kpdpQcxaNa31FifdgpUQxfEN6KwGzr
         a9ems9UZkOVrYRYCmI6cruYN3XrGy6X94C/Ki/pIj8H+BepyDjDtDciVVI3Fg9ZOL+1x
         UCSJhBQn4U1x7cKm8hnOa4dXvPAPwkc/66eiyJYpsda50Zd5yVssWHNSLYKkx3kMMOuW
         pfXA==
In-Reply-To: <20150824202509.GF28944@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, lizefan@huawei.com, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

On Mon, Aug 24, 2015 at 1:25 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Austin.
>
> On Mon, Aug 24, 2015 at 04:00:49PM -0400, Austin S Hemmelgarn wrote:
>> >That alone doesn't require hierarchical resource distribution tho.
>> >Setting nice levels reasonably is likely to alleviate most of the
>> >problem.
>>
>> In the cases I've dealt with this myself, nice levels didn't cut it, and I
>> had to resort to SCHED_RR with particular care to avoid priority inversions.
>
> I wonder why.  The difference between -20 and 20 is around 2500x in
> terms of weight.  That should have been enough for expressing whatever
> precedence the vcpus should have over other threads.

This strongly perturbs the load-balancer which performs busiest cpu
selection by weight.

Note that also we do not necessarily want total dominance by vCPU
threads, the hypervisor threads are almost always doing work on their
behalf and we want to provision them with _some_ time.  A
sub-hierarchy allows this to be performed in a way that is independent
of how many vCPUs or support threads that are present.

>
>> >I don't know.  "Someone running one or two VM's on a laptop under
>> >QEMU" doesn't really sound like the use case which absolutely requires
>> >hierarchical cpu cycle distribution.
>>
>> It depends on the use case.  I never have more than 2 VM's running on my
>> laptop (always under QEMU, setting up Xen is kind of pointless ona quad core
>> system with only 8G of RAM), and I take extensive advantage of the cpu
>> cgroup to partition resources among various services on the host.
>
> Hmmm... I'm trying to understand the usecases where having hierarchy
> inside a process are actually required so that we don't end up doing
> something complex unnecessarily.  So far, it looks like an easy
> alternative for qemu would be teaching it to manage priorities of its
> threads given that the threads are mostly static - vcpus going up and
> down are explicit operations which can trigger priority adjustments if
> necessary, which is unlikely to begin with.

What you're proposing is both unnecessarily complex and imprecise.
Arbitrating competition between groups of threads is exactly why we
support sub-hierarchies within cpu.

>
> Thanks.
>
> --
> tejun
