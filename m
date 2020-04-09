From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Memory CG and 5.1 to 5.6 uprade slows backup
Date: Thu, 9 Apr 2020 17:25:40 +0200
Message-ID: <20200409152540.GP18386@dhcp22.suse.cz>
References: <20200409112505.2e1fc150@hemera.lan.sysophe.eu>
 <20200409094615.GE18386@dhcp22.suse.cz>
 <20200409121733.1a5ba17c@hemera.lan.sysophe.eu>
 <20200409103400.GF18386@dhcp22.suse.cz>
 <20200409170926.182354c3@hemera.lan.sysophe.eu>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200409170926.182354c3-pDZhbqX7CfkoGc32E1+a2S4z1YicLaQ4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

On Thu 09-04-20 17:09:26, Bruno Pr=E9mont wrote:
> On Thu, 9 Apr 2020 12:34:00 +0200Michal Hocko wrote:
>=20
> > On Thu 09-04-20 12:17:33, Bruno Pr=E9mont wrote:
> > > On Thu, 9 Apr 2020 11:46:15 Michal Hocko wrote: =20
> > > > [Cc Chris]
> > > >=20
> > > > On Thu 09-04-20 11:25:05, Bruno Pr=E9mont wrote: =20
> > > > > Hi,
> > > > >=20
> > > > > Upgrading from 5.1 kernel to 5.6 kernel on a production system us=
ing
> > > > > cgroups (v2) and having backup process in a memory.high=3D2G cgro=
up
> > > > > sees backup being highly throttled (there are about 1.5T to be
> > > > > backuped).   =20
> > > >=20
> > > > What does /proc/sys/vm/dirty_* say? =20
> > >=20
> > > /proc/sys/vm/dirty_background_bytes:0
> > > /proc/sys/vm/dirty_background_ratio:10
> > > /proc/sys/vm/dirty_bytes:0
> > > /proc/sys/vm/dirty_expire_centisecs:3000
> > > /proc/sys/vm/dirty_ratio:20
> > > /proc/sys/vm/dirty_writeback_centisecs:500 =20
> >=20
> > Sorry, but I forgot ask for the total amount of memory. But it seems
> > this is 64GB and 10% dirty ration might mean a lot of dirty memory.
> > Does the same happen if you reduce those knobs to something smaller than
> > 2G? _bytes alternatives should be useful for that purpose.
>=20
> Well, tuning it to /proc/sys/vm/dirty_background_bytes:268435456
> /proc/sys/vm/dirty_background_ratio:0
> /proc/sys/vm/dirty_bytes:536870912
> /proc/sys/vm/dirty_expire_centisecs:3000
> /proc/sys/vm/dirty_ratio:0
> /proc/sys/vm/dirty_writeback_centisecs:500
> does not make any difference.

OK, it was a wild guess because cgroup v2 should be able to throttle
heavy writers and be memcg aware AFAIR. But good to have it confirmed.

[...]

> > > > Is it possible that the reclaim is not making progress on too many
> > > > dirty pages and that triggers the back off mechanism that has been
> > > > implemented recently in  5.4 (have a look at 0e4b01df8659 ("mm,
> > > > memcg: throttle allocators when failing reclaim over memory.high")
> > > > and e26733e0d0ec ("mm, memcg: throttle allocators based on
> > > > ancestral memory.high"). =20
> > >=20
> > > Could be though in that case it's throttling the wrong task/cgroup
> > > as far as I can see (at least from cgroup's memory stats) or being
> > > blocked by state external to the cgroup.
> > > Will have a look at those patches so get a better idea at what they
> > > change. =20
> >=20
> > Could you check where is the task of your interest throttled?
> > /proc/<pid>/stack should give you a clue.
>=20
> As guessed by Chris, it's
> [<0>] mem_cgroup_handle_over_high+0x121/0x170
> [<0>] exit_to_usermode_loop+0x67/0xa0
> [<0>] do_syscall_64+0x149/0x170
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
>=20
> And I know no way to tell kernel "drop all caches" for a specific cgroup
> nor how to list the inactive files assigned to a given cgroup (knowing
> which ones they are and their idle state could help understanding why
> they aren't being reclaimed).
>=20
>=20
>=20
> Could it be that cache is being prevented from being reclaimed by a task
> in another cgroup?
>=20
> e.g.
>   cgroup/system/backup
>     first reads $files (reads each once)
>   cgroup/workload/bla
>     second&more reads $files
>=20
> Would $files remain associated to cgroup/system/backup and not
> reclaimed there instead of being reassigned to cgroup/workload/bla?

No, page cache is first-touch-gets-charged. But there is certainly a
interference possible if the memory is somehow pinned - e.g. mlock - by
a task from another cgroup or internally by FS.

Your earlier stat snapshot doesn't indicate a big problem with the
reclaim though:

memory.stat:pgscan 47519855
memory.stat:pgsteal 44933838

This tells the overall reclaim effectiveness was 94%. Could you try to
gather snapshots with a 1s granularity starting before your run your
backup to see how those numbers evolve? Ideally with timestamps to
compare with the actual stall information.

Another option would be to enable vmscan tracepoints but let's try with
stats first.
--=20
Michal Hocko
SUSE Labs
