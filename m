From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 1/2] mm: memcg: per-memcg reclaim statistics
Date: Wed, 11 Jan 2012 01:30:20 +0100
Message-ID: <20120111003020.GD24386@cmpxchg.org>
References: <1326207772-16762-1-git-send-email-hannes@cmpxchg.org>
 <1326207772-16762-2-git-send-email-hannes@cmpxchg.org>
 <CALWz4izbTw4+7zbfiED9Lx=6RwiqxE11g5-fNRHTh=mcP=vQ2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALWz4izbTw4+7zbfiED9Lx=6RwiqxE11g5-fNRHTh=mcP=vQ2Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 10, 2012 at 03:54:05PM -0800, Ying Han wrote:
> Thank you for the patch and the stats looks reasonable to me, few
> questions as below:
>=20
> On Tue, Jan 10, 2012 at 7:02 AM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>=
 wrote:
> > With the single per-zone LRU gone and global reclaim scanning
> > individual memcgs, it's straight-forward to collect meaningful and
> > accurate per-memcg reclaim statistics.
> >
> > This adds the following items to memory.stat:
>=20
> Some of the previous discussions including patches have similar stats
> in memory.vmscan_stat API, which collects all the per-memcg vmscan
> stats. I would like to understand more why we add into memory.stat
> instead, and do we have plan to keep extending memory.stat for those
> vmstat like stats?

I think they were put into an extra file in particular to be able to
write to this file to reset the statistics.  But in my opinion, it's
trivial to calculate a delta from before and after running a workload,
so I didn't really like adding kernel code for that.

Did you have another reason for a separate file in mind?

> > pgreclaim
>=20
> Not sure if we want to keep this more consistent to /proc/vmstat, the=
n
> it will be "pgsteal"?

The problem with that was that we didn't like to call pages stolen
when they were reclaimed from within the cgroup, so we had pgfree for
inner reclaim and pgsteal for outer reclaim, respectively.

I found it cleaner to just go with pgreclaim, it's unambiguous and
straight-forward.  Outer reclaim is designated by the hierarchy_
prefix.

> > pgscan
> >
> > =A0Number of pages reclaimed/scanned from that memcg due to its own
> > =A0hard limit (or physical limit in case of the root memcg) by the
> > =A0allocating task.
> >
> > kswapd_pgreclaim
> > kswapd_pgscan
>=20
> we have "pgscan_kswapd_*" in vmstat, so maybe ?
> "pgsteal_kswapd"
> "pgscan_kswapd"
>=20
> > =A0Reclaim activity from kswapd due to the memcg's own limit. =A0On=
ly
> > =A0applicable to the root memcg for now since kswapd is only trigge=
red
> > =A0by physical limits, but kswapd-style reclaim based on memcg hard
> > =A0limits is being developped.
> >
> > hierarchy_pgreclaim
> > hierarchy_pgscan
> > hierarchy_kswapd_pgreclaim
> > hierarchy_kswapd_pgscan
>=20
> "pgsteal_hierarchy"
> "pgsteal_kswapd_hierarchy"
> ..
>=20
> No strong option on the naming, but try to make it more consistent to
> existing API.

I swear I tried, but the existing naming is pretty screwed up :(

=46or example, pgscan_direct_* and pgscan_kswapd_* allow you to compare
scan rates of direct reclaim vs. kswapd reclaim.  To get the total
number of pages reclaimed, you sum them up.

On the other hand, pgsteal_* does not differentiate between direct
reclaim and kswapd, so to get direct reclaim numbers, you add up the
pgsteal_* counters and subtract kswapd_steal (notice the lack of pg?),
which is in turn not available at zone granularity.

> > +#define MEM_CGROUP_EVENTS_KSWAPD 2
> > +#define MEM_CGROUP_EVENTS_HIERARCHY 4

These two function as namespaces, that's why I put hierarchy_ and
kswapd_ at the beginning of the names.

Given that we have kswapd_steal, would you be okay with doing it like
this?  I mean, at least my naming conforms to ONE of the standards in
/proc/vmstat, right? ;-)

