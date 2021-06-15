From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] memcg: periodically flush the memcg stats
Date: Tue, 15 Jun 2021 14:52:37 -0700
Message-ID: <CALvZod6Hpema0uMcnMGPS+_2iZuxc8JqkjHRVBeEGp-vdcpPYA@mail.gmail.com>
References: <20210615174435.4174364-1-shakeelb@google.com> <20210615174435.4174364-2-shakeelb@google.com>
 <YMj/s26uF+cQOB2D@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0XQnzVjTuP7aBILPyoyVQYQXqE/KQql4/BGG/kkVsjE=;
        b=gGfsNADVzHheLJtshFSvaD/DGD7MMjGpXn9cuW+cqCUX2Xd2zmn5p3v+yDXFjhYjtK
         PDLnOr1KKcT1OLCV6DmMntBGhrfUy0fxFML9PTdLQwix8Sd1hhPKRkJq6T0G7E4Ih+NA
         bygB5L8TqSiTWvrpf2PeCWl4nP29lwEvs0p8hAUMjE225soFkN2+WNABhSNuB+euV8Q/
         HSj4o5EqiwXTsqhpK8SRG3q2fz0JovM5ppq9RUlGel+tygTg+OEql0sia8kFjIp7n0lC
         rSEFJnNMUDNnbVoVZyuQrRWa9O1SgCOtrk9ljun/mmLILGGgE16kacXSjSAUEPM4K2jZ
         iBoQ==
In-Reply-To: <YMj/s26uF+cQOB2D-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jun 15, 2021 at 12:29 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> Hey Shakeel,
>
> On Tue, Jun 15, 2021 at 10:44:35AM -0700, Shakeel Butt wrote:
> > At the moment memcg stats are read in four contexts:
> >
> > 1. memcg stat user interfaces
> > 2. dirty throttling
> > 3. page fault
> > 4. memory reclaim
> >
> > Currently the kernel flushes the stats for first two cases. Flushing the
> > stats for remaining two casese may have performance impact. Always
> > flushing the memcg stats on the page fault code path may negatively
> > impacts the performance of the applications. In addition flushing in the
> > memory reclaim code path, though treated as slowpath, can become the
> > source of contention for the global lock taken for stat flushing because
> > when system or memcg is under memory pressure, many tasks may enter the
> > reclaim path.
> >
> > Instead of synchronously flushing the stats, this patch adds support of
> > asynchronous periodic flushing of the memcg stats. For now the flushing
> > period is hardcoded to 2*HZ but that can be changed later through maybe
> > sysctl if need arise.
>
> I'm concerned that quite a lot can happen in terms of reclaim and page
> faults in 2 seconds. It's conceivable that the error of a fixed 2s
> flush can actually exceed the error of a fixed percpu batch size.
>

Yes, that is possible.

> The way the global vmstat implementation manages error is doing both:
> ratelimiting and timelimiting. It uses percpu batching to limit the
> error when it gets busy, and periodic flushing to limit the length of
> time consumers of those stats could be stuck trying to reach a state
> that the batching would otherwise prevent from being reflected.
>
> Maybe we can use a combination of ratelimiting and timelimiting too?
>
> We shouldn't flush on every fault, but what about a percpu ratelimit
> that would at least bound the error to NR_CPU instead of nr_cgroups?
>

Couple questions here:

First, to convert the error bound to NR_CPU from nr_cgroups, I think
we have to move from (delta > threshold) comparison to
(num_update_events > threshold). Previously an increment event
followed by decrement would keep the delta to 0 (or same) but after
this change num_update_events would be 2. Is that ok?

Second, do we want to synchronously flush the stats when we cross the
threshold on update or asynchronously by queuing the flush with zero
delay?

> For thundering herds during reclaim: as long as they all tried to
> flush from the root, only one of them would actually need to do the
> work, and we could use trylock. If the lock is already taken, you can
> move on knowing that somebody is already doing the shared flush work.

Yes, this makes sense.
