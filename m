From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: introduce per-memcg reclaim interface
Date: Mon, 21 Sep 2020 10:50:14 -0700
Message-ID: <CALvZod43VXKZ3StaGXK_EZG_fKcW3v3=cEYOWFwp4HNJpOOf8g@mail.gmail.com>
References: <20200909215752.1725525-1-shakeelb@google.com> <20200921163055.GQ12990@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fU34l7YxeD2C4TJGstKuQVh5OhgRVbQTmIsDH4TDtHA=;
        b=uawmf0NTdlD+Im+9mFd3lJDOqDo2Lsnv+KTjz98QMlHh4Ee2SL3Q4WOCovv/niPzcs
         IQvZtZsqpBQUtlDfI434b4iCVueJIG8k2HdnhSDdOzgriUDUB4SVTywrvcq+7aynv+G4
         9QCetox6w2Iny8/vuNondiSTlvkdSI+R3t4rh3P36hw6LyiB2jDb5YIF0PTishVgYV/9
         Kwuc5EX6vamTecE5s7JWTqU5JEJzWHi4ysKhDHOt8VHVJfESBMPkBJsuA8OQxo7P/98X
         DA0/OBG/CSSpaZEDOzbGRqCJIK9Iybw04BGzjfmgvpxLck7bWBDAhN9jySLBLBpI4CW5
         DxjA==
In-Reply-To: <20200921163055.GQ12990-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Sep 21, 2020 at 9:30 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Wed 09-09-20 14:57:52, Shakeel Butt wrote:
> > Introduce an memcg interface to trigger memory reclaim on a memory cgroup.
> >
> > Use cases:
> > ----------
> >
> > 1) Per-memcg uswapd:
> >
> > Usually applications consists of combination of latency sensitive and
> > latency tolerant tasks. For example, tasks serving user requests vs
> > tasks doing data backup for a database application. At the moment the
> > kernel does not differentiate between such tasks when the application
> > hits the memcg limits. So, potentially a latency sensitive user facing
> > task can get stuck in high reclaim and be throttled by the kernel.
> >
> > Similarly there are cases of single process applications having two set
> > of thread pools where threads from one pool have high scheduling
> > priority and low latency requirement. One concrete example from our
> > production is the VMM which have high priority low latency thread pool
> > for the VCPUs while separate thread pool for stats reporting, I/O
> > emulation, health checks and other managerial operations. The kernel
> > memory reclaim does not differentiate between VCPU thread or a
> > non-latency sensitive thread and a VCPU thread can get stuck in high
> > reclaim.
>
> As those are presumably in the same cgroup what does prevent them to get
> stuck behind shared resources with taken during the reclaim performed by
> somebody else? I mean, memory reclaim might drop memory used by the high
> priority task. Or they might simply stumble over same locks.
>

Yes there are a lot of challenges in providing isolation between
latency sensitive and latency tolerant jobs/threads. This proposal
aims to solve one specific challenge memcg limit reclaim.

> I am also more interested in actual numbers here. The high limit reclaim
> is normally swift and should be mostly unnoticeable. If the reclaim gets
> more expensive then it can get really noticeable for sure. But for the
> later the same can happen with the external pro-activee reclaimer as

I think you meant 'uswapd' here instead of pro-active reclaimer.

> well, right? So there is no real "guarantee". Do you have any numbers
> from your workloads where you can demonstrate that the external reclaim
> has saved you this amount of effective cpu time of the sensitive
> workload? (Essentially measure how much time it has to consume in the
> high limit reclaim)
>

What we actually use in our production is the 'proactive reclaim'
which I have explained in the original message but I will add a couple
more sentences below.

For the uswapd use-case, let me point to the previous discussions and
feature requests by others [1, 2]. One of the limiting factors of
these previous proposals was the lack of CPU accounting of the
background reclaimer which the current proposal solves by enabling the
user space solution.

[1] https://lwn.net/Articles/753162/
[2] http://lkml.kernel.org/r/20200219181219.54356-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org

Let me add one more point. Even if the high limit reclaim is swift, it
can still take 100s of usecs. Most of our jobs are anon-only and we
use zswap. Compressing a page can take a couple usec, so 100s of usecs
in limit reclaim is normal. For latency sensitive jobs, this amount of
hiccups do matters.

For the proactive reclaim, based on the refault medium, we define
tolerable refault rate of the applications. Then we proactively
reclaim memory from the applications and monitor the refault rates.
Based on the refault rates, the memory overcommit manager controls the
aggressiveness of the proactive reclaim.

This is exactly what we do in the production. Please let me know if
you want to know why we do proactive reclaim in the first place.

> To the feature itself, I am not yet convinced we want to have a feature
> like that. It surely sounds easy to use and attractive for a better user
> space control. It is also much well defined than drop_caches/force_empty
> because it is not all or nothing. But it also sounds like something too
> easy to use incorrectly (remember drop_caches). I am also a bit worried
> about corner cases wich would be easier to hit - e.g. fill up the swap
> limit and turn anonymous memory into unreclaimable and who knows what
> else.

The corner cases you are worried about are already possible with the
existing interfaces. We can already do all such things with
memory.high interface but with some limitations. This new interface
resolves that limitation as explained in the original email.

Please let me know if you have more questions.

thanks,
Shakeel
