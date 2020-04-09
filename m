From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Subject: Re: Memory CG and 5.1 to 5.6 uprade slows backup
Date: Thu, 9 Apr 2020 12:17:33 +0200
Message-ID: <20200409121733.1a5ba17c@hemera.lan.sysophe.eu>
References: <20200409112505.2e1fc150@hemera.lan.sysophe.eu>
        <20200409094615.GE18386@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200409094615.GE18386-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

On Thu, 9 Apr 2020 11:46:15 Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@pub=
lic.gmane.org> wrote:
> [Cc Chris]
>=20
> On Thu 09-04-20 11:25:05, Bruno Pr=C3=A9mont wrote:
> > Hi,
> >=20
> > Upgrading from 5.1 kernel to 5.6 kernel on a production system using
> > cgroups (v2) and having backup process in a memory.high=3D2G cgroup
> > sees backup being highly throttled (there are about 1.5T to be
> > backuped). =20
>=20
> What does /proc/sys/vm/dirty_* say?

/proc/sys/vm/dirty_background_bytes:0
/proc/sys/vm/dirty_background_ratio:10
/proc/sys/vm/dirty_bytes:0
/proc/sys/vm/dirty_expire_centisecs:3000
/proc/sys/vm/dirty_ratio:20
/proc/sys/vm/dirty_writeback_centisecs:500

Captured after having restarted the backup task.
After backup process restart the cgroup again has more free memory and
things run at a normal speed (until cgroup memory gets "full" again).
Current cgroup stats when things run fluently:

anon 176128
file 633012224
kernel_stack 73728
slab 47173632
sock 364544
shmem 0
file_mapped 10678272
file_dirty 811008
file_writeback 405504
anon_thp 0
inactive_anon 0
active_anon 0
inactive_file 552849408
active_file 79360000
unevictable 0
slab_reclaimable 46411776
slab_unreclaimable 761856
pgfault 8656857
pgmajfault 2145
workingset_refault 8672334
workingset_activate 410586
workingset_nodereclaim 92895
pgrefill 1516540
pgscan 48241750
pgsteal 45655752
pgactivate 7986
pgdeactivate 1483626
pglazyfree 0
pglazyfreed 0
thp_fault_alloc 0
thp_collapse_alloc 0


> Is it possible that the reclaim is not making progress on too many
> dirty pages and that triggers the back off mechanism that has been
> implemented recently in  5.4 (have a look at 0e4b01df8659 ("mm,
> memcg: throttle allocators when failing reclaim over memory.high")
> and e26733e0d0ec ("mm, memcg: throttle allocators based on
> ancestral memory.high").

Could be though in that case it's throttling the wrong task/cgroup
as far as I can see (at least from cgroup's memory stats) or being
blocked by state external to the cgroup.
Will have a look at those patches so get a better idea at what they
change.

System-wide memory is at least 10G/64G completely free (varies between
10G and 20G free - ~18G file cache, ~10G reclaimable slabs, ~5G
unreclaimable slabs and 7G otherwise in use).

> Keeping the rest of the email for reference.
>=20
> > Most memory usage in that cgroup is for file cache.
> >=20
> > Here are the memory details for the cgroup:
> > memory.current:2147225600
> > memory.events:low 0
> > memory.events:high 423774
> > memory.events:max 31131
> > memory.events:oom 0
> > memory.events:oom_kill 0
> > memory.events.local:low 0
> > memory.events.local:high 423774
> > memory.events.local:max 31131
> > memory.events.local:oom 0
> > memory.events.local:oom_kill 0
> > memory.high:2147483648
> > memory.low:33554432
> > memory.max:2415919104
> > memory.min:0
> > memory.oom.group:0
> > memory.pressure:some avg10=3D90.42 avg60=3D72.59 avg300=3D78.30 total=
=3D298252577711
> > memory.pressure:full avg10=3D90.32 avg60=3D72.53 avg300=3D78.24 total=
=3D295658626500
> > memory.stat:anon 10887168
> > memory.stat:file 2062102528
> > memory.stat:kernel_stack 73728
> > memory.stat:slab 76148736
> > memory.stat:sock 360448
> > memory.stat:shmem 0
> > memory.stat:file_mapped 12029952
> > memory.stat:file_dirty 946176
> > memory.stat:file_writeback 405504
> > memory.stat:anon_thp 0
> > memory.stat:inactive_anon 0
> > memory.stat:active_anon 10121216
> > memory.stat:inactive_file 1954959360
> > memory.stat:active_file 106418176
> > memory.stat:unevictable 0
> > memory.stat:slab_reclaimable 75247616
> > memory.stat:slab_unreclaimable 901120
> > memory.stat:pgfault 8651676
> > memory.stat:pgmajfault 2013
> > memory.stat:workingset_refault 8670651
> > memory.stat:workingset_activate 409200
> > memory.stat:workingset_nodereclaim 62040
> > memory.stat:pgrefill 1513537
> > memory.stat:pgscan 47519855
> > memory.stat:pgsteal 44933838
> > memory.stat:pgactivate 7986
> > memory.stat:pgdeactivate 1480623
> > memory.stat:pglazyfree 0
> > memory.stat:pglazyfreed 0
> > memory.stat:thp_fault_alloc 0
> > memory.stat:thp_collapse_alloc 0
> >=20
> > Numbers that change most are pgscan/pgsteal
> > Regularly the backup process seems to be blocked for about 2s, but not
> > within a syscall according to strace.
> >=20
> > Is there a way to tell kernel that this cgroup should not be throttled
> > and its inactive file cache given up (rather quickly).
> >=20
> > The aim here is to avoid backup from killing production task file cache
> > but not starving it.
> >=20
> >=20
> > If there is some useful info missing, please tell (eventually adding how
> > I can obtain it).
> >=20
> >=20
> > On a side note, I liked v1's mode of soft/hard memory limit where the
> > memory amount between soft and hard could be used if system has enough
> > free memory. For v2 the difference between high and max seems almost of
> > no use.
> >=20
> > A cgroup parameter for impacting RO file cache differently than
> > anonymous memory or otherwise dirty memory would be great too.
> >=20
> >=20
> > Thanks,
> > Bruno
