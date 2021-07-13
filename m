From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [External] [PATCH v3 2/3] mm, memcg: inline mem_cgroup_{charge/uncharge}
 to improve disabled memcg config
Date: Mon, 12 Jul 2021 18:12:22 -0700
Message-ID: <CAJuCfpGB96oDToQewi6x2AAc03S1v0A97Z4OyiyZG9hCJ6nSOA@mail.gmail.com>
References: <20210710003626.3549282-1-surenb@google.com> <20210710003626.3549282-2-surenb@google.com>
 <CAMZfGtUqMKnMKDqY7wP+29U-fSxqsOv9OHnaZxQSsOtKrBQYfQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c3oAlTpbgK6u4tipighDXmanWuC5k+j2pz7LHeW3niE=;
        b=seQEp+0/ZpN/RK+fvG8klQBC3j7eW84QimkF86nmGyY8xuENBGhMw/dtqU1HqofJx+
         qSF0iqRZHKLoVWniM5fTCcOUAjyzBzRrYYe+wnEeP0L4Q3nCGdKo26wTAWGF2mauRJ13
         tOjhFdoOphrNcXGK5aZ3VIEoNG5cpH3qtf44HaWa3kVoS3HyVvFPk1wzWkFt7rYB+wDj
         BMjF8FxNIvqAFCI1dYFSD4ul3G7utINcF0CRxMJaegbwDLfC9FzeE84nmEd3ruMsE9uO
         E7YXB/C92IzbWGPUaQZv0Ad5pbbwzMDyFghYA563uleRAgkGiwnjUnZaOijuQI4p0IFN
         MPGQ==
In-Reply-To: <CAMZfGtUqMKnMKDqY7wP+29U-fSxqsOv9OHnaZxQSsOtKrBQYfQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Shi <alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, kernel-team <kernel->

