From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH 1/6] memcg: fix unused variable warning
Date: Mon, 26 Dec 2011 08:47:34 +0200
Message-ID: <20111226064734.GA13355@shutemov.name>
References: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
 <20111226152531.e0335ec4.kamezawa.hiroyu@jp.fujitsu.com>
 <20111226063652.GA13273@shutemov.name>
 <20111226154252.d3621532.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111226154252.d3621532.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Mon, Dec 26, 2011 at 03:42:52PM +0900, KAMEZAWA Hiroyuki wrote:
> On Mon, 26 Dec 2011 08:36:52 +0200
> "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org> wrote:
>=20
> > On Mon, Dec 26, 2011 at 03:25:31PM +0900, KAMEZAWA Hiroyuki wrote:
> > > On Sat, 24 Dec 2011 05:00:14 +0200
> > > "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org> wrote:
> > >=20
> > > > From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> > > >=20
> > > > mm/memcontrol.c: In function =E2=80=98memcg_check_events=E2=80=99=
:
> > > > mm/memcontrol.c:784:22: warning: unused variable =E2=80=98do_nu=
mainfo=E2=80=99 [-Wunused-variable]
> > > >=20
> > > > Signed-off-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> > >=20
> > > Hmm ? Doesn't this fix cause a new Warning ?
> > >=20
> > > mm/memcontrol.c: In function ?memcg_check_events?:
> > > mm/memcontrol.c:789: warning: ISO C90 forbids mixed declarations =
and code
> >=20
> > I don't see how. The result code is:
> >=20
> > 	if (unlikely(mem_cgroup_event_ratelimit(memcg,
> > 						MEM_CGROUP_TARGET_THRESH))) {
> > 		bool do_softlimit;
> >=20
> > #if MAX_NUMNODES > 1
> > 		bool do_numainfo;
> > 		do_numainfo =3D mem_cgroup_event_ratelimit(memcg,
> > 						MEM_CGROUP_TARGET_NUMAINFO);
> > #endif
> > 		do_softlimit =3D mem_cgroup_event_ratelimit(memcg,
> > 						MEM_CGROUP_TARGET_SOFTLIMIT);
> > 		preempt_enable();
> >=20
> > 		mem_cgroup_threshold(memcg);
> >=20
>=20
> Ah. please see linux-next and rebase onto that.

The patchset is on top of next-20111222. Have I missed something?

>=20
> Thanks,
> -Kame
>=20

--=20
 Kirill A. Shutemov
