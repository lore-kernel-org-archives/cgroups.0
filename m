From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 4/5] mm: rework non-root kmem_cache lifecycle management
Date: Wed, 17 Apr 2019 18:55:12 -0700
Message-ID: <CALvZod6UiTeN40RgpE-4zE5zagSifqh3o_AXaw8o-ubVUWf=4w@mail.gmail.com>
References: <20190417215434.25897-1-guro@fb.com> <20190417215434.25897-5-guro@fb.com>
 <CALvZod5K8SM2EQFH1WM9bbwWBtyXWb_PvzJGvF5dg1Z=bdR7zg@mail.gmail.com> <20190418003850.GA13977@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KCQ+0ux3f2lhz2JQz+sODUn7gTy6oTF+cvFWZuiFK1k=;
        b=lWEA3zXd1uUNwv1sfs/UBAcFEGV7gzD1mipY5IZjzjsWevuBoSGre2ffvv0LXhiX4/
         il0RgAxHngPy2TypBkVVpVhebvUuicEOsLe69KHZgTg2Zena0Fg5SHPJGeGcJUlix0KX
         weKb4jER8526L50m+2MUd9bNeIw/1seMQ5k/0Z9qBKWVfB5W7YQF7LwAeFzykqOcPsyl
         2EEp3IbR6TfHeeiJW5IAuOiQa+KVTjR9+cqCX6OraglnF6lFsaoXFgMyDt6OtNR3uKYk
         0WCmXgoVwQMwrGnETEOjRHfIB7v11L7+Pesh8yrqNVI1oU/z4JfX2WzzMZLRH801nTP+
         3YwQ==
In-Reply-To: <20190418003850.GA13977@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <guroan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, "david@fromorbit.com" <david@fromorbit.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>

On Wed, Apr 17, 2019 at 5:39 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Wed, Apr 17, 2019 at 04:41:01PM -0700, Shakeel Butt wrote:
> > On Wed, Apr 17, 2019 at 2:55 PM Roman Gushchin <guroan@gmail.com> wrote:
> > >
> > > This commit makes several important changes in the lifecycle
> > > of a non-root kmem_cache, which also affect the lifecycle
> > > of a memory cgroup.
> > >
> > > Currently each charged slab page has a page->mem_cgroup pointer
> > > to the memory cgroup and holds a reference to it.
> > > Kmem_caches are held by the cgroup. On offlining empty kmem_caches
> > > are freed, all other are freed on cgroup release.
> >
> > No, they are not freed (i.e. destroyed) on offlining, only
> > deactivated. All memcg kmem_caches are freed/destroyed on memcg's
> > css_free.
>
> You're right, my bad. I was thinking about the corresponding sysfs entry
> when was writing it. We try to free it from the deactivation path too.
>
> >
> > >
> > > So the current scheme can be illustrated as:
> > > page->mem_cgroup->kmem_cache.
> > >
> > > To implement the slab memory reparenting we need to invert the scheme
> > > into: page->kmem_cache->mem_cgroup.
> > >
> > > Let's make every page to hold a reference to the kmem_cache (we
> > > already have a stable pointer), and make kmem_caches to hold a single
> > > reference to the memory cgroup.
> >
> > What about memcg_kmem_get_cache()? That function assumes that by
> > taking reference on memcg, it's kmem_caches will stay. I think you
> > need to get reference on the kmem_cache in memcg_kmem_get_cache()
> > within the rcu lock where you get the memcg through css_tryget_online.
>
> Yeah, a very good question.
>
> I believe it's safe because css_tryget_online() guarantees that
> the cgroup is online and won't go offline before css_free() in
> slab_post_alloc_hook(). I do initialize kmem_cache's refcount to 1
> and drop it on offlining, so it protects the online kmem_cache.
>

Let's suppose a thread doing a remote charging calls
memcg_kmem_get_cache() and gets an empty kmem_cache of the remote
memcg having refcnt equal to 1. That thread got a reference on the
remote memcg but no reference on the kmem_cache. Let's suppose that
thread got stuck in the reclaim and scheduled away. In the meantime
that remote memcg got offlined and decremented the refcnt of all of
its kmem_caches. The empty kmem_cache which the thread stuck in
reclaim have pointer to can get deleted and may be using an already
destroyed kmem_cache after coming back from reclaim.

I think the above situation is possible unless the thread gets the
reference on the kmem_cache in memcg_kmem_get_cache().

Shakeel
