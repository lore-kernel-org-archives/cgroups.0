From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v5 0/7] mm: reparent slab memory on cgroup removal
Date: Wed, 22 May 2019 21:43:54 +0000
Message-ID: <20190522214347.GA10082@tower.DHCP.thefacebook.com>
References: <20190521200735.2603003-1-guro@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=CVBt7BPNswQzm1QWI5odkco7icjFSz99iGBFJfOMJQA=;
 b=b1KQ6zvJd/xPhumJ6qChso9eTSMzXaX0pe1ZeVasAtdQygLY/E+cYhAnD+dsC2oGQJE3
 Wsp8r9P/tu0/DQT9tW+NJw/0hCePmRwLpdyEVOyeGf53Mvz1DWn9/u+EWr6R1t/CE7kd
 fG5Ouwu8z4zgh+pHYLgy1IYoWu5PjABBXzA= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVBt7BPNswQzm1QWI5odkco7icjFSz99iGBFJfOMJQA=;
 b=lPRSEyRg4tPgG8O0DHIfFcEAQUHyDjDmcf6ezrL4pX7pH6C0zXEAwSSBJ2aOXg1eSmPqKceyVueee9HMN+VyEb1qgF8uEkToesbLVt4gE8dLmMEFt+FYgMDJ0INtrUUWAqTM4zceSITf2VuKlReeLhfUhwzyGAGhgY8Xz2R7RFM=
In-Reply-To: <20190521200735.2603003-1-guro@fb.com>
Content-Language: en-US
Content-ID: <F6381D1F9E5B2945A5A46313F2B8DFE9@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Waiman Long <longman@redhat.com>

Hi, Andrew!

Is this patchset good to go? Or do you have any remaining concerns?

It has been carefully reviewed by Shakeel; and also Christoph and Waiman
gave some attention to it.

Since commit 172b06c32b94 ("mm: slowly shrink slabs with a relatively")
has been reverted, the memcg "leak" problem is open again, and I've heard
from several independent people and companies that it's a real problem
for them. So it will be nice to close it asap.

I suspect that the fix is too heavy for stable, unfortunately.

Please, let me know if you have any issues that preventing you
from pulling it into the tree.

Thank you!

