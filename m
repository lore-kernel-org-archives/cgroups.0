From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: css_tryget_online cleanups
Date: Fri, 21 Feb 2020 17:49:37 -0800
Message-ID: <CALvZod5pAv=u8L2Tgk0hDY7XAiiF2dvjC1omQ5BSfzFu_2zSXA@mail.gmail.com>
References: <20200221195919.186576-1-shakeelb@google.com> <20200222011046.GB459391@carbon.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9RB5FaQbzQgbIL5nfWOlaYI9euOnM0n/xrO01cC3y4A=;
        b=YxwOEI3aPWiqbDzeypVY5RciIfiOmAgVFyUfidQdPNEy5hAeU3MlnuS2lvPsg8ZQQt
         32TeqEWSjAXgXzGwqYOhopacZHXWMkyaIr7PG4raOs9Igi6tjJMPuZJHtP9+e5bHTvZr
         akNuht7bh9C+DsU3ARsOhZR/zPYpTHAzFteAqblFeEciTjkN9zn/tTMDoZMOZXomimyN
         y2judLthdCsztfodgjm5kPbweqH3d0A9dNEFIFUYS5miqGt/oF4srFdf5FopXqPk6uQU
         fKjvOoMg2Yfzhqg0Uy/In1FqidDB6nO5RcNxOyS5HjUPGk1sN2QehJkSQ7oz6VO9nbpc
         WS2g==
In-Reply-To: <20200222011046.GB459391-lLJQVQxiE4uLfgCeKHXN1g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Feb 21, 2020 at 5:10 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
>
> On Fri, Feb 21, 2020 at 11:59:19AM -0800, Shakeel Butt wrote:
> > Currently multiple locations in memcg code, css_tryget_online() is being
> > used. However it doesn't matter whether the cgroup is online for the
> > callers. Online used to matter when we had reparenting on offlining and
> > we needed a way to prevent new ones from showing up.
> >
> > The failure case for couple of these css_tryget_online usage is to
> > fallback to root_mem_cgroup which kind of make bypassing the memcg
> > limits possible for some workloads. For example creating an inotify
> > group in a subcontainer and then deleting that container after moving the
> > process to a different container will make all the event objects
> > allocated for that group to the root_mem_cgroup. So, using
> > css_tryget_online() is dangerous for such cases.
> >
> > Two locations still use the online version. The swapin of offlined
> > memcg's pages and the memcg kmem cache creation. The kmem cache indeed
> > needs the online version as the kernel does the reparenting of memcg
> > kmem caches. For the swapin case, it has been left for later as the
> > fallback is not really that concerning.
> >
> > Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> Hello, Shakeel!
>
> > ---
> >  mm/memcontrol.c | 14 +++++++++-----
> >  1 file changed, 9 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 63bb6a2aab81..75fa8123909e 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -656,7 +656,7 @@ __mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
> >        */
> >       __mem_cgroup_remove_exceeded(mz, mctz);
> >       if (!soft_limit_excess(mz->memcg) ||
> > -         !css_tryget_online(&mz->memcg->css))
> > +         !css_tryget(&mz->memcg->css))
>
> Looks good.
>
> >               goto retry;
> >  done:
> >       return mz;
> > @@ -962,7 +962,8 @@ struct mem_cgroup *get_mem_cgroup_from_page(struct page *page)
> >               return NULL;
> >
> >       rcu_read_lock();
> > -     if (!memcg || !css_tryget_online(&memcg->css))
> > +     /* Page should not get uncharged and freed memcg under us. */
> > +     if (!memcg || WARN_ON(!css_tryget(&memcg->css)))
>
> I'm slightly worried about this WARN_ON().
> As I understand the idea is that the caller must own the page and make
> sure that page->memcg remains intact.

Yes you are correct.

> Do we really need this?

There are no current such users, maybe just the warning in the comment
is enough and use css_get(). I don't have any strong opinion. I will
at least convert the warning to once and wait for comments from
others.

>
> Also, I'd go with WARN_ON_ONCE() to limit the dmesg flow in the case
> if something will go wrong.
>
> >               memcg = root_mem_cgroup;
> >       rcu_read_unlock();
> >       return memcg;
> > @@ -975,10 +976,13 @@ EXPORT_SYMBOL(get_mem_cgroup_from_page);
> >  static __always_inline struct mem_cgroup *get_mem_cgroup_from_current(void)
> >  {
> >       if (unlikely(current->active_memcg)) {
> > -             struct mem_cgroup *memcg = root_mem_cgroup;
> > +             struct mem_cgroup *memcg;
> >
> >               rcu_read_lock();
> > -             if (css_tryget_online(&current->active_memcg->css))
> > +             /* current->active_memcg must hold a ref. */
>
> Hm, does it?
> memalloc_use_memcg() isn't touching the memcg's reference counter.
> And if it does hold a reference, why can't we just do css_get()?

The callers of the memalloc_use_memcg() should already have the refcnt
of the memcg elevated. I should add that to the comment description of
memalloc_use_memcg().

>
> > +             if (WARN_ON(!css_tryget(&current->active_memcg->css)))
> > +                     memcg = root_mem_cgroup;
>
> Btw, if css_tryget() fails here, what does it mean?
> I'd s/WARN_ON/WARN_ON_ONCE too.
>

If css_tryget() fails, it means someone is using memalloc_use_memcg()
without holding the reference to the memcg. Converting to once makes
sense.

> > +             else
> >                       memcg = current->active_memcg;
> >               rcu_read_unlock();
> >               return memcg;
> > @@ -6703,7 +6707,7 @@ void mem_cgroup_sk_alloc(struct sock *sk)
> >               goto out;
> >       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg->tcpmem_active)
> >               goto out;
> > -     if (css_tryget_online(&memcg->css))
> > +     if (css_tryget(&memcg->css))
>
> So it can be offline, right? Makes sense.
>

Actually we got the memcg from the current just few lines above within
rcu lock. memcg can not go offline here, right?

> >               sk->sk_memcg = memcg;
> >  out:
> >       rcu_read_unlock();
> > --
> > 2.25.0.265.gbab2e86ba0-goog
> >
>
> Overall I have to admit it all is quite tricky. I had a patchset doing
> a similar cleanup (but not only in the mm code), but dropped it after
> Tejun showed me some edge cases, when it would cause a regression.
>
> So I really think it's a valuable work, but we need to be careful here.
>

Totally agreed.

Shakeel
