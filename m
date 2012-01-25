From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC] [PATCH 2/7 v2] memcg: add memory barrier for checking
 account move.
Date: Wed, 25 Jan 2012 12:07:26 +0100
Message-ID: <20120125110725.GD25368@tiehlicka.suse.cz>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
 <20120113173347.6231f510.kamezawa.hiroyu@jp.fujitsu.com>
 <20120117152635.GA22142@tiehlicka.suse.cz>
 <20120118090656.83268b3e.kamezawa.hiroyu@jp.fujitsu.com>
 <20120118123759.GB31112@tiehlicka.suse.cz>
 <20120119111727.6337bde4.kamezawa.hiroyu@jp.fujitsu.com>
 <CALWz4iz59=-J+cif+XickXBG3zUSy58yHhkX6j3zbJyBXGzpYw@mail.gmail.com>
 <20120123090436.GA12375@tiehlicka.suse.cz>
 <CALWz4iyaWtes=aU79DAbEfBsNUTaHKLK5HZbNfShaxgC8UX_TQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALWz4iyaWtes=aU79DAbEfBsNUTaHKLK5HZbNfShaxgC8UX_TQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org" <hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue 24-01-12 11:04:16, Ying Han wrote:
> On Mon, Jan 23, 2012 at 1:04 AM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> > On Fri 20-01-12 10:08:44, Ying Han wrote:
> >> On Wed, Jan 18, 2012 at 6:17 PM, KAMEZAWA Hiroyuki
> >> <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
[...]
> >> > I doubt .... If no barrier, this case happens
> >> >
> >> > =3D=3D
> >> > =A0 =A0 =A0 =A0update =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0referen=
ce
> >> > =A0 =A0 =A0 =A0CPU A =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CPU B
> >> > =A0 =A0 =A0 =A0set value
> >> > =A0 =A0 =A0 =A0synchronize_rcu() =A0 =A0 =A0 rcu_read_lock()
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0r=
ead_value <=3D find old value
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0r=
cu_read_unlock()
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0d=
o no lock
> >> > =3D=3D
> >>
> >> Hi Kame,
> >>
> >> Can you help to clarify a bit more on the example above? Why
> >> read_value got the old value after synchronize_rcu().
> >
> > AFAIU it is because rcu_read_unlock doesn't force any memory barrie=
r
> > and we synchronize only the updater (with synchronize_rcu), so noth=
ing
> > guarantees that the value set on CPUA is visible to CPUB.
>=20
> Thanks, and i might have found similar comment on the
> documentation/rcu/checklist.txt:
> "
> The various RCU read-side primitives do -not- necessarily contain
> memory barriers.
> "
>=20
> So, the read barrier here is to make sure no reordering between the
> reader and the rcu_read_lock. The same for the write barrier which
> makes sure no reordering between the updater and synchronize_rcu. The
> the rcu here is to synchronize between the updater and reader. If so,
> why not the change like :
>=20
>        for_each_online_cpu(cpu)
>                per_cpu(memcg->stat->count[MEM_CGROUP_ON_MOVE], cpu) +=
=3D 1;
> +      smp_wmb();

Threre is a data dependency between per_cpu update (the above for look)
and local read of the per-cpu on the read-side and IIUC we need to pair
write barrier with read one before we read the value.

But I might be wrong here (see the SMP BARRIER PAIRING section in
Documentation/memory-barriers.txt).

> Sorry, the use of per-cpu variable MEM_CGROUP_ON_MOVE does confuse me=
=2E

--=20
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9   =20
Czech Republic
