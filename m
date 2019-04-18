From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 4/5] mm: rework non-root kmem_cache lifecycle management
Date: Thu, 18 Apr 2019 03:07:37 +0000
Message-ID: <20190418030729.GA5038@castle>
References: <20190417215434.25897-1-guro@fb.com>
 <20190417215434.25897-5-guro@fb.com>
 <CALvZod5K8SM2EQFH1WM9bbwWBtyXWb_PvzJGvF5dg1Z=bdR7zg@mail.gmail.com>
 <20190418003850.GA13977@tower.DHCP.thefacebook.com>
 <CALvZod6UiTeN40RgpE-4zE5zagSifqh3o_AXaw8o-ubVUWf=4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Z2dJelOQ0yl/7TG6RhC7wYBCcKk0cxBJ3I7/DHMqBN4=;
 b=D8ZKOD/Ihzyye6iV/EbZGj495tOCgRifPz41G+rx2tGqLvZ0zSAzFx5sMGmX6bqLXE2z
 SfFsGZWNSRelafkUPT+1rZeox0HmK9F9vCF3xxnlPspLknalz9GjFo2MunEcBXOkoj32
 z/Qy5usbs1SqLZP02CA97sEdJWJ5pDKCiOw= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2dJelOQ0yl/7TG6RhC7wYBCcKk0cxBJ3I7/DHMqBN4=;
 b=XkNACIXA9ktp4uZ/hi3GBQcWnc49gLlB5iH9DRdfGGvhW9Tb1MfrfIEQPw5WB7ZLZC0HUpOh/eU5vCwL69jrN9NHAmpmCQAKA99Ny8UD0H++Rg4GT/1HCKKNlEsa2R8BqdmU5Gi05no4GqWz5M4ATkukbjcwcp7/EanUMCQ6RkE=
In-Reply-To: <CALvZod6UiTeN40RgpE-4zE5zagSifqh3o_AXaw8o-ubVUWf=4w@mail.gmail.com>
Content-Language: en-US
Content-ID: <247B59BC911AF840B54250803B8E442F@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guroan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, "david@fromorbit.com" <david@fromorbit.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>

On Wed, Apr 17, 2019 at 06:55:12PM -0700, Shakeel Butt wrote:
> On Wed, Apr 17, 2019 at 5:39 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Wed, Apr 17, 2019 at 04:41:01PM -0700, Shakeel Butt wrote:
> > > On Wed, Apr 17, 2019 at 2:55 PM Roman Gushchin <guroan@gmail.com> wro=
te:
> > > >
> > > > This commit makes several important changes in the lifecycle
> > > > of a non-root kmem_cache, which also affect the lifecycle
> > > > of a memory cgroup.
> > > >
> > > > Currently each charged slab page has a page->mem_cgroup pointer
> > > > to the memory cgroup and holds a reference to it.
> > > > Kmem_caches are held by the cgroup. On offlining empty kmem_caches
> > > > are freed, all other are freed on cgroup release.
> > >
> > > No, they are not freed (i.e. destroyed) on offlining, only
> > > deactivated. All memcg kmem_caches are freed/destroyed on memcg's
> > > css_free.
> >
> > You're right, my bad. I was thinking about the corresponding sysfs entr=
y
> > when was writing it. We try to free it from the deactivation path too.
> >
> > >
> > > >
> > > > So the current scheme can be illustrated as:
> > > > page->mem_cgroup->kmem_cache.
> > > >
> > > > To implement the slab memory reparenting we need to invert the sche=
me
> > > > into: page->kmem_cache->mem_cgroup.
> > > >
> > > > Let's make every page to hold a reference to the kmem_cache (we
> > > > already have a stable pointer), and make kmem_caches to hold a sing=
le
> > > > reference to the memory cgroup.
> > >
> > > What about memcg_kmem_get_cache()? That function assumes that by
> > > taking reference on memcg, it's kmem_caches will stay. I think you
> > > need to get reference on the kmem_cache in memcg_kmem_get_cache()
> > > within the rcu lock where you get the memcg through css_tryget_online=
.
> >
> > Yeah, a very good question.
> >
> > I believe it's safe because css_tryget_online() guarantees that
> > the cgroup is online and won't go offline before css_free() in
> > slab_post_alloc_hook(). I do initialize kmem_cache's refcount to 1
> > and drop it on offlining, so it protects the online kmem_cache.
> >
>=20
> Let's suppose a thread doing a remote charging calls
> memcg_kmem_get_cache() and gets an empty kmem_cache of the remote
> memcg having refcnt equal to 1. That thread got a reference on the
> remote memcg but no reference on the kmem_cache. Let's suppose that
> thread got stuck in the reclaim and scheduled away. In the meantime
> that remote memcg got offlined and decremented the refcnt of all of
> its kmem_caches. The empty kmem_cache which the thread stuck in
> reclaim have pointer to can get deleted and may be using an already
> destroyed kmem_cache after coming back from reclaim.
>=20
> I think the above situation is possible unless the thread gets the
> reference on the kmem_cache in memcg_kmem_get_cache().

Yes, you're right and I'm writing a nonsense: css_tryget_online()
can't prevent the cgroup from being offlined.

So, the problem with getting a reference in memcg_kmem_get_cache()
is that it's an atomic operation on the hot path, something I'd like
to avoid.

I can make the refcounter percpu, but it'll add some complexity and size
to the kmem_cache object. Still an option, of course.

I wonder if we can use rcu_read_lock() instead, and bump the refcounter
only if we're going into reclaim.

What do you think?

Thanks!
