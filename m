From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: page_cgroup_ino() get memcg from compound_head(page)
Date: Wed, 15 Mar 2023 20:16:53 -0700
Message-ID: <CAJD7tkZ_RuZFpJd2raK_y6CxwGMa7uo1QXxO7Od5iORZH8ixpw@mail.gmail.com>
References: <20230313083452.1319968-1-yosryahmed@google.com>
 <20230313124431.fe901d79bc8c7dc96582539c@linux-foundation.org>
 <CAJD7tkZKhNRiWOrUOiHWuEQbOuDhjyHx0H01M1mQziM36viq9w@mail.gmail.com>
 <ZBFPh6j+4Khl1Je8@casper.infradead.org> <CAJD7tkYFjRPq6ATj-d0P25FhDaMzKdXfqTa_hh7TZp_Xyt4v+w@mail.gmail.com>
 <ZBG3xzGd6j+uByyN@casper.infradead.org> <CAJD7tkbcTMo1oZAa0Pa3v_6d0n4bHCo+8vTxzXGU6UBVOhrUQw@mail.gmail.com>
 <8d4e1b74-6ae8-4243-d5c2-e63e8046d355@redhat.com> <CAJD7tkbNtJHse5BH=FzgRGUW=oLLoORb7yb8xqUFhF097zDLyg@mail.gmail.com>
 <ZBKH3xT3FesWeX2c@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678936650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YXNzovKLJVYy7gSWnrkduiiESPL+tnprAmERLJ9c4NY=;
        b=NRQD09/EkrkQfR7xQtFTEI9QJBiVxyflHtJW6z/y+NzHFWpQ8JaVK7xtttKCq7oNhY
         EhHdshdjxrDhdmDM32NOVhSuY5bTEeIo8qvtE6jUhidqSflnT32TvtkRVaXr4Uk6MnIi
         rx2KxeyAviXttBTLasD9xRHAKqCf1ZwnCTBg6yyDGtdlgO/qtgJfXLBVkOCgodk/4aTB
         L1L2+RRrS39zqUklhKnr7rxuTgnpdd+PW/l0td+cnb01CSRMWANJiC8flZDrXr1df7GZ
         AQnv7g6xchDTwjjZrZ7iX6E7rq0Xhi6Ac3KFGNgH2yXFoJPVX+mfcEl7E/7kqpCUBqp0
         e//A==
In-Reply-To: <ZBKH3xT3FesWeX2c-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Naoya Horiguchi <naoya.horiguchi-YMj9X0ASwKA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 15, 2023 at 8:07=E2=80=AFPM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org=
> wrote:
>
> On Wed, Mar 15, 2023 at 05:25:49PM -0700, Yosry Ahmed wrote:
> [snipped 80 lines.  please learn to trim]
> > I think instead of explicitly checking page->memcg_data, we can check
> > PageTail() and return explicitly for tail pages tails, check
> > PageSlab() to print the message for slab pages, then get the page's
> > memcg through folio_memcg_check(page_folio(page)).
> >
> > Something like:
> >
> > static inline int print_page_owner_memcg(char *kbuf, size_t count, int =
ret,
> > struct page *page)
> > {
> >     ...
> >     rcu_read_lock();
> >
> >     /* Only head pages hold refs to a memcg */
> >     if (PageTail(page))
> >         goto out_unlock;
> >
> >     if (PageSlab(page))
> >         ret +=3D scnprintf(kbuf + ret, count - ret, "Slab cache page\n"=
);
> >
> >     memcg =3D folio_memcg_check(page_folio(page));
> >     if (!memcg)
> >         goto out_unlock;
> >     ...
> > }
> >
> > Matthew, What do you think?
>
> Brrr, this is hard.  read_page_owner() holds no locks or references,
> so pages can transform between being head/tail/order-0 while we're
> running.
>
> It _tries_ to skip over tail pages in the most inefficient way possible:
>
>                 if (!IS_ALIGNED(pfn, 1 << page_owner->order))
>                         goto ext_put_continue;
>
> But any attempt to use folio APIs is going to risk tripping the
> assertions in the folio code that it's not a tail.  This requires
> more thought.

Ugh yeah. I thought the worst that could happen is that if a page
becomes a tail page after the PageTail() check, then we will not skip
it and we will read the memcg from the head instead, which shouldn't
be the end of the world. I missed the fact that the folio returned by
page_folio() can change before folio_memcg_check() gets to read its
memcg_data.

I guess this race exists with the current implementation as well.
page_memcg_check() will check for tail pages then cast the page to a
folio. If the page becomes a tail page after the PageTail() check
inside page_memcg_check() we risk running into the same situation.

(FWIW folio_memcg_check() doesn't seem to have assertions for tail pages to=
day)