On Sat, Jul 10, 2021 at 4:08 AM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>
> On Sat, Jul 10, 2021 at 8:36 AM Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > Inline mem_cgroup_{charge/uncharge} and mem_cgroup_uncharge_list functions
> > functions to perform mem_cgroup_disabled static key check inline before
> > calling the main body of the function. This minimizes the memcg overhead
> > in the pagefault and exit_mmap paths when memcgs are disabled using
> > cgroup_disable=memory command-line option.
> > This change results in ~0.4% overhead reduction when running PFT test
> > comparing {CONFIG_MEMCG=n} against {CONFIG_MEMCG=y, cgroup_disable=memory}
> > configurationon on an 8-core ARM64 Android device.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>
> But some nits below.
>
> > ---
> >  include/linux/memcontrol.h | 28 +++++++++++++++++++++++++---
> >  mm/memcontrol.c            | 29 ++++++++++-------------------
> >  2 files changed, 35 insertions(+), 22 deletions(-)
> >
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index bfe5c486f4ad..39fa88051a42 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -693,13 +693,35 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *memcg)
> >                 page_counter_read(&memcg->memory);
> >  }
> >
> > -int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask);
> > +int __mem_cgroup_charge(struct page *page, struct mm_struct *mm,
> > +                       gfp_t gfp_mask);
> > +static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
> > +                                   gfp_t gfp_mask)
> > +{
> > +       if (mem_cgroup_disabled())
> > +               return 0;
> > +       return __mem_cgroup_charge(page, mm, gfp_mask);
> > +}
> > +
> >  int mem_cgroup_swapin_charge_page(struct page *page, struct mm_struct *mm,
> >                                   gfp_t gfp, swp_entry_t entry);
> >  void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry);
> >
> > -void mem_cgroup_uncharge(struct page *page);
> > -void mem_cgroup_uncharge_list(struct list_head *page_list);
> > +void __mem_cgroup_uncharge(struct page *page);
> > +static inline void mem_cgroup_uncharge(struct page *page)
> > +{
> > +       if (mem_cgroup_disabled())
> > +               return;
> > +       __mem_cgroup_uncharge(page);
> > +}
> > +
> > +void __mem_cgroup_uncharge_list(struct list_head *page_list);
> > +static inline void mem_cgroup_uncharge_list(struct list_head *page_list)
> > +{
> > +       if (mem_cgroup_disabled())
> > +               return;
> > +       __mem_cgroup_uncharge_list(page_list);
> > +}
> >
> >  void mem_cgroup_migrate(struct page *oldpage, struct page *newpage);
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index a228cd51c4bd..cdaf7003b43d 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6701,8 +6701,7 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
> >                         atomic_long_read(&parent->memory.children_low_usage)));
> >  }
> >
> > -static int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
> > -                              gfp_t gfp)
> > +static int charge_memcg(struct page *page, struct mem_cgroup *memcg, gfp_t gfp)
> >  {
> >         unsigned int nr_pages = thp_nr_pages(page);
> >         int ret;
> > @@ -6723,7 +6722,7 @@ static int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
> >  }
> >
> >  /**
> > - * mem_cgroup_charge - charge a newly allocated page to a cgroup
> > + * __mem_cgroup_charge - charge a newly allocated page to a cgroup
> >   * @page: page to charge
> >   * @mm: mm context of the victim
> >   * @gfp_mask: reclaim mode
> > @@ -6736,16 +6735,14 @@ static int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
> >   *
> >   * Returns 0 on success. Otherwise, an error code is returned.
> >   */
> > -int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
> > +int __mem_cgroup_charge(struct page *page, struct mm_struct *mm,
> > +                       gfp_t gfp_mask)
> >  {
> >         struct mem_cgroup *memcg;
> >         int ret;
> >
> > -       if (mem_cgroup_disabled())
> > -               return 0;
> > -
> >         memcg = get_mem_cgroup_from_mm(mm);
> > -       ret = __mem_cgroup_charge(page, memcg, gfp_mask);
> > +       ret = charge_memcg(page, memcg, gfp_mask);
> >         css_put(&memcg->css);
> >
> >         return ret;
> > @@ -6780,7 +6777,7 @@ int mem_cgroup_swapin_charge_page(struct page *page, struct mm_struct *mm,
> >                 memcg = get_mem_cgroup_from_mm(mm);
> >         rcu_read_unlock();
> >
> > -       ret = __mem_cgroup_charge(page, memcg, gfp);
> > +       ret = charge_memcg(page, memcg, gfp);
> >
> >         css_put(&memcg->css);
> >         return ret;
> > @@ -6916,18 +6913,15 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
> >  }
> >
> >  /**
> > - * mem_cgroup_uncharge - uncharge a page
> > + * __mem_cgroup_uncharge - uncharge a page
> >   * @page: page to uncharge
> >   *
> >   * Uncharge a page previously charged with mem_cgroup_charge().
>
> The comment here also needs to be updated.
>
> mem_cgroup_uncharge() -> __mem_cgroup_uncharge()
>
> >   */
> > -void mem_cgroup_uncharge(struct page *page)
> > +void __mem_cgroup_uncharge(struct page *page)
> >  {
> >         struct uncharge_gather ug;
> >
> > -       if (mem_cgroup_disabled())
> > -               return;
> > -
> >         /* Don't touch page->lru of any random page, pre-check: */
> >         if (!page_memcg(page))
> >                 return;
> > @@ -6938,20 +6932,17 @@ void mem_cgroup_uncharge(struct page *page)
> >  }
> >
> >  /**
> > - * mem_cgroup_uncharge_list - uncharge a list of page
> > + * __mem_cgroup_uncharge_list - uncharge a list of page
> >   * @page_list: list of pages to uncharge
> >   *
> >   * Uncharge a list of pages previously charged with
> >   * mem_cgroup_charge().
>
> Should be __mem_cgroup_charge().

Fixed and posted in v4 at:
https://lore.kernel.org/patchwork/project/lkml/list/?series=507943
Thanks!

>
> Thanks.
>
> >   */
> > -void mem_cgroup_uncharge_list(struct list_head *page_list)
> > +void __mem_cgroup_uncharge_list(struct list_head *page_list)
> >  {
> >         struct uncharge_gather ug;
> >         struct page *page;
> >
> > -       if (mem_cgroup_disabled())
> > -               return;
> > -
> >         uncharge_gather_clear(&ug);
> >         list_for_each_entry(page, page_list, lru)
> >                 uncharge_page(page, &ug);
> > --
> > 2.32.0.93.g670b81a890-goog
> >
