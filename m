From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH 4/4] mm: memcontrol: fix swap uncharge on
 cgroup v2
Date: Mon, 15 Feb 2021 18:15:36 +0800
Message-ID: <CAMZfGtVSXG5BRR9R3_+eeoCCWBW87GLVNLPwZCyDUHNeAPrXUw@mail.gmail.com>
References: <20210212170159.32153-1-songmuchun@bytedance.com>
 <20210212170159.32153-4-songmuchun@bytedance.com> <YCpDSnLSDoE/FHK5@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u1c7h/mK6g+ogVZX7ggIUmGlrcBSJghu81rDVUuKJeo=;
        b=0FW5axmzuWLUD9WPtpoYRed/CptLJiwqxxA0oC3HxYlqxYr6uBNojbzJPsUS8mQmkN
         vDFuP6SBiWLEd/VrJ+S/uJSQAFLY4Ou/4VgcHFNVse+ImTNKDedz2knB9JWla6RAZvG4
         lr8hpfYy6vGcOCg28Kh7laHBDZ1r4Fc966DYiIwHqveX9UJb6Tn+PrW7IFxOmNEG+Qmy
         CELGwkYpG5+N3Z9/e7kkZF01HzyQnlM9RAXis+9nKiHiGKOLRp+FRGv29Wz3cU/ks2TL
         WLofAn/LIf3heA08rlSbJDpfaDFRBu5ZxClran+mrYIagZ7NE1v75Ep3V9JAmUPnuY8N
         2Ogw==
In-Reply-To: <YCpDSnLSDoE/FHK5-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Feb 15, 2021 at 5:47 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Sat 13-02-21 01:01:59, Muchun Song wrote:
> > The swap charges the actual number of swap entries on cgroup v2.
> > If a swap cache page is charged successful, and then we uncharge
> > the swap counter. It is wrong on cgroup v2. Because the swap
> > entry is not freed.
>
> Is there any actual problem though? Can you describe the specific
> scenario please? Swap cache charge life time is a bit tricky and I have
> to confess I have to relearn it every time I need to understand it. The
> patch would be much more easier to review if the changelog was much more
> specific.

I copied the reply to Shakeel here. :-)

IIUC, I think that we cannot limit the swap to memory.swap.max
on cgroup v2.

  cd /sys/fs/cgroup/
  mkdir test
  cd test
  echo 8192 > memory.max
  echo 4096 > memory.swap.max

OK. Now we limit swap to 1 page and memory to 2 pages.
Firstly, we allocate 1 page from this memory cgroup and
swap this page to swap disk. We can see:

  memory.current: 0
  memory.swap.current: 1

Then we touch this page, we will swap in and charge
the swap cache page to the memory counter and uncharge
the swap counter.

  memory.current: 1
  memory.swap.current: 0 (but actually we use a swap entry)

Then we allocate another 1 page from this memory cgroup.

  memory.current: 2
  memory.swap.current: 0 (but actually we use a swap entry)

If we swap those 2 pages to swap disk. We can charge and swap
those 2 pages successfully. Right? Maybe I am wrong.

>
> > Fixes: 2d1c498072de ("mm: memcontrol: make swap tracking an integral part of memory control")
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > ---
> >  mm/memcontrol.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index c737c8f05992..be6bc5044150 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6753,7 +6753,7 @@ int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
> >       memcg_check_events(memcg, page);
> >       local_irq_enable();
> >
> > -     if (PageSwapCache(page)) {
> > +     if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && PageSwapCache(page)) {
> >               swp_entry_t entry = { .val = page_private(page) };
> >               /*
> >                * The swap entry might not get freed for a long time,
> > --
> > 2.11.0
>
> --
> Michal Hocko
> SUSE Labs
