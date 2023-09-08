From: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH v4 4/4] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Thu, 7 Sep 2023 18:02:50 -0700
Message-ID: <CABWYdi1WNp9f20nRFEExn8QB1MwP7QXwvD6Q8xHHuTO2SUTLkA@mail.gmail.com>
References: <20230831165611.2610118-1-yosryahmed@google.com>
 <20230831165611.2610118-5-yosryahmed@google.com> <ZPX0kCKd4TaVLJY7@dhcp22.suse.cz>
 <CAAPL-u9D2b=iF5Lf_cRnKxUfkiEe0AMDTu6yhrUAzX0b6a6rDg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1694134982; x=1694739782; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vgOHdnSmXvgov+u7Wmn+BFpJR24lLmQ+cuhX0XC1/Sw=;
        b=S6ue76Lh4WLAs6+657xuvrK2SvNBos+cIWjE5bnWrY99oOJnbFcCRyXpyiImLyNZl2
         QDeUdW5rf9sYmnFv2vnRoe91f1Bm2a7wvaNajBYcmk2Z/mQAErjHqk+aVRgXf5DnzLIa
         W4/9bdoXALiBbYe+2AVQsP1vW9h4T3TqYG0fk=
In-Reply-To: <CAAPL-u9D2b=iF5Lf_cRnKxUfkiEe0AMDTu6yhrUAzX0b6a6rDg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Sep 7, 2023 at 5:52=E2=80=AFPM Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Mon, Sep 4, 2023 at 8:15=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wro=
te:
> >
> > On Thu 31-08-23 16:56:11, Yosry Ahmed wrote:
> > > Unified flushing allows for great concurrency for paths that attempt =
to
> > > flush the stats, at the expense of potential staleness and a single
> > > flusher paying the extra cost of flushing the full tree.
> > >
> > > This tradeoff makes sense for in-kernel flushers that may observe hig=
h
> > > concurrency (e.g. reclaim, refault). For userspace readers, stale sta=
ts
> > > may be unexpected and problematic, especially when such stats are use=
d
> > > for critical paths such as userspace OOM handling. Additionally, a
> > > userspace reader will occasionally pay the cost of flushing the entir=
e
> > > hierarchy, which also causes problems in some cases [1].
> > >
> > > Opt userspace reads out of unified flushing. This makes the cost of
> > > reading the stats more predictable (proportional to the size of the
> > > subtree), as well as the freshness of the stats. Userspace readers ar=
e
> > > not expected to have similar concurrency to in-kernel flushers,
> > > serializing them among themselves and among in-kernel flushers should=
 be
