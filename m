From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 2/3] mm, memcg: inline mem_cgroup_{charge/uncharge} to
 improve disabled memcg config
Date: Fri, 9 Jul 2021 08:18:36 -0700
Message-ID: <CAJuCfpFFNZ1DNQHFOyGwafw1MBHfELDzp2iqR4ot-gm3SGNNBA@mail.gmail.com>
References: <20210709000509.2618345-1-surenb@google.com> <20210709000509.2618345-3-surenb@google.com>
 <YOhh0IabpRk/W/qR@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hGX3UGEwXfFwKKdhbKxdN5Z9a9eTLdUcU8IFnRtBKXI=;
        b=dxLikpQTw+JGI68eVGXPE6+Vh6CNs2aa72+3GaFp/nhZH3pkxKvuJ4GDphfvTwANQh
         DwW5jmyPQNxQp+Gyg+r7oZaSKpbXMTnjJ9thXEB5FircFSbyu2WlopPeIjGFD4KnbEJ3
         bYzsdtMFPHBOdJiiJ2OcgObtZ/BHPgIcxPnlYvdZIjtQpa1ltOWVphSG/gUJ6w+ODLMF
         9RBzHBKRDJXEzH9lBmrhfqHDt7i9UzkjLi0ltOMOhrvm+TUFqvi/v0HjDEIMYHVm2mga
         7RvC6esBxwFX8ldoMQR+kadRcZVFoEXd48ZRjWo3iW1tQHu+xqXdgTmwcUhQXbR+S8So
         4Srw==
In-Reply-To: <YOhh0IabpRk/W/qR@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@kernel.org>, vdavydov.dev@gmail.com, Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, songmuchun@bytedance.com, Yang Shi <shy828301@gmail.com>, alexs@kernel.org, alexander.h.duyck@linux.intel.com, richard.weiyang@gmail.com, Vlastimil Babka <vbabka@suse.cz>, Jens Axboe <axboe@kernel.dk>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, apopple@nvidia.com, Minchan Kim <minchan@kernel.org>, linmiaohe@huawei.com, LKML <linux-kernel@vger.kernel.org>, cgroups mailinglist <cgroups@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, kernel-team <kernel-team@android.com>

On Fri, Jul 9, 2021 at 7:48 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Thu, Jul 08, 2021 at 05:05:08PM -0700, Suren Baghdasaryan wrote:
> > Inline mem_cgroup_{charge/uncharge} and mem_cgroup_uncharge_list functions
> > functions to perform mem_cgroup_disabled static key check inline before
> > calling the main body of the function. This minimizes the memcg overhead
> > in the pagefault and exit_mmap paths when memcgs are disabled using
> > cgroup_disable=memory command-line option.
> > This change results in ~0.4% overhead reduction when running PFT test
> > comparing {CONFIG_MEMCG=n} against {CONFIG_MEMCG=y, cgroup_disable=memory}
> > configurationon on an 8-core ARM64 Android device.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> Sounds reasonable to me as well. One comment:
>
> > @@ -693,13 +693,59 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *memcg)
> >               page_counter_read(&memcg->memory);
> >  }
> >
> > -int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask);
> > +struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
> > +
> > +int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
> > +                     gfp_t gfp);
> > +/**
> > + * mem_cgroup_charge - charge a newly allocated page to a cgroup
> > + * @page: page to charge
> > + * @mm: mm context of the victim
> > + * @gfp_mask: reclaim mode
> > + *
> > + * Try to charge @page to the memcg that @mm belongs to, reclaiming
> > + * pages according to @gfp_mask if necessary. if @mm is NULL, try to
> > + * charge to the active memcg.
> > + *
> > + * Do not use this for pages allocated for swapin.
> > + *
> > + * Returns 0 on success. Otherwise, an error code is returned.
> > + */
> > +static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
> > +                                 gfp_t gfp_mask)
> > +{
> > +     struct mem_cgroup *memcg;
> > +     int ret;
> > +
> > +     if (mem_cgroup_disabled())
> > +             return 0;
> > +
> > +     memcg = get_mem_cgroup_from_mm(mm);
> > +     ret = __mem_cgroup_charge(page, memcg, gfp_mask);
> > +     css_put(&memcg->css);
> > +
> > +     return ret;
>
> Why not do
>
> int __mem_cgroup_charge(struct page *page, struct mm_struct *mm,
>                         gfp_t gfp_mask);
>
> static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
>                                     gfp_t gfp_mask)
> {
>         if (mem_cgroup_disabled())
>                 return 0;
>
>         return __mem_cgroup_charge(page, memcg, gfp_mask);
> }
>
> like in the other cases as well?
>
> That would avoid inlining two separate function calls into all the
> callsites...
>
> There is an (internal) __mem_cgroup_charge() already, but you can
> rename it charge_memcg().

Sounds good. I'll post an updated version with your suggestion.
Thanks for the review, Johannes!

>
