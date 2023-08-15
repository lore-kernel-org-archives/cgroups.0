From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Mon, 14 Aug 2023 17:28:22 -0700
Message-ID: <CAJD7tkYBFz-gZ2QsHxUMT=t0KNXs66S-zzMPebadHx9zaG0Q3w@mail.gmail.com>
References: <CAJD7tkbJ1fnMDudtsS2xubKn0RTWz7t0Hem=PSRQQp3sGf-iOw@mail.gmail.com>
 <ZNaLGVUtPu7Ua/jL@dhcp22.suse.cz> <CAJD7tkbF1tNi8v0W4Mnqs0rzpRBshOFepxFTa1SiSvmBEBUEvw@mail.gmail.com>
 <CALvZod55S3XeK-MquTq0mDuipq8j0vFymQeX_XnPb_HuPK+oGQ@mail.gmail.com>
 <CAJD7tkYZxjAHrodVDK=wmz-sULJrq2VhC_5ecRP7T-KiaOcTuw@mail.gmail.com>
 <CALvZod46Cz_=5UgiyAKM+VgKyk=KJCqDqXu91=9uHy7-2wk53g@mail.gmail.com>
 <CAJD7tkY-ezyYebvcs=8Z_zrw2UVW8jf2WvP1G8tu2rT=2sMnAA@mail.gmail.com>
 <CALvZod5fH9xu_+6x85K38f63GfKGWD1LqtD2R4d09xmDtLB7ew@mail.gmail.com>
 <ZNdEaw2nktq1NfmH@dhcp22.suse.cz> <CAJD7tkaFHgc3eN1K1wYsQFWMLu4+Frf9DJ-5HOja2nC20Es9Dw@mail.gmail.com>
 <ZNrDWqfjXtAYhnvT@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692059339; x=1692664139;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s1lKc8UCS20HXuR6dZ0rRLPXdPOi2Gp9kpdm+wPioZA=;
        b=MMfQ/rxhV+SsA65fGuBjuQe0apk2cIeqwqBhMkO+8zOqb5kPwPqW9O3Zb/4RzJVlwf
         ic+ugnVvM/Jgs29lFDzYaYGp6IsQx7LrQTKlPaeaRDyNDCvCAzfanGOhQQfKSzQsBB13
         3e/YVG6A9CbUlf8V5a3jAlnuOFRYse+svOjPsaBEhK9RhWzg8ua9loRuGHQlTWaH44vg
         nbyNPZbFGZO/I30U8nrkBrs3llTa2l4HtNWN2KwrsUFPYx1ZXHw3i9W2bNveRZxUKzgs
         IG2O/dIiKNAgfU/voy1SjkaBYfrfyRM/nQzsiF2r7WR2+WhXcXfL8w3PjZ9uJUK9pwDq
         KBAw==
In-Reply-To: <ZNrDWqfjXtAYhnvT-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Aug 14, 2023 at 5:14=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Sat, Aug 12, 2023 at 04:04:32AM -0700, Yosry Ahmed wrote:
> > Taking a step back though, and considering there have been other
> > complaints about unified flushing causing expensive reads from
> > memory.stat [1], I am wondering if we should tackle the fundamental
> > problem.
> >
> > We have a single global rstat lock for flushing, which protects the
> > global per-cgroup counters as far as I understand. A single lock means
> > a lot of contention, which is why we implemented unified flushing on
> > the memcg side in the first place, where we only let one flusher
> > operate and everyone else skip, but that flusher needs to flush the
> > entire tree.
> >
> > This can be unnecessarily expensive (see [1]), and to avoid how
> > expensive it is we sacrifice accuracy (what this patch is about). I am
> > exploring breaking down that lock into per-cgroup locks, where a
> > flusher acquires locks in a top down fashion. This allows for some
> > concurrency in flushing, and makes unified flushing unnecessary. If we
> > retire unified flushing we fix both accuracy and expensive reads at
> > the same time, while not sacrificing performance for concurrent
> > in-kernel flushers.
> >
> > What do you think? I am prototyping something now and running some
> > tests, it seems promising and simple-ish (unless I am missing a big
> > correctness issue).
>
> So, the original design used mutex for synchronize flushing with the idea
> being that updates are high freq but reads are low freq and can be
> relatively slow. Using rstats for mm internal operations changed this
> assumption quite a bit and we ended up switching that mutex with a lock.

Naive question, do mutexes handle thundering herd problems better than
spinlocks? I would assume so but I am not sure.

>
> Here are some suggestions:
>
> * Update-side, per-cpu lock should be fine. I don't think splitting them
>   would buy us anything meaningful.

I agree, I was mainly concerned with the global flushing lock.

>
> * Flush-side, maybe we can break flushing into per-cpu or whatnot but
>   there's no avoiding the fact that flushing can take quite a while if th=
ere
>   are a lot to flush whether locks are split or not. I wonder whether it'=
d
>   be possible to go back to mutex for flushing and update the users to
>   either consume the cached values or operate in a sleepable context if
>   synchronous read is necessary, which is the right thing to do anyway gi=
ven
>   how long flushes can take.

Unfortunately it cannot be broken down into per-cpu as all flushers
update the same per-cgroup counters, so we need a bigger locking
scope. Switching to atomics really hurts performance. Breaking down
the lock to be per-cgroup is doable, but since we need to lock both
the parent and the cgroup, flushing top-level cgroups (which I assume
is most common) will lock the root anyway.

All flushers right now operate in sleepable context, so we can go
again to the mutex if you think this will make things better. The
slowness problem reported recently is in a sleepable context, it's
just too slow for userspace if I understand correctly.

+Ivan Babrou

What I am thinking about now is that since all flushers are sleepable,
perhaps the thundering herd problem would be less severe, since we may
release the lock (or mutex) at the cpu boundaries. I wonder if would
be better if we retire the unified flushing on the memcg side, so that
not all flushers need to flush the entire tree, and we allow
concurrent flushing.

This should address the slowness in reads (as proven by a patch by
Ivan [1]), and it should also address the inaccuracy addressed by this
thread, since no flushers will skip if someone else is flushing.

I am trying to test if there are any regressions by running some
synthetic stress testing (reclaim, refault, read stats, repeat), so
far I can't see any.

Two things that we will need to figure out if we retire unified flushing:
(a) We now have a global "stats_flush_threshold" variable to know when
to flush and when to skip. If flushing is not global, we need to make
this per-cgroup or retire it as well. If we make it per-cgroup it may
affect the update-side, and we will need to move it to the rstat code
I think.

(b) We now have a global "flush_next_time" to know whether the
ratelimited flusher should run or not. If we keep it, only the global
async flusher will kill it forward, sync flushers will not. Otherwise
we can also make it per-cgroup and update it during flushes.

[1]https://github.com/bobrik/linux/commit/50b627811d54
>
> Thanks.
>
> --
> tejun
