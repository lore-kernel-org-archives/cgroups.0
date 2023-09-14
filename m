From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcg: optimize stats flushing for latency and accuracy
Date: Thu, 14 Sep 2023 10:56:52 -0700
Message-ID: <CAJD7tkbb5zxEPSW6vvijDpQKCZiDcUJqe8SPvLHfo0RX7iHXAw@mail.gmail.com>
References: <20230913073846.1528938-1-yosryahmed@google.com>
 <20230913073846.1528938-4-yosryahmed@google.com> <CALvZod6j5E2MXFz463LRcrP6XY8FedzLUKW88c=ZY39B6mYyMA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694714251; x=1695319051; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7VwkUDvl9cZBLnoPVjTuHGS1QPb1S9F5cL//3ghT7s0=;
        b=YlWf9sD7GK4cXkl+pkBTdxc9bxdcUbiqFiuxTAoqK5nGIWWh5Tu6glIfvHSNyIVugD
         W17YoFOy0fJsDwyd2mQA2343Rp3Ecjdy4fSP64NYey8tQe0aeia2U9PclC9gGCLNpGnp
         Fun3PCAD+MWLDGTBTrXQEHf44ku1/FaD9Evg290F0OOPoGUzcMj/W1B0wKs3badVXY/R
         n2I0mwhs/mmvKCOWdApbPL4nmCB2+o8gxjh7RZZ/cOS3Gczj8qnZZXmS0p3mK/9S6lw4
         W2JGa1KxPbuucey4JBvpDSpcRJgic4Ner0KV8VaWA04CSDpRFCd03t703eoPVo0e3q3i
         k39Q==
In-Reply-To: <CALvZod6j5E2MXFz463LRcrP6XY8FedzLUKW88c=ZY39B6mYyMA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Sep 14, 2023 at 10:36=E2=80=AFAM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>=
 wrote:
>
> On Wed, Sep 13, 2023 at 12:38=E2=80=AFAM Yosry Ahmed <yosryahmed@google.c=
om> wrote:
> >
> > Stats flushing for memcg currently follows the following rules:
> > - Always flush the entire memcg hierarchy (i.e. flush the root).
> > - Only one flusher is allowed at a time. If someone else tries to flush
> >   concurrently, they skip and return immediately.
> > - A periodic flusher flushes all the stats every 2 seconds.
> >
> > The reason this approach is followed is because all flushes are
> > serialized by a global rstat spinlock. On the memcg side, flushing is
> > invoked from userspace reads as well as in-kernel flushers (e.g.
> > reclaim, refault, etc). This approach aims to avoid serializing all
> > flushers on the global lock, which can cause a significant performance
> > hit under high concurrency.
> >
> > This approach has the following problems:
> > - Occasionally a userspace read of the stats of a non-root cgroup will
> >   be too expensive as it has to flush the entire hierarchy [1].
>
> This is a real world workload exhibiting the issue which is good.
>
> > - Sometimes the stats accuracy are compromised if there is an ongoing
> >   flush, and we skip and return before the subtree of interest is
> >   actually flushed. This is more visible when reading stats from
> >   userspace, but can also affect in-kernel flushers.
>
> Please provide similar data/justification for the above. In addition:
>
> 1. How much delayed/stale stats have you observed on real world workload?

I am not really sure. We don't have a wide deployment of kernels with
rstat yet. These are problems observed in testing and/or concerns
expressed by our userspace team.

I am trying to solve this now because any problems that result from
this staleness will be very hard to debug and link back to stale
stats.

>
> 2. What is acceptable staleness in the stats for your use-case?

Again, unfortunately I am not sure, but right now it can be O(seconds)
which is not acceptable as we have workloads querying the stats every
1s (and sometimes more frequently).

>
> 3. What is your use-case?

A few use cases we have that may be affected by this:
- System overhead: calculations using memory.usage and some stats from
memory.stat. If one of them is fresh and the other one isn't we have
an inconsistent view of the system.
- Userspace OOM killing: We use some stats in memory.stat to gauge the
amount of memory that will be freed by killing a task as sometimes
memory.usage includes shared resources that wouldn't be freed anyway.
- Proactive reclaim: we read memory.stat in a proactive reclaim
feedback loop, stale stats may cause us to mistakenly think reclaim is
ineffective and prematurely stop.

>
> 4. Does your use-case care about staleness of all the stats in
> memory.stat or some specific stats?

We have multiple use cases that can be affected by this, so I don't
think there are some specific stats. I am also not aware of all
possibly affected use cases.

>
> 5. If some specific stats in memory.stat, does it make sense to
> decouple them from rstat and just pay the price up front to maintain
> them accurately?
>
> Most importantly please please please be concise in your responses.

I try, sometimes I am not sure how much detail is needed. Sorry about that =
:)

>
> I know I am going back on some of the previous agreements but this
> whole locking back and forth has made in question the original
> motivation.

That's okay. Taking a step back, having flushing being indeterministic
in this way is a time bomb in my opinion. Note that this also affects
in-kernel flushers like reclaim or dirty isolation, which I suspect
will be more affected by staleness. No one complained yet AFAICT, but
I think it's a time bomb. The worst part is that if/when a problem
happens, we won't be able to easily tell what went wrong.
