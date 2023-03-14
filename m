From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: page_cgroup_ino() get memcg from
 compound_head(page)
Date: Tue, 14 Mar 2023 11:02:00 +0100
Message-ID: <ZBBGGFi0U8r67S5E@dhcp22.suse.cz>
References: <20230313083452.1319968-1-yosryahmed@google.com>
 <20230313124431.fe901d79bc8c7dc96582539c@linux-foundation.org>
 <CAJD7tkZKhNRiWOrUOiHWuEQbOuDhjyHx0H01M1mQziM36viq9w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678788121; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F3V9UlH+4QbXycfDs9XgBP/KFr5npe8+4wtZALH2Ryk=;
        b=B3TInlRa76gpBNGGVaMXKohYJ3fSl3MCkousy1D+tQbxukirNV4Sn+na4/YlHcdfuET39l
        +J2Kxha6ZHC3/F3y9wVKku3J7WyiMVU7becgzjmeWbg0VbPS5slkDvMbNuoQxvwaOBSHQE
        FKX3z3cGHStkhPxrMFv3tLHl+8KmSvw=
Content-Disposition: inline
In-Reply-To: <CAJD7tkZKhNRiWOrUOiHWuEQbOuDhjyHx0H01M1mQziM36viq9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Naoya Horiguchi <naoya.horiguchi-YMj9X0ASwKA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 13-03-23 14:08:53, Yosry Ahmed wrote:
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

I would just stick with the existing code and put a comment that this
function shouldn't be used in any new code and the folio counterpart
should be used instead.

--=20
Michal Hocko
SUSE Labs
