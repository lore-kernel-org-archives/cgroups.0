From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm: page-writeback: simplify memcg handling in test_clear_page_writeback()
Date: Wed, 10 Feb 2021 14:59:32 -0800
Message-ID: <CALvZod6vgYcpgskf7NaRagH999L6VkfnVtD1UDb+JhQceCuUEA@mail.gmail.com>
References: <20210209214543.112655-1-hannes@cmpxchg.org> <alpine.LSU.2.11.2102092058290.7553@eggly.anvils>
 <alpine.LSU.2.11.2102100813050.8131@eggly.anvils> <YCQbYAWg4nvBFL6h@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xrTlzAySlcJTUXRnlEJkf0lrI9Iuz7zvICLmzyym/xM=;
        b=eMT+HrSpUk67s7D9Fb/wYqRRhLhygRRnmrKjid5+dGjRRdcWnl+Coe1Hmivi013BcD
         vM7qrpbntHPGYw3ZR2mT73sG3gTPW+Ae1qRtuLiiI+dqqOKuimFiDxcTK8abjY31E3rf
         Fmq+1ScDwhhI6jHG7o9mVfPDf1sBmPRQsQLW79d/E3O3s4IGItRepiKnHYMt1D30bRmR
         MM+t2zmasxETxauJwuE6V8yQF8vBKu/UNkNA0RFX4nCUyjeyCijXg0fMI7T9wwjnhnNQ
         0u4Vr+WykIzPW6B+1Kw9DctVhRNP42iVTrRSwiizbnXzW/vUetxSQ8bVn1+17zIlc7Ni
         ft3w==
In-Reply-To: <YCQbYAWg4nvBFL6h-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Feb 10, 2021 at 9:44 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Wed, Feb 10, 2021 at 08:22:00AM -0800, Hugh Dickins wrote:
> > On Tue, 9 Feb 2021, Hugh Dickins wrote:
> > > On Tue, 9 Feb 2021, Johannes Weiner wrote:
> > >
> > > > Page writeback doesn't hold a page reference, which allows truncate to
> > > > free a page the second PageWriteback is cleared. This used to require
> > > > special attention in test_clear_page_writeback(), where we had to be
> > > > careful not to rely on the unstable page->memcg binding and look up
> > > > all the necessary information before clearing the writeback flag.
> > > >
> > > > Since commit 073861ed77b6 ("mm: fix VM_BUG_ON(PageTail) and
> > > > BUG_ON(PageWriteback)") test_clear_page_writeback() is called with an
> > > > explicit reference on the page, and this dance is no longer needed.
> > > >
> > > > Use unlock_page_memcg() and dec_lruvec_page_stat() directly.
> > >
> > > s/stat()/state()/
> > >
> > > This is a nice cleanup: I hadn't seen that connection at all.
> > >
> > > But I think you should take it further:
> > > __unlock_page_memcg() can then be static in mm/memcontrol.c,
> > > and its declarations deleted from include/linux/memcontrol.h?
> >
> > And further: void lock_page_memcg(page), not returning memcg.
>
> You're right on all counts!
>
> > > And further: delete __dec_lruvec_state() and dec_lruvec_state()
> > > from include/linux/vmstat.h - unless you feel that every "inc"
> > > ought to be matched by a "dec", even when unused.
>
> Hey look, there isn't a user for the __inc, either :) There is one for
> inc, but I don't insist on having symmetry there.
>
> > > > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > >
> > > Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> Thanks for the review and good feedback.
>
> How about this v2?
>
> ---
>
> From 5bcc0f468460aa2670c40318bb657e8b08ef96d5 Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Date: Tue, 9 Feb 2021 16:22:42 -0500
> Subject: [PATCH] mm: page-writeback: simplify memcg handling in
>  test_clear_page_writeback()
>
> Page writeback doesn't hold a page reference, which allows truncate to
> free a page the second PageWriteback is cleared. This used to require
> special attention in test_clear_page_writeback(), where we had to be
> careful not to rely on the unstable page->memcg binding and look up
> all the necessary information before clearing the writeback flag.
>
> Since commit 073861ed77b6 ("mm: fix VM_BUG_ON(PageTail) and
> BUG_ON(PageWriteback)") test_clear_page_writeback() is called with an
> explicit reference on the page, and this dance is no longer needed.
>
> Use unlock_page_memcg() and dec_lruvec_page_state() directly.
>
> This removes the last user of the lock_page_memcg() return value,
> change it to void. Touch up the comments in there as well. This also
> removes the last extern user of __unlock_page_memcg(), make it
> static. Further, it removes the last user of dec_lruvec_state(),
> delete it, along with a few other unused helpers.
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

The patch looks fine. I don't want to spoil the fun but just wanted to
call out that I might bring back __unlock_page_memcg() for the memcg
accounting of zero copy TCP memory work where we are uncharging the
page in page_remove_rmap().
