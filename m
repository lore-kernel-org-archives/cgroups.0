From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] mm: Drop locked from isolate_migratepages_block
Date: Thu, 13 Aug 2020 07:32:46 -0700
Message-ID: <CAKgT0UcRFqXUOJ+QjgtjdQE6A7EMgAc_v9b7+mXy-ZJLvG2AgQ@mail.gmail.com>
References: <20200813035100.13054.25671.stgit@localhost.localdomain>
 <20200813040224.13054.96724.stgit@localhost.localdomain> <8ea9e186-b223-fb1b-5c82-2aa43c5e9f10@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3t8eGrZXM10uYzb31bPcLIKkAbsLARz4dGnB5Cy2z60=;
        b=TWdedpVEAeL5F4lIHfRmXjcM2gOol8GetJGIbvGEfn2PzRRvGuQmT9qms8dyox4tBC
         TV4olmsqv+0yl4gwyaxhsyMADP4gykCx7w0DeuEAK0G0iKyTcxtK409+XnpWCKn77hM9
         fGLuSGnkag+rfc+u0KvKsUoGTz7XH2m7xDeTKGi6QXOlYKfSDhZe+K/6trEwSbHHWdGN
         on+Ef55218X7FivayasbemenUR1HH+CVbum0FuKSmuDOJ5sg5KBdBa3eiKWnW5DcE1FA
         Nqq/G/Qfu86pN4x96xifFsjaO08utj7p933Ow7bdiPB9+wF2p1BIdWkeFyTKPxrrVnkh
         3M3Q==
In-Reply-To: <8ea9e186-b223-fb1b-5c82-2aa43c5e9f10-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

On Wed, Aug 12, 2020 at 11:57 PM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrot=
e:
>
>
>
> =E5=9C=A8 2020/8/13 =E4=B8=8B=E5=8D=8812:02, Alexander Duyck =E5=86=99=E9=
=81=93:
> > From: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >
> > We can drop the need for the locked variable by making use of the
> > lruvec_holds_page_lru_lock function. By doing this we can avoid some rc=
u
> > locking ugliness for the case where the lruvec is still holding the LRU
> > lock associated with the page. Instead we can just use the lruvec and i=
f it
> > is NULL we assume the lock was released.
> >
> > Signed-off-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > ---
> >  mm/compaction.c |   45 ++++++++++++++++++++-------------------------
> >  1 file changed, 20 insertions(+), 25 deletions(-)
>
> Thanks a lot!
> Don't know if community is ok if we keep the patch following whole patchs=
et alone?

I am fine with you squashing it with another patch if you want. In
theory this could probably be squashed in with the earlier patch I
submitted that introduced lruvec_holds_page_lru_lock or some other
patch. It is mostly just a cleanup anyway as it gets us away from
needing to hold the RCU read lock in the case that we already have the
correct lruvec.