> > > okay. Nonetheless, for extra safety, introduce a mutex when flushing =
for
> > > userspace readers to make sure only a single userspace reader can com=
pete
> > > with in-kernel flushers at a time. This takes away userspace ability =
to
> > > directly influence or hurt in-kernel lock contention.
> >
> > I think it would be helpful to note that the primary reason this is a
> > concern is that the spinlock is dropped during flushing under
> > contention.
> >
> > > An alternative is to remove flushing from the stats reading path
> > > completely, and rely on the periodic flusher. This should be accompan=
ied
> > > by making the periodic flushing period tunable, and providing an
> > > interface for userspace to force a flush, following a similar model t=
o
> > > /proc/vmstat. However, such a change will be hard to reverse if the
> > > implementation needs to be changed because:
> > > - The cost of reading stats will be very cheap and we won't be able t=
o
> > >   take that back easily.
> > > - There are user-visible interfaces involved.
> > >
> > > Hence, let's go with the change that's most reversible first and revi=
sit
> > > as needed.
> > >
> > > This was tested on a machine with 256 cpus by running a synthetic tes=
t
> > > script [2] that creates 50 top-level cgroups, each with 5 children (2=
50
> > > leaf cgroups). Each leaf cgroup has 10 processes running that allocat=
e
> > > memory beyond the cgroup limit, invoking reclaim (which is an in-kern=
el
> > > unified flusher). Concurrently, one thread is spawned per-cgroup to r=
ead
> > > the stats every second (including root, top-level, and leaf cgroups -=
-
> > > so total 251 threads). No significant regressions were observed in th=
e
> > > total run time, which means that userspace readers are not significan=
tly
> > > affecting in-kernel flushers:
> > >
> > > Base (mm-unstable):
> > >
> > > real  0m22.500s
> > > user  0m9.399s
> > > sys   73m41.381s
> > >
> > > real  0m22.749s
> > > user  0m15.648s
> > > sys   73m13.113s
> > >
> > > real  0m22.466s
> > > user  0m10.000s
> > > sys   73m11.933s
> > >
> > > With this patch:
> > >
> > > real  0m23.092s
> > > user  0m10.110s
> > > sys   75m42.774s
> > >
> > > real  0m22.277s
> > > user  0m10.443s
> > > sys   72m7.182s
> > >
> > > real  0m24.127s
> > > user  0m12.617s
> > > sys   78m52.765s
> > >
> > > [1]https://lore.kernel.org/lkml/CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M4=
3KO9ME4-dsgfoQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
> > > [2]https://lore.kernel.org/lkml/CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjc=
OBZcz6POYTV-4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
> > >
> > > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > OK, I can live with that but I still believe that locking involved in
> > the user interface only begs for issues later on as there is no control
> > over that lock contention other than the number of processes involved.
> > As it seems that we cannot make a consensus on this concern now and thi=
s
> > should be already helping existing workloads then let's just buy some
> > more time ;)
>
> Indeed, even though the new global mutex protects the kernel from the
> userspace contention on the rstats spinlock, its current
> implementation doesn't have any protection for the lock contention
> among the userspace threads and can cause significant delays to memcg
> stats reads.
>
> I tested this patch on a machine with 384 CPUs using a microbenchmark
> that spawns 10K threads, each reading its memory.stat every 100
> milliseconds.  Most of memory.stat reads take 5ms-10ms in kernel, with
> ~5% reads even exceeding 1 second. This is a significant regression.
> In comparison, without contention, each memory.stat read only takes
> 20us-50us in the kernel.  Almost all of the extra read time is spent
> on waiting for the new mutex. The time to flush rstats only accounts
> for 10us-50us (This test creates only 1K memory cgroups and doesn't
> generate any loads other than these stat reader threads).
>
>  Here are some ideas to control the lock contention on the mutex and
> reduce both the median and tail latencies of concurrent memcg stat
> reads:
>
> - Bring back the stats_flush_threshold check in
> mem_cgroup_try_flush_stats() to mem_cgroup_user_flush_stats().  This
> check provides a reasonable bound on the stats staleness while being
> able to filter out a large number of rstats flush requests, which
> reduces the contention on the mutex.
>
> - When contended, upgrade the per-memcg rstats flush in
> mem_cgroup_user_flush_stats() to a root memcg flush and coalesce these
> contended flushes together.  We can wait for the ongoing flush to
> complete and eliminate repeated flush requests.

Full root memcg flush being slow is one of the issues that prompted this pa=
tch:

* https://lore.kernel.org/lkml/CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4=
-dsgfoQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/

I don't want us to regress in this regard.

> - Wait for the mutex and the ongoing flush with a timeout.  We should
> not use busy-wait, though.  We can bail out to read the stats without
> a flush after enough wait.  A long-stalled system call is much worse
> than somewhat stale stats in the corner cases in my opinion.
>
> Wei Xu
>
> > Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> >
> > Thanks!
> >
> > > ---
> > >  mm/memcontrol.c | 24 ++++++++++++++++++++----
> > >  1 file changed, 20 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 94d5a6751a9e..46a7abf71c73 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -588,6 +588,7 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgr=
oup_tree_per_node *mctz)
> > >  static void flush_memcg_stats_dwork(struct work_struct *w);
> > >  static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_=
dwork);
> > >  static DEFINE_PER_CPU(unsigned int, stats_updates);
> > > +static DEFINE_MUTEX(stats_user_flush_mutex);
> > >  static atomic_t stats_unified_flush_ongoing =3D ATOMIC_INIT(0);
> > >  static atomic_t stats_flush_threshold =3D ATOMIC_INIT(0);
> > >  static u64 flush_next_time;
> > > @@ -655,6 +656,21 @@ static void do_stats_flush(struct mem_cgroup *me=
mcg)
> > >       cgroup_rstat_flush(memcg->css.cgroup);
> > >  }
> > >
> > > +/*
> > > + * mem_cgroup_user_flush_stats - do a stats flush for a user read
> > > + * @memcg: memory cgroup to flush
> > > + *
> > > + * Flush the subtree of @memcg. A mutex is used for userspace reader=
s to gate
> > > + * the global rstat spinlock. This protects in-kernel flushers from =
userspace
> > > + * readers hogging the lock.
> >
> > readers hogging the lock as do_stats_flush drops the spinlock under
> > contention.
> >
> > > + */
> > > +static void mem_cgroup_user_flush_stats(struct mem_cgroup *memcg)
> > > +{
> > > +     mutex_lock(&stats_user_flush_mutex);
> > > +     do_stats_flush(memcg);
> > > +     mutex_unlock(&stats_user_flush_mutex);
> > > +}
> > > +
> > >  /*
> > >   * do_unified_stats_flush - do a unified flush of memory cgroup stat=
istics
> > >   *
> > --
> > Michal Hocko
> > SUSE Labs
> >
