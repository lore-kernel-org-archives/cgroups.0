From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Wed, 9 Aug 2023 05:31:04 -0700
Message-ID: <CAJD7tkYhxbd2e+4HMZVKUfD4cx6oDauna3vLmttNPLCmFNtpgA@mail.gmail.com>
References: <20230809045810.1659356-1-yosryahmed@google.com> <ZNNTgZVPZipTL/UM@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691584300; x=1692189100;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ovz1LQ6CtkIwOn2X9qPamiwiMkn0NFocCNlrpAkV6FE=;
        b=z87ipBGX3qL/8LN9fCqtHDrLvXwt7S+tuWniA0tiSN+CNh6VbxxtBmQyhlh+HSLCWN
         MokZhrhhkDyQWUhh9ddK3revJvWDVvj2sxHC4KXjeDpHTshiyAuc70hwHoBgd0D3IuBu
         5k9b808R7uSlBLTvoexBmRyAkLz6yt2iieSuBEiwwYnarzGFdq2UbjWDrhJYDGYDKrzU
         Ngn0OvDY/ASZZNoBb+Po1N546t3BYGJ/Kndgkbj6cNDyIWWYTuWeiikDfIujTd9k81IP
         ioqXYMTlg8TrKl0DP1iGK/J5PrbeS+eADjISSm/JLbcsqPhfWZABOt3x9Ej67B+2ocPB
         8qXw==
In-Reply-To: <ZNNTgZVPZipTL/UM-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Aug 9, 2023 at 1:51=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote=
:
>
> On Wed 09-08-23 04:58:10, Yosry Ahmed wrote:
> > Over time, the memcg code added multiple optimizations to the stats
> > flushing path that introduce a tradeoff between accuracy and
> > performance. In some contexts (e.g. dirty throttling, refaults, etc), a
> > full rstat flush of the stats in the tree can be too expensive. Such
> > optimizations include [1]:
> > (a) Introducing a periodic background flusher to keep the size of the
> > update tree from growing unbounded.
> > (b) Allowing only one thread to flush at a time, and other concurrent
> > flushers just skip the flush. This avoids a thundering herd problem
> > when multiple reclaim/refault threads attempt to flush the stats at
> > once.
> > (c) Only executing a flush if the magnitude of the stats updates exceed=
s
> > a certain threshold.
> >
> > These optimizations were necessary to make flushing feasible in
> > performance-critical paths, and they come at the cost of some accuracy
> > that we choose to live without. On the other hand, for flushes invoked
> > when userspace is reading the stats, the tradeoff is less appealing
> > This code path is not performance-critical, and the inaccuracies can
> > affect userspace behavior. For example, skipping flushing when there is
> > another ongoing flush is essentially a coin flip. We don't know if the
> > ongoing flush is done with the subtree of interest or not.
>
> I am not convinced by this much TBH. What kind of precision do you
> really need and how much off is what we provide?
>
> More expensive read of stats from userspace is quite easy to notice
> and usually reported as a regression. So you should have a convincing
> argument that an extra time spent is really worth it. AFAIK there are
> many monitoring (top like) tools which simply read those files regularly
> just to show numbers and they certainly do not need a high level of
> precision.

We used to spend this time before commit fd25a9e0e23b ("memcg: unify
memcg stat flushing") which generalized the "skip if ongoing flush"
for all stat flushing. As far I know, the problem was contention on
the flushing lock which also affected critical paths like refault.

The problem is that the current behavior is indeterministic, if cpu A
tries to flush stats and cpu B is already doing that, cpu A will just
skip. At that point, the cgroup(s) that cpu A cares about may have
been fully flushed, partially flushed (in terms of cpus), or not
flushed at all. We have no idea. We just know that someone else is
flushing something. IOW, in some cases the flush request will be
completely ignored and userspace will read stale stats (up to 2s + the
periodic flusher runtime).

Some workloads need to read up-to-date stats as feedback to actions
(e.g. after proactive reclaim, or for userspace OOM killing purposes),
and reading such stale stats causes regressions or misbehavior by
userspace.

>
> [...]
> > @@ -639,17 +639,24 @@ static inline void memcg_rstat_updated(struct mem=
_cgroup *memcg, int val)
> >       }
> >  }
> >
> > -static void do_flush_stats(void)
> > +static void do_flush_stats(bool full)
> >  {
> > +     if (!atomic_read(&stats_flush_ongoing) &&
> > +         !atomic_xchg(&stats_flush_ongoing, 1))
> > +             goto flush;
> > +
> >       /*
> > -      * We always flush the entire tree, so concurrent flushers can ju=
st
> > -      * skip. This avoids a thundering herd problem on the rstat globa=
l lock
> > -      * from memcg flushers (e.g. reclaim, refault, etc).
> > +      * We always flush the entire tree, so concurrent flushers can ch=
oose to
> > +      * skip if accuracy is not critical. Otherwise, wait for the ongo=
ing
> > +      * flush to complete. This avoids a thundering herd problem on th=
e rstat
> > +      * global lock from memcg flushers (e.g. reclaim, refault, etc).
> >        */
> > -     if (atomic_read(&stats_flush_ongoing) ||
> > -         atomic_xchg(&stats_flush_ongoing, 1))
> > -             return;
> > -
> > +     while (full && atomic_read(&stats_flush_ongoing) =3D=3D 1) {
> > +             if (!cond_resched())
> > +                     cpu_relax();
>
> You are reinveting a mutex with spinning waiter. Why don't you simply
> make stats_flush_ongoing a real mutex and make use try_lock for !full
> flush and normal lock otherwise?

So that was actually a spinlock at one point, when we used to skip if
try_lock failed. We opted for an atomic because the lock was only used
in a try_lock fashion. The problem here is that the atomic is used to
ensure that only one thread actually attempts to flush at a time (and
others skip/wait), to avoid a thundering herd problem on
cgroup_rstat_lock.

Here, what I am trying to do is essentially equivalent to "wait until
the lock is available but don't grab it". If we make
stats_flush_ongoing a mutex, I am afraid the thundering herd problem
will be reintroduced for stats_flush_ongoing this time.

I am not sure if there's a cleaner way of doing this, but I am
certainly open for suggestions. I also don't like how the spinning
loop looks as of now.
