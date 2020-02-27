From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: memcontrol: asynchronous reclaim for memory.high
Date: Wed, 26 Feb 2020 18:36:34 -0800
Message-ID: <CALvZod7kFNV7_+3pWiG7=bo0nFai8Qi+Hr5Cqa94nwUCPpWgJg@mail.gmail.com>
References: <20200219181219.54356-1-hannes@cmpxchg.org> <CALvZod7fya+o8mO+qo=FXjk3WgNje=2P=sxM5StgdBoGNeXRMg@mail.gmail.com>
 <1bfd6ea4-f012-5778-64c6-36731e69b5ba@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FgDRP53fhRc849hJWqV/+PwhPD91i+668jgIHMCfsLU=;
        b=NxVZZMPHkldyISQkt/j9q46fqdC/fTHYg2D8rxmu3JQ5FQTpEWAnsrfAW1INOGxpeL
         7h/DwX4EseSXzq8DPxsx7tT89LiU3NA/LHAN4Sx7xeCJY7jLlWu2wlI7PxFLojwfUju3
         XCXCv0GNC9Xz5gwwW7M6ZQvAHCRuijZey00McNQxQ9NVe7aC2WLqdpYWQ76fRU+M2TSD
         fCSLoyGAnvdSsxpdtTUIC1FBt0jEnZJWNiN/eJ1V1HI2R4d3LlFZziKBBFNxThGx34jE
         FKNM7vbPt25+yqO0LpSs/FWkruIUFSvFAow7Xv2uEwRevRGyVVEdbZ3TS4R6adpOe9Q4
         7e2Q==
In-Reply-To: <1bfd6ea4-f012-5778-64c6-36731e69b5ba@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Wed, Feb 26, 2020 at 3:59 PM Yang Shi <yang.shi@linux.alibaba.com> wrote:
>
>
>
> On 2/26/20 12:25 PM, Shakeel Butt wrote:
> > On Wed, Feb 19, 2020 at 10:12 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >> We have received regression reports from users whose workloads moved
> >> into containers and subsequently encountered new latencies. For some
> >> users these were a nuisance, but for some it meant missing their SLA
> >> response times. We tracked those delays down to cgroup limits, which
> >> inject direct reclaim stalls into the workload where previously all
> >> reclaim was handled my kswapd.
> >>
> >> This patch adds asynchronous reclaim to the memory.high cgroup limit
> >> while keeping direct reclaim as a fallback. In our testing, this
> >> eliminated all direct reclaim from the affected workload.
> >>
> >> memory.high has a grace buffer of about 4% between when it becomes
> >> exceeded and when allocating threads get throttled. We can use the
> >> same buffer for the async reclaimer to operate in. If the worker
> >> cannot keep up and the grace buffer is exceeded, allocating threads
> >> will fall back to direct reclaim before getting throttled.
> >>
> >> For irq-context, there's already async memory.high enforcement. Re-use
> >> that work item for all allocating contexts, but switch it to the
> >> unbound workqueue so reclaim work doesn't compete with the workload.
> >> The work item is per cgroup, which means the workqueue infrastructure
> >> will create at maximum one worker thread per reclaiming cgroup.
> >>
> >> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> >> ---
> >>   mm/memcontrol.c | 60 +++++++++++++++++++++++++++++++++++++------------
> >>   mm/vmscan.c     | 10 +++++++--
> > This reminds me of the per-memcg kswapd proposal from LSFMM 2018
> > (https://lwn.net/Articles/753162/).
>
> Thanks for bringing this up.
>
> >
> > If I understand this correctly, the use-case is that the job instead
> > of direct reclaiming (potentially in latency sensitive tasks), prefers
> > a background non-latency sensitive task to do the reclaim. I am
> > wondering if we can use the memory.high notification along with a new
> > memcg interface (like memory.try_to_free_pages) to implement a user
> > space background reclaimer. That would resolve the cpu accounting
> > concerns as the user space background reclaimer can share the cpu cost
> > with the task.
>
> Actually I'm interested how you implement userspace reclaimer. Via a new
> syscall or a variant of existing syscall?
>

We have a per-memcg interface memory.try_to_free_pages on which user
space can echo two numbers i.e. number of bytes to reclaim and a byte
representing flags (I/O allowed or just reclaim zombies e.t.c).
However nowadays we are just using it for zombie cleanup.

Shakeel
