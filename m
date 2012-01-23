From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC] [PATCH 2/7 v2] memcg: add memory barrier for checking
 account move.
Date: Mon, 23 Jan 2012 10:04:36 +0100
Message-ID: <20120123090436.GA12375@tiehlicka.suse.cz>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
 <20120113173347.6231f510.kamezawa.hiroyu@jp.fujitsu.com>
 <20120117152635.GA22142@tiehlicka.suse.cz>
 <20120118090656.83268b3e.kamezawa.hiroyu@jp.fujitsu.com>
 <20120118123759.GB31112@tiehlicka.suse.cz>
 <20120119111727.6337bde4.kamezawa.hiroyu@jp.fujitsu.com>
 <CALWz4iz59=-J+cif+XickXBG3zUSy58yHhkX6j3zbJyBXGzpYw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALWz4iz59=-J+cif+XickXBG3zUSy58yHhkX6j3zbJyBXGzpYw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org" <hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri 20-01-12 10:08:44, Ying Han wrote:
> On Wed, Jan 18, 2012 at 6:17 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> > On Wed, 18 Jan 2012 13:37:59 +0100
> > Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> >
> >> On Wed 18-01-12 09:06:56, KAMEZAWA Hiroyuki wrote:
> >> > On Tue, 17 Jan 2012 16:26:35 +0100
> >> > Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> >> >
> >> > > On Fri 13-01-12 17:33:47, KAMEZAWA Hiroyuki wrote:
> >> > > > I think this bugfix is needed before going ahead. thoughts?
> >> > > > =3D=3D
> >> > > > From 2cb491a41782b39aae9f6fe7255b9159ac6c1563 Mon Sep 17 00:=
00:00 2001
> >> > > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> >> > > > Date: Fri, 13 Jan 2012 14:27:20 +0900
> >> > > > Subject: [PATCH 2/7] memcg: add memory barrier for checking =
account move.
> >> > > >
> >> > > > At starting move_account(), source memcg's per-cpu variable
> >> > > > MEM_CGROUP_ON_MOVE is set. The page status update
> >> > > > routine check it under rcu_read_lock(). But there is no memo=
ry
> >> > > > barrier. This patch adds one.
> >> > >
> >> > > OK this would help to enforce that the CPU would see the curre=
nt value
> >> > > but what prevents us from the race with the value update witho=
ut the
> >> > > lock? This is as racy as it was before AFAICS.
> >> > >
> >> >
> >> > Hm, do I misunderstand ?
> >> > =3D=3D
> >> > =A0 =A0update =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 reference
> >> >
> >> > =A0 =A0CPU A =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CPU =
B
> >> > =A0 set value =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rcu_read_lock()
> >> > =A0 smp_wmb() =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0smp_rmb()
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0read_valu=
e
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rcu_read_=
unlock()
> >> > =A0 synchronize_rcu().
> >> > =3D=3D
> >> > I expect
> >> > If synchronize_rcu() is called before rcu_read_lock() =3D> move_=
lock_xxx will be held.
> >> > If synchronize_rcu() is called after rcu_read_lock() =3D> update=
 will be delayed.
> >>
> >> Ahh, OK I can see it now. Readers are not that important because i=
t is
> >> actually the updater who is delayed until all preexisting rcu read
> >> sections are finished.
> >>
> >> In that case. Why do we need both barriers? spin_unlock is a full
> >> barrier so maybe we just need smp_rmb before we read value to make=
 sure
> >> that we do not get stalled value when we start rcu_read section af=
ter
> >> synchronize_rcu?
> >>
> >
> > I doubt .... If no barrier, this case happens
> >
> > =3D=3D
> > =A0 =A0 =A0 =A0update =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0reference
> > =A0 =A0 =A0 =A0CPU A =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CPU B
> > =A0 =A0 =A0 =A0set value
> > =A0 =A0 =A0 =A0synchronize_rcu() =A0 =A0 =A0 rcu_read_lock()
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0read=
_value <=3D find old value
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rcu_=
read_unlock()
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0do n=
o lock
> > =3D=3D
>=20
> Hi Kame,
>=20
> Can you help to clarify a bit more on the example above? Why
> read_value got the old value after synchronize_rcu().

AFAIU it is because rcu_read_unlock doesn't force any memory barrier
and we synchronize only the updater (with synchronize_rcu), so nothing
guarantees that the value set on CPUA is visible to CPUB.

--=20
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9   =20
Czech Republic
