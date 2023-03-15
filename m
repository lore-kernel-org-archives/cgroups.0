From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: page_cgroup_ino() get memcg from compound_head(page)
Date: Tue, 14 Mar 2023 20:40:46 -0700
Message-ID: <CAJD7tkaFdi4gb9Y-SZGxmwCM1ev2JZ_A2h_b_asnpDH4jYPYPQ@mail.gmail.com>
References: <20230313083452.1319968-1-yosryahmed@google.com>
 <20230313124431.fe901d79bc8c7dc96582539c@linux-foundation.org>
 <CAJD7tkZKhNRiWOrUOiHWuEQbOuDhjyHx0H01M1mQziM36viq9w@mail.gmail.com>
 <61e8e6d3-697e-f9a5-a1fb-45a3448ee5db@redhat.com> <CAJD7tkYm25ohS_P1Q6mzZMHJp4Hjwr3LqLaiPA3NFpa1gfOdJw@mail.gmail.com>
 <84d8fd38-f05c-73f5-ef50-fcac524097f3@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678851683;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HqjNzfEl6/soQ303j8VicjxqLu+8Pdbe2K2IwqybTZ4=;
        b=iSEoWq8zG/XKNq2+fbe3RXpE91OOk3YVSEIyPM9ABQM4pahRYJI1NL5J/hoZgboRLw
         hGhGQ3Y/QRowLilPx+6Fi+usDRlxoH51Be9IiwN8Dkjk3xJTZ0VQ6zYyGff/FbyWRiYd
         9FoM7TjRgazH8K2U7SloDG4bIphe+Cx6Z1Y1rPZz3DQL0b0U79QAwbOkP1T4Vx9+7H0e
         PHrx2lp5Ks7Hv3AVICtUx/K1/gE6hfODeDrCe2+Dyn+mG4Y07GO0AeuQ4oW8ptay+pXK
         DPSjPdAWw40PkNKCdbyojegoUrV2sZJ6Ezuvgi4CDvEVfsMncfzHDbxCJQ0Y7LJwdUhm
         TW+Q==
In-Reply-To: <84d8fd38-f05c-73f5-ef50-fcac524097f3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Naoya Horiguchi <naoya.horiguchi-YMj9X0ASwKA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Tue, Mar 14, 2023 at 8:33=E2=80=AFPM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>
> On 3/14/23 23:10, Yosry Ahmed wrote:
> >>> The only other user today is print_page_owner_memcg(). I am not sure
> >>> if it's doing the right thing by explicitly reading page->memcg_data,
> >>> but it is already excluding pages that have page->memcg_data =3D=3D 0=
,
> >>> which should be the case for tail pages.
> >> It is reading memcg_data directly to see if it is slab cache page. It =
is
> >> currently skipping page that does not have memcg_data set.
> > IIUC this skips tail pages, because they should always have
> > page->memcg_data =3D=3D 0, even if they are charged to a memcg. To
> > correctly get their memcg we should read it from the
> > compound_head()/page_folio().
> The purpose of that function is mainly to report pages that have a
> reference to a memcg, especially the dead one. So by counting the
> occurrence of a particular cgroup name, we can have a rough idea of
> that. So only head page has relevance here and we can skip the tail pages=
.

I see. If you update the code to not check memcg_data directly, and we
update page_memcg_check() to return memcg of the head page, this will
stop skipping tail pages. Is this okay?

If not, we can explicitly skip tail pages in print_page_owner_memcg()
if we decide to check the head's memcg in page_memcg_check().

> >
> > My 2c, we can check PageSlab() to print the extra message for slab
> > pages, instead of reading memcg_data directly, which kinda breaks the
> > abstraction created by the various helpers for reading a page memcg.
> > Someone can easily change something in how memcg_data is interpreted
> > in those helpers without realizing that page_owner is also reading it.
>
> You are right. We should be using a helper if available. I will send a
> patch to fix that.

Great, thanks!

>
> Thanks,
> Longman
>
