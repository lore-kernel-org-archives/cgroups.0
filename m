From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Subject: Re: Memory CG and 5.1 to 5.6 uprade slows backup
Date: Thu, 9 Apr 2020 17:40:42 +0200
Message-ID: <20200409174042.2a3389ba@hemera.lan.sysophe.eu>
References: <20200409112505.2e1fc150@hemera.lan.sysophe.eu>
        <20200409094615.GE18386@dhcp22.suse.cz>
        <20200409121733.1a5ba17c@hemera.lan.sysophe.eu>
        <20200409103400.GF18386@dhcp22.suse.cz>
        <20200409170926.182354c3@hemera.lan.sysophe.eu>
        <20200409152417.GB1040020@chrisdown.name>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200409152417.GB1040020-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, 9 Apr 2020 16:24:17 +0100 wrote:

> Bruno Pr=C3=A9mont writes:
> >Could it be that cache is being prevented from being reclaimed by a task
> >in another cgroup?
> >
> >e.g.
> >  cgroup/system/backup
> >    first reads $files (reads each once)
> >  cgroup/workload/bla
> >    second&more reads $files
> >
> >Would $files remain associated to cgroup/system/backup and not
> >reclaimed there instead of being reassigned to cgroup/workload/bla? =20
>=20
> Yes, that's entirely possible. The first cgroup to fault in the pages is =

> charged for the memory. Other cgroups may use them, but they are not acco=
unted=20
> for as part of that other cgroup. They may also still be "active" as a re=
sult=20
> of use by another cgroup.

But the memory would then be 'active' in the original cgroup? which is
not the case here I feel.
If the remain inactive-unreclaimable in the first cgroup due to use in
another cgroup that would be at least surprising.

Doubling the high value helped (but for how long?), back with
memory.current around memory.high nut no throttling yet. But from
increase until now memory.pressure is small/zero.

Capturing=20
  memory.stat:pgscan 47519855
  memory.stat:pgsteal 44933838
over time for Michal and will report back later this evening.

When seen stuck backup was reading a multi-GiB file with
  open(, O_NOATIME)
  while (read()) {
    transform and write to network
  }
  close()
thus plain sequential file read through file cache (and for this
backup run, only files not in use by anyone else, or some being
just appended to by others).

Bruno
