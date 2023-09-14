From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcg: optimize stats flushing for latency and accuracy
Date: Thu, 14 Sep 2023 16:30:56 -0700
Message-ID: <CAJD7tkb_pDxqqhB25aZpbfur=YodBRb1nmdpNZt1DB_1ozDpPQ@mail.gmail.com>
References: <20230913073846.1528938-1-yosryahmed@google.com>
 <20230913073846.1528938-4-yosryahmed@google.com> <CALvZod6j5E2MXFz463LRcrP6XY8FedzLUKW88c=ZY39B6mYyMA@mail.gmail.com>
 <CAJD7tkbb5zxEPSW6vvijDpQKCZiDcUJqe8SPvLHfo0RX7iHXAw@mail.gmail.com> <20230914225844.woz7mke6vnmwijh7@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694734295; x=1695339095; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r7Rb24jsu1Obt5C61wSLsWivJKBy0po7p8YAHy1mWV0=;
        b=ec94cJ09zKdzjHAXxU1iRkThGliciKFPhphW1t4eNFS4oSPl3XsbT+Vug8CSQ8qmjs
         0W2BS5XmVYmJobS3Mer6nPsVBXBxNIg+AQtfL2xgcSHJOw0dDMSdJuBQcl3DrcLDL1n3
         VNkQOnjMJaf8laRkx+kHoJ3babjO5UqhUKysdabSfYo++J0b/1QWcA9tMlrwcYR+3w2U
         48f+fQxE5HQCRtHS95YEc30BodxZevyHNYFWSZgw0jqBHjtGa7yoZnPEF9qAYyDF7xuc
         mPgpSbKxKfIOzf7cSDCyEtPTVviPa/u1FhFGZtI8nSLQErVztPSpn+7HlJEpdA6Zf6Ih
         2GLQ==
In-Reply-To: <20230914225844.woz7mke6vnmwijh7-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Sep 14, 2023 at 3:58=E2=80=AFPM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
>
> On Thu, Sep 14, 2023 at 10:56:52AM -0700, Yosry Ahmed wrote:
> [...]
> > >
> > > 1. How much delayed/stale stats have you observed on real world workl=
oad?
> >
> > I am not really sure. We don't have a wide deployment of kernels with
> > rstat yet. These are problems observed in testing and/or concerns
> > expressed by our userspace team.
> >
>
> Why sleep(2) not good enough for the tests?

The problem is not making the tests pass. The tests are just a signal.

>
> > I am trying to solve this now because any problems that result from
> > this staleness will be very hard to debug and link back to stale
> > stats.
> >
>
> I think first you need to show if this (2 sec stale stats) is really a
> problem.

That's the thing, my main concern is that if this causes a problem, we
probably won't be able to tell it was because of stale stats. It's
very hard to make that connection.

Pre-rstat, reading stats would always yield fresh stats (as much as
possible). Now the stats can be up to 2s stale, and we don't really
know how this will affect our existing workloads.

>
> > >
> > > 2. What is acceptable staleness in the stats for your use-case?
> >
> > Again, unfortunately I am not sure, but right now it can be O(seconds)
> > which is not acceptable as we have workloads querying the stats every
> > 1s (and sometimes more frequently).
> >
>
> It is 2 seconds in most cases and if it is higher, the system is already
> in bad shape. O(seconds) seems more dramatic. So, why 2 seconds
> staleness is not acceptable? Is 1 second acceptable? or 500 msec? Let's
> look at the use-cases below.
>
> > >
> > > 3. What is your use-case?
> >
> > A few use cases we have that may be affected by this:
> > - System overhead: calculations using memory.usage and some stats from
> > memory.stat. If one of them is fresh and the other one isn't we have
> > an inconsistent view of the system.
> > - Userspace OOM killing: We use some stats in memory.stat to gauge the
> > amount of memory that will be freed by killing a task as sometimes
> > memory.usage includes shared resources that wouldn't be freed anyway.
> > - Proactive reclaim: we read memory.stat in a proactive reclaim
> > feedback loop, stale stats may cause us to mistakenly think reclaim is
> > ineffective and prematurely stop.
> >
>
> I don't see why userspace OOM killing and proactive reclaim need
> subsecond accuracy. Please explain.

For proactive reclaim it is not about sub-second accuracy. It is about
doing the reclaim then reading the stats immediately to see the
effect. Naturally one would expect that a stat read after reclaim
would show the system state after reclaim.

For userspace OOM killing I am not really sure. It depends on how
dynamic the workload is. If a task recently had a spike in memory
usage causing a threshold to be hit, userspace can kill a different
task if the stats are stale.

I think the whole point is *not* about the amount of staleness. It is
more about that you expect a stats read after an event to reflect the
system state after the event. Whether this event is proactive reclaim
or a spike in memory usage or something else.

As Tejun mentioned previously [1]: "The only guarantee you need is
that there has been at least one flush since
the read attempt started".

[1]https://lore.kernel.org/lkml/ZP92xP5rdKdeps7Z-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org/

> Same for system overhead but I can
> see the complication of two different sources for stats. Can you provide
> the formula of system overhead? I am wondering why do you need to read
> stats from memory.stat files. Why not the memory.current of top level
> cgroups and /proc/meminfo be enough. Something like:
>
> Overhead =3D MemTotal - MemFree - SumOfTopCgroups(memory.current)

We use the amount of compressed memory in zswap from memory.stat,
which is not accounted as memory usage in cgroup v1.

>
> > >
> > > I know I am going back on some of the previous agreements but this
> > > whole locking back and forth has made in question the original
> > > motivation.
> >
> > That's okay. Taking a step back, having flushing being indeterministic
>
> I would say atmost 2 second stale instead of indeterministic.

Ack.

>
> > in this way is a time bomb in my opinion. Note that this also affects
> > in-kernel flushers like reclaim or dirty isolation
>
> Fix the in-kernel flushers separately.

The in-kernel flushers are basically facing the same problem. For
instance, reclaim would expect a stats read after a reclaim iteration
to reflect the system state after the reclaim iteration.

> Also the problem Cloudflare is facing does not need to be tied with this.

When we try to wait for flushing to complete we run into the same
latency problem of the root flush.
