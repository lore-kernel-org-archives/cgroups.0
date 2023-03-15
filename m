From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: page_cgroup_ino() get memcg from compound_head(page)
Date: Tue, 14 Mar 2023 20:10:54 -0700
Message-ID: <CAJD7tkYm25ohS_P1Q6mzZMHJp4Hjwr3LqLaiPA3NFpa1gfOdJw@mail.gmail.com>
References: <20230313083452.1319968-1-yosryahmed@google.com>
 <20230313124431.fe901d79bc8c7dc96582539c@linux-foundation.org>
 <CAJD7tkZKhNRiWOrUOiHWuEQbOuDhjyHx0H01M1mQziM36viq9w@mail.gmail.com> <61e8e6d3-697e-f9a5-a1fb-45a3448ee5db@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678849891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YXqCKGMyW/C+0Hogx41I4dQn/i/iOzKSbxMPqIV3gX0=;
        b=gvJCiPYbBgWxA/3y98DWHdOpJYKUc0mYgM4igQE4cMa+S1vjhhHBTFcV3pd3erEvNX
         o9tufmTIVgzVU4Zc9pbYdrPnCy7vstq4ZMLRRzjPCFFenh/sJlNtSc7XITQUGrjSp+dD
         OIdhh+SFVgd8DT2bpIBTp7WaL8V2svJCYwVW2x492qCSsxGu8Llgr3OBGCEbpx4PMPA/
         Ai2jMvvMwqW+sy+LdMt8lseB2EVAYv4YeN3QAgTFEQYa7a4U64tSzPo9xvhX5uO7IBFJ
         4oKB9rGM9KM7U9TG6BtcDrqQCcJeGyLioy4i1JAMcFm2211dRy+TaJPMauys4R9mV1Nr
         EA9w==
In-Reply-To: <61e8e6d3-697e-f9a5-a1fb-45a3448ee5db-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Naoya Horiguchi <naoya.horiguchi-YMj9X0ASwKA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Tue, Mar 14, 2023 at 8:07=E2=80=AFPM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>
> On 3/13/23 17:08, Yosry Ahmed wrote:
> > On Mon, Mar 13, 2023 at 12:44=E2=80=AFPM Andrew Morton
> > <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> >> On Mon, 13 Mar 2023 08:34:52 +0000 Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>=
 wrote:
> >>
> >>> From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >>>
> >>> In a kernel with added WARN_ON_ONCE(PageTail) in page_memcg_check(), =
we
> >>> observed a warning from page_cgroup_ino() when reading
> >>> /proc/kpagecgroup.
> >> If this is the only known situation in which page_memcg_check() is
> >> passed a tail page, why does page_memcg_check() have
> >>
> >>          if (PageTail(page))
> >>                  return NULL;
> >>
> >> ?  Can we remove this to simplify, streamline and clarify?
> > I guess it's a safety check so that we don't end up trying to cast a
> > tail page to a folio. My opinion is to go one step further and change
> > page_memcg_check() to do return the memcg of the head page, i.e:
> >
> > static inline struct mem_cgroup *page_memcg_check(struct page *page)
> > {
> >      return folio_memcg_check(page_folio(page));
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
> It is reading memcg_data directly to see if it is slab cache page. It is
> currently skipping page that does not have memcg_data set.

IIUC this skips tail pages, because they should always have
page->memcg_data =3D=3D 0, even if they are charged to a memcg. To
correctly get their memcg we should read it from the
compound_head()/page_folio().

My 2c, we can check PageSlab() to print the extra message for slab
pages, instead of reading memcg_data directly, which kinda breaks the
abstraction created by the various helpers for reading a page memcg.
Someone can easily change something in how memcg_data is interpreted
in those helpers without realizing that page_owner is also reading it.

>
> Cheers,
> Longman
>
