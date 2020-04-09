From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Memory CG and 5.1 to 5.6 uprade slows backup
Date: Thu, 9 Apr 2020 11:46:15 +0200
Message-ID: <20200409094615.GE18386@dhcp22.suse.cz>
References: <20200409112505.2e1fc150@hemera.lan.sysophe.eu>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200409112505.2e1fc150-pDZhbqX7CfkoGc32E1+a2S4z1YicLaQ4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

[Cc Chris]

On Thu 09-04-20 11:25:05, Bruno Pr=E9mont wrote:
> Hi,
>=20
> Upgrading from 5.1 kernel to 5.6 kernel on a production system using
> cgroups (v2) and having backup process in a memory.high=3D2G cgroup
> sees backup being highly throttled (there are about 1.5T to be
> backuped).

What does /proc/sys/vm/dirty_* say? Is it possible that the reclaim is
not making progress on too many dirty pages and that triggers the back
off mechanism that has been implemented recently in  5.4 (have a look at=20
0e4b01df8659 ("mm, memcg: throttle allocators when failing reclaim over
memory.high") and e26733e0d0ec ("mm, memcg: throttle allocators based on
ancestral memory.high").

Keeping the rest of the email for reference.

> Most memory usage in that cgroup is for file cache.
>=20
> Here are the memory details for the cgroup:
> memory.current:2147225600
> memory.events:low 0
> memory.events:high 423774
> memory.events:max 31131
> memory.events:oom 0
> memory.events:oom_kill 0
> memory.events.local:low 0
> memory.events.local:high 423774
> memory.events.local:max 31131
> memory.events.local:oom 0
> memory.events.local:oom_kill 0
> memory.high:2147483648
> memory.low:33554432
> memory.max:2415919104
> memory.min:0
> memory.oom.group:0
> memory.pressure:some avg10=3D90.42 avg60=3D72.59 avg300=3D78.30 total=3D2=
98252577711
> memory.pressure:full avg10=3D90.32 avg60=3D72.53 avg300=3D78.24 total=3D2=
95658626500
> memory.stat:anon 10887168
> memory.stat:file 2062102528
> memory.stat:kernel_stack 73728
> memory.stat:slab 76148736
> memory.stat:sock 360448
> memory.stat:shmem 0
> memory.stat:file_mapped 12029952
> memory.stat:file_dirty 946176
> memory.stat:file_writeback 405504
> memory.stat:anon_thp 0
> memory.stat:inactive_anon 0
> memory.stat:active_anon 10121216
> memory.stat:inactive_file 1954959360
> memory.stat:active_file 106418176
> memory.stat:unevictable 0
> memory.stat:slab_reclaimable 75247616
> memory.stat:slab_unreclaimable 901120
> memory.stat:pgfault 8651676
> memory.stat:pgmajfault 2013
> memory.stat:workingset_refault 8670651
> memory.stat:workingset_activate 409200
> memory.stat:workingset_nodereclaim 62040
> memory.stat:pgrefill 1513537
> memory.stat:pgscan 47519855
> memory.stat:pgsteal 44933838
> memory.stat:pgactivate 7986
> memory.stat:pgdeactivate 1480623
> memory.stat:pglazyfree 0
> memory.stat:pglazyfreed 0
> memory.stat:thp_fault_alloc 0
> memory.stat:thp_collapse_alloc 0
>=20
> Numbers that change most are pgscan/pgsteal
> Regularly the backup process seems to be blocked for about 2s, but not
> within a syscall according to strace.
>=20
> Is there a way to tell kernel that this cgroup should not be throttled
> and its inactive file cache given up (rather quickly).
>=20
> The aim here is to avoid backup from killing production task file cache
> but not starving it.
>=20
>=20
> If there is some useful info missing, please tell (eventually adding how
> I can obtain it).
>=20
>=20
> On a side note, I liked v1's mode of soft/hard memory limit where the
> memory amount between soft and hard could be used if system has enough
> free memory. For v2 the difference between high and max seems almost of
> no use.
>=20
> A cgroup parameter for impacting RO file cache differently than
> anonymous memory or otherwise dirty memory would be great too.
>=20
>=20
> Thanks,
> Bruno

--=20
Michal Hocko
SUSE Labs