On Tue, May 21, 2019 at 01:07:28PM -0700, Roman Gushchin wrote:
> # Why do we need this?
>=20
> We've noticed that the number of dying cgroups is steadily growing on mos=
t
> of our hosts in production. The following investigation revealed an issue
> in userspace memory reclaim code [1], accounting of kernel stacks [2],
> and also the mainreason: slab objects.
>=20
> The underlying problem is quite simple: any page charged
> to a cgroup holds a reference to it, so the cgroup can't be reclaimed unl=
ess
> all charged pages are gone. If a slab object is actively used by other cg=
roups,
> it won't be reclaimed, and will prevent the origin cgroup from being recl=
aimed.
>=20
> Slab objects, and first of all vfs cache, is shared between cgroups, whic=
h are
> using the same underlying fs, and what's even more important, it's shared
> between multiple generations of the same workload. So if something is run=
ning
> periodically every time in a new cgroup (like how systemd works), we do
> accumulate multiple dying cgroups.
>=20
> Strictly speaking pagecache isn't different here, but there is a key diff=
erence:
> we disable protection and apply some extra pressure on LRUs of dying cgro=
ups,
> and these LRUs contain all charged pages.
> My experiments show that with the disabled kernel memory accounting the n=
umber
> of dying cgroups stabilizes at a relatively small number (~100, depends o=
n
> memory pressure and cgroup creation rate), and with kernel memory account=
ing
> it grows pretty steadily up to several thousands.
>=20
> Memory cgroups are quite complex and big objects (mostly due to percpu st=
ats),
> so it leads to noticeable memory losses. Memory occupied by dying cgroups
> is measured in hundreds of megabytes. I've even seen a host with more tha=
n 100Gb
> of memory wasted for dying cgroups. It leads to a degradation of performa=
nce
> with the uptime, and generally limits the usage of cgroups.
>=20
> My previous attempt [3] to fix the problem by applying extra pressure on =
slab
> shrinker lists caused a regressions with xfs and ext4, and has been rever=
ted [4].
> The following attempts to find the right balance [5, 6] were not successf=
ul.
>=20
> So instead of trying to find a maybe non-existing balance, let's do repar=
ent
> the accounted slabs to the parent cgroup on cgroup removal.
>=20
>=20
> # Implementation approach
>=20
> There is however a significant problem with reparenting of slab memory:
> there is no list of charged pages. Some of them are in shrinker lists,
> but not all. Introducing of a new list is really not an option.
>=20
> But fortunately there is a way forward: every slab page has a stable poin=
ter
> to the corresponding kmem_cache. So the idea is to reparent kmem_caches
> instead of slab pages.
>=20
> It's actually simpler and cheaper, but requires some underlying changes:
> 1) Make kmem_caches to hold a single reference to the memory cgroup,
>    instead of a separate reference per every slab page.
> 2) Stop setting page->mem_cgroup pointer for memcg slab pages and use
>    page->kmem_cache->memcg indirection instead. It's used only on
>    slab page release, so it shouldn't be a big issue.
> 3) Introduce a refcounter for non-root slab caches. It's required to
>    be able to destroy kmem_caches when they become empty and release
>    the associated memory cgroup.
>=20
> There is a bonus: currently we do release empty kmem_caches on cgroup
> removal, however all other are waiting for the releasing of the memory cg=
roup.
> These refactorings allow kmem_caches to be released as soon as they
> become inactive and free.
>=20
> Some additional implementation details are provided in corresponding
> commit messages.
>=20
>=20
> # Results
>=20
> Below is the average number of dying cgroups on two groups of our product=
ion
> hosts. They do run some sort of web frontend workload, the memory pressur=
e
> is moderate. As we can see, with the kernel memory reparenting the number
> stabilizes in 60s range; however with the original version it grows almos=
t
> linearly and doesn't show any signs of plateauing. The difference in slab
> and percpu usage between patched and unpatched versions also grows linear=
ly.
> In 7 days it exceeded 200Mb.
>=20
> day           0    1    2    3    4    5    6    7
> original     56  362  628  752 1070 1250 1490 1560
> patched      23   46   51   55   60   57   67   69
> mem diff(Mb) 22   74  123  152  164  182  214  241
>=20
>=20
> # History
>=20
> v5:
>   1) fixed a compilation warning around missing kmemcg_queue_cache_shutdo=
wn()
>   2) s/rcu_read_lock()/rcu_read_unlock() in memcg_kmem_get_cache()
>=20
> v4:
>   1) removed excessive memcg !=3D parent check in memcg_deactivate_kmem_c=
aches()
>   2) fixed rcu_read_lock() usage in memcg_charge_slab()
>   3) fixed synchronization around dying flag in kmemcg_queue_cache_shutdo=
wn()
>   4) refreshed test results data
>   5) reworked PageTail() checks in memcg_from_slab_page()
>   6) added some comments in multiple places
>=20
> v3:
>   1) reworked memcg kmem_cache search on allocation path
>   2) fixed /proc/kpagecgroup interface
>=20
> v2:
>   1) switched to percpu kmem_cache refcounter
>   2) a reference to kmem_cache is held during the allocation
>   3) slabs stats are fixed for !MEMCG case (and the refactoring
>      is separated into a standalone patch)
>   4) kmem_cache reparenting is performed from deactivatation context
>=20
> v1:
>   https://lkml.org/lkml/2019/4/17/1095
>=20
>=20
> # Links
>=20
> [1]: commit 68600f623d69 ("mm: don't miss the last page because of
> round-off error")
> [2]: commit 9b6f7e163cd0 ("mm: rework memcg kernel stack accounting")
> [3]: commit 172b06c32b94 ("mm: slowly shrink slabs with a relatively
> small number of objects")
> [4]: commit a9a238e83fbb ("Revert "mm: slowly shrink slabs
> with a relatively small number of objects")
> [5]: https://lkml.org/lkml/2019/1/28/1865
> [6]: https://marc.info/?l=3Dlinux-mm&m=3D155064763626437&w=3D2
>=20
>=20
> Roman Gushchin (7):
>   mm: postpone kmem_cache memcg pointer initialization to
>     memcg_link_cache()
>   mm: generalize postponed non-root kmem_cache deactivation
>   mm: introduce __memcg_kmem_uncharge_memcg()
>   mm: unify SLAB and SLUB page accounting
>   mm: rework non-root kmem_cache lifecycle management
>   mm: reparent slab memory on cgroup removal
>   mm: fix /proc/kpagecgroup interface for slab pages
>=20
>  include/linux/memcontrol.h |  10 +++
>  include/linux/slab.h       |  13 +--
>  mm/memcontrol.c            | 101 ++++++++++++++++-------
>  mm/slab.c                  |  25 ++----
>  mm/slab.h                  | 137 ++++++++++++++++++++++++-------
>  mm/slab_common.c           | 162 +++++++++++++++++++++----------------
>  mm/slub.c                  |  36 ++-------
>  7 files changed, 299 insertions(+), 185 deletions(-)
>=20
> --=20
> 2.20.1
>=20
