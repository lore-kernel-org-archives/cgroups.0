From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: page_cgroup_ino() get memcg from compound_head(page)
Date: Tue, 14 Mar 2023 19:39:01 -0700
Message-ID: <CAJD7tkbs8p3rNgmGWFgBB4GCapKQP97Zc3chCsNZ43dAj4s0Qg@mail.gmail.com>
References: <20230313083452.1319968-1-yosryahmed@google.com>
 <20230313124431.fe901d79bc8c7dc96582539c@linux-foundation.org>
 <CAJD7tkZKhNRiWOrUOiHWuEQbOuDhjyHx0H01M1mQziM36viq9w@mail.gmail.com> <ZBEusOt3onLa30Hm@P9FQF9L96D>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678847977;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ljOVhU1fVs1xN3h4tM9mfHkMvJnrbFNvzgF16LNR3Vo=;
        b=PLcLfvxHZdYNgL8JlzYiaOCIP1jymITB2rVN9pw3Y87SePfPyZiOPkONKSLoMmo3S+
         FrxXNV+tT07Oo4sdulau0vk37m2vyy0mRe8ZdcS95goR63oHkQcTxPMxJQwR/2eCGLD6
         rHA5FbhPuzmSZxu0qsrV7Iw6F1UnY66DTLz3Ghjie1XGN5LiIRFSmuThuKIAnT7UhQfi
         nxapEjnpcx5XXl57JR6jDAImN1T51fj62Lfya4UhbTY9C8tW7/7XXgSQwbi5bAE6QTXK
         0Xtm0CtiMdKMAOAzyAqhy4VYPDXpOT8DbeYjVlfJslD3C2vJXFEY+VFREghp2oB8VtrN
         kZkg==
In-Reply-To: <ZBEusOt3onLa30Hm@P9FQF9L96D>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Naoya Horiguchi <naoya.horiguchi-YMj9X0ASwKA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Tue, Mar 14, 2023 at 7:34=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> On Mon, Mar 13, 2023 at 02:08:53PM -0700, Yosry Ahmed wrote:
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
> >
> > This makes it consistent with page_memcg(), and makes sure future
> > users are getting the "correct" memcg for whatever page they pass in.
> > I am interested to hear other folks' opinions here.
> >
> > The only other user today is print_page_owner_memcg(). I am not sure
> > if it's doing the right thing by explicitly reading page->memcg_data,
> > but it is already excluding pages that have page->memcg_data =3D=3D 0,
> > which should be the case for tail pages.
>
> Yeah, I think it's a good idea. I'd do this.
> If you'll master a patch like this, please, apply my
> Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> .

Thanks, Roman. So far there have been different opinions (specifically
Michal's), so I'll wait until the discussion settles before sending
another patch.

>
> I'm ok with the current approach too (the one you posted),
> but the one above is preferable.
>
> Overall it would be nice to clarify & document our expectations
> from /proc/kpagecgroup (and /proc/kpageflags & /proc/kpagecount)
> in the new folio "epoch".

Agreed, though I don't think I am the right person for this.


>
> Thanks!
