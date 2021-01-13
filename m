From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] mm: net: memcg accounting for TCP rx zerocopy
Date: Wed, 13 Jan 2021 10:47:53 -0800
Message-ID: <20210113184753.GB355124@carbon.dhcp.thefacebook.com>
References: <20210112214105.1440932-1-shakeelb@google.com>
 <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
 <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com>
 <20210112234822.GA134064@carbon.dhcp.thefacebook.com>
 <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=gulwjmtfgPvzvG+CYkimturzVYttqGxf4st4wHxiViM=;
 b=lVwQD0RL31fEbDkOy97ruT8/aGOFrRldSJwHVWMEj+fx8e+QK5wnD7rQQ3HNtEDRqlr9
 R3Hel8e+VOSKvb0dQ46vbEpX1S4j3apQ4Y8a3M2qQ2rFVwSeSNAtGet4Fekn7hCvFNnZ
 fEf31OZpIbZvzi84haR8hankF0biK1LR8eg= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gulwjmtfgPvzvG+CYkimturzVYttqGxf4st4wHxiViM=;
 b=kneNKI5UHYK6MC+P1n7MTeqJI3R1schBSOgWtO6Xf6XtsjBp3OIpNz9Va6hKzOHB0mP0+pdqii8YAQXskzhFm9XCusYkRdDxy2FK/NuwQEy79vhsk0LPdepUI4IJ6IUl7Dl9ds+pmngv4voRcYS9dYoXQLhBeI/B/iC8M2yR21E=
