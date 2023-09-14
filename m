From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcg: optimize stats flushing for latency and accuracy
Date: Thu, 14 Sep 2023 22:58:44 +0000
Message-ID: <20230914225844.woz7mke6vnmwijh7@google.com>
References: <20230913073846.1528938-1-yosryahmed@google.com>
 <20230913073846.1528938-4-yosryahmed@google.com> <CALvZod6j5E2MXFz463LRcrP6XY8FedzLUKW88c=ZY39B6mYyMA@mail.gmail.com>
 <CAJD7tkbb5zxEPSW6vvijDpQKCZiDcUJqe8SPvLHfo0RX7iHXAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694732326; x=1695337126; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OBvN087+LWsLjnRA9Q/StMUiztB5piJc+GOWYwv7hrg=;
        b=p3JssecyoEX9wuIVN0J7z8qmLVKXKzxNoq3mjO4yI95IflwOVTbu9mFZQjU0enJb/6
         sbOSw3kaCV3XPKw8/AbII/ly2LbVcY+50VKFZACDajJlsvLWnMto0bk3BxRJ/rdWdqHy
         iQ1W76kU69HA6FJ5IVeMNTFO0vsl22k5zRCy6K7mw4HLeJpMc9UuDCvZun/wsAkVD+s9
         ZkrrwT+BTSpcq9x7qn7ZSwbnxe0PIeHP281nueNpSMKRyzpkAsz7198rnLhoixgJxcDu
         nNSPPgNeC4jgHQ4MabFMPln+95ePlenHHRYtcmQsuajUyIrXmcQV+rFg82bgLZwko9xO
         it2A==
In-Reply-To: <CAJD7tkbb5zxEPSW6vvijDpQKCZiDcUJqe8SPvLHfo0RX7iHXAw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Sep 14, 2023 at 10:56:52AM -0700, Yosry Ahmed wrote:
[...]
> >
> > 1. How much delayed/stale stats have you observed on real world workload?
> 
> I am not really sure. We don't have a wide deployment of kernels with
> rstat yet. These are problems observed in testing and/or concerns
> expressed by our userspace team.
> 

Why sleep(2) not good enough for the tests?

> I am trying to solve this now because any problems that result from
> this staleness will be very hard to debug and link back to stale
> stats.
> 

I think first you need to show if this (2 sec stale stats) is really a
problem.

> >
> > 2. What is acceptable staleness in the stats for your use-case?
> 
> Again, unfortunately I am not sure, but right now it can be O(seconds)
> which is not acceptable as we have workloads querying the stats every
> 1s (and sometimes more frequently).
> 

It is 2 seconds in most cases and if it is higher, the system is already
in bad shape. O(seconds) seems more dramatic. So, why 2 seconds
staleness is not acceptable? Is 1 second acceptable? or 500 msec? Let's
look at the use-cases below.

> >
> > 3. What is your use-case?
> 
> A few use cases we have that may be affected by this:
> - System overhead: calculations using memory.usage and some stats from
> memory.stat. If one of them is fresh and the other one isn't we have
> an inconsistent view of the system.
> - Userspace OOM killing: We use some stats in memory.stat to gauge the
> amount of memory that will be freed by killing a task as sometimes
> memory.usage includes shared resources that wouldn't be freed anyway.
> - Proactive reclaim: we read memory.stat in a proactive reclaim
> feedback loop, stale stats may cause us to mistakenly think reclaim is
> ineffective and prematurely stop.
> 

I don't see why userspace OOM killing and proactive reclaim need
subsecond accuracy. Please explain. Same for system overhead but I can
see the complication of two different sources for stats. Can you provide
the formula of system overhead? I am wondering why do you need to read
stats from memory.stat files. Why not the memory.current of top level
cgroups and /proc/meminfo be enough. Something like:

Overhead = MemTotal - MemFree - SumOfTopCgroups(memory.current)

> >
> > I know I am going back on some of the previous agreements but this
> > whole locking back and forth has made in question the original
> > motivation.
> 
> That's okay. Taking a step back, having flushing being indeterministic

I would say atmost 2 second stale instead of indeterministic.

> in this way is a time bomb in my opinion. Note that this also affects
> in-kernel flushers like reclaim or dirty isolation

Fix the in-kernel flushers separately. Also the problem Cloudflare is
facing does not need to be tied with this.
