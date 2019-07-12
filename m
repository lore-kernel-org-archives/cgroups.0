From: bsegall@google.com
Subject: Re: [PATCH v5 1/1] sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices
Date: Fri, 12 Jul 2019 15:09:57 -0700
Message-ID: <xm26muhikiq2.fsf@bsegall-linux.svl.corp.google.com>
References: <1558121424-2914-1-git-send-email-chiluk+linux@indeed.com>
        <1561664970-1555-1-git-send-email-chiluk+linux@indeed.com>
        <1561664970-1555-2-git-send-email-chiluk+linux@indeed.com>
        <xm26lfxhwlxr.fsf@bsegall-linux.svl.corp.google.com>
        <20190711095102.GX3402@hirez.programming.kicks-ass.net>
        <xm26v9w8jwgl.fsf@bsegall-linux.svl.corp.google.com>
        <CAC=E7cV4sO50NpYOZ06n_BkZTcBqf1KQp83prc+oave3ircBrw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=zuU348vMM9aXraE4ccy+eAHv0CShi7BKwdNOAqDmvDI=;
        b=NFurjCS4ooi0Fvo+RA6fYOmAV3aI9uoCXtAdcbExWzcIftI8DfV9JB8MhRl69Nkd12
         WJlgvG6DaRBT85EjBYvmNsJOMUBjLpOwKA8/MF6ehv7mq7G2SQDEX+RScKErCld4Oh9n
         lx5EEDhrlZvfID2u1YwWjPNskhw8Msgc1X2OpGnLqrmXlt123SbRgZQKprlIhWhxHowA
         TFO95zYgyxnLNE1dsmf/IhAx9WFRQHstemWHiXAeZf3/oQbfFufly73Y48mzb1yXanjg
         PtQD6sHac7/JTOtjepbHEuZ7hG6AzXCbirlxWuFgsUgBTQe5LnVv2jdiqCqZ0ALh3FsT
         nm3g==
In-Reply-To: <CAC=E7cV4sO50NpYOZ06n_BkZTcBqf1KQp83prc+oave3ircBrw@mail.gmail.com>
        (Dave Chiluk's message of "Thu, 11 Jul 2019 18:48:24 -0500")
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chiluk <chiluk+linux@indeed.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Pqhil Auld <pauld@redhat.com>, Peter Oskolkov <posk@posk.io>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Brendan Gregg <bgregg@netflix.com>, Kyle Anderson <kwa@yelp.com>, Gabriel Munos <gmunoz@netflix.com>, John Hammond <jhammond@indeed.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, Paul Turner <pjt@google.com>

Dave Chiluk <chiluk+linux@indeed.com> writes:

> So I spent some more time testing this new patch as is *(interrupts disabled).  I know I probably should have fixed the patch, but it's hard to get time on big test hardware sometimes, and I was already well along my way with testing.
>
> In regards to the quota usage overage I was seeing earlier: I have a theory as to what might be happening here, and I'm pretty sure it's related to the IRQs being disabled during the rq->lock walk.  I think that the main fast thread was able to use an excess amount
> of quota because the timer interrupt meant to stop it wasn't being handled timely due to the interrupts being disabled.  On my 8 core machine this resulted in a what looked like simply improved usage of the quota, but when I ran the test on an 80 core machine I
> saw a massive overage of cpu usage when running fibtest.  Specifically when running fibtest for 5 seconds with 50ms quota/100ms period expecting ~2500ms of quota usage; I got 3731 ms of cpu usage which was an unexpected overage of 1231ms. Is that a
> reasonable theory?

I think I've figured out what's going on here (and a related issue
that gave me some inconsistency when trying to debug it): other "slow"
threads can wake up while the slack timer is in distribute and
double-spend some runtime. Since we lsub_positive rather than allow
cfs_b->runtime to be negative this double-spending is permanent, and can
go on indefinitely.

In addition, if things fall out in a slightly different way, all the
"slow" threads can wind up getting on cpu and claiming slices of runtime
before the "fast" thread, and then it just has to wait another slack
period to hope that the ordering winds up better that time. This just
depends on things like IPI latency and maybe what order things happened
to happen at the start of the period.

Ugh. Maybe we /do/ just give up and say that most people don't seem to
be using cfs_b in a way that expiration of the leftover 1ms matters.
