From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [RFC] [PATCH 2/7 v2] memcg: add memory barrier for checking
 account move.
Date: Tue, 24 Jan 2012 09:49:47 +0100
Message-ID: <20120124084947.GF26289@tiehlicka.suse.cz>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
 <20120113173347.6231f510.kamezawa.hiroyu@jp.fujitsu.com>
 <20120117152635.GA22142@tiehlicka.suse.cz>
 <20120118090656.83268b3e.kamezawa.hiroyu@jp.fujitsu.com>
 <20120118123759.GB31112@tiehlicka.suse.cz>
 <20120119111727.6337bde4.kamezawa.hiroyu@jp.fujitsu.com>
 <CALWz4iz59=-J+cif+XickXBG3zUSy58yHhkX6j3zbJyBXGzpYw@mail.gmail.com>
 <20120123090436.GA12375@tiehlicka.suse.cz>
 <20120124122120.53f01da5.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20120124122120.53f01da5.kamezawa.hiroyu@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, cgroups@vger.kernel.org, "bsingharora@gmail.com" <bsingharora@gmail.com>

On Tue 24-01-12 12:21:20, KAMEZAWA Hiroyuki wrote:
> On Mon, 23 Jan 2012 10:04:36 +0100
> Michal Hocko <mhocko@suse.cz> wrote:
>=20
> > On Fri 20-01-12 10:08:44, Ying Han wrote:
> > > On Wed, Jan 18, 2012 at 6:17 PM, KAMEZAWA Hiroyuki
> > > <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > > On Wed, 18 Jan 2012 13:37:59 +0100
> > > > Michal Hocko <mhocko@suse.cz> wrote:
> > > >
> > > >> On Wed 18-01-12 09:06:56, KAMEZAWA Hiroyuki wrote:
> > > >> > On Tue, 17 Jan 2012 16:26:35 +0100
> > > >> > Michal Hocko <mhocko@suse.cz> wrote:
> > > >> >
> > > >> > > On Fri 13-01-12 17:33:47, KAMEZAWA Hiroyuki wrote:
> > > >> > > > I think this bugfix is needed before going ahead. thoughts=
?
> > > >> > > > =3D=3D
> > > >> > > > From 2cb491a41782b39aae9f6fe7255b9159ac6c1563 Mon Sep 17 0=
0:00:00 2001
> > > >> > > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > >> > > > Date: Fri, 13 Jan 2012 14:27:20 +0900
> > > >> > > > Subject: [PATCH 2/7] memcg: add memory barrier for checkin=
g account move.
> > > >> > > >
> > > >> > > > At starting move_account(), source memcg's per-cpu variabl=
e
> > > >> > > > MEM_CGROUP_ON_MOVE is set. The page status update
> > > >> > > > routine check it under rcu_read_lock(). But there is no me=
mory
> > > >> > > > barrier. This patch adds one.
> > > >> > >
> > > >> > > OK this would help to enforce that the CPU would see the cur=
rent value
> > > >> > > but what prevents us from the race with the value update wit=
hout the
> > > >> > > lock? This is as racy as it was before AFAICS.
> > > >> > >
> > > >> >
> > > >> > Hm, do I misunderstand ?
> > > >> > =3D=3D
> > > >> > =A0 =A0update =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 referenc=
e
> > > >> >
> > > >> > =A0 =A0CPU A =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CP=
U B
> > > >> > =A0 set value =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rcu_read_lock()
> > > >> > =A0 smp_wmb() =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0smp_rmb()
> > > >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0read_va=
lue
> > > >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rcu_rea=
d_unlock()
> > > >> > =A0 synchronize_rcu().
> > > >> > =3D=3D
> > > >> > I expect
> > > >> > If synchronize_rcu() is called before rcu_read_lock() =3D> mov=
e_lock_xxx will be held.
> > > >> > If synchronize_rcu() is called after rcu_read_lock() =3D> upda=
te will be delayed.
> > > >>
> > > >> Ahh, OK I can see it now. Readers are not that important because=
 it is
> > > >> actually the updater who is delayed until all preexisting rcu re=
ad
> > > >> sections are finished.
> > > >>
> > > >> In that case. Why do we need both barriers? spin_unlock is a ful=
l
> > > >> barrier so maybe we just need smp_rmb before we read value to ma=
ke sure
> > > >> that we do not get stalled value when we start rcu_read section =
after
> > > >> synchronize_rcu?
> > > >>
> > > >
> > > > I doubt .... If no barrier, this case happens
> > > >
> > > > =3D=3D
> > > > =A0 =A0 =A0 =A0update =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0referenc=
e
> > > > =A0 =A0 =A0 =A0CPU A =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CPU B
> > > > =A0 =A0 =A0 =A0set value
> > > > =A0 =A0 =A0 =A0synchronize_rcu() =A0 =A0 =A0 rcu_read_lock()
> > > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0re=
ad_value <=3D find old value
> > > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc=
u_read_unlock()
> > > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0do=
 no lock
> > > > =3D=3D
> > >=20
> > > Hi Kame,
> > >=20
> > > Can you help to clarify a bit more on the example above? Why
> > > read_value got the old value after synchronize_rcu().
> >=20
> > AFAIU it is because rcu_read_unlock doesn't force any memory barrier
> > and we synchronize only the updater (with synchronize_rcu), so nothin=
g
> > guarantees that the value set on CPUA is visible to CPUB.
> >=20
>=20
> Thank you.=20
>=20
> ...Finally, I'd like to make this check to atomic_t rather than complic=
ated
> percpu counter. Hmm, do it now ?

I thought you wanted to prevent from atomics but you would need a read
barrier in the reader side because only atomics which change the state
imply a memory barrier IIRC. So it is a question why atomic is
simpler...

>=20
> Thanks,
> -Kame
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9   =20
Czech Republic

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter=
.ca/
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
