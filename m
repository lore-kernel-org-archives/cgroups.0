From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Mon, 14 Aug 2023 17:39:15 -0700
Message-ID: <CAJD7tkaXwoF-faApweAmm7Db7jAuS3EO7hVvdyVtqW_rE+T9Vg@mail.gmail.com>
References: <CAJD7tkbF1tNi8v0W4Mnqs0rzpRBshOFepxFTa1SiSvmBEBUEvw@mail.gmail.com>
 <CALvZod55S3XeK-MquTq0mDuipq8j0vFymQeX_XnPb_HuPK+oGQ@mail.gmail.com>
 <CAJD7tkYZxjAHrodVDK=wmz-sULJrq2VhC_5ecRP7T-KiaOcTuw@mail.gmail.com>
 <CALvZod46Cz_=5UgiyAKM+VgKyk=KJCqDqXu91=9uHy7-2wk53g@mail.gmail.com>
 <CAJD7tkY-ezyYebvcs=8Z_zrw2UVW8jf2WvP1G8tu2rT=2sMnAA@mail.gmail.com>
 <CALvZod5fH9xu_+6x85K38f63GfKGWD1LqtD2R4d09xmDtLB7ew@mail.gmail.com>
 <ZNdEaw2nktq1NfmH@dhcp22.suse.cz> <CAJD7tkaFHgc3eN1K1wYsQFWMLu4+Frf9DJ-5HOja2nC20Es9Dw@mail.gmail.com>
 <ZNrDWqfjXtAYhnvT@slm.duckdns.org> <CAJD7tkYBFz-gZ2QsHxUMT=t0KNXs66S-zzMPebadHx9zaG0Q3w@mail.gmail.com>
 <ZNrITZVTf2EILRJq@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692059991; x=1692664791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pUQhhVLOh6qVlfYVa6vB28rLbeIPVQEya3teNIVSHU8=;
        b=jp2hKW8+cT+9BIqBvImxERQxPLIhNiBP/eE4OjQULk+2t9+AW9OG8RsWIa7O8bL5AA
         6SMdlFMG163klFvruDYh20QUH9xHwjHYDNRgpju60THKIMmW69yQIEbK2ZDkXEs61oC4
         rZ6BT5Wz/YbnmD8OUACA5AB3QECE263UTei1K/Xmg3uh3y3z2qec3y59u64Gs4VvNPlI
         27Tphcei621LPX0MpfJM+4Dqe59z1HzPM6M9O2JjTKpg+s3DbX8iJqWTcc4xeIywuhDE
         QmYojV7hVgDhTCJkdN88IlzUz2K1qwW+5wDAionPs0FCK+4dCQZ8Tgs0EOkLpxMiiuVn
         KeeA==
In-Reply-To: <ZNrITZVTf2EILRJq-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Aug 14, 2023 at 5:35=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Mon, Aug 14, 2023 at 05:28:22PM -0700, Yosry Ahmed wrote:
> > > So, the original design used mutex for synchronize flushing with the =
idea
> > > being that updates are high freq but reads are low freq and can be
> > > relatively slow. Using rstats for mm internal operations changed this
> > > assumption quite a bit and we ended up switching that mutex with a lo=
ck.
> >
> > Naive question, do mutexes handle thundering herd problems better than
> > spinlocks? I would assume so but I am not sure.
>
> I don't know. We can ask Waiman if that becomes a problem.
>
> > > * Flush-side, maybe we can break flushing into per-cpu or whatnot but
> > >   there's no avoiding the fact that flushing can take quite a while i=
f there
> > >   are a lot to flush whether locks are split or not. I wonder whether=
 it'd
> > >   be possible to go back to mutex for flushing and update the users t=
o
> > >   either consume the cached values or operate in a sleepable context =
if
> > >   synchronous read is necessary, which is the right thing to do anywa=
y given
> > >   how long flushes can take.
> >
> > Unfortunately it cannot be broken down into per-cpu as all flushers
> > update the same per-cgroup counters, so we need a bigger locking
> > scope. Switching to atomics really hurts performance. Breaking down
> > the lock to be per-cgroup is doable, but since we need to lock both
> > the parent and the cgroup, flushing top-level cgroups (which I assume
> > is most common) will lock the root anyway.
>
> Plus, there's not much point in flushing in parallel, so I don't feel too
> enthusiastic about splitting flush locking.
>
> > All flushers right now operate in sleepable context, so we can go
> > again to the mutex if you think this will make things better. The
>
> Yes, I think that'd be more sane.
>
> > slowness problem reported recently is in a sleepable context, it's
> > just too slow for userspace if I understand correctly.
>
> I mean, there's a certain amount of work to do. There's no way around it =
if
> you wanna read the counters synchronously. The only solution there would =
be
> using a cached value or having some sort of auto-flushing mechanism so th=
at
> the amount to flush don't build up too much - e.g. keep a count of the
> number of entries to flush and trigger flush if it goes over some thresho=
ld.

I really hoped you'd continue reading past this point :)

My proposed solution was to only flush the needed subtree rather than
flushing the entire tree all the time, which is what we do now on the
memcg side. We already have an asynchronous flusher on the memcg side
that runs every 2s to try to keep the tree size bounded, and we
already keep track of the magnitude of updates and only flush if it's
significant.

The problems in this thread and the other one are:
(a) Sometimes reading from userspace is slow because we needlessly
flush the entire tree.
(b) Sometimes reading from userspace is inaccurate because we skip
flushing if someone else is flushing, even though we don't know if
they flushed the subtree we care about yet or not.

I believe dropping unified flushing, if possible of course, may fix
both problems.

>
> Thanks.
>
> --
> tejun
