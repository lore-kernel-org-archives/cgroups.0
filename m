From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 2/3] mm, memcg: inline mem_cgroup_{charge/uncharge} to
 improve disabled memcg config
Date: Fri, 9 Jul 2021 10:17:48 -0700
Message-ID: <CAJuCfpHTT6v2Gjph=BMHPRQ76DRY8q3+4UEs0gaOkm3cLvJKDw@mail.gmail.com>
References: <20210709000509.2618345-1-surenb@google.com> <20210709000509.2618345-3-surenb@google.com>
 <YOhh0IabpRk/W/qR@cmpxchg.org> <CAJuCfpFFNZ1DNQHFOyGwafw1MBHfELDzp2iqR4ot-gm3SGNNBA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6F4LOb4/qbICNruJHwbsWh8y31MCaegySpX98sO3li0=;
        b=NMc2lbTxvLMqVFevQe6lCca1Wk+YJmMCWhkCP6Iy4HwWowK2M9RJ2jBgpcfpA+yn/t
         2FMysA7140dTnBDBQrluNz0Y7eYYGHjLLpFg/WjfRb4WvKMaZxXuAU2z7VjzRMPx+9Rv
         DMaFCjFdwle1AchujQt/7vV48KFnN9nQOsXeqQK44TnPH43LwFGSoCklkIT9o2jRJKlY
         SOCUi4qdZXCyjlPmJMkV2NHx+mpdy8iSGld11vCUYr2Xc+nbof7t0CznipuL94S/THLf
         RRNXF9WsCaD6ZFmEauMBLXdLJvyj93jP/mI0ACpdmWs80NC+gb+A1VPVKHSWPoqsQYyG
         lqyQ==
In-Reply-To: <CAJuCfpFFNZ1DNQHFOyGwafw1MBHfELDzp2iqR4ot-gm3SGNNBA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@kernel.org>, vdavydov.dev@gmail.com, Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, songmuchun@bytedance.com, Yang Shi <shy828301@gmail.com>, alexs@kernel.org, alexander.h.duyck@linux.intel.com, richard.weiyang@gmail.com, Vlastimil Babka <vbabka@suse.cz>, Jens Axboe <axboe@kernel.dk>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, apopple@nvidia.com, Minchan Kim <minchan@kernel.org>, linmiaohe@huawei.com, LKML <linux-kernel@vger.kernel.org>, cgroups mailinglist <cgroups@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, kernel-team <kernel-team@android.com>

On Fri, Jul 9, 2021 at 8:18 AM Suren Baghdasaryan <surenb@google.com> wrote:
>
> On Fri, Jul 9, 2021 at 7:48 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Thu, Jul 08, 2021 at 05:05:08PM -0700, Suren Baghdasaryan wrote:
> > > Inline mem_cgroup_{charge/uncharge} and mem_cgroup_uncharge_list functions
> > > functions to perform mem_cgroup_disabled static key check inline before
> > > calling the main body of the function. This minimizes the memcg overhead
> > > in the pagefault and exit_mmap paths when memcgs are disabled using
> > > cgroup_disable=memory command-line option.
> > > This change results in ~0.4% overhead reduction when running PFT test
> > > comparing {CONFIG_MEMCG=n} against {CONFIG_MEMCG=y, cgroup_disable=memory}
> > > configurationon on an 8-core ARM64 Android device.
> > >
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >
> > Sounds reasonable to me as well. One comment:
> >
> > > @@ -693,13 +693,59 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *memcg)
> > >               page_counter_read(&memcg->memory);
> > >  }
> > >
> > > -int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask);
> > > +struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
> > > +
> > > +int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
> > > +                     gfp_t gfp);
> > > +/**
> > > + * mem_cgroup_charge - charge a newly allocated page to a cgroup
> > > + * @page: page to charge
> > > + * @mm: mm context of the victim
> > > + * @gfp_mask: reclaim mode
> > > + *
> > > + * Try to charge @page to the memcg that @mm belongs to, reclaiming
> > > + * pages according to @gfp_mask if necessary. if @mm is NULL, try to
> > > + * charge to the active memcg.
> > > + *
> > > + * Do not use this for pages allocated for swapin.
> > > + *
> > > + * Returns 0 on success. Otherwise, an error code is returned.
> > > + */
> > > +static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
> > > +                                 gfp_t gfp_mask)
> > > +{
> > > +     struct mem_cgroup *memcg;
> > > +     int ret;
> > > +
> > > +     if (mem_cgroup_disabled())
> > > +             return 0;
> > > +
> > > +     memcg = get_mem_cgroup_from_mm(mm);
> > > +     ret = __mem_cgroup_charge(page, memcg, gfp_mask);
> > > +     css_put(&memcg->css);
> > > +
> > > +     return ret;
> >
> > Why not do
> >
> > int __mem_cgroup_charge(struct page *page, struct mm_struct *mm,
> >                         gfp_t gfp_mask);
> >
> > static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
> >                                     gfp_t gfp_mask)
> > {
> >         if (mem_cgroup_disabled())
> >                 return 0;
> >
> >         return __mem_cgroup_charge(page, memcg, gfp_mask);
> > }
> >
> > like in the other cases as well?
> >
> > That would avoid inlining two separate function calls into all the
> > callsites...
> >
> > There is an (internal) __mem_cgroup_charge() already, but you can
> > rename it charge_memcg().
>
> Sounds good. I'll post an updated version with your suggestion.
> Thanks for the review, Johannes!

Posted v2 just for this patch at
https://lore.kernel.org/patchwork/patch/1455550 . Please let me know
if you want me to resent the whole patchset instead of just this
patch.
>
> >
