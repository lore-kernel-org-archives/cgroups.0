From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Tue, 15 Aug 2023 19:19:20 -0700
Message-ID: <CAJD7tkYzr2cg-aQ899vfqB4jR7iP83t8f-Z4AH8d9iW-yw-nnQ@mail.gmail.com>
References: <CAJD7tkYZxjAHrodVDK=wmz-sULJrq2VhC_5ecRP7T-KiaOcTuw@mail.gmail.com>
 <CALvZod46Cz_=5UgiyAKM+VgKyk=KJCqDqXu91=9uHy7-2wk53g@mail.gmail.com>
 <CAJD7tkY-ezyYebvcs=8Z_zrw2UVW8jf2WvP1G8tu2rT=2sMnAA@mail.gmail.com>
 <CALvZod5fH9xu_+6x85K38f63GfKGWD1LqtD2R4d09xmDtLB7ew@mail.gmail.com>
 <ZNdEaw2nktq1NfmH@dhcp22.suse.cz> <CAJD7tkaFHgc3eN1K1wYsQFWMLu4+Frf9DJ-5HOja2nC20Es9Dw@mail.gmail.com>
 <ZNrDWqfjXtAYhnvT@slm.duckdns.org> <CAJD7tkYBFz-gZ2QsHxUMT=t0KNXs66S-zzMPebadHx9zaG0Q3w@mail.gmail.com>
 <ZNrITZVTf2EILRJq@slm.duckdns.org> <CAJD7tkaXwoF-faApweAmm7Db7jAuS3EO7hVvdyVtqW_rE+T9Vg@mail.gmail.com>
 <ZNrLO5PAEZw4yjI9@slm.duckdns.org> <CAJD7tkYgCySTX28zK9GZiWwsabR4nv7M2hQ57y12si-fqtv7zg@mail.gmail.com>
 <CALvZod6KRxiDzrppCgx+=SHg2+96nFE5crwXCKwe9PZbWM_6cQ@mail.gmail.com>
 <CAJD7tkaUzhvZPohpo1F8TUKRPuXH7bjDeg9VCzN2CbywQbRutQ@mail.gmail.com> <CALvZod6HUtYhDaXiwXSrcwfxLSrZ37sZhKY1Mg4kmpDFk13aYw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692152399; x=1692757199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V37BsPFrQfflT/FozBg7eajhwQW33aYWS46wbu2Ypkg=;
        b=0QZSUunPFCDBu7ePJO+ZUAJzTXgigsi5VNYuL05PmuqaCgP+zWcsDOoK4uBnj+Gg1B
         xiu4JLzGNSuShm+gtMpqjUgpqeK36gFrPFC8krbioG1dOUspb6EXb8NiXABp6ifpZvJL
         nBWvhdyDy9Cjrc6JGod54iQ1PqCr9i3QhL/7EAY9AgeqxMV1VMzo01SQtoKrD56q6GEc
         iljoQajqNzWVfbgnMusqhIDqOZrGH6GWVvoplEdL5ZrGaEs37M9t4k1R5zgdAMLawa1A
         7qFUznQjxAotmuX9LT0Xu8BuoXq3POeGNydhcfsOZ/7mojILhRLmA8/S2vhzLXnFN7qA
         p1xA==
In-Reply-To: <CALvZod6HUtYhDaXiwXSrcwfxLSrZ37sZhKY1Mg4kmpDFk13aYw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>

On Tue, Aug 15, 2023 at 6:14=E2=80=AFPM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
>
> On Tue, Aug 15, 2023 at 5:29=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKldhl2p70BpVqQ@public.gmane.org=
m> wrote:
> >
> [...]
> > >
> > > I thought we already reached the decision on how to proceed here. Let
> > > me summarize what I think we should do:
> > >
> > > 1. Completely remove the sync flush from stat files read from userspa=
ce.
> > > 2. Provide a separate way/interface to explicitly flush stats for
> > > users who want more accurate stats and can pay the cost. This is
> > > similar to the stat_refresh interface.
> > > 3. Keep the 2 sec periodic stats flusher.
> >
> > I think this solution is suboptimal to be honest, I think we can do bet=
ter.
> >
> > With recent improvements to spinlocks/mutexes, and flushers becoming
> > sleepable, I think a better solution would be to remove unified
> > flushing and let everyone only flush the subtree they care about. Sync
> > flushing becomes much better (unless you're flushing root ofc), and
> > concurrent flushing wouldn't cause too many problems (ideally no
> > thundering herd, and rstat lock can be dropped at cpu boundaries in
> > cgroup_rstat_flush_locked()).
> >
> > If we do this, stat reads can be much faster as Ivan demonstrated with
> > his patch that only flushes the cgroup being read, and we do not
> > sacrifice accuracy as we never skip flushing. We also do not need a
> > separate interface for explicit refresh.
> >
> > In all cases, we need to keep the 2 sec periodic flusher. What we need
> > to figure out if we remove unified flushing is:
> >
> > 1. Handling stats_flush_threshold.
> > 2. Handling flush_next_time.
> >
> > Both of these are global now, and will need to be adapted to
> > non-unified non-global flushing.
>
> The only thing we are disagreeing on is (1) the complete removal of
> sync flush and an explicit flush interface versus (2) keep doing the
> sync flush of the subtree.
>
> To me (1) seems more optimal particularly for the server use-case
> where a node controller reads stats of root and as well as cgroups of
> a couple of top levels (we actually do this internally). Doing flush
> once explicitly and then reading the stats for all such cgroups seems
> better to me.

The problem in (1) is that first of all it's a behavioral change, we
start having explicit staleness in the stats, and userspace needs to
adapt by explicitly requesting a flush. A node controller can be
enlightened to do so, but on a system with a lot of cgroups, if you
flush once explicitly and iterate through all cgroups, the flush will
be stale by the time you reach the last cgroup. Keep in mind there are
also users that read their own stats, figuring out which users need to
flush explicitly vs. read cached stats is a problem.

Taking a step back, the total work that needs to be done does not
change with (2). A node controller iterating cgroups and reading their
stats will do the same amount of flushing, it will just be distributed
across multiple read syscalls, so shorter intervals in kernel space.

There are also in-kernel flushers (e.g. reclaim and dirty throttling)
that will benefit from (2) by reading more accurate stats without
having to flush the entire tree. The behavior is currently
indeterministic, you may get fresh or stale stats, you may flush one
cgroup or 100 cgroups.

I think with (2) we make less compromises in terms of accuracy and
determinism, and it's a less disruptive change to userspace.
