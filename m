From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFC] [PATCH 2/7 v2] memcg: add memory barrier for checking
 account move.
Date: Tue, 24 Jan 2012 12:21:20 +0900
Message-ID: <20120124122120.53f01da5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
	<20120113173347.6231f510.kamezawa.hiroyu@jp.fujitsu.com>
	<20120117152635.GA22142@tiehlicka.suse.cz>
	<20120118090656.83268b3e.kamezawa.hiroyu@jp.fujitsu.com>
	<20120118123759.GB31112@tiehlicka.suse.cz>
	<20120119111727.6337bde4.kamezawa.hiroyu@jp.fujitsu.com>
	<CALWz4iz59=-J+cif+XickXBG3zUSy58yHhkX6j3zbJyBXGzpYw@mail.gmail.com>
	<20120123090436.GA12375@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120123090436.GA12375-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org" <hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, 23 Jan 2012 10:04:36 +0100
Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:

> On Fri 20-01-12 10:08:44, Ying Han wrote:
> > On Wed, Jan 18, 2012 at 6:17 PM, KAMEZAWA Hiroyuki
> > <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> > > On Wed, 18 Jan 2012 13:37:59 +0100
> > > Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> > >
> > >> On Wed 18-01-12 09:06:56, KAMEZAWA Hiroyuki wrote:
> > >> > On Tue, 17 Jan 2012 16:26:35 +0100
> > >> > Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> > >> >
> > >> > > On Fri 13-01-12 17:33:47, KAMEZAWA Hiroyuki wrote:
> > >> > > > I think this bugfix is needed before going ahead. thoughts=
?
> > >> > > > =3D=3D
> > >> > > > From 2cb491a41782b39aae9f6fe7255b9159ac6c1563 Mon Sep 17 0=
0:00:00 2001
> > >> > > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> > >> > > > Date: Fri, 13 Jan 2012 14:27:20 +0900
> > >> > > > Subject: [PATCH 2/7] memcg: add memory barrier for checkin=
g account move.
> > >> > > >
> > >> > > > At starting move_account(), source memcg's per-cpu variabl=
e
> > >> > > > MEM_CGROUP_ON_MOVE is set. The page status update
> > >> > > > routine check it under rcu_read_lock(). But there is no me=
mory
> > >> > > > barrier. This patch adds one.
> > >> > >
> > >> > > OK this would help to enforce that the CPU would see the cur=
rent value
> > >> > > but what prevents us from the race with the value update wit=
hout the
> > >> > > lock? This is as racy as it was before AFAICS.
> > >> > >
> > >> >
> > >> > Hm, do I misunderstand ?
> > >> > =3D=3D
> > >> > =C2=A0 =C2=A0update =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 reference
> > >> >
> > >> > =C2=A0 =C2=A0CPU A =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CPU B
> > >> > =C2=A0 set value =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0rcu_read_lock()
> > >> > =C2=A0 smp_wmb() =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0smp_rmb()
> > >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0read_value
> > >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rcu_read_unlock()
> > >> > =C2=A0 synchronize_rcu().
> > >> > =3D=3D
> > >> > I expect
> > >> > If synchronize_rcu() is called before rcu_read_lock() =3D> mov=
e_lock_xxx will be held.
> > >> > If synchronize_rcu() is called after rcu_read_lock() =3D> upda=
te will be delayed.
> > >>
> > >> Ahh, OK I can see it now. Readers are not that important because=
 it is
> > >> actually the updater who is delayed until all preexisting rcu re=
ad
> > >> sections are finished.
> > >>
> > >> In that case. Why do we need both barriers? spin_unlock is a ful=
l
> > >> barrier so maybe we just need smp_rmb before we read value to ma=
ke sure
> > >> that we do not get stalled value when we start rcu_read section =
after
> > >> synchronize_rcu?
> > >>
> > >
> > > I doubt .... If no barrier, this case happens
> > >
> > > =3D=3D
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0update =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0reference
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0CPU A =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CPU B
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0set value
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0synchronize_rcu() =C2=A0 =C2=A0 =C2=A0=
 rcu_read_lock()
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0read_value <=3D find old v=
alue
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rcu_read_unlock()
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0do no lock
> > > =3D=3D
> >=20
> > Hi Kame,
> >=20
> > Can you help to clarify a bit more on the example above? Why
> > read_value got the old value after synchronize_rcu().
>=20
> AFAIU it is because rcu_read_unlock doesn't force any memory barrier
> and we synchronize only the updater (with synchronize_rcu), so nothin=
g
> guarantees that the value set on CPUA is visible to CPUB.
>=20

Thank you.=20

=2E..Finally, I'd like to make this check to atomic_t rather than compl=
icated
percpu counter. Hmm, do it now ?

Thanks,
-Kame

