From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v17 17/21] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 28 Jul 2020 07:54:01 -0700
Message-ID: <CAKgT0UdrQpa9OSusi=TZoj4RgC63-BNiF1GmeTG=rS47r7rGvQ@mail.gmail.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <1595681998-19193-18-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0UdaW4Rf43yULhQBuP07vQgmoPbaWHGKv1Z7fEPP6jH83w@mail.gmail.com> <ccd01046-451c-463d-7c5d-9c32794f4b1e@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rlXEKJ8xEIOgNHiN29J7TVPDIEGm7u8gbZy3u1s9Ctw=;
        b=t5IBgxDmqzCT6sfkH5/d8FUEdSDdI2dJz1S8qZ1ZiU+8a6LEYgoUdHC7V+GMiMw/5Y
         TVjf/4KKXxfObmWFzed1Ov64eHn8wDiSC4LJTQC1LV6suKmQw72Wnud2TRs6QafppeYq
         +RTfvgb55wEeFd2AOM4jJHQOkfgm44l0ROWwTVjPmaW4J3ZwHRF747lsegTE9kOxt2nc
         lG30esH922EGIPfNLuuuNh+56AJL4x1Zpi8P2J2tfhf/C2+Fpm+kBa9PXCpksfIPy6wv
         GezNC01nzIpMgnSJn9ve9dutdqJpKucoQxvvzUOJrLX4Sr1u7TwJZ78crHveaaYoHnBY
         ydWA==
In-Reply-To: <ccd01046-451c-463d-7c5d-9c32794f4b1e-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue, Jul 28, 2020 at 4:20 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote=
:
>
>
>
> =E5=9C=A8 2020/7/28 =E4=B8=8A=E5=8D=887:34, Alexander Duyck =E5=86=99=E9=
=81=93:
> >> @@ -1876,6 +1876,12 @@ static unsigned noinline_for_stack move_pages_t=
o_lru(struct lruvec *lruvec,
> >>                  *                                        list_add(&pa=
ge->lru,)
> >>                  *     list_add(&page->lru,) //corrupt
> >>                  */
> >> +               new_lruvec =3D mem_cgroup_page_lruvec(page, page_pgdat=
(page));
> >> +               if (new_lruvec !=3D lruvec) {
> >> +                       if (lruvec)
> >> +                               spin_unlock_irq(&lruvec->lru_lock);
> >> +                       lruvec =3D lock_page_lruvec_irq(page);
> >> +               }
> >>                 SetPageLRU(page);
> >>
> >>                 if (unlikely(put_page_testzero(page))) {
> > I was going through the code of the entire patch set and I noticed
> > these changes in move_pages_to_lru. What is the reason for adding the
> > new_lruvec logic? My understanding is that we are moving the pages to
> > the lruvec provided are we not?If so why do we need to add code to get
> > a new lruvec? The code itself seems to stand out from the rest of the
> > patch as it is introducing new code instead of replacing existing
> > locking code, and it doesn't match up with the description of what
> > this function is supposed to do since it changes the lruvec.
>
> this new_lruvec is the replacement of removed line, as following code:
> >> -               lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
> This recheck is for the page move the root memcg, otherwise it cause the =
bug:

Okay, now I see where the issue is. You moved this code so now it has
a different effect than it did before. You are relocking things before
you needed to. Don't forget that when you came into this function you
already had the lock. In addition the patch is broken as it currently
stands as you aren't using similar logic in the code just above this
addition if you encounter an evictable page. As a result this is
really difficult to review as there are subtle bugs here.

I suppose the correct fix is to get rid of this line, but  it should
be placed everywhere the original function was calling
spin_lock_irq().

In addition I would consider changing the arguments/documentation for
move_pages_to_lru. You aren't moving the pages to lruvec, so there is
probably no need to pass that as an argument. Instead I would pass
pgdat since that isn't going to be moving and is the only thing you
actually derive based on the original lruvec.
