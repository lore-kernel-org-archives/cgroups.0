From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcg: optimize stats flushing for latency and accuracy
Date: Fri, 15 Sep 2023 01:01:38 +0000
Message-ID: <20230915010138.knjli6ovpozxbpss@google.com>
References: <20230913073846.1528938-1-yosryahmed@google.com>
 <20230913073846.1528938-4-yosryahmed@google.com> <CALvZod6j5E2MXFz463LRcrP6XY8FedzLUKW88c=ZY39B6mYyMA@mail.gmail.com>
 <CAJD7tkbb5zxEPSW6vvijDpQKCZiDcUJqe8SPvLHfo0RX7iHXAw@mail.gmail.com>
 <20230914225844.woz7mke6vnmwijh7@google.com> <CAJD7tkb_pDxqqhB25aZpbfur=YodBRb1nmdpNZt1DB_1ozDpPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694739700; x=1695344500; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sJTS4bFwxQYCp+W2QwuD6ymPLJmZK+oQFYtEHbQSJpI=;
        b=CQzisWFX8Q5XtrDFza1+V28zemiMBfXMSKzjy4iODIdwnQTPmhtQu4gUb6PNavwYPV
         JCJAvwD2Q/DOb2AqTUlGReIWajG4L/XC3sF+wRcA54s4/IKCfkXH+GSqdmtQ8krAOSnT
         7UWk8cBh7HrybfJi3w0z52fP07NduP28rzI8Lz9Q+jQhZ+S15F2z+VPNjsSNaUzDYz7b
         ThXogwlGaTXLncK39Fvoxe2wi5WmCDvUMt27Uyc9IqxMzu0/SnuHAizARCJ66a5pZ5s2
         8/ZoWofVKskT7Rq/ico6cjaXn2e1+o+C6C4/nEVVfOizbl9f/RiKIkKp3ConkNu2QmsG
         g9dw==
In-Reply-To: <CAJD7tkb_pDxqqhB25aZpbfur=YodBRb1nmdpNZt1DB_1ozDpPQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Sep 14, 2023 at 04:30:56PM -0700, Yosry Ahmed wrote:
[...]
> >
> > I think first you need to show if this (2 sec stale stats) is really a
> > problem.
> 
> That's the thing, my main concern is that if this causes a problem, we
> probably won't be able to tell it was because of stale stats. It's
> very hard to make that connection.
> 

Please articulate what the problem would look like which you did in the
use-cases description below, let's discuss there.

> Pre-rstat, reading stats would always yield fresh stats (as much as
> possible). Now the stats can be up to 2s stale, and we don't really
> know how this will affect our existing workloads.
> 

Pre-rstat the stat read would traverse the memcg tree. With rstat
the tradeoff was made between expensive read and staleness.
Yeah there
might still be memcg update tree traversal which I would like to remove
completely. However you are saying to 

[...]
> >
> > I don't see why userspace OOM killing and proactive reclaim need
> > subsecond accuracy. Please explain.
> 
> For proactive reclaim it is not about sub-second accuracy. It is about
> doing the reclaim then reading the stats immediately to see the
> effect. Naturally one would expect that a stat read after reclaim
> would show the system state after reclaim.
> 
> For userspace OOM killing I am not really sure. It depends on how
> dynamic the workload is. If a task recently had a spike in memory
> usage causing a threshold to be hit, userspace can kill a different
> task if the stats are stale.
> 

Please add above reasoning in your commit message (though I am not
convinced but let's leave it at that).

> I think the whole point is *not* about the amount of staleness. It is
> more about that you expect a stats read after an event to reflect the
> system state after the event.

The whole point is to understand the tradeoff between accuracy and cost
of accuracy. I don't think you want to pay the cost of strong
consistency/ordering between stats reading and an event. My worry is
that you are enforcing a tradeoff which *might* be just applicable to
your use-cases. Anyways this is not something that can not be changed
later.

> 
> > Same for system overhead but I can
> > see the complication of two different sources for stats. Can you provide
> > the formula of system overhead? I am wondering why do you need to read
> > stats from memory.stat files. Why not the memory.current of top level
> > cgroups and /proc/meminfo be enough. Something like:
> >
> > Overhead = MemTotal - MemFree - SumOfTopCgroups(memory.current)
> 
> We use the amount of compressed memory in zswap from memory.stat,
> which is not accounted as memory usage in cgroup v1.
> 

There are zswap stats in /proc/meminfo. Will those work for you?

[...]
> > Fix the in-kernel flushers separately.
> 
> The in-kernel flushers are basically facing the same problem. For
> instance, reclaim would expect a stats read after a reclaim iteration
> to reflect the system state after the reclaim iteration.
> 

I have not seen any complains on memory reclaim recently. Maybe
reclaim does not really need that such accuracy :P

> > Also the problem Cloudflare is facing does not need to be tied with this.
> 
> When we try to wait for flushing to complete we run into the same
> latency problem of the root flush.

Not sure what wait for flushing has to do with Cloudflare's report. They
are ok with no sync flushing at all stat read.
