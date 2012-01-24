From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFC] [PATCH 7/7 v2] memcg: make mem_cgroup_begin_update_stat
 to use global pcpu.
Date: Tue, 24 Jan 2012 12:18:46 +0900
Message-ID: <20120124121846.051d225b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
	<20120113174510.5e0f6131.kamezawa.hiroyu@jp.fujitsu.com>
	<CAHH2K0ZzE55Dx=pz+cR1US3UnUbUxuyVjM=N3kf3NN+Rz8GJjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHH2K0ZzE55Dx=pz+cR1US3UnUbUxuyVjM=N3kf3NN+Rz8GJjQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org" <hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri, 20 Jan 2012 00:40:34 -0800
Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> On Fri, Jan 13, 2012 at 12:45 AM, KAMEZAWA Hiroyuki

> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 8b67ccf..4836e8d 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -89,7 +89,6 @@ enum mem_cgroup_stat_index {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0MEM_CGROUP_STAT_FILE_MAPPED, =C2=A0/* # =
of pages charged as file rss */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0MEM_CGROUP_STAT_SWAPOUT, /* # of pages, =
swapped out */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0MEM_CGROUP_STAT_DATA, /* end of data req=
uires synchronization */
> > - =C2=A0 =C2=A0 =C2=A0 MEM_CGROUP_ON_MOVE, =C2=A0 =C2=A0 /* someone=
 is moving account between groups */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0MEM_CGROUP_STAT_NSTATS,
> > =C2=A0};
> >
> > @@ -279,6 +278,8 @@ struct mem_cgroup {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 * mem_cgroup ? And what type of charges=
 should we move ?
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long =C2=A0 move_charge_at_immi=
grate;
> > + =C2=A0 =C2=A0 =C2=A0 /* set when a page under this memcg may be m=
oving to other memcg */
> > + =C2=A0 =C2=A0 =C2=A0 atomic_t =C2=A0 =C2=A0 =C2=A0 =C2=A0account_=
moving;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 * percpu counter.
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> > @@ -1250,20 +1251,27 @@ int mem_cgroup_swappiness(struct mem_cgroup=
 *memcg)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return memcg->swappiness;
> > =C2=A0}
> >
> > +/*
> > + * For quick check, for avoiding looking up memcg, system-wide
> > + * per-cpu check is provided.
> > + */
> > +DEFINE_PER_CPU(int, mem_cgroup_account_moving);
>=20
> Why is this a per-cpu counter?  Can this be an single atomic_t
> instead, or does cpu hotplug require per-cpu state?  In the common
> case, when there is no move in progress, then the counter would be
> zero and clean in all cpu caches that need it.  When moving pages,
> mem_cgroup_start_move() would atomic_inc the counter.
>=20

Ok, atomic_t will be simple.

Thanks,
-Kame
