From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v3 0/7] mm: reparent slab memory on cgroup removal
Date: Mon, 13 May 2019 20:21:52 +0000
Message-ID: <20190513202146.GA18451@tower.DHCP.thefacebook.com>
References: <20190508202458.550808-1-guro@fb.com>
 <CALvZod4WGVVq+UY_TZdKP_PHdifDrkYqPGgKYTeUB6DsxGAdVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=tsSq1++Ye+ueNW2uquEVLDQ0QUuST6HsPFGeUaz02Fg=;
 b=atNArPYwI7Qi502c3cGXbYPvLVXeNdJL+9LkN0rK40ahoP3DwgzLcYDXJBPX89rkSnJX
 w6GD8IIuhUjJx3u7QnxJYgwBfxMOrGvFharT7abTzC2dKOWHATqiTXHiDeeh0AQVS4NB
 j6+RI08hcEjh23kfDQNymk+JdnUuGVJYwTw= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tsSq1++Ye+ueNW2uquEVLDQ0QUuST6HsPFGeUaz02Fg=;
 b=e8kd77HTWO0U024kz84jEE4mhV9DedZ3159BoIWOcoQq+3LIxnmIPT2ZoJ8v+/ypQtlcd/COFOWMyhDs38MzgZe1HCkouEmcsvFS97P3Gpwwjbp876zz7w/OXnILT/oS1sPyDV0x9hE3gfcCiBv4hI1dc+VLHWy5j995WFdZrlU=
In-Reply-To: <CALvZod4WGVVq+UY_TZdKP_PHdifDrkYqPGgKYTeUB6DsxGAdVw@mail.gmail.com>
Content-Language: en-US
Content-ID: <166DA22C09B836488E8671DA1192C6A8@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>

On Fri, May 10, 2019 at 05:32:15PM -0700, Shakeel Butt wrote:
> From: Roman Gushchin <guro@fb.com>
> Date: Wed, May 8, 2019 at 1:30 PM
> To: Andrew Morton, Shakeel Butt
> Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
> <kernel-team@fb.com>, Johannes Weiner, Michal Hocko, Rik van Riel,
> Christoph Lameter, Vladimir Davydov, <cgroups@vger.kernel.org>, Roman
> Gushchin
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
>=20
> How do you apply extra pressure on dying cgroups? cgroup-v2 does not
> have memory.force_empty.

I mean the following part of get_scan_count():
	/*
	 * If the cgroup's already been deleted, make sure to
	 * scrape out the remaining cache.
	 */
	if (!scan && !mem_cgroup_online(memcg))
		scan =3D min(lruvec_size, SWAP_CLUSTER_MAX);

It seems to work well, so that pagecache alone doesn't pin too many
dying cgroups. The price we're paying is some excessive IO here,
which can be avoided had we be able to recharge the pagecache.


Btw, thank you very much for looking into the patchset. I'll address
all comments and send v4 soon.

Thanks!

Roman
