From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH 4/4] mm: memcontrol: fix swap uncharge on
 cgroup v2
Date: Wed, 17 Feb 2021 13:15:17 +0800
Message-ID: <CAMZfGtVoZc=w51MmfZ38SD1RXDDd-muRsX0EYbS5HjDmgpaNsQ@mail.gmail.com>
References: <20210212170159.32153-1-songmuchun@bytedance.com>
 <20210212170159.32153-4-songmuchun@bytedance.com> <YCv51LgGIWxVjLHT@cmpxchg.org>
 <YCwApSWpgOTOZEMx@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nxax/8EwLpfEywaFZNrZLBQYVWz7Z8fTZrkl9WlTJsk=;
        b=TjLBGWBAPyoCC0TEIegIyE/Nj8wMMOyxVs9bt3bYOem3jMqToT9VdJwPO6mqXZ2UNj
         rnXSlmZcsy4QebmWanmcK1+RaKkGppYn2htgoCc5LEdddP2/v+TLRB4+Wqh55c4PxWSn
         67mxMG4F/PETxmfOziZ+wnIk+jMZHeuEKeZfNDIusf4qVMIZGijFNX8YoajTaHNiOJlV
         3ZtZBS9AFEdFM3stjzQZuJVxZjFvG0rm1FeohggbZGcFeGJt5Hgfcvg4fPug1iFHbeBL
         ijcJbzONnmG3KpGK5uxM2PyaZDJlQ9/V7idkNOGcXpCu+zH69LoQgv8lIMxBIfRWxT3k
         0RQA==
In-Reply-To: <YCwApSWpgOTOZEMx-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Feb 17, 2021 at 1:28 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Tue, Feb 16, 2021 at 11:59:01AM -0500, Johannes Weiner wrote:
> > Hello Muchun,
> >
> > On Sat, Feb 13, 2021 at 01:01:59AM +0800, Muchun Song wrote:
> > > The swap charges the actual number of swap entries on cgroup v2.
> > > If a swap cache page is charged successful, and then we uncharge
> > > the swap counter. It is wrong on cgroup v2. Because the swap
> > > entry is not freed.
> >
> > The patch makes sense to me. But this code is a bit tricky, we should
> > add more documentation to how it works and what the problem is.
> >
> > How about this for the changelog?
> >
> > ---
> > mm: memcontrol: fix swap undercounting for shared pages in cgroup2
>
> Coming to think of it, this isn't just for shared pages. We also hold
> on to the swap slot as long as the page is read-only, not mlocked, and
> swap isn't full. So scratch "for shared pages" here.

OK. Will do.

>
> > When shared pages are swapped in partially, we can have some page
> > tables referencing the in-memory page and some referencing the swap
> > slot. Cgroup1 and cgroup2 handle these overlapping lifetimes slightly
> > differently due to the nature of how they account memory and swap:
>
> Correction:
>
> When pages are swapped in, the VM may retain the swap copy to avoid
> repeated writes in the future. It's also retained if shared pages are
> faulted back in some processes, but not in others. During that time we
> have an in-memory copy of the page, as well as an on-swap
> copy. Cgroup1 and cgroup2 handle these overlapping lifetimes slightly
> differently due to the nature of how they account memory and swap:

Thanks a lot.

>
> > Cgroup1 has a unified memory+swap counter that tracks a data page
> > regardless whether it's in-core or swapped out. On swapin, we transfer
> > the charge from the swap entry to the newly allocated swapcache page,
> > even though the swap entry might stick around for a while. That's why
> > we have a mem_cgroup_uncharge_swap() call inside mem_cgroup_charge().
> >
> > Cgroup2 tracks memory and swap as separate, independent resources and
> > thus has split memory and swap counters. On swapin, we charge the
> > newly allocated swapcache page as memory, while the swap slot in turn
> > must remain charged to the swap counter as long as its allocated too.
> >
> > The cgroup2 logic was broken by commit 2d1c498072de ("mm: memcontrol:
> > make swap tracking an integral part of memory control"), because it
> > accidentally removed the do_memsw_account() check in the branch inside
> > mem_cgroup_uncharge() that was supposed to tell the difference between
> > the charge transfer in cgroup1 and the separate counters in cgroup2.
> >
> > As a result, cgroup2 currently undercounts consumed swap when shared
> > pages are partially swapped back in. This in turn allows a cgroup to
> > consume more swap than its configured limit intends.
>
> Correction:
>
> As a result, cgroup2 currently undercounts retained swap to varying
> degrees: swap slots are cached up to 50% of the configured limit or
> total available swap space; partially faulted back shared pages are
> only limited by physical capacity. This in turn allows cgroups to
> significantly overconsume their alloted swap space.

Thanks a lot.

>
> > Add the do_memsw_account() check back to fix this problem.
> > ---
> >
> > > Fixes: 2d1c498072de ("mm: memcontrol: make swap tracking an integral part of memory control")
> > > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> >
> > Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>
> I also think we should tag stable on this one. The potential
> accounting error is quite large and, even without concrete examples,
> is likely to cause problems for swap management in the real world.
>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 5.8+

OK. I will add a Cc stable tag. Thanks.

>
> > >  mm/memcontrol.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index c737c8f05992..be6bc5044150 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -6753,7 +6753,7 @@ int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
> > >     memcg_check_events(memcg, page);
> > >     local_irq_enable();
> > >
> > > -   if (PageSwapCache(page)) {
> > > +   if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && PageSwapCache(page)) {
> >
> > It's more descriptive to use do_memsw_account() here, IMO.
> >
> > We should also add a comment. How about this above the branch?
> >
> >       /*
> >        * Cgroup1's unified memory+swap counter has been charged with the
> >        * new swapcache page, finish the transfer by uncharging the swap
> >        * slot. The swap slot would also get uncharged when it dies, but
> >        * for shared pages it can stick around indefinitely and we'd count
> >        * the page twice the entire time.
>
> -for shared pages
>
> >        * Cgroup2 has separate resource counters for memory and swap,
> >        * so this is a non-issue here. Memory and swap charge lifetimes
> >        * correspond 1:1 to page and swap slot lifetimes: we charge the
> >        * page to memory here, and uncharge swap when the slot is freed.
> >        */
