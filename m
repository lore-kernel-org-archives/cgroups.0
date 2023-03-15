From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] memcg: page_cgroup_ino() get memcg from
 compound_head(page)
Date: Wed, 15 Mar 2023 04:54:31 +0000
Message-ID: <ZBFPh6j+4Khl1Je8@casper.infradead.org>
References: <20230313083452.1319968-1-yosryahmed@google.com>
 <20230313124431.fe901d79bc8c7dc96582539c@linux-foundation.org>
 <CAJD7tkZKhNRiWOrUOiHWuEQbOuDhjyHx0H01M1mQziM36viq9w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=+5eAySqKu8quKYezY1WSwvPjQogNyS4CVabFURW422s=; b=UWGc5iC75MwzhUe32/obZHoEYG
        9HjdVRVyOT+5NNcsHuT4FIPSntudhDB+Hgm6nvg3LhHaV6+X/rY0guINYcagEHA+zoOv3XH2qHZz9
        LbyQhGU+JajvQR9XMZcIpjljLyVBelZ9bFku4mgr0ZuPjIrTQ9yWFJBFp7sJ5aM5DjqfU//miQHgN
        4ocintfUcutJkUpO4tA/63ctHJK09HPIxI8yc1uClbZx6j9x5L1Tn+7bS9w8NIW5u8MYMU0bMNeeH
        vpLBwN4QDES2yrycumMTX+yG7sWHV1ffrOAsXryr1kYMDPKEom0KAGk845XZhgiliAum9WYD/DM9R
        cfNTeG5A==;
Content-Disposition: inline
In-Reply-To: <CAJD7tkZKhNRiWOrUOiHWuEQbOuDhjyHx0H01M1mQziM36viq9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Naoya Horiguchi <naoya.horiguchi-YMj9X0ASwKA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Mar 13, 2023 at 02:08:53PM -0700, Yosry Ahmed wrote:
> On Mon, Mar 13, 2023 at 12:44=E2=80=AFPM Andrew Morton
> <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> >
> > On Mon, 13 Mar 2023 08:34:52 +0000 Yosry Ahmed <yosryahmed-hpIqsD4AKlfQ=
T0dZR+AlfA@public.gmane.org> wrote:
> >
> > > From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > >
> > > In a kernel with added WARN_ON_ONCE(PageTail) in page_memcg_check(), =
we
> > > observed a warning from page_cgroup_ino() when reading
> > > /proc/kpagecgroup.
> >
> > If this is the only known situation in which page_memcg_check() is
> > passed a tail page, why does page_memcg_check() have
> >
> >         if (PageTail(page))
> >                 return NULL;
> >
> > ?  Can we remove this to simplify, streamline and clarify?
>=20
> I guess it's a safety check so that we don't end up trying to cast a
> tail page to a folio. My opinion is to go one step further and change
> page_memcg_check() to do return the memcg of the head page, i.e:
>=20
> static inline struct mem_cgroup *page_memcg_check(struct page *page)
> {
>     return folio_memcg_check(page_folio(page));
> }

If you look at my commit becacb04fdd4, I was preserving the existing
behaviour of page_memcg_check() when passed a tail page.  It would
previously, rightly or wrongly, read the memcg_data from the tail page
and get back NULL.

I suspect that was not the intended behaviour, but I do not think this
patch is the right fix; it simply papers over the problem and maybe
creates a new one.  Callers of page_memcg_check() should be eliminated,
precisely because of this ambiguity.  It's up to the people who understand
each of the callers who need to make the decision to always convert the
page that they have to a folio and ask about its memcg, or whether they
want to preserve the existing behaviour of returning NULL for tail pages.

So, I say NACK to this patch as it does not preserve existing behaviour,
and does not advance our understanding of what we have wrought.
