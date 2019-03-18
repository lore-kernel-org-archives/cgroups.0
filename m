From: Dave Chiluk <chiluk+linux@indeed.com>
Subject: Cgroup cpu throttling with low cpu usage of multi-threaded
 applications on high-core count machines
Date: Mon, 18 Mar 2019 09:59:32 -0500
Message-ID: <CAC=E7cV_2QtXQ-mx4-GfHLyAWxW+7Ub75UmMvOLxLXzot47TWw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=ws4FJo5ukAEQiG439+2y1DKalwBDgyKq1PiNzms22Kw=;
        b=HxkosBIxEqzFF/0kkCpxkInPNuqViBtIZlV/vU4WhawG6sbQB8AVEsyBz999V/9jaJ
         xdh7fW4uI57qpZA2L+eN7jvTV/hKO7j2h2CjlnT7CxXff+O0ZBt0yRuukhvE5qSm25Mg
         cvVywpPROngtZu8fWfulOhe0adi5s0VyZLUBg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Brendan Gregg <bgregg@netflix.com>, Kyle Anderson <kwa@yelp.com>, Gabriel Munos <gmunoz@netflix.com>, John Hammond <jhammond@indeed.com>, Cong Wang <xiyou.wangcong@gmail.com>

We are seeing a high amount of cgroup cpu throttling, as measured by
nr_throttled/nr_periods, while also seeing low cpu usage when running
highly threaded applications on high core-count machines. In
particular we are seeing this on "thread pool" design pattern
applications that are being run on kubernetes cpu with hard limits.
We've seen similar issues on other microservice cloud architectures
that utilize cgroup cpu constraints.  Most information out there about
this problem is to over-commit cpu which is wasteful, or turn off hard
limits and rely on the cpu_shares mechanism instead.

We=E2=80=99ve root caused this to bandwitdth_slices being allocated to
runqueues that own threads that do little work.  This results in the
primary =E2=80=9Cfast=E2=80=9D worker threads being starved for runtime/thr=
ottled,
while runtime allocated to the cfs_rq=E2=80=99s of the less productive thre=
ads
goes unused.  Eventually the time slices on the less productive thread
expires wasting cpu quota.

This issue is exacerbated even further as you move from 8 core -> 80
core machines, as slices are allocated and left unused to that many
more cfs_rq=E2=80=99s.  With an 80 core machine assigning the default time
slice (5ms) to each cfs_rq requires 400ms quota per 100ms period
simply to allow each cfs_rq to have one time slice which is 4 CPUs
worth of quota.  In reality tasks rarely get spread out to every core
like this, but that is only the worst case scenario.  This is also why
we saw a performance regression when moving from older 46 core
machines to newer 80 core machines.  Now that the world is moving to
micro-services architectures such as kubernetes, more and more
applications are being run with cgroup cpu constraints like this.

I have created an artificial C testcase that reproduces that problem
and have posted it at
https://github.com/indeedeng/fibtest

I have used that testcase to identify 512ac99 as the source of this
performance regression.  However as far as I can tell 512ac99 is
technically a correct patch. Instead what was happening before is that
the runtime on each cfs_rq would almost never be expired because the
following conditional would almost always be true.

vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
static void expire_cfs_rq_runtime(struct cfs_rq *cfs_rq)
...
if (cfs_rq->runtime_expires !=3D cfs_b->runtime_expires) {
       /* extend local deadline, drift is bounded above by 2 ticks */
       cfs_rq->runtime_expires +=3D TICK_NSEC;
..
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I verified this by adding a variable to the cfs_bandwidth structure
that counted all of the runtime_remaining that would've been expired,
in the else clause of this if and found that it was never hit pre
512ac99 on my test machines.  However after 512ac99 lots of runtime
would be expired. I understand that this experience is different from
the submitters of 512ac99, and I suspect there may be some
architecture or configuration difference at play there.  So looking
back at commit 51f2176d which introduced the above logic, the behavior
appears to have existed since 3.16.

Cong Wang submitted a patch that happens to work around this, by
implementing bursting based on idle time
https://lore.kernel.org/patchwork/patch/907450/.  However beneficial,
that patch is orthogonal to the root cause of this problem, but I
wanted to mention it.

So my question is what should be done?
1. Make the expiration time of a time slice configurable with the
default set to INF to match the behavior of the kernel as it existed
v3.16..v4.18-rc4.
2. Another option that should work afaik would be to remove all the
cfs_bandwidth time slice expiration logic, as time slices naturally
expire as they get used anyways.  This is actually my preferred course
of action as it's most performant, and it removes what appears to be
some very hardware sensitive logic.  Additionally the hard limit
description still holds true albeit not strictly per each accounting
period.  However since no one has complained about that over the 5
years it was broken, I think it's pretty safe to assume that very few
people are actually watching that carefully.  Instead it's a much
worse user experience when you ask for .5 cpu, and are only able to
use .1 of it while being throttled because of time slice expiration.

Thank you,
Dave Chiluk
p.s. I've copied representatives of Netflix and Yelp as well, as we
were talking about this at the Scale 17x conference. There we
discovered we had all individually hit this issue and had it on
roadmaps to fix.
