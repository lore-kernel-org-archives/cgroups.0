From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] memcg: page_cgroup_ino() get memcg from
 compound_head(page)
Date: Wed, 15 Mar 2023 12:19:19 +0000
Message-ID: <ZBG3xzGd6j+uByyN@casper.infradead.org>
References: <20230313083452.1319968-1-yosryahmed@google.com>
 <20230313124431.fe901d79bc8c7dc96582539c@linux-foundation.org>
 <CAJD7tkZKhNRiWOrUOiHWuEQbOuDhjyHx0H01M1mQziM36viq9w@mail.gmail.com>
 <ZBFPh6j+4Khl1Je8@casper.infradead.org>
 <CAJD7tkYFjRPq6ATj-d0P25FhDaMzKdXfqTa_hh7TZp_Xyt4v+w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=YEHaS1jbcFt6XFTHtzvHwBBDGnKA7GP1NQZcvCyxIVc=; b=ibZv7O8AfRIpW1okpk0auST6ju
        QGUQE09QAEhtE72dYe30m3Dx/TOe/gWHxKNlcCcZ9+EUAiQ2s+8VPtKAkZlSmetzcOHPSTNtoV5vA
        ZyUgKojS86wmMbFQw0TSsvCFRTsuh9xBIQmKbJcHkSRfozwqbyLbIBPkV3NyIaHQM55O98xXphp1a
        zWzRoqY9juw8uxfElduAWBKt7cU6+xxk17aQQeXoLIsR4ElNNMLqtkx9VbmHi8G67IY1jSHrSgg0Y
        +mD2lwCmLX5Xms/qJDQg6vHlcKDWhlRph2sAKiurG5rDNTp7J4rUQRu4llhEaK6aiKd82vJa78t8T
        Q550uQfA==;
Content-Disposition: inline
In-Reply-To: <CAJD7tkYFjRPq6ATj-d0P25FhDaMzKdXfqTa_hh7TZp_Xyt4v+w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Naoya Horiguchi <naoya.horiguchi-YMj9X0ASwKA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 15, 2023 at 12:04:10AM -0700, Yosry Ahmed wrote:
> On Tue, Mar 14, 2023 at 9:54 PM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> >
> > On Mon, Mar 13, 2023 at 02:08:53PM -0700, Yosry Ahmed wrote:
> > > On Mon, Mar 13, 2023 at 12:44 PM Andrew Morton
> > > <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > > >
> > > > On Mon, 13 Mar 2023 08:34:52 +0000 Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > >
> > > > > From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > >
> > > > > In a kernel with added WARN_ON_ONCE(PageTail) in page_memcg_check(), we
> > > > > observed a warning from page_cgroup_ino() when reading
> > > > > /proc/kpagecgroup.
> > > >
> > > > If this is the only known situation in which page_memcg_check() is
> > > > passed a tail page, why does page_memcg_check() have
> > > >
> > > >         if (PageTail(page))
> > > >                 return NULL;
> > > >
> > > > ?  Can we remove this to simplify, streamline and clarify?
> > >
> > > I guess it's a safety check so that we don't end up trying to cast a
> > > tail page to a folio. My opinion is to go one step further and change
> > > page_memcg_check() to do return the memcg of the head page, i.e:
> > >
> > > static inline struct mem_cgroup *page_memcg_check(struct page *page)
> > > {
> > >     return folio_memcg_check(page_folio(page));
> > > }
> >
> > If you look at my commit becacb04fdd4, I was preserving the existing
> > behaviour of page_memcg_check() when passed a tail page.  It would
> > previously, rightly or wrongly, read the memcg_data from the tail page
> > and get back NULL.
> 
> Right, I looked at that. I also looked at 1b7e4464d43a which added
> folio_memcg() and changed page_memcg()'s behavior to use page_folio()
> to retrieve the memcg from the head, which made me wonder why
> different decisions were made for these 2 helpers.
> 
> Were the users of page_memcg() already passing in head pages only?

There were 18 months between those commits ... I'd learned to be
more careful about maintaining the semantics instead of changing
them to "what they should have been".

> >
> > I suspect that was not the intended behaviour, but I do not think this
> > patch is the right fix; it simply papers over the problem and maybe
> > creates a new one.  Callers of page_memcg_check() should be eliminated,
> > precisely because of this ambiguity.  It's up to the people who understand
> > each of the callers who need to make the decision to always convert the
> > page that they have to a folio and ask about its memcg, or whether they
> > want to preserve the existing behaviour of returning NULL for tail pages.
> >
> > So, I say NACK to this patch as it does not preserve existing behaviour,
> > and does not advance our understanding of what we have wrought.
> 
> I am not sure which patch you are NACKing, the original patch from
> Hugh (adding compound_head() to page_cgroup_ino()) or the suggested
> alternative patch which changes page_memcg_check() to use
> page_folio().

Both patches are NACKed.  page_memcg_check() needs to go away
because it has the tail page ambiguity.  Both callers should be using
folio_memcg_check() directly and resolving for themselves what the
correct behaviour is when seeing a tail page.

