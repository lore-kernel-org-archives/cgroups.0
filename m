From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v11 6/9] hugetlb_cgroup: support noreserve mappings
Date: Tue, 11 Feb 2020 13:35:06 -0800
Message-ID: <CAHS8izMGreJgOhG8ivE2OH9bq98BmvxAqtBc=M9waTqOKv3eeQ@mail.gmail.com>
References: <20200203232248.104733-1-almasrymina@google.com>
 <20200203232248.104733-6-almasrymina@google.com> <6cc406e7-757f-4922-ffc0-681df3ee0d18@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FPD9BpDVwDUxM6Ip8EFlRULrgnjEP3aNdZIbOVFnMe0=;
        b=B36DxbZZRwo0TP4rDikBCgdf0HltQGxfonCU0xN5pDZFDZm/IDCxFJLUu9RD4TJKjC
         wXrxZ5GyC2AWBXmn87iB/TGJXJGGw/+YS4H5kRamVkLauyNnlgJ4ioKGHrocGiWjFhUo
         MTaip7Vg7uEqbQi/ZBe8/pZgqKxATTSSJZ4D58a+AAvNtm0ZGHUwtkEYQlfFqAcnsgmi
         qW2YpT1kG7XMDLPTauVsDkdRXFdNQd7izC6dJjaiv4QZcFjH4igk5gTy8LX24VHUCZOe
         4pBCo9vJhQ/y3yhG9LcVjX0JcApXUBZMpckrwjYDzMwxpe8KWH4cy8wcGeKWD4fgi1Je
         PbOw==
In-Reply-To: <6cc406e7-757f-4922-ffc0-681df3ee0d18-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Feb 6, 2020 at 2:31 PM Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> On 2/3/20 3:22 PM, Mina Almasry wrote:
> > Support MAP_NORESERVE accounting as part of the new counter.
> >
> > For each hugepage allocation, at allocation time we check if there is
> > a reservation for this allocation or not. If there is a reservation for
> > this allocation, then this allocation was charged at reservation time,
> > and we don't re-account it. If there is no reserevation for this
> > allocation, we charge the appropriate hugetlb_cgroup.
> >
> > The hugetlb_cgroup to uncharge for this allocation is stored in
> > page[3].private. We use new APIs added in an earlier patch to set this
> > pointer.
>
> Ah!  That reminded me to look at the migration code.  Turns out that none
> of the existing cgroup information (page[2]) is being migrated today.  That
> is a bug. :(  I'll confirm and fix in a patch separate from this series.
> We will need to make sure that new information added by this series in page[3]
> is also migrated.  That would be in an earlier patch where the use of the
> field is introduced.
>
> >
> > Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > ---
> >
> > Changes in v10:
> > - Refactored deferred_reserve check.
> >
> > ---
> >  mm/hugetlb.c | 28 +++++++++++++++++++++++++++-
> >  1 file changed, 27 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 33818ccaf7e89..ec0b55ea1506e 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -1339,6 +1339,9 @@ static void __free_huge_page(struct page *page)
> >       clear_page_huge_active(page);
> >       hugetlb_cgroup_uncharge_page(hstate_index(h), pages_per_huge_page(h),
> >                                    page, false);
> > +     hugetlb_cgroup_uncharge_page(hstate_index(h), pages_per_huge_page(h),
> > +                                  page, true);
> > +
>
> When looking at the code without change markings, the two above lines
> look so similar my first thought is there must be a mistake.
>
> A suggestion for better code readability:
> - hugetlb_cgroup_uncharge_page could just take "struct hstate *h" and
>   get both hstate_index(h) and pages_per_huge_page(h).
> - Perhaps make hugetlb_cgroup_uncharge_page and
>   hugetlb_cgroup_uncharge_page_rsvd be wrappers around a common routine.
>   Then the above would look like:
>
>   hugetlb_cgroup_uncharge_page(h, page);
>   hugetlb_cgroup_uncharge_page_rsvd(h, page);
>

I did modify the interfaces to this, as it's much better for
readability indeed. Unfortunately the patch the adds interfaces
probably needs a re-review now as it's changed quite a bit, I did not
carry your or David's Reviewed-by.

>
> >       if (restore_reserve)
> >               h->resv_huge_pages++;
> >
> > @@ -2172,6 +2175,7 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
> >       long gbl_chg;
> >       int ret, idx;
> >       struct hugetlb_cgroup *h_cg;
> > +     bool deferred_reserve;
> >
> >       idx = hstate_index(h);
> >       /*
> > @@ -2209,10 +2213,20 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
> >                       gbl_chg = 1;
> >       }
> >
> > +     /* If this allocation is not consuming a reservation, charge it now.
> > +      */
> > +     deferred_reserve = map_chg || avoid_reserve || !vma_resv_map(vma);
> > +     if (deferred_reserve) {
> > +             ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h),
> > +                                                &h_cg, true);
> > +             if (ret)
> > +                     goto out_subpool_put;
> > +     }
> > +
> >       ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg,
> >                                          false);
>
> Hmmm?  I'm starting to like the wrapper idea more as a way to help with
> readability of the bool rsvd argument.
>
> hugetlb_cgroup_charge_cgroup_rsvd()
> hugetlb_cgroup_charge_cgroup()
>
> At least to me it makes it easier to read.
> --
> Mike Kravetz
>
> >       if (ret)
> > -             goto out_subpool_put;
> > +             goto out_uncharge_cgroup_reservation;
> >
> >       spin_lock(&hugetlb_lock);
> >       /*
> > @@ -2236,6 +2250,14 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
> >       }
> >       hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page,
> >                                    false);
> > +     /* If allocation is not consuming a reservation, also store the
> > +      * hugetlb_cgroup pointer on the page.
> > +      */
> > +     if (deferred_reserve) {
> > +             hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg,
> > +                                          page, true);
> > +     }
> > +
> >       spin_unlock(&hugetlb_lock);
> >
> >       set_page_private(page, (unsigned long)spool);
> > @@ -2261,6 +2283,10 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
> >  out_uncharge_cgroup:
> >       hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg,
> >                                      false);
> > +out_uncharge_cgroup_reservation:
> > +     if (deferred_reserve)
> > +             hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h),
> > +                                            h_cg, true);
> >  out_subpool_put:
> >       if (map_chg || avoid_reserve)
> >               hugepage_subpool_put_pages(spool, 1);
> > --
> > 2.25.0.341.g760bfbb309-goog