Content-Disposition: inline
In-Reply-To: <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jan 12, 2021 at 04:12:08PM -0800, Arjun Roy wrote:
> On Tue, Jan 12, 2021 at 3:48 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> >
> > On Tue, Jan 12, 2021 at 03:36:18PM -0800, Arjun Roy wrote:
> > > On Tue, Jan 12, 2021 at 3:31 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> > > >
> > > > On Tue, Jan 12, 2021 at 01:41:05PM -0800, Shakeel Butt wrote:
> > > > > From: Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > >
> > > > > TCP zerocopy receive is used by high performance network applications to
> > > > > further scale. For RX zerocopy, the memory containing the network data
> > > > > filled by network driver is directly mapped into the address space of
> > > > > high performance applications. To keep the TLB cost low, these
> > > > > applications unmaps the network memory in big batches. So, this memory
> > > > > can remain mapped for long time. This can cause memory isolation issue
> > > > > as this memory becomes unaccounted after getting mapped into the
> > > > > application address space. This patch adds the memcg accounting for such
> > > > > memory.
> > > > >
> > > > > Accounting the network memory comes with its own unique challenge. The
> > > > > high performance NIC drivers use page pooling to reuse the pages to
> > > > > eliminate/reduce the expensive setup steps like IOMMU. These drivers
> > > > > keep an extra reference on the pages and thus we can not depends on the
> > > > > page reference for the uncharging. The page in the pool may keep a memcg
> > > > > pinned for arbitrary long time or may get used by other memcg.
> > > > >
> > > > > This patch decouples the uncharging of the page from the refcnt and
> > > > > associate it with the map count i.e. the page gets uncharged when the
> > > > > last address space unmaps it. Now the question what if the driver drops
> > > > > its reference while the page is still mapped. That is fine as the
> > > > > address space also holds a reference to the page i.e. the reference
> > > > > count can not drop to zero before the map count.
> > > > >
> > > > > Signed-off-by: Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > > Co-developed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > > Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > > ---
> > > > >  include/linux/memcontrol.h | 34 +++++++++++++++++++--
> > > > >  mm/memcontrol.c            | 60 ++++++++++++++++++++++++++++++++++++++
> > > > >  mm/rmap.c                  |  3 ++
> > > > >  net/ipv4/tcp.c             | 27 +++++++++++++----
> > > > >  4 files changed, 116 insertions(+), 8 deletions(-)
> > > > >
> > > > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > > > index 7a38a1517a05..0b0e3b4615cf 100644
> > > > > --- a/include/linux/memcontrol.h
> > > > > +++ b/include/linux/memcontrol.h
> > > > > @@ -349,11 +349,13 @@ extern struct mem_cgroup *root_mem_cgroup;
> > > > >
> > > > >  enum page_memcg_data_flags {
> > > > >       /* page->memcg_data is a pointer to an objcgs vector */
> > > > > -     MEMCG_DATA_OBJCGS = (1UL << 0),
> > > > > +     MEMCG_DATA_OBJCGS       = (1UL << 0),
> > > > >       /* page has been accounted as a non-slab kernel page */
> > > > > -     MEMCG_DATA_KMEM = (1UL << 1),
> > > > > +     MEMCG_DATA_KMEM         = (1UL << 1),
> > > > > +     /* page has been accounted as network memory */
> > > > > +     MEMCG_DATA_SOCK         = (1UL << 2),
> > > > >       /* the next bit after the last actual flag */
> > > > > -     __NR_MEMCG_DATA_FLAGS  = (1UL << 2),
> > > > > +     __NR_MEMCG_DATA_FLAGS   = (1UL << 3),
> > > > >  };
> > > > >
> > > > >  #define MEMCG_DATA_FLAGS_MASK (__NR_MEMCG_DATA_FLAGS - 1)
> > > > > @@ -444,6 +446,11 @@ static inline bool PageMemcgKmem(struct page *page)
> > > > >       return page->memcg_data & MEMCG_DATA_KMEM;
> > > > >  }
> > > > >
> > > > > +static inline bool PageMemcgSock(struct page *page)
> > > > > +{
> > > > > +     return page->memcg_data & MEMCG_DATA_SOCK;
> > > > > +}
> > > > > +
> > > > >  #ifdef CONFIG_MEMCG_KMEM
> > > > >  /*
> > > > >   * page_objcgs - get the object cgroups vector associated with a page
> > > > > @@ -1095,6 +1102,11 @@ static inline bool PageMemcgKmem(struct page *page)
> > > > >       return false;
> > > > >  }
> > > > >
> > > > > +static inline bool PageMemcgSock(struct page *page)
> > > > > +{
> > > > > +     return false;
> > > > > +}
> > > > > +
> > > > >  static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
> > > > >  {
> > > > >       return true;
> > > > > @@ -1561,6 +1573,10 @@ extern struct static_key_false memcg_sockets_enabled_key;
> > > > >  #define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
> > > > >  void mem_cgroup_sk_alloc(struct sock *sk);
> > > > >  void mem_cgroup_sk_free(struct sock *sk);
> > > > > +int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg, struct page **pages,
> > > > > +                              unsigned int nr_pages);
> > > > > +void mem_cgroup_uncharge_sock_pages(struct page **pages, unsigned int nr_pages);
> > > > > +
> > > > >  static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
> > > > >  {
> > > > >       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
> > > > > @@ -1589,6 +1605,18 @@ static inline void memcg_set_shrinker_bit(struct mem_cgroup *memcg,
> > > > >                                         int nid, int shrinker_id)
> > > > >  {
> > > > >  }
> > > > > +
> > > > > +static inline int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg,
> > > > > +                                            struct page **pages,
> > > > > +                                            unsigned int nr_pages)
> > > > > +{
> > > > > +     return 0;
> > > > > +}
> > > > > +
> > > > > +static inline void mem_cgroup_uncharge_sock_pages(struct page **pages,
> > > > > +                                               unsigned int nr_pages)
> > > > > +{
> > > > > +}
> > > > >  #endif
> > > > >
> > > > >  #ifdef CONFIG_MEMCG_KMEM
> > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > index db9836f4b64b..38e94538e081 100644
> > > > > --- a/mm/memcontrol.c
> > > > > +++ b/mm/memcontrol.c
> > > > > @@ -7061,6 +7061,66 @@ void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
> > > > >       refill_stock(memcg, nr_pages);
> > > > >  }
> > > > >
> > > > > +/**
> > > > > + * mem_cgroup_charge_sock_pages - charge socket memory
> > > > > + * @memcg: memcg to charge
> > > > > + * @pages: array of pages to charge
> > > > > + * @nr_pages: number of pages
> > > > > + *
> > > > > + * Charges all @pages to current's memcg. The caller should have a reference on
> > > > > + * the given memcg.
> > > > > + *
> > > > > + * Returns 0 on success.
> > > > > + */
> > > > > +int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg, struct page **pages,
> > > > > +                              unsigned int nr_pages)
> > > > > +{
> > > > > +     int ret = 0;
> > > > > +
> > > > > +     if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
> > > > > +             goto out;
> > > > > +
> > > > > +     ret = try_charge(memcg, GFP_KERNEL, nr_pages);
> > > > > +
> > > > > +     if (!ret) {
> > > > > +             int i;
> > > > > +
> > > > > +             for (i = 0; i < nr_pages; i++)
> > > > > +                     pages[i]->memcg_data = (unsigned long)memcg |
> > > > > +                             MEMCG_DATA_SOCK;
> > > > > +             css_get_many(&memcg->css, nr_pages);
> > > > > +     }
> > > > > +out:
> > > > > +     return ret;
> > > > > +}
> > > > > +
> > > > > +/**
> > > > > + * mem_cgroup_uncharge_sock_pages - uncharge socket pages
> > > > > + * @pages: array of pages to uncharge
> > > > > + * @nr_pages: number of pages
> > > > > + *
> > > > > + * This assumes all pages are charged to the same memcg.
> > > > > + */
> > > > > +void mem_cgroup_uncharge_sock_pages(struct page **pages, unsigned int nr_pages)
> > > > > +{
> > > > > +     int i;
> > > > > +     struct mem_cgroup *memcg;
> > > > > +
> > > > > +     if (mem_cgroup_disabled())
> > > > > +             return;
> > > > > +
> > > > > +     memcg = page_memcg(pages[0]);
> > > > > +
> > > > > +     if (unlikely(!memcg))
> > > > > +             return;
> > > > > +
> > > > > +     refill_stock(memcg, nr_pages);
> > > > > +
> > > > > +     for (i = 0; i < nr_pages; i++)
> > > > > +             pages[i]->memcg_data = 0;
> > > > > +     css_put_many(&memcg->css, nr_pages);
> > > > > +}
> > > >
> > > > What about statistics? Should it be accounted towards "sock", "slab/kmem" or deserves
> > > > a separate counter? Do we plan to eventually have shrinkers for this type of memory?
> > > >
> > >
> > > While the pages in question are part of an sk_buff, they may be
> > > accounted towards sockmem. However, that charge is unaccounted when
> > > the skb is freed after the receive operation. When they are in use by
> > > the user application I do not think sockmem is the right place to have
> > > a break-out counter.
> >
> > Does it mean that a page can be accounted twice (even temporarily)?
> >
> 
> This was an actual consideration for this patchset that we went back
> and forth on a little bit.
> Short answer, for this patch in its current form: yes. We're calling
> mem_cgroup_charge_sock_pages() immediately prior to vm_insert_pages();
> and the skb isn't cleaned up until afterwards. Thus we have a period
> of double charging.
> 
> The pseudocode for the approach in this patch is:
> 
> while skb = next skb in queue is not null:
>     charge_skb_pages(skb.pages) // sets page.memcg for each page
>     // at this point pages are double counted
>     vm_insert_pages(skb.pages)
>     free(skb) // unrefs the pages, no longer double counted
> 
> An alternative version of this patch went the other way: have a short
> period of undercharging.
> 
> while skb = next skb in queue is not null:
>     for page in skb.pages set page.memcg
>     vm_insert_pages(skb.pages)
>     free(skb) // unrefs the pages. pages are now undercounted
> charge_skb_pages(nr_pages_mapped, FORCE_CHARGE) // count is now correct again
> ret

I have to think more, but at the first look the second approach is better.
IMO forcing the charge is less of a problem than double accounting
(we're forcing sock memory charging anyway). I'm afraid that even if the
double counting is temporarily for each individual page, with a constant
traffic it will create a permanent difference.

Btw, what is a typical size of the TCP zerocopy data per-memcg? MBs? GBs?

Thanks!
