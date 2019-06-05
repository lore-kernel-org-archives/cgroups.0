From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v4 0/7] mm: reparent slab memory on cgroup removal
Date: Wed, 5 Jun 2019 17:33:00 +0000
Message-ID: <20190605173256.GB10098@tower.DHCP.thefacebook.com>
References: <20190514213940.2405198-1-guro@fb.com>
 <xr93ef48v5ub.fsf@gthelen.svl.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=NQd/ZrI7OHysa9+zywBc0NoPVivbuTiA3s8wT2Jxq4Y=;
 b=kto5V4C/V0elVdD6dHMAsm4VhDwt1TTtQhq/8JrkNr241iFgZXjd3ETWvpyrON+dCvOK
 MJOsoQNi32z3FiPzEK9Fb2kZMPtcVNw76Iqsq62yCdxms0uMPhyNfdgjB8J0LUpiZBBx
 pcHPF65WKmJoKx05ersvDvWp0Ak3Hi/etZA= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NQd/ZrI7OHysa9+zywBc0NoPVivbuTiA3s8wT2Jxq4Y=;
 b=trQfGH8YOa4LmX/6mzBHPf+6imT05ZbzrLQ2ldxSP+NEK/17MfHSZ8Kv9Mc7Lo8NzUmd2Qhz+ESIclMPUGXp3qqj2UNyExZyCvNb5zfoOhd4OPW/5CMzczVU9DETQFoS+0YVssjlYeW0O8uCzrMlIhJivWu1caRRTv19aEZ63fg=
In-Reply-To: <xr93ef48v5ub.fsf@gthelen.svl.corp.google.com>
Content-Language: en-US
Content-ID: <4827968C6C11134CB78F7FF0C1B2FBD3@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>

On Wed, Jun 05, 2019 at 12:39:24AM -0700, Greg Thelen wrote:
> Roman Gushchin <guro@fb.com> wrote:
>=20
> > # Why do we need this?
> >
> > We've noticed that the number of dying cgroups is steadily growing on m=
ost
> > of our hosts in production. The following investigation revealed an iss=
ue
> > in userspace memory reclaim code [1], accounting of kernel stacks [2],
> > and also the mainreason: slab objects.
> >
> > The underlying problem is quite simple: any page charged
> > to a cgroup holds a reference to it, so the cgroup can't be reclaimed u=
nless
> > all charged pages are gone. If a slab object is actively used by other =
cgroups,
> > it won't be reclaimed, and will prevent the origin cgroup from being re=
claimed.
> >
> > Slab objects, and first of all vfs cache, is shared between cgroups, wh=
ich are
> > using the same underlying fs, and what's even more important, it's shar=
ed
> > between multiple generations of the same workload. So if something is r=
unning
> > periodically every time in a new cgroup (like how systemd works), we do
> > accumulate multiple dying cgroups.
> >
> > Strictly speaking pagecache isn't different here, but there is a key di=
fference:
> > we disable protection and apply some extra pressure on LRUs of dying cg=
roups,
> > and these LRUs contain all charged pages.
> > My experiments show that with the disabled kernel memory accounting the=
 number
> > of dying cgroups stabilizes at a relatively small number (~100, depends=
 on
> > memory pressure and cgroup creation rate), and with kernel memory accou=
nting
> > it grows pretty steadily up to several thousands.
> >
> > Memory cgroups are quite complex and big objects (mostly due to percpu =
stats),
> > so it leads to noticeable memory losses. Memory occupied by dying cgrou=
ps
> > is measured in hundreds of megabytes. I've even seen a host with more t=
han 100Gb
> > of memory wasted for dying cgroups. It leads to a degradation of perfor=
mance
> > with the uptime, and generally limits the usage of cgroups.
> >
> > My previous attempt [3] to fix the problem by applying extra pressure o=
n slab
> > shrinker lists caused a regressions with xfs and ext4, and has been rev=
erted [4].
> > The following attempts to find the right balance [5, 6] were not succes=
sful.
> >
> > So instead of trying to find a maybe non-existing balance, let's do rep=
arent
> > the accounted slabs to the parent cgroup on cgroup removal.
> >
> >
> > # Implementation approach
> >
> > There is however a significant problem with reparenting of slab memory:
> > there is no list of charged pages. Some of them are in shrinker lists,
> > but not all. Introducing of a new list is really not an option.
> >
> > But fortunately there is a way forward: every slab page has a stable po=
inter
> > to the corresponding kmem_cache. So the idea is to reparent kmem_caches
> > instead of slab pages.
> >
> > It's actually simpler and cheaper, but requires some underlying changes=
:
> > 1) Make kmem_caches to hold a single reference to the memory cgroup,
> >    instead of a separate reference per every slab page.
> > 2) Stop setting page->mem_cgroup pointer for memcg slab pages and use
> >    page->kmem_cache->memcg indirection instead. It's used only on
> >    slab page release, so it shouldn't be a big issue.
> > 3) Introduce a refcounter for non-root slab caches. It's required to
> >    be able to destroy kmem_caches when they become empty and release
> >    the associated memory cgroup.
> >
> > There is a bonus: currently we do release empty kmem_caches on cgroup
> > removal, however all other are waiting for the releasing of the memory =
cgroup.
> > These refactorings allow kmem_caches to be released as soon as they
> > become inactive and free.
> >
> > Some additional implementation details are provided in corresponding
> > commit messages.
> >
> > # Results
> >
> > Below is the average number of dying cgroups on two groups of our produ=
ction
> > hosts. They do run some sort of web frontend workload, the memory press=
ure
> > is moderate. As we can see, with the kernel memory reparenting the numb=
er
> > stabilizes in 60s range; however with the original version it grows alm=
ost
> > linearly and doesn't show any signs of plateauing. The difference in sl=
ab
> > and percpu usage between patched and unpatched versions also grows line=
arly.
> > In 7 days it exceeded 200Mb.
> >
> > day           0    1    2    3    4    5    6    7
> > original     56  362  628  752 1070 1250 1490 1560
> > patched      23   46   51   55   60   57   67   69
> > mem diff(Mb) 22   74  123  152  164  182  214  241
>=20
> No objection to the idea, but a question...

Hi Greg!

> In patched kernel, does slabinfo (or similar) show the list reparented
> slab caches?  A pile of zombie kmem_caches is certainly better than a
> pile of zombie mem_cgroup.  But it still seems like it'll might cause
> degradation - does cache_reap() walk an ever growing set of zombie
> caches?

It's not a pile of zombie kmem_caches vs a pile of zombie mem_cgroups.
It's a smaller pile of zombie kmem_caches vs a larger pile of zombie kmem_c=
aches
*and* a pile of zombie mem_cgroups. The patchset makes the number of zombie
kmem_caches lower, not bigger.

Re slabinfo and other debug interfaces: I do not change anything here.

>=20
> We've found it useful to add a slabinfo_full file which includes zombie
> kmem_cache with their memcg_name.  This can help hunt down zombies.

I'm not sure we need to add a permanent debug interface, because something =
like
drgn ( https://github.com/osandov/drgn ) can be used instead.

If you think that we lack some necessary debug interfaces, I'm totally open
here, but it's not a part of this patchset. Let's talk about them separatel=
y.

Thank you for looking into it!

Roman
