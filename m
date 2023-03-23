From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 4/7] memcg: sleep during flushing stats in safe contexts
Date: Thu, 23 Mar 2023 11:07:47 -0700
Message-ID: <CAJD7tkbtHhzOytu3hfN8tjdAyNq0BZXYN8TEipS4NTApUzkL7w@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-5-yosryahmed@google.com> <20230323155613.GC739026@cmpxchg.org>
 <CAJD7tkZ7Dz9myftc9bg7jhiaOYcn7qJ+V4sxZ_2kfnb+k=zhJQ@mail.gmail.com> <20230323172732.GE739026@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679594903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GVEQ3jjBhRvvdROqbmTd0ErWpAgtFM7LpI2zkeVM6nc=;
        b=iSMmzvR4nUOgFdPoIuMVdAVhXTbAdbYo7pLETlxOCbMwcNRovtBt/22dPXrSySYxbp
         zJCQTHhPo4PFrUR62vtMimmYSgiWTsqB9tSiqzOg0nSraK9/nvwtvh334JEH2rWJQ6FS
         97I4Xoiz7o/cACMu+o9beDqaksw/PavmXjFklptwSOqiOI8p/ig5E0vc2DDXoFcGspgE
         dju0BzbOVvGZNQp11KXGu3UcBpKdWla8vD/e/4gAeirBuUxilCcora4A4l+Yn/h2OwD4
         6M/kCw/eev/Mgj2sy4Ebimfd+9ZQNukVrkyECwua5LZ1YLU4Qdfjw8d4Qq5KqMIfy9SZ
         h7Sw==
In-Reply-To: <20230323172732.GE739026-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 23, 2023 at 10:27=E2=80=AFAM Johannes Weiner <hannes-druUgvl0LCPF2uMehF1BdA@public.gmane.org=
g> wrote:
>
> On Thu, Mar 23, 2023 at 09:01:12AM -0700, Yosry Ahmed wrote:
> > On Thu, Mar 23, 2023 at 8:56=E2=80=AFAM Johannes Weiner <hannes@cmpxchg=
.org> wrote:
> > >
> > > On Thu, Mar 23, 2023 at 04:00:34AM +0000, Yosry Ahmed wrote:
> > > > @@ -644,26 +644,26 @@ static void __mem_cgroup_flush_stats(void)
> > > >               return;
> > > >
> > > >       flush_next_time =3D jiffies_64 + 2*FLUSH_TIME;
> > > > -     cgroup_rstat_flush(root_mem_cgroup->css.cgroup, false);
> > > > +     cgroup_rstat_flush(root_mem_cgroup->css.cgroup, may_sleep);
> > >
> > > How is it safe to call this with may_sleep=3Dtrue when it's holding t=
he
> > > stats_flush_lock?
> >
> > stats_flush_lock is always called with trylock, it is only used today
> > so that we can skip flushing if another cpu is already doing a flush
> > (which is not 100% correct as they may have not finished flushing yet,
> > but that's orthogonal here). So I think it should be safe to sleep as
> > no one can be blocked waiting for this spinlock.
>
> I see. It still cannot sleep while the lock is held, though, because
> preemption is disabled. Make sure you have all lock debugging on while
> testing this.

Thanks for pointing this out, will do.

>
> > Perhaps it would be better semantically to replace the spinlock with
> > an atomic test and set, instead of having a lock that can only be used
> > with trylock?
>
> It could be helpful to clarify what stats_flush_lock is protecting
> first. Keep in mind that locks should protect data, not code paths.
>
> Right now it's doing multiple things:
>
> 1. It protects updates to stats_flush_threshold
> 2. It protects updates to flush_next_time
> 3. It serializes calls to cgroup_rstat_flush() based on those ratelimits
>
> However,
>
> 1. stats_flush_threshold is already an atomic
>
> 2. flush_next_time is not atomic. The writer is locked, but the reader
>    is lockless. If the reader races with a flush, you could see this:
>
>                                         if (time_after(jiffies, flush_nex=
t_time))
>         spin_trylock()
>         flush_next_time =3D now + delay
>         flush()
>         spin_unlock()
>                                         spin_trylock()
>                                         flush_next_time =3D now + delay
>                                         flush()
>                                         spin_unlock()
>
>    which means we already can get flushes at a higher frequency than
>    FLUSH_TIME during races. But it isn't really a problem.
>
>    The reader could also see garbled partial updates, so it needs at
>    least READ_ONCE and WRITE_ONCE protection.
>
> 3. Serializing cgroup_rstat_flush() calls against the ratelimit
>    factors is currently broken because of the race in 2. But the race
>    is actually harmless, all we might get is the occasional earlier
>    flush. If there is no delta, the flush won't do much. And if there
>    is, the flush is justified.
>
> In summary, it seems to me the lock can be ditched altogether. All the
> code needs is READ_ONCE/WRITE_ONCE around flush_next_time.

Thanks a lot for this analysis. I agree that the lock can be removed
with proper READ_ONCE/WRITE_ONCE, but I think there is another purpose
of the lock that we are missing here.

I think one other purpose of the lock is avoiding a thundering herd
problem on cgroup_rstat_lock, particularly from reclaim context, as
mentioned by the log of  commit aa48e47e3906 ("memcg: infrastructure
to flush memcg stats").

While testing, I did notice that removing this lock indeed causes a
thundering herd problem if we have a lot of concurrent reclaimers. The
trylock makes sure we abort immediately if someone else is flushing --
which is not ideal because that flusher might have just started, and
we may end up reading stale data anyway.

This is why I suggested replacing the lock by an atomic, and do
something like this if we want to maintain the current behavior:

static void __mem_cgroup_flush_stats(void)
{
    ...
    if (atomic_xchg(&ongoing_flush, 1))
        return;
    ...
    atomic_set(&ongoing_flush, 0)
}

Alternatively, if we want to change the behavior and wait for the
concurrent flusher to finish flushing, we can maybe spin until
ongoing_flush goes back to 0 and then return:

static void __mem_cgroup_flush_stats(void)
{
    ...
    if (atomic_xchg(&ongoing_flush, 1)) {
        /* wait until the ongoing flusher finishes to get updated stats */
        while (atomic_read(&ongoing_flush) {};
        return;
    }
    /* flush the stats ourselves */
    ...
    atomic_set(&ongoing_flush, 0)
}

WDYT?
