From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v3 0/7] mm: reparent slab memory on cgroup removal
Date: Tue, 14 May 2019 20:04:07 +0000
Message-ID: <20190514200402.GE12629@tower.DHCP.thefacebook.com>
References: <20190508202458.550808-1-guro@fb.com>
 <CALvZod4WGVVq+UY_TZdKP_PHdifDrkYqPGgKYTeUB6DsxGAdVw@mail.gmail.com>
 <20190513202146.GA18451@tower.DHCP.thefacebook.com>
 <CALvZod4GscZjob8bfCcfhsMh0sco16r4yfOaRU69WnNO7MRrpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=XDYBZG8A2YAwR/soZSe1ByMG22/MIAVGPV0s6wx9Hhs=;
 b=Y8uBkIUFpcPveDqGTtJ0sObqL0awHr835TfVj95DuR8UW6HIyFY7U/oimLPxxm3aZih0
 U7NXaBScwd/p0BVuCV472Pd+Hk5YHjfcCykNsRFs/T6jrrQJLRLao2aS3zUibvy29t5g
 h3LNoRO4TbW0lzkM4d+X4nSPG7ZffayCHaI= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDYBZG8A2YAwR/soZSe1ByMG22/MIAVGPV0s6wx9Hhs=;
 b=NQH3+akos5tt/UBmphMosqnrG5Lg9d2amThk1QWrGj54XwmwC5pPt/LWoB1KMlYIKAzcPGVAkI6UXp6i7vxjDMubeEFa+XjQrwIIKkkSns6NjV/Q4tFulnk2c4xOEMa8RUrz0Es79qMUtdrVBczRuzl5RlgqNdsOqqeMp2BM9xI=
In-Reply-To: <CALvZod4GscZjob8bfCcfhsMh0sco16r4yfOaRU69WnNO7MRrpw@mail.gmail.com>
Content-Language: en-US
Content-ID: <78C6EF45B1ED7E4EA4926F9332690197@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>

On Tue, May 14, 2019 at 12:22:08PM -0700, Shakeel Butt wrote:
> From: Roman Gushchin <guro@fb.com>
> Date: Mon, May 13, 2019 at 1:22 PM
> To: Shakeel Butt
> Cc: Andrew Morton, Linux MM, LKML, Kernel Team, Johannes Weiner,
> Michal Hocko, Rik van Riel, Christoph Lameter, Vladimir Davydov,
> Cgroups
>=20
> > On Fri, May 10, 2019 at 05:32:15PM -0700, Shakeel Butt wrote:
> > > From: Roman Gushchin <guro@fb.com>
> > > Date: Wed, May 8, 2019 at 1:30 PM
> > > To: Andrew Morton, Shakeel Butt
> > > Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
> > > <kernel-team@fb.com>, Johannes Weiner, Michal Hocko, Rik van Riel,
> > > Christoph Lameter, Vladimir Davydov, <cgroups@vger.kernel.org>, Roman
> > > Gushchin
> > >
> > > > # Why do we need this?
> > > >
> > > > We've noticed that the number of dying cgroups is steadily growing =
on most
> > > > of our hosts in production. The following investigation revealed an=
 issue
> > > > in userspace memory reclaim code [1], accounting of kernel stacks [=
2],
> > > > and also the mainreason: slab objects.
> > > >
> > > > The underlying problem is quite simple: any page charged
> > > > to a cgroup holds a reference to it, so the cgroup can't be reclaim=
ed unless
> > > > all charged pages are gone. If a slab object is actively used by ot=
her cgroups,
> > > > it won't be reclaimed, and will prevent the origin cgroup from bein=
g reclaimed.
> > > >
> > > > Slab objects, and first of all vfs cache, is shared between cgroups=
, which are
> > > > using the same underlying fs, and what's even more important, it's =
shared
> > > > between multiple generations of the same workload. So if something =
is running
> > > > periodically every time in a new cgroup (like how systemd works), w=
e do
> > > > accumulate multiple dying cgroups.
> > > >
> > > > Strictly speaking pagecache isn't different here, but there is a ke=
y difference:
> > > > we disable protection and apply some extra pressure on LRUs of dyin=
g cgroups,
> > >
> > > How do you apply extra pressure on dying cgroups? cgroup-v2 does not
> > > have memory.force_empty.
> >
> > I mean the following part of get_scan_count():
> >         /*
> >          * If the cgroup's already been deleted, make sure to
> >          * scrape out the remaining cache.
> >          */
> >         if (!scan && !mem_cgroup_online(memcg))
> >                 scan =3D min(lruvec_size, SWAP_CLUSTER_MAX);
> >
> > It seems to work well, so that pagecache alone doesn't pin too many
> > dying cgroups. The price we're paying is some excessive IO here,
>=20
> Thanks for the explanation. However for this to work, something still
> needs to trigger the memory pressure until then we will keep the
> zombies around. BTW the get_scan_count() is getting really creepy. It
> needs a refactor soon.

Sure, but that's true for all sorts of memory.
Re get_scan_count(): for sure, yeah, it's way too hairy now.

>=20
> > which can be avoided had we be able to recharge the pagecache.
> >
>=20
> Are you looking into this? Do you envision a mount option which will
> tell the filesystem is shared and do recharging on the offlining of
> the origin memcg?

Not really working on it now, but thinking of what to do here long-term.
One of the ideas I have (just an idea for now) is to move memcg pointer
from individual pages to the inode level. It can bring more opportunities
in terms of recharging and reparenting, but I'm not sure how complex it is
and what are possible downsides.

Do you have any plans or ideas here?

>=20
> > Btw, thank you very much for looking into the patchset. I'll address
> > all comments and send v4 soon.
> >
>=20
> You are most welcome.

Thanks!
