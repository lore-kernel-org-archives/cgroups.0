From: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: reduce spinlock contention in release_pages()
Date: Thu, 25 Nov 2021 11:13:54 +0800
Message-ID: <CA+PpKPm4nfFM1XNifQoQT6Q_f3hQ6gSNnCgUumLDnruaLaUgvQ@mail.gmail.com>
References: <20211124151915.GA6163@haolee.io> <YZ5hBtWPBpHDWzE4@casper.infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LUJ2xL+Px+DOun+h5cyap9d/dwV4T1osfNsX5aVR3pw=;
        b=nDcBW1cRvwI3INDB/78zeUB31/ODkKV5AQk+Mv9y1EzYqq4NByJ2IuLdxSnJvIVwPR
         PPYZJ5f1JTGOlao2bfW/eExJuS02Do+tl2cpuuBbw9gy6QL6HQj1NLFJ51enf9mhG5KN
         X5f8/n2GVyfST9jajOklGweUJG2VNBiPWjxZW47TPHj6mvwOlwceHiBAaTFp1vWa3xGq
         oI4Iwq/XBps2Q4wSsH6nfi6dsta5cktP1DweFQ2XPn329xrU0sR5CAEi1J4UQrrQ3q2i
         TOS6SHWMslVeZWSAf+qsnzpFZm2+/AJsoTqe43/Ryyta71lv7BjIFkHXJvdC/CBf/mpJ
         FbSA==
In-Reply-To: <YZ5hBtWPBpHDWzE4-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Nov 24, 2021 at 11:58 PM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Wed, Nov 24, 2021 at 03:19:15PM +0000, Hao Lee wrote:
> > When several tasks are terminated simultaneously, lots of pages will be
> > released, which can cause severe spinlock contention. Other tasks which
> > are running on the same core will be seriously affected. We can yield
> > cpu to fix this problem.
>
> The realtime people will eat you alive for this suggestion.

Thanks for pointing out this.

>
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
