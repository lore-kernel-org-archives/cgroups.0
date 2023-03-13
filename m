From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: page_cgroup_ino() get memcg from compound_head(page)
Date: Mon, 13 Mar 2023 14:08:53 -0700
Message-ID: <CAJD7tkZKhNRiWOrUOiHWuEQbOuDhjyHx0H01M1mQziM36viq9w@mail.gmail.com>
References: <20230313083452.1319968-1-yosryahmed@google.com> <20230313124431.fe901d79bc8c7dc96582539c@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678741770;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IlBkJK/x7/8YyJiF20jdzTRn8hgNL0nBlwjb2kxzy2s=;
        b=L4JWVhvyZWCF4cgwpgIXArKcdLYPq0qd5QJjDzWuDe23O+CD4GTBk6scii3kW10Yt8
         6Ws9/hqGin1e/JljVTjGAaWBsZxk4MKzMxc+9OsHYOg3Iqpl7L9l7/th2+71fabvxtyi
         wJjHNVwEQiVzqxQlKqhk1FFubtpxnhsg7HgInTzGDXHABpYRmkf5NSmu7EAaGMt7fD3o
         PE0s1zWoezTpC79MyfRjjkec/fBpG1Bv0meCD1hVkI1BEnmJC0vmGMdr3k13NY7SWPpf
         /qJ0B+jUpyx6EG0BUMy04FA3G/LMMq7UuDD5+QZH9klqx5U5pnafS0FlHOw/hl6Q5N9m
         4bSw==
In-Reply-To: <20230313124431.fe901d79bc8c7dc96582539c-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Naoya Horiguchi <naoya.horiguchi-YMj9X0ASwKA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Mar 13, 2023 at 12:44=E2=80=AFPM Andrew Morton
<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> On Mon, 13 Mar 2023 08:34:52 +0000 Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wr=
ote:
>
> > From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > In a kernel with added WARN_ON_ONCE(PageTail) in page_memcg_check(), we
> > observed a warning from page_cgroup_ino() when reading
> > /proc/kpagecgroup.
>
> If this is the only known situation in which page_memcg_check() is
> passed a tail page, why does page_memcg_check() have
>
>         if (PageTail(page))
>                 return NULL;
>
> ?  Can we remove this to simplify, streamline and clarify?

I guess it's a safety check so that we don't end up trying to cast a
tail page to a folio. My opinion is to go one step further and change
page_memcg_check() to do return the memcg of the head page, i.e:

static inline struct mem_cgroup *page_memcg_check(struct page *page)
{
    return folio_memcg_check(page_folio(page));
}

This makes it consistent with page_memcg(), and makes sure future
users are getting the "correct" memcg for whatever page they pass in.
I am interested to hear other folks' opinions here.

The only other user today is print_page_owner_memcg(). I am not sure
if it's doing the right thing by explicitly reading page->memcg_data,
but it is already excluding pages that have page->memcg_data =3D=3D 0,
which should be the case for tail pages.

>
>