> > @@ -91,12 +91,23 @@ enum mem_cgroup_stat_index {
> > =A0 =A0 =A0 =A0MEM_CGROUP_STAT_NSTATS,
> > =A0};
> >
> > +#define MEM_CGROUP_EVENTS_KSWAPD 2
> > +#define MEM_CGROUP_EVENTS_HIERARCHY 4
> > +
> > =A0enum mem_cgroup_events_index {
> > =A0 =A0 =A0 =A0MEM_CGROUP_EVENTS_PGPGIN, =A0 =A0 =A0 /* # of pages =
paged in */
> > =A0 =A0 =A0 =A0MEM_CGROUP_EVENTS_PGPGOUT, =A0 =A0 =A0/* # of pages =
paged out */
> > =A0 =A0 =A0 =A0MEM_CGROUP_EVENTS_COUNT, =A0 =A0 =A0 =A0/* # of page=
s paged in/out */
> > =A0 =A0 =A0 =A0MEM_CGROUP_EVENTS_PGFAULT, =A0 =A0 =A0/* # of page-f=
aults */
> > =A0 =A0 =A0 =A0MEM_CGROUP_EVENTS_PGMAJFAULT, =A0 /* # of major page=
-faults */
> > + =A0 =A0 =A0 MEM_CGROUP_EVENTS_PGRECLAIM,
> > + =A0 =A0 =A0 MEM_CGROUP_EVENTS_PGSCAN,
> > + =A0 =A0 =A0 MEM_CGROUP_EVENTS_KSWAPD_PGRECLAIM,
> > + =A0 =A0 =A0 MEM_CGROUP_EVENTS_KSWAPD_PGSCAN,
> > + =A0 =A0 =A0 MEM_CGROUP_EVENTS_HIERARCHY_PGRECLAIM,
> > + =A0 =A0 =A0 MEM_CGROUP_EVENTS_HIERARCHY_PGSCAN,
> > + =A0 =A0 =A0 MEM_CGROUP_EVENTS_HIERARCHY_KSWAPD_PGRECLAIM,
> > + =A0 =A0 =A0 MEM_CGROUP_EVENTS_HIERARCHY_KSWAPD_PGSCAN,
>=20
> missing comment here?

As if the lines weren't long enough already ;-) I'll add some.

> > =A0 =A0 =A0 =A0MEM_CGROUP_EVENTS_NSTATS,
> > =A0};
> > =A0/*
> > @@ -889,6 +900,38 @@ static inline bool mem_cgroup_is_root(struct m=
em_cgroup *memcg)
> > =A0 =A0 =A0 =A0return (memcg =3D=3D root_mem_cgroup);
> > =A0}
> >
> > +/**
> > + * mem_cgroup_account_reclaim - update per-memcg reclaim statistic=
s
> > + * @root: memcg that triggered reclaim
> > + * @memcg: memcg that is actually being scanned
> > + * @nr_reclaimed: number of pages reclaimed from @memcg
> > + * @nr_scanned: number of pages scanned from @memcg
> > + * @kswapd: whether reclaiming task is kswapd or allocator itself
> > + */
> > +void mem_cgroup_account_reclaim(struct mem_cgroup *root,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struc=
t mem_cgroup *memcg,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsig=
ned long nr_reclaimed,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsig=
ned long nr_scanned,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bool =
kswapd)
> > +{
> > + =A0 =A0 =A0 unsigned int offset =3D 0;
> > +
> > + =A0 =A0 =A0 if (!root)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 root =3D root_mem_cgroup;
> > +
> > + =A0 =A0 =A0 if (kswapd)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset +=3D MEM_CGROUP_EVENTS_KSWAPD;
> > + =A0 =A0 =A0 if (root !=3D memcg)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset +=3D MEM_CGROUP_EVENTS_HIERARC=
HY;
>=20
> Just to be clear, here root cgroup has hierarchy_* stats always 0 ?

That's correct, there can't be any hierarchical pressure on the
topmost parent.

> Also, we might want to consider renaming the root here, something lik=
e
> target? The root is confusing with root_mem_cgroup.

It's the same naming scheme I used for the iterator functions
(mem_cgroup_iter() and friends), so if we change it, I'd like to
change it consistently.

Having target and memcg as parameters is even more confusing and
non-descriptive, IMO.

Other places use mem_over_limit, which is a bit better, but quite
long.

Any other ideas for great names for parameters that designate a
hierarchy root and a memcg in that hierarchy?
