From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] memcg: introduce per-memcg reclaim interface
Date: Mon, 5 Oct 2020 14:59:10 -0700
Message-ID: <CALvZod66T4-y2JQnN+favf6tnKkkFQ17HZ8EAAX0GXAcbO4v+w@mail.gmail.com>
References: <20200909215752.1725525-1-shakeelb@google.com> <20200928210216.GA378894@cmpxchg.org>
 <CALvZod7afgoAL7KyfjpP-LoSFGSHv7XtfbbnVhEEhsiZLqZu9A@mail.gmail.com> <20201001151058.GB493631@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LsnSp/dKPJAZzQDStydfHkWvldA7av+IiYeRmlTt4/8=;
        b=mz35yaD2r8hUgO+GSF0qAc5vVEH3SeonsFMI6KdZcoNNym7Pd6MsbUxcZddO1PUpwj
         FuSvqYFGvVTvOxAIBDiGdxHbcGf5apD+7AUJNzeh/DAQUGFCAn95imvjTx/aoQkuzizu
         GiHSQTfvzp1v+81QiEdV2g1IPvpclyBIRUaXJfuObYRAVWgnJcB1B+ho/ky6OW7bo+Xo
         w221HwZ1DrqnO5qC3CP+PilfLZjpCP6LxySy25/cR2hp5r6Z8PbchAvmbKoqQ3QOWj14
         Y2IumtFdbYlxhwdmxL1zwsdbsOz7RrFs3Y4GiADconT3Wz+PSWJPXkvcRv355nUo1QB+
         WFMQ==
In-Reply-To: <20201001151058.GB493631@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Yang Shi <yang.shi@linux.alibaba.com>, Greg Thelen <gthelen@google.com>, David Rientjes <rientjes@google.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, SeongJae Park <sjpark@amazon.com>, andrea.righi@canonical.com

Hi Johannes,

On Thu, Oct 1, 2020 at 8:12 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> Hello Shakeel,
>
> On Wed, Sep 30, 2020 at 08:26:26AM -0700, Shakeel Butt wrote:
> > On Mon, Sep 28, 2020 at 2:03 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > Workloads may not
> > > allocate anything for hours, and then suddenly allocate gigabytes
> > > within seconds. A sudden onset of streaming reads through the
> > > filesystem could destroy the workingset measurements, whereas a limit
> > > would catch it and do drop-behind (and thus workingset sampling) at
> > > the exact rate of allocations.
> > >
> > > Again I believe something that may be doable as a hyperscale operator,
> > > but likely too fragile to get wider applications beyond that.
> > >
> > > My take is that a proactive reclaim feature, whose goal is never to
> > > thrash or punish but to keep the LRUs warm and the workingset trimmed,
> > > would ideally have:
> > >
> > > - a pressure or size target specified by userspace but with
> > >   enforcement driven inside the kernel from the allocation path
> > >
> > > - the enforcement work NOT be done synchronously by the workload
> > >   (something I'd argue we want for *all* memory limits)
> > >
> > > - the enforcement work ACCOUNTED to the cgroup, though, since it's the
> > >   cgroup's memory allocations causing the work (again something I'd
> > >   argue we want in general)
> >
> > For this point I think we want more flexibility to control the
> > resources we want to dedicate for proactive reclaim. One particular
> > example from our production is the batch jobs with high memory
> > footprint. These jobs don't have enough CPU quota but we do want to
> > proactively reclaim from them. We would prefer to dedicate some amount
> > of CPU to proactively reclaim from them independent of their own CPU
> > quota.
>
> Would it not work to add headroom for this reclaim overhead to the CPU
> quota of the job?
>
> The reason I'm asking is because reclaim is only one side of the
> proactive reclaim medal. The other side is taking faults and having to
> do IO and/or decompression (zswap, compressed btrfs) on the workload
> side. And that part is unavoidably consuming CPU and IO quota of the
> workload. So I wonder how much this can generally be separated out.
>
> It's certainly something we've been thinking about as well. Currently,
> because we use memory.high, we have all the reclaim work being done by
> a privileged daemon outside the cgroup, and the workload pressure only
> stems from the refault side.
>
> But that means a workload is consuming privileged CPU cycles, and the
> amount varies depending on the memory access patterns - how many
> rotations the reclaim scanner is doing etc.
>
> So I do wonder whether this "cost of business" of running a workload
> with a certain memory footprint should be accounted to the workload
> itself. Because at the end of the day, the CPU you have available will
> dictate how much memory you need, and both of these axes affect how
> you can schedule this job in a shared compute pool. Do neighboring
> jobs on the same host leave you either the memory for your colder
> pages, or the CPU (and IO) to trim them off?
>
> For illustration, compare extreme examples of this.
>
>         A) A workload that has its executable/libraries and a fixed
>            set of hot heap pages. Proactive reclaim will be relatively
>            slow and cheap - a couple of deactivations/rotations.
>
>         B) A workload that does high-speed streaming IO and generates
>            a lot of drop-behind cache; or a workload that has a huge
>            virtual anon set with lots of allocations and MADV_FREEing
>            going on. Proactive reclaim will be fast and expensive.
>
> Even at the same memory target size, these two types of jobs have very
> different requirements toward the host environment they can run on.
>
> It seems to me that this is cost that should be captured in the job's
> overall resource footprint.

I understand your point but from the usability perspective, I am
finding it hard to deploy/use.

As you said, the proactive reclaim cost will be different for
different types of workload but I do not expect the job owners telling
me how much headroom their jobs need.

I would have to start with a fixed headroom for a job, have to monitor
the resource usage of the proactive reclaim for it and dynamically
adjust the headroom to not steal the CPU from the job (I am assuming
there is no isolation between job and proactive reclaim).

This seems very hard to use as compared to setting aside a fixed
amount of CPU for proactive reclaim system wide. Please correct me if
I am misunderstanding something.
