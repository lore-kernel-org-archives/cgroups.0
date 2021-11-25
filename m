From: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: reduce spinlock contention in release_pages()
Date: Thu, 25 Nov 2021 11:24:02 +0800
Message-ID: <CA+PpKPmy-u_BxYMCQOFyz78t2+3uM6nR9mQeX+MPyH6H2tOOHA@mail.gmail.com>
References: <20211124151915.GA6163@haolee.io> <YZ5o/VmU59evp65J@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t/Nlxsq9kW/Hom8aFbXv00FjzaRJZNLNO5zx85ROZpc=;
        b=iGvZ8sbmh/4SE7+kimL/hMSaYE6r3hTAUYMI1l1prKEWmHZwP4CZeYeMDyPAmsPta+
         FwQrQaLpCEo6tG39Unv35ph6rBzGZacRiXcEqCmPHZ34POlGCVRwXkasiqA5VzzdNPV/
         f5qVk911D4yMley6KUZFDJjQ6cx060O0k7yZUCE1N92qpg9B4dFQQRTWfJ2QbFMbLw0Z
         SlnJRYLQms27nZlMngnOuPBHq/QbijNdcbDeiYrQB4czAFqQoJ4OFtH1GB0MS8pdzYt1
         cKL12skDmYNcy+0+LVCfXrzsnHNaO5ihPHcwGflVoq5v4xOEvMeVXG730b9fWi6lxWX0
         sPhg==
In-Reply-To: <YZ5o/VmU59evp65J-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Nov 25, 2021 at 12:31 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Wed 24-11-21 15:19:15, Hao Lee wrote:
> > When several tasks are terminated simultaneously, lots of pages will be
> > released, which can cause severe spinlock contention. Other tasks which
> > are running on the same core will be seriously affected. We can yield
> > cpu to fix this problem.
>
> How does this actually address the problem? You are effectivelly losing
> fairness completely.

Got it. Thanks!

> We do batch currently so no single task should be
> able to monopolize the cpu for too long. Why this is not sufficient?

uncharge and unref indeed take advantage of the batch process, but
del_from_lru needs more time to complete. Several tasks will contend
spinlock in the loop if nr is very large. We can notice a transient peak
of sys% reflecting this, and perf can also report spinlock slowpath takes
too much time. This scenario is not rare, especially when containers are
destroyed simultaneously and other latency critical tasks may be affected
by this problem. So I want to figure out a way to deal with it.

Thanks.

>
> > diff --git a/mm/swap.c b/mm/swap.c
> > index e8c9dc6d0377..91850d51a5a5 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -960,8 +960,14 @@ void release_pages(struct page **pages, int nr)
> >               if (PageLRU(page)) {
> >                       struct lruvec *prev_lruvec = lruvec;
> >
> > -                     lruvec = folio_lruvec_relock_irqsave(folio, lruvec,
> > +retry:
> > +                     lruvec = folio_lruvec_tryrelock_irqsave(folio, lruvec,
> >                                                                       &flags);
> > +                     if (!lruvec) {
> > +                             cond_resched();
> > +                             goto retry;
> > +                     }
> > +
> >                       if (prev_lruvec != lruvec)
> >                               lock_batch = 0;
> >
> > --
> > 2.31.1
>
> --
> Michal Hocko
> SUSE Labs
