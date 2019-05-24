From: Dave Chiluk <chiluk+linux@indeed.com>
Subject: Re: [PATCH v2 1/1] sched/fair: Fix low cpu usage with high throttling
 by removing expiration of cpu-local slices
Date: Fri, 24 May 2019 10:14:36 -0500
Message-ID: <CAC=E7cXxsyMLw1PR+8QchTH8FYL7WX6_8LBVdqueR1yjW+VVkQ@mail.gmail.com>
References: <1558121424-2914-1-git-send-email-chiluk+linux@indeed.com>
 <1558637087-20283-1-git-send-email-chiluk+linux@indeed.com>
 <1558637087-20283-2-git-send-email-chiluk+linux@indeed.com>
 <CAFTs51W0KdK4nw6wydn2HjNYvFRC8DYMmVeKX9FAe+4YUGEAZg@mail.gmail.com> <20190524143204.GB4684@lorien.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QKLfYJyC3pKaeS6F7jFzdQyiyzLOg1HgkzY2ER2lf8E=;
        b=SyJyK7bqOaMgHMjzDpJD7dAwjgOIEi1xlEARg3dMKeAMKWck3EhGPDjqP3Nh4hmz1D
         N6RkEfG1q17Dn79D9gw30IPA1hQljik6lSpT9pcuHQWSC0uWEpj2+lu366snnFzTXXZE
         uM4krkIXH4V6O5L0XG32GACEDXsUx3lL9SeA4=
In-Reply-To: <20190524143204.GB4684@lorien.usersys.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Phil Auld <pauld@redhat.com>
Cc: Peter Oskolkov <posk@posk.io>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Brendan Gregg <bgregg@netflix.com>, Kyle Anderson <kwa@yelp.com>, Gabriel Munos <gmunoz@netflix.com>, John Hammond <jhammond@indeed.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, Ben Segall <bsegall@google.com>

On Fri, May 24, 2019 at 9:32 AM Phil Auld <pauld@redhat.com> wrote:
> On Thu, May 23, 2019 at 02:01:58PM -0700 Peter Oskolkov wrote:

> > If the machine runs at/close to capacity, won't the overallocation
> > of the quota to bursty tasks necessarily negatively impact every other
> > task? Should the "unused" quota be available only on idle CPUs?
> > (Or maybe this is the behavior achieved here, and only the comment and
> > the commit message should be fixed...)
> >
>
> It's bounded by the amount left unused from the previous period. So
> theoretically a process could use almost twice its quota. But then it
> would have nothing left over in the next period. To repeat it would have
> to not use any that next period. Over a longer number of periods it's the
> same amount of CPU usage.
>
> I think that is more fair than throttling a process that has never used
> its full quota.
>
> And it removes complexity.
>
> Cheers,
> Phil

Actually it's not even that bad.  The overallocation of quota to a
bursty task in a period is limited to at most one slice per cpu, and
that slice must not have been used in the previous periods.  The slice
size is set with /proc/sys/kernel/sched_cfs_bandwidth_slice_us and
defaults to 5ms.  If a bursty task goes from underutilizing quota to
using it's entire quota, it will not be able to burst in the
subsequent periods.  Therefore in an absolute worst case contrived
scenario, a bursty task can add at most 5ms to the latency of other
threads on the same CPU.  I think this worst case 5ms tradeoff is
entirely worth it.

This does mean that a theoretically a poorly written massively
threaded application on an 80 core box, that spreads itself onto 80
cpu run queues, can overutilize it's quota in a period by at most 5ms
* 80 CPUs in a sincle period (slice * number of runqueues the
application is running on).  But that means that each of those threads
 would have had to not be use their quota in a previous period, and it
also means that the application would have to be carefully written to
exacerbate this behavior.

Additionally if cpu bound threads underutilize a slice of their quota
in a period due to the cfs choosing a bursty task to run, they should
theoretically be able to make it up in the following periods when the
bursty task is unable to "burst".

Please be careful here quota and slice are being treated differently.
Quota does not roll-over between periods, only slices of quota that
has already been allocated to per cpu run queues. If you allocate
100ms of quota per period to an application, but it only spreads onto
3 cpu run queues that means it can in the worst case use 3 x slice
size = 15ms in periods following underutilization.

So why does this matter.  Well applications that use thread pools
*(*cough* java *cough*) with lots of tiny little worker threads, tend
to spread themselves out onto a lot of run queues.  These worker
threads grab quota slices in order to run, then rarely use all of
their slice (1 or 2ms out of the 5ms).  This results in those worker
threads starving the main application of quota, and then expiring the
remainder of that quota slice on the per-cpu.  Going back to my
earlier 100ms quota / 80 cpu example.  That means only
100ms/cfs_bandwidth_slice_us(5ms) = 20 slices are available in a
period.  So only 20 out of these 80 cpus ever get a slice allocated to
them.  By allowing these per-cpu run queues to use their remaining
slice in following periods these worker threads do not need to be
allocated additional slice, and thereby the main threads are actually
able to use the allocated cpu quota.

This can be experienced by running fibtest available at
https://github.com/indeedeng/fibtest/.
$ runfibtest 1
runs a single fast thread taskset to cpu 0
$ runfibtest 8
Runs a single fast thread taskset to cpu 0, and 7 slow threads taskset
to cpus 1-7.  This run is expected to show less iterations, but the
worse problem is that the cpu usage is far less than the 500ms that it
should have received.

Thanks for the engagement on this,
Dave Chiluk
