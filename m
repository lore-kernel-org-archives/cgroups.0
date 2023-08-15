From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Mon, 14 Aug 2023 14:35:25 -1000
Message-ID: <ZNrITZVTf2EILRJq@slm.duckdns.org>
References: <CAJD7tkbF1tNi8v0W4Mnqs0rzpRBshOFepxFTa1SiSvmBEBUEvw@mail.gmail.com>
 <CALvZod55S3XeK-MquTq0mDuipq8j0vFymQeX_XnPb_HuPK+oGQ@mail.gmail.com>
 <CAJD7tkYZxjAHrodVDK=wmz-sULJrq2VhC_5ecRP7T-KiaOcTuw@mail.gmail.com>
 <CALvZod46Cz_=5UgiyAKM+VgKyk=KJCqDqXu91=9uHy7-2wk53g@mail.gmail.com>
 <CAJD7tkY-ezyYebvcs=8Z_zrw2UVW8jf2WvP1G8tu2rT=2sMnAA@mail.gmail.com>
 <CALvZod5fH9xu_+6x85K38f63GfKGWD1LqtD2R4d09xmDtLB7ew@mail.gmail.com>
 <ZNdEaw2nktq1NfmH@dhcp22.suse.cz>
 <CAJD7tkaFHgc3eN1K1wYsQFWMLu4+Frf9DJ-5HOja2nC20Es9Dw@mail.gmail.com>
 <ZNrDWqfjXtAYhnvT@slm.duckdns.org>
 <CAJD7tkYBFz-gZ2QsHxUMT=t0KNXs66S-zzMPebadHx9zaG0Q3w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692059727; x=1692664527;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bfAmkgzB7vT7tpPqvlusS7lhE5MuyQY4MvJWqWEdMxw=;
        b=Q3FsTHwS9lFILlCZTL+VSW2aBgIikI37LyzDBlO0rg0yAWWl8WiLTTad1Bw93yvH2Z
         6+H2tD04Xx312hOQjfVs27DFdL6BpDfUgH3bGOLnXfU6snGVTi+SuseJ4OifnvpGkxDr
         7JxqVmNrBAZB0ief7FxYgn9iQKvIGAqQQi5CNmTYRSrxjBEfskBkDsspIzSrAK/aJg7x
         f2nsQFkayTk8wUfT/jQZzyxeA+3lz1jN9M8+8YF+8FCQmW5s/n9Zuni13dkFGyJoQPYv
         QmmmIL1K28eb5SymTU5DSEDwbxqSnpm9lF4RfGQ00GO5KnsBKtt5CZPR0kq/u1Kq9JmR
         OySw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJD7tkYBFz-gZ2QsHxUMT=t0KNXs66S-zzMPebadHx9zaG0Q3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Aug 14, 2023 at 05:28:22PM -0700, Yosry Ahmed wrote:
> > So, the original design used mutex for synchronize flushing with the idea
> > being that updates are high freq but reads are low freq and can be
> > relatively slow. Using rstats for mm internal operations changed this
> > assumption quite a bit and we ended up switching that mutex with a lock.
> 
> Naive question, do mutexes handle thundering herd problems better than
> spinlocks? I would assume so but I am not sure.

I don't know. We can ask Waiman if that becomes a problem.

> > * Flush-side, maybe we can break flushing into per-cpu or whatnot but
> >   there's no avoiding the fact that flushing can take quite a while if there
> >   are a lot to flush whether locks are split or not. I wonder whether it'd
> >   be possible to go back to mutex for flushing and update the users to
> >   either consume the cached values or operate in a sleepable context if
> >   synchronous read is necessary, which is the right thing to do anyway given
> >   how long flushes can take.
> 
> Unfortunately it cannot be broken down into per-cpu as all flushers
> update the same per-cgroup counters, so we need a bigger locking
> scope. Switching to atomics really hurts performance. Breaking down
> the lock to be per-cgroup is doable, but since we need to lock both
> the parent and the cgroup, flushing top-level cgroups (which I assume
> is most common) will lock the root anyway.

Plus, there's not much point in flushing in parallel, so I don't feel too
enthusiastic about splitting flush locking.

> All flushers right now operate in sleepable context, so we can go
> again to the mutex if you think this will make things better. The

Yes, I think that'd be more sane.

> slowness problem reported recently is in a sleepable context, it's
> just too slow for userspace if I understand correctly.

I mean, there's a certain amount of work to do. There's no way around it if
you wanna read the counters synchronously. The only solution there would be
using a cached value or having some sort of auto-flushing mechanism so that
the amount to flush don't build up too much - e.g. keep a count of the
number of entries to flush and trigger flush if it goes over some threshold.

Thanks.

-- 
tejun
