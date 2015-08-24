From: Paul Turner <pjt@google.com>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified hierarchy
Date: Mon, 24 Aug 2015 15:03:05 -0700
Message-ID: <CAPM31R+Mnk=AL6h05eMMQvPEEfnjkB3iGb+oZj28jAQ9-ajOxA@mail.gmail.com>
References: <20150818203117.GC15739@mtj.duckdns.org> <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org> <55DB3C76.5010009@gmail.com>
 <20150824170427.GA27262@mtj.duckdns.org> <CAPM31RJi07qs42YsH=4JQSbZ+J-zCLv8e7yELb3tF_qAZmLqRA@mail.gmail.com>
 <20150824210223.GH28944@mtj.duckdns.org> <CAPM31R+i7BD8x9h_6wZVTa0zCB7XP0SGL5dSA-n6h9PTeAEhug@mail.gmail.com>
 <20150824211707.GJ28944@mtj.duckdns.org> <CAPM31R+vt1oAPCB-q6570RqZtJVBu5MH=gcQD2m9mjauStV7MA@mail.gmail.com>
 <20150824214000.GL28944@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=QXsvxIEBYBWiLzD+oJJRih7i/VhJXEIPbdzNMFFG0m4=;
        b=nG3wkUTtZI6arlaJLIOKzTqCEXUbo7tOJjn6pVNdbi7JdYL4gB1ETWDTe6IYXHVVXd
         RVtRVu6SgkQ3QGkoz0sYtyWaDWEg6QjUKwSHMgDXI971r61lPUlRsKrWllUncnv0duzw
         +zZHHdpgxduIGmdsr4UaEs6sUhYuzUcGy6dSWHIt1uGAd50v3nEpk3PeedS9Dojj17tf
         2CR7B6ivY6H0dLVTo/2+nWeOrrSRbqdiQI2Gq1QFts6ZNLAtMsongELpdFHCYyMK7Wrc
         HEk2Yk3Dzf0ZQWLFs+AAUDCzq1a6mW4gAdgZd47VMtwZL3emF3ZWO30kxdtE0YjHsRim
         PMDQ==
In-Reply-To: <20150824214000.GL28944@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, lizefan@huawei.com, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

On Mon, Aug 24, 2015 at 2:40 PM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Aug 24, 2015 at 02:19:29PM -0700, Paul Turner wrote:
>> > Would it be possible for you to give realistic and concrete examples?
>> > I'm not trying to play down the use cases but concrete examples are
>> > usually helpful at putting things in perspective.
>>
>> I don't think there's anything that's not realistic or concrete about
>> the example above.  The "suppose" parts were only for qualifying the
>> pool sizes for vcpu and non-vcpu threads above since discussion of
>> implementation using nice is dependent on knowing these counts.
>
> Hmm... I was hoping for an actual configurations and usage scenarios.
> Preferably something people can set up and play with.

This is much easier to set up and play with synthetically.  Just
create the 10 threads and 100 threads above then experiment with
configurations designed at guaranteeing the set of 100 threads
relatively uniform throughput regardless of how many are active.   I
don't think trying to run a VM stack adds anything except complexity
of reproduction here.

> I take that the
> CPU intensive helper threads are usually IO workers?  Is the scenario
> where the VM is set up with a lot of IO devices and different ones may
> consume large amount of CPU cycles at any given point?

Yes, generally speaking there are a few major classes of IO (flash,
disk, network) that a guest may invoke.  Each of these backends is
separate and chooses its own threading.
