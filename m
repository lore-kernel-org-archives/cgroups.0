From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 4/5] mm: rework non-root kmem_cache lifecycle management
Date: Thu, 18 Apr 2019 00:38:57 +0000
Message-ID: <20190418003850.GA13977@tower.DHCP.thefacebook.com>
References: <20190417215434.25897-1-guro@fb.com>
 <20190417215434.25897-5-guro@fb.com>
 <CALvZod5K8SM2EQFH1WM9bbwWBtyXWb_PvzJGvF5dg1Z=bdR7zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=GtgCHvQddxepzDm5CilE+VAum+QHU1xHkXGEwpuPmHo=;
 b=FW/JetfMvy6oE23quhvpPdBzWf3l3k1VoVn6e44DwXcJqI1umxU6gXFq3pdMU4AoVwMB
 eobzNHwIwq78PyZPoYIm5j7VSVZ5WTyVzrDik0vQFZbnYF1RH4MY2adkGrhc4vM/g4Sh
 rTdlTN+SjAsU3LcVA7RVQy4OJnKraUlSQD4= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GtgCHvQddxepzDm5CilE+VAum+QHU1xHkXGEwpuPmHo=;
 b=EWotGmswVEmaOZyw8UJ1/cSI7CCmHAczCBjrjdhp6c2ApxoDgrJYxAAh7NZswvFRb4uh/MCiCHYKjPfaiJgTfHqpt1IU0PoywRYPaCBwAETXxVgscmLxibNVMGOXb0ZevGv6dB+jEKpxlhuDyqMWaa7jGbJK3CILXAJIv0uaOXY=
In-Reply-To: <CALvZod5K8SM2EQFH1WM9bbwWBtyXWb_PvzJGvF5dg1Z=bdR7zg@mail.gmail.com>
Content-Language: en-US
Content-ID: <29E42D93509769408761DF124E08866C@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guroan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, "david@fromorbit.com" <david@fromorbit.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>

On Wed, Apr 17, 2019 at 04:41:01PM -0700, Shakeel Butt wrote:
> On Wed, Apr 17, 2019 at 2:55 PM Roman Gushchin <guroan@gmail.com> wrote:
> >
> > This commit makes several important changes in the lifecycle
> > of a non-root kmem_cache, which also affect the lifecycle
> > of a memory cgroup.
> >
> > Currently each charged slab page has a page->mem_cgroup pointer
> > to the memory cgroup and holds a reference to it.
> > Kmem_caches are held by the cgroup. On offlining empty kmem_caches
> > are freed, all other are freed on cgroup release.
>=20
> No, they are not freed (i.e. destroyed) on offlining, only
> deactivated. All memcg kmem_caches are freed/destroyed on memcg's
> css_free.

You're right, my bad. I was thinking about the corresponding sysfs entry
when was writing it. We try to free it from the deactivation path too.

>=20
> >
> > So the current scheme can be illustrated as:
> > page->mem_cgroup->kmem_cache.
> >
> > To implement the slab memory reparenting we need to invert the scheme
> > into: page->kmem_cache->mem_cgroup.
> >
> > Let's make every page to hold a reference to the kmem_cache (we
> > already have a stable pointer), and make kmem_caches to hold a single
> > reference to the memory cgroup.
>=20
> What about memcg_kmem_get_cache()? That function assumes that by
> taking reference on memcg, it's kmem_caches will stay. I think you
> need to get reference on the kmem_cache in memcg_kmem_get_cache()
> within the rcu lock where you get the memcg through css_tryget_online.

Yeah, a very good question.

I believe it's safe because css_tryget_online() guarantees that
the cgroup is online and won't go offline before css_free() in
slab_post_alloc_hook(). I do initialize kmem_cache's refcount to 1
and drop it on offlining, so it protects the online kmem_cache.

Thank you for looking into the patchset!
