From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v17 14/21] mm/compaction: do page isolation first in compaction
Date: Tue, 11 Aug 2020 07:47:17 -0700
Message-ID: <CAKgT0Ues0ShkSbb1XtA7z7EYB8NCPgLGq8zZUjrXK_jcWn8mDQ@mail.gmail.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <1595681998-19193-15-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0UcbBv=QBK9ErqLKXoNLYxFz52L4fiiHy4h6zKdBs=YPOg@mail.gmail.com>
 <241ca157-104f-4f0d-7d5b-de394443788d@linux.alibaba.com> <CAKgT0UdSrarC8j+G=LYRSadcaG6yNCoCfeVpFjEiHRJb4A77-g@mail.gmail.com>
 <8dbd004e-8eba-f1ec-a5eb-5dc551978936@linux.alibaba.com> <CAKgT0UdK-fy+yYGLFK=YgE+maa_0_uecq0_8S_0kM8BiVgRO7g@mail.gmail.com>
 <d9818e06-95f1-9f21-05c0-98f29ea96d89@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IIIvYG8OQy5SVNgWTuGukxssojF/486+mb+O9w4PDtk=;
        b=NaqAX3wl28TbdvrAD3AZ4ERIShK39VkxBdJD3bYWJhcwPuA0miqXrpuX9zpra5mCRQ
         6dJtc1UcwKVyOq/vXdP05jlWyD9ube6IdAo7U6JTiMzGfpY5C4nsErPey/JuUTR2nQAD
         VTd8JBLugvUKNsoowNbdcp5QOa8bPwLso3lPkA24WuBMLsvEnQsnUQYS4I3P6L/5MPoF
         2cSpkUTxbrqDMfHpS5s2yUKLU/LTol+uvFWNMyD0hq8SUPx9G+xyebl5S7pp6tZ3Y2zT
         hMktOb9KRF9JYdfNQHSI1H896WUX3zNRoqWzJjQwpdBLnneIV5yJ2lF0XzsG77n6eMYq
         Z4zg==
In-Reply-To: <d9818e06-95f1-9f21-05c0-98f29ea96d89-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Tue, Aug 11, 2020 at 1:23 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote=
:
>
>
>
> =E5=9C=A8 2020/8/10 =E4=B8=8B=E5=8D=8810:41, Alexander Duyck =E5=86=99=E9=
=81=93:
> > On Mon, Aug 10, 2020 at 6:10 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> w=
rote:
> >>
> >>
> >>
> >> =E5=9C=A8 2020/8/7 =E4=B8=8B=E5=8D=8810:51, Alexander Duyck =E5=86=99=
=E9=81=93:
> >>> I wonder if this entire section shouldn't be restructured. This is th=
e
> >>> only spot I can see where we are resetting the LRU flag instead of
> >>> pulling the page from the LRU list with the lock held. Looking over
> >>> the code it seems like something like that should be possible. I am
> >>> not sure the LRU lock is really protecting us in either the
> >>> PageCompound check nor the skip bits. It seems like holding a
> >>> reference on the page should prevent it from switching between
> >>> compound or not, and the skip bits are per pageblock with the LRU bit=
s
> >>> being per node/memcg which I would think implies that we could have
> >>> multiple LRU locks that could apply to a single skip bit.
> >>
> >> Hi Alexander,
> >>
> >> I don't find problem yet on compound or skip bit usage. Would you clar=
ify the
> >> issue do you concerned?
> >>
> >> Thanks!
> >
> > The point I was getting at is that the LRU lock is being used to
> > protect these and with your changes I don't think that makes sense
> > anymore.
> >
> > The skip bits are per-pageblock bits. With your change the LRU lock is
> > now per memcg first and then per node. As such I do not believe it
> > really provides any sort of exclusive access to the skip bits. I still
> > have to look into this more, but it seems like you need a lock per
> > either section or zone that can be used to protect those bits and deal
> > with this sooner rather than waiting until you have found an LRU page.
> > The one part that is confusing though is that the definition of the
> > skip bits seems to call out that they are a hint since they are not
> > protected by a lock, but that is exactly what has been happening here.
> >
>
> The skip bits are safe here, since even it race with other skip action,
> It will still skip out. The skip action is try not to compaction too much=
,
> not a exclusive action needs avoid race.

That would be the case if it didn't have the impact that they
currently do on the compaction process. What I am getting at is that a
race was introduced when you placed this test between the clearing of
the LRU flag and the actual pulling of the page from the LRU list. So
if you tested the skip bits before clearing the LRU flag then I would
be okay with the code, however because it is triggering an abort after
the LRU flag is cleared then you are creating a situation where
multiple processes will be stomping all over each other as you can
have each thread essentially take a page via the LRU flag, but only
one thread will process a page and it could skip over all other pages
that preemptively had their LRU flag cleared.

If you take a look at the test_and_set_skip the function only acts on
the pageblock aligned PFN for a given range. WIth the changes you have
in place now that would mean that only one thread would ever actually
call this function anyway since the first PFN would take the LRU flag
so no other thread could follow through and test or set the bit as
well. The expectation before was that all threads would encounter this
test and either proceed after setting the bit for the first PFN or
abort after testing the first PFN. With you changes only the first
thread actually runs this test and then it and the others will likely
encounter multiple failures as they are all clearing LRU bits
simultaneously and tripping each other up. That is why the skip bit
must have a test and set done before you even get to the point of
clearing the LRU flag.

> > The point I was getting at with the PageCompound check is that instead
> > of needing the LRU lock you should be able to look at PageCompound as
> > soon as you call get_page_unless_zero() and preempt the need to set
> > the LRU bit again. Instead of trying to rely on the LRU lock to
> > guarantee that the page hasn't been merged you could just rely on the
> > fact that you are holding a reference to it so it isn't going to
> > switch between being compound or order 0 since it cannot be freed. It
> > spoils the idea I originally had of combining the logic for
> > get_page_unless_zero and TestClearPageLRU into a single function, but
> > the advantage is you aren't clearing the LRU flag unless you are
> > actually going to pull the page from the LRU list.
>
> Sorry, I still can not follow you here. Compound code part is unchanged
> and follow the original logical. So would you like to pose a new code to
> see if its works?

No there are significant changes as you reordered all of the
operations. Prior to your change the LRU bit was checked, but not
cleared before testing for PageCompound. Now you are clearing it
before you are testing if it is a compound page. So if compaction is
running we will be seeing the pages in the LRU stay put, but the
compound bit flickering off and on if the compound page is encountered
with the wrong or NULL lruvec. What I was suggesting is that the
PageCompound test probably doesn't need to be concerned with the lock
after your changes. You could test it after you call
get_page_unless_zero() and before you call
__isolate_lru_page_prepare(). Instead of relying on the LRU lock to
protect us from the page switching between compound and not we would
be relying on the fact that we are holding a reference to the page so
it should not be freed and transition between compound or not.
