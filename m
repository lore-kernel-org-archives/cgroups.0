From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Subject: Re: Regression from 5.7.17 to 5.9.9 with memory.low cgroup
 constraints
Date: Wed, 25 Nov 2020 15:33:50 +0100
Message-ID: <20201125153350.0af98d93@hemera>
References: <20201125123956.61d9e16a@hemera>
        <20201125133740.GE31550@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20201125133740.GE31550-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Michal,

On Wed, 25 Nov 2020 14:37:40 +0100 Michal Hocko <mhocko-IBi9RG/b67k@public.=
gmane.org> wrote:
> Hi,
> thanks for the detailed report.
>=20
> On Wed 25-11-20 12:39:56, Bruno Pr=C3=A9mont wrote:
> [...]
> > Did memory.low meaning change between 5.7 and 5.9? =20
>=20
> The latest semantic change in the low limit protection semantic was
> introduced in 5.7 (recursive protection) but it requires an explicit
> enablinig.

No specific mount options set for v2 cgroup, so not active.

> > From behavior it
> > feels as if inodes are not accounted to cgroup at all and kernel pushes
> > cgroups down to their memory.low by killing file cache if there is not
> > enough free memory to hold all promises (and not only when a cgroup
> > tries to use up to its promised amount of memory). =20
>=20
> Your counters indeed show that the low protection has been breached,
> most likely because the reclaim couldn't make any progress. Considering
> that this is the case for all/most of your cgroups it suggests that the
> memory pressure was global rather than limit imposed. In fact even top
> level cgroups got reclaimed below the low limit.

Note that the "original" counters we partially triggered by a first
event where I had one cgroup (websrv) of the with a rather very high
memory.low (16G or even 32G) which caused counters everywhere to
increase.


So before the last trashing during which the values were collected the
event counters and `current` looked as follows:

system/memory.pressure
  some avg10=3D0.04 avg60=3D0.28 avg300=3D0.12 total=3D5844917510
  full avg10=3D0.04 avg60=3D0.26 avg300=3D0.11 total=3D2439353404
system/memory.current
  96432128
system/memory.events.local
  low      5399469   (unchanged)
  high     0
  max      112303    (unchanged)
  oom      0
  oom_kill 0

system/base/memory.pressure
  some avg10=3D0.04 avg60=3D0.28 avg300=3D0.12 total=3D4589562039
  full avg10=3D0.04 avg60=3D0.28 avg300=3D0.12 total=3D1926984197
system/base/memory.current
  59305984
system/base/memory.events.local
  low      0   (unchanged)
  high     0
  max      0   (unchanged)
  oom      0
  oom_kill 0

system/backup/memory.pressure
  some avg10=3D0.00 avg60=3D0.00 avg300=3D0.00 total=3D2123293649
  full avg10=3D0.00 avg60=3D0.00 avg300=3D0.00 total=3D815450446
system/backup/memory.current
  32444416
system/backup/memory.events.local
  low      5446   (unchanged)
  high     0
  max      0
  oom      0
  oom_kill 0

system/shell/memory.pressure
  some avg10=3D0.00 avg60=3D0.00 avg300=3D0.00 total=3D1345965660
  full avg10=3D0.00 avg60=3D0.00 avg300=3D0.00 total=3D492812915
system/shell/memory.current
  4571136
system/shell/memory.events.local
  low      0
  high     0
  max      0
  oom      0
  oom_kill 0

website/memory.pressure
  some avg10=3D0.00 avg60=3D0.00 avg300=3D0.00 total=3D415008878
  full avg10=3D0.00 avg60=3D0.00 avg300=3D0.00 total=3D201868483
website/memory.current
  12104380416
website/memory.events.local
  low      11264569  (during trashing: 11372142 then 11377350)
  high     0
  max      0
  oom      0
  oom_kill 0

remote/memory.pressure
  some avg10=3D0.00 avg60=3D0.00 avg300=3D0.00 total=3D2005130126
  full avg10=3D0.00 avg60=3D0.00 avg300=3D0.00 total=3D735366752
remote/memory.current
  116330496
remote/memory.events.local
  low      11264569  (during trashing: 11372142 then 11377350)
  high     0
  max      0
  oom      0
  oom_kill 0

websrv/memory.pressure
  some avg10=3D0.02 avg60=3D0.11 avg300=3D0.03 total=3D6650355162
  full avg10=3D0.02 avg60=3D0.11 avg300=3D0.03 total=3D2034584579
websrv/memory.current
  18483359744
websrv/memory.events.local
  low      0
  high     0
  max      0
  oom      0
  oom_kill 0


> This suggests that this is not likely to be memcg specific. It is
> more likely that this is a general memory reclaim regression for your
> workload. There were larger changes in that area. Be it lru balancing
> based on cost model by Johannes or working set tracking for anonymous
> pages by Joonsoo. Maybe even more. Both of them can influence page cache
> reclaim but you are suggesting that slab accounted memory is not
> reclaimed properly.

That is my impression, yes. No idea though if memcg can influence the
way reclaim tries to perform its work or if slab_reclaimable not
associated to any (child) cg would somehow be excluded from reclaim.

> I am not sure sure there were considerable changes
> there. Would it be possible to collect /prov/vmstat as well?

I will have a look at gathering memory.stat and /proc/vmstat at next
opportunity.
Will first try with a test system with not too much memory and lots of
files to reproduce about 50% of memory usage by slab_reclaimable and
see how far I get.

Thanks,
Bruno
