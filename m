From: Paul Turner <pjt@google.com>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified hierarchy
Date: Mon, 24 Aug 2015 14:10:17 -0700
Message-ID: <CAPM31R+i7BD8x9h_6wZVTa0zCB7XP0SGL5dSA-n6h9PTeAEhug@mail.gmail.com>
References: <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org> <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org> <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org> <55DB3C76.5010009@gmail.com>
 <20150824170427.GA27262@mtj.duckdns.org> <CAPM31RJi07qs42YsH=4JQSbZ+J-zCLv8e7yELb3tF_qAZmLqRA@mail.gmail.com>
 <20150824210223.GH28944@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=jV8X88jOaBGEwFw45k/6R+fCOul/yG0JhRFV/fqSt+I=;
        b=H02kaDl4oQRhy2qsDUdZKjnqCbgQXRqB4U586TIrZwT4f2ZsjNH9oocerMBV+pnzL4
         lJfMJOlMBSfLjXMNsiPSLVdKHKo/dg3B/Uk8gX8zfpYnzAWJK/v/7nKZnqL+2bq+5Jnn
         gqD8RmBqI2BZz+xMeK8eJhAvwnyZpnLfrNtx7VSMnBhFa0h3puBHGEy60LbPA0ILKNMm
         4bleyMx9UeQ8MSRLQCj0c1+wmxGSa0rWVQr4GUfpYXmHnnictRxg0P+58FqTTJh5kUbF
         /fZgwAiV8+Ix+sZWTe0EkhBhQgb0bBZND47sLRtEhhttBoOlVYGfxujQxilm3k+tO/M+
         6U8g==
In-Reply-To: <20150824210223.GH28944@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, lizefan@huawei.com, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

On Mon, Aug 24, 2015 at 2:02 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Mon, Aug 24, 2015 at 01:54:08PM -0700, Paul Turner wrote:
>> > That alone doesn't require hierarchical resource distribution tho.
>> > Setting nice levels reasonably is likely to alleviate most of the
>> > problem.
>>
>> Nice is not sufficient here.  There could be arbitrarily many threads
>> within the hypervisor that are not actually hosting guest CPU threads.
>> The only way to have this competition occur at a reasonably fixed
>> ratio is a sub-hierarchy.
>
> I get that having hierarchy of threads would be nicer but am having a
> bit of difficulty seeing why adjusting priorities of threads wouldn't
> be sufficient.  It's not like threads of the same process competing
> with each other is a new problem.  People have been dealing with it
> for ages.  Hierarchical management can be a nice plus but we want the
> problem and proposed solution to be justifiable.

Consider what happens with load asymmetry:

Suppose that we have 10 vcpu threads and 100 support threads.
Suppose that we want the support threads to receive up to 10% of the
time available to the VM as a whole on that machine.

If I have one particular support thread that is busy, I want it to
receive that entire 10% (maybe a guest is pounding on scsi for
example, or in the thread-pool case, I've passed a single expensive
computation).  Conversely, suppose the guest is doing lots of
different things and several support threads are active, I want the
time to be shared between them.

There is no way to implement this with nice.  Either a single thread
can consume 10%, and the group can dominate, or the group cannot
dominate and the single thread can be starved.

>
> Thanks.
>
> --
> tejun
