From: Dave Chiluk <chiluk+linux@indeed.com>
Subject: Re: [PATCH v2 1/1] sched/fair: Fix low cpu usage with high throttling
 by removing expiration of cpu-local slices
Date: Tue, 28 May 2019 17:25:22 -0500
Message-ID: <CAC=E7cVrLFDOm3uNQ_45DzmMVJ_i9bNvjsi7yRPaPe0HcaykUg@mail.gmail.com>
References: <1558121424-2914-1-git-send-email-chiluk+linux@indeed.com>
 <1558637087-20283-1-git-send-email-chiluk+linux@indeed.com>
 <1558637087-20283-2-git-send-email-chiluk+linux@indeed.com>
 <CAFTs51W0KdK4nw6wydn2HjNYvFRC8DYMmVeKX9FAe+4YUGEAZg@mail.gmail.com>
 <20190524143204.GB4684@lorien.usersys.redhat.com> <CAC=E7cXxsyMLw1PR+8QchTH8FYL7WX6_8LBVdqueR1yjW+VVkQ@mail.gmail.com>
 <CAFTs51Vm258CkDXi_Jj_cGOMotTvhdYR_VW8aUwAUvgistZOFQ@mail.gmail.com>
 <CAC=E7cXVrGRKMNkJPhd4fJi7wgdYk=YcXPV7B8GVNL5M69BarQ@mail.gmail.com> <CAFTs51VhpDk9iW5UT62CkPCN3SjgUHHO1nVqhe+ssHMYqou6Bg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M9EQwLvAO9oXFChsQAamKMxe068zBhP/svdhcV040aU=;
        b=oZO5Y0/DQnUWbpFkchPEk+KHgUZmbFsV53HDF5Y2snBl8sfk23OBpMHuYhiQnjogbn
         Pypla7gFHvnyePY6+WprzNqKLk3FagutRMWa9TFsABvcrJGecUYKfDQk8MBHawwtWdLt
         nT+OHEv2XEM1YDavmsCLBLsIK2pCcvpfcsM94=
In-Reply-To: <CAFTs51VhpDk9iW5UT62CkPCN3SjgUHHO1nVqhe+ssHMYqou6Bg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Oskolkov <posk@posk.io>
Cc: Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Brendan Gregg <bgregg@netflix.com>, Kyle Anderson <kwa@yelp.com>, Gabriel Munos <gmunoz@netflix.com>, John Hammond <jhammond@indeed.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, Ben Segall <bsegall@google.com>

On Fri, May 24, 2019 at 5:07 PM Peter Oskolkov <posk@posk.io> wrote:
> Linux CPU scheduling tail latency is a well-known issue and a major
> pain point in some workloads:
> https://www.google.com/search?q=linux+cpu+scheduling+tail+latency
>
> Even assuming that nobody noticed this particular cause
> of CPU scheduling latencies, it does not mean the problem should be waved
> away. At least it should be documented, if at this point it decided that
> it is difficult to address it in a meaningful way. And, preferably, a way
> to address the issue later on should be discussed and hopefully agreed to.

Pursuing reducing tail latencies for our web application is the
precise reason I created this patch set.  Those applications that
previously were responding in 20ms 95% where now taking 220ms.  Those
were correctly sized applications prior to 512ac999. After which, they
started seeing massive increases in their latencies  due to hitting
throttling with lower than quota amounts of cpu usage.

I'll see if I can rework the documentation.  Any specific
suggestions for how that can be worded would be appreciated.
