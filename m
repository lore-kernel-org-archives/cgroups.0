From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: page_cgroup_ino() get memcg from compound_head(page)
Date: Tue, 14 Mar 2023 12:45:23 -0700
Message-ID: <CAJD7tkbaDeRP6-WuRGuRdhnOSV26=G_jhqMnejHQFGiT8VZ0bw@mail.gmail.com>
References: <20230313083452.1319968-1-yosryahmed@google.com>
 <20230313124431.fe901d79bc8c7dc96582539c@linux-foundation.org>
 <CAJD7tkZKhNRiWOrUOiHWuEQbOuDhjyHx0H01M1mQziM36viq9w@mail.gmail.com> <ZBBGGFi0U8r67S5E@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678823160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+daTM6MAyn6TGH4bluRXORo6ZRCtPzEVsAVbOVoNzA8=;
        b=iqwXKiXBy/QmLohV8HdYfz7gN2eG08oii+mneuEAyxsmZrR1k3jmF+kUW+T6HVqf/t
         bsN0+OnhObLIyRQq59ne3Q84xTZcsUOKfu5bRL9L9FD2y/g0qFB2Upm8ivyj+VEnX80x
         3uCifVPKxb6hLEhq1Xg9/pc3awcooXRyJyI8UQAS9sNvaNXB6BBcJvLk1YgEBgyutUo9
         XDtCFlh8sjPUnCJCdgie4OqkORdNfqth0Qet3qysMs2GmtT2XdjUu5sLdVhJjJZP1y2n
         9wR90TB+QxK3kC08InHtuwnES6bZI0AhCoIB6dWzCrx65fXI8OvbYSaS+Vq4cePFBaAR
         VpVw==
In-Reply-To: <ZBBGGFi0U8r67S5E-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Naoya Horiguchi <naoya.horiguchi-YMj9X0ASwKA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 14, 2023 at 3:02=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrot=
e:
>
> On Mon 13-03-23 14:08:53, Yosry Ahmed wrote:
> > On Mon, Mar 13, 2023 at 12:44=E2=80=AFPM Andrew Morton
> > <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > >
> > > On Mon, 13 Mar 2023 08:34:52 +0000 Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
> wrote:
> > >
> > > > From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > >
> > > > In a kernel with added WARN_ON_ONCE(PageTail) in page_memcg_check()=
, we
> > > > observed a warning from page_cgroup_ino() when reading
> > > > /proc/kpagecgroup.
> > >
> > > If this is the only known situation in which page_memcg_check() is
> > > passed a tail page, why does page_memcg_check() have
> > >
> > >         if (PageTail(page))
> > >                 return NULL;
> > >
> > > ?  Can we remove this to simplify, streamline and clarify?
> >
> > I guess it's a safety check so that we don't end up trying to cast a
> > tail page to a folio. My opinion is to go one step further and change
> > page_memcg_check() to do return the memcg of the head page, i.e:
> >
> > static inline struct mem_cgroup *page_memcg_check(struct page *page)
> > {
> >     return folio_memcg_check(page_folio(page));
> > }
>
> I would just stick with the existing code and put a comment that this
> function shouldn't be used in any new code and the folio counterpart
> should be used instead.

Would you mind explaining the rationale?

If existing users are not passing in tail pages and we are telling new
users not to use it, what's the point of leaving the PageTail() check?

Is page owner doing the right thing by discounting pages with
page->memcg_data =3D 0 in print_page_owner_memcg() ? Wouldn't this not
show the memcg of tail pages?

If page owner also needs a compound_head()/ page_folio() call before
checking the page memcg, perhaps we should convert both call sites to
page_memcg_check() to folio_memcg_check() and remove it now?

>
> --
> Michal Hocko
> SUSE Labs
