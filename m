From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v16 00/22] per memcg lru_lock
Date: Sun, 19 Jul 2020 21:47:49 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2007192144150.1478@eggly.anvils>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com> <CAKgT0UcKVyTXQ=tGv_uMV+fSvoH_-cuG9zA_zhE+S8Ou11gt=w@mail.gmail.com> <57c619e7-da7e-198e-3de8-530bf19b9450@linux.alibaba.com> <alpine.LSU.2.11.2007190801490.3521@eggly.anvils>
 <5f2401d3-dd4f-cbc6-8cb4-4e92fc64998c@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1916823428-1595220486=:1478"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=6Nps254wO3Vku/AMs/COcTPJnAHzxFnu9/tet83Jczo=;
        b=Orx+a9RBBcSgVIEOHFVB374CoAHh0H+dcciHwze7bjd/evrRLoNHoEeHX6AUUXAWPE
         rlEZJuyYrLtfrbxBEr1f6tOk1hUCeuxitWVtbHQSm1gD5eBMeQnnQmiecOui/n+Wy+CH
         lVR+yKJxXOVRAwcOkkKdPQDX9l0WSRYT55r6M1O9qVGNeakNm5eWCBq/poyfEr+Mh+xO
         fvXDBer896r9lWpDPRKLzlOfw7HMuYx8YhXqqDQ9X/jiqcowwnnertv+u6tOMyTf4L6x
         VhxLTL6Tuzj5Wcb/bIoRfQ7SJeG3OQOLcWf9uL2ccqf9yxAULz7Zp0JITwEJl9p0MruI
         UiVg==
In-Reply-To: <5f2401d3-dd4f-cbc6-8cb4-4e92fc64998c-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1916823428-1595220486=:1478
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 20 Jul 2020, Alex Shi wrote:
> =E5=9C=A8 2020/7/19 =E4=B8=8B=E5=8D=8811:23, Hugh Dickins =E5=86=99=E9=81=
=93:
> > I noticed that 5.8-rc5, with lrulock v16 applied, took significantly
> > longer to run loads than without it applied, when there should have bee=
n
> > only slight differences in system time. Comparing /proc/vmstat, somethi=
ng
> > that stood out was "pgrotated 0" for the patched kernels, which led her=
e:
> >=20
> > If pagevec_lru_move_fn() is now to TestClearPageLRU (I have still not
> > decided whether that's good or not, but assume here that it is good),
> > then functions called though it must be changed not to expect PageLRU!
> >=20
> > Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>=20
> Good catch!
>=20
> Thanks a lot, Hugh!=20
> except 6 changes should apply, looks we add one more in swap.c file to st=
op
> !PageRLU further actions!

Agreed, that's a minor optimization that wasn't done before,
that can be added (but it's not a fix like the rest of them).

>=20
> Many Thanks!
> Alex
>=20
> @@ -649,7 +647,7 @@ void deactivate_file_page(struct page *page)
>          * In a workload with many unevictable page such as mprotect,
>          * unevictable page deactivation for accelerating reclaim is poin=
tless.
>          */
> -       if (PageUnevictable(page))
> +       if (PageUnevictable(page) || !PageLRU(page))
>                 return;
>=20
>         if (likely(get_page_unless_zero(page))) {
--0-1916823428-1595220486=:1478--
