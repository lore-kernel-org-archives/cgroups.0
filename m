From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 4/5] mm: rework non-root kmem_cache lifecycle management
Date: Thu, 18 Apr 2019 18:14:05 +0000
Message-ID: <20190418181400.GC11008@tower.DHCP.thefacebook.com>
References: <20190417215434.25897-1-guro@fb.com>
 <20190417215434.25897-5-guro@fb.com>
 <CALvZod5K8SM2EQFH1WM9bbwWBtyXWb_PvzJGvF5dg1Z=bdR7zg@mail.gmail.com>
 <20190418003850.GA13977@tower.DHCP.thefacebook.com>
 <CALvZod6UiTeN40RgpE-4zE5zagSifqh3o_AXaw8o-ubVUWf=4w@mail.gmail.com>
 <20190418030729.GA5038@castle>
 <CALvZod4K9HymKkG9hGoU-sFxZogqP+wrBRD9AighvfUzDGoTFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=DSUc3ZUilcXF9SyrLXYkcFIObP6rbmpcZ+nA23ILDqs=;
 b=S4iJSnj7v4nw51t41u2c6Sene2JN/34aQMO5Ss3kZK4gog3bVdWW4/7g9lrBQOvwmcce
 c0OX/nWyxrJUHs9auO5bxVKRBUaKwCxwu+VAG7o6yqut/z+z4dVZdEvVbnr/Rz4NJ9Fd
 X5UgtUC7cujdMSNxicZkIi500ng600Sc8NU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSUc3ZUilcXF9SyrLXYkcFIObP6rbmpcZ+nA23ILDqs=;
 b=PZXzz6WhfCMD6OW0ipbHlcfX+zlTHRvdrwTvcsDFAJUbhpRdnbn0MHv3YTqCImwtJvfgM3LlLj69GyFW7dqa/q3lk90cSQ0g2cMW5XedBJbKVoIB00m0Soh7aFc/N1UD9VHrjzyMl1h30BKLKQIFxyhs2Oy5W5c9ZPYAb1iMjJ8=
In-Reply-To: <CALvZod4K9HymKkG9hGoU-sFxZogqP+wrBRD9AighvfUzDGoTFQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <ADD4024971601F44BCA664623F115C4F@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guroan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, "david@fromorbit.com" <david@fromorbit.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>

On Thu, Apr 18, 2019 at 07:05:24AM -0700, Shakeel Butt wrote:
> On Wed, Apr 17, 2019 at 8:07 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Wed, Apr 17, 2019 at 06:55:12PM -0700, Shakeel Butt wrote:
> > > On Wed, Apr 17, 2019 at 5:39 PM Roman Gushchin <guro@fb.com> wrote:
> > > >
> > > > On Wed, Apr 17, 2019 at 04:41:01PM -0700, Shakeel Butt wrote:
> > > > > On Wed, Apr 17, 2019 at 2:55 PM Roman Gushchin <guroan@gmail.com>=
 wrote:
> > > > > >
> > > > > > This commit makes several important changes in the lifecycle
> > > > > > of a non-root kmem_cache, which also affect the lifecycle
> > > > > > of a memory cgroup.
> > > > > >
> > > > > > Currently each charged slab page has a page->mem_cgroup pointer
> > > > > > to the memory cgroup and holds a reference to it.
> > > > > > Kmem_caches are held by the cgroup. On offlining empty kmem_cac=
hes
> > > > > > are freed, all other are freed on cgroup release.
> > > > >
> > > > > No, they are not freed (i.e. destroyed) on offlining, only
> > > > > deactivated. All memcg kmem_caches are freed/destroyed on memcg's
> > > > > css_free.
> > > >
> > > > You're right, my bad. I was thinking about the corresponding sysfs =
entry
> > > > when was writing it. We try to free it from the deactivation path t=
oo.
> > > >
> > > > >
> > > > > >
> > > > > > So the current scheme can be illustrated as:
> > > > > > page->mem_cgroup->kmem_cache.
> > > > > >
> > > > > > To implement the slab memory reparenting we need to invert the =
scheme
> > > > > > into: page->kmem_cache->mem_cgroup.
> > > > > >
> > > > > > Let's make every page to hold a reference to the kmem_cache (we
> > > > > > already have a stable pointer), and make kmem_caches to hold a =
single
> > > > > > reference to the memory cgroup.
> > > > >
> > > > > What about memcg_kmem_get_cache()? That function assumes that by
> > > > > taking reference on memcg, it's kmem_caches will stay. I think yo=
u
> > > > > need to get reference on the kmem_cache in memcg_kmem_get_cache()
> > > > > within the rcu lock where you get the memcg through css_tryget_on=
line.
> > > >
> > > > Yeah, a very good question.
> > > >
> > > > I believe it's safe because css_tryget_online() guarantees that
> > > > the cgroup is online and won't go offline before css_free() in
> > > > slab_post_alloc_hook(). I do initialize kmem_cache's refcount to 1
> > > > and drop it on offlining, so it protects the online kmem_cache.
> > > >
> > >
> > > Let's suppose a thread doing a remote charging calls
> > > memcg_kmem_get_cache() and gets an empty kmem_cache of the remote
> > > memcg having refcnt equal to 1. That thread got a reference on the
> > > remote memcg but no reference on the kmem_cache. Let's suppose that
> > > thread got stuck in the reclaim and scheduled away. In the meantime
> > > that remote memcg got offlined and decremented the refcnt of all of
> > > its kmem_caches. The empty kmem_cache which the thread stuck in
> > > reclaim have pointer to can get deleted and may be using an already
> > > destroyed kmem_cache after coming back from reclaim.
> > >
> > > I think the above situation is possible unless the thread gets the
> > > reference on the kmem_cache in memcg_kmem_get_cache().
> >
> > Yes, you're right and I'm writing a nonsense: css_tryget_online()
> > can't prevent the cgroup from being offlined.
> >
>=20
> The reason I knew about that race is because I tried something similar
> but for different use-case:
>=20
> https://lkml.org/lkml/2018/3/26/472
>=20
> > So, the problem with getting a reference in memcg_kmem_get_cache()
> > is that it's an atomic operation on the hot path, something I'd like
> > to avoid.
> >
> > I can make the refcounter percpu, but it'll add some complexity and siz=
e
> > to the kmem_cache object. Still an option, of course.
> >
>=20
> I kind of prefer this option.
>=20
> > I wonder if we can use rcu_read_lock() instead, and bump the refcounter
> > only if we're going into reclaim.
> >
> > What do you think?
>=20
> Should it be just reclaim or anything that can reschedule the current thr=
ead?
>=20
> I can tell how we resolve the similar issue for our
> eager-kmem_cache-deletion use-case. Our solution (hack) works only for
> CONFIG_SLAB (we only use SLAB) and non-preemptible kernel. The
> underlying motivation was to reduce the overhead of slab reaper of
> traversing thousands of empty offlined kmem caches. CONFIG_SLAB
> disables interrupts before accessing the per-cpu caches and reenables
> the interrupts if it has to fallback to the page allocation. We use
> this window to call memcg_kmem_get_cache() and only increment the
> refcnt of kmem_cache if going to the fallback. Thus no need to do
> atomic operation on the hot path.
>=20
> Anyways, I think having percpu refcounter for each memcg kmem_cache is
> not that costy for CONFIG_MEMCG_KMEM users and to me that seems like
> the most simple solution.
>=20
> Shakeel

Ok, sounds like a percpu refcounter is the best option.
I'll try this approach in v2.

Thanks!
