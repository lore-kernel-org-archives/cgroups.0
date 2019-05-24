From: Dave Chiluk <chiluk+linux@indeed.com>
Subject: Re: [PATCH v2 1/1] sched/fair: Fix low cpu usage with high throttling
 by removing expiration of cpu-local slices
Date: Fri, 24 May 2019 16:35:02 -0500
Message-ID: <CAC=E7cXVrGRKMNkJPhd4fJi7wgdYk=YcXPV7B8GVNL5M69BarQ@mail.gmail.com>
References: <1558121424-2914-1-git-send-email-chiluk+linux@indeed.com>
 <1558637087-20283-1-git-send-email-chiluk+linux@indeed.com>
 <1558637087-20283-2-git-send-email-chiluk+linux@indeed.com>
 <CAFTs51W0KdK4nw6wydn2HjNYvFRC8DYMmVeKX9FAe+4YUGEAZg@mail.gmail.com>
 <20190524143204.GB4684@lorien.usersys.redhat.com> <CAC=E7cXxsyMLw1PR+8QchTH8FYL7WX6_8LBVdqueR1yjW+VVkQ@mail.gmail.com>
 <CAFTs51Vm258CkDXi_Jj_cGOMotTvhdYR_VW8aUwAUvgistZOFQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=noDnUncx7v00BxHdUohQoEvRvQhcGRS8pbc3im08Y6w=;
        b=XkGCSwkf+gvLn+XdjFi6oK3HPEzI0RUs4ZqtQ0lOHGrQKFa0hwHkkjkQDO+7jwA6gC
         WYWPee8sG9gbw27iFQteMwZ78ZN7XW9kKpMa23LGy1HbSfZblj4tEItFv0nC1wtzn8XL
         0pfiZab5hvshimfRZ1ThgNinG45tn30mJAPM8=
In-Reply-To: <CAFTs51Vm258CkDXi_Jj_cGOMotTvhdYR_VW8aUwAUvgistZOFQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Oskolkov <posk@posk.io>
Cc: Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Brendan Gregg <bgregg@netflix.com>, Kyle Anderson <kwa@yelp.com>, Gabriel Munos <gmunoz@netflix.com>, John Hammond <jhammond@indeed.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, Ben Segall <bsegall@google.com>

On Fri, May 24, 2019 at 11:28 AM Peter Oskolkov <posk@posk.io> wrote:
>
> On Fri, May 24, 2019 at 8:15 AM Dave Chiluk <chiluk+linux@indeed.com> wrote:
> >
> > On Fri, May 24, 2019 at 9:32 AM Phil Auld <pauld@redhat.com> wrote:
> > > On Thu, May 23, 2019 at 02:01:58PM -0700 Peter Oskolkov wrote:
> >
> > > > If the machine runs at/close to capacity, won't the overallocation
> > > > of the quota to bursty tasks necessarily negatively impact every other
> > > > task? Should the "unused" quota be available only on idle CPUs?
> > > > (Or maybe this is the behavior achieved here, and only the comment and
> > > > the commit message should be fixed...)
> > > >
> > >
> > > It's bounded by the amount left unused from the previous period. So
> > > theoretically a process could use almost twice its quota. But then it
> > > would have nothing left over in the next period. To repeat it would have
> > > to not use any that next period. Over a longer number of periods it's the
> > > same amount of CPU usage.
> > >
> > > I think that is more fair than throttling a process that has never used
> > > its full quota.
> > >
> > > And it removes complexity.
> > >
> > > Cheers,
> > > Phil
> >
> > Actually it's not even that bad.  The overallocation of quota to a
> > bursty task in a period is limited to at most one slice per cpu, and
> > that slice must not have been used in the previous periods.  The slice
> > size is set with /proc/sys/kernel/sched_cfs_bandwidth_slice_us and
> > defaults to 5ms.  If a bursty task goes from underutilizing quota to
> > using it's entire quota, it will not be able to burst in the
> > subsequent periods.  Therefore in an absolute worst case contrived
> > scenario, a bursty task can add at most 5ms to the latency of other
> > threads on the same CPU.  I think this worst case 5ms tradeoff is
> > entirely worth it.
> >
> > This does mean that a theoretically a poorly written massively
> > threaded application on an 80 core box, that spreads itself onto 80
> > cpu run queues, can overutilize it's quota in a period by at most 5ms
> > * 80 CPUs in a sincle period (slice * number of runqueues the
> > application is running on).  But that means that each of those threads
> >  would have had to not be use their quota in a previous period, and it
> > also means that the application would have to be carefully written to
> > exacerbate this behavior.
> >
> > Additionally if cpu bound threads underutilize a slice of their quota
> > in a period due to the cfs choosing a bursty task to run, they should
> > theoretically be able to make it up in the following periods when the
> > bursty task is unable to "burst".
>
> OK, so it is indeed possible that CPU bound threads will underutilize a slice
> of their quota in a period as a result of this patch. This should probably
> be clearly stated in the code comments and in the commit message.
>
> In addition, I believe that although many workloads will indeed be
> indifferent to getting their fair share "later", some latency-sensitive
> workloads will definitely be negatively affected by this temporary
> CPU quota stealing by bursty antagonists. So there should probably be
> a way to limit this behavior; for example, by making it tunable
> per cgroup.
>
This patch restores the behavior that existed from at least
v3.16..v4.18, and the current Redhat 7 kernels.  So you are kind of
championing a moot point as no one has noticed this "bursting"
behavior in over 5 years.  By removing this slice expiration
altogether we restore the behavior and also solve the root issue of
'commit 512ac999d275 ("sched/fair: Fix bandwidth timer clock drift
condition")'.

Since 512ac999d275, many people are now noticing the slice expiration
and very displeased with the behavior change.
see: https://github.com/kubernetes/kubernetes/issues/67577

I would love to hear if you know of a single complaint during that 5
year time window, where someone noticed this bursting and reported
that it negatively affected their application.

As for the documentation, I thought about documenting the possible
adverse side-effect, but I didn't feel it was worthwhile since no one
had noticed that corner case in the 5 years.  I also could not figure
out a concise way of describing the slight corner case issue without
overly complicating the documentation.  I felt that adding that corner
case would have detracted rather than added to the documentation's
usefulness.  As far as commenting in code, considering most of this
commit removes lines, there's not a really great place for it.  That's
why I did my best to describe the behavior in the documentation.
Smart people can draw conclusions from there as you have done.  Please
keep in mind that this "bursting" is again limited to a single slice
on each per-cpu run-queue.

Thank you,
Dave
